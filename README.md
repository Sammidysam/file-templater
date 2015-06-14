# File Templater

File Templater was created out of my inability to find a program that takes a single ERB template, or a folder full of some files and some ERB templates, and copies them to the current directory, executing the templates and removing the `.erb` from the extensions.
It is very possible that such a program existed already, but I was just incapable of finding it.
One of the closest projects I found did not have much of a command-line interface and was last updated in 2009.
The other really close project was not a gem and did not allow quite as much complexity as I would hope for.
I was looking for a simpler system that still allowed for a high level of complexity.

## Quick Usage Example

```bash
$ template -t gem # loads template gem into current directory
$ template -t gem rails # does same as previous line, but passes an argument "rails" to the gem template binding
$ template -t gem -m # does not evaluate the template gem, but copies the source into the current directory
$ template -c gem # copies the template gem source and its corresponding binding into the current directory
$ template -a c -b c.rb # adds the template c (probably a directory, but could be a file) into the template directory, as well as a corresponding binding c.rb into the binding directory
$ template -r c # removes the template c and/or the binding c.rb
$ template -l # lists the templates and bindings that are saved and able to be used
```

## File Structure

When you run File Templater for the first time, it creates some files in order to store templates and bindings.
The folders it creates are `~/.templater`, `~/.templater/bindings`, and `~/.templater/templates`.
As is probably expected, binding files are saved into `~/.templater/bindings` and template folders or files are saved into `~/.templater/templates`.

## Command-Line Interface

File Templater is best used with the command-line, but the binary file is made to be as compact as possible in case you wish to use it from a Ruby shell.
The binary file is named `template`.
If this conflicts with any other program, do open an issue, as I am willing to change it.
For me at least, it conflicts with nothing.
The command-line interface allows for the standard switches for help and displaying the version, `-h`, `--help`, `-v`, and `--version`, as well as seven other custom switches.

`-t` is used to load a template to be loaded into the current directory.
It expects only a single argument of the name of the template to load.
If you want to load multiple templates, you will need to run the program multiple times.
If the template is a file, the file will be copied into the current directory.
If the template is a folder, the contents of the folder, but not the folder itself, will be copied into the current directory.

`-a` is used to add a template to the templates directory.
Files or folders can be added using this switch.
It can take a single argument or multiple arguments, and files and folders being added are expected to be in the current directory.

`-b` is used to add a binding to the bindings directory.
A file ending in `.rb` is expected as the argument, though a list of files can be given as well.
To be used with a template, the file name minus the extension must match the template folder name or template file name minus its extension **exactly**.
If the names do not match, the binding will not be loaded for use with the template source, which could cause errors upon loading the template.
As well as that, the class name inside of the binding file must follow the UpperCamelCase conventions.
For more information about formats of binding files, read the bindings section below.

`-r` removes the template and/or the binding of the given argument or list of arguments.
The `.rb` extension will be automatically added to the argument(s) when finding the binding file.
So, if you have a lone binding `hi.rb` sitting around, you can remove it with `template -r hi`.

`-l` lists all of the templates and bindings, as well as indicates whether a template or binding does not have a match.
This can be useful for debugging name mismatches.
The list return will be sorted alphabetically to better help determine what is wrong.

`-m` prevents modifying the template source.
The `.erb` extensions will not be removed from the resulting files either.
This is useful for loading a template that contains ERB code.

`-c` will copy a template and binding of its argument or a list of arguments to the current directory.
This is useful for editing a template; you can copy it with `-c`, make modifications, remove it from the directory with `-r`, then add it again with `-a` and `-b`.
Rather than when loading a template, this command will copy the template directory, not its contents, into the current directory.
Note that the binding file will contain more code that you inputted it as, as code will be added to the binding file as you are adding it.
See the binding section below to see what code is added.

## Bindings

Nothing special needs to be added to a binding file, as the program will automatically add the necessary repetitive code to the file to make it work within the program better.
The constructor of the binding file will be passed the arguments that are passed to the program without any switches.
This allows for command-line arguments changing the outputs of templates.
An example of a binding file is below.

```ruby
class Gem
	def initialize(name)
		@name = name.capitalize
	end
end
```

Then, when you load the template `gem`, you can use the variable `@name` in your templates.

When a binding file like this is added, the code is changed to make it function within the program better.
The entire code is wrapped within a `module Bindings` at the beginning and the corresponding `end` at the end, and the class statement goes from `class X` to `class X < Binding`, with `X` changing to be the name of the class.
The `Binding` class handles adding a `get_binding` method to all of the binding classes, which allows what ERB wants to handle to be retrieved easily.
Putting all of the binding classes within a module simply prevents as many naming conflicts when the classes are loaded.
