class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.string :code
      t.string :original
      t.string :url_digest
      t.index :code
      t.index :url_digest
      t.timestamps
    end
  end
end
