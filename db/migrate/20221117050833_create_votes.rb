class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|

      t.integer :vote_weight
      t.references :user, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
