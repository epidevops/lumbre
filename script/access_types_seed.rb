# frozen_string_literal: true

SeedLogger.section "access types"
[
  [ AccessType::NAVIGATION, "Navigation" ],
  [ AccessType::RESOURCES, "Resources" ],
  [ AccessType::PAGES, "Pages" ]
].each do |key, name|
  AccessType.find_or_initialize_by(key:).tap do |access_type|
    access_type.name = name
    access_type.save!
  end
end
