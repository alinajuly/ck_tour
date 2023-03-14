class DropPasswordResetTokens < ActiveRecord::Migration[7.0]
  def change
    drop_table :password_reset_tokens
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
