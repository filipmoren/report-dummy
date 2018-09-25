#!/bin/bash
while read p
do
 export "$p"
done < /vars

cd /
date=`date`
echo "Generating reports $date"
cd projFiles && Rscript scripts/R/master.R