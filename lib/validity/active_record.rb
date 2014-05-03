# Author::    Matt Fornaciari (mailto:mattforni@gmail.com)
# License::   MIT

module Validity
  # The Validity::ActiveRecord module contains testing logic specific to ActiveRecord
  module ActiveRecord
    # Creates an ActiveRecord::Wrapper to test against
    def validates(record)
      Wrapper.new(record)
    end

    private

    # The Wrapper class is just a thin wrapper around the ActiveRecord model
    # which defines several methods to validate a model behaves as it should.
    # Example Usage:
    #   validates(@model).field_presence(:required)
    class Wrapper 
      include Test::Unit::Assertions

      # Creates a new instance of Validity::ActiveRecord::Wrapper to test against
      def initialize(record)
        @record = record
      end

      # Asserts that the record has a belongs_to association and that the
      # associated record equals the +target+ record, if provided.
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
      # the returned object is equal to the object referenced by +delegated_to+
      def delegates(delegated, delegated_to)
        clazz = @record.class
        assert_respond_to @record, delegated, "#{clazz} does not respond to #{delegated}"
        assert_equal delegated_to.send(delegated), @record.send(delegated), "Delegated objects do not match"
      end

      # Asserts that the +field+ field must be present for the record to be valid
      def field_presence(field)
        @record.send("#{field}=", nil)

        clazz = @record.class
        assert !@record.valid?, "#{clazz} is considered valid with nil #{field}"
        assert !@record.save, "#{clazz} saved without #{field} field"
        assert @record.errors[field].any?, "#{clazz} does not have an error on #{field}"
      end

      # Asserts that the +field+ field must be unique for the record to be valid
      def field_uniqueness(field)
        dup = @record.dup

        clazz = dup.class
        assert !dup.valid?, "#{clazz} is considered valid with duplicate #{field}"
        assert !dup.save, "#{clazz} saved with a duplicate #{field}"
        assert dup.errors[field].any?, "#{clazz} does not have an error on #{field}"
      end

      # Asserts that the record has a has_many association and that the
      # associated records equal the +targets+ records, if provided.
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

      attr_reader :record
    end
  end
end

