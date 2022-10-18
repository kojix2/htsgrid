require_relative 'alignment'
require_relative 'position'
require_relative 'bam_file'

module HTSGrid
  module Model
    class MainPresenter
      def initialize(options = {})
        @options = options
      end
    end
  end
end
