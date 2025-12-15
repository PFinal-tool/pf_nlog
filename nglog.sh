
#!/bin/bash

# Nginx日志分析工具
# 版本: 1.0.0

# 全局变量
PLUGINS=()
CONFIG_FILE="conf/nglog.conf"

# 加载配置
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    fi
}

# 加载插件
load_plugin() {
    for p in plugins/*/plugin.sh; do
        if [[ -f "$p" ]]; then
            source "$p"
            PLUGINS+=("$PLUGIN_NAME")
            plugin_init
        fi
    done
}

# 运行插件
run_plugin() {
    local name="$1"
    local log="$2"

    for p in plugins/*/plugin.sh; do
        source "$p"
        if [[ "$PLUGIN_NAME" == "$name" ]]; then
            echo "=== 运行插件: $PLUGIN_NAME ==="
            echo "描述: $PLUGIN_DESC"
            echo "版本: $PLUGIN_VERSION"
            echo "作者: $PLUGIN_AUTHOR"
            echo ""
            plugin_run "$log"
            return 0
        fi
    done
    
    echo "错误: 未找到插件 '$name'"
    return 1
}

# 显示插件列表
list_plugins() {
    echo "可用的插件:"
    echo "============"
    for p in plugins/*/plugin.sh; do
        if [[ -f "$p" ]]; then
            source "$p"
            echo "- $PLUGIN_NAME: $PLUGIN_DESC (v$PLUGIN_VERSION)"
        fi
    done
}

# 显示帮助信息
show_help() {
    echo "用法: $0 [选项] <日志文件>"
    echo ""
    echo "选项:"
    echo "  -p, --plugin <插件名>    运行指定插件"
    echo "  -l, --list               显示可用插件列表"
    echo "  -h, --help               显示此帮助信息"
    echo "  -v, --version            显示版本信息"
    echo "  -o, --output <文件>      输出HTML报告到指定文件"
    echo "  -a, --all                运行所有插件并生成完整报告"
    echo ""
    echo "示例:"
    echo "  $0 -p top_ip /var/log/nginx/access.log"
    echo "  $0 -p security -o report.html /var/log/nginx/access.log"
    echo "  $0 -a -o full_report.html /var/log/nginx/access.log"
    echo "  $0 --list"
    echo "  $0 --help"
}

# 显示版本信息
show_version() {
    echo "nglog - Nginx日志分析工具 v1.0.0"
    echo "作者: pfinal"
}

# HTML报告生成函数
generate_html_report() {
    local plugin_name="$1"
    local log_file="$2"
    local output_file="$3"
    
    # 创建临时文件来捕获插件输出
    local temp_file=$(mktemp)
    
    # 运行插件并捕获输出
    run_plugin "$plugin_name" "$log_file" > "$temp_file" 2>&1
    
    # 生成HTML报告
    echo "<!DOCTYPE html>" > "$output_file"
    echo "<html lang=\"zh-CN\">" >> "$output_file"
    echo "<head>" >> "$output_file"
    echo "    <meta charset=\"UTF-8\">" >> "$output_file"
    echo "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" >> "$output_file"
    echo "    <title>Nginx日志分析报告 - $plugin_name</title>" >> "$output_file"
    echo "    <style>" >> "$output_file"
    echo "        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }" >> "$output_file"
    echo "        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }" >> "$output_file"
    echo "        h1 { color: #333; border-bottom: 2px solid #007cba; padding-bottom: 10px; }" >> "$output_file"
    echo "        .section { margin: 20px 0; padding: 15px; background: #f9f9f9; border-left: 4px solid #007cba; }" >> "$output_file"
    echo "        pre { background: #f4f4f4; padding: 10px; border-radius: 4px; overflow-x: auto; }" >> "$output_file"
    echo "        .timestamp { color: #666; font-size: 0.9em; }" >> "$output_file"
    echo "    </style>" >> "$output_file"
    echo "</head>" >> "$output_file"
    echo "<body>" >> "$output_file"
    echo "    <div class=\"container\">" >> "$output_file"
    echo "        <h1>📊 Nginx日志分析报告</h1>" >> "$output_file"
    echo "        <div class=\"timestamp\">生成时间: $(date)</div>" >> "$output_file"
    echo "        <div class=\"timestamp\">日志文件: $log_file</div>" >> "$output_file"
    echo "        <div class=\"timestamp\">分析插件: $plugin_name</div>" >> "$output_file"
    echo "        <div class=\"section\">" >> "$output_file"
    echo "            <h2>分析结果</h2>" >> "$output_file"
    echo "            <pre>" >> "$output_file"
    cat "$temp_file" >> "$output_file"
    echo "            </pre>" >> "$output_file"
    echo "        </div>" >> "$output_file"
    echo "    </div>" >> "$output_file"
    echo "</body>" >> "$output_file"
    echo "</html>" >> "$output_file"
    
    # 清理临时文件
    rm -f "$temp_file"
    
    echo "HTML报告已生成: $output_file"
}

# 运行所有插件并生成完整报告
run_all_plugins() {
    local log_file="$1"
    local output_file="$2"
    
    # 创建临时目录
    local temp_dir=$(mktemp -d)
    
    # 生成HTML报告头部
    echo "<!DOCTYPE html>" > "$output_file"
    echo "<html lang=\"zh-CN\">" >> "$output_file"
    echo "<head>" >> "$output_file"
    echo "    <meta charset=\"UTF-8\">" >> "$output_file"
    echo "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" >> "$output_file"
    echo "    <title>Nginx日志完整分析报告</title>" >> "$output_file"
    echo "    <style>" >> "$output_file"
    echo "        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }" >> "$output_file"
    echo "        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }" >> "$output_file"
    echo "        h1 { color: #333; border-bottom: 2px solid #007cba; padding-bottom: 10px; }" >> "$output_file"
    echo "        .section { margin: 20px 0; padding: 15px; background: #f9f9f9; border-left: 4px solid #007cba; }" >> "$output_file"
    echo "        pre { background: #f4f4f4; padding: 10px; border-radius: 4px; overflow-x: auto; }" >> "$output_file"
    echo "        .timestamp { color: #666; font-size: 0.9em; }" >> "$output_file"
    echo "        .nav { background: #e9ecef; padding: 10px; border-radius: 4px; margin-bottom: 20px; }" >> "$output_file"
    echo "        .nav a { margin-right: 15px; text-decoration: none; color: #007cba; }" >> "$output_file"
    echo "    </style>" >> "$output_file"
    echo "</head>" >> "$output_file"
    echo "<body>" >> "$output_file"
    echo "    <div class=\"container\">" >> "$output_file"
    echo "        <h1>📊 Nginx日志完整分析报告</h1>" >> "$output_file"
    echo "        <div class=\"timestamp\">生成时间: $(date)</div>" >> "$output_file"
    echo "        <div class=\"timestamp\">日志文件: $log_file</div>" >> "$output_file"
    echo "        <div class=\"nav\">" >> "$output_file"
    
    # 生成导航
    for p in plugins/*/plugin.sh; do
        if [[ -f "$p" ]]; then
            source "$p"
            echo "            <a href=\"#$PLUGIN_NAME\">$PLUGIN_NAME</a>" >> "$output_file"
        fi
    done
    
    echo "        </div>" >> "$output_file"
    
    # 运行所有插件
    for p in plugins/*/plugin.sh; do
        if [[ -f "$p" ]]; then
            source "$p"
            local plugin_output=$(mktemp)
            
            echo "        <div class=\"section\" id=\"$PLUGIN_NAME\">" >> "$output_file"
            echo "            <h2>$PLUGIN_NAME - $PLUGIN_DESC</h2>" >> "$output_file"
            echo "            <pre>" >> "$output_file"
            
            # 运行插件并捕获输出
            run_plugin "$PLUGIN_NAME" "$log_file" > "$plugin_output" 2>&1
            cat "$plugin_output" >> "$output_file"
            
            echo "            </pre>" >> "$output_file"
            echo "        </div>" >> "$output_file"
            
            rm -f "$plugin_output"
        fi
    done
    
    echo "    </div>" >> "$output_file"
    echo "</body>" >> "$output_file"
    echo "</html>" >> "$output_file"
    
    # 清理临时目录
    rm -rf "$temp_dir"
    
    echo "完整HTML报告已生成: $output_file"
}

# 主函数
main() {
    local plugin_name=""
    local log_file=""
    local output_file=""
    local run_all=false
    
    # 参数解析
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--plugin)
                plugin_name="$2"
                shift 2
                ;;
            -o|--output)
                output_file="$2"
                shift 2
                ;;
            -a|--all)
                run_all=true
                shift
                ;;
            -l|--list)
                list_plugins
                exit 0
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            -*)
                echo "错误: 未知选项 $1"
                show_help
                exit 1
                ;;
            *)
                log_file="$1"
                shift
                ;;
        esac
    done
    
    # 检查日志文件
    if [[ -z "$log_file" ]]; then
        echo "错误: 请指定日志文件"
        show_help
        exit 1
    fi
    
    if [[ ! -f "$log_file" ]]; then
        echo "错误: 日志文件不存在: $log_file"
        exit 1
    fi
    
    # 加载配置和插件
    load_config
    load_plugin
    
    # 处理输出选项
    if [[ -n "$output_file" ]]; then
        if [[ "$run_all" == true ]]; then
            # 运行所有插件并生成完整报告
            run_all_plugins "$log_file" "$output_file"
        elif [[ -n "$plugin_name" ]]; then
            # 运行单个插件并生成报告
            generate_html_report "$plugin_name" "$log_file" "$output_file"
        else
            echo "错误: 使用 -o 选项时需要指定插件或使用 -a 选项"
            show_help
            exit 1
        fi
    else
        # 普通模式运行
        if [[ "$run_all" == true ]]; then
            echo "运行所有插件分析:"
            echo "=================="
            for p in plugins/*/plugin.sh; do
                if [[ -f "$p" ]]; then
                    source "$p"
                    echo ""
                    run_plugin "$PLUGIN_NAME" "$log_file"
                fi
            done
        elif [[ -n "$plugin_name" ]]; then
            run_plugin "$plugin_name" "$log_file"
        else
            echo "请使用 -p 选项指定要运行的插件或使用 -a 运行所有插件"
            list_plugins
            exit 1
        fi
    fi
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi