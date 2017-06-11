function fish_right_prompt -d "Prints right prompt"
    function __git_modified_files -d "Counts number of modified files"
        count (command git status --porcelain --ignore-submodules)
    end

    if set branch_name (git_branch_name)
        set -l git_ahead (git_ahead " ↑" " ↓" " ⥄ ")
        set -l git_color
        set -l git_modified_files (__git_modified_files)
        set -l git_changed_files

        if git_is_dirty
            set git_color (set_color red)
        else if git_is_touched
            set git_color (set_color red)
        else
            set git_color (set_color cyan)
        end

        if test "$git_modified_files" -ne 0
            set git_changed_files (set_color yellow)"$git_modified_files changed "
        end

        printf "$git_changed_files$git_color$branch_name$git_ahead "
        set_color $fish_color_normal
    end
end
