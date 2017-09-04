require 'trollop'

module Passkeep
  class AddMenu
    BANNER =
"""
This command is for adding passwords.

Usage:  passkeep add [options]

Options:

"""

    def self.parse
      Trollop::options do
        banner BANNER

        opt :key_name, "Key name to identify the needed password information.", type: :string, required: true
        opt :login, "User login.", type: :string, required: true
        opt :url, "Url to the login page", type: :string
        opt :meta, "Anything you want to add", type: :string
      end
    end
  end
end
