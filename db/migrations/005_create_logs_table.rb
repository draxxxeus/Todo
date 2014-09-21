Sequel.migration do
  change do
    create_table :logs do
      primary_key :id
      foreign_key :user_id, :users
      foreign_key :list_id, :lists, :on_delete => :cascade
      String :log_line, :length => 256, :null => false
      DateTime :created_at
    end
  end
end
