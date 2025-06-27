SmartPrompt.define_worker :answer do
  use "ollama"
  model "llama3.2"
  prompt :answer, {prompt_doc: params[:prompt_doc], prompt: params[:prompt]}
  send_msg
end
