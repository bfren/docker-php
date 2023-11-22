use bf
use ini.nu

# Download and setup php.ini
export def main [] {
    # if there is an override file, use it - otherwise use defaults
    let override_file = "/php-ini.json"
    let override_values = if ($override_file | path exists) { bf fs read $override_file | from json }

    # download php.ini file and apply override values
    ini $override_values
}
