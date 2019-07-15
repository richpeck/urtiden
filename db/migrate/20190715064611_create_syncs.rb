class CreateSyncs < ActiveRecord::Migration[6.0]
  def change
    create_table :syncs do |t|

      t.timestamps
    end
  end
end
