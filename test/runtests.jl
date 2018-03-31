using AutoInteract
using Interact
using Plots
using Base.Test
using Interact.update_view


# TODO: properly test AxisArrays and other complex implementations.

function mocktoggle(value, label)
    widget = togglebutton(label, value = value)
    widget.signal.name = label * "_toggle"
    return widget
end

function mockslider(value, label, range)
    widget = slider(range, value = value, label = label)
    widget.signal.name = label * "_slider"
    return widget
end

# Override update method to do nothing on push!
Interact.update_view(::Any) = nothing 

# Signal numbers will be different every time, so we compare properties
function compare_slider(widget1, widget2)
    @test widget1.label == widget2.label
    @test widget1.value == widget2.value
    @test widget1.range == widget2.range
    @test widget1.orientation == widget2.orientation
    @test widget1.signal.name == widget2.signal.name
end

function compare_toggle(widget1, widget2)
    @test widget1.label == widget2.label
    @test widget1.value == widget2.value
    @test widget1.signal.name == widget2.signal.name
end

# Test components to escape circular references
function compare_layouts(l1, l2)
    isequal(l1.layout.box.children, l2.layout.box.children)
    isequal(l1.layout.box.vert, l2.layout.box.vert)
    isequal(l1.vert, l2.vert)
end

mutable struct teststruct
    a::Array{Float64}
    b::Bool
    i::Int
    f::Float64
end

@testset "interface" begin
    @testset "interface from Float64" begin
        ref_slider = mockslider(1.0, "Float64", 0.0:0.02:2.0)
        slider = make_widgets(1.0, "Float64")
        compare_slider(ref_slider, slider)
        # Interface
        iface = make_interface(slider)
        # No vboxes are added for single sliders
        ref_iface = slider
        compare_slider(ref_iface, iface)
    end

    @testset "interface from Bool" begin
        ref_toggle = mocktoggle(true, "Bool")
        toggle = make_widgets(true, "Bool")
        compare_toggle(ref_toggle, toggle)
        # Interface
        iface = make_interface(toggle)
        # No vboxes are added for single sliders
        ref_iface = toggle
        compare_toggle(ref_iface, iface)
    end

    @testset "interface from Int" begin
        # Positive
        ref_slider = mockslider(1, "Int", 0:1:2)
        slider = make_widgets(1, "Int")
        compare_slider(ref_slider, slider)
        # Negative
        ref_slider = mockslider(-2, "Int", -4:1:0)
        slider = make_widgets(-2, "Int")
        compare_slider(ref_slider, slider)
        # Custom range
        ref_slider = mockslider(9, "Int", -99:9:99)
        slider = make_widgets(9, "Int", -99:9:99)
        compare_slider(ref_slider, slider)

        # Interface
        iface = make_interface(slider)
        # No vboxes are added for single sliders
        ref_iface = slider
        compare_slider(ref_iface, iface)
    end

    @testset "interface from tuple" begin
        ref_sliders = mockslider.((1.0, 2.0, 3.0), ("unknown1", "unknown2", "unknown3"), (0.0:0.02:2.0, 0.0:0.04:4.0, 0.0:0.06:6.0))
        sliders = make_widgets((1.0, 2.0, 3.0))
        compare_slider.(ref_sliders, sliders)
        iface = make_interface(sliders)
        ref_iface = vbox(sliders...)
    end

    @testset "Arrays are ignored" begin
        ref_sliders = nothing
        sliders = make_widgets([1.0, 2.0, 3.0])
        @test ref_sliders == sliders
    end

    @testset "interface from struct" begin
        data = teststruct([1.0,2.0,3.0], true, 10, 10.0)
        b = mocktoggle(true, "b") 
        i = mockslider(10, "i", 0:1:20)
        f = mockslider(10.0, "f", 0.0:0.2:20.0)
        widgets = make_widgets(data)
        @test collect(keys(widgets)) == [:b, :i, :f]
        compare_toggle(b, widgets[:b])
        compare_slider(i, widgets[:i])
        compare_slider(f, widgets[:f])

        iface = make_interface(widgets)
        ref_iface = vbox(widgets[:b], widgets[:i], widgets[:f])

        # Test components to escape circular references
        isequal(iface.layout.box.children, ref_iface.layout.box.children)
        isequal(iface.layout.box.vert, ref_iface.layout.box.vert)
        isequal(iface.vert, ref_iface.vert)
    end

end

@testset "plottables" begin
    plotly()
    array = collect(1.0:100.0)
    data = teststruct(array, true, 10, 10.0)
    b = mocktoggle(true, "b") 
    i = mockslider(10, "i", 0:1:21)
    f = mockslider(10.0, "f", 0.0:0.2:20.0)
    plottables = make_plottables(data)
    signals = get_signals(plottables)


    @testset "Plottable heriarchy only contains plottables objects" begin
        @test collect(keys(plottables)) == [:a]
    end

    @testset "Signals are initially false" begin
        @test signals.value == Dict(:a => false)
    end

    @testset "No plots if plottables signals are false" begin
        @test typeof(plot_all(data, signals.value, 1:100)) == Void
    end

    @testset "Plots an array if its signal is true" begin
        signals.value[:a] = true
        p = plot_all(data, signals.value, 1:100)
        @test length(p.subplots) == 1
        @test p.subplots[1].series_list[1].d[:y] == array
    end
end


@testset "can apply modified signals back to data" begin
    data = teststruct([1.0,2.0,3.0], true, 10, 10.0)
    widgets = make_widgets(data)
    signals = get_signals(widgets)

    @testset "initial values are correct" begin
        @test data.b == true
        @test data.i == 10
        @test data.f == 10.0
    end

    push!(widgets[:b].signal, false)
    push!(widgets[:i].signal, 99)
    push!(widgets[:f].signal, 99.9)
    sleep(0.01) # Wait for async updates
    apply_signals!(data, signals.value)

    @testset "updates have been aplied" begin
        @test data.b == false
        @test data.i == 99
        @test data.f == 99.9
    end
end
