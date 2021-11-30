FROM ruby:3.0.2-alpine3.14

# GENERAL ENVS #
ENV APP_PATH /project
ENV APP_BIN_PATH "$APP_PATH/bin"
ENV PATH "$PATH:$APP_BIN_PATH"
ENV HOME "$APP_PATH/docker/development/home"

# RUBY ENVS #
ENV BUNDLE_PATH /bundle
ENV BUNDLE_BIN "${BUNDLE_PATH}/ruby/3.0.2/bin"
ENV PATH "${PATH}:${BUNDLE_BIN}"
ENV BUNDLE_JOBS 4
ENV RAILS_ENV development

# NODE ENVS #
ENV NODE_ENV development

WORKDIR $APP_PATH

COPY ./bin/install-system-dependencies $APP_BIN_PATH/install-system-dependencies
RUN install-system-dependencies

# RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)"

RUN mkdir $BUNDLE_PATH && chown meideiteam:meideiteam $BUNDLE_PATH

USER meideiteam

ENTRYPOINT [ "docker/development/entrypoint" ]

EXPOSE 3000
