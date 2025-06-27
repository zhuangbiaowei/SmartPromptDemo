require "json"

def word?(str)
  # 基本验证：非空且为字符串类型
  return false unless str.is_a?(String) && !str.empty?
  
  # 去除首尾空格
  str = str.strip
  
  # 检查是否只包含字母、连字符和撇号（支持英文单词如 don't, well-known）
  basic_word = /\A[a-zA-Z]+(?:[''-][a-zA-Z]+)*\z/
  
  # 更宽松的判断，支持其他语言的单词（如中文、日文等）
  unicode_word = /\A\p{Word}+(?:[''-]\p{Word}+)*\z/
  
  # 额外检查：
  # 1. 不允许只有连字符或撇号
  # 2. 不允许连续的连字符或撇号
  # 3. 长度不能过长（这里假设正常单词不会超过50个字符）
  return false if str.length > 50
  return false if str.match?(/['\-]{2,}/)
  
  # 返回结果：
  # 如果是英文单词，用basic_word判断
  # 如果可能是其他语言的单词，用unicode_word判断
  str.match?(basic_word) || str.match?(unicode_word)
end

SmartPrompt.define_worker :categorized_translation do
  use "siliconflow"
  model "Qwen/Qwen2.5-Coder-7B-Instruct"
  prompt :cat_trans, {text: params[:text], source_language: params[:source_language]}
  json = send_msg
  model "Qwen/Qwen2.5-72B-Instruct-128K"
  if word?(params[:text])
    prompt :senior_translator, {
      json: json,
      text: params[:text],
      source_language: params[:source_language],
      target_language: params[:target_language]
    }
    result = send_msg
  else
    prompt :senior_translator2, {
      json: json,
      text: params[:text],
      source_language: params[:source_language],
      target_language: params[:target_language]
    }
    result = send_msg
  end
  result
end
