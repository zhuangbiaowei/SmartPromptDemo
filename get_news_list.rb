require "../smart_prompt/lib/smart_prompt"
engine = SmartPrompt::Engine.new("./config/llm_config.yml")

urls=[
  "https://mp.weixin.qq.com/s/VYuzWJu_V6nbuUF-bK-RCA",
  "https://mp.weixin.qq.com/s/o07eU-x05CFi_BJBVCa9yA",
  "https://mp.weixin.qq.com/s/zXUx8FzdijxehMTG2yPhlg",
  "https://mp.weixin.qq.com/s/JL-9Nr6HjP-7amTcBx9tzA",
  "https://mp.weixin.qq.com/s/UUlbYzVzfhC-C2-fLD2Xog",
  "https://mp.weixin.qq.com/s/8w1D--Jevc-mtHs3alDrcA",
  "https://mp.weixin.qq.com/s/4totLvoI1K8H2K76BcAzrQ",
  "https://mp.weixin.qq.com/s/qEwsLWOGQW95A-jY-y4rJg",
  "https://mp.weixin.qq.com/s/VYLi4vc9Su6wWIs6zdtUjw",
  "https://mp.weixin.qq.com/s/9_7DL1AzZCM_10sXruPcaQ",
  "https://mp.weixin.qq.com/s/0Mm2V9rpII-RmfsRsXzfKA",
  "https://mp.weixin.qq.com/s/U1exYxtxnZLbtPQW-I9X_w",
  "https://mp.weixin.qq.com/s/2asn0UvGYQg5Q29XkBjO7A",
  "https://mp.weixin.qq.com/s/lH6OA9KVP5EuQkNmZTVnGw",
  "https://mp.weixin.qq.com/s/5IAKqj1dgOI8DBOHeKoMLQ",
  "https://mp.weixin.qq.com/s/ch3_TmLD_a-45QsE4X262w",
  "https://mp.weixin.qq.com/s/eqj8jK3PUbFpOyjC7K_iFw",
  "https://mp.weixin.qq.com/s/59iJDzE1TRrBweKn9LtyBg",
  "https://mp.weixin.qq.com/s/eh_fTvSgR2Zc6POlu_fICA",
  "https://mp.weixin.qq.com/s/rato2btln7L9r9RVCpDtvg",
  "https://mp.weixin.qq.com/s/246ddcmATMZE6QOkK-p6VA",
  "https://mp.weixin.qq.com/s/RIvLN-dAb5qkBkzhVVEsaw",
  "https://mp.weixin.qq.com/s/KxTm7QW-tMugo_1v15_ymg",
  "https://mp.weixin.qq.com/s/X1KWQJBtgsm8YegdE-Hm4g",
  "https://mp.weixin.qq.com/s/oIxwZk_O2wMnNCXDJA1bog",
  "https://mp.weixin.qq.com/s/EWXGsGODSYu_b4RjoQlfzA",
  "https://mp.weixin.qq.com/s/DbUXNYJaDYz-YskIdfWUlg",
  "https://mp.weixin.qq.com/s/nFVbC6CnAFbHkSqlkScmvA",
  "https://mp.weixin.qq.com/s/VoTDS5uZwN7t8iVUacLgXQ",
  "https://mp.weixin.qq.com/s/PTIP6ccbl60xHgc99beNpQ",
  "https://mp.weixin.qq.com/s/-FVqqKTS20OEYLkyLBj3Nw",
  "https://mp.weixin.qq.com/s/hd1yKp9kOeGCl4pnNUAb2A",
  "https://mp.weixin.qq.com/s/d3LzbHP6mdYJsFT3b5lxfw",
  "https://mp.weixin.qq.com/s/KY2tLthhre-SRbuWka3c2w"
]

urls.each do |url|
  puts url
  engine.call_worker(:get_news, {text: url})
end