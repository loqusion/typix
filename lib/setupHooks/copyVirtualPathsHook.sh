_same_path() {
    [ "$(realpath "$1")" = "$(realpath "$2")" ]
}

_ensure_parent_exists() {
    mkdir -p "$(dirname "$1")"
}

_cleanup_parent() {
    local parent
    parent=$(dirname "$1")
    if ! _same_path "." "$1" && ! _same_path "." "$parent"; then
        rmdir -p --ignore-fail-on-non-empty "$parent"
    fi
}

copyVirtualPaths() {
	:
	@copyAllVirtualPaths@
}

preBuildHooks+=(copyVirtualPaths)
