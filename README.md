# report-dummy
A rough dummy of my regular workflow

## Instructions

1. Install [docker ce](https://docs.docker.com/install/)
2. Download this repo
3. Build the docker image
   ```
   cd /path/to/this/repo
   docker build -t dummy-report:latest .
   ```
   The above code will build the docker image and tag it with the name dummy-report:latest.
4. Start the docker container
   ```
   docker run -d -p 8787:8787 -v $(pwd):/projFiles \
   -e "DB_SERVER=host" \
   -e "DB_USERNAME=username" \
   -e "DB_PASSWORD=password" \
   -e "DB_NAME=dbName" \
   -e "CRON_SCHEDULE=1 6 * * 1 root /projFiles/r.sh >> /var/log/r.log 2>&1" \
   dummy-report:latest
   ```

   The above will start your docker container detached (-d), open the 
   port 8787 (-p), mount the current working directory to the dir projFiles 
   (-v), add a bunch of environment variables (-e). Run `docker ps` to check if your
   container is running. Copy the `CONTAINER ID`
5. To start RStudio server run
   ```
   docker exec CONTAINER_ID bash -c "rstudio-server start"
   ```
   This starts issues the command within quotes on your container. 
   To connect to to your container as if it was a server, run 
   ```
   docker exec -it CONTAINER_ID bash
   ```
   Connect to localhost:8787 in your browser to access RStudio server.
   Username and password are both rstudio. The content of $pwd are under /projFiles.
   since we mounted a volume in step 4, these are the same files as on your computer
   and any changes will be written to your copy.
6. Generate a dummy report by running the code in `projFiles/scripts/R/master.R`
   The reports will end up in /projFiles/output/
