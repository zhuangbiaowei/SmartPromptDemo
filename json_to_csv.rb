require 'json'
require 'csv'

# 读取JSON文件
file_path = '/mnt/d/news.json'
begin
  json_text = File.read(file_path)
  data = JSON.parse(json_text)
rescue Errno::ENOENT
  puts "文件#{file_path}未找到。"
  exit
rescue JSON::ParserError => e
  puts "解析JSON时出错: #{e.message}"
  exit
end

# 确保数据是数组格式
data = [data] unless data.is_a?(Array)

# 获取CSV的表头（使用所有对象的键的并集）
headers = data.flat_map(&:keys).uniq

# 写入CSV文件
CSV.open('/mnt/d/output.csv', 'w', write_headers: true, headers: headers) do |csv|
  data.each do |item|
    csv << headers.map { |header| item[header] }
  end
end

puts "已成功将#{file_path}转换为output.csv。"
