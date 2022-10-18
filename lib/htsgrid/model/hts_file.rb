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

      def query(...)
        @hts.query(...)
      end

      def close
        @hts&.close
      end

      
    end
  end
end
