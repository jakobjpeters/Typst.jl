
"""
    typst_executable
"""
const typst_executable = typst()

"""
    TypstCommand
    TypstCommand(::Vector{String})
    TypstCommand(::TypstCommand; kwargs...)

The Typst command-line interface.

This command attempts to support the same interface as `Cmd`.
However, this interface is unspecified which may result in missing functionality.

# Examples
```jldoctest
julia> help = TypstCommand(["help"])
typst`help`

julia> TypstCommand(help; ignorestatus = true)
typst`help`
```
"""
struct TypstCommand
    typst::Cmd
    parameters::Cmd

    TypstCommand(parameters::Vector{String}) = new(typst_executable, Cmd(parameters))
    TypstCommand(tc::TypstCommand; kwargs...) = new(Cmd(tc.typst; kwargs...), tc.parameters)
end

"""
    @typst_cmd(parameters)
    typst`parameters...`

Construct a [`TypstCommand`](@ref) without interpolation.

Each parameter must be separated by a space `" "`.

# Examples
```jldoctest
julia> typst`help`
typst`help`

julia> typst`compile input.typ output.typ`
typst`compile input.typ output.typ`
```
"""
macro typst_cmd(parameters)
    :(TypstCommand(map(string, eachsplit($parameters, " "))))
end

"""
    render(elements...;
        delimeter = '\\n',
        input = "input.typ",
        output = "output.pdf",
        open = true,
    settings...)

Render the `elements` to a document.

Each element is written to the `input` file with `print_typst`
and the given `settings`, seperated by the `delimeter`.

Then, the `input` file is compiled to the `output` file with a [`TypstCommand`](@ref).

The document format is inferred by the file extension of `output`.
The available formats are `pdf`, `png`, and `svg`.

If `open` = true`, the `output` file will be opened using the default viewer.
```
"""
function render(elements...; delimeter = '\n', input = "input.typ", output = "output.pdf", open = true, settings...)
    Base.open(input; truncate = true) do file
        join_with(print_typst, file, elements, delimeter; settings...)
        println(file)
    end

    run(TypstCommand(["compile", input, output, "--open"][begin:end - !open]))
end

# Interface

"""
    addenv(::TypstCommand, args...; kwargs...)
"""
addenv(tc::TypstCommand, args...; kwargs...) =
    TypstCommand(addenv(tc.typst, args...; kwargs...), tc.parameters)

"""
    detach(::TypstCommand)
"""
detach(tc::TypstCommand) =
    TypstCommand(detach(tc.typst), tc.parameters)

"""
    ignorestatus(::TypstCommand)
"""
ignorestatus(tc::TypstCommand) =
    TypstCommand(ignorestatus(tc.typst), tc.parameters)

"""
    run(::TypstCommand, args...; kwargs...)
"""
run(tc::TypstCommand, args...; kwargs...) =
    run(Cmd(`$(tc.typst) $(tc.parameters)`), args...; kwargs...)

"""
    setcpuaffinity(::TypstCommand, cpus)
"""
setcpuaffinity(tc::TypstCommand, cpus) =
    TypstCommand(setcpuaffinity(tc.typst, cpus), tc.parameters)

"""
    setenv(::TypstCommand, env; kwargs...)
"""
setenv(tc::TypstCommand, env; kwargs...) =
    TypstCommand(setenv(tc.typst, env; kwargs...), tc.parameters)

"""
    show(::IO, ::TypstCommand)
"""
show(io::IO, tc::TypstCommand) = print(io, "typst", tc.parameters)
