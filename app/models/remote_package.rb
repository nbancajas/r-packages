require 'rubygems/package'
require 'dcf'

class RemotePackage
  attr_reader :name, :version

  def initialize(name, version)
    @name    = name
    @version = version

    self
  end

  def url
    @url ||= File.join(ENV['CRAN_HOST'], "#{name}_#{version}.tar.gz")
  end

  def description_contents
    get_tarball do |tarball|
      ungzip(tarball) do |tar_contents|
        get_description_file(tar_contents) do |description_file|
          return (FastDcf.parse(description_file).first rescue Dcf.parse(description_file).first)
        end
      end
    end
  end

  private

  def get_description_file(tar_contents)
    Gem::Package::TarReader.new(tar_contents) do |tar|
      yield tar.detect { |tf| tf.full_name.include?('DESCRIPTION') }.read
    end
  end

  def get_tarball
    HTTParty.get(url).body.tap { |body| yield StringIO.new(body) }
  end

  def ungzip(tarball)
    z = Zlib::GzipReader.new(tarball)
    unzipped = StringIO.new(z.read)
    z.close
    yield unzipped
  end
end
