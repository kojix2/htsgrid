module HTSGrid
  module Model
    class BamFile
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
          r.seq
        )
      end

      def open_bam(path)
        @bam = HTS::Bam.open(path)
        target.chr = ''
        target.pos = nil
      rescue StandardError => e
        message_box_error('Error', e.message)
        nil
      end

      def open_ban_dialog
        path = open_file
        open_bam path if path
      end

      def go
        if @target.chr == 'ALL'
          @bam.rewind
          @data.replace(@bam.map { |r| row2ary(r) })
        else
          begin
            r = @bam.query(target.to_s).map do |r|
              row2ary(r)
            end.to_a
            @data.replace(r)
          rescue StandardError => e
            message_box_error('Error', e.message)
          end
        end
      end
    end
  end
end
