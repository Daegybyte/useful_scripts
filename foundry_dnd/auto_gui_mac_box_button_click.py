import pyautogui
import time

# Path to the text file containing URLs
file_path = 'links.txt'

# Screen coordinates for the input box and button
input_box_coords = (2510, 1012)  # Replace with the actual coordinates
button_coords = (2998, 1003)     # Replace with the actual coordinates

# Delay to allow switching to the application window
initial_delay = 5

# Set a global pause between PyAutoGUI actions
pyautogui.PAUSE = 0.5  # Adjust the pause duration as needed

# Wait for a few seconds to switch to the application window
print(f"You have {initial_delay} seconds to switch to the application window...")
time.sleep(initial_delay)

# Read the URLs from the file
with open(file_path, 'r') as file:
    urls = file.readlines()

# Loop through the URLs, enter each into the input box, and click the button
for url in urls:
    # Wait for any processing to complete (adjust time as needed)
    time.sleep(3)
    url = url.strip()  # Remove any leading/trailing whitespace
    pyautogui.click(input_box_coords)
    
    if url:
        # Click on the input box
        time.sleep(1)
        pyautogui.click(input_box_coords)
        time.sleep(1)
        pyautogui.click(input_box_coords)
        
        # Type the URL with a small delay between each keystroke
        time.sleep(1)
        pyautogui.write(url, interval=0.1)  # Adjust the interval as needed
        
        # Click the button
        time.sleep(1)
        pyautogui.click(button_coords)
        
        # Wait for any processing to complete (adjust time as needed)
        time.sleep(1)
        pyautogui.click(button_coords)
        
        time.sleep(1)
        pyautogui.click(input_box_coords)

    

print("All URLs have been processed.")
