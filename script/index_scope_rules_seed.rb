# frozen_string_literal: true

SeedLogger.section "index scope rules"
[
  [ "all", "All records", "No filtering applied to the index list." ],
  [ "current_admin_user", "Current admin user", "Only records owned by or assigned to the signed-in admin user." ],
  [ "role_peers", "Role peers", "Records visible to admin users who share at least one role." ],
  [ "author", "Author", "Only records created by the signed-in admin user via the author association." ]
].each do |key, name, description|
  IndexScopeRule.find_or_initialize_by(key:).tap do |rule|
    rule.name = name
    rule.description = description
    rule.save!
  end
end
