
module Typstry

import Base:
    IOBuffer, ==, addenv, codeunit, detach, eltype, firstindex,
    getindex, hash, ignorestatus, isvalid, iterate, keys, lastindex,
    length, ncodeunits, pointer, repr, run, setenv, show, showerror
using Artifacts: @artifact_str
using Base: Docs.Text, Iterators.Stateful, Meta.parse, escape_raw_string
using PrecompileTools: PrecompileTools, @compile_workload
using Typst_jll: typst

@static isdefined(Base, :setcpuaffinity) && import Base: setcpuaffinity

include("strings.jl")

export Mode, Typst, TypstString, @typst_str, code, markup, math, context, show_typst, typst_text

include("commands.jl")

export TypstCommand, TypstError, @typst_cmd, julia_mono, render

@compile_workload for (x, _) in examples
    typst"\(x)"
end

end # module
