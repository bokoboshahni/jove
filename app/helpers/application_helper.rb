# frozen_string_literal: true

module ApplicationHelper
  def title(text = nil)
    content_for(:title) { text || t('.title') }
  end
end
