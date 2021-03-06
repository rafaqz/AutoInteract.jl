# AutoInteract

__There is a much better way of doing this now, like using Flatten.jl with FieldMetadata.jl to generate sliders, like this:
https://github.com/cesaraustralia/DynamicGridsInteract.jl/blob/master/src/interact.jl__

[![Build Status](https://travis-ci.org/rafaqz/AutoInteract.jl.svg?branch=master)](https://travis-ci.org/rafaqz/AutoInteract.jl)

[![codecov.io](http://codecov.io/github/rafaqz/AutoInteract.jl/coverage.svg?branch=master)](http://codecov.io/github/rafaqz/AutoInteract.jl?branch=master)

The aim of this module is to allow automatic generation of an interactive
interface for any julia type.

It also facilities interactive plotting of any AbstractArray nested anywhere in
the data.


See the [Documentation](https://rafaqz.github.io/AutoInteract.jl/latest/) for more details.


Currently AutoInteract.jl supports [Interact.jl](https://github.com/JuliaGizmos/Interact.jl)
and [Reactive.jl](https://github.com/JuliaGizmos/Reactive.jl), and 
[InteractNext.jl](https://github.com/JuliaGizmos/InteractNext.jl) in a limited
form - the layout is pretty lousy.
