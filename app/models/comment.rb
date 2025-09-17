class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article

  acts_as_tenant(:organization)
  belongs_to :organization
end
