class SystemContactTypeLabel < ApplicationRecord
  enum :contact_type, %w[address email phone].index_by(&:itself)
end
