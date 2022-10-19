# frozen_string_literal: true

require_relative 'variant'
require_relative 'position'
require_relative 'hts_file'

module HTSGrid
  module Model
    class BcfPresenter
      attr_reader :data
      attr_accessor :chr, :pos, :chr_list

      def initialize(_options = {}, open_dialog, err_dialog, _cb_set)
        per_page = 30 # FIXME
        @data = Array.new(per_page + 1) { Variant.new } # FIXME: Show navigation buttons
        @chr_list = ['']
        @chr = ''
        @pos = '0-1000'
        @err_dialog = err_dialog
        @open_dialog = open_dialog
      end

      def close
      end
    end
  end
end
