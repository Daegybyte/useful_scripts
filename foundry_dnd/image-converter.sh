find . -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) -print0 | xargs -0 -P $(nproc) -n 10 sh -c 'for file do ffmpeg -y -i "$file" -q:v 75 "${file%.*}.webp"; done' sh
