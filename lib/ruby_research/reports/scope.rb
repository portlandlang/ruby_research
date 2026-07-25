# frozen_string_literal: true

module RubyResearch
  module Reports
    # Consistent wording for how much of the corpus a report covered, so
    # a full-corpus run never claims to be a "sample of 195393 gems".
    module Scope
      def self.describe(sampled:, analyzed:)
        return "all #{analyzed} gems" unless sampled

        "a random sample of #{analyzed} gems (seeded, reproducible)"
      end
    end
  end
end
