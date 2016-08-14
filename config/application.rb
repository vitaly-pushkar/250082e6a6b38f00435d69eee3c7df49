module App
  extend Dry::Configurable

  setting :api_key, ENV['FYBER_API_KEY']

  setting :base_path, '/feed/v1/offers.json'

  setting :base_params,
          appid: 157,
          format: 'json',
          device_id: '2b6f0cc904d137be2e1730235f5664094b83',
          ip: '109.235.143.113',
          locale: 'de',
          offer_types: 112
end
