require "json"
require "date"

news_list = JSON.parse(File.read('./news.json'), symbolize_names: true)
news_list.each do |item|
  if item[:date]
    begin
      # 检查并修订日期格式
      item[:date] = Date.parse(item[:date]).strftime('%Y-%m-%d')
    rescue ArgumentError
      puts "无效日期格式，修订为空值: #{item[:date]}"
      item[:date] = nil
    end
  else
    puts "缺少日期字段，修订为空值。"
    item[:date] = nil
  end
end

File.open("new_json.json", "w") do |f|
  f.puts JSON.pretty_generate(news_list)
end