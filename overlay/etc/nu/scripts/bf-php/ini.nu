use bf

# format to the 'downloaded' file so we don't unnecessarily download a php.ini file
const php_ini_downloaded = "{path}.downloaded"

# Download a php.ini file and replace values
export def main [
    values?: record # use these key/value pairs to replace values in php.ini
] {
    # download php.ini file
    let php_ini_file = $"(bf env PHP_DIR)/php.ini"
    download $php_ini_file (bf env PHP_INI)

    # replace values
    if $values != null { replace_values_in_file $php_ini_file $values }
}

# Download a standard php.ini file unless it has already been downloaded
def download [
    php_ini_file: string                # Absolute file path to php.ini file
    environment: string = "production"  # PHP environment - 'production' or 'development'
] {
    # return if the requested ini file has already been downloaded
    let downloaded = bf string format $php_ini_downloaded {path: $php_ini_file}
    if ($downloaded | path exists) { return }

    # download file
    let url = $"https://raw.githubusercontent.com/php/php-src/master/php.ini-($environment)"
    bf write debug $"Downloading php.ini from ($url)." ini/download
    http get --raw $url | save --force $php_ini_file

    # mark as downloaded
    touch $downloaded
}

# Replace configuration settings in a php.ini format using $values
def replace_values [
    initial: string # initial php.ini contents
    values: record  # use these key/value pairs to replace values in $initial
] {
    # loop through each key/value pair and replace values
    bf write debug $"Replacing php.ini values." ini/replace_values
    $values | transpose key val | reduce --fold $initial {|x, acc|
        # trim key and value
        let key = $x.key | str trim
        let val = $x.val | str trim

        # ignore empty keys / values
        if $key == "" or $val == "" { $acc }

        # replace value in accumulator
        bf write debug $" .. ($key)=($val)" ini/replace_values
        $acc | str replace --all --multiline $"^;?($key) .*$" $"($key) = ($val)"
    }
}

# Replace configuration settings in a file of php.ini format using $values
export def replace_values_in_file [
    file: string    # file to read values from and then replace with $values
    values: record  # use these key/value pairs to replace values in $file
] {
    # read initial file values
    let initial = bf fs read $file

    # replace values and save file
    replace_values $initial $values | save --force $file
}
