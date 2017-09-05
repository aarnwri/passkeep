require 'clipboard'

module Passkeep

  # This class formats password data for output
  #
  class PasswordDataFormatter
    attr_reader :data

    def initialize (data={})
      @data = data
    end

    def render_password_to_clipboard (key_name, login)
      raise "Unable to format missing data." unless has_login?(key_name, login)
      Clipboard.copy(@data[key_name][login]['password'].strip)
    end

    # valid options are :filter
    # :filter should be a hash with possible keys :key_name and/or :login
    def str_all_keys (options={})
      str = ""
      @data.keys.each do |key_name|
        if options[:filter] && options[:filter][:key_name]
          next unless key_name == options[:filter][:key_name]
        end
        str << str_key_name(key_name, options)
        str << "\n"
      end
      str
    end

    def str_key_name (key_name, options={})
      str = ""
      @data[key_name].keys.each do |login|
        if options[:filter] && options[:filter][:login]
          next unless login == options[:filter][:login]
        end
        str << str_login(login, @data[key_name][login], 1)
        str << "\n"
      end
      str
    end

    def str_login (login, login_data, indent_level)
      str = ""
      str << "#{"  " * indent_level}login: #{login}\n"
      str << "#{"  " * indent_level}password: #{login_data['password']}\n"
      str << "#{"  " * indent_level}url: #{login_data['url']}\n"
      str << "#{"  " * indent_level}meta: #{login_data['meta']}\n"
      str
    end

    def has_login? (key_name, login)
      @data[key_name] && @data[key_name][login]
    end
  end
end
