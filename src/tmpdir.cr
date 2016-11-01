require "file_utils"

lib LibC
  fun mkstemp(x0 : Char*) : Int
  fun mkdtemp(template : Char*) : Char*
end

class Dir
  # Creates a new temporary directory
  #
  # ```
  # Dir.mktmpdir # => "/tmp/c.a56b2F"
  # ```
  def self.mktmpdir(prefix = "c")
    tmp_dir = File.join(Dir.tmpdir, "#{prefix}.XXXXXX")

    fileno = LibC.mkdtemp(tmp_dir)
    if fileno == nil
      raise Errno.new("mkdtemp")
    end

    tmp_dir
  end

  # Creates a new temporary directory within the lifecycle
  # of the given block and destroys it, and its content, later on.
  #
  # ```
  # Dir.mktmpdir do |dir|
  #   puts dir
  # => "/tmp/c.a56b2F"
  # end
  # ```
  def self.mktmpdir(prefix = "c", &block)
    tmp_dir = Dir.mktmpdir(prefix)
    begin
      yield tmp_dir
    ensure
      FileUtils.rm_r(tmp_dir)
    end

    tmp_dir
  end

  # Returns the tmp dir
  #
  # ```
  # Dir.tmpdir # => "/tmp"
  # ```
  def self.tmpdir : String
    unless tmpdir = ENV["TMPDIR"]?
        tmpdir = "/tmp"
    end

    tmpdir
  end
end

class Tempfile < IO::FileDescriptor
  def initialize(name)
    @path = File.join(Dir.tmpdir, "#{name}.XXXXXX")
    fileno = LibC.mkstemp(@path)
    if fileno == -1
      raise Errno.new("mkstemp")
    end
    super(fileno, blocking: true)
  end
end
