module HTSGrid
  module Model
    Variant = Struct.new(:chrom, :pos, :id, :ref, :alt, :qual, :filter, :info, :format, :samples)
  end
end
