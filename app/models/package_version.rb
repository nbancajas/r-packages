class PackageVersion < ApplicationRecord
  belongs_to :package

  has_many :contributor_package_versions
  has_many :contributors, through: :contributor_package_versions

  def maintainer
    @maintainer ||= contributors.where("contributors_package_versions.role = ?", "maintainer").first
  end

  def authors
    @authors ||= contributors.where("contributors_package_versions.role = ?", "author")
  end
end
