# frozen_string_literal: true

module HTSGrid
  module Model
    class HtsFile
      def query(position)
        @hts.query(position).map do |r|
          row2ary(r)
        end
      end

      def close
        @hts&.close
      end

      def header
        @hts.header.to_s
      end
    end
  end
end
