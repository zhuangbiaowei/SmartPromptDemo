SmartPrompt.define_worker :trans do
  use "siliconflow"
  model "Qwen/Qwen2.5-Coder-7B-Instruct"
  system "You are an experienced translator."
  prompt :trans, {text: params[:text]}
  send_msg
end
