class AddPersonDuplicates < ActiveRecord::Migration[6.0]
  def change
    create_table(:person_duplicates) do |t|
      t.integer :person_1_id, null: false
      t.integer :person_2_id, null: false
      t.boolean :ignore, null: false, default: false

      t.timestamps
    end

    add_foreign_key(:person_duplicates, :people, column: :person_1_id)
    add_foreign_key(:person_duplicates, :people, column: :person_2_id)
    add_index(:person_duplicates, [:person_1_id, :person_2_id], unique: true)
  end
end
