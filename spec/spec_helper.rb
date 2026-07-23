# frozen_string_literal: true

require_relative '../lib/ruby_research'

FIXTURES_DIR = File.expand_path('fixtures', __dir__)

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random
end
