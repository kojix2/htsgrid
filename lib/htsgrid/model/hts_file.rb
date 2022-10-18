module HTSGrid
  module Model
    class HtsFile
      def initialize(path)
        case File.extname(path)
        when '.bam', '.sam', '.cram'
          @hts = HTS::Bam.open(path)
        when '.vcf', '.bcf'
          @hts = HTS::Vcf.open(path)
        else
          LibUI.message_box_error(
            'Error',
            "Unsupported file type: #{File.extname(path)}\n" \
            "Only BAM, SAM, CRAM, VCF, and BCF are supported. \n" \
            "File format is identified by the file extension. \n" \
            "\n" \
            "You opened #{path}"
          )
        end
      end

      def query(position)
        @hts.query(position).map do |r|
          row2ary(r)
        end
      end

      def chr_list
        @hts.header.target_names.clone
      end

      def close
        @hts&.close
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
