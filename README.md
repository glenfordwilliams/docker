# Manual Steps for EduFocal Setup 
Step 1:
```
git clone git@github.com:gordonswaby/edufocal.git $INSTALL_DIR/webapp
```

Step 2
```
git clone git@github.com:edufocal/api.git $INSTALL_DIR/api
```

Step 3
```
git clone git@github.com:edufocal/docker.git $INSTALL_DIR/docker
```

Step 4:
Edit the following files with the necessary configuration choices:
1. Change DATA_FOLDER in docker-compose.yml to the correct folder location
2. Change SITE_URL in docker/nginx/api.conf to the correct local url (suggest: edufocal.localhost)
3. Change SITE_URL in docker/webapp.conf to correct local url (suggest: edufocal.localhost)

Step 5:
```
run $INSTALL_DIR/docker/start.sh
```
