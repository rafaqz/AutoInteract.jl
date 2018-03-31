module AutoInteract

using Requires
using StaticArrays
using DataStructures
using DataFrames
using AxisArrays
using Interact
using Reactive
using Plots

include("interface.jl")
include("plots.jl")
include("signals.jl")

export func, make_widgets, make_interface, make_plottables, spreadwidgets
export plot_all, plot_all!
export get_signals, apply_signals!

end # module
