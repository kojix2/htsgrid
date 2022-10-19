# frozen_string_literal: true

require_relative 'hts_file'

module HTSGrid
  module Model
    class BamFile < HtsFile
      def initialize(path)
        case File.extname(path)
        when '.bam', '.sam', '.cram'
          @hts = HTS::Bam.open(path)
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
        @hts.header.target_names
      end

      def row2ary(r)
        Model::Alignment.new(
          r.qname,
          r.flag.to_s,
          r.chrom,
          r.pos + 1,
          r.mapq,
          r.cigar.to_s,
          r.mate_chrom,
          r.mpos + 1,
          r.isize,
          r.seq,
          r.qual_string
        )
      end
    end
  end
end
