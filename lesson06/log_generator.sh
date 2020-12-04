#!/bin/bash
COUNT=0
while [ true ]
do
        echo log $COUNT\;$COUNT\;`date`
        COUNT=$(( $COUNT + 1 ))
        sleep 3
done
