# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class CorporationImporter < BaseImporter
        self.sde_file = 'fsd/npcCorporations.yaml'

        self.sde_model = Corporation

        self.sde_mapper = lambda { |data, **_kwargs|
          data[:npc] = true
        }

        self.sde_exclude = %i[
          allowed_member_races
          corporation_trades
          divisions
          exchange_rates
          has_player_personnel_manager
          initial_price
          investors
          lp_offer_tables
          member_limit
          min_security
          minimum_join_standing
          public_shares
          send_char_termination_message
          unique_name
        ]

        self.sde_rename = {
          shares: :share_count,
          station_id: :home_station_id,
          ticker_name: :ticker
        }

        self.sde_localized = %i[description name]
      end
    end
  end
end
