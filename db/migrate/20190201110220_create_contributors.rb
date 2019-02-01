class CreateContributors < ActiveRecord::Migration[5.2]
  def change
    create_table :contributors do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    create_table :contributors_package_versions do |t|
      t.references :contributor, index: true
      t.references :package_version, index: true

      t.string     :role, null: false, default: 'maintainer'
    end
  end
end
