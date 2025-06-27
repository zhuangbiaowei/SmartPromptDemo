SmartPrompt.define_worker :get_embedding do
  use "siliconflow"
  model "BAAI/bge-m3"
  prompt params[:text]
  embeddings(1024)
end
