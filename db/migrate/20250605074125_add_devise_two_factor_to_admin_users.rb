class AddDeviseTwoFactorToAdminUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :admin_users, :otp_secret, :string
    add_column :admin_users, :otp_backup_codes, :text
    add_column :admin_users, :consumed_timestep, :integer, default: 0, null: false
    add_column :admin_users, :otp_required_for_login, :boolean, null: false, default: false
  end
end
