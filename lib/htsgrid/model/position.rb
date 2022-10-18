# frozen_string_literal: true

module HTSGrid
  module Model
    Position = Struct.new(:chr, :pos) do
      def to_s
        pos ? "#{chr}:#{pos}" : chr
      end

      def validate
        raise 'No chromosome specified' unless chr
        raise 'No chromosome specified' if chr.empty?
        raise 'No position specified' unless pos
        raise 'Invalid position' unless pos.match?(/\d+-\d+\z/)

        true
      end
    end
  end
end
