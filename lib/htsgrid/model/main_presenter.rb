# frozen_string_literal: true

require_relative 'alignment'
require_relative 'position'
require_relative 'hts_file'

module HTSGrid
  module Model
    class MainPresenter
      attr_reader :initial_width, :initial_height, :per_page, :option

      def initialize(options = {}, bam_presenter, bcf_presenter)
        @options = options
        @initial_width = 800
        @initial_height = 600
        @per_page = 30
        @bam_presenter = bam_presenter
        @bcf_presenter = bcf_presenter
      end

      def close
        @bam_presenter.close
        @bcf_presenter.close        
      end
    end
  end
end
