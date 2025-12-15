PLUGIN_NAME="status_code"
PLUGIN_DESC="统计HTTP状态码分布"
PLUGIN_VERSION="0.1"
PLUGIN_AUTHOR="pfinal"

plugin_init() {
    return 0
}

plugin_run() {
    local log="$1"
    echo "HTTP状态码统计:"
    echo "================"
    awk '{print $9}' "$log" | sort | uniq -c | sort -nr | head -20
    echo ""
    
    # 统计成功和错误比例
    echo "状态码分类统计:"
    echo "----------------"
    local total=$(wc -l < "$log")
    local success=$(awk '$9 ~ /^2[0-9][0-9]$/ {count++} END {print count}' "$log")
    local redirect=$(awk '$9 ~ /^3[0-9][0-9]$/ {count++} END {print count}' "$log")
    local client_error=$(awk '$9 ~ /^4[0-9][0-9]$/ {count++} END {print count}' "$log")
    local server_error=$(awk '$9 ~ /^5[0-9][0-9]$/ {count++} END {print count}' "$log")
    
    echo "总请求数: $total"
    echo "成功请求(2xx): $success ($(echo "scale=2; $success*100/$total" | bc)%) "
    echo "重定向(3xx): $redirect ($(echo "scale=2; $redirect*100/$total" | bc)%) "
    echo "客户端错误(4xx): $client_error ($(echo "scale=2; $client_error*100/$total" | bc)%) "
    echo "服务器错误(5xx): $server_error ($(echo "scale=2; $server_error*100/$total" | bc)%) "
}