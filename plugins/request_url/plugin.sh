PLUGIN_NAME="request_url"
PLUGIN_DESC="统计最常访问的URL"
PLUGIN_VERSION="0.1"
PLUGIN_AUTHOR="pfinal"

plugin_init() {
    return 0
}

plugin_run() {
    local log="$1"
    echo "最常访问的URL:"
    echo "==============="
    awk -F'"' '{print $2}' "$log" | awk '{print $2}' | sort | uniq -c | sort -nr | head -20
}