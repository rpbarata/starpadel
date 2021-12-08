#!/bin/sh
set -e

echo "=== Remove a potentially pre-existing server.pid for Rails ==="
rm -f $APP_PATH/tmp/pids/server.pid

echo "=== PREPARING CACHE FOLDERS ==="
mkdir -p $APP_PATH/vendor/bundle $APP_PATH/node_modules $APP_PATH/public

echo "=== PREPARING HOME FOLDER ==="
sudo chown meideiteam:meideiteam $HOME

echo "=== INSTALLING DEPENDENCIES ==="
bundle install
yarn install

echo "=== CLEANING OLD DEPENDENCIES, ASSETS AND LOGS ==="
bundle clean
rails assets:clean log:clear tmp:clear

if [ ! -f "$HOME/.setup_complete" ]; then
  # echo "=== SETTING UP PROJECT ==="
  # if [ -x /bin/zsh ]; then exec /bin/zsh; fi

  # echo "=== INSTALLING OHMYZSH ==="
  # if [ ! -d "$HOME/.oh-my-zsh" ]; then sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -) --unattended"; fi

  echo "=== SETTING UP DATABASE ==="
  rails db:create db:migrate
  rails db:seed

  touch "$HOME/.setup_complete"
fi

# echo "=== CONFIGURING GIT ==="
# config-git

echo "=== APPLYING LATEST MIGRATIONS ==="
rails db:migrate
rails db:seed

echo "=== COMPILING ASSETS ==="
rails assets:precompile --trace

echo "=== STARTING WEBPACK SERVER ==="
(webpack-dev-server)&

echo "=== STARTING WEB SERVER ==="
bundle exec rails s -p 3000 -b '0.0.0.0'
