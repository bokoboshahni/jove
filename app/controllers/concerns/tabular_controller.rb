# frozen_string_literal: true

module TabularController
  extend ActiveSupport::Concern

  DEFAULT_PAGE_SIZES = [10, 25, 50, 100].freeze

  DEFAULT_SORT_NAME_PARAM = 'name'

  included do
    class_attribute :page_sizes
    self.page_sizes = DEFAULT_PAGE_SIZES

    class_attribute :sort_columns
    self.sort_columns = {}

    class_attribute :sort_name_param
    self.sort_name_param = DEFAULT_SORT_NAME_PARAM

    helper_method :sorted?, :sort_dir
  end

  def sorted?(column)
    params[:sort] == column.to_s
  end

  def sort_dir
    params[:dir]
  end

  def sort_param # rubocop:disable Metrics/AbcSize
    return { sort_name_param => :asc } unless sort_columns.keys.include?(params[:sort])

    param = { sort_columns[params[:sort]] => params[:dir] }
    param[sort_name_param] = :asc unless params[:sort] == sort_name_param
    param
  end

  def page_param
    params[:page] || 1
  end

  def per_page_param
    return params[:per_page].to_i if page_sizes.include?(params[:per_page].to_i)

    25
  end
end
