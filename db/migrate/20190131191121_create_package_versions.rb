class CreatePackageVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :package_versions do |t|
      t.references :package
      t.string     :version
      t.date       :publication_date
      t.string     :title
      t.text       :description
      t.integer    :maintainer_id

      t.timestamps
    end

    change_column :package_versions, :package_id, :integer, null: false
  end
end
