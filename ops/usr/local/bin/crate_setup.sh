#!/usr/bin/env bash

set -ex

./build.sh

NAME=$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].name')
rm -f /opt/dist/$NAME
mv ./dist/$NAME /opt/bin/$NAME

CONF=$(realpath $(pwd)/../../conf)

sh=/opt/bin/$NAME.sh

cat <<EOF >$sh
#!/usr/bin/env bash
set -e
cd $CONF/env
$(cat ../env.sh)
exec /opt/bin/$NAME
EOF

echo $NAME
chmod +x $sh

add_service.sh $NAME
