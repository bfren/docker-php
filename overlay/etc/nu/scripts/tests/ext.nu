use std/assert
use ../bf-php/ext.nu *


#======================================================================================================================
# packages
#======================================================================================================================

export def packages__adds_php_prefix [] {
    let result = with-env {BF_PHP_PREFIX: "php85"} { packages [mbstring pdo_mysql] }

    assert equal ["php85-mbstring" "php85-pdo_mysql"] $result
}


#======================================================================================================================
# packages_from_file
#======================================================================================================================

export def packages_from_file__prefixes_dash_lines_keeps_others_and_ignores_blank_lines [] {
    let file = mktemp
    "-mbstring\n\ncomposer\n  -curl  \n" | save --force $file

    let result = with-env {BF_PHP_PREFIX: "php85"} { packages_from_file $file }
    rm --force $file

    assert equal ["php85-mbstring" "composer" "php85-curl"] $result
}
