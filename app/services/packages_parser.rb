class PackagesParser
  attr_reader :packages_path

  def initialize
    @packages_path = Rails.root.join("lib/packages/PACKAGES")
  end

  def perform
    FastDcf.parse(contents)
  end

  private

  def contents
    IO.read(packages_path)
  end
end
