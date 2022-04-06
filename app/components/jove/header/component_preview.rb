# frozen_string_literal: true

module Jove
  module Header
    class ComponentPreview < ViewComponent::Preview
      # @!group Light

      # @label With title
      def title_light
        render_title
      end

      # @label With title and description
      def title_description_light
        render_title_description
      end

      # @label With title, description, and avatar
      def title_description_avatar_light
        render_title_description_avatar
      end

      # @label With title, description, avatar, and actions
      def title_description_avatar_actions_light
        render_title_description_avatar_actions
      end

      # @!endgroup

      # @!group Dark

      # @label With title
      # @display theme dark
      def title_dark
        render_title
      end

      # @label With title and description
      # @display theme dark
      def title_description_dark
        render_title_description
      end

      # @label With title, description, and avatar
      # @display theme dark
      def title_description_avatar_dark
        render_title_description_avatar
      end

      # @label With title, description, avatar, and actions
      # @display theme dark
      def title_description_avatar_actions_dark
        render_title_description_avatar_actions
      end

      # @!endgroup

      private

      def render_title
        render_with_template(template: 'jove/header/component_preview/title')
      end

      def render_title_description
        render_with_template(template: 'jove/header/component_preview/title_description')
      end

      def render_title_description_avatar
        render_with_template(template: 'jove/header/component_preview/title_description_avatar')
      end

      def render_title_description_avatar_actions
        render_with_template(template: 'jove/header/component_preview/title_description_avatar_actions')
      end
    end
  end
end
