class CreateBestEffortTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :best_effort_types do |t|
      t.string :name, index: true

      t.timestamps
    end
  end
end
