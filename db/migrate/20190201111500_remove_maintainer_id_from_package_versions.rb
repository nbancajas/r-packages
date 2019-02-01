class RemoveMaintainerIdFromPackageVersions < ActiveRecord::Migration[5.2]
  def up
    remove_column :package_versions, :maintainer_id
  end

  def down
    add_column :package_versions, :maintainer_id, :integer, index: true
    add_foreign_key :package_versions, :contributors, column: :maintainer_id
  end
end
