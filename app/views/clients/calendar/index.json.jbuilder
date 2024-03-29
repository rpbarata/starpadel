# frozen_string_literal: true

json.array!(@events) do |event|
  json.extract!(event, :id, :title)
  json.start(event.start_time)
  json.end(event.end_time)
  json.color("#ffa722")
end
