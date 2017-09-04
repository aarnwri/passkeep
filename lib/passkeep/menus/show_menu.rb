require 'trollop'

module Passkeep
  class ShowMenu
    BANNER =
"""
This command is for showing passwords for a given key name.

Usage:  passkeep show [options]

Options:

"""

    def self.parse
      Trollop::options do
        banner BANNER

        opt :key_name, "Key name to identify the needed password information.", type: :string, required: true
        opt :login, "Login name to identify the needed password information.", type: :string
        opt :clipboard, "Copy password associated with login to clipboard.", type: :boolean
      end
    end
  end
end
