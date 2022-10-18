# frozen_string_literal: true

require_relative 'alignment'
require_relative 'position'
require_relative 'hts_file'

module HTSGrid
  module Model
    class MainPresenter
      include Glimmer

      attr_reader :initial_width, :initial_height, :option, :data
      attr_accessor :chr, :pos

      def initialize(options = {}, open_dialog, err_dialog)
        @options = options
        @initial_width = 800
        @initial_height = 600
        @data = []
        @err_dialog = err_dialog
        @open_dialog = open_dialog
      end

      def close
        @hts&.close
      end

      def open
        path = @open_dialog.call()
        @hts = HtsFile.new(path)
      end

      def goto
        position = Position.new(chr, pos)
        begin
          position.validate
        rescue => e
          @err_dialog.('Error', e.message)
          return
        end
        new_data = @hts.query(position.to_s).map do |r|
          Alignment.new(
            r.qname,
            r.flag.to_s,
            r.chrom,
            r.pos + 1,
            r.mapq,
            r.cigar.to_s,
            r.mate_chrom,
            r.mpos + 1,
            r.isize,
            r.seq
          )
        end
        data.replace(new_data)
      end
    end
  end
end
