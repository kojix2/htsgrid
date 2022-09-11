require 'htslib'
require 'glimmer-dsl-libui'

class HTSGrid
  include Glimmer
  Aln = Struct.new(:qname, :flag, :rname, :pos, :mapq, :cigar, :rnext, :pnext, :tlen, :seq, :qual)

  def initialize
    @fpath = File.expand_path(ARGV[0])

    open_bam @fpath
  end

  def open_bam(path)
    begin
      @bam = HTS::Bam.open(path)
    rescue StandardError => e
      message_box_error('Error', e.message)
      return
    end
    @data = @bam.map do |r|
      row2ary(r)
    end.to_a
  end

  def open_ban_dialog
    path = open_file
    open_bam path if path
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
    # menu
    menu('File') do
      menu_item('Open') do
        on_clicked do
          open_ban_dialog
        end
      end

      quit_menu_item do
        on_clicked do
          @bam.close
        end
      end
    end
    menu('Help') do
      menu_item('Help')

      about_menu_item do
        on_clicked do
          msg_box('About', 'This is a simple HTS file viewer')
        end
      end
    end

    # window
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
              open_ban_dialog
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
            'QNAME' => :text,
            'FLAG' => :text,
            'RNAME' => :text,
            'POS' => :text,
            'MAPQ' => :text,
            'CIGAR' => :text,
            'RNEXT' => :text,
            'PNEXT' => :text,
            'TLEN' => :text,
            'SEQ' => :text,
            'QUAL' => :text
          },
          editable: false,
          per_page: 20
        )
      end
    end.show
  end
end

HTSGrid.new.launch
