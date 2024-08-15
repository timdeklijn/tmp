#!/bin/bash

subscriptions=$(cat subscriptions.txt)

echo $subscriptions

for sub in $subscriptions
do
	echo $sub
done