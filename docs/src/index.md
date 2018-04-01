# AutoInteract

The main use of AutoInteract is to build widgets, extract signals from them, 
and apply them back to data from a live interface. These steps all maintain a
similar structure to the original data so that it can all be automated.

## Widgets

```@docs
make_widgets
```

## Interface

```@docs
make_interface
```

## Signals

```@docs
get_signals
```

```@docs
apply_signals!
```

## Plottables and plotting

AutoInteract also generates an interface for plotting arbitrary data in an
interface. 'Plottables' are structured objects containing toggle-button widgets
indicating if any data can be plotted. Mostly this means it inherits
AbstractArray, or it is the last dimension of an AxisArray, with a grid of named
toggle-buttons being made for the other dimensions. Signals from plottables can
be plotted with `plot_all()`.

```@docs
make_plottables
```

```@docs
plot_all
```

```@docs
plot_all!
```

# Customisation API

```@docs
set_defaults
```

```@docs
steprange
```

```@docs
box
```

## Misc


```@docs
spreadwidgets
```


