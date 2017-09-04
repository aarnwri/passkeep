require 'trollop'

module Passkeep
  class MainMenu
    SUB_COMMANDS = [
      'add',
      'show'
    ]

    BANNER =
"""
This is a utility for managing passwords.

Usage:  passkeep [options] COMMAND

COMMANDS:
  add           add 'PASSWORD'
  show          show password for given key name

Options:

"""

    def self.parse
      Trollop::options do
        banner BANNER

        stop_on SUB_COMMANDS
      end
    end
  end
end
