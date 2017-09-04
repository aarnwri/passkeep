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
      decrypt
      if File.readable?(vault_path)
        password_data = YAML.load_file(vault_path)
        encrypt
      else
        encrypt
        puts "Could not read vault at #{vault_path}."
        exit(1)
      end

      password_data
    end

    # This is a setter method for the password data hash
    #
    def update (data)
      if File.writable?(vault_path)
        File.open(vault_path, 'w') { |f| f.write data.to_yaml }
        FileUtils.chmod(0600, vault_path)
      else
        puts "Could not write to vault at #{vault_path}."
        exit(1)
      end
      encrypt
    end

    private

    # TODO: this method crashes when the wrong password is put in for the vault...
    def decrypt
      if File.exist?(vault_path) && File.readable?(vault_path) && File.writable?(vault_path)
        encrypted_file_content = File.read(vault_path)
        cipher = new_decryption_cipher
        decrypted_file_content = cipher.update(encrypted_file_content) + cipher.final
        File.write(vault_path, decrypted_file_content)
      elsif File.exist?(vault_path)
        # we don't have proper access...
        puts "Not enough permissions on vault at #{vault_path}."
        exit(1)
      else
        # we must not have created this vault yet...
        File.open(vault_path, 'w') { |f| f.write({}.to_yaml) }
      end
    end

    def encrypt
      decrypted_file_content = File.read(vault_path)
      cipher = new_encryption_cipher
      encrypted_file_content = cipher.update(decrypted_file_content) + cipher.final
      File.write(vault_path, encrypted_file_content)
    end

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
