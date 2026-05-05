#!/bin/sh
set -e
cd /app
bin/stream_activities eval "StreamActivities.Release.migrate"
exec bin/stream_activities start
