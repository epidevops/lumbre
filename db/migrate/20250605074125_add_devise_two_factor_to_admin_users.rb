class AddDeviseTwoFactorToAdminUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :admin_users, :otp_secret, :string
    add_column :admin_users, :consumed_timestep, :integer
    add_column :admin_users, :otp_required_for_login, :boolean, null: false, default: false
  end
end
