class RgCryptoKeysGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.template 'crypto_keys.sh', 'crypto_keys.sh'
    end
  end

end
