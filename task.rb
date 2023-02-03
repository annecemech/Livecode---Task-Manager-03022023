class Task
  attr_reader :id
  attr_accessor :title, :description

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @description = attributes[:description]
    @done = attributes[:done] || false
  end

  def done?
   @done
  end

  def done!
    @done = !@done
  end

  def self.find(id)
    row = DB.execute("SELECT * FROM tasks WHERE id = #{id}")
    if row.empty?
      nil
    else
      row = row.first
      self.build_task(row)
    end
  end

  def self.all
    rows = DB.execute("SELECT * FROM tasks")
    rows.map { |row| self.build_task(row) }
  end

  def save
    if @id
      DB.execute("UPDATE tasks SET title = ?, description = ?, done = ? WHERE id = ?", @title, @description, @done ? 1 : 0, @id)
    else
      DB.execute("INSERT INTO tasks (title, description) VALUES (?, ?)", @title, @description)
      @id = DB.last_insert_row_id
    end
  end

  def destroy
    DB.execute("DELETE from tasks where id = ?", @id)
  end

  private

  def self.build_task(row)
    self.new(id: row["id"], title: row["title"], description: row["description"], done: row["done"] == 1 ? true : false)
  end

end
