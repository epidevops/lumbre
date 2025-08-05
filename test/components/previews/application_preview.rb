# frozen_string_literal: true

class ApplicationPreview < ViewComponent::Preview
  include ActionView::Helpers::TagHelper
  include ActionView::Context
  include Turbo::FramesHelper
  include RailsHeroicon::Helper

  private

  def render_partial(partial_path, **locals)
    ApplicationController.render(
      partial: partial_path,
      locals: locals
    )
  end
end
