use std/assert
use bf


#======================================================================================================================
# helpers
#======================================================================================================================

# The php.ini file PHP has loaded, e.g. /etc/php85/php.ini - asked of PHP directly, as the format of 'php --ini' varies
# between versions (8.5 puts quotes around the path)
def loaded_ini []: nothing -> string {
    ^php -r "echo php_ini_loaded_file();" | str trim
}


#======================================================================================================================
# installation
#======================================================================================================================

export def install__php_runs [] {
    let result = ^php -r "echo 'ok';" | complete

    assert equal 0 $result.exit_code $"php does not run: ($result.stderr)"
    assert equal "ok" $result.stdout
}

export def install__php_version_matches_build [] {
    # the build log records the Alpine package version, e.g. 8.5.11-r0
    let expected = with-env {BF_ETC: "/etc/bf"} { bf build | get PHP } | split row "-" | first
    let installed = ^php -r "echo PHP_VERSION;"

    assert equal $expected $installed
}

export def install__php_is_a_symlink_to_versioned_executable [] {
    let target = ^readlink /usr/bin/php | str trim

    assert (("/usr/bin/php" | path type) == "symlink") "/usr/bin/php should be a symlink"
    assert ($target =~ '^(/usr/bin/)?php[0-9]+$') $"/usr/bin/php should link to a versioned PHP executable, not ($target)"
}

export def install__loads_downloaded_production_php_ini [] {
    let ini = loaded_ini

    assert ($ini | str ends-with "/php.ini") $"PHP should load a php.ini file, not '($ini)'"
    assert equal "production" (open --raw $"($ini).downloaded" | str trim) "the production php.ini should have been downloaded"
}
