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
    include Test::Unit::Assertions
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
      clazz = @record.class
      assert_respond_to @record, field, "#{clazz} cannot find associated #{field}"

      one = @record.send(field)
      assert_not_nil one, "#{clazz} does not have associated #{field}"
      if target
        assert_equal target, one, "#{field.to_s.capitalize} associated with this #{clazz.to_s.downcase} is not the target #{field}"
      end
    end

    # Asserts that the record responds to the +delegated+ method and that
    # the returned object is equal to the object referenced by +delegated_to+.
    #
    # * *Args*:
    #   - +field+ the fields to check for presence
    def delegates(delegated, delegated_to)
      clazz = @record.class
      assert_respond_to @record, delegated, "#{clazz} does not respond to #{delegated}"
      assert_equal delegated_to.send(delegated), @record.send(delegated), "Delegated objects do not match"
    end

    # Asserts that the given +field+ must be present for the record to be valid.
    #
    # * *Args*:
    #   - +field+ the fields to check for presence
    def field_presence(field)
      @record.send("#{field}=", nil)

      clazz = @record.class
      assert !@record.valid?, "#{clazz} is considered valid with nil #{field}"
      assert !@record.save, "#{clazz} saved without #{field} field"
      assert @record.errors[field].any?, "#{clazz} does not have an error on #{field}"
    end

    # Asserts that the given +field+ must be unique for the record to be valid.
    #
    # * *Args*:
    #   - +field+ the fields to check for uniqueness
    def field_uniqueness(field)
      dup = @record.dup

      clazz = dup.class
      assert !dup.valid?, "#{clazz} is considered valid with duplicate #{field}"
      assert !dup.save, "#{clazz} saved with a duplicate #{field}"
      assert dup.errors[field].any?, "#{clazz} does not have an error on #{field}"
    end

    # Asserts the record has a +has_many+ association as indicated by the provided
    # +field+ and that the many records equal the +targets+ records, if provided.
    #
    # * *Args*:
    #   - +field+ the fields to check for has_many association
    #   - +targets+ the target associated records
    def has_many(field, targets = nil)
      clazz = @record.class
      assert_respond_to @record, field, "#{clazz} cannot find associated #{field}"

      many = @record.send(field)
      assert !(many.nil? || many.empty?), "#{clazz} does not have associated #{field}"
      if targets
        assert_equal targets.size, many.size, "#{clazz} does not have #{targets.size} associated #{field}"
      end
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
  end
end

