global defaults = Dict(:maxlen_widget_array => 9,
                       :minlen_plottable_array => 10,
                       :missing_label => "unknown",
                       :plot_range => 1:10000000
                  )

"""
    set_defaults(args...)

Set global defaults to control behaviour.

# Examples

```julia
set_defaults(:maxlen_slider_array => 10, 
             :minlen_plot_array => 10,
             :missing_label => "List"
            )
```
"""
function set_defaults(args...)
    global defaults
    for (key, val) in args
        defaults[key] = val
    end
end

"""
    get_box(::T)

Returns the vbox or hbox function depending on input type.
Add methods to control the layout. Associtave structures are displayed 
vertically by default, otherwise horizontally.

# Examples

Use a vertical layout for tuples:

```julia
using AutoInteract.get_box
AutoInteract.get_box(::Tuple) = vbox
```
"""
get_box(::Associative) = vbox
get_box(::Any) = hbox

"""
    get_range(x::Number, label)

Set the range of a slider. Add methods to customise.
The widget label provided if you need to modify specific widgets.

# Examples

Make all sliders range from 0.0 to 100.0, with a step of 2.0 for Float64:

```julia
using AutoInteract.get_range
AutoInteract.get_range(x::Float64, label) = 0.0:2.0:100.0
```
"""
function get_range(x::AbstractFloat, label)
    low = 0.0
    if x == 0.0
        high = 1.0
    else
        high = x * 2
    end
    step = (high - low) / 100
    return low:step:high
end
function get_range(x::Integer, label)
    step = 1
    if x == 0
        range = 0:step:100
    elseif x < 0
        range = 2x:step:0
    else
        range = 0:step:2x
    end
    return range
end

@require Unitful begin
function get_range(x::Unitful.Quantity, label)
    u = Unitful.unit(x)
    low = 0.0u
    if x == 0.0u
        high = 1.0u
    else
        high = x * 2
    end
    step = (high - low) / 100
    return low:step:high
end
end

"""
    plotit!(p, parent, data, label)

Common plotting function. Can extend specific methods for a parent type, 
or customise for a particular label.

p is a Plots object to plot to.
"""
plotit!(p, parent, data, label) =
    plot!(p, data[inbounds_range(data)], label=label, layout=deflayout)
