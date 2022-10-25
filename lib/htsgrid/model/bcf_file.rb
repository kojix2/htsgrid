# frozen_string_literal: true

require_relative 'hts_file'

module HTSGrid
  module Model
    class BcfFile < HtsFile
      def initialize(path)
        case File.extname(path)
        when '.vcf', '.bcf'
          @hts = HTS::Bcf.open(path)
        else
          LibUI.message_box_error(
            'Error',
            "Unsupported file type: #{File.extname(path)}\n" \
            "\n" \
            "You opened #{path}"
          )
        end
      end

      def chr_list
        @hts.header.seqnames
      end

      def row2ary(r)
        Model::Variant.new(
          r.chrom,
          r.pos,
          r.id,
          r.qual,
          r.ref,
          r.alt,
          r.filter,
          r.info.to_h.map { |k, v| "#{k}: #{v}" }.join(' ').strip, # FIXME
          r.format.to_s,
          ''
        )
      end
    end
  end
end
