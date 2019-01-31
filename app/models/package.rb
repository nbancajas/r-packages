class Package < ApplicationRecord
  has_many :versions, class_name: "PackageVersion"

  belongs_to :latest_version, class_name: "PackageVersion", optional: true
end
