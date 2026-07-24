# frozen_string_literal: true

require 'json'
require 'yaml'

module RubyResearch
  ROOT = File.expand_path('..', __dir__)
  DATA_DIR = File.join(ROOT, 'data')
  REPORTS_DIR = File.join(ROOT, 'reports')
end

require_relative 'ruby_research/http_client'
require_relative 'ruby_research/report_writer'
require_relative 'ruby_research/compact_index_client'
require_relative 'ruby_research/rubygems_api_client'
require_relative 'ruby_research/gem_source_client'
require_relative 'ruby_research/reports/rubocop_discouragements'
require_relative 'ruby_research/reports/ruby_requirements'
require_relative 'ruby_research/reports/platforms'
require_relative 'ruby_research/reports/gem_ages'
require_relative 'ruby_research/reports/c_extensions'
require_relative 'ruby_research/reports/feature_usage'
require_relative 'ruby_research/reports/ruby_deprecations'
require_relative 'ruby_research/reports/portland_compatibility'
require_relative 'ruby_research/reports/error_handling'
require_relative 'ruby_research/reports/nil_idioms'
require_relative 'ruby_research/reports/mutation_shapes'
require_relative 'ruby_research/reports/heredocs'
