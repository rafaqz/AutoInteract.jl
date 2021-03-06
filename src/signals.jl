"""
    get_signals(x)

Signals can be recursively retrieved from any type containing widgets.
"""
function get_signals end

get_signals(xs::Tuple) = begin
    sig_array = []
    for x in xs
        if x != nothing && x != tuple()
            sig = get_signals(x)
            if is_usable(sig)
                push!(sig_array, sig)
            end
        end
    end
    mapsig(sig_array)
end
get_signals(x::OrderedDict) = begin sigs = []
    used_keys = []
    k = keys(x)
    for key in k
        if x != nothing && x != tuple()
            sig = get_signals(x[key])
            if is_usable(sig)
                push!(sigs, sig) 
                push!(used_keys, key) 
            end
        end
    end
    if length(sigs) > 0
        return map(s::Vararg -> OrderedDict(zip(used_keys, s)), sigs...)
    else
        return nothing
    end
end
get_signals(xs::AbstractArray) = 
    map(s::Vararg -> reshape([s...], size(xs)), get_signals.(xs)...)
@require Interact begin
    get_signals(x::Signal) = x
    get_signals(x::Interact.InputWidget) = signal(x)
    is_usable(sig) = isa(sig, Signal)
    mapsig(sig_array) = map(sigs::Vararg -> sigs, map(s -> signal(s), sig_array)...)
end
@require InteractNext begin
    get_signals(x::Observable) = x
    get_signals(x::WebIO.Scope) = observe(x)
    mapsig(sig_array) = begin
        map(sigs::Vararg -> sigs, sig_array[1], sig_array...)
    end
    is_usable(sig) = isa(sig, Observable)
end


"""
    apply_signals!(data, signal)

Signals can be recursively applied back to data.
"""
function apply_signals! end

apply_signals!(data::Associative, signal::Associative) = begin
    for key in keys(signal) 
        data[key] = apply_signals!(data[key], signal[key]) 
    end
    return data
end
apply_signals!(data::Tuple, signal::Tuple) = apply_signals!.(data, signal)
@require StaticArrays begin
apply_signals!(data::FieldVector, signal) = data .= signal
end
apply_signals!(data, signal::Associative) = begin
    for key in keys(signal) 
        setfield!(data, key, apply_signals!(getfield(data, key), signal[key]))
    end
    return data
end
apply_signals!(data, signal) = signal
