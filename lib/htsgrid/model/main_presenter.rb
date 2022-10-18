# frozen_string_literal: true

require_relative 'alignment'
require_relative 'position'
require_relative 'hts_file'

module HTSGrid
  module Model
    class MainPresenter
      include Glimmer

      attr_reader :initial_width, :initial_height, :option, :data
      attr_accessor :chr, :pos, :chr_list

      def initialize(options = {}, open_dialog, err_dialog, cb_set)
        @options = options
        @initial_width = 800
        @initial_height = 600
        @data = []
        @chr_list = ['']
        @chr = ''
        @pos = '0-1000'
        @err_dialog = err_dialog
        @open_dialog = open_dialog
        @cb_set = cb_set
      end

      def close
        @hts&.close
      end

      def open
        path = @open_dialog.call
        @hts = HtsFile.new(path)
        @cb_set.call(@hts.chr_list)
      end

      def goto
        position = Position.new(chr, pos)
        begin
          position.validate
        rescue StandardError => e
          @err_dialog.call('Error', e.message)
          return
        end
        new_data = @hts.query(position.to_s)
        data.replace(new_data)
      end

      def header
        @hts.header
      end
    end
  end
end
