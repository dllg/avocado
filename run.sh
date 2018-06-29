NAME="avocado"
docker run -itd --name $NAME --mount type=bind,source="$HOME",target=/test $NAME
docker attach $NAME
