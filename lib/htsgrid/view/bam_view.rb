# frozen_string_literal: true

require_relative '../model/bam_presenter'

module HTSGrid
  module View
    class MainView
      def bam_cb_set(chr_list)
        @bam_flag = true
        ::LibUI.combobox_clear(@cb_bam.libui)
        @cb_bam.items = chr_list
        @bam_flag = false
      end

      def create_bam_view
        vertical_box do
          horizontal_box do
            stretchy false
            button('Open') do
              stretchy false
              on_clicked do
                @bam_presenter.open
              end
            end
            @cb_bam = combobox do
              stretchy false
              items ['']
              selected_item <=> [@bam_presenter, :chr]
              on_selected do
                @bam_presenter.pos = '0-1000'
                @bam_presenter.goto unless @flag
              end
            end
            entry do
              stretchy false
              text <=> [@bam_presenter, :pos]
            end
            button('Go') do
              stretchy false
              on_clicked do
                @bam_presenter.goto
              end
            end
          end

          refined_table(
            model_array: @bam_presenter.data,
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
            per_page: @presenter.per_page,
            visible_page_count: true
          )
        end
      end
    end
  end
end
