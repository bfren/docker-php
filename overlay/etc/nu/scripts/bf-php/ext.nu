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
