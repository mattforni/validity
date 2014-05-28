module Validity
  # The Validity::Record module contains testing logic specific to ActiveRecord.
  # Example Usage:
  #   @user = Record.validates(User.new)
  #   @user.field_uniqueness(:email)
  #   @user.field_presence(:email)
  #
  # Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
  # License::   MIT
  class Record
    include Validity

    attr_reader :record

    # Creates a Validity::Record for validation.
    #
    # * *Args*:
    #   - +record+ the ActiveRecord model to validate
    # * *Returns*:
    #   - a newly created Validity::Record object
    # * *Raises*:
    #   - +Unconfigured+ if Validity is not configured
    def self.validates(record)
      Validity.check_configured!
      Record.new(record)
    end

    # Asserts the record has a +belongs_to+ association as indicated by the provided
    # +field+ and that the record equals the +target+ record, if provided.
    #
    # * *Args*:
    #   - +field+ the fields to check for has_many association
    #   - +targets+ the target associated records
    def belongs_to(field, target = nil)
      test_class.belongs_to @record, field, target
    end

    # Asserts that the record responds to the +delegated+ method and that
    # the returned object is equal to the object referenced by +delegated_to+.
    #
    # * *Args*:
    #   - +field+ the fields to check for presence
    def delegates(delegated, delegated_to)
      test_class.delegates @record, delegated, delegated_to
    end

    # Asserts that the given +field+ must be present for the record to be valid.
    #
    # * *Args*:
    #   - +field+ the fields to check for presence
    def field_presence(field)
      test_class.field_presence @record, field
    end

    # Asserts that the given +field+ must be unique for the record to be valid.
    #
    # * *Args*:
    #   - +field+ the fields to check for uniqueness
    def field_uniqueness(field)
      test_class.field_uniqueness @record, field
    end

    # Asserts the record has a +has_many+ association as indicated by the provided
    # +field+ and that the many records equal the +targets+ records, if provided.
    #
    # * *Args*:
    #   - +field+ the fields to check for has_many association
    #   - +targets+ the target associated records
    def has_many(field, targets = nil)
      test_class.has_many @record, field, targets
    end

    private

    attr_writer :record

    # Creates a Validity::Record for validation.
    #
    # * *Args*:
    #   - +record+ the ActiveRecord model to validate
    # * *Returns*:
    #   - a newly created Validity::Record object
    def initialize(record)
      self.record = record
    end

    # Returns the test class to be used based on the current configuration.
    #
    # * *Returns*:
    #   - the test class to use based on the current configuration.
    def test_class
      @@test_framework::Record
    end
  end
end

