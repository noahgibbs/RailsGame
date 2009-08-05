class CryptoKeysGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # m.directory "lib"
      m.template 'crypto_keys.sh', 'crypto_keys.sh'
    end
  end
end
