using BinDeps
using Compat

@BinDeps.setup

# General settings.
so = "so"
all_load = "--whole-archive"
noall_load = "--no-whole-archive"

@static if Sys.isapple()
  so = "dylib"
  all_load = "-all_load"
  noall_load = "-noall_load"
  using Homebrew
end

hsl_modules = @compat Dict()

here = dirname(@__FILE__)

blas_and_metis_built = false

function build_blas_and_metis()
  global blas_and_metis_built
  if !blas_and_metis_built
    @info "building blas"
    include(joinpath(here, "build_blas.jl"))
    @info "building metis"
    include(joinpath(here, "build_metis4.jl"))
    blas_and_metis_built = true
  end
end

const hsl_ma97_version = "2.4.0"
const hsl_ma97_sha256 = "b91552164311add95f7228d1397a747611f08ffdc86a100df58ddfcedfdc7ca7"
const hsl_ma97_archive = joinpath(here, "downloads", "hsl_ma97-$hsl_ma97_version.tar.gz")

@info "looking for $hsl_ma97_archive"
if isfile(hsl_ma97_archive)
  @info "hsl_ma97 found"
  build_blas_and_metis()
  include("build_hsl_ma97.jl")
else
  @info "hsl_ma97 not found"
end

@eval @BinDeps.install $hsl_modules
