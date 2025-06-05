###Start###
web_site=http://10.118.128.205/
url=$(curl -s --head --request GET http://10.118.128.205/ | grep "HTTP/1.1 200 OK") >/dev/null
if [ $? -eq 0 ]; then
echo "Web Site it Up"
else
echo "$web_site is down" | mail -s "Website Down Alert" laptop@example.com,labuser@example.com
fi
###End###
