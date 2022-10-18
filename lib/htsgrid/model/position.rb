# frozen_string_literal: true

module HTSGrid
  module Model
    Position = Struct.new(:chr, :pos) do
      def to_s
        pos ? "#{chr}:#{pos}" : chr
      end
    end
  end
end
