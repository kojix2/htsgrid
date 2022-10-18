# frozen_string_literal: true

require_relative '../model/main_presenter'

module HTSGrid
  module View
    class MainView
      include Glimmer::LibUI::Application
      options :initial_width, :initial_height

      attr_reader :presenter
      attr_accessor :cb, :flag

      before_body do
        open_dialog = -> { open_file }
        err_dialog = ->(title, message) { msg_box_error(title, message) }
        cb_set = lambda do |chr_list|
          @flag = true
          ::LibUI.combobox_clear(@cb.libui)
          @cb.items = chr_list
          @flag = false
        end
        @presenter = Model::MainPresenter.new(options, open_dialog, err_dialog, cb_set)
      end

      body do
        htsgrid_menu_bar

        # window
        window('HTSGrid', @presenter.initial_width, @presenter.initial_height) do
          margined true

          on_closing do
            @presenter.close
          end

          vertical_box do
            horizontal_box do
              stretchy false
              button('Open') do
                stretchy false
                on_clicked do
                  @presenter.open
                end
              end
              @cb = combobox do
                stretchy false
                items ['']
                selected_item <=> [@presenter, :chr]
                on_selected do
                  @presenter.pos = '0-1000'
                  @presenter.goto unless @flag
                end
              end
              entry do
                stretchy false
                text <=> [@presenter, :pos]
              end
              button('Go') do
                stretchy false
                on_clicked do
                  @presenter.goto
                end
              end
            end
            refined_table(
              model_array: @presenter.data,
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
              visible_page_count: true,
            )
          end
        end
      end

      def htsgrid_menu_bar
        file_menu
        view_menu
        help_menu
      end

      def file_menu
        menu('File') do
          menu_item('Open') do
            on_clicked do
              @presenter.open
            end
          end

          quit_menu_item do
            on_clicked do
              @presenter.close
            end
          end
        end
      end

      def view_menu
        menu('View') do
          menu_item('Header') do
            on_clicked do
              msg_box(
                'Header',
                @presenter.header
              )
            end
          end
        end
      end

      def help_menu
        menu('Help') do
          menu_item('Help') do
            on_clicked do
              msg_box(
                'Help',
                "Please open GitHub issue to ask for help.\n" \
                "\n" \
                'https://github.com/kojix2/htsgrid/issues'
              )
            end
          end

          about_menu_item do
            on_clicked do
              msg_box(
                'ℹ️ About',
                "This is a simple HTS file viewer\n" \
                '© 2022 kojix2'
              )
            end
          end
        end
      end
    end
  end
end
