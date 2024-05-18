find . -type f -name "*.mp3" -print0 | xargs -0 -P $(nproc) -n 10 sh -c 'for file do ffmpeg -y -i "$file" -c:a libvorbis -q:a 5 "${file%.*}.ogg"; done' sh

