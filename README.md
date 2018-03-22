# AutoInteract

This module is to allow automatic generation of interactive control interfaces
for any julia type that can be controlled with buttons and sliders.

Currently it supports Interact.jl and Reactive.jl, but other signals packages
should be possible without too much modification.

It also facilities interactive plotting of any AbstractArray nested anywhere in
the provided type, by selecting them with a toggle-button interface.

Widgets, signals, and "plottables" are all return using as much as possible the
same hierarchical structure as the original data. This means plots can be
plotted automatically, and signals can automatically update the data
recursively.

## Widgets

Widgets can be built recursively by running:

```
widget = make_widgets(data)
```

They are named from the dict or struct label, AxisArray names, etc. They can
then be edited before retrieving signals and building an interface.

## Interface

Interfaces can be build recursively from any type containing widgets. This
mostly means anything returned by make_widgets, even after having any
sub-components deleted :

```
interface make_interface(widgets)
```

Signals can be retrieved from types containing widgets using:

```
get_signals
```

## Plottables and plotting

A structure of toggle-button widgets indicating if any node it the hierarchy is
"plottable" is returned from any data. Mostly this means it is an AbstractArray,
or it is the last dimension of an AxisArray, with a grid of named toggle-buttons
being made for the other dimensions.

```
plottables = make_plottable(data)
signals = get_signals(plottables)
plot_all(data, signals)
```


