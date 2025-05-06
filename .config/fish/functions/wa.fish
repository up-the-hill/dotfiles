function wa
    set -f APPID K7AWWU-7AA94AQA6K # Get one at https://products.wolframalpha.com/api/
    echo $argv | string escape --style=url | read question_string
    set -f url "https://api.wolframalpha.com/v1/llm-api?appid="$APPID"&input="$question_string
    curl -s $url
end
