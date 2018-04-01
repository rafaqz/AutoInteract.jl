
"""
    make_widgets(x, label)

Widets are built recursively from any type, labelled using the dict or struct 
label, AxisArray names, etc. 

They can then be edited before retrieving signals and building an interface.
"""
make_widgets(x, label...) = begin
    widgets = []
    labels = []
    if length(fieldnames(x)) > 0
        for name in fieldnames(x)
            field = getfield(x, name)
            widget = make_widgets(field, string(name))
            if widget != nothing 
                push!(widgets, widget)
                push!(labels, name) 
            end
        end
        if length(widgets) > 0 
            if all(w -> typeof(w) == typeof(widgets[1]), widgets)
                widgettype = typeof(widgets[1])
            else
                widgettype = Any
            end
            return OrderedDict{Any,widgettype}(zip(labels, widgets))
        else
            return nothing
        end
    else
        return nothing
    end
end
make_widgets(x::Associative, label...) = begin
    widgets = []
    labels = []
    for key in keys(x)
        field = x[key]
        widget = make_widgets(field, string(key))
        if widget != nothing 
            push!(widgets, widget)
            push!(labels, key) 
        end
    end
    if length(widgets) > 0 
        if all(w -> typeof(w) == typeof(widgets[1]), widgets)
            widgettype = typeof(widgets[1])
        else
            widgettype = Any
        end
        return OrderedDict{Any,widgettype}(zip(labels, widgets))
    else
        return nothing
    end
end
make_widgets(xs::Tuple) = begin
    label = defaults[:missing_label]
    make_widgets(xs, label)
end
make_widgets(xs::Tuple, label) = begin
    labels = [string(label, n) for n = 1:length(xs)]
    tuple(make_widgets.(xs, labels)...)
end
make_widgets(xs::AbstractArray, label) = 
    if length(xs) <= defaults[:maxlen_widget_array]
        labels = [string(label, n) for n = 1:length(xs)]
        make_widgets.(xs, labels)
    end
make_widgets(x::Integer, label) = begin
    range = get_range(x, label)
    make_widgets(x, label, range)
end
make_widgets(x::AbstractFloat, label) = begin
    range = get_range(x, label)
    return make_widgets(x, label, range)
end
make_widgets(x::Real, label, range) = begin
    widget = slider(range, value = x, label = label)
    widget.signal.name = label * "_slider"
    return widget
end
make_widgets(x::Function, label) = nothing
make_widgets(x::Bool, label) = begin
    widget = togglebutton(label, value = x)
    widget.signal.name = label * "_toggle"
    return widget
end
@require DataFrames begin
make_widgets(x::DataFrame, label...) = begin
    array = []
    for name in names(x)
        field = x[name]
        widget = make_widgets(field, string(name))
        if widget != nothing 
            push!(array, widget)
        end
    end
    # Return 2 dimensional array for column output
    return reshape(array, 1, length(array))
end
end
@require AxisArrays begin
make_widgets(xs::AxisArray, label...) = nothing
end
@require StaticArrays begin
make_widgets(xs::FieldVector, label...) = begin
    names = string.(fieldnames(xs))
    [make_widgets(x, n) for (x, n) in zip(xs, names)]
end
end


"""
    make_plottables(x, label)

Generate 'plottable' toggles recursively, with optional label.
"""
function make_plottables end

make_plottables(x::Associative, label...) = begin
    dict = OrderedDict()
    for key in keys(x)
        field = x[key]
        widget = make_plottables(field, string(key))
        if widget != nothing 
            dict[key] = widget 
        end
    end
    return length(keys(dict)) > 0 ? dict : nothing
end
make_plottables(x::Any, label...) = begin
    dict = OrderedDict()
    if length(fieldnames(x)) > 0
        for name in fieldnames(x)
            field = getfield(x, name)
            widget = make_plottables(field, string(name))
            if widget != nothing 
                dict[name] = widget 
            end
        end
    end
    return length(keys(dict)) > 0 ? dict : nothing
end
make_plottables(xs::Tuple) = make_plottables(xs, "unknown")
make_plottables(xs::Tuple, label) = begin
    labels = [string(label, n) for n = 1:length(xs)]
    widgets = tuple(make_plottables.(xs, labels)...)
    if all(w -> w == nothing, widgets)
        return nothing
    else
        return widgets
    end
end
@require DataFrames begin
make_plottables(x::DataFrame, label...) = begin
    labels = []
    values = []
    for name in names(x)
        field = x[name]
        widget = make_widgets(false, string(name))
        if widget != nothing 
            push!(labels, name) 
            push!(values, widget) 
        end
    end
    # Return 2 dimensional array for column output
    return AxisArray(reshape(values, 1, length(values)), 
                     Axis{:row}([:row]), Axis{:col}(labels))
end
end
@require AxisArrays begin
make_plottables(xs::AxisArray, label...) = make_toggles(xs)
end
# Arrays get a toggle to control subplots 
make_plottables(x::Vector, label) = 
    if length(x) >= defaults[:minlen_plottable_array]
        make_widgets(false, label)
    end


@require AxisArrays begin
make_toggles(x::A) where A<:AxisArray = begin
    a = [[string(a[i]) for i in 1:length(a)] for a in axes(x)]
    num_axes = length(a)
    if num_axes == 2
        return make_toggles(a[1])
    elseif num_axes == 3
        return make_toggles(a[1], a[2])
    else
        return nothing
    end
end
end
@require StaticArrays begin
make_toggles(x::FieldVector) = make_toggles(fieldnames(x))
end
make_toggles(colnames::AbstractArray) = 
    [togglebutton(string(colnames[c])) for c = 1:length(colnames)]
make_toggles(rownames::AbstractArray{String}, colnames::AbstractArray{String}) = begin
    rows = length(rownames)
    cols = length(colnames)
    return [togglebutton(join([string(rownames[r]), string(colnames[c])], ",")) for r = 1:rows, c = 1:cols]
end



"""
    make_interface(xs; box)

Interfaces are build recursively from any type containing widgets. This
mostly means anything returned by make_widgets, but also after having any
sub-components deleted custom components added:
"""
make_interface(xs::Tuple; box = get_box(xs)) = box(make_interface.(xs)...)

make_interface(xs::AbstractVector{Interact.Slider{T}}; box = get_box(xs)) where T =
    spreadwidgets(make_interface.(xs); cols = 2)
make_interface(xs::AbstractVector{Interact.ToggleButton}; box = get_box(xs)) = 
    box(make_interface.(xs)...)
make_interface(xs::AbstractArray{T,1}; box = get_box(xs)) where T = 
    spreadwidgets(make_interface.(xs); cols = 2)
make_interface(xs::AbstractArray{T,2}; box = get_box(xs)) where T = arrange_columns(xs; box = box)
make_interface(x::Interact.Widget; box = get_box(x)) = x
@require DataStructures begin
make_interface(x::OrderedDict{Any,Interact.Slider{T}}; box = get_box(x)) where T = begin
    widgets = []
    for (key, val) in x
        if val != nothing
            push!(widgets, make_interface(val))
        end
    end
    return spreadwidgets(widgets; cols = 3)
end
make_interface(x::OrderedDict; box = get_box(x)) = begin
    widgets = []
    for (key, val) in x
        if val != nothing
            push!(widgets, make_interface(val))
        end
    end
    return box(widgets...)
end
end

function arrange_columns(xs; box = get_box(xs)) 
    columns = []
    for col in 1:size(xs, 2)
        push!(columns, vbox(make_interface.(xs[:,col])...))
    end
    return box(columns...)
end


"""
    spreadwidgets(widgets; cols = 6)

Create multiple columns to spread widgets accross a page
"""
function spreadwidgets(widgets; cols = 6)
    vboxes = []
    widget_col = []
    colsize = ceil(Int,length(widgets)/cols)
    # Build vbox columns for widgets
    for i = 1:length(widgets)
        push!(widget_col, widgets[i])
        if rem(i, colsize) == 0
            push!(vboxes, vbox(widget_col...))
            widget_col = []
        end
    end

    # Push remaining widgets
    push!(vboxes, vbox(widget_col...))
    return hbox(vboxes...)
end
