class RenamePackageLatestVersionToVersion < ActiveRecord::Migration[5.2]
  def change
    rename_column :packages, :latest_version, :version
  end
end
