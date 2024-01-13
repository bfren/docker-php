# Docker PHP

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-php) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fphp) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fphp) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-php/dev.yml?branch=main)

[Docker Repository](https://hub.docker.com/r/bfren/php) - [bfren ecosystem](https://github.com/bfren/docker)

PHP (7.4, 8.0, 8.1, 8.2 and 8.3) CLI with no additional packages installed.

To override values in php.ini map a `php-ini.json` file to root - see `php-ini-sample.json`.

## Contents

* [Environment Variables](#environment-variables)
* [Licence / Copyright](#licence)

## Environment Variables

| Variable          | Values                        | Description                                                                       | Default       |
| ----------------- | ----------------------------- | --------------------------------------------------------------------------------- | ------------- |
| `BF_PHP_DIR`      | *path*                        | Path to the PHP configuration directory - should not normally need to be changed. | '/etc/php82'  |
| `BF_PHP_ENV`      | 'production' or 'development' | Defines which official php.ini template to use, "production" or "development".    | 'production'  |
| `BF_PHP_EXT`      | *space-separated string*      | List of PHP extensions to install.                                                | *blank*       |
| `BF_PHP_PREFIX`   | *php82 (etc)*                 | PHP version prefix for package install - should not normally need to be changed.  | 'php82'       |

## Licence

> [MIT](https://mit.bfren.dev/2021)

## Copyright

> Copyright (c) 2021-2024 [bfren](https://bfren.dev) (unless otherwise stated)
