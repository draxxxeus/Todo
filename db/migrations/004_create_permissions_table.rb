Sequel.migration do
  change do
    create_table :permissions do
      foreign_key :user_id, :users
      foreign_key :list_id, :lists, :on_delete => :cascade
      column :permission_level, 'enum("read_only", "read_write")', :null => false
      DateTime :created_at
      DateTime :updated_at
      primary_key [:user_id, :list_id], :name => :permissions_pk
    end
  end
end
