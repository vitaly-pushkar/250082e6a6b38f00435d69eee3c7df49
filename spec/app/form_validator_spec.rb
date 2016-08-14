require 'spec_helper'

RSpec.describe FormValidator do
  context '#valid?' do
    it 'returns true if all parameters pass validations' do
      result = FormValidator.new(uid: '123', pub0: 'pub0', page: 1).valid?
      expect(result).to be true
    end

    it 'returns false if at least one parameter is invalid' do
      result = FormValidator.new(uid: '123', pub0: 'pub0', page: 0).valid?
      expect(result).to be false
    end
  end

  context '#errors_string' do
    it 'returns all errors in one string' do
      result = FormValidator.new(uid: '123', pub0: 'pub0', page: 0)
        .errors_string

      expect(result).to be_a String
      expect(result).to_not be_empty
    end

    it 'returns empty string for no errors' do
      result = FormValidator.new(uid: '123', pub0: 'pub0', page: 1)
        .errors_string

      expect(result).to be_empty
    end
  end
end
