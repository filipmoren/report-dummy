FROM rocker/tidyverse:3.4.4

# install packages
RUN apt-get update
RUN apt-get install -y cron
RUN apt-get install -y nano
## swaks for sending emails
RUN apt-get install -y swaks

# install R packages
RUN Rscript -e 'install.packages("flexdashboard")'
RUN Rscript -e 'install.packages("plotly")'
RUN Rscript -e 'install.packages("RMariaDB")'
RUN Rscript -e 'install.packages("DT")'
RUN Rscript -e 'install.packages("gsheet")'

# Install fixed version of ggplot to play well with plotly
RUN Rscript -e "devtools::install_github('tidyverse/ggplot2', ref = 'v3.0.0')"

RUN mkdir projFiles

# add files
# uncomment the section below to add files when building the image
# ADD ./init.sh /projFiles/init.sh
# ADD ./r.sh /projFiles/r.sh
# RUN chmod u+x /projFiles/r.sh
# RUN chmod u+x /projFiles/init.sh
# ADD ./scripts /projFiles/scripts

CMD ["/projFiles/init.sh"]

# command to start container with rstudio server and wd mounted

# docker run -d -p 8787:8787 -v $(pwd):/projFiles \
# -e "DB_SERVER=host" \
# -e "DB_USERNAME=username" \
# -e "DB_PASSWORD=password" \
# -e "DB_NAME=dbName" \
# -e "CRON_SCHEDULE=1 6 * * 1 root /projFiles/r.sh >> /var/log/r.log 2>&1" \
# ex-report:lates ex-report:latest 
