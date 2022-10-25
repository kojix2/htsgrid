# frozen_string_literal: true

require_relative '../model/main_presenter'
require_relative '../model/browser_presenter'
require_relative '../model/bam_presenter'
require_relative '../model/bcf_presenter'

require_relative '../view/browser_view'
require_relative '../view/bam_view'
require_relative '../view/bcf_view'

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
        @browser_presenter = Model::BrowserPresenter.new(options, open_dialog, err_dialog)
        @bam_presenter = Model::BamPresenter.new(options, @browser_presenter, open_dialog, err_dialog,
                                                 method(:bam_cb_set).to_proc)
        @bcf_presenter = Model::BcfPresenter.new(options, @browser_presenter, open_dialog, err_dialog,
                                                 method(:bcf_cb_set).to_proc)
        @presenter = Model::MainPresenter.new(options, @bam_presenter, @bcf_presenter)
      end

      body do
        htsgrid_menu_bar

        # window
        window('HTSGrid', @presenter.initial_width, @presenter.initial_height) do
          margined true

          on_closing do
            @presenter.close
            @presenter.close
          end

          vertical_box do
            tab do
              tab_item('BAM') do
                create_bam_view
              end
              tab_item('BCF') do
                create_bcf_view
              end
            end
            create_browser_view
          end
        end
      end

      def htsgrid_menu_bar
        file_menu
        help_menu
      end

      def file_menu
        menu('File') do
          menu_item('Open SAM/BAM/CRAM') do
            on_clicked do
              @bam_presenter.open
            end
          end

          menu_item('Open VCF/BCF') do
            on_clicked do
              @bcf_presenter.open
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
