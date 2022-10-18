module HTSGrid
  module Model
    Alignment = Struct.new(:qname, :flag, :rname, :pos, :mapq, :cigar, :rnext, :pnext, :tlen, :seq, :qual)
  end
end