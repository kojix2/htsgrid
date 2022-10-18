# frozen_string_literal: true

require_relative '../model/main_presenter'

module HTSGrid
  module View
    class MainView
      include Glimmer::LibUI::Application
      options :initial_width, :initial_height

      attr_reader :presenter

      before_body do
        @presenter = Model::MainPresenter.new(options)
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
                  @presenter.open_bam_dialog
                end
              end
              editable_combobox do
                stretchy false
                items 'ALL'
                # text <=> [target, :chr]
                on_changed do
                  @presenter.go
                end
              end
              entry do
                stretchy false
                # text <=> [target, :pos]
              end
              button('Go') do
                stretchy false
                on_clicked do
                  @presenter.go
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
              per_page: 20
            )
          end
        end
      end

      def htsgrid_menu_bar
        file_menu
        help_menu
      end

      def file_menu
        menu('File') do
          menu_item('Open') do
            on_clicked do
              open_bam_dialog
            end
          end

          quit_menu_item do
            on_clicked do
              @presenter.close
            end
          end
        end
      end

      def help_menu
        menu('Help') do
          menu_item('Help') do
            on_clicked do
              msg_box('Help', 'FIXME')
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
