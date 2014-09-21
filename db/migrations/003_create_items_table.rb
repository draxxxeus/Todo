Sequel.migration do
  change do
    create_table :items do
      primary_key :id
      String :name, :length => 128, :null => false
      String :description, :length => 256
      foreign_key :user_id, :users
      foreign_key :list_id, :lists, :on_delete => :cascade
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
