# Docker PHP

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-php) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fphp) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fphp)<br/>
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-php/dev-7_3?label=PHP+7.3) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-php/dev-7_4?label=PHP+7.4) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-php/dev-8_0?label=PHP+8.0) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-php/dev-8_0-edge?label=PHP+8.0+(edge))

[Docker Repository](https://hub.docker.com/r/bfren/php) - [bfren ecosystem](https://github.com/bfren/docker)

PHP (7.3, 7.4, and 8.0) CLI with minimal PHP packages installed:

* `php7` or `php8`
* `php7-common` or `php8-common`

## Contents

* [Environment Variables](#environment-variables)
* [Licence / Copyright](#licence)

## Environment Variables

| Variable  | Values                        | Description                                                                    | Default      |
| --------- | ----------------------------- | ------------------------------------------------------------------------------ | ------------ |
| `PHP_INI` | 'production' or 'development' | Defines which official php.ini template to use, "production" or "development". | 'production' |

The following environment variables will override values in `php.ini` (see [here](https://www.php.net/manual/en/ini.list.php)):

| Variable                         | Directive              | Default Value |
| -------------------------------- | ---------------------- | ------------- |
| `PHP_INI_DISPLAY_ERRORS`         | display_errors         | *None*        |
| `PHP_INI_DISPLAY_STARTUP_ERRORS` | display_startup_errors | *None*        |
| `PHP_INI_ERROR_REPORTING`        | error_reporting        | *None*        |
| `PHP_INI_MEMORY_LIMIT`           | memory_limit           | 256M          |

## Licence

> [MIT](https://mit.bfren.dev/2021)

## Copyright

> Copyright (c) 2021-2022 [bfren](https://bfren.dev) (unless otherwise stated)
