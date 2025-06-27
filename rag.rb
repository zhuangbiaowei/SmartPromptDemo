require "../smart_prompt/lib/smart_prompt"
require "sequel"
DB = Sequel.connect("postgres://docs:ment@localhost/docs")

engine = SmartPrompt::Engine.new("./config/llm_config.yml")

quest = "化工厂爆炸的新闻有哪些？"

result = engine.call_worker(:get_embedding, {text: quest, length: 1024})

sql = "SELECT title, content, 1 - (embedding <=> ?) AS similarity FROM documents ORDER BY similarity DESC"

res = DB[sql, "[" + result.join(",") + "]"].first

result = engine.call_worker(:answer, {prompt_doc: res.to_s, prompt: quest})

puts result
