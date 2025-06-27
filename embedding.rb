require "../smart_prompt/lib/smart_prompt"
require "sequel"
DB = Sequel.connect("postgres://docs:ment@localhost/docs")
engine = SmartPrompt::Engine.new("./config/llm_config.yml")
title = "浓烟滚滚！山东威海一化工企业突发爆炸，当地居民听到巨响"
content = "　10月24日下午，山东省威海市文登区虎山路附近一化工厂发生爆炸，发出巨大响声。现场浓烟滚滚，消防和警车已经到达现场，企业周边道路已经有交警在管制。　　24日16时左右，在文登区开发区，有居民听到一声巨响，“刚开始还以为是楼上住户的柜子倒了，砸在了地上，声音很大。”一位附近居民告诉津云新闻记者，当他从窗外望去，发现一处化工园区冒出滚滚浓烟。"
result = engine.call_worker(:get_embedding, {text: title + "  " + content, length: 1024})
insert_ds = DB["INSERT INTO documents (title, content, embedding) VALUES (?,?,?)", title, content, "[" + result.join(",") + "]"]
insert_ds.insert
