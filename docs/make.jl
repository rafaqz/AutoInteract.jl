using Documenter, AutoInteract

makedocs(
    modules = [AutoInteract],
    doctest = false,
    clean = false,
    sitename = "AutoInteract.jl",
    format = :html,
    pages = Any[
        "Introduction" => "index.md",
    ]
)

deploydocs(
    repo = "github.com/rafaqz/AutoInteract.jl.git",
    osname = "linux",
    julia = "0.6",
    target = "build",
    deps = nothing,
    make = nothing
)
