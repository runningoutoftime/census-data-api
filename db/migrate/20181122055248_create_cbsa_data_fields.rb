class CreateCbsaDataFields < ActiveRecord::Migration[5.1]
  def change
    create_table :cbsa_data_fields do |t|
      t.integer :code_based_statistical_area_id
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
