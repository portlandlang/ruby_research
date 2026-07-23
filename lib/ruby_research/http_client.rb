# frozen_string_literal: true

require 'net/http'
require 'uri'

module RubyResearch
  # Shared HTTP fetching for all clients: tight timeouts, retry with
  # exponential backoff on transient failures, and redirect following.
  # Built for long corpus runs on unreliable connections — a stalled
  # request fails in seconds, transient failures self-heal, and only
  # persistent failures surface (to be logged per gem and filled in by a
  # rerun).
  class HttpClient
    MAX_ATTEMPTS = 4
    MAX_REDIRECTS = 3
    OPEN_TIMEOUT_SECONDS = 10
    READ_TIMEOUT_SECONDS = 30

    RETRYABLE_ERRORS = [
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::EHOSTUNREACH,
      Errno::ENETUNREACH,
      Errno::ETIMEDOUT,
      IOError,
      Net::OpenTimeout,
      Net::ReadTimeout,
      OpenSSL::SSL::SSLError,
      SocketError
    ].freeze

    # Returns the response body. `range: [first_byte, last_byte]` sends a
    # Range header (servers may respond with the full body; both are fine).
    def get(url, range: nil)
      attempts = 0
      begin
        attempts += 1
        request(url, range: range)
      rescue *RETRYABLE_ERRORS, RetryableStatus => e
        raise "GET #{url} failed after #{attempts} attempts: #{e.message}" if attempts >= MAX_ATTEMPTS

        sleep(2**(attempts - 1))
        retry
      end
    end

    private

    class RetryableStatus < StandardError; end

    def request(url, range:, redirects_left: MAX_REDIRECTS)
      uri = URI(url)
      http_request = Net::HTTP::Get.new(uri)
      http_request['Range'] = "bytes=#{range.first}-#{range.last}" if range

      response = Net::HTTP.start(
        uri.hostname,
        uri.port,
        open_timeout: OPEN_TIMEOUT_SECONDS,
        read_timeout: READ_TIMEOUT_SECONDS,
        use_ssl: uri.scheme == 'https'
      ) { it.request(http_request) }

      case response
      when Net::HTTPSuccess then response.body
      when Net::HTTPRedirection
        raise "GET #{url} failed: too many redirects" if redirects_left.zero?

        request(response['location'], range: range, redirects_left: redirects_left - 1)
      when Net::HTTPServerError, Net::HTTPTooManyRequests
        raise RetryableStatus, "GET #{url} failed: #{response.code}"
      else
        raise "GET #{url} failed: #{response.code}"
      end
    end
  end
end
