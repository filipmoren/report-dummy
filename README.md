# report-dummy
This is a rough dummy of my regular workflow. Some of the scripts are
not sourced at all since theres no access to a database etc., but they 
are left here to show how I usually do things. Please leave me a comment
with any suggestions or questions.

## Instructions

1. Install [docker ce](https://docs.docker.com/install/)
2. Download this repo
3. Build the docker image
   ```
   cd /path/to/this/repo
   docker build -t dummy-report:dev .
   ```
   The above code will build the docker image and tag it with the name dummy-report:dev.
   I use the tag :dev.
4. Start the docker container
   ```
   docker run -d -p 8787:8787 -v $(pwd):/projFiles \
   -e "DB_SERVER=host" \
   -e "DB_USERNAME=username" \
   -e "DB_PASSWORD=password" \
   -e "DB_NAME=dbName" \
   -e "CRON_SCHEDULE=1 6 * * 1 root /projFiles/r.sh >> /var/log/r.log 2>&1" \
   dummy-report:dev
   ```

   The above will start your docker container detached (-d), open the 
   port 8787 (-p), mount the current working directory to the dir projFiles 
   (-v), add a bunch of environment variables (-e). Run `docker ps` to check if your
   container is running. Copy the `CONTAINER ID`
5. To start RStudio server run
   ```
   docker exec CONTAINER_ID bash -c "rstudio-server start"
   ```
   This issues the command within quotes on your container. 
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

## To put in "production"
The instructions above mounts a volume, meaning that the project files are not
really a part of the container. They are just being made available to the 
container. To make it self contained we need to `ADD` the files when we 
build the container. 

To add the files, uncomment the lines in the section following `# add files`
in `Dockerfile`. Then run the command from step 3 again, but change the tag to
`:prod` instead of `dev`. Thus, this container will be tagged `dummy-report:prod`.

To start the prod container run
```
   docker run -d -p 8788:8787 \
   -e "DB_SERVER=host" \
   -e "DB_USERNAME=username" \
   -e "DB_PASSWORD=password" \
   -e "DB_NAME=dbName" \
   -e "CRON_SCHEDULE=1 6 * * 1 root /projFiles/r.sh >> /var/log/r.log 2>&1" \
   dummy-report:prod

``` 
Notice how we did not mount the curremt wd to the container, the image now
containes the files needed. Note also how we changed the port mapping, from
8787 to 8788. If we have both :dev and :prod running at the same time, we
cannot use the same ports.

Do step 5 again to start RStudio and to access the container.

## Special files
When I started working with dockers I had some initial problems getting them
run when my cron schedule said that they were suppose to run. To fix this, we
added two files, /init.sh and /r.sh

### /init.sh
When the container starts, the script init.sh will run. This scripts does four 
important things.

1. Export  the environment variable to /etc/cron.d/cronSchedule and change the permissions of the 
   file.
2. It starts cron.
3. It writes all environment variables to the file /vars. This is an important
   part of /r.sh.
4. It starts loging the output from R to /var/log/r.log

### /r.sh
The cron schedule, wich is defined as an environment variable, looks like so:

```
1 6 * * 1 root /projFiles/r.sh >> /var/log/r.log 2>&1
```

So, cron runs r.sh and writes the output to the log. However, the script that
cron runs cannot access the environment variables we defined when we started 
the container. So, the first thing r.sh does is to export all our environment
variables from /vars (which was created by /init.sh). That way, when r.sh 
finally executes `cd projFiles && Rscript scripts/R/master.R`, our script has 
access to all environment variables we need.


