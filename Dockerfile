# syntax=docker.io/docker/dockerfile:1.4

FROM docker.io/library/php:8.2.1-fpm-bullseye AS app_development

ARG APP_UID=10001
ARG APP_GID=10001

ENV PATH=/app/bin:/app/vendor/bin:"${PATH}"

SHELL ["/usr/bin/env", "sh", "-eu", "-c"]

RUN <<EOF
	apt-get update
	apt-get --yes install \
		git \
		libicu-dev \
		libicu67 \
		libpq-dev \
		libpq5 \
		unzip
	rm --force --recursive /var/lib/apt/lists/*

	docker-php-ext-install -j$(nproc) \
		intl \
		pdo_pgsql

	apt-get --yes remove --purge --auto-remove \
		libicu-dev \
		libpq-dev

	ln --no-target-directory --relative --symbolic \
		"${PHP_INI_DIR}"/php.ini-development \
		"${PHP_INI_DIR}"/php.ini

	groupadd --gid "${APP_GID}" app
	useradd --uid "${APP_UID}" --gid app --comment App --home-dir /home/app --create-home --shell "$(which nologin)" app

	install --owner app --group app --mode 0700 --directory /app
EOF

COPY --from=docker.io/library/composer:2.5.1 ["/usr/bin/composer", "/usr/local/bin/composer"]
COPY ["./docker/app/entrypoint", "/entrypoint"]
COPY ["./docker/app/php-fpm.conf", "/usr/local/etc/php-fpm.d/zz-php-fpm.conf"]

USER app
WORKDIR /app

ENTRYPOINT ["/entrypoint"]
CMD ["php-fpm", "--nodaemonize"]
STOPSIGNAL SIGQUIT

FROM docker.io/library/caddy:2.6.2-alpine AS http-server_development

ARG APP_UID=10001
ARG APP_GID=10001

SHELL ["/usr/bin/env", "sh", "-eu", "-c"]

RUN <<EOF
	addgroup -g "${APP_GID}" app
	adduser -u "${APP_UID}" -G app -g App -h /home/app -s "$(which nologin)" -D app

	chown -R app:app \
		/config \
		/data

	install -o app -g app -m 0700 -d /app
EOF

COPY ["./docker/http-server/entrypoint", "/entrypoint"]
COPY ["./docker/http-server/Caddyfile", "/etc/caddy/Caddyfile"]

USER app
WORKDIR /app

ENTRYPOINT ["/entrypoint"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
STOPSIGNAL SIGINT

FROM docker.io/library/postgres:15.1-bullseye AS relational-database_development

ARG APP_UID=10001
ARG APP_GID=10001

SHELL ["/usr/bin/env", "sh", "-eu", "-c"]

RUN <<EOF
	groupadd --gid "${APP_GID}" app
	useradd --uid "${APP_UID}" --gid app --comment App --home-dir /home/app --create-home --shell "$(which nologin)" app

	find / -mount -user postgres -exec chown app {} +
	find / -mount -group postgres -exec chgrp app {} +

	install --owner app --group app --mode 0700 --directory /app
EOF

COPY ["./docker/relational-database/entrypoint", "/entrypoint"]

USER app
WORKDIR /app

ENTRYPOINT ["/entrypoint"]
CMD ["postgres"]
STOPSIGNAL SIGTERM
