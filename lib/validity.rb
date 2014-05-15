# This gem provides a library aimed at making testing easy.  At this point it
# is aimed at testing ActiveRecord models, though the ultimate goal is to make
# spinning up a Ruby on Rails stack both quick and painless.  The
# syntactical structure of this library is based losely upon rspec's
# expect/match syntax as it seems to lend itself well to testing readability.
# This testing library is test framework agnostic, though it currently only
# supports test-unit and rspec.  Which framework you would like to use must
# be configured prior to use.  Happy testing!
#
# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

require 'test/unit/assertions'
require 'validity/record'

module Validity
  # Configures Validity to use the provided test_module.
  #
  # * *Args*:
  #   - +test_module+ the module to use for testing
  # * *Returns*:
  #   - the test module Validity was configured to use
  # * *Raises*:
  #   - +Unsupported+ if the provided test module is unsupported
  def self.configure(test_module)
    raise Unsupported.new(test_module) if !supported?(test_module)
    @@test_module = test_module
  end

  # Returns whether or not Validity is configured.
  #
  # * *Returns*:
  #   - whether or not Validity has been configured
  def self.configured?
    !@@test_module.nil?
  end

  # Resets Validity to an unconfigured state.
  def self.reset!
    @@test_module = nil
  end

  # Returns a list of test modules Validity supports.
  #
  # * *Returns*:
  #   - a list of test modules Validity supports
  def self.supported
    SUPPORTED
  end

  # A Validity specific error signifying an unsupported test module.
  #
  # Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
  # License::   MIT
  class Unsupported < RuntimeError
    def initialize(test_module)
      super(UNSUPPORTED % {test_module: test_module})
    end
  end

  # A Validity specific error signifying Validity is unconfigured.
  #
  # Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
  # License::   MIT
  class Unconfigured < RuntimeError
    def initialize
      super('Validity must be configured before use')
    end
  end

  protected

  # Checks if Validity is configured and raises an error if is not.
  #
  # * *Raises*:
  #   - +Unconfigured+ if Validity is not configured
  def self.check_configured!
    raise Unconfigured.new if !configured?
  end

  module TestUnit
  end

  module RSpec
  end

  SUPPORTED = [TestUnit]
  UNSUPPORTED = "%{test_module} is not a supported test module, please specify one of #{SUPPORTED.join(', ')}"

  private

  @@test_module = nil

  # Returns whether or not a test module is supported by Validity.
  #
  # * *Args*:
  #   - +test_module+ the module to check
  # * *Returns*:
  #   - whether or not the module is supported by Validity
  def self.supported?(test_module)
    SUPPORTED.include?(test_module)
  end
end

