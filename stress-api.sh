ACCESS_TOKEN=$(curl --silent 'http://localhost:3000/api/token' \
-H 'content-type: application/x-www-form-urlencoded' \
--data-raw 'grant_type=password&username=admin%40example.net&password=pwd123&scope=my-scope' | jq --raw-output  .access_token)

for i in {1..3}
do
  curl -X PATCH 'http://localhost:3000/api/someapi' -H "Authorization: Bearer $ACCESS_TOKEN" &
  echo "."
  sleep 1
done