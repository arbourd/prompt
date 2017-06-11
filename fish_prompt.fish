function fish_prompt -d "Prints left prompt"
    set -l last_status  $status
    set -l glyph        "\$"
    set -l glyph_color  (set_color normal)
    set -l pwd          (prompt_pwd)
    set -l pwd_color    (set_color blue)

    if test (id -u "$USER") -eq 0
        set glyph "#"
    end

    if test "$last_status" -ne 0
        set pwd_color (set_color red)
    end

    if git_is_repo
        if git_is_staged
            set glyph_color (set_color green)
        else if git_is_stashed
            set glyph_color (set_color yellow)
        end
    end

    printf " $pwd_color$pwd $glyph_color$glyph "
end
