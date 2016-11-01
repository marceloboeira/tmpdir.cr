require "./spec_helper"

describe "mktmpdir" do
  it "creates the temporary directory" do
    tmp_dir = Dir.mktmpdir

    Dir.exists?(tmp_dir).should be_true
  end

  it "accepts a prefix when creating the temporary directory" do
    prefix = "foo"
    path = Dir.mktmpdir(prefix)

    Dir.exists?(path).should be_true
    (path =~ /#{prefix}/).should_not be_nil
  end

  describe "with a block" do
    it "creates the dir" do
      Dir.mktmpdir do |dir|
        Dir.exists?(dir).should be_true
      end
    end

    it "removes the dir" do
      tmp_dir = "/"

      Dir.mktmpdir do |dir|
        tmp_dir = dir
      end

      Dir.exists?(tmp_dir).should be_false
    end
  end
end
