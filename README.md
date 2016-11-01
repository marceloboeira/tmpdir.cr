# tmpdir.cr
> [Temporary Monkey Patch](https://github.com/crystal-lang/crystal/pull/2911) solution to create temporary directories with Crystal

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  tmpdir:
    github: marceloboeira/tmpdir.cr
```

## Usage

Require the library

Then:

Without prefix:

```crystal
require "tmpdir"

puts Dir.mktmpdir
# => /tmp/c.a39bF4
```

With prefix:

```crystal
require "tmpdir"

puts Dir.mktmpdir("foo")
# => /tmp/foo.a39bF4
```

Within a block:
```crystal
require "tmpdir"

Dir.mktmpdir("foo") do |tmp_dir|
  puts tmp_dir
  # => /tmp/foo.a39bF4
end

# tmp_dir does not exists anymore
```

The solution uses the `LibC.mkdtemp` bind. 
The mkdtemp function creates a directory with a unique name. If it
succeeds, it overwrites template with the name of the directory, and
returns template. As with mktemp and mkstemp, template should be a
string ending with ‘XXXXXX’.

Reference:
- http://www.gnu.org/software/libc/manual/html_node/Temporary-Files.html
