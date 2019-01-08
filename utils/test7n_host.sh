#!/bin/sh
set -e

# check curl site
# 0 is TEST PASS
# 1 is TEST FAILURE

result=$(docker exec -it con-$NGINX_IMAGE  /usr/local/bin/test7.sh | grep -q  'TEST OK')
exit $result
