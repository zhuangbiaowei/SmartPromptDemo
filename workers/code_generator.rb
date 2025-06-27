SmartPrompt.define_worker :code_generator do
  use "siliconflow"
  model "deepseek-ai/DeepSeek-Coder-V2-Instruct"

  prompt :analyze_requirements, {language: "Ruby", requirements: params[:text]}
  description_of_requirements = send_msg
  puts description_of_requirements
  # 根据需求生成 worker 代码
  prompt :generate_worker_code, {language: "Ruby", requirements: description_of_requirements}
  worker_code = send_msg

  # 根据需求生成 template 模板代码
  prompt :generate_template_code, {language: "ERB", requirements: description_of_requirements}
  template_code = send_msg

  puts worker_code
  puts template_code
  #   worker_name = description_of_requirements["worker_name"]
  #   template_name = description_of_requirements["template_name"]
  #
  #   f = File.new(worker_name, "w")
  #   f.puts(worker_code)
  #   f.close
  #   f = File.new(template_name, "w")
  #   f.puts(template_code)
  #   f.close
  #
  #   description_of_requirements
  "Done"
end
