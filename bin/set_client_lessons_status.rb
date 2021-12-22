ClientLesson.find_each do |cl|
  next unless cl.client.present?
  if cl.start_time.present? && cl.end_time.present?
    cl.done!
  elsif cl.start_time.present?
    if cl.start_time.past?
      cl.missed!
    else
      cl.schedule!
    end
  else
    cl.to_schedule!
  end

  cl.save
end