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


## Widgets

Widgets can be built recursively by running:

```
widgets = make_widgets(data)
```

They are labelled using the dict or struct label, AxisArray names, etc. They can
then be edited before retrieving signals and building an interface.

## Interface

Interfaces can be build recursively from any type containing widgets. This
mostly means anything returned by make_widgets, but also after having any
sub-components deleted custom components added:

```
interface make_interface(widgets)
```

## Signals

Signals can be retrieved from types containing widgets, as returned by
make_widgets() and make_plottable() using:

```
signals = get_signals(widgets)
```

And applied (only to mutables) using:

```
apply_signals!(data, signals.value)
```

But ultimately use this somewhere inside a Reactive map() without the `.value`
part

## Plottables and plotting

A structure of toggle-button widgets indicating if any node it the hierarchy is
"plottable" is returned from any data. Mostly this means it is an AbstractArray,
or it is the last dimension of an AxisArray, with a grid of named toggle-buttons
being made for the other dimensions.

```
plottables = make_plottables(data)
signals = get_signals(plottables)
plot_all(data, signals.value)
```

See the demo notebook for more details.
