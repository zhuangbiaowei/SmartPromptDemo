require "nokogiri"
require "reverse_markdown"

class HTMLTextExtractor
  class << self
    # 方法1：提取所有文本，保持基本格式
    def extract_formatted_text(html_content)
      doc = Nokogiri::HTML(html_content)

      # 删除script和style标签
      doc.css("script, style").remove

      # 替换一些常见的块级元素为换行
      doc.css("p, div, h1, h2, h3, h4, h5, h6, li").each do |node|
        node.after("\n")
      end

      # 提取并清理文本
      doc.text
        .gsub(/[[:space:]]+/, " ")  # 将多个空白字符替换为单个空格
        .gsub(/\n[[:space:]]*\n/, "\n\n")  # 将多个换行替换为双换行
        .strip
    end

    # 方法2：提取纯文本，忽略格式
    def extract_plain_text(html_content)
      doc = Nokogiri::HTML(html_content)

      # 删除script和style标签
      doc.css("script, style").remove

      # 提取并清理文本
      doc.text.gsub(/[[:space:]]+/, " ").strip
    end

    # 方法3：按层级结构提取文本
    def extract_structured_text(html_content)
      doc = Nokogiri::HTML(html_content)

      # 删除script和style标签
      doc.css("script, style").remove

      result = []

      # 遍历所有文本节点
      doc.traverse do |node|
        if node.text? && !node.text.strip.empty?
          # 获取父元素的标签名
          parent_tag = node.parent.name
          text = node.text.strip

          result << {
            tag: parent_tag,
            text: text,
            path: node_path(node)
          }
        end
      end

      result
    end

    # 方法4：从文件中提取文本
    def extract_from_file(input_path, output_path, method: :formatted)
      html_content = File.read(input_path)

      extracted_text = case method
      when :formatted
        extract_formatted_text(html_content)
      when :plain
        extract_plain_text(html_content)
      when :structured
        extract_structured_text(html_content)
      else
        raise ArgumentError, "Unknown extraction method: #{method}"
      end

      output = if extracted_text.is_a?(Array)
        # 如果是结构化文本，转换为易读格式
        extracted_text.map { |item| "#{item[:tag]}: #{item[:text]}" }.join("\n")
      else
        extracted_text
      end

      File.write(output_path, output)
      puts "提取完成: #{input_path} -> #{output_path}"
    end

    private

    # 获取节点的路径
    def node_path(node)
      path = []
      current = node
      while current.respond_to?(:parent) && current.parent
        if current.parent.name != "document"
          path.unshift(current.parent.name)
        end
        current = current.parent
      end
      path.join(" > ")
    end
  end
end

SmartPrompt.define_worker :html_to_text do
  text = HTMLTextExtractor.extract_formatted_text(params[:html])
  text
end
