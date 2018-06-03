module AutoInteract

using Requires
using DataStructures
using AxisArrays

@require InteractNext begin
    using InteractNext
    using Observables
    using WebIO
    using CSSUtil
end
@require Interact begin
    using Interact
    using Reactive
end
@require DataFrames begin
    using DataFrames
end
@require StaticArrays begin
    using StaticArrays
end

include("interface.jl")
include("signals.jl")
include("api.jl")
@require Plots begin
    include("plots.jl")
end

export set_defaults, steprange, box, make_widgets, make_interface, make_plottables, spreadwidgets
export plot_all, plot_all!
export get_signals, apply_signals!

end # module
