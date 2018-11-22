class CreateCodeBasedStatisticalAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :code_based_statistical_areas do |t|
      t.string :cbsa
      t.string :mdiv
      t.string :stcou
      t.string :name
      t.string :lsad

      t.timestamps
    end
  end
end
