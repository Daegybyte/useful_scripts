# compress-show-recursive

Recursively re-encodes MKV video files to H.265 (HEVC) using ffmpeg. Skips files already in H.265. Designed to run unattended via cron or manually.

## Why

H.265 provides roughly 50–60% smaller file sizes at the same visual quality compared to H.264. Smaller files mean less Plex transcoding and faster direct play on modern devices.

## Requirements

- `ffmpeg` with `libx265` support
- `ffprobe`

## Installation

```bash
sudo cp compress-show-recursive /usr/local/bin/
sudo chmod +x /usr/local/bin/compress-show-recursive
```

## Usage

Navigate to the root directory of the files you want to convert and run:

```bash
nohup compress-show-recursive &
```

- `nohup` keeps it running even if you close the terminal
- `&` runs it in the background

Or pass a path directly:

```bash
nohup compress-show-recursive /path/to/files &
```

## Checking Progress

```bash
tail -f /home/$USER/logs/compress_show_recursive_*.log
```

## Cron
 
Runs on the 1st, of every month at 0600:
 
```crontab -e
0 6 1  * * compress-show-recursive /path/to/files

## Behavior

- Skips files already encoded in H.265
- Skips files where the output is not smaller than the original
- Encodes to a temp file first — only replaces the original after a successful encode
- Uses a lock file to prevent multiple instances running at the same time
- Auto-deletes logs older than 30 days
- Logs are saved to `/home/$USER/logs/compress_show_recursive_<timestamp>.log`

## Settings

Encoding settings are hardcoded in the script:

| Setting | Value | Notes |
|---------|-------|-------|
| Codec | libx265 | H.265/HEVC |
| CRF | 24 | Lower = better quality, larger file |
| Preset | medium | Better compression, slower encode |
| Audio | copy | Original audio kept as-is |
| Subtitles | copy | All subtitle tracks preserved |
