class CreateViewers < ActiveRecord::Migration[5.2]
  def change
    create_table :viewers do |t|
      t.string :ip
      t.string :browser
      t.string :browser_version
      t.string :os
      t.string :country
      t.string :city
      t.string :ua, limit: 512
      t.string :viewer_hash
      t.integer :view_count, default: 0
      t.belongs_to :link
      t.index :viewer_hash
      t.timestamps
    end
  end
end
