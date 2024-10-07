SmartPrompt.define_worker :translator do
    text1 = call_worker(:just_trans, { text: params[:text], from: params[:from], to: params[:to], model: "qwen2.5" })
    text2 = call_worker(:just_trans, { text: params[:text], from: params[:from], to: params[:to], model: "gemma2" })
    text3 = call_worker(:just_trans, { text: params[:text], from: params[:from], to: params[:to], model: "llama3.1" })
    use "ollama"
    model "qwen2.5"
    system "You are an experienced translator."
    prompt :comparison_results, { text: params[:text], text1: text1, text2: text2, text3: text3 }
    send_msg
end