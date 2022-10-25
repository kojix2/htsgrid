module HTSGrid
  module Model
    class HtsPresenter
      def goto
        position = Position.new(chr, pos)
        position.validate
        new_data = @hts.query(position.to_s)
        data.replace(new_data)
        @browser_presenter.goto(data)
      rescue StandardError => e
        @err_dialog.call('Error', "#{e.message}\n#{e.backtrace.join("\n")}")
        nil
      end

      def close
        @hts&.close
      end

      def header
        return if @hts.nil?

        @hts.header
      rescue StandardError => e
        @err_dialog.call('Error', "#{e.message}\n#{e.backtrace.join("\n")}")
        nil
      end
    end
  end
end
