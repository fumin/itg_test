class CreateAnotherModels < ActiveRecord::Migration
  def change
    create_table :another_models do |t|
      t.integer :qq

      t.timestamps
    end
  end
end
