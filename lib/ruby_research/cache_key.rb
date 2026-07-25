# frozen_string_literal: true

require 'digest'

module RubyResearch
  # Turns a gem name into a filename that is unique on case-insensitive
  # filesystems.
  #
  # macOS (APFS) folds case by default, so the distinct gems `CnpOnline`
  # and `cnponline` would share one cache file and silently serve one
  # gem's data for the other. Names that are already lowercase keep their
  # plain filename — that's ~99.9% of the corpus, so existing caches stay
  # valid — while any name carrying uppercase gets a digest suffix derived
  # from its exact spelling, so case variants land in different files.
  module CacheKey
    # Not legal in a gem name, so a suffixed key can never collide with
    # the plain key of some other real gem.
    SEPARATOR = '@'

    def self.for(gem_name)
      return gem_name if gem_name == gem_name.downcase

      "#{gem_name}#{SEPARATOR}#{Digest::SHA256.hexdigest(gem_name)[0, 8]}"
    end
  end
end
