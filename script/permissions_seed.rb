# frozen_string_literal: true

require Rails.root.join("script/permission_seed")

SeedLogger.section "permissions"
PermissionSeed.run!
