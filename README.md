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
$ template -a c,c.rb # adds the template c (probably a directory, but could be a file) into the template directory, as well as a corresponding binding c.rb into the binding directory
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
The command-line interface allows for the standard switches for help and displaying the version, `-h`, `--help`, `-v`, and `--version`, as well as six other custom switches.

`-t` is used to load a template to be loaded into the current directory.
It expects only a single argument of the name of the template to load.
If you want to load multiple templates, you will need to run the program multiple times.
If the template is a file, the file will be copied into the current directory.
If the template is a folder, the contents of the folder, but not the folder itself, will be copied into the current directory.

`-a` is used to add a template to the templates directory or a binding to the bindings directory.
When given a directory, the directory will be treated as a template and copied to the templates directory.
When given a file, the file will be treated as a binding if it ends in `.rb` and a template otherwise.
If it is treated as a template, the template will be named the file name without its extension.
If your template name plans to end in `.rb`, create a folder for it before adding it so that it is not incorrectly treated as a binding.
Read the bindings section below to learn more about acceptable rules of binding files.
This switch can take a single argument or multiple arguments, and files and folders being added are expected to be in the current directory.

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

Any arguments outside of those provided as part of a switch become passed to the binding file associated with the loaded template.
See the section on bindings below to find out more information about how using those arguments works.

## Templates

Templates can either be one file or multiple files.
The files can either be directly copied (have no `.erb` suffix) or be ERB templates (have a `.erb` suffix).
If a `.erb` suffix is present, it will be removed when the file is finished being copied and transformed.
Binding files are used to manage how data is provided to template.
Read the section about them below to learn more about them.

Files can have variable names as well.
For a file to have a variable filled in its name, include the name of the variable encapsulated by `{{}}`.
For example, if my binding provides a variable `PARTY_NAME` and I want to create a file of `PARTY_NAME` with an extension `.txt`, I would name the file within the template `{{PARTY_NAME}}.txt`.
It will then change its name based on the parameters given to the program.

## Bindings

To be used with a template, the name of the binding file without the `.rb` extension must match the template name **exactly**.
If they do not match, the binding file will not be loaded when the template file is loaded.
The name of the class within the binding file must follow UpperCamelCase conventions and must match the template name.
For example, if your template is named `jazz_combo`, your binding class will be named `JazzCombo`.

Nothing special needs to be added to a binding file before adding it with `-a`, as the program will automatically add the necessary repetitive code to the file to make it work within the program better.
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
The entire code is wrapped within a `module Bindings` at the beginning and the corresponding `end` at the end.
A method within the class is defined, `get_binding`.
This method is used to get the context of the provided class.
Putting all of the binding classes within a module, here named `Bindings`, simply prevents as many naming conflicts when the classes are loaded.
