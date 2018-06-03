var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#AutoInteract-1",
    "page": "Introduction",
    "title": "AutoInteract",
    "category": "section",
    "text": "The main use of AutoInteract is to build widgets, extract signals from them,  and apply them back to data from a live interface. These steps all maintain a similar structure to the original data so that it can all be automated."
},

{
    "location": "index.html#AutoInteract.make_widgets",
    "page": "Introduction",
    "title": "AutoInteract.make_widgets",
    "category": "function",
    "text": "make_widgets(x, label)\n\nWidets are built recursively from any type, labelled using the dict or struct  label, AxisArray names, etc. \n\nThey can then be edited before retrieving signals and building an interface.\n\n\n\n"
},

{
    "location": "index.html#Widgets-1",
    "page": "Introduction",
    "title": "Widgets",
    "category": "section",
    "text": "make_widgets"
},

{
    "location": "index.html#AutoInteract.make_interface",
    "page": "Introduction",
    "title": "AutoInteract.make_interface",
    "category": "function",
    "text": "make_interface(xs; box)\n\nInterfaces are build recursively from any type containing widgets. This mostly means anything returned by make_widgets, but also after having any sub-components deleted custom components added:\n\n\n\n"
},

{
    "location": "index.html#Interface-1",
    "page": "Introduction",
    "title": "Interface",
    "category": "section",
    "text": "make_interface"
},

{
    "location": "index.html#AutoInteract.get_signals",
    "page": "Introduction",
    "title": "AutoInteract.get_signals",
    "category": "function",
    "text": "get_signals(x)\n\nSignals can be recursively retrieved from any type containing widgets.\n\n\n\n"
},

{
    "location": "index.html#AutoInteract.apply_signals!",
    "page": "Introduction",
    "title": "AutoInteract.apply_signals!",
    "category": "function",
    "text": "apply_signals!(data, signal)\n\nSignals can be recursively applied back to data.\n\n\n\n"
},

{
    "location": "index.html#Signals-1",
    "page": "Introduction",
    "title": "Signals",
    "category": "section",
    "text": "get_signalsapply_signals!"
},

{
    "location": "index.html#AutoInteract.make_plottables",
    "page": "Introduction",
    "title": "AutoInteract.make_plottables",
    "category": "function",
    "text": "make_plottables(x, label)\n\nGenerate \'plottable\' toggles recursively, with optional label.\n\n\n\n"
},

{
    "location": "index.html#AutoInteract.plot_all",
    "page": "Introduction",
    "title": "AutoInteract.plot_all",
    "category": "function",
    "text": "plot_all(data, plottables, [label])\n\nPlot all data for selected plottables.\n\n\n\n"
},

{
    "location": "index.html#AutoInteract.plot_all!",
    "page": "Introduction",
    "title": "AutoInteract.plot_all!",
    "category": "function",
    "text": "plot_all!(plots, data, plottables, label)\n\nRecursive plotting methods for (almost) all types.\n\n\n\n"
},

{
    "location": "index.html#Plottables-and-plotting-1",
    "page": "Introduction",
    "title": "Plottables and plotting",
    "category": "section",
    "text": "AutoInteract also generates an interface for plotting arbitrary data in an interface. \'Plottables\' are structured objects containing toggle-button widgets indicating if any data can be plotted. Mostly this means it inherits AbstractArray, or it is the last dimension of an AxisArray, with a grid of named toggle-buttons being made for the other dimensions. Signals from plottables can be plotted with plot_all().make_plottablesplot_allplot_all!"
},

{
    "location": "index.html#AutoInteract.set_defaults",
    "page": "Introduction",
    "title": "AutoInteract.set_defaults",
    "category": "function",
    "text": "set_defaults(args...)\n\nSet global defaults to control behaviour.\n\nExamples\n\nset_defaults(:maxlen_slider_array => 10, \n             :minlen_plot_array => 10,\n             :missing_label => \"List\"\n            )\n\n\n\n"
},

{
    "location": "index.html#Customisation-API-1",
    "page": "Introduction",
    "title": "Customisation API",
    "category": "section",
    "text": "set_defaultssteprangebox"
},

{
    "location": "index.html#AutoInteract.spreadwidgets",
    "page": "Introduction",
    "title": "AutoInteract.spreadwidgets",
    "category": "function",
    "text": "spreadwidgets(widgets; cols = 6)\n\nCreate multiple columns to spread widgets accross a page\n\n\n\n"
},

{
    "location": "index.html#Misc-1",
    "page": "Introduction",
    "title": "Misc",
    "category": "section",
    "text": "spreadwidgets"
},

]}
