from os import makedirs
from shutil import copy
from glob import glob
from pathlib import Path
HAS_SHADOWS = False

# Get the current directory
current_directory = Path.cwd()

# Find all directories matching the pattern "*" == all directories
creature_directories = glob(f"{current_directory}/*")
# Destination directory relative to the current directory

tokens_directory = current_directory / "tokens"

# Check if the tokens directory doesn't exist
if not tokens_directory.exists():
    # Create the tokens directory
    makedirs(tokens_directory)

shadowed = "without-shadows" if not HAS_SHADOWS else "with-shadows"

for creature_directory in creature_directories:
    # Find all PNG files within the subdirectory determined by HAS_SHADOWS bool above
    files_to_move = glob(f"{Path(creature_directory) / shadowed}/*.png")

    # Move each PNG file to the destination directory
    for file_path in files_to_move:
        file_name = Path(file_path).name
        destination_file_path = tokens_directory / file_name
        copy(file_path, destination_file_path)
        print(f"Copied: {file_path} to {destination_file_path}")
