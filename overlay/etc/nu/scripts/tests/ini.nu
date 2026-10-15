use std/assert
use ../bf-php/ini.nu *


#======================================================================================================================
# helpers
#======================================================================================================================

# Write $initial to a temporary file, insert or replace $values in it, and return the result
def apply [
    initial: string # The initial php.ini contents
    values: record  # The values to insert or replace
]: nothing -> string {
    let file = mktemp
    $initial | save --force $file
    insert_or_replace_values_in_file $file $values
    let result = open --raw $file
    rm --force $file
    $result
}


#======================================================================================================================
# insert_or_replace_values_in_file
#======================================================================================================================

export def insert_or_replace__existing_setting__replaces_value [] {
    let result = apply "memory_limit = 128M\n" {memory_limit: "256M"}

    assert equal "memory_limit = 256M" ($result | str trim)
}

export def insert_or_replace__commented_setting__uncomments_and_sets_value [] {
    let result = apply ";memory_limit = 128M\n" {memory_limit: "256M"}

    assert equal "memory_limit = 256M" ($result | str trim)
}

export def insert_or_replace__missing_setting__inserts_it [] {
    let result = apply "[PHP]\n" {memory_limit: "256M"}

    assert ($result | lines | any {|x| $x == "memory_limit = 256M" }) "missing setting should be inserted"
}

export def insert_or_replace__setting_only_in_a_comment__inserts_it [] {
    # php.ini mentions settings in its comments - that must not stop the setting being added
    let result = apply "; session.name is the cookie name\n" {"session.name": "bf"}

    assert ($result | lines | any {|x| $x == "session.name = bf" }) "setting mentioned only in a comment should be inserted"
    assert ($result | str contains "; session.name is the cookie name") "comment should be left alone"
}

export def insert_or_replace__dot_in_key__matches_literally [] {
    let result = apply "sessionXname = keep\nopcache.jit_buffer_size = 0\n" {"session.name": "bf", "opcache.jit": "tracing"}

    assert ($result | str contains "sessionXname = keep") "a dot in a key should not match any character"
    assert ($result | str contains "opcache.jit_buffer_size = 0") "a longer key with the same start should be left alone"
    assert ($result | str contains "session.name = bf") "session.name should be inserted"
    assert ($result | str contains "opcache.jit = tracing") "opcache.jit should be inserted"
}

export def insert_or_replace__empty_value__is_ignored [] {
    let result = apply "memory_limit = 128M\n" {memory_limit: "", other: ""}

    assert equal "memory_limit = 128M" ($result | str trim)
}


#======================================================================================================================
# branch
#======================================================================================================================

export def branch__matches_installed_php_version [] {
    # e.g. 'PHP 8.5.11 (cli) ...' - the branch should be 'PHP-8.5'
    let version = ^php -v | lines | first | parse "PHP {major}.{minor}.{rest}" | first

    assert equal $"PHP-($version.major).($version.minor)" (branch)
}
