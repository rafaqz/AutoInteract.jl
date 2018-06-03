const deflayout = Plots.EmptyLayout(height=:auto, width=:auto)


"""
    plot_all(data, plottables, [label])

Plot all data for selected plottables.
"""
function plot_all end

plot_all(data, plottables) =  plot_all(data, plottables, "")
plot_all(data, plottables, label) = begin
    plots = []
    plot_all!(plots, data, plottables, label)
    num_plots = length(plots)
    if num_plots > 0
        row_layout = Plots.GridLayout(num_plots, 1)
        return plot(plots..., layout=row_layout)
    else
        return nothing
    end
end

"""
    plot_all!(plots, data, plottables, label)

Recursive plotting methods for (almost) all types.
"""
function plot_all! end

plot_all!(plots, data::Associative, plottables::Associative, label...) =
    for key in keys(plottables)
        plot_all!(plots, data[key], plottables[key], key)
    end
plot_all!(plots, data::Any, plottables::Associative, label...) = begin
    if haskey(plottables, :__data)
        index
        for key in keys(plottables)
            p = plot()
            data_plot!(p, getfield(data, key), plottables[key], key)
            push!(plots, p)
        end
    else
        for key in keys(plottables)
            plot_all!(plots, getfield(data, key), plottables[key], key)
        end
    end
end
plot_all!(plots, data::Tuple, plottables::Tuple, label...) =
    for i in 1:length(data)
        plot_all!(plots, data[i], plottables[i])
    end
plot_all!(plots, data::AxisArray{T,2}, plottables::AbstractArray, label...) where T = begin
    p = plot()
    labels = axes(data)[1]
    for i = 1:length(data[:, 1])
        plotit!(p, data, data[i, :], labels[i])
    end
    push_if_plotted!(plots, p)
end
plot_all!(plots, data::AxisArray{T,3}, plottables::AbstractArray, label...) where T = begin
    p = plot()
    labels1 = axes(data)[1]
    labels2 = axes(data)[2]
    rows = length(data[:, 1, 1])
    cols = length(data[1, :, 1])
    for i = 1:rows
        for j = 1:cols
            if plottables[i, j]
                l = string(labels1[i], ",", labels2[j])
                plotit!(p, data, data[i, j, :], l)
            end
        end
    end
    push_if_plotted!(plots, p)
end
@require DataFrames begin
    plot_all!(plots, data::DataFrame, plottables, label...) = begin
        p = plot()
        for (i, n) in enumerate(names(data))
            if plottables[i]
                plotit!(p, data, data[n], n)
            end
        end
        push_if_plotted!(plots, p)
    end
end
plot_all!(plots, data, plottables::Bool, label...) = begin
    if !plottables return end

    p = plot()
    if length(label) > 0
        l = label[1]
    else
        l = ""
    end
    plotit!(p, data, data, l)
    push_if_plotted!(plots, p)
end

data_plot!(p, data, plottables::Associative, keys) = begin
    for key in keys(plottables)
        data_plot!(p, data, plottables[key], (keys..., key))
    end
end
data_plot!(p, data, plottables::Bool, keys) = begin
    if plottables
        plotit!(p, data, [recursive_getfield(data, keys) for i in length(data)], keys[end])
    end
end

recursive_getfield(data, keys) = 
    recursive_getfield(getfield(data, keys[1]), Base.tail(keys))   
recursive_getfield(data, keys::Tuple{}) = data


"""
Return the intersect of the array range and the default plotting range. 
"""
inbounds_range(data) = intersect(1:length(data), defaults[:plot_range])

"""
If it isn't empty push a plot to an array of plots,
"""
push_if_plotted!(plots, p) = if p.n > 0 push!(plots, p) end
