module NameOfPerson
  extend ActiveSupport::Concern

  included do
    has_person_name
  end

  def initials
    name_or_email.scan(/\b\w/).join
  end

  def title
    [ name, bio ].compact_blank.join(" – ")
  end

  private

  def name_or_email
    name.presence || email
  end

  def title_or_bio
    title.presence || bio.presence || "Master of your meals!"
  end
end
