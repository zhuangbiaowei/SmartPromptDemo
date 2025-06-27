require "epub/maker"
require "../smart_prompt/lib/smart_prompt"
engine = SmartPrompt::Engine.new("./config/llm_config.yml")
Words = {}

def translate_text(engine, text)
  checked = true
  count = 0
  result = ""
  while checked == true && count < 10
    puts "try #{count}"
    result = engine.call_worker(:categorized_translation, {text: text, source_language: "English", target_language: "Chinese"})
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

def translate_page(engine, doc)
  doc.traverse do |node|
    if node.text? && !node.content.strip.empty?
      puts "原文：#{node.content}"
      if Words.has_key?(node.content)
        result = Words[node.content]
      else
        result = translate_text(engine, node.content)
        Words[node.content] = result
      end
      puts "译文：#{result}"
      node.content = result
    end
  end
end

book = EPUB::Parser.parse("../OpenLife.epub")
i = 0

title = book.metadata.title
puts "原文：#{title}"
title2 = translate_text(engine, title)
Words[title] = title2
puts "译文：#{title2}"
book.metadata.title = title2

book.each_content do |item|
  if item.media_type == "application/x-dtbncx+xml" or item.media_type == "application/xhtml+xml"
    item.edit_with_nokogiri do |doc|
      puts "page #{i}"
      i += 1
      translate_page(engine, doc)
    end
  end
end
