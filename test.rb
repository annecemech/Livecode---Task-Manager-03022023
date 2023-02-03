require "sqlite3"
require "pry-byebug"
require_relative "task"

db_file_path = File.join(File.dirname(__FILE__), 'tasks.db')
DB = SQLite3::Database.new(db_file_path)

DB.execute('DROP TABLE IF EXISTS `tasks`;')
create_statement = "
    CREATE TABLE `tasks` (
      `id`  INTEGER PRIMARY KEY AUTOINCREMENT,
      `title` TEXT,
      `description` TEXT,
      `done`  INTEGER
    );"
DB.execute(create_statement)
DB.execute("INSERT INTO tasks (title, description) VALUES ('Complete Livecode', 'Implement CRUD on Task')")

DB.results_as_hash = true

puts "Test - Read (One)"
task = Task.find(1)
puts "#{task.done? ? "[X]" : "[ ]"} #{task.id}. #{task.title} : #{task.description}"

puts "Test - Create"

new_task = Task.new(title: "Faire ma valise", description: "Youpi c'est le week-end!")
new_task.save
puts new_task.id

puts "Test - Update"

task.done!
task.save

task = Task.find(1)
puts "#{task.done? ? "[X]" : "[ ]"} #{task.id}. #{task.title} : #{task.description}"

puts "Test - Read (All)"

tasks = Task.all

tasks.each { |task| puts "#{task.done? ? "[X]" : "[ ]"} #{task.id}. #{task.title} : #{task.description}" }

puts "Test - Delete"
task = Task.find(1)
task.destroy
p Task.find(1) == nil
