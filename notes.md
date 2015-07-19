# Miscellaneous notes

`-b` command can be added back later to be similar to the `-t` command, but load a binding *other* than the default.

Make the requiring of a binding file more lazy.
Currently, if a binding has broken (such as syntax error) code, it will break the program no matter what every time it runs.
This will be bad, because a user cannot remove the binding.

Make `-r` allow being given a `.rb` so that it only removes the binding.

When loading bindings, instead of determining the class name from file name via conventions, the program could read the class declaration of the file.
