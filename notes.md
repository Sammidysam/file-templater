# Miscellaneous notes

Make the requiring of a binding file more lazy.
Currently, if a binding has broken (such as syntax error) code, it will break the program no matter what every time it runs.
This will be bad, because a user cannot remove the binding.

When loading bindings, instead of determining the class name from file name via conventions, the program could read the class declaration of the file.
