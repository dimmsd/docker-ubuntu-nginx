#!/bin/sh
set -e

# check last commit image
# 0 is TEST PASS
# 1 is TEST FAILURE

result=$(docker exec  -it con-$NGINX_IMAGE  /usr/local/bin/test6.sh | grep -q  $COMMIT)

exit $result
