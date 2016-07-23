require "json"

class Sense::API
  module Sensors
    struct CurrentSensors
      JSON.mapping(
        particulates: Summary,
        humidity: Summary,
        sound: Summary,
        temperature: Summary,
        light: Summary,
      )

      struct Summary
        JSON.mapping(
          unit: String,
          condition: String,
          message: String,
          value: Float64,
          last_updated_utc: UInt64,
          ideal_conditions: String,
        )

        def last_updated
          Time.epoch_ms(last_updated_utc).to_local
        end
      end
    end

    struct SensorDatum
      JSON.mapping({
        datetime: UInt64,
        value: Float64,
        offset_millis: UInt64
      })

      def time
        Time.epoch_ms(datetime).to_local
      end
    end

    def current_sensors(temp_unit = 'c')
      resp = @client.get("/v1/room/current")
      CurrentSensors.from_json(resp.body)
    end

    macro define_room_sensor(name)
      def {{name}}_by_week(from = Time.now)
        resp = @client.get("/v1/room/{{name}}/week?from=#{from.epoch_ms}")
        Array(SensorDatum).from_json(resp.body)
      end

      def {{name}}_by_day(from = Time.now - 5.minutes)
        resp = @client.get("/v1/room/{{name}}/day?from=#{from.epoch_ms}")
        begin
          Array(SensorDatum).from_json(resp.body)
        rescue ex : JSON::ParseException
          puts resp.body
          [] of SensorDatum
        end
      end
    end

    define_room_sensor(temperature)
    define_room_sensor(sound)
    define_room_sensor(light)
    define_room_sensor(particulates)
    define_room_sensor(humidity)
  end
end
