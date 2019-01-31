class PersistPackagesWorker
  attr_reader :packages, :packages_to_index

  def initialize(packages)
    @packages = packages
    @packages_to_index = {}
  end

  def perform
    packages.each_slice(100) do |batch|
      package_names = batch.map { |package| package["Package"] }

      update_already_indexed_packages(batch, package_names)
      create_unindexed_packages(batch, package_names)
    end

    # TODO: call worker to enqueue downloading, unpacking, and reading DESCRIPTION
    # SomeWorker.enqueue(packages_to_index)
  end

  private

  def update_already_indexed_packages(batch, package_names)
    indexed_packages = Package.where(name: package_names)

    indexed_packages.each do |indexed_package|
      package_entry = batch.find { |parsed_package| parsed_package["Package"] == indexed_package.name }

      # NOTE: not checking whether new version is uprade or downgrade
      #       we always assume the 'latest' available package in repository as preferred
      if package_entry["Version"] != indexed_package.version
        indexed_package.update(version: package_entry["Version"])
        latest_version = PackageVersion.find_or_create_by(package: indexed_package, version: package_entry["Version"])
        indexed_package.update(latest_version: latest_version)

        @packages_to_index[package_entry["Package"]] = package_entry["Version"]
      end
    end
  end

  def create_unindexed_packages(batch, package_names)
    indexed_packages = Package.where(name: package_names)
    unindexed_package_names = package_names - indexed_packages.map(&:name)

    batch.select { |package_entry| unindexed_package_names.include?(package_entry["Package"]) }.each do |package_entry|
      # NOTE: could be improved by batch imports, especially on first run
      package = Package.create(name: package_entry["Package"], version: package_entry["Version"])
      latest_version = PackageVersion.create(package: package, version: package_entry["Version"])
      package.update(latest_version: latest_version)

      @packages_to_index[package_entry["Package"]] = package_entry["Version"]
    end
  end
end
