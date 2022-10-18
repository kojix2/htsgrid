# frozen_string_literal: true

require_relative 'alignment'
require_relative 'position'
require_relative 'bam_file'

module HTSGrid
  module Model
    class MainPresenter
      attr_reader :initial_width, :initial_height, :options

      def initialize(options = {})
        @options = options
        @initial_width = 800
        @initial_height = 600
      end

      def close
        @hts&.close
      end

      def data
        []
      end

      def open
      end

      def goto
      end
    end
  end
end
