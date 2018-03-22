# Recursively apply a nested signal output to any type

apply_all(data::Associative, signal::Associative) = begin
    for key in keys(signal) 
        data[key] = apply_all(data[key], signal[key]) 
    end
    return data
end
apply_all(data::Tuple, signal::Tuple) = apply_all.(data, signal)
@require StaticArrays begin
apply_all(data::FieldVector, signal) = data .= signal
end
@require MechanisticModels begin
apply_all(data::ParamSpec, signal::Float64) = 
    ParamSpec(data.id, data.unit, signal, data.range, data.flags, data.description)
end
apply_all(data, signal::Associative) = begin
    for key in keys(signal) 
        setfield!(data, key, apply_all(getfield(data, key), signal[key]))
    end
    return data
end
apply_all(data, signal) = signal
