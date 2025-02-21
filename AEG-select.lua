-- 奇偶行选择器 (带GUI)
script_name = "字幕奇偶行选择器"
script_description = "GUI字幕选择奇数或偶数行"
script_author = "xibaoxuan"
script_version = "2.0"

function select_lines(subs, sel)
    -- 创建GUI对话框
    local config = {
        { class = "label",     x = 0, y = 0, label = "选择模式:" },
        { class = "dropdown",  x = 1, y = 0, name = "mode",
          items = { "偶数行", "奇数行" }, value = "偶数行" },
        { class = "checkbox", x = 0, y = 1, name = "skip_comment",
          label = "跳过注释行", value = true },
        { class = "intedit", x = 0, y = 2, name = "start", 
		  label = "起始行:", value = 1 },
		{ class = "intedit", x = 1, y = 2, name = "end", 
		  label = "结束行:", value = #subs }
    }
    
    -- 显示对话框并获取用户输入
    local btn, result = aegisub.dialog.display(config)
    if btn == "Cancel" then return end  -- 用户取消操作
    
    local new_sel = {}
    for i = 1, #subs do
        local line = subs[i]
        -- 条件过滤
        local valid = (result.skip_comment and not line.comment) or not result.skip_comment
        if valid and line.class == "dialogue" then
            -- 根据用户选择判断奇偶
            if (result.mode == "偶数行" and i % 2 == 0) or
               (result.mode == "奇数行" and i % 2 == 1) then
                table.insert(new_sel, i)
            end
        end
    end
    
    aegisub.set_undo_point(script_name)
    aegisub.debug.out("将选择 " .. #new_sel .. " 行")
    return new_sel
end

-- 注册宏命令
aegisub.register_macro(script_name, script_description, select_lines)