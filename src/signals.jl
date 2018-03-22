get_signals(xs::Tuple) = begin
    sig_array = []
    for x in xs
        if x != nothing && x != tuple()
            sig = get_signals(x)
            if isa(sig, Signal)
                push!(sig_array, sig)
            end
        end
    end
    return map(sigs::Vararg -> sigs, map(s -> signal(s), sig_array)...)
end
get_signals(x::OrderedDict) = begin
    sigs = []
    used_keys = []
    k = keys(x)
    for key in k
        if x != nothing && x != tuple()
            sig = get_signals(x[key])
            if isa(sig, Signal)
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
# get_signals(x::Any) = begin
#   dict = OrderedDict()
#   if length(fieldnames(x)) > 0
#     for name in fieldnames(x)
#       field = get_signals(getfield(x, name))
#       if field != nothing
#         println(name)
#         println(field)
#         dict[name] = field
#       end
#     end
#     return length(dict) > 0 ? dict : nothing
#   else
#     return nothing
#   end
# end
get_signals(x::Signal) = x
get_signals(x::Interact.InputWidget) = signal(x)
get_signals(xs::AbstractArray) = 
    map(s::Vararg -> reshape([s...], size(xs)), get_signals.(xs)...)
get_signals(x::Bool) = Signal(x)
get_signals(x::Number) = Signal(x)
get_signals(x::String) = Signal(x)
get_signals(x::Symbol) = Signal(x)
