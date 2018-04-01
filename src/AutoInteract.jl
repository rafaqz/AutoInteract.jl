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
include("api.jl")

export set_defaults, steprange, box, make_widgets, make_interface, make_plottables, spreadwidgets
export plot_all, plot_all!
export get_signals, apply_signals!

function __init__()
    global defaults = Dict(:maxlen_widget_array => 9,
                           :minlen_plottable_array => 10,
                           :missing_label => "unknown"
                      )
end



end # module
