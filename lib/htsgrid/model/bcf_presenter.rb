# frozen_string_literal: true

require_relative 'variant'
require_relative 'position'
require_relative 'bcf_file'

module HTSGrid
  module Model
    class BcfPresenter
      attr_reader :data
      attr_accessor :chr, :pos, :chr_list

      def initialize(_options = {}, open_dialog, err_dialog, cb_set)
        per_page = 30 # FIXME
        @data = Array.new(per_page + 1) { Variant.new } # FIXME: Show navigation buttons
        @chr_list = ['']
        @chr = ''
        @pos = '0-1000'
        @err_dialog = err_dialog
        @open_dialog = open_dialog
        @cb_set = cb_set
      end

      def open
        path = @open_dialog.call
        return if path.nil?

        @hts = BcfFile.new(path)
        @cb_set.call(@hts.chr_list)
      rescue StandardError => e
        p e
        nil
      end

      def close
        @hts.close
      end


      def goto
        position = Position.new(chr, pos)
        position.validate
        new_data = @hts.query(position.to_s)
        data.replace(new_data)
      rescue StandardError => e
        @err_dialog.call('Error', "#{e.message}\n#{e.backtrace.join("\n")}")
        nil
      end
    end
  end
end