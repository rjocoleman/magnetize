# magnetize

CLI for generating Magento local.xml files.
Generates both `app/etc/local.xml` and `errors/local.xml` from the local enviroment variables or `.env` files.


## Installation

`$ gem install magnetize`


## Usage

* See `.env.sample` for example usage of `.env` and the valid enviroment variables.
* Create a .env file or set an ENV.
* `$ magnetize configure`


### Generating config for different environments

It's possible to use environment specific `.env` files to generate different sets of config.
For example: 

* Create `.env` with local development configuration values.
* `$ magnetize configure`

* Create `.env.production` with production configuration values.
* `$ magnetize configure --environment production`


### Variable selection

Variable selection is hierarchical in decending priority order:

1. `.env` file for specified environment e.g `.env.test` for `--environment test`
2. Generic `.env` file, named exactally `.env`
3. Process ENV variables e.g `magento_crypt_key=hello magnetize configure`
4. User ENV.
5. Process ENV.


## Help

`$ magnetize --help`
