require 'htslib'
require 'glimmer-dsl-libui'

class HTSGrid
  include Glimmer
  Aln = Struct.new(:qname, :flag, :rname, :pos, :mapq, :cigar, :rnext, :pnext, :tlen, :seq, :qual)

  def initialize
    @fpath = File.expand_path(ARGV[0])

    @bam = HTS::Bam.open(@fpath)
    @data = @bam.map do |r|
      row2ary(r)
    end.to_a
  end

  def row2ary(r)
    Aln.new(
      r.qname,
      r.flag.to_s,
      r.chrom,
      r.pos + 1,
      r.mapq,
      r.cigar.to_s,
      r.mate_chrom,
      r.mpos + 1,
      r.isize,
      r.seq
    )
  end

  attr_accessor :position

  def launch
    window("HTSGrid - #{@fpath}", 800, 500) do
      margined true

      on_closing do
        @bam.close
      end

      vertical_box do
        horizontal_box do
          stretchy false
          button('Open') do
            stretchy false
            on_clicked do
            end
          end
          entry do
            label 'pos'
            text <=> [self, :position]
          end
          button('Go') do
            stretchy false
            on_clicked do
              r = @bam.query(@position).map do |r|
                row2ary(r)
              end.to_a
              if r.size > 0
                @data.replace(p(r))
              else
                message_box_error('Error', "No record found at position #{@position}")
              end
            end
          end
        end
        refined_table(
          model_array: @data,
          table_columns: {
            "QNAME" => :text,
            "FLAG" => :text,
            "RNAME" => :text,
            "POS" => :text,
            "MAPQ" => :text,
            "CIGAR" => :text,
            "RNEXT" => :text,
            "PNEXT" => :text,
            "TLEN" => :text,
            "SEQ" => :text,
            "QUAL" => :text
          },
          editable: false,
          per_page: 20
        )
      end
    end.show
  end
end

HTSGrid.new.launch
