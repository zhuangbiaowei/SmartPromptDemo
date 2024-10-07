require 'smart_prompt'
engine = SmartPrompt::Engine.new('./config/llm_config.yml')
text=File.read("./en.txt")
f = File.new("./zh.txt", "w")
text.split("\n").each do |line|
    if line == "```"
        puts result
        f.puts result
    else    
        result = engine.call_worker(:translator, {text: line, from: "English", to: "Chinese"})  unless line.empty?
        puts result
        f.puts result
    end
end
f.close