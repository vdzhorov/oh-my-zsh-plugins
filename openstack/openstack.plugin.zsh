# Functions
function openstack-version() {
    openstack --version
}

# Prints the cloud names defined in all clouds.yaml files that openstacksdk reads
function _openstack_clouds() {
    local file
    for file in ./clouds.yaml \
                "${XDG_CONFIG_HOME:-$HOME/.config}/openstack/clouds.yaml" \
                /etc/openstack/clouds.yaml; do
        [[ -r "$file" ]] || continue
        awk '
            /^[[:space:]]*(#|$)/ { next }
            /^clouds:/ { in_clouds = 1; indent = ""; next }
            /^[^[:space:]]/ { in_clouds = 0 }
            in_clouds {
                match($0, /^[[:space:]]+/)
                cur = substr($0, 1, RLENGTH)
                if (indent == "") indent = cur
                if (cur == indent) {
                    name = substr($0, RLENGTH + 1)
                    sub(/:.*$/, "", name)
                    gsub(/["\047]/, "", name)
                    print name
                }
            }
        ' "$file"
    done | sort -u
}

function openstack-cloud() {
    if [[ -n "$1" ]]; then
        export OS_CLOUD="$1"
        echo "OpenStack cloud : $OS_CLOUD"
    else
        echo "Current cloud : ${OS_CLOUD:-<none>}"
        echo "Available clouds :"
        _openstack_clouds | sed 's/^/  /'
        echo
        echo "Usage : openstack-cloud <cloud name>"
    fi
}

function _openstack-cloud() {
    local -a clouds
    clouds=(${(f)"$(_openstack_clouds)"})
    _describe 'cloud' clouds
}
compdef _openstack-cloud openstack-cloud

# Shows the OS_* environment variables with secrets masked
function openstack-env() {
    local var
    for var in ${(ko)parameters[(I)OS_*]}; do
        if [[ "$var" == *(PASSWORD|SECRET|TOKEN)* ]]; then
            echo "$var=********"
        else
            echo "$var=${(P)var}"
        fi
    done
}

# Unsets all OS_* environment variables (e.g. after sourcing an openrc file)
function openstack-unset() {
    unset -m 'OS_*'
    echo "All OS_* variables unset"
}

# Lists all aliases provided by this plugin
function openstack-aliases() {
    local name
    for name in ${(ko)aliases}; do
        [[ "${aliases[$name]}" == openstack* ]] && printf '%-10s %s\n' "$name" "${aliases[$name]}"
    done
    return 0
}

# Prompt helper, e.g. RPROMPT='$(openstack_prompt_info)'
function openstack_prompt_info() {
    local name="${OS_CLOUD:-$OS_PROJECT_NAME}"
    [[ -n "$name" ]] || return
    echo "${ZSH_THEME_OPENSTACK_PREFIX-<os:}${name:gs/%/%%}${ZSH_THEME_OPENSTACK_SUFFIX->}"
}

# Completion for the openstack CLI. Generating it is slow, so it is cached
# and regenerated in the background when the openstack binary changes.
if (( $+commands[openstack] )); then
    _openstack_comp_file="${ZSH_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}}/openstack_completion.bash"
    if [[ ! -s "$_openstack_comp_file" || "$_openstack_comp_file" -ot "$commands[openstack]" ]]; then
        mkdir -p "${_openstack_comp_file:h}"
        # Per-process temp file, so that shells starting at the same time don't race
        (tmp="$_openstack_comp_file.$$.tmp"
         if openstack complete --shell bash >| "$tmp" 2>/dev/null; then
             mv -f "$tmp" "$_openstack_comp_file"
         else
             rm -f "$tmp"
         fi) &|
    fi
    if [[ -s "$_openstack_comp_file" ]]; then
        autoload -Uz bashcompinit && bashcompinit
        source "$_openstack_comp_file"
    fi
    unset _openstack_comp_file
fi

# Alias
alias os='openstack '
alias osver='openstack-version'
alias oscl='openstack-cloud'
alias osenv='openstack-env'
alias osunset='openstack-unset'
alias osalias='openstack-aliases'
alias ostoken='openstack token issue'
alias oscat='openstack catalog list'
alias osproj='openstack project '
alias oss='openstack server '
alias ossl='openstack server list'
alias osss='openstack server show'
alias osimg='openstack image '
alias osimgl='openstack image list'
alias osfl='openstack flavor '
alias osfll='openstack flavor list'
alias osnet='openstack network '
alias osnetl='openstack network list'
alias ossub='openstack subnet '
alias osport='openstack port '
alias osrt='openstack router '
alias osfip='openstack floating ip '
alias ossg='openstack security group '
alias ossgr='openstack security group rule '
alias osvol='openstack volume '
alias osvoll='openstack volume list'
alias oskey='openstack keypair '
alias osstack='openstack stack '
alias osq='openstack quota show'
