module HTSGrid
  module View
    class MainView
      def create_browser_view
        @browser = area(@presenter.initial_width, @presenter.initial_height / 2)
        @browser_presenter.browser = @browser
      end
    end
  end
end
