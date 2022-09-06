# frozen_string_literal: true

# libraries
require "dotenv/load"
require "dry-initializer"
require "pry"

# generics
require_relative "infer_model/callable"
require_relative "infer_model/common_type"
require_relative "infer_model/value_type_guesser"
require_relative "infer_model/common_type_guesser"

# adapters
require_relative "infer_model/from"
require_relative "infer_model/from/csv"
require_relative "infer_model/to"
require_relative "infer_model/to/migration"
require_relative "infer_model/to/text"

# main classes
require_relative "infer_model/task"
require_relative "infer_model/version"

module InferModel
  class Error < StandardError; end

  class << self
    def from(...) = Task.from(...)
    def to(...) = Task.to(...)
  end
end
