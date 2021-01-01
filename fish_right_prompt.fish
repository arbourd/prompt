function fish_right_prompt -d "Prints right prompt"
    function __git_branch_name
        command git symbolic-ref --short HEAD 2>/dev/null \
            || command git describe --tags --exact-match HEAD 2>/dev/null \
            || command git rev-parse --short HEAD 2>/dev/null
    end

    function __git_changed
        ! command git diff-index --quiet HEAD 2>/dev/null \
            || count (command git ls-files --others --exclude-standard) >/dev/null
    end

    function __git_modified_files
        count (command git status --porcelain --ignore-submodules 2>/dev/null)
    end

    function __git_symbol
        command git rev-list --count --left-right @{upstream}...@ 2>/dev/null | read behind ahead

        switch "$behind $ahead"
            case " " "0 0"
            case "0 *"
                echo " ↑"
            case "* 0"
                echo " ↓"
            case "*"
                echo " ⥄"
        end
    end

    if set branch_name (__git_branch_name)
        set -l git_symbol (__git_symbol)
        set -l git_color
        set -l git_modified_files (__git_modified_files)
        set -l git_changed_files

        if __git_changed
            set git_color (set_color red)
        else
            set git_color (set_color cyan)
        end

        if test "$git_modified_files" -gt 0
            set git_changed_files (set_color yellow)"$git_modified_files changed "
        end

        printf "$git_changed_files$git_color$branch_name$git_symbol"
    end
end
