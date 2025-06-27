require "smart_prompt"

SmartPrompt.define_worker :smart_bot do
  use "SiliconFlow"
  model "deepseek-ai/DeepSeek-V3"
  sys_msg "你是一个聪明的智能助手。"
  prompt :summarize, { text: params[:text] }
  send_msg
end

engine = SmartPrompt::Engine.new("./config/llm_config.yml")
result = engine.call_worker(:smart_bot, { text: "已知：张聪明的父亲名叫张老实，张老实只有一个儿子。我们能够推论出什么？", with_history: true })
puts result
result = engine.call_worker(:smart_bot, { text: "请用中文回答我：张老实的儿子叫什么名字？", with_history: true })
puts result
engine.clear_history_messages
result = engine.call_worker(:smart_bot, { text: "请用中文回答我：张老实的儿子叫什么名字？", with_history: false })
puts result
