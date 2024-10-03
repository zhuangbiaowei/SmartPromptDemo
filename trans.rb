require 'smart_prompt'
engine = SmartPrompt::Engine.new('./config/llm_config.yml')
result = engine.call_worker(:translator, {text: File.read("./en.txt"), from: "English", to: "Chinese"}) 
puts result