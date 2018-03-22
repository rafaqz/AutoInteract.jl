using AutoInteract
using Base.Test

# TODO: properly test AxisArrays and other complex implementations.

function testtoggle(value, label)
    widget = togglebutton(label, value = value)
    widget.signal.name = label * "_toggle"
    return widget
end

function testslider(range, value, label)
    widget = slider(range, value = value, label = label)
    widget.signal.name = label * "_slider"
    return widget
end

# Signal numbers will be different every time, so we compare properties
function compare_slider(widget1, widget2)
    @test widget1.label == widget2.label
    @test widget1.value == widget2.value
    @test widget1.range == widget2.range
    @test widget1.orientation == widget2.orientation
    @test widget1.signal.name == widget2.signal.name
end

function compare_layouts(l1, l2)
    # Test components to escape circular references
    isequal(l1.layout.box.children, l2.layout.box.children)
    isequal(l1.layout.box.vert, l2.layout.box.vert)
    isequal(l1.vert, l2.vert)
end

function compare_togglebutton(widget1, widget2)
    @test widget1.label == widget2.label
    @test widget1.value == widget2.value
    @test widget1.signal.name == widget2.signal.name
end

mutable struct teststruct
    a::Array{Float64}
    b::Bool
    i::Int
    f::Float64
end

@testset "interface from struct" begin
    testdata = teststruct([1.0,2.0,3.0], true, 10, 10.0)
    b = testtoggle(true, "b") 
    i = testslider(0:1:21, 10, "i")
    f = testslider(0.0:0.2:20.0, 10.0, "f")
    test_widgets = make_widgets(testdata)
    @test collect(keys(test_widgets)) == [:b, :i, :f]
    compare_togglebutton(b, test_widgets[:b])
    compare_slider(i, test_widgets[:i])
    compare_slider(f, test_widgets[:f])

    test_iface = make_interface(test_widgets)
    ref_iface = vbox(test_widgets[:b], test_widgets[:i], test_widgets[:f])
    # Test components to escape circular references
    isequal(test_iface.layout.box.children, ref_iface.layout.box.children)
    isequal(test_iface.layout.box.vert, ref_iface.layout.box.vert)
    isequal(test_iface.vert, ref_iface.vert)

    signals = get_signals(test_widgets)
    apply_all(testdata, signals.value)
end

@testset "plottable" begin
    array = collect(1.0:100.0)
    testdata = teststruct(array, true, 10, 10.0)
    b = testtoggle(true, "b") 
    i = testslider(0:1:21, 10, "i")
    f = testslider(0.0:0.2:20.0, 10.0, "f")
    test_plottable = make_plottable(testdata)
    signals = get_signals(test_plottable)

    @testset "Plottable heriarchy only contains plottable objects" begin
        @test collect(keys(test_plottable)) == [:a]
    end

    @testset "Signals are initially false" begin
        @test signals.value == Dict(:a => false)
    end

    @testset "No plots if plottable signals are false" begin
        @test typeof(plot_all(testdata, signals.value, 1:100)) == Void
    end

    @testset "Plots array if signal is true" begin
        signals.value[:a] = true
        p = plot_all(testdata, signals.value, 1:100)
        @test length(p.subplots) == 1
        @test p.subplots[1].series_list[1].d[:y] == array
    end
end

@testset "interface from tuple" begin
    ref_sliders = testslider.((0.0:0.02:2.0, 0.0:0.04:4.0, 0.0:0.06:6.0), (1.0, 2.0, 3.0), ("unknown1", "unknown2", "unknown3"))
    test_sliders = make_widgets((1.0, 2.0, 3.0))
    compare_slider.(ref_sliders, test_sliders)
    test_iface = make_interface(test_sliders)
    ref_iface = vbox(test_sliders...)
end



