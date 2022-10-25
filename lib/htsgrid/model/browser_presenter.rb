module HTSGrid
  module Model
    class BrowserPresenter
      attr_writer :browser

      def initialize(_options = {}, open_dialog, err_dialog)
        @browser = nil
        @err_dialog = err_dialog
        @open_dialog = open_dialog
      end

      def goto(_data)
        @browser.on_draw do |prm|
          browser.rectangle(0, 0, 100, 20)
          browser.fill r: 102, g: 102, b: 204, a: 1.0
        end
      end
    end
  end
end
