use bf

# Download a php.ini file and replace values
export def main [
    values?: record # use these key/value pairs to replace values in php.ini
] {
    # download php.ini file
    let php_ini_file = $"(bf env PHP_DIR)/php.ini"
    download $php_ini_file (bf env PHP_INI)

    # replace values
    if $values != null {
        let initial = bf fs read $php_ini_file
        replace_values $initial $values | save --force $php_ini_file
    }
}

# Download a standard php.ini file
export def download [
    file: string                        # Absolute file path to php.ini file
    environment: string = "production"  # PHP environment - 'production' or 'development'
] {
    let url = $"https://raw.githubusercontent.com/php/php-src/master/php.ini-($environment)"
    bf write debug $"Downloading php.ini from ($url)." ini/download
    http get --raw $url | save --force $file
}

# Replace configuration settings in a php.ini format using $values
def replace_values [
    initial: string # initial php.ini contents
    values: record  # use these key/value pairs to replace values in $initial
] {
    # loop through each key/value pair and replace values
    bf write debug $"Replacing php.ini values." ini/replace_values
    $values | transpose key value | reduce --fold $initial {|x, acc|
        # ignore empty values
        if ($x.value | str trim) == "" { $acc }

        # replace value in accumulator
        bf write debug $" .. ($x.key)=($x.value)" ini/replace_values
        $acc | str replace --all --multiline $"^;?($x.key) .*$" $"($x.key) = ($x.value)"
    }
}
