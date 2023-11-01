
using Documenter: DocMeta.setdocmeta!, makedocs, HTML, deploydocs
using Typstry

const directory = joinpath(@__DIR__, "src", "assets")
const logo = joinpath(directory, "logo.svg")
if !ispath(logo)
    using Luxor: Drawing, julia_blue, julia_red, julia_green, julia_purple, sethue, rect, finish

    const width, height = 210, 297

    mkpath(directory)
    Drawing(width, height, :svg, logo)

    for (color, (x_min, y_min)) in zip(
        (julia_purple, julia_green, julia_red, julia_blue),
        map(i -> ((0.3 - i) * width, i * height), 0:0.1:0.3)
    )
        sethue(color)
        rect(x_min, y_min, 0.7 * width, 0.7 * height; action = :fill)
    end

    finish()
end

setdocmeta!(
    Typstry,
    :DocTestSetup,
    :(using Typstry),
    recursive = true,
)

makedocs(
    sitename = "Typstry.jl",
    format = HTML(edit_link = "main"),
    modules = [Typstry],
    pages = ["Home" => "index.md", "Manual" => "manual.md"],
)

deploydocs(
    repo = "github.com/jakobjpeters/Typstry.jl.git",
    devbranch = "main"
)
