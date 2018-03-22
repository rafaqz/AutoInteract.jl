const deflayout = Plots.EmptyLayout(height=:auto, width=:auto)

plot_all(data, plottable, range) = begin
    plots = []
    plot_all!(plots, data, plottable, range)
    num_plots = length(plots)
    if num_plots > 0
        row_layout = Plots.GridLayout(num_plots, 1)
        return plot(plots..., layout=row_layout)
    else
        return nothing
    end
end

plot_all!(plots, data::Associative, plottable::Associative, range) =
for key in keys(plottable)
    plot_all!(plots, data[key], plottable[key], range)
end
plot_all!(plots, data::Any, plottable::Associative, range) =
for key in keys(plottable)
    plot_all!(plots, getfield(data, key), plottable[key], range)
end
plot_all!(plots, data::Tuple, plottable::Tuple, range) =
for i in 1:length(data)
    plot_all!(plots, data[i], plottable[i], range)
end
plot_all!(plots, data::AxisArray{T,2}, plottable::AbstractArray, range) where T = begin
    p = plot()
    plotted = false
    labels = axes(data)[1]
    for i = 1:length(data[:, 1])
        plot!(p, data[i, range], label=labels[i], layout=deflayout)
        plotted = true
    end
    if plotted
        push!(plots, p)
    end
end
plot_all!(plots, data::AxisArray{T,3}, plottable::AbstractArray, range) where T = begin
    p = plot()
    plotted = false
    labels1 = axes(data)[1]
    labels2 = axes(data)[2]
    rows = length(data[:, 1, 1])
    cols = length(data[1, :, 1])
    for i = 1:rows
        for j = 1:cols
            if plottable[i, j]
                l = string(labels1[i], ",", labels2[j])
                plot!(p, data[i, j, range], label=l, layout=deflayout)
                plotted = true
            end
        end
    end
    if plotted
        push!(plots, p)
    end
end
@require DataFrames begin
plot_all!(plots, data::DataFrame, plottable, range) = begin
    p = plot()
    plotted = false
    for (i, n) in enumerate(names(data))
        if plottable[i]
            plot!(p, data[n][range], label=n, layout=deflayout)
            plotted = true
        end
    end
    if plotted
        push!(plots, p)
    end
end
end
plot_all!(plots, data, plottable::Bool, range) = begin
    if plottable 
        # if all(r  -> r <= length(data), (range.start, range.stop))
    push!(plots, plot(data[range])) end
    # end
end


