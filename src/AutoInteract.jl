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

export apply_all
export make_widgets, make_interface, make_plottable, spreadwidgets
export plot_all, plot_all!
export get_signals

include("apply.jl")
include("interface.jl")
include("plots.jl")
include("signals.jl")

end # module
