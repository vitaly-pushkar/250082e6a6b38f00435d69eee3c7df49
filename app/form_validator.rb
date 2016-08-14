require 'dry-validation'

class FormValidator
  attr_reader :schema, :params

  def initialize(params)
    @params = params
    @schema = validation_schema
  end

  def valid?
    messages.empty?
  end

  def errors_string
    messages.map { |k,v| "#{k}: #{v.join(', ')}" }.join('; ')
  end

  private
  def messages
    schema.call(params).messages
  end

  def validation_schema
    Dry::Validation.Form do
      required(:uid).filled(:str?, max_size?: 256)
      required(:pub0).filled(:str?, max_size?: 256)
      required(:page).filled(:int?, gt?: 0)
    end
  end
end
