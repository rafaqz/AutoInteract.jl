# AutoInteract

This module is to allow automatic generation of interactive interfaces
for any julia type than contains anything that can be controlled with buttons
and sliders.

It also facilities interactive plotting of any AbstractArray nested anywhere in
the provided type, by providing a toggle-button interface and a `plot_all`
command.

Widgets, signals, and "plottables" are all return using as much as possible the
same hierarchical structure as the original data. This means plots can be
plotted automatically, and signals can automatically update the data
recursively.

Currently AutoInteract.jl supports [Interact.jl](https://github.com/JuliaGizmos/Interact.jl)
and [Reactive.jl](https://github.com/JuliaGizmos/Reactive.jl), but other signals
packages could also be supported in future.
