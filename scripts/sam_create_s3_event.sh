#!/bin/bash

sam local generate-event s3 put > sam/s3-lambda-event-handler/events/s3-put-event.json