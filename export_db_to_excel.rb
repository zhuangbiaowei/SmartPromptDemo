require "sequel"
require 'rubyXL'

DB = Sequel.connect("postgres://docs:ment@localhost/docs")

class News < Sequel::Model(DB[:news])
end

result = News.all

OUTPUT_FILE = 'news_export.xlsx'
workbook = RubyXL::Workbook.new
sheet = workbook.worksheets[0]
sheet.sheet_name = 'News'
sheet.add_cell(0, 0, 'ID')
sheet.add_cell(0, 1, '标题')
sheet.add_cell(0, 2, '日期')
sheet.add_cell(0, 3, '摘要')
sheet.add_cell(0, 4, '分类')
id = 1 
result.each do |news|
  sheet.add_cell(id, 0, news[:id])
  sheet.add_cell(id, 1, news[:title])
  sheet.add_cell(id, 2, news[:date])
  sheet.add_cell(id, 3, news[:summary])
  sheet.add_cell(id, 4, news[:category])
  id = id + 1    
end

workbook.write(OUTPUT_FILE)
puts "数据成功导出到 #{OUTPUT_FILE}"