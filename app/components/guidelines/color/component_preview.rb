# frozen_string_literal: true

module Guidelines
  module Color
    class ComponentPreview < ViewComponent::Preview
      # @!group Theme (Light)

      # @label Primary
      def theme_primary_light
        theme_primary
      end

      # @label Secondary
      def theme_secondary_light
        theme_secondary
      end

      # @label Tertiary
      def theme_tertiary_light
        theme_tertiary
      end

      # @label Danger
      def theme_danger_light
        theme_danger
      end

      # @label Success
      def theme_success_light
        theme_success
      end

      # @label Notice
      def theme_notice_light
        theme_notice
      end

      # @label Background
      def theme_background_light
        theme_background
      end

      # @label Surface
      def theme_surface_light
        theme_surface
      end

      # @label Outline
      def theme_outline_light
        theme_outline
      end

      # @endgroup

      # @!group Theme (Dark)

      # @label Primary
      # @display theme dark
      def theme_primary_dark
        theme_primary
      end

      # @label Secondary
      # @display theme dark
      def theme_secondary_dark
        theme_secondary
      end

      # @label Tertiary
      # @display theme dark
      def theme_tertiary_dark
        theme_tertiary
      end

      # @label Danger
      # @display theme dark
      def theme_danger_dark
        theme_danger
      end

      # @label Success
      # @display theme dark
      def theme_success_dark
        theme_success
      end

      # @label Notice
      # @display theme dark
      def theme_notice_dark
        theme_notice
      end

      # @label Background
      # @display theme dark
      def theme_background_dark
        theme_background
      end

      # @label Surface
      # @display theme dark
      def theme_surface_dark
        theme_surface
      end

      # @label Outline
      # @display theme dark
      def theme_outline_dark
        theme_outline
      end

      # @endgroup

      # @!group Scales (light)

      # @label Primary
      def primary_light
        primary
      end

      # @label Secondary
      def secondary_light
        secondary
      end

      # @label Tertiary
      def tertiary_light
        tertiary
      end

      # @label Notice
      def notice_light
        notice
      end

      # @label Success
      def success_light
        success
      end

      # @label Danger
      def danger_light
        danger
      end

      # @label Neutral
      def neutral_light
        neutral
      end

      # @!endgroup

      # @!group Scales (dark)

      # @label Neutral
      # @display theme dark
      def neutral_dark
        neutral
      end

      # @label Primary
      # @display theme dark
      def primary_dark
        primary
      end

      # @label Secondary
      # @display theme dark
      def secondary_dark
        secondary
      end

      # @label Notice
      # @display theme dark
      def notice_dark
        notice
      end

      # @label Success
      # @display theme dark
      def success_dark
        success
      end

      # @label danger
      # @display theme dark
      def danger_dark
        danger
      end

      # @!endgroup

      private

      def neutral
        component = Guidelines::Color::Component.new
        colors = [
          { color: 'neutral-0' },
          { color: 'neutral-10' },
          { color: 'neutral-20' },
          { color: 'neutral-25' },
          { color: 'neutral-30' },
          { color: 'neutral-35' },
          { color: 'neutral-40' },
          { color: 'neutral-50' },
          { color: 'neutral-60' },
          { color: 'neutral-70' },
          { color: 'neutral-80' },
          { color: 'neutral-90' },
          { color: 'neutral-95' },
          { color: 'neutral-98' },
          { color: 'neutral-99' },
          { color: 'neutral-100' }
        ]
        component.colors(colors)
        render(component)
      end

      def primary
        component = Guidelines::Color::Component.new
        colors = [
          { color: 'primary-0' },
          { color: 'primary-10' },
          { color: 'primary-20' },
          { color: 'primary-25' },
          { color: 'primary-30' },
          { color: 'primary-35' },
          { color: 'primary-40' },
          { color: 'primary-50' },
          { color: 'primary-60' },
          { color: 'primary-70' },
          { color: 'primary-80' },
          { color: 'primary-90' },
          { color: 'primary-95' },
          { color: 'primary-98' },
          { color: 'primary-99' },
          { color: 'primary-100' }
        ]
        component.colors(colors)
        render(component)
      end

      def secondary
        component = Guidelines::Color::Component.new
        colors = [
          { color: 'secondary-0' },
          { color: 'secondary-10' },
          { color: 'secondary-20' },
          { color: 'secondary-25' },
          { color: 'secondary-30' },
          { color: 'secondary-35' },
          { color: 'secondary-40' },
          { color: 'secondary-50' },
          { color: 'secondary-60' },
          { color: 'secondary-70' },
          { color: 'secondary-80' },
          { color: 'secondary-90' },
          { color: 'secondary-95' },
          { color: 'secondary-98' },
          { color: 'secondary-99' },
          { color: 'secondary-100' }
        ]
        component.colors(colors)
        render(component)
      end

      def tertiary
        component = Guidelines::Color::Component.new
        colors = [
          { color: 'tertiary-0' },
          { color: 'tertiary-10' },
          { color: 'tertiary-20' },
          { color: 'tertiary-25' },
          { color: 'tertiary-30' },
          { color: 'tertiary-35' },
          { color: 'tertiary-40' },
          { color: 'tertiary-50' },
          { color: 'tertiary-60' },
          { color: 'tertiary-70' },
          { color: 'tertiary-80' },
          { color: 'tertiary-90' },
          { color: 'tertiary-95' },
          { color: 'tertiary-98' },
          { color: 'tertiary-99' },
          { color: 'tertiary-100' }
        ]
        component.colors(colors)
        render(component)
      end

      def notice
        component = Guidelines::Color::Component.new
        colors = [
          { color: 'notice-0' },
          { color: 'notice-10' },
          { color: 'notice-20' },
          { color: 'notice-25' },
          { color: 'notice-30' },
          { color: 'notice-35' },
          { color: 'notice-40' },
          { color: 'notice-50' },
          { color: 'notice-60' },
          { color: 'notice-70' },
          { color: 'notice-80' },
          { color: 'notice-90' },
          { color: 'notice-95' },
          { color: 'notice-98' },
          { color: 'notice-99' },
          { color: 'notice-100' }
        ]
        component.colors(colors)
        render(component)
      end

      def success
        component = Guidelines::Color::Component.new
        colors = [
          { color: 'success-0' },
          { color: 'success-10' },
          { color: 'success-20' },
          { color: 'success-25' },
          { color: 'success-30' },
          { color: 'success-35' },
          { color: 'success-40' },
          { color: 'success-50' },
          { color: 'success-60' },
          { color: 'success-70' },
          { color: 'success-80' },
          { color: 'success-90' },
          { color: 'success-95' },
          { color: 'success-98' },
          { color: 'success-99' },
          { color: 'success-100' }
        ]
        component.colors(colors)
        render(component)
      end

      def danger
        component = Guidelines::Color::Component.new
        colors = [
          { color: 'danger-0' },
          { color: 'danger-10' },
          { color: 'danger-20' },
          { color: 'danger-25' },
          { color: 'danger-30' },
          { color: 'danger-35' },
          { color: 'danger-40' },
          { color: 'danger-50' },
          { color: 'danger-60' },
          { color: 'danger-70' },
          { color: 'danger-80' },
          { color: 'danger-90' },
          { color: 'danger-95' },
          { color: 'danger-98' },
          { color: 'danger-99' },
          { color: 'danger-100' }
        ]
        component.colors(colors)
        render(component)
      end

      def theme_primary
        component = Guidelines::Color::Component.new(size: :lg)
        colors = [
          { color: 'bg-primary text-on-primary', label: 'Primary' },
          { color: 'bg-on-primary text-primary', label: 'On Primary' },
          { color: 'bg-primary-container text-on-primary-container', label: 'Primary Container' },
          { color: 'bg-on-primary-container text-primary-container', label: 'On Primary Container' }
        ]
        component.colors(colors)
        render(component)
      end

      def theme_secondary
        component = Guidelines::Color::Component.new(size: :lg)
        colors = [
          { color: 'bg-secondary text-on-secondary', label: 'Secondary' },
          { color: 'bg-on-secondary text-secondary', label: 'On Secondary' },
          { color: 'bg-secondary-container text-on-secondary-container', label: 'Secondary Container' },
          { color: 'bg-on-secondary-container text-secondary-container', label: 'On Secondary Container' }
        ]
        component.colors(colors)
        render(component)
      end

      def theme_tertiary
        component = Guidelines::Color::Component.new(size: :lg)
        colors = [
          { color: 'bg-tertiary text-on-tertiary', label: 'Tertiary' },
          { color: 'bg-on-tertiary text-tertiary', label: 'On Tertiary' },
          { color: 'bg-tertiary-container text-on-tertiary-container', label: 'Tertiary Container' },
          { color: 'bg-on-tertiary-container text-tertiary-container', label: 'On Tertiary Container' }
        ]
        component.colors(colors)
        render(component)
      end

      def theme_danger
        component = Guidelines::Color::Component.new(size: :lg)
        colors = [
          { color: 'bg-danger text-on-danger', label: 'Danger' },
          { color: 'bg-on-danger text-danger', label: 'On Danger' },
          { color: 'bg-danger-container text-on-danger-container', label: 'Danger Container' },
          { color: 'bg-on-danger-container text-danger-container', label: 'On Danger Container' }
        ]
        component.colors(colors)
        render(component)
      end

      def theme_success
        component = Guidelines::Color::Component.new(size: :lg)
        colors = [
          { color: 'bg-success text-on-success', label: 'Success' },
          { color: 'bg-on-success text-success', label: 'On Success' },
          { color: 'bg-success-container text-on-success-container', label: 'Success Container' },
          { color: 'bg-on-success-container text-success-container', label: 'On Success Container' }
        ]
        component.colors(colors)
        render(component)
      end

      def theme_notice
        component = Guidelines::Color::Component.new(size: :lg)
        colors = [
          { color: 'bg-notice text-on-notice', label: 'Notice' },
          { color: 'bg-on-notice text-notice', label: 'On Notice' },
          { color: 'bg-notice-container text-on-notice-container', label: 'Notice Container' },
          { color: 'bg-on-notice-container text-notice-container', label: 'On Notice Container' }
        ]
        component.colors(colors)
        render(component)
      end

      def theme_background
        component = Guidelines::Color::Component.new(size: :lg)
        colors = [
          { color: 'bg-background text-on-background', label: 'Background' },
          { color: 'bg-on-background text-background', label: 'On Background' }
        ]
        component.colors(colors)
        render(component)
      end

      def theme_surface
        component = Guidelines::Color::Component.new(size: :lg)
        colors = [
          { color: 'bg-surface text-on-surface', label: 'Surface' },
          { color: 'bg-on-surface text-surface', label: 'On Surface' },
          { color: 'bg-surface-variant text-on-surface-variant', label: 'Surface Variant' },
          { color: 'bg-on-surface-variant text-surface-variant', label: 'On Surface Variant' }
        ]
        component.colors(colors)
        render(component)
      end

      def theme_outline
        component = Guidelines::Color::Component.new(size: :lg)
        colors = [
          { color: 'bg-outline text-surface', label: 'Outline' }
        ]
        component.colors(colors)
        render(component)
      end
    end
  end
end
