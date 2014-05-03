# This gem attempts to provide a library to easily test validations on
# ActiveRecord models. The ultimate goal is to make spinning up and testing a
# data model for a Ruby on Rails stack both quick and painless.  The
# syntactical structure of this library is based losely upon rspec's
# expect/match syntax as it seems to lend itself well to testing readability.
#
# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

require 'test/unit/assertions'
require 'validity/active_record'

