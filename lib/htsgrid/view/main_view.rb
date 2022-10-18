module HTSGrid
  module View
    class MainView
      include Glimmer
      Aln = Struct.new(:qname, :flag, :rname, :pos, :mapq, :cigar, :rnext, :pnext, :tlen, :seq, :qual)

      class Position < Struct.new(:chr, :pos)
        def to_s
          pos ? "#{chr}:#{pos}" : chr
        end
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

      attr_accessor :target

      def initialize
        @fpath = ARGV[0]
        @data = []
        @target = Position.new

        open_bam @fpath if @fpath
      end

      def open_bam(path)
        @bam = HTS::Bam.open(path)
        target.chr = ''
        target.pos = nil
      rescue StandardError => e
        message_box_error('Error', e.message)
        nil
      end

      def open_ban_dialog
        path = open_file
        open_bam path if path
      end

      def go
        if @target.chr == 'ALL'
          @bam.rewind
          @data.replace(@bam.map { |r| row2ary(r) })
        else
          begin
            r = @bam.query(target.to_s).map do |r|
              row2ary(r)
            end.to_a
            @data.replace(r)
          rescue StandardError => e
            message_box_error('Error', e.message)
          end
        end
      end

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
              editable_combobox do
                stretchy false
                if @bam
                  items 'ALL', *@bam.header.target_names
                else
                  items 'ALL'
                end
                text <=> [target, :chr]
                on_changed do
                  go
                end
              end
              entry do
                stretchy false
                text <=> [target, :pos]
              end
              button('Go') do
                stretchy false
                on_clicked do
                  go
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
  end
end
