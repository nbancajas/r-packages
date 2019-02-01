class UpdatePackagesDescriptionWorker
  include Sidekiq::Worker

  def perform(packages_hash)
    packages_hash.each do |key, value|
      update_package_metadata(key, value.to_s)
    end
  end

  private

  def update_package_metadata(name, version)
    package = Package.find_by(name: name)
    package_version = PackageVersion.find_or_create_by(package: package, version: version)

    return if package_version.title.present?

    description_content = RemotePackage.new(name, version).description_contents
    description = RemotePackageDescription.new(description_content)

    #puts "****************************************"
    #puts description_content
    #puts "****************************************"

    package_version.update(
      publication_date: description.publication_date,
      title:            description.title,
      description:      description.description
    )

    persist_contributors(package_version, description)
  end

  def persist_contributors(package_version, description)
    maintainer = description.maintainer.yield_self do |maintainer|
      contributor = Contributor.find_or_create_by(name: maintainer.full_name, email: maintainer.email)
      contributor
    end

    ContributorPackageVersion.find_or_create_by(package_version: package_version, contributor: maintainer, role: 'maintainer')

    description.authors.each do |author_name|
      author = Contributor.find_or_create_by(name: author_name)
      ContributorPackageVersion.find_or_create_by(package_version: package_version, contributor: author, role: 'author')
    end
  end
end
