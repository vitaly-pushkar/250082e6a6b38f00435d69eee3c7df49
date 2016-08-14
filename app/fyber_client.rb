require 'httparty'
require 'pry'

class FyberClient
  InvalidResponseSignature = Class.new(StandardError)
  include HTTParty

  base_uri 'api.fyber.com'

  BASE_PARAMS = App.config.base_params.freeze
  BASE_PATH = App.config.base_path.freeze
  API_KEY = App.config.api_key.freeze

  def call(options = {})
    params = BASE_PARAMS
             .merge(options)
             .merge(timestamp: Time.now.to_i)

    request_url = generate_request_url(params, API_KEY)

    response = self.class.get(request_url)
    validate_response_hash(response, API_KEY)
  end

  private

  def generate_request_url(params, api_key)
    query_string = hash_to_query_string(params)
    hash_key = generate_hash_key(query_string, api_key)

    "#{BASE_PATH}?#{query_string}&hashkey=#{hash_key}"
  end

  def hash_to_query_string(params_hash)
    stringify_keys(params_hash).sort.map { |k, v| "#{k}=#{v}" }.join('&')
  end

  def generate_hash_key(query_string, api_key)
    signed_query_string = query_string + "&#{api_key}"

    hash(signed_query_string)
  end

  def validate_response_hash(response, api_key)
    return response unless response.code == 200

    signature = response.headers['X-Sponsorpay-Response-Signature']
    response_hash = hash(response.body + api_key)

    unless signature == response_hash
      message = 'Response signature is not matching! May be a fake response.'
      raise InvalidResponseSignature, message
    end

    response
  end

  def hash(string)
    Digest::SHA1.hexdigest string
  end

  def stringify_keys(hash)
    Hash[hash.collect { |k, v| [k.to_s, v] }]
  end
end
