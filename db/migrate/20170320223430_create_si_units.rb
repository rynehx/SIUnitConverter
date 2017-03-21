class CreateSiUnits < ActiveRecord::Migration
  def change
    create_table :si_units do |t|
      t.string :si_unit, index: true, :null => false
      t.string :other_unit, index: true, :null => false
      t.decimal :conversion_factor, :precision => 64, :scale => 32, :null => false

      t.timestamps null: false
    end
  end
end
