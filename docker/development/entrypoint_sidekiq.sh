#!/bin/bash
set -e

echo "=== INSTALLING DEPENDENCIES ==="
bundle install

echo "=== STARTING SIDEKIQ ==="
bundle exec sidekiq -C config/sidekiq.yml
# bundle exec sidekiq