[EN](./README.md) | 中文

这是一个为了 [smart_prompt](https://github.com/zhuangbiaowei/smart_prompt) 项目提供示例的项目。

* hello.rb
    * 首先调用daily_report这个worker
    * 在daily_report中调用weather_summary
    * 最后生成一份每日报告
* trans.rb
    * 逐行翻译文本，注意保留markdown的格式
    * 找了三个LLM翻译，最后用qwen2.5做裁判评价三个翻译的结果
    * 最后输出优化后的翻译
* code.rb
    * 为了计算三角形的面积，让LLM生成一个ruby函数
    * 调用这个ruby函数，并打印结果