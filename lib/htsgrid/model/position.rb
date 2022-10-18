module HTSGrid
  module Model
    class Position < Struct.new(:chr, :pos)
      def to_s
        pos ? "#{chr}:#{pos}" : chr
      end
    end
  end
end
