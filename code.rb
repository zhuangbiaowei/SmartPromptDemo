require 'smart_prompt'
engine = SmartPrompt::Engine.new('./config/llm_config.yml')
result = engine.call_worker(:get_code, {
    name: "calculate_triangle_area", 
    description: "calculates the area of a triangle",
    input: "the base and height of the triangle",
    output: "the area as a float"
    }) 
code_str = result+"\n"+"puts calculate_triangle_area(8, 10)"
eval(code_str)