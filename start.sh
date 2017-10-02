#!/usr/bin/env sh
#------------------------------------------------------------------------------
# Author: Paul Allen
# Description: Bootstrap local development environment for edufocal.com
#------------------------------------------------------------------------------


INSTALL_DIR=${1:-~/www/edufocal}
WORKSPACE_USER=${2:-ef}
SITE_URL=${3:-edufocal.localhost}
DATA_FOLDER=${4:-~/www/var/docker_data}
NGINX_GROUP=${2:-www-data}

SUBJECT=$SITE_URL.bootstrap.script
LOCK_FILE=/tmp/${SUBJECT}.lock

if [ -f "$LOCK_FILE" ]; then
  echo "Script is already running"
  exit
fi

trap "rm -f $LOCK_FILE" EXIT

touch $LOCK_FILE

if [ ! -d $INSTALL_DIR/webapp ]; then
  git clone git@github.com:gordonswaby/edufocal.git $INSTALL_DIR/webapp
fi

if [ ! -d $INSTALL_DIR/docker ]; then
  git clone git@github.com:edufocal/docker.git $INSTALL_DIR/docker
fi

if [ ! -d $INSTALL_DIR/api ]; then
  git clone git@github.com:edufocal/api.git $INSTALL_DIR/api
fi

if [ ! -d $INSTALL_DIR/docker/workspace/.ssh/ ]; then
    mkdir $INSTALL_DIR/docker/workspace/.ssh/
fi

cp  ~/.ssh/id_rsa.pub $INSTALL_DIR/docker/workspace/.ssh/id_rsa.pub
cp  ~/.ssh/id_rsa $INSTALL_DIR/docker/workspace/.ssh/id_rsa

cd $INSTALL_DIR/docker && \

ESCAPED=$(echo $DATA_FOLDER | sed 's_/_\\/_g')

sed "s/SITE_URL/$SITE_URL/" nginx/api.conf.template > nginx/api.conf && \
sed "s/SITE_URL/$SITE_URL/" nginx/webapp.conf.template > nginx/webapp.conf && \
sed "s/WORKSPACE_USER/$WORKSPACE_USER/" workspace/screenrc.template > workspace/screenrc  && \
sed "s/WORKSPACE_USER/$WORKSPACE_USER/;s/DATA_FOLDER/$ESCAPED/" docker-compose.yml.template > docker-compose.yml  && \

make build && make up

# if directory isn't owned by user 1000
FILE_OWNER=$(ls -ld $INSTALL_DIR | awk '{print $3}')
[ $FILE_OWNER = '1000' ] || docker exec -t ef_workspace_1 chown -R $WORKSPACE_USER:$NGINX_GROUP ./

cd $INSTALL_DIR

function confirm()
{
    echo -n "$@ "
    read -e answer
    for response in y Y yes YES Yes Sure sure SURE OK ok Ok
    do
        if [ "_$answer" == "_$response" ]
        then
            return 0
        fi
    done

    # Any answer other than the list above is considerred a "no" answer
    return 1
}

write_hosts()
{
     SUDO=''
     if (( $EUID != 0 )); then
         SUDO='sudo'
     fi

     declare -a urls=($SITE_URL "api.$SITE_URL")
     for url in "${urls[@]}"
     do
         if ! grep -q "$url" /etc/hosts
         then
             echo "127.0.0.1 $url" | $SUDO tee -a /etc/hosts > /dev/null
         fi
     done
}

if [ -f /etc/hosts ]; then
    confirm "Generate aliases to your /etc/hosts file? [y/N]" && write_hosts
fi

# Add the signature to our hostfile to avoid interactive approval
docker exec ef_workspace_1 sh -c "su ${WORKSPACE_USER} && ssh -oStrictHostKeyChecking=no dump@edufocal.com ls"

docker exec ef_workspace_1 sh -c"chmod 777 storage && chomd 777 bootstrap/cache"

echo "Done!"
