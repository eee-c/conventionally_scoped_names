ActiveRecord::Schema.define(:version => 0) do
  create_table "posts", :force => true do |t|
    t.string "title"
    t.string "last_modified"
    t.string "status"
  end
end
