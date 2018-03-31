module AutoInteract

# TODO: Should be able to move some of these deps into submodules in julia 0.7
using Requires
using StaticArrays
using DataStructures
using DataFrames
using AxisArrays
using Interact
using Reactive
using Plots

export make_widgets, make_interface, make_plottables, spreadwidgets
export plot_all, plot_all!
export get_signals, apply_signals!

include("interface.jl")
include("plots.jl")
include("signals.jl")

end # module
