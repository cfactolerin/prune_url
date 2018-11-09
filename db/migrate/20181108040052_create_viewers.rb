class CreateViewers < ActiveRecord::Migration[5.2]
  def change
    create_table :viewers do |t|
      t.string :ip
      t.string :browser
      t.string :browser_version
      t.string :os
      t.string :country
      t.string :city
      t.string :ua
      t.string :sha
      t.integer :visit_count
      t.belongs_to :link
      t.index :sha
      t.timestamps
    end
  end
end
