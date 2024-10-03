SmartPrompt.define_worker :daily_report do
    use "ollama"
    model "gemma2"
    system "You are a helpful report writer."
    weather = call_worker(:weather_summary, { location: params[:location], date: "today" })
    prompt :daily_report, { weather: weather, location: params[:location] }
    send_msg
end