require "../smart_prompt/lib/smart_prompt"
engine = SmartPrompt::Engine.new("./config/llm_config.yml")
Words = {}

def translate_text(engine, text)
  checked = true
  count = 0
  result = ""
  while checked == true && count < 10
    puts "try #{count}"
    result = engine.call_worker(:categorized_translation, {
        text: text, 
        source_language: "English", 
        target_language: "Chinese"})
    checked =
      (result.include?("{") && result.include?("}")) ||
      (result.include?("```") || result.include?("```json")) ||
      result.include?("**Output**") ||
      result.include?("**输出**") ||
      (result.split("\n").size > text.split("\n").size)
    count += 1
  end
  result
end

book = File.read("../OpenLife.txt")
new_book = File.new("../OpenLife_new.txt", "w+")

book.split("\n").each do |line|
  if line.strip.empty?
    result = line
  elsif Words.has_key?(line)
    result = Words[line]
  else
    result = translate_text(engine, line)
    Words[line] = result
  end
  new_book.puts result
end
new_book.close
