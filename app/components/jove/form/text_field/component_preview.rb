# frozen_string_literal: true

module Jove
  module Form
    module TextField
      # @display wrapper_class 'p-4 max-w-xs'
      class ComponentPreview < ViewComponent::Preview
        def initialize
          super

          @object = User.new
          @object_name = 'user'
          @method_name = :id
        end

        # @!group Light

        # @label With label
        def with_label_light
          render_text_field(label: 'Email', placeholder: 'shahni@bokobo.space')
        end

        # @label With help text
        def with_help_text_light
          render_text_field(label: 'Email', placeholder: 'shahni@bokobo.space',
                            help: 'The address to spam you at.')
        end

        # @label With error text
        def with_error_text_light
          render_text_field(label: 'Email', placeholder: 'shahni@bokobo.space',
                            error: 'Invalid email.')
        end

        # @label With corner hint
        def with_corner_hint_light
          render_text_field(label: 'Email', placeholder: 'shahni@bokobo.space',
                            hint: 'Optional')
        end

        # @label With leading icon
        def with_leading_icon_light
          render_text_field(label: 'Email', placeholder: 'shahni@bokobo.space',
                            leading_icon: 'heroicons/solid/mail')
        end

        # @label With trailing icon
        def with_trailing_icon_light
          render_text_field(label: 'Account ID', placeholder: '1234567890',
                            trailing_icon: 'heroicons/solid/question-mark-circle')
        end

        # @label With filled leading add-on
        def with_filled_leading_addon_light
          render_text_field(label: 'URL', placeholder: 'eveonline.com',
                            leading_addon: 'http://', leading_addon_variant: :filled)
        end

        # @label With filled trailing add-on
        def with_filled_trailing_addon_light
          render_text_field(label: 'Volume', placeholder: '0', trailing_addon: 'm3',
                            trailing_addon_variant: :filled)
        end

        # @label With filled leading and trailing add-ons
        def with_filled_leading_trailing_addons_light
          render_text_field(label: 'Price', placeholder: '0.00', leading_addon: 'Ƶ',
                            leading_addon_variant: :filled, trailing_addon: 'ISK', trailing_addon_variant: :filled)
        end

        # @label With inline leading add-on
        def with_inline_leading_addon_light
          render_text_field(label: 'URL', placeholder: 'eveonline.com',
                            leading_addon: 'http://', leading_addon_variant: :inline)
        end

        # @label With inline trailing add-on
        def with_inline_trailing_addon_light
          render_text_field(label: 'Volume', placeholder: '0', trailing_addon: 'm3',
                            trailing_addon_variant: :inline)
        end

        # @label With inline leading and trailing add-ons
        def with_inline_leading_trailing_addons_light
          render_text_field(label: 'Price', placeholder: '0.00', leading_addon: 'Ƶ',
                            leading_addon_variant: :inline, trailing_addon: 'ISK', trailing_addon_variant: :inline)
        end

        # @!endgroup

        # @!group Dark

        # @label With label
        # @display theme dark
        def with_label_dark
          render_text_field(label: 'Email', placeholder: 'shahni@bokobo.space')
        end

        # @label With help text
        # @display theme dark
        def with_help_text_dark
          render_text_field(label: 'Email', placeholder: 'shahni@bokobo.space',
                            help: 'The address to spam you at.')
        end

        # @label With error text
        # @display theme dark
        def with_error_text_dark
          render_text_field(label: 'Email', placeholder: 'shahni@bokobo.space',
                            error: 'Invalid email.')
        end

        # @label With corner hint
        # @display theme dark
        def with_corner_hint_dark
          render_text_field(label: 'Email', placeholder: 'shahni@bokobo.space',
                            hint: 'Optional')
        end

        # @label With leading icon
        # @display theme dark
        def with_leading_icon_dark
          render_text_field(label: 'Email', placeholder: 'shahni@bokobo.space',
                            leading_icon: 'heroicons/solid/mail')
        end

        # @label With trailing icon
        # @display theme dark
        def with_trailing_icon_dark
          render_text_field(label: 'Account ID', placeholder: '1234567890',
                            trailing_icon: 'heroicons/solid/question-mark-circle')
        end

        # @label With filled leading add-on
        # @display theme dark
        def with_filled_leading_addon_dark
          render_text_field(label: 'URL', placeholder: 'eveonline.com',
                            leading_addon: 'http://', leading_addon_variant: :filled)
        end

        # @label With filled trailing add-on
        # @display theme dark
        def with_filled_trailing_addon_dark
          render_text_field(label: 'Volume', placeholder: '0', trailing_addon: 'm3',
                            trailing_addon_variant: :filled)
        end

        # @label With filled leading and trailing add-ons
        # @display theme dark
        def with_filled_leading_trailing_addons_dark
          render_text_field(label: 'Price', placeholder: '0.00', leading_addon: 'Ƶ',
                            leading_addon_variant: :filled, trailing_addon: 'ISK', trailing_addon_variant: :filled)
        end

        # @label With inline leading add-on
        # @display theme dark
        def with_inline_leading_addon_dark
          render_text_field(label: 'URL', placeholder: 'eveonline.com',
                            leading_addon: 'http://', leading_addon_variant: :inline)
        end

        # @label With inline trailing add-on
        # @display theme dark
        def with_inline_trailing_addon_dark
          render_text_field(label: 'Volume', placeholder: '0', trailing_addon: 'm3',
                            trailing_addon_variant: :inline)
        end

        # @label With inline leading and trailing add-ons
        # @display theme dark
        def with_inline_leading_trailing_addons_dark
          render_text_field(label: 'Price', placeholder: '0.00', leading_addon: 'Ƶ',
                            leading_addon_variant: :inline, trailing_addon: 'ISK', trailing_addon_variant: :inline)
        end

        # @!endgroup

        private

        def render_text_field(**args)
          object_args = { object: @object, object_name: @object_name, method_name: @method_name }
          render(Jove::Form::TextField::Component.new(**args.merge(object_args)))
        end
      end
    end
  end
end
