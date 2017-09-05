require_relative './utils'

require 'openssl'
require 'digest'
require 'yaml'
require 'fileutils'

module Passkeep
  # The Vault is what keeps passwords safe
  #
  class Vault

    # @param name [String] The filename reference to the vault
    # @param password [String] The password that should be used to encrypt/decrypt the vault
    def initialize (name:, password:)
      @name     = name
      @password = password
    end

    # This is a getter method for the password data hash
    #
    def data
      return {} unless File.exist?(vault_path)
      
      encrypted_file_content = File.open(vault_path, 'rb') { |f| f.read }
      cipher = new_decryption_cipher
      decrypted_file_content = cipher.update(encrypted_file_content) + cipher.final

      password_data = YAML.load(decrypted_file_content)
    end

    # This is a setter method for the password data hash
    #
    def update (data)
      cipher = new_encryption_cipher
      encrypted_file_content = cipher.update(data.to_yaml) + cipher.final

      File.open(vault_path, 'wb') { |f| f.write(encrypted_file_content) }
      FileUtils.chmod(0600, vault_path)
    end

    private

    def vault_path
      File.join(Passkeep::Utils::VAULTS_DIR, "#{@name}.yaml")
    end

    def new_encryption_cipher
      cipher = OpenSSL::Cipher::AES256.new :CBC
      cipher.encrypt
      cipher.key = Digest::SHA256.digest(@password)
      cipher
    end

    def new_decryption_cipher
      cipher = OpenSSL::Cipher::AES256.new :CBC
      cipher.decrypt
      cipher.key = Digest::SHA256.digest(@password)
      cipher
    end
  end
end
