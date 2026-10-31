# PHP

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-php) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fphp) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fphp) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-php/build.yml?branch=main)

[Docker Hub](https://hub.docker.com/r/bfren/php) - [Quay.io](https://quay.io/repository/bfren/php) - [bfren ecosystem](https://github.com/bfren/docker)

## Introduction

A small image for running [PHP](https://www.php.net) on the command line - scripts, Composer-style tools, scheduled jobs - with PHP 7.2 to 8.5 from Alpine's own packages.

It is [Alpine](https://github.com/bfren/docker-alpine) with:

* the PHP command-line interpreter, and nothing else - add the extensions you need
* the official `php.ini` (production or development), with your own values applied on top
* the `bf-php` module, which [Nginx + PHP](https://github.com/bfren/docker-nginx-php) also uses to manage `php.ini` and extensions

For websites, use [Nginx + PHP](https://github.com/bfren/docker-nginx-php) instead - it adds nginx and PHP-FPM.

## Quickstart

Run a script in the current folder:

```sh
docker run --rm -v ./:/ws quay.io/bfren/php:php8.5 php script.php
```

The current folder is mounted at `/ws`, which is the working directory. If the first argument starts with `-` it is passed to `php`, so this is the same:

```sh
docker run --rm -v ./:/ws quay.io/bfren/php:php8.5 -f script.php
```

## Features

* 🐘 PHP 8.2, 8.3, 8.4 and 8.5 - choose with the image tag
* 📄 The official `php.ini-production` (or `-development`) file for your PHP version, downloaded from the PHP source
* ⚙️ Override any `php.ini` value with a small JSON file
* 🧩 Add extensions by name with `bf-php ext install`

## Tags

Images are published to Docker Hub (`bfren/php`) and Quay.io (`quay.io/bfren/php`) for `linux/amd64`, `linux/arm/v7` and `linux/arm64`. Tags start with the PHP version.

| Tag                            | Example            | Use when                                              |
| ------------------------------ | ------------------ | ----------------------------------------------------- |
| `phpX.Y`                       | `php8.5`           | You want the latest image for a PHP version           |
| `phpX.Y-MAJOR`                 | `php8.5-3`         | You want updates, but not breaking changes            |
| `phpX.Y-MINOR`                 | `php8.5-3.1`       | You want fixes only - **recommended for building on** |
| `phpX.Y-VERSION`               | `php8.5-3.1.20`    | You want to pin this image exactly                    |
| `phpX.Y.Z`                     | `php8.5.11`        | You want an exact PHP release                         |
| `phpX.Y.Z-VERSION`             | `php8.5.11-3.1.20` | You want to pin both                                  |
| `latest`, `3`, `3.1`, `3.1.20` |                    | As above, on PHP 8.5                                  |

Each PHP version is built on the Alpine release that packages it:

| PHP | Release | Alpine | PHP security support ends |
| --- | ------- | ------ | ------------------------- |
| 8.5 | 8.5.11  | 3.24   | 2029-12-31                |
| 8.4 | 8.4.26  | 3.24   | 2028-12-31                |
| 8.3 | 8.3.35  | 3.24   | 2027-12-31                |
| 8.2 | 8.2.33  | 3.22   | 2026-12-31                |

## Configuration

### Volumes

| Volume | Purpose                                                          |
| ------ | ---------------------------------------------------------------- |
| `/ws`  | The working directory - mount the folder with your scripts here. |

### Environment Variables

| Variable        | Values                      | Description                                                                                                       | Default           |
| --------------- | --------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------- |
| `BF_PHP_ENV`    | `production`, `development` | Which official `php.ini` to use.                                                                                  | `production`      |
| `BF_PHP_EXT`    | space-separated list        | Only read when this image itself is built - install extensions in your own image (see [Extensions](#extensions)). | *blank*           |
| `BF_PHP_DIR`    | path                        | PHP's configuration folder - set by the image, don't change it.                                                   | e.g. `/etc/php85` |
| `BF_PHP_PREFIX` | e.g. `php85`                | Alpine's package prefix for this PHP version - set by the image, don't change it.                                 | e.g. `php85`      |
| `BF_DEBUG`      | `0`, `1`                    | Show detailed output from `bf` scripts.                                                                           | `0`               |

## How It Works

### Starting

The entrypoint, `/init`, runs before every command:

1. It saves the container's environment, so `bf` scripts can read it.
2. It runs `bf-php init`, which sets up `php.ini` (below).
3. It changes to `/ws` and runs your command. If the first argument starts with `-`, it runs `php` with your arguments.

There is no default command - `docker run bfren/php` on its own does nothing.

### `php.ini`

When the image is built, the official `php.ini-production` file is downloaded from the PHP source on GitHub, from the branch for the installed version (e.g. `PHP-8.5`). At every start:

* if `BF_PHP_ENV` asks for a different file (`development`), that file is downloaded instead - so the container needs internet access the first time
* if `/php-ini.json` exists, each of its values is set in `php.ini`, replacing the existing line or adding a new one

For example, to show errors while developing:

```json
{
    "display_errors": "On",
    "display_startup_errors": "On"
}
```

```sh
docker run --rm -v ./:/ws -v ./php-ini.json:/php-ini.json:ro -e BF_PHP_ENV=development quay.io/bfren/php:php8.5 php script.php
```

### Extensions

Only the PHP interpreter is installed. Add extensions in your own image - they are Alpine packages, named `<prefix>-<extension>` (e.g. `php85-mbstring`), and `bf-php ext install` adds the prefix for you:

```nu
# overlay/tmp/install
#!/usr/bin/nu

use bf
use bf-php

def main [] {
    bf-php ext install [mbstring pdo_mysql]
}
```

`bf-php ext install_from_file` installs from a list in `/tmp/PHP_EXT`, one per line: lines starting `-` get the prefix (`-mbstring` becomes `php85-mbstring`), other lines are installed as written. Find package names at [pkgs.alpinelinux.org](https://pkgs.alpinelinux.org/packages?name=php85-*) - change `php85` to your version's prefix.

### The `bf-php` module

| Command                                       | Use                                                                 |
| --------------------------------------------- | ------------------------------------------------------------------- |
| `bf-php init`                                 | Set up `php.ini` and apply `/php-ini.json` (used by `/init`).       |
| `bf-php ini [values]`                         | Download `php.ini` if needed, then set each value in the record.    |
| `bf-php ini insert_or_replace_values_in_file` | Set values in any `php.ini`-format file, e.g. PHP-FPM's `www.conf`. |
| `bf-php ext install [names]`                  | Install extensions by name, adding the PHP prefix.                  |
| `bf-php ext install_from_file [file]`         | Install extensions listed in a file (default `/tmp/PHP_EXT`).       |

## Building on this image

```dockerfile
FROM quay.io/bfren/php:php8.5-3.1

COPY ./overlay /
RUN bf-install
```

Put your installation steps (e.g. extensions) in `overlay/tmp/install`. See [Alpine](https://github.com/bfren/docker-alpine) for everything else.

## Testing

```sh
./test.nu        # builds the PHP 8.5 image and runs /test
./test.nu 8.2    # the same for PHP 8.2
./test.nu --all  # every version, in parallel
./run.sh         # builds the PHP 8.5 image in development mode, with php-ini-sample.json applied, and opens a shell
```

`/test` runs this image's tests alongside Alpine's, and fails if tests don't execute. They check that PHP runs and matches the version in the build log, that `php` links to the versioned executable and loads the downloaded `php.ini`, how `php.ini` values are replaced or added, and how extension names become package names.

## Troubleshooting

### Nothing happens when I run the image

There is no default command. Give it one, e.g. `php script.php` or `php -v`.

### Setting `BF_PHP_EXT` with `docker run` does nothing

In this image extensions are only installed when the image is built. Install them in your own image (see [Extensions](#extensions)). [Nginx + PHP](https://github.com/bfren/docker-nginx-php) is different - it installs `BF_PHP_EXT` at every start.

### "Call to undefined function"

The function's extension isn't installed - check [pkgs.alpinelinux.org](https://pkgs.alpinelinux.org) for the package and add it.

## FAQs

### Why Alpine's PHP packages and not the official PHP image?

They are small, receive Alpine's security fixes, and install extensions as packages in seconds - no compiling. The catch is that each PHP version is tied to the Alpine release that packages it.

### Why are some versions on old Alpine releases?

Alpine only packages a few PHP versions in each release, so older PHP versions come from the last Alpine release that had them.

## Licence

> [MIT](https://mit.bfren.dev/2021)

## Copyright

> Copyright (c) 2021-2026 [bfren](https://bfren.dev) (unless otherwise stated)
