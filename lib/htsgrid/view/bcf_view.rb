# frozen_string_literal: true

require_relative '../model/bcf_presenter'

module HTSGrid
  module View
    class MainView
      def bcf_cb_set(chr_list)
        @bcf_flag = true
        ::LibUI.combobox_clear(@cb_bcf.libui)
        @cb_bcf.items = chr_list
        @bcf_flag = false
      end

      def create_bcf_view
        vertical_box do
          horizontal_box do
            stretchy false
            button('Open') do
              stretchy false
              on_clicked do
                @bcf_presenter.open
              end
            end
            @cb_bcf = combobox do
              stretchy false
              items ['']
              selected_item <=> [@bcf_presenter, :chr]
              on_selected do
                @bcf_presenter.pos = '0-1000'
                @bcf_presenter.goto unless @bcf_flag
              end
            end
            entry do
              stretchy false
              text <=> [@bcf_presenter, :pos]
            end
            button('Go') do
              stretchy false
              on_clicked do
                @bcf_presenter.goto
              end
            end
          end

          refined_table(
            model_array: @bcf_presenter.data,
            table_columns: {
              'CHROM' => :text,
              'POS' => :text,
              'ID' => :text,
              'REF' => :text,
              'ALT' => :text,
              'QUAL' => :text,
              'FILTER' => :text,
              'INFO' => :text,
              'FORMAT' => :text,
              'SAMPLES' => :text
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
