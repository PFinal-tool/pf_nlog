PLUGIN_NAME="top_ip"
PLUGIN_DESC="统计访问量最高的 IP"
PLUGIN_VERSION="0.1"
PLUGIN_AUTHOR="pfinal"

plugin_init() {
    return 0
}

plugin_run() {
    local log="$1"
    awk '{print $1}' "$log" | sort | uniq -c | sort -nr | head
}