use bf
use ini.nu

# Download and setup php.ini
export def main [] {
    ini {
        "cgi.fix_pathinfo":         (bf env PHP_INI_CGI_FIX_PATHINFO)
        "display_errors":           (bf env PHP_INI_DISPLAY_ERRORS)
        "display_startup_errors":   (bf env PHP_INI_DISPLAY_STARTUP_ERRORS)
        "error_log":                (bf env PHP_INI_ERROR_LOG)
        "error_reporting":          (bf env PHP_INI_ERROR_REPORTING)
        "post_max_size":            (bf env PHP_INI_MAX_POST)
        "memory_limit":             (bf env PHP_INI_MEMORY_LIMIT)
        "session.gc_maxlifetime":   (bf env PHP_INI_SESSION_MAX_LIFETIME)
    }
}
