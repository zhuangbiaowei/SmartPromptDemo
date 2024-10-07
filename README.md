EN | [中文](./README.cn.md)

This is a project to provide examples for the [smart_prompt](https://github.com/zhuangbiaowei/smart_prompt) project.

* hello.rb
    * First call the daily_report worker
    * Call weather_summary in daily_report
    * Finally generate a daily report
* trans.rb
    * Translate the text line by line, taking care to keep the markdown formatting
    * Find three LLM translations, and finally use qwen2.5 as a referee to evaluate the results of the three translations
    * Final output of the optimized translation
* code.rb
    * In order to calculate the area of a triangle, let LLM generate a ruby function
    * Call this ruby function and print the result

Translated with DeepL.com (free version)