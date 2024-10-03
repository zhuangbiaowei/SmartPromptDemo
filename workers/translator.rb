SmartPrompt.define_worker :translator do
    text1 = call_worker(:just_trans, { text: params[:text], from: params[:from], to: params[:to], model: "Qwen/Qwen2.5-7B-Instruct" })    
    text2 = call_worker(:just_trans, { text: params[:text], from: params[:from], to: params[:to], model: "Qwen/Qwen2.5-32B-Instruct" })
    text3 = call_worker(:just_trans, { text: params[:text], from: params[:from], to: params[:to], model: "01-ai/Yi-1.5-9B-Chat-16K" })    
    use "siliconflow"
    model "meta-llama/Meta-Llama-3.1-405B-Instruct"
    system "You are an experienced translator."
    prompt :comparison_results, { text: params[:text], text1: text1, text2: text2, text3: text3 }
    result = send_msg
    model "Qwen/Qwen2.5-32B-Instruct"
    prompt :extraction_result, { text: result }
    send_msg
end