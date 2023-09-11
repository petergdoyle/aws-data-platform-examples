#!/bin/bash

sam build && sam local invoke -e events/s3-put-event.json
