SmartPrompt.define_worker :get_news do
  url = params[:text]
  html = call_worker(:download_page, {url: url})
  text = call_worker(:html_to_text, {html: html})
  use "siliconflow"
  sys_msg "You're a journalist familiar with open source-related news coverage."
  model "Qwen/Qwen2.5-72B-Instruct"
  prompt :analyzing_news_content, {news: text}
  news_json = safe_send_msg
  f = File.open("news.json", "a+")
  f.puts news_json
  f.close
end
