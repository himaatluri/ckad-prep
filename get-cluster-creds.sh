#!/bin/sh

gcloud container clusters get-credentials \
    hatluri \
    --zone us-east1-b \
    --project gcp-kubernetes-278403