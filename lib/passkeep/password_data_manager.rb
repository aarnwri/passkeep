require 'clipboard'

module Passkeep

  # This class manages the password data hash
  # The format of this hash shoul look something like this:
  # {
  #   <key_name>:
  #     <login>:
  #       password: <password>
  #       url: <url>
  #       meta: <anything_string>
  # }
  class PasswordDataManager
    attr_reader :data

    def initialize (data={})
      @data = data
    end

    def show_login_info (key_name, login, options={})
      output = "Key name provided could not be found...\n"
      if @data[key_name]
        output = "Login provided could not be found...\n"
        if @data[key_name][login]
          if options[:clipboard]
            Clipboard.copy(@data[key_name][login]['password'].strip)
          end
          output = "Password data:\n"
          output << "\n"
          output << "#{key_name}:\n"
          output << "  #{login}:\n"
          output << "    password: ******\n"
          output << "    url: #{@data[key_name][login]['url']}\n"
          output << "    meta: #{@data[key_name][login]['meta']}\n"
        end
      end

      output
    end

    def show_key_info (key_name)
      output = "Key name provided could not be found...\n"
      if @data[key_name]
        output = "Password data:\n"
        output << "#{key_name}:\n"
        @data[key_name].each do |login, login_data|
          output << "\n"
          output << "  #{login}:\n"
          output << "    password: ******\n"
          output << "    url: #{login_data['url']}\n"
          output << "    meta: #{login_data['meta']}\n"
        end
      end

      output
    end

    def set_password (key_name, login, password)
      ensure_login(key_name, login)
      @data[key_name][login]['password'] = password
    end

    def set_url (key_name, login, url)
      ensure_login(key_name, login)
      @data[key_name][login]['url'] = url
    end

    def set_meta (key_name, login, meta)
      ensure_login(key_name, login)
      @data[key_name][login]['meta'] = meta
    end

    def ensure_login (key_name, login)
      @data[key_name] ||= {}
      @data[key_name][login] ||= {}
    end

    def has_login? (key_name, login)
      @data[key_name] && @data[key_name][login]
    end

    def remove_password (key_name, login, password)
      @data[key_name][login].delete('password') if has_login?(key_name, login)
      clean_up_login(key_name, login)
    end

    def remove_url (key_name, login, url)
      @data[key_name][login].delete('url') if has_login?(key_name, login)
      clean_up_login(key_name, login)
    end

    def remove_meta (key_name, login, meta)
      @data[key_name][login].delete('meta') if has_login?(key_name, login)
      clean_up_login(key_name, login)
    end

    def clean_up_login (key_name, login)
      unless @data[key_name][login]['password'] || @data[key_name][login]['url'] || @data[key_name][login]['meta']
        @data[key_name].delete(login)
        clean_up_key_name(key_name)
      end
    end

    def clean_up_key_name (key_name)
      @data.delete(key_name) unless @data[key_name].keys.count > 0
    end
  end
end
