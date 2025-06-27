require "json"

SmartPrompt.define_worker :translation_expert do
  params[:source_language] = "English" unless params[:source_language]
  params[:source_location] = "USA" unless params[:source_location]
  params[:target_language] = "简体中文" unless params[:target_language]
  params[:target_location] = "中国大陆" unless params[:target_location]
  use "siliconflow"
  model "Qwen/Qwen2.5-Coder-7B-Instruct"
  prompt :cat_trans2, {
    text: params[:text],
    source_language: params[:source_language],
    source_location: params[:source_location]
  }
  json = send_msg
  prompt :senior_translator2, {
    json: json,
    text: params[:text],
    source_language: params[:source_language],
    source_location: params[:source_location],
    target_language: params[:target_language],
    target_location: params[:target_location]
  }
  send_msg
end
