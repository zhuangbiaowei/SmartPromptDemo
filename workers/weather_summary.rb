SmartPrompt.define_worker :weather_summary do
  use "ollama"
  model "gemma2"
  sys_msg "You are a helpful weather assistant."
  prompt :weather, { location: params[:location], date: params[:date] }
  weather_info = send_msg  
  prompt :summarize, { text: weather_info }
  send_msg
end