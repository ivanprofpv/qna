class AddNullToAnswersAndQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column_null(:answers, :body, false)
    change_column_null(:questions, :title, false)
    change_column_null(:questions, :body, false)
  end
end
