class CreateTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :types do |t|
      t.string :name, unique: true

      t.timestamps
    end
  end
end
