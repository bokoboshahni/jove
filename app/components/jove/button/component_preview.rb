# frozen_string_literal: true

module Jove
  module Button
    class ComponentPreview < ViewComponent::Preview
      # @!group Elevated (Light)

      # @label Primary
      def elevated_primary_light
        render_buttons(:elevated, :primary)
      end

      # @label Secondary
      def elevated_secondary_light
        render_buttons(:elevated, :secondary)
      end

      # @label Tertiary
      def elevated_tertiary_light
        render_buttons(:elevated, :tertiary)
      end

      # @label Danger
      def elevated_danger_light
        render_buttons(:elevated, :danger)
      end

      # @label Success
      def elevated_success_light
        render_buttons(:elevated, :success)
      end

      # @label Notice
      def elevated_notice_light
        render_buttons(:elevated, :notice)
      end

      # @!endgroup

      # @!group Filled (Light)

      # @label Primary
      def filled_primary_light
        render_buttons(:filled, :primary)
      end

      # @label Secondary
      def filled_secondary_light
        render_buttons(:filled, :secondary)
      end

      # @label Tertiary
      def filled_tertiary_light
        render_buttons(:filled, :tertiary)
      end

      # @label Danger
      def filled_danger_light
        render_buttons(:filled, :danger)
      end

      # @label Success
      def filled_success_light
        render_buttons(:filled, :success)
      end

      # @label Notice
      def filled_notice_light
        render_buttons(:filled, :notice)
      end

      # @!endgroup

      # @!group Outlined (Light)

      # @label Primary
      def outlined_primary_light
        render_buttons(:outlined, :primary)
      end

      # @label Secondary
      def outlined_secondary_light
        render_buttons(:outlined, :secondary)
      end

      # @label Tertiary
      def outlined_tertiary_light
        render_buttons(:outlined, :tertiary)
      end

      # @label Danger
      def outlined_danger_light
        render_buttons(:outlined, :danger)
      end

      # @label Success
      def outlined_success_light
        render_buttons(:outlined, :success)
      end

      # @label Notice
      def outlined_notice_light
        render_buttons(:outlined, :notice)
      end

      # @!endgroup

      # @!group Text (Light)

      # @label Primary
      def text_primary_light
        render_buttons(:text, :primary)
      end

      # @label Secondary
      def text_secondary_light
        render_buttons(:text, :secondary)
      end

      # @label Tertiary
      def text_tertiary_light
        render_buttons(:text, :tertiary)
      end

      # @label Danger
      def text_danger_light
        render_buttons(:text, :danger)
      end

      # @label Success
      def text_success_light
        render_buttons(:text, :success)
      end

      # @label Notice
      def text_notice_light
        render_buttons(:text, :notice)
      end

      # @!endgroup

      # @label Overflow (Light)
      def overflow_light
        render_overflow_button
      end

      # @label Avatar (Light)
      def avatar_light
        render_avatar_button
      end

      # @!group Filled (Dark)

      # @label Primary
      # @display theme dark
      def filled_primary_dark
        render_buttons(:filled, :primary)
      end

      # @label Secondary
      # @display theme dark
      def filled_secondary_dark
        render_buttons(:filled, :secondary)
      end

      # @label Tertiary
      # @display theme dark
      def filled_tertiary_dark
        render_buttons(:filled, :tertiary)
      end

      # @label Danger
      # @display theme dark
      def filled_danger_dark
        render_buttons(:filled, :danger)
      end

      # @label Success
      # @display theme dark
      def filled_success_dark
        render_buttons(:filled, :success)
      end

      # @label Notice
      # @display theme dark
      def filled_notice_dark
        render_buttons(:filled, :notice)
      end

      # @!endgroup

      # @!group Outlined (Dark)

      # @label Primary
      # @display theme dark
      def outlined_primary_dark
        render_buttons(:outlined, :primary)
      end

      # @label Secondary
      # @display theme dark
      def outlined_secondary_dark
        render_buttons(:outlined, :secondary)
      end

      # @label Tertiary
      # @display theme dark
      def outlined_tertiary_dark
        render_buttons(:outlined, :tertiary)
      end

      # @label Danger
      # @display theme dark
      def outlined_danger_dark
        render_buttons(:outlined, :danger)
      end

      # @label Success
      # @display theme dark
      def outlined_success_dark
        render_buttons(:outlined, :success)
      end

      # @label Notice
      # @display theme dark
      def outlined_notice_dark
        render_buttons(:outlined, :notice)
      end

      # @!endgroup

      # @!group Text (Dark)

      # @label Primary
      # @display theme dark
      def text_primary_dark
        render_buttons(:text, :primary)
      end

      # @label Secondary
      # @display theme dark
      def text_secondary_dark
        render_buttons(:text, :secondary)
      end

      # @label Tertiary
      # @display theme dark
      def text_tertiary_dark
        render_buttons(:text, :tertiary)
      end

      # @label Danger
      # @display theme dark
      def text_danger_dark
        render_buttons(:text, :danger)
      end

      # @label Success
      # @display theme dark
      def text_success_dark
        render_buttons(:text, :success)
      end

      # @label Notice
      # @display theme dark
      def text_notice_dark
        render_buttons(:text, :notice)
      end

      # @!endgroup

      # @label Overflow (Dark)
      # @display theme dark
      def overflow_dark
        render_overflow_button
      end

      # @label Avatar (Dark)
      # @display theme dark
      def avatar_dark
        render_avatar_button
      end

      private

      def render_overflow_button
        render(Jove::Button::Component.new(variant: :overflow, color: :surface, label: 'Open menu'))
      end

      def render_avatar_button
        avatar = 'https://images.evetech.net/characters/2113024536/portrait'
        render(Jove::Button::Component.new(variant: :avatar, color: :primary,
                                           avatar:, label: 'Open menu'))
      end

      def render_buttons(variant, color)
        render_with_template(
          template: 'jove/button/component_preview/buttons',
          locals: {
            variant:,
            color:
          }
        )
      end
    end
  end
end
