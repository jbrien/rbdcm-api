require 'spec_helper'

describe DCM::Client do
  before do
    @keys = DCM::Configuration::VALID_CONFIG_KEYS
    @config = {
        access_key: 'ak',
        secret_key: 'of',
        endpoint: 'ep',
        api_version: 'rf',
        user_agent: 'ua',
        method: 'hm'
    }
  end

  describe '#new' do
    it 'raises an ConfigurationError' do
      expect { DCM::Client.new( access_key: 1234 ).to raise_exception(DCM::Error::ConfigurationError)}
    end
    it 'raises an MissingConfigurationError' do
      expect { DCM::Client.new( access_key: nil ).to raise_exception(DCM::Error::MissingConfigurationError)}
    end
  end

  describe 'module configuration' do
    before do
      DCM.configure do |config|
        @keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    it 'should inherit module configuration' do
      @keys.each do |key|
        api = DCM::Client.new
        expect(api.send(key)).to eq(key)
      end
    end
  end

  describe 'with class configuration' do

    it 'should override module configuration' do
      api = DCM::Client.new(@config)
      @keys.each do |key|
        expect(api.send(key)).to eq(@config[key])
      end
    end

    it 'should override module configuration after' do
      api = DCM::Client.new(access_key: '1234', secret_key: '4321')

      @config.each do |key, value|
        api.send("#{key}=", value)
      end

      @keys.each do |key|
        expect(api.send("#{key}")).to eq(@config[key])
      end
    end

  end

  after do
    DCM.reset
  end

end
