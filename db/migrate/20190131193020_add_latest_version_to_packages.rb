class AddLatestVersionToPackages < ActiveRecord::Migration[5.2]
  def up
    add_reference :packages, :latest_version, index: true
    add_foreign_key :packages, :package_versions, column: :latest_version_id

    Package.includes(:versions).find_each do |package|
      package.update(latest_version: package.versions.last)
    end
  end

  def down
    remove_foreign_key :packages, column: :latest_version_id
    remove_reference :packages, :latest_version
  end
end
