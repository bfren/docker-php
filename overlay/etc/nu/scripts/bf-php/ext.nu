use bf

# Install a list of PHP extensions
export def install [
    extensions: list<string>    # List of extensions to install - PHP prefix will be added
] {
    bf pkg install (packages $extensions)
}

# Install PHP extensions listed in a text file:
#   * any lines beginning '-' will have the value of environment variable BF_PHP_PREFIX added
#   * any lines not beginning with '-' will be installed as written
#   * any blank lines will be ignored
export def install_from_file [
    file: string = "/tmp/PHP_EXT"
] {
    # ensure the file exists
    if ($file | bf fs is_not_file) { return }

    # install packages
    bf pkg install (packages_from_file $file)
}

# Get the package names for a list of extensions, by adding the PHP prefix, e.g. 'mbstring' becomes 'php85-mbstring'
export def packages [
    extensions: list<string>    # List of extensions
]: nothing -> list<string> {
    let prefix = bf env PHP_PREFIX
    $extensions | each {|x| $"($prefix)-($x)" }
}

# Get the package names listed in a text file - see install_from_file
export def packages_from_file [
    file: string    # Path to the file
]: nothing -> list<string> {
    let prefix = bf env PHP_PREFIX
    bf fs read $file
        | lines
        | str trim
        | where $it != ""
        | each {|x| if ($x | str starts-with "-") { $"($prefix)($x)" } else { $x } }
}
