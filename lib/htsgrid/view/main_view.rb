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
          menu_item('Help') do
            on_clicked do
              msg_box('Help', 'FIXME')
            end
          end

          about_menu_item do
            on_clicked do
              msg_box(
                'ℹ️ About',
                "This is a simple HTS file viewer\n" +
                '© 2022 kojix2'
              )
            end
          end
        end

        # window
        window("HTSGrid", 800, 500) do
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
                  items 'ALL' #, *@bam.header.target_names
                else
                  items 'ALL'
                end
                # text <=> [target, :chr]
                on_changed do
                  go
                end
              end
              entry do
                stretchy false
                # text <=> [target, :pos]
              end
              button('Go') do
                stretchy false
                on_clicked do
                  go
                end
              end
            end
            refined_table(
              model_array: [], # @data
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
