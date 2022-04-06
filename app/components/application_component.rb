# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  def call
    content_tag :h1, 'Hello world!'
  end
end
