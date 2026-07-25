# frozen_string_literal: true

module RubyResearch
  # Single-line progress ticker on stderr, refreshed at most once a
  # second. Full-corpus runs take tens of minutes, so they need to show
  # movement and an ETA without scrolling 195k lines past the terminal.
  class Progress
    def initialize(label:, interval: 1, output: $stderr)
      @label = label
      @interval = interval
      @output = output
      @started_at = Time.now
      @last_tick = @started_at - interval
    end

    def tick(position, total)
      now = Time.now
      return if now - @last_tick < @interval && position != total

      @last_tick = now
      @output.print "\r  #{@label}: #{position}/#{total} · #{rate(position, now).round} gems/s · " \
                    "#{minutes_left(position, total, now)} min left    "
      @output.flush
    end

    def finish = @output.puts

    private

    def rate(position, now)
      elapsed = now - @started_at
      elapsed.positive? ? position / elapsed : 0.0
    end

    def minutes_left(position, total, now)
      per_second = rate(position, now)
      return '?' unless per_second.positive?

      ((total - position) / per_second / 60).round(1)
    end
  end
end
