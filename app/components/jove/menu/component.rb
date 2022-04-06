# frozen_string_literal: true

module Jove
  module Menu
    class Component < Jove::Component
      renders_many :groups, Jove::Menu::Group::Component

      self.container_class_names = 'w-screen max-w-menu ' \
                                   'rounded-md shadow-elevation-3 ' \
                                   'bg-surface ' \
                                   'text-on-surface text-label-lg'

      self.elevation_class_names = 'py-2 space-y-2 ' \
                                   'rounded-md ' \
                                   'bg-primary bg-opacity-elevation-3'
    end
  end
end
