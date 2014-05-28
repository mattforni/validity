module Validity
  module TestUnit
    module Record
      extend Test::Unit::Assertions
      # Asserts a record has a +belongs_to+ association as indicated by the provided
      # +field+ and that the record equals the +target+ record, if provided.
      #
      # * *Args*:
      #   - +record+ the record to validate
      #   - +field+ the fields to check for has_many association
      #   - +targets+ the target associated records
      def self.belongs_to(record, field, target)
        clazz = record.class
        assert_respond_to record, field, "#{clazz} cannot find associated #{field}"

        one = record.send(field)
        assert_not_nil one, "#{clazz} does not have associated #{field}"
        if target
          assert_equal target, one, "#{field.to_s.capitalize} associated with this #{clazz.to_s.downcase} is not the target #{field}"
        end
      end

      # Asserts that a record responds to the +delegated+ method and that
      # the returned object is equal to the object referenced by +delegated_to+.
      #
      # * *Args*:
      #   - +record+ the record to validate
      #   - +field+ the fields to check for presence
      def self.delegates(record, delegated, delegated_to)
        clazz = record.class
        assert_respond_to record, delegated, "#{clazz} does not respond to #{delegated}"
        assert_equal delegated_to.send(delegated), record.send(delegated), "Delegated objects do not match"
      end

      # Asserts that the given +field+ must be present for a record to be valid.
      #
      # * *Args*:
      #   - +record+ the record to validate
      #   - +field+ the fields to check for presence
      def self.field_presence(record, field)
        record.send("#{field}=", nil)

        clazz = record.class
        assert !record.valid?, "#{clazz} is considered valid with nil #{field}"
        assert !record.save, "#{clazz} saved without #{field} field"
        assert record.errors[field].any?, "#{clazz} does not have an error on #{field}"
      end

      # Asserts that the given +field+ must be unique for a record to be valid.
      #
      # * *Args*:
      #   - +record+ the record to validate
      #   - +field+ the fields to check for uniqueness
      def self.field_uniqueness(record, field)
        dup = record.dup

        clazz = dup.class
        assert !dup.valid?, "#{clazz} is considered valid with duplicate #{field}"
        assert !dup.save, "#{clazz} saved with a duplicate #{field}"
        assert dup.errors[field].any?, "#{clazz} does not have an error on #{field}"
      end

      # Asserts a record has a +has_many+ association as indicated by the provided
      # +field+ and that the many records equal the +targets+ records, if provided.
      #
      # * *Args*:
      #   - +record+ the record to validate
      #   - +field+ the fields to check for has_many association
      #   - +targets+ the target associated records
      def self.has_many(record, field, targets)
        clazz = record.class
        assert_respond_to record, field, "#{clazz} cannot find associated #{field}"

        many = record.send(field)
        assert !(many.nil? || many.empty?), "#{clazz} does not have associated #{field}"
        if targets
          assert_equal targets.size, many.size, "#{clazz} does not have #{targets.size} associated #{field}"
        end
      end
    end
  end
end

