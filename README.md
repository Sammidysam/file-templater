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
The folders it creates are `~/.templater`, `~/.templater/bindings`, `~/.templater/templates`, and `~/.templater/original`.
As is probably expected, binding files are saved into `~/.templater/bindings` and template folders or files are saved into `~/.templater/templates`.
The original binding files without any modification are saved into `~/.templater/original` so that the original files can be retrieved.

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

`-b` is used to load a binding other than the default for the template loaded with `-t`.
It expects a single argument of the binding to load.
The binding name should end in `.rb`.

`-a` is used to add a template to the templates directory or a binding to the bindings directory.
When given a directory, the directory will be treated as a template and copied to the templates directory.
When given a file, the file will be treated as a binding if it ends in `.rb` and a template otherwise.
If it is treated as a template, the template will be named the file name without its extension.
If your template name plans to end in `.rb`, create a folder for it before adding it so that it is not incorrectly treated as a binding.
Read the bindings section below to learn more about acceptable rules of binding files.
This switch can take a single argument or multiple arguments, and files and folders being added are expected to be in the current directory.

`-r` removes the template or the binding of the given argument or list of arguments.
Like `-a`, this command assumes that arguments ending in `.rb` are bindings and those not are templates.
However, if a binding of the argument does not exist, the template by the same name will try to be deleted.
This allows removing templates ending in `.rb`.
To remove a template and a binding, you will need to give the `-r` two arguments similar to when using `-a`.

`-l` lists all of the templates and bindings, as well as indicates whether a template or binding does not have a match.
This can be useful for debugging name mismatches.
The list return will be sorted alphabetically to better help determine what is wrong.

`-m` prevents modifying the template source.
The `.erb` extensions will not be removed from the resulting files either.
This is useful for loading a template that contains ERB code.

`-c` will copy a template or binding of its argument or a list of arguments to the current directory.
Like `-a`, arguments ending in `.rb` will be assumed to be bindings and all else will be assumed to be templates.
However, even after assuming an argument designates a binding, if copying the binding fails it will try to fallback to a template with a `.rb` extension.
This is useful for editing a template; you can copy it with `-c`, make modifications, remove it from the loaded directory with `-r`, then add it again with `-a`.
Rather than when loading a template, this command will copy the template directory, not its contents, into the current directory.
When a binding is copied, it will be copied into the current directory.

Any arguments outside of those provided as part of a switch become passed to the binding file associated with the loaded template.
See the section on bindings below to find out more information about how using those arguments works.

## Templates

Templates can either be one file or multiple files.
The files can either be directly copied (have no `.erb` suffix) or be ERB templates (have a `.erb` suffix).
If a `.erb` suffix is present, it will be removed when the file is finished being copied and transformed.
ERB is run with a trim mode of `<>`, which means that newlines will be omitted around ERB code.
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
The value will be the capitalized version of the first argument passed to the template.
In the Quick Usage section above, when running the command `template -t gem rails`, `@name` would be equal to `Rails`.

When a binding file like this is added, the code is changed to make it function within the program better.
The entire code is wrapped within a `module Bindings` at the beginning and the corresponding `end` at the end.
A method within the class is defined, `get_binding`.
This method is used to get the context of the provided class.
Putting all of the binding classes within a module, here named `Bindings`, simply prevents as many naming conflicts when the classes are loaded.

## License

This project is licensed under the GNU General Public License version 3.
There is a license file in this repository that you can look at to learn more about the conditions.
