require "json"
require "sequel"
require "io/console"

DB = Sequel.connect("postgres://docs:ment@localhost/docs")

class News < Sequel::Model(DB[:news])
end


# 可选择的分类
CATEGORIES = [
  "开源技术", "开源AI", "开源社区生态", "开源软件安全", "开源许可与合规治理",
  "开源商业", "国际协作与开源外交", "开源教育", "开源政策"
].freeze

# 读取 JSON 文件
def load_news(file_path)
  JSON.parse(File.read(file_path), symbolize_names: true)
rescue StandardError => e
  puts "无法加载文件: #{e.message}"
  []
end

# 保存新闻到数据库
def save_to_database(news)
  DB["INSERT INTO news (title, date, summary, category) VALUES (?,?,?,?)", news[:original_title],news[:date],news[:summary],news[:category]].insert
  puts "新闻已保存到数据库。"
  puts "-------------------"
end

# 交互主函数
def main
  news_list = load_news('./new_json.json')
  if news_list.empty?
    puts "未加载到任何新闻。"
    return
  end

  news_list.each do |news|
    unless News.find(title: news[:original_title])
      puts <<~NEWS
        原始标题: #{news[:original_title]}
        中文标题: #{news[:chinese_title]}
        日期: #{news[:date]}
        摘要: #{news[:summary]}
        分类: #{news[:category]}
      NEWS
      puts "-------------------"

      loop do
        puts "请输入操作 (S: 保存, D: 丢弃, E: 修改分类, Q: 退出):"
        input = STDIN.getch.upcase

        case input
        when 'S'
          save_to_database(news)
          break
        when 'D'
          puts "新闻已丢弃。"
          puts "-------------------"
          break
        when 'E'
          puts "请选择一个新的分类："
          CATEGORIES.each_with_index do |category, index|
            puts "#{index + 1}. #{category}"
          end
          print "输入分类编号: "
          category_index = STDIN.getch.to_i - 1
          if category_index.between?(0, CATEGORIES.length - 1)
            news[:category] = CATEGORIES[category_index]
            puts "分类已修改为: #{news[:category]}"
            save_to_database(news)
            break
          else
            puts "无效的编号，请重新输入。"
          end
        when 'Q'
          puts "退出程序。"
          exit
        else
          puts "无效输入，请重新输入。"
        end
      end
    end
  end
end

# 程序入口
main
