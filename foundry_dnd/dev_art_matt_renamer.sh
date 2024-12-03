declare -A count; for file in *_by*.png; do base="${file%%_by*}"; count["$base"]=$((count["$base"] + 1)); mv "$file" "${base}_${count["$base"]}.png"; done

