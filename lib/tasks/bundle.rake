# frozen_string_literal: true

if Rails.env.development?
  require 'bundler/audit/task'
  Bundler::Audit::Task.new

  require 'bundler/plumber/task'
  Bundler::Plumber::Task.new
end
