class ContributorPackageVersion < ApplicationRecord
  self.table_name = :contributors_package_versions

  belongs_to :package_version
  belongs_to :contributor

  validates :role, presence: true, inclusion: { in: %w(maintainer author) }
end
