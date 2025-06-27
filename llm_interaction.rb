require "../smart_prompt/lib/smart_prompt"
require "readline"
engine = SmartPrompt::Engine.new("./config/llm_config.yml")

class LLMInteraction
  def initialize(engine)
    @engine = engine
    @current_worker = :smart_agent
  end

  def start
    puts "欢迎使用LLM交互程序!"
    puts "您可以输入内容来调用LLM,或者输入 /worker_name 来切换worker。"
    puts "输入 'exit' 来退出程序。"

    loop do
      input = Readline.readline("> ", true)
      break if input.nil?

      case input
      when "exit"
        puts "感谢使用,再见!"
        break
      when /^\/(\w+)/
        change_worker($1)
      else
        unless input.empty?
          call_llm(input)
        end
      end
    end
  end

  private

  def change_worker(new_worker)
    if @engine.check_worker(new_worker.to_sym)
      @current_worker = new_worker.to_sym
      puts "已切换到 worker: #{@current_worker}"
    else
      puts "Worker #{new_worker} 不存在。"
    end
  end

  def call_llm(input)
    reasoning = false
    @engine.call_worker_by_stream(@current_worker, {text: input}) do |chunk, _bytesize|
      #puts "----"
      #puts chunk
      #puts "----"
      if chunk.dig("choices", 0, "delta", "reasoning_content")
        if reasoning == false
          print "("+@current_worker.to_s+" thinking):"
          reasoning = true
        end
        print chunk.dig("choices", 0, "delta", "reasoning_content")
      else
        if reasoning == true
          print "\n" + "("+@current_worker.to_s+" say):"
          reasoning = false
        end
        print chunk.dig("choices", 0, "delta", "content")
      end
    end
    puts "\n"
    # puts @engine.call_worker(@current_worker, {text: input})
  end
end

LLMInteraction.new(engine).start
