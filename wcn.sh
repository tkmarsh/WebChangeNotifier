#!/bin/bash
url="http://website.com/pagetocheck"
{
md5="$(wget $url | md5sum | tail)"
prevmd5="$(cat prev.md5)"
printf $md5 > prev.md5
} &> /dev/null

printf $md5 + "\n"
printf $prevmd5 + "\n"

if [ -f index.html ]; then
 rm index.html
else
 url_short=${url:7}
 url_path=${url_short#*/}
 rm $url_path
fi

if [ "${md5::-3}" != "$prevmd5" ]; then
 printf "Page updated!\n"
 #{
  curl -s \
  --form-string "token=TOKEN" \
  --form-string "user=USER" \
  --form-string "message=MESSAGE" \
  https://api.pushover.net/1/messages.json
#} &> /dev/null
else
 printf "No updates yet :^(\n"
fi
