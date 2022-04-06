# frozen_string_literal: true

require 'jove/configurable'

module ESIRepositoryGateway
  extend ActiveSupport::Concern

  ESI_BASE_URL = 'https://esi.evetech.net/latest'

  included do # rubocop:disable Metrics/BlockLength
    include Jove::Configurable

    class_attribute :model
    class_attribute :path
    class_attribute :mapper

    def find(id)
      rec = model.find_by(id:)

      return rec if rec && !rec.esi_expired?

      attrs = fetch_from_esi(id)

      raise_record_not_found(id) unless attrs

      if rec
        rec.update!(attrs)
        rec
      else
        model.create!(attrs)
      end
    end

    private

    delegate :user_agent, to: :jove

    def fetch_from_esi(id)
      res = run_request(url(id))
      data = Oj.load(res.body)

      return nil unless res.success?

      data.merge!(esi_cache_attrs(res.headers))
      data['id'] = id
      mapper.call(data)
      data
    end

    def url(id)
      "#{ESIRepositoryGateway::ESI_BASE_URL}/#{path.expand(id:)}"
    end

    def http
      @http ||= Typhoeus::Hydra.new
    end

    def build_request(url, method: :get, params: {}, body: nil, headers: {})
      headers = default_headers.merge(headers)
      Typhoeus::Request.new(url, method:, params:, body:, headers:)
    end

    def run_request(path, method: :get, params: {}, body: nil, headers: {})
      req = build_request(path, method:, params:, body:, headers:)
      http.queue(req)
      http.run

      req.response
    end

    def default_headers
      {
        'User-Agent': user_agent
      }
    end

    def esi_cache_attrs(headers)
      {
        esi_etag: headers['etag'],
        esi_expires_at: DateTime.parse(headers['expires']),
        esi_last_modified_at: DateTime.parse(headers['last-modified'])
      }
    end

    def raise_record_not_found(id)
      raise ActiveRecord::RecordNotFound.new("#{model.name.humanize} does not exist in ESI", model, :id, id)
    end
  end
end
