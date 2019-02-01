class PackagesParser
  class << self
    def perform
      get_packages do |contents|
        FastDcf.parse(contents).first(ENV['PACKAGES_COUNT'].to_i)
      end
    end

    private

    def url
      @url ||= File.join(ENV['CRAN_HOST'], "PACKAGES")
    end

    def get_packages
      #yield IO.read(Rails.root.join("lib/packages/PACKAGES"))
      yield HTTParty.get(url).body
    end
  end
end
