# frozen_string_literal: true

require_relative 'alignment'
require_relative 'position'
require_relative 'bam_file'
require_relative 'hts_presenter'

module HTSGrid
  module Model
    class BamPresenter < HtsPresenter
      attr_reader :data
      attr_accessor :chr, :pos, :chr_list

      def initialize(_options = {}, browser_presenter, open_dialog, err_dialog, cb_set)
        @browser_presenter = browser_presenter
        per_page = 30 # FIXME
        @data = Array.new(per_page + 1) { Alignment.new } # FIXME: Show navigation buttons
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

        @hts = BamFile.new(path)
        @cb_set.call(@hts.chr_list)
      rescue StandardError => e
        @err_dialog.call('Error', "#{e.message}\n#{e.backtrace.join("\n")}")
        nil
      end
    end
  end
end
