# frozen_string_literal: true

require "active_support"
require "date"

module InferModel
  class Parsers::DateTime
    extend Callable
    extend Dry::Initializer

    ACCEPTABLE_DATETIME_FORMATS = [
      "%Y-%m-%dT%T%z",
      "%Y-%m-%dT%T%Z",
      "%Y-%m-%dT%TZ",
      "%d.%m.%Y %T%z",
      "%d.%m.%Y %T%Z",
      "%d.%m.%Y %T",
      "%d.%m.%Y %H:%M",
      "%Y-%m-%dT",
      "%Y-%m-%d",
      "%d.%m.%Y",
    ].freeze

    param :value
    option :allow_blank, default: -> { true }
    option :time_zone_offset, optional: true
    option :time_zone, optional: true

    def call
      raise Parsers::Error, "value was blank which is not allowed" if value.nil? && !allow_blank
      return if value.nil? || value.empty?

      # make sure value parsed once before applying time zone
      # so formats are validated
      apply_time_zone(parsed_datetime)
    end

    private

    def apply_time_zone(datetime)
      if time_zone_offset
        datetime.change(offset: time_zone_offset)
      elsif time_zone
        Time.use_zone(time_zone) { Time.zone.parse(value) } # discard parsed result and parse again in assumed zone
      else
        datetime
      end
    end

    def parsed_datetime
      ACCEPTABLE_DATETIME_FORMATS.each do |format|
        return DateTime.strptime(value, format)
      rescue Date::Error
        next
      end

      raise Parsers::Error, "'#{value}' is not a DateTime"
    end
  end
end
