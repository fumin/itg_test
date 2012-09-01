class CreateSomeModels < ActiveRecord::Migration
  def change
    create_table :some_models do |t|
      t.boolean :a_column

      t.timestamps
    end
  end
end
