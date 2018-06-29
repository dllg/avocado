#!/bin/bash

NAME="avocado"


$(cat <<EOF >$HOME/bin/$NAME

if [[ "\$(docker ps -a | grep $NAME)" != "" ]]; then
    echo "docker stop $NAME"
    docker stop $NAME
    echo "docker rm $NAME"
    docker rm $NAME
fi

if [[ "\$(docker images | grep $NAME)" == "" ]]; then
    echo "/bin/bash -c $(pwd)/build.sh"
    /bin/bash -c $(pwd)/build.sh
fi

echo "/bin/bash -c $(pwd)/run.sh"
/bin/bash -c $(pwd)/run.sh
exit 0
EOF
)

chmod +x $HOME/bin/$NAME
