SmartPrompt.define_worker :smart_query do
  use "siliconflow"
  # use "ollama"
  system "You are a helpful SQL programmer."
  model "Qwen/Qwen2.5-Coder-7B-Instruct"
  # model "qwen2.5-coder"
  prompt :generate_sql, {
    description: params[:description]
  }
  sql_text = send_msg
  if sql_text.include?("Failed to call LLM after")
    sql_text
  else    
    model "meta-llama/Meta-Llama-3.1-8B-Instruct"
    prompt :get_code, {code_text: sql_text}
    send_msg
  end
end
