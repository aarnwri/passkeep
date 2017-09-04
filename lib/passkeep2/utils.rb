require 'fileutils'

module Passkeep2
  module Utils
    PASSKEEP_DIR  = File.join(Dir.home, '.passkeep')
    VAULTS_DIR    = File.join(PASSKEEP_DIR, 'vaults')
    DEFAULT_VAULT = 'default'

    def self.default_vault_path
      File.join(VAULTS_DIR, "#{DEFAULT_VAULT}.yaml")
    end

    def self.ensure_passkeep_dir
      # TODO: test for mkdir failure
      # TODO: make sure this directory is writable
      FileUtils.mkdir_p(PASSKEEP_DIR, :mode => 0700) unless Dir.exist?(PASSKEEP_DIR)
    end

    def self.ensure_vaults_dir
      # TODO: test for mkdir failure
      # TODO: make sure this directory is writable
      FileUtils.mkdir_p(VAULTS_DIR, :mode => 0700) unless Dir.exist?(VAULTS_DIR)
    end
  end
end
