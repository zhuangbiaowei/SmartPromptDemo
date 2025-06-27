require "../smart_prompt/lib/smart_prompt"
engine = SmartPrompt::Engine.new("./config/llm_config.yml")
text = File.read("./en.txt")
result = engine.call_worker(:reflective_translation, {text: text, source_language: "English", target_language: "Chinese"})
puts result
