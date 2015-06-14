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
$ template -a c -b c.rb # adds the template c (probably a directory, but could be a file) into the template directory, as well as a corresponding binding c.rb into the binding directory
$ template -r c # removes the template c and/or the binding c.rb
$ template -l # lists the templates and bindings that are loaded
```

## File Structure

When you run File Templater for the first time, it creates some files in order to store templates and bindings.
The folders it creates are `~/.templater`, `~/.templater/bindings`, and `~/.templater/templates`.
