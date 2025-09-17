class AddOrganizationToComments < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :organization, null: false, foreign_key: true
  end
end
