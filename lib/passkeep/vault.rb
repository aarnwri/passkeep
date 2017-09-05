require 'openssl'
require 'digest'
require 'yaml'
require 'fileutils'

module Passkeep
  # The Vault is what keeps passwords safe
  #
  class Vault
    VAULTS_DIR    = File.join(Dir.home, '.passkeep', 'vaults')
    DEFAULT_VAULT = 'default'

    # @param name [String] The filename reference to the vault
    # @param password [String] The password that should be used to encrypt/decrypt the vault
    def initialize (name: nil, password:)
      @name     = name || DEFAULT_VAULT
      @password = password

      ensure_vaults_dir
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

    def ensure_vaults_dir
      # TODO: test for mkdir failure
      # TODO: make sure this directory is writable
      FileUtils.mkdir_p(VAULTS_DIR, :mode => 0700) unless Dir.exist?(VAULTS_DIR)
    end

    def vault_path
      File.join(VAULTS_DIR, "#{@name}.yaml")
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
