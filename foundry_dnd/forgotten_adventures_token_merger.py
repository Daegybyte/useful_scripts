import os
import shutil

# Source directory containing the directories with FA_Tokens subdirectories
source_directory = os.path.join(os.getcwd(), "FA")

# Destination directory where all FA_Tokens directories will be merged
destination_directory = os.path.join(os.getcwd(), "merged")

# Iterate through each directory in the source directory
for directory in os.listdir(source_directory):
    # Construct the source directory path
    source_subdirectory = os.path.join(source_directory, directory, "FA_Tokens")
    
    # Skip non-directory files
    if not os.path.isdir(source_subdirectory):
        continue
    
    # Construct the destination directory path
    destination_subdirectory = os.path.join(destination_directory, "FA_Tokens")
    
    # Check if the destination directory already exists
    if not os.path.exists(destination_subdirectory):
        # Copy the source directory to the destination directory
        shutil.copytree(source_subdirectory, destination_subdirectory)
    else:
        # Merge the source directory with the existing destination directory
        for root, dirs, files in os.walk(source_subdirectory):
            for file in files:
                # Construct the destination file path
                destination_file_path = os.path.join(destination_subdirectory, os.path.relpath(os.path.join(root, file), source_subdirectory))
                # Create parent directories if necessary
                os.makedirs(os.path.dirname(destination_file_path), exist_ok=True)
                # Copy the file to the destination directory
                shutil.copy2(os.path.join(root, file), destination_file_path)

print("All FA_Tokens directories merged successfully.")
