# frozen_string_literal: true

SeedLogger.section "access resources"
AccessControlCatalog.sync_access_resources!
AccessControlCatalog.sync_page_access_resources!
