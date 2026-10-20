use bf

# format to the 'downloaded' file so we don't unnecessarily download a php.ini file
const downloaded_format = "{path}.downloaded"

# Download a php.ini file and replace values
export def main [
    values?: record # use these key/value pairs to replace values in php.ini
] {
    # download php.ini file
    let file = $"(bf env PHP_DIR)/php.ini"
    download $file (bf env PHP_ENV)

    # replace values
    if ($values | is-not-empty) { insert_or_replace_values_in_file $file $values }
}

# Download a standard php.ini file unless it has already been downloaded
def download [
    file: string                        # Absolute file path to php.ini file
    environment: string = "production"  # PHP environment - 'production' or 'development'
] {
    # return if the requested ini file has already been downloaded
    let downloaded = bf string format $downloaded_format {path: $file}
    if ($downloaded | path exists) and (bf fs read $downloaded) == $environment {
        bf write debug $"The ($environment) php.ini file has already been downloaded." ini/download
        return
    }

    # download file from the branch for the installed version of PHP (master is the next, unreleased, version)
    let url = $"https://raw.githubusercontent.com/php/php-src/(branch)/php.ini-($environment)"
    bf write debug $"Downloading php.ini from ($url)." ini/download
    bf http download $url $file

    # mark as downloaded
    $environment | save --force $downloaded
}

# The php-src branch for the installed version of PHP, e.g. PHP-8.5
export def branch []: nothing -> string {
    let version = { ^php -r "echo PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;" } | bf handle ini/branch
    $"PHP-($version)"
}

# Insert or replace configuration settings in a php.ini format using $values
def insert_or_replace_values [
    initial: string # initial php.ini contents
    values: record  # use these key/value pairs to insert or replace values in $initial
] {
    # loop through each key/value pair and insert or replace
    bf write debug $"Replacing values:" ini/insert_or_replace_values
    $values | transpose key val | reduce --fold $initial {|x, acc|
        # trim key and value
        let key = $x.key | str trim
        let val = $x.val | into string | str trim

        # ignore empty keys / values
        if $key == "" or $val == "" { return $acc }

        # replace the key/value if there is a setting line for it (commented out or not), otherwise insert it
        # (checking for the key anywhere would match it in comments, and the value would never be set)
        let escaped = $key | str replace --all "." "\\."
        if ($acc =~ $"\(?m\)^;?($escaped)[ =]") {
            bf write debug $" .. ($key)=($val) \(replace)" ini/insert_or_replace_values
            $acc | str replace --all --multiline $"^;?($escaped)[ =]+.*$" $"($key) = ($val)"
        } else {
            bf write debug $" .. ($key)=($val) \(insert)" ini/insert_or_replace_values
            $acc + $"\n($key) = ($val)"
        }
    }
}

# Insert or replace configuration settings in a file of php.ini format using $values
export def insert_or_replace_values_in_file [
    file: string    # file to read values from and then insert or replace with $values
    values: record  # use these key/value pairs to insert or replace values in $file
] {
    # read initial file values
    bf write debug $"Loading values from ($file)." ini/insert_or_replace_values_in_file
    let initial = bf fs read $file

    # insert or replace values and save file
    insert_or_replace_values $initial $values | save --force $file
}
