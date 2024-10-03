SmartPrompt.define_worker :just_trans do
    use "siliconflow"
    model params[:model]
    system "You are an experienced translator."
    prompt :translator, { text: params[:text] , from: params[:from], to: params[:to] }
    send_msg
end