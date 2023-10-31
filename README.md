# Docker PHP

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-php) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fphp) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fphp) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-php/dev.yml?branch=main)

[Docker Repository](https://hub.docker.com/r/bfren/php) - [bfren ecosystem](https://github.com/bfren/docker)

PHP (7.4, 8.0, 8.1 and 8.2) CLI with no additional packages installed.

To override values in php.ini map a `php-ini.json` file to root - see `php-ini-sample.json`.

## Contents

* [Environment Variables](#environment-variables)
* [Licence / Copyright](#licence)

## Environment Variables

| Variable  | Values                        | Description                                                                    | Default      |
| --------- | ----------------------------- | ------------------------------------------------------------------------------ | ------------ |
| `PHP_ENV` | 'production' or 'development' | Defines which official php.ini template to use, "production" or "development". | 'production' |

## Licence

> [MIT](https://mit.bfren.dev/2021)

## Copyright

> Copyright (c) 2021-2023 [bfren](https://bfren.dev) (unless otherwise stated)
