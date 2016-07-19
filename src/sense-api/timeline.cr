require "json"

class Sense::API
  module Timeline
    struct Timeline
      struct Event
        JSON.mapping(
          timestamp: UInt64,
          timezone_offset: UInt64,
          duration_millis: UInt64,
          message: String,
          sleep_depth: UInt8,
          sleep_state: String,
          event_type: String,
          valid_actions: Array(String),
        )

        def time
          Time.epoch_ms(timestamp).to_local
        end
      end
      JSON.mapping(
        score: UInt8,
        score_condition: String,
        message: String,
        date: String,
        events: Array(Event),
      )
    end

    def timeline(date = Time.now.date)
      resp = @client.get("/v2/timeline/#{date.to_local.to_s("%Y-%m-%d")}")
      Timeline.from_json(resp.body)
    end
  end
end
