SmartPrompt.define_worker :get_code do
    use "siliconflow"
    system "You are a helpful programmer."
    model "Qwen/Qwen2.5-Coder-7B-Instruct"
    prompt :generate_code, {
        name: params[:name],
        description: params[:description],
        input: params[:input], 
        output: params[:output]
    }
    code_text = send_msg
    model "meta-llama/Meta-Llama-3.1-8B-Instruct"
    prompt :get_code, {code_text: code_text}
    send_msg
end