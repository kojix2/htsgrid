# frozen_string_literal: true

module HTSGrid
  module Model
    Alignment = Struct.new(:qname, :flag, :rname, :pos, :mapq, :cigar, :rnext, :pnext, :tlen, :seq, :qual, :endpos)
  end
end
