class CreateZipCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :zip_codes do |t|
      t.string :zip
      t.string :cbsa
      t.decimal :res_ratio
      t.decimal :bus_ratio
      t.decimal :oth_ratio
      t.decimal :tot_ratio

      t.timestamps
    end
  end
end
