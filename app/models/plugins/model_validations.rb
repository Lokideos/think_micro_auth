# frozen_string_literal: true

module Sequel::Plugins::ModelValidations
  class ModelValidationFailed < StandardError; end

  module InstanceMethods
    private

    def validate_with!(validation, values)
      result = validate_with(validation, values)
      raise ModelValidationFailed, { errors: result.errors.to_h } if result.failure?

      result
    end

    def validate_with(validation, values)
      contract = validation.new
      contract.call(values)
    end
  end
end
