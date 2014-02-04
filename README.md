# Magnetize

CLI and library for generating Magento local.xml files.
Generates both `app/etc/local.xml` and `errors/local.xml` from the a specified [TOML]() configuration file.
Also supports converting an existing Magento XML configuration file into a TOML file.

Prefixes the TOML data with the `type` of Magento configuration file so that multiple Magento `local.xml` files can be stored in a common configuration and then seperate files be generated larter.

Supports arbitrary values in the both the `local.xml` and toml config, so new configration can be added without prior knowlege.


## Installation

Add this line to your application's Gemfile:

    gem 'magnetize'

Or install it yourself as:

    $ gem install magnetize


## Usage

### CLI

* `$ magnetize help`

### Library

```ruby
require 'magnetize'

opts = {
  :types => {
    'app' => {
      :magento => 'app/etc/local.xml',
      :toml => 'config.toml'
    },
    'errors' => {
      :magento => 'errors/local.xml',
      :toml => 'config.toml'
    }
  }
}

Magnetize::Convert.new.to_toml(opts)

# => {"app"=> "[app.config.admin.routers.adminhtml.args]\nfrontName = \"admin\"\n[app.config.global]\ndisable_local_modules = \"false\"\n[app.config.global.crypt]\nkey = \"foo\"\n[app.config.global.install]\ndate = \"Tue, 04 Feb 2014\"...", "errors"=> "..."}

Magnetize::Convert.new.to_magento(opts)

# => {"app"=> "<config><admin><routers><adminhtml><args><frontName>admin</frontName></args></adminhtml></routers></admin><global><disable_local_modules>false</disable_local_modules><crypt><key>foo</key></crypt><install><date>Tues, 04 Feb 2014...," "error"=> ".."}

```


## Version 1

Version 1 is functionally equivalent in that it generates `local.xml` files from `ENV`. However it relies on all configuration values being present in the template which it's output to. This means it's inflexible when dealing with new configuration options.

Version 2 is a complete re-write and as such is API incompatable with V1. V1 is available here on [this branch](https://github.com/rjocoleman/magnetize/tree/v1)


## Contributing

1. Fork it ( http://github.com/<my-github-username>/magnetize/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
