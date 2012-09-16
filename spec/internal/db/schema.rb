ActiveRecord::Schema.define do
  create_table(:books, :force => true) do |t|
    t.string  :title
    t.string  :author
    t.integer :year
    t.string  :blurb_file
    t.boolean :delta, :default => true, :null => false
    t.timestamps
  end

  create_table(:delayed_jobs, :force => true) do |t|
    t.column :priority, :integer, :default => 0
    t.column :attempts, :integer, :default => 0
    t.column :handler, :text
    t.column :last_error, :text
    t.column :run_at, :datetime
    t.column :locked_at, :datetime
    t.column :failed_at, :datetime
    t.column :locked_by, :string
    t.column :queue, :string
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
  end
end
