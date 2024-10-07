require 'smart_prompt'
engine = SmartPrompt::Engine.new('./config/llm_config.yml')
result = engine.call_worker(:daily_report, {location: "Shanghai"}) 
puts result
