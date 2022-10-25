module HTSGrid
  module View
    class MainView
      def create_browser_view
        @browser = area(@presenter.initial_width, @presenter.initial_height / 2) do
          on_draw do
            @bam_presenter.data.each do |d|
              next if d[:pos].nil?
              rectangle(d[:pos], rand(100), d[:endpos]-d[:pos], 10) do
                fill r: 102, g: 102, b: 204
              end
            end
          end
        end
      end
    end
  end
end
