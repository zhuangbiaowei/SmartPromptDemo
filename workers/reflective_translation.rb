SmartPrompt.define_worker :reflective_translation do
  use "siliconflow"
  # use "ollama"
  system "You are a highly skilled translator with the ability to reflect on your translations."

  model "01-ai/Yi-1.5-9B-Chat-16K"
  # model "gemma2"
  prompt :translate, {text: params[:text], source_language: params[:source_language], target_language: params[:target_language]}
  initial_translation1 = send_msg

  model "Qwen/Qwen2.5-Coder-7B-Instruct"
  # model "llama3.1"
  prompt :translate, {text: params[:text], source_language: params[:source_language], target_language: params[:target_language]}
  initial_translation2 = send_msg

  model "THUDM/glm-4-9b-chat"
  # model "qwen2.5"
  prompt :translate, {text: params[:text], source_language: params[:source_language], target_language: params[:target_language]}
  initial_translation3 = send_msg

  # Reflection and self-evaluation
  model "Pro/Qwen/Qwen2.5-7B-Instruct"
  SmartPrompt.logger.info "Now, reflect on the quality of your translation. Identify potential issues such as ambiguity, tone mismatch, or cultural differences, and provide suggestions for improvement."
  prompt :reflect_on_translation, {
    original_text: params[:text],
    translated_text1: initial_translation1,
    translated_text2: initial_translation2,
    translated_text3: initial_translation3
  }
  evaluation = send_msg

  # Improve the translation based on reflection
  SmartPrompt.logger.info "Based on your reflection, improve the translation if necessary."
  prompt :improve_translation, {
    original_text: params[:text],
    translated_text1: initial_translation1,
    translated_text2: initial_translation2,
    translated_text3: initial_translation3,
    evaluation: evaluation
  }
  result = send_msg
  {
    original_text: params[:text],
    translated_text1: initial_translation1,
    translated_text2: initial_translation2,
    translated_text3: initial_translation3,
    evaluation: evaluation,
    result: result
  }
end
