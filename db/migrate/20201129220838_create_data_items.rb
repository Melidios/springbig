class CreateDataItems < ActiveRecord::Migration[6.0]
  def change
    create_table :data_items do |t|
      t.string :first
      t.string :last
      t.string :phone
      t.string :email
      t.string :file_name

      t.timestamps
    end
  end
end
