require "../rich/lib/ruby_rich"
require "../smart_prompt/lib/smart_prompt"

$LLM_WORKING = false
$PROMPT_LIST = ["> "]
$PROMPT_NO = 0
$CURRENT_PROMPT = ""

engine = SmartPrompt::Engine.new("./config/llm_config.yml")
console = RubyRich::Console.new
layout = RubyRich::Layout.new

layout.split_row(
  RubyRich::Layout.new(name: "main", ratio: 3),
  RubyRich::Layout.new(name: "sidebar", size: 26)
)

layout["main"].split_column(
  RubyRich::Layout.new(name: "content", ratio: 4),
  RubyRich::Layout.new(name: "input_area", size: 8)
)

sidebar = RubyRich::Panel.new(
  "[F1] 帮助\n[Ctrl+N] 开启新对话\n[Ctrl+S] 保存对话\n[Ctrl+O] 加载历史对话\n[Ctrl+W] 切换工作模型\n[Ctrl+A] 深入分析对话\n[Ctrl+K] 管理知识库\n[Ctrl+C] 退出",
  title: "快捷方式",
  border_style: :cyan
)

layout["sidebar"].update_content(sidebar)

content_panel = RubyRich::Panel.new(
  "",
  title: "聊天窗"
)
layout["content"].update_content(content_panel)

input_panel = RubyRich::Panel.new(
  "> ",
  title: "输入框 (F6 = 换行，↑/↓ = 切换聊天历史)",
  border_style: :blue
)
layout["input_area"].update_content(input_panel)

def process_key(live, console, layout, engine, input_pos = 2)
  input_panel = layout["input_area"].content
  content_panel = layout["content"].content
  input_str = console.get_key()
  if input_str
    if input_str == :ctrl_c
      live.stop
    elsif input_str == :f6
      input_panel.content += "\n> "
      input_pos = 2
    elsif input_str == :enter
      arr = input_panel.content.split("\n").map { |str| str[2..-1] }
      input_text = arr.join("\n")
      content_panel.content += "User: " + input_text + "\n"
      $PROMPT_LIST << "> "
      $PROMPT_NO += 1
      input_pos = 2
      input_panel.content = ""
      $thread = Thread.new {
        input_panel.border_style = :red
        content_panel.border_style = :green
        call_worker(engine, input_text, content_panel) 
        input_panel.border_style = :blue
        input_panel.content = "> "
        content_panel.border_style = :white
      }
    else
      if input_str == :backspace
        arr = input_panel.content.split("\n")
        text = arr.last
        if input_pos > text.size - 1 && input_pos > 2
          arr[-1] = text[0..-2]
          input_panel.content = arr.join("\n")
          input_pos -= 1 if input_pos > 2
        elsif input_pos.between?(3, text.size - 1)
          arr[-1] = text[0..input_pos-2].to_s + text[input_pos..-1].to_s
          input_panel.content = arr.join("\n")
          input_pos -= 1 if input_pos > 0
        elsif input_pos==3
          arr[-1] = text[1..-1]
          input_panel.content = arr.join("\n")
          input_pos=2
        elsif input_pos==2 && arr.size>1
          input_panel.content = arr[0..-2].join("\n")
          input_pos = arr[-2].size
        end
      end
      if input_str == :delete
        arr = input_panel.content.split("\n")
        text = arr.last
        if input_pos == text.size - 1 && input_pos >= 2
          input_panel.content = input_panel.content[0..-2]
        elsif input_pos.between?(2, text.size - 2)
          arr[-1] = text[0..input_pos-1].to_s + text[input_pos+1..-1].to_s
          input_panel.content = arr.join("\n")
        end
      end
      if input_str == :left
        input_pos -= 1 if input_pos > 2
      end
      if input_str == :right
        input_pos += 1 if input_pos < input_panel.content.size
      end
      if input_str == :up
        if $PROMPT_NO > 0
          $CURRENT_PROMPT = input_panel.content if $PROMPT_NO==$PROMPT_LIST.size-1
          $PROMPT_NO -= 1
          input_panel.content = $PROMPT_LIST[$PROMPT_NO]
          input_pos = input_panel.content.split("\n").last.size
        end
      end
      if input_str == :down
        if $PROMPT_NO < $PROMPT_LIST.size - 1
          $PROMPT_NO += 1
          if $PROMPT_NO==$PROMPT_LIST.size-1
            input_panel.content = $CURRENT_PROMPT
          else
            input_panel.content = $PROMPT_LIST[$PROMPT_NO]
          end
          input_pos = input_panel.content.split("\n").last.size
        end
      end
      if input_str.class==String
        if input_pos == input_panel.content.split("\n").last.size
          input_panel.content = input_panel.content + input_str
        else
          input_panel.content = input_panel.content[0..input_pos-1].to_s + input_str + input_panel.content[input_pos..-1].to_s
        end        
        input_pos += 1
      end
    end
    $PROMPT_LIST[-1] = input_panel.content
  end
  return input_pos
end

def call_worker(engine, input_text, content_panel)
  $LLM_WORKING = true
  reasoning = false
  reasoned = false
  engine.call_worker_by_stream(:smart_agent, {text: input_text}) do |chunk, _bytesize|
    if chunk.dig("choices", 0, "delta", "reasoning_content")
      reasoned = true
      if reasoning == false
        content_panel.content += "AI Thinking: \n"
        reasoning = true
      end
      content_panel.content += chunk.dig("choices", 0, "delta", "reasoning_content")
    end
    if chunk.dig("choices", 0, "delta", "content")
      if reasoning == true
        if reasoned == true
          content_panel.content += "AI Talking: "
          reasoning = false
        end
      else
        if reasoned == false
          content_panel.content += "AI Talking: \n"
          reasoned = true
        end
      end
      content_panel.content += chunk.dig("choices", 0, "delta", "content")
    end
  end
  content_panel.content += "\n"
  $LLM_WORKING = false
end
$thread = nil
input_pos = 2
RubyRich::Live.start(layout, refresh_rate: 24) do |live|
  if $thread
    if $LLM_WORKING == false
      $thread.join
      $thread = nil
      input_pos = process_key(live, console, layout, engine, input_pos)
      input_panel.title = "输入框 (F6 = 换行，↑/↓ = 切换聊天历史)"
    else
      sleep(1)
    end
  else
    input_pos = process_key(live, console, layout, engine, input_pos)
    input_panel.title = "输入框 (F6 = 换行，↑/↓ = 切换聊天历史)"
  end
end
system("clear")