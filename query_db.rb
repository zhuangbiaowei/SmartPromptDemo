require "../smart_prompt/lib/smart_prompt"
require "sequel"
require "readline"

engine = SmartPrompt::Engine.new("./config/llm_config.yml")

DB = Sequel.connect("postgres://docs:ment@localhost/docs")

class LLMInteraction
  def initialize(engine)
    @engine = engine
    @current_worker = :smart_query
    Readline.completion_append_character = " "
    Readline.completion_proc = proc { |s| [] }
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
    if @current_worker == :smart_query
      result = @engine.call_worker(:smart_query, {description: input})
      result = result.gsub("```sql", "").gsub("```", "").strip
      begin
        puts result
        ds = DB.fetch(result)
        ds.each do |rs|
          puts rs
        end
      rescue
        puts "SQL = " + result
      end
    else
      result = @engine.call_worker(@current_worker, {text: input})
      puts result
    end
  end
end

LLMInteraction.new(engine).start
