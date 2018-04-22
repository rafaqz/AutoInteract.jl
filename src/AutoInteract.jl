module AutoInteract

using Requires
using StaticArrays
using DataStructures
using Interact
using Reactive
using Plots

include("interface.jl")
include("plots.jl")
include("signals.jl")
include("api.jl")

export set_defaults, steprange, box, make_widgets, make_interface, make_plottables, spreadwidgets
export plot_all, plot_all!
export get_signals, apply_signals!

end # module
