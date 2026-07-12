use bf

# Install a list of PHP extensions
export def install [
    extensions: list<string>    # List of extensions to install - PHP prefix will be added
] {
    # get PHP prefix
    let prefix = bf env PHP_PREFIX

    # build and install list of packages
    let packages = $extensions | each {|x| $"($prefix)-($x)" }
    bf pkg install $packages
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

    # get PHP prefix
    let prefix = bf env PHP_PREFIX

    # read file into a list of prefixed packages
    let packages = bf fs read $file | lines | each {|x|
        if ($x | str starts-with "-" ) {
            $"($prefix)($x)"
        } else {
            $x
        }
    }

    # install packages
    bf pkg install $packages
}
