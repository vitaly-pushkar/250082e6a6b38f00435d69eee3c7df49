require 'httparty'
require 'pry'

class FyberClient
  InvalidResponseSignature = Class.new(StandardError)
  include HTTParty

  base_uri 'api.fyber.com'

  def api_key
    ENV['FYBER_API_KEY'] || 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'
  end

  def base_path
    '/feed/v1/offers.json'
  end

  def base_params
    {
      appid: 157,
      format: 'json',
      device_id: '2b6f0cc904d137be2e1730235f5664094b83',
      ip: '109.235.143.113',
      locale: 'de',
      offer_types: 112,
      timestamp: Time.now.to_i
    }
  end

  def call(options = {})
    params = base_params.merge(options)
    request_url = generate_request_url(params, api_key)

    response = self.class.get(request_url)

    validate_response_hash(response, api_key)
  end

  private

  def generate_request_url(params, api_key)
    query_string = hash_to_query_string(params)
    hash_key = generate_hash_key(query_string, api_key)

    "#{base_path}?#{query_string}&hashkey=#{hash_key}"
  end

  def hash_to_query_string(params_hash)
    stringify_keys(params_hash).sort.map{|k,v| "#{k}=#{v}"}.join('&')
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
    Hash[hash.collect{|k,v| [k.to_s, v]}]
  end
end
