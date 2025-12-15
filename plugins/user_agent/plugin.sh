PLUGIN_NAME="user_agent"
PLUGIN_DESC="分析用户代理(User-Agent)信息"
PLUGIN_VERSION="0.1"
PLUGIN_AUTHOR="pfinal"

plugin_init() {
    return 0
}

plugin_run() {
    local log="$1"
    echo "用户代理(User-Agent)分析:"
    echo "========================="
    
    # 统计浏览器类型
    echo "浏览器类型统计:"
    echo "----------------"
    awk -F'"' '{print $6}' "$log" | \
    awk '{
        if (/Chrome/) print "Chrome"
        else if (/Firefox/) print "Firefox"
        else if (/Safari/) print "Safari"
        else if (/Edge/) print "Edge"
        else if (/MSIE|Trident/) print "Internet Explorer"
        else if (/Opera/) print "Opera"
        else if (/bot|Bot|crawler|Crawler|spider|Spider/) print "爬虫/机器人"
        else print "其他"
    }' | sort | uniq -c | sort -nr
    
    echo ""
    echo "移动设备访问统计:"
    echo "------------------"
    local total=$(wc -l < "$log")
    local mobile=$(awk -F'"' '$6 ~ /Mobile|Android|iPhone|iPad|iPod/ {count++} END {print count}' "$log")
    echo "移动设备访问: $mobile ($(echo "scale=2; $mobile*100/$total" | bc)%) "
    echo "桌面设备访问: $((total - mobile)) ($(echo "scale=2; ($total - $mobile)*100/$total" | bc)%) "
}