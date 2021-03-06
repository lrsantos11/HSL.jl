module HSL

using LinearAlgebra
using SparseArrays

if isfile(joinpath(dirname(@__FILE__), "..", "deps", "deps.jl"))
  include("../deps/deps.jl")
else
  error("HSL library not properly installed. Please run Pkg.build(\"HSL\")")
end

# definitions applicable to all packages
const data_map = Dict{Type, Type}(Float32 => Cfloat,
                                  Float64 => Cdouble,
                                  ComplexF32 => Cfloat,
                                  ComplexF64 => Cdouble)

# package-specific definitions
if @isdefined libhsl_ma97
  include("hsl_ma97.jl")
end

end
