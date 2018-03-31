const deflayout = Plots.EmptyLayout(height=:auto, width=:auto)

plot_all(data, plottables, range, label...) = begin
    plots = []
    plot_all!(plots, data, plottables, range, label)
    num_plots = length(plots)
    if num_plots > 0
        row_layout = Plots.GridLayout(num_plots, 1)
        return plot(plots..., layout=row_layout)
    else
        return nothing
    end
end

plot_all!(plots, data::Associative, plottables::Associative, range, label...) =
    for key in keys(plottables)
        plot_all!(plots, data[key], plottables[key], range, key)
    end
plot_all!(plots, data::Any, plottables::Associative, range, label...) =
    for key in keys(plottables)
        plot_all!(plots, getfield(data, key), plottables[key], range, key)
    end
plot_all!(plots, data::Tuple, plottables::Tuple, range, label...) =
    for i in 1:length(data)
        plot_all!(plots, data[i], plottables[i], range)
    end
plot_all!(plots, data::AxisArray{T,2}, plottables::AbstractArray, range, label...) where T = begin
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
plot_all!(plots, data::AxisArray{T,3}, plottables::AbstractArray, range, label...) where T = begin
    p = plot()
    plotted = false
    labels1 = axes(data)[1]
    labels2 = axes(data)[2]
    rows = length(data[:, 1, 1])
    cols = length(data[1, :, 1])
    for i = 1:rows
        for j = 1:cols
            if plottables[i, j]
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
plot_all!(plots, data::DataFrame, plottables, range, label...) = begin
    p = plot()
    plotted = false
    for (i, n) in enumerate(names(data))
        if plottables[i]
            plot!(p, data[n][range], label=n, layout=deflayout)
            plotted = true
        end
    end
    if plotted
        push!(plots, p)
    end
end
end
plot_all!(plots, data, plottables::Bool, range, label...) = begin
    if !plottables || length(data) < (range.stop)
        return 
    end

    if length(label) > 0
        push!(plots, plot(data[range], label = label[1]))
    else
        push!(plots, plot(data[range]))
    end
end
