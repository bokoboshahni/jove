# frozen_string_literal: true

AuthTrail.transform_method = lambda do |data, request|
  data[:user] = Identity.find_by(id: request.session[:current_identity_id])
end

AuthTrail.identity_method = lambda do |request, _opts, _user|
  request.session[:current_identity_id]
end
