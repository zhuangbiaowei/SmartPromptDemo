SmartPrompt.define_worker :get_date do
  use "ollama"
  model "qwen2.5-coder:14b"
  temperature 0.4
  response_format "json"
  prompt :get_date, {date_str: params[:text]}
  send_msg
end
