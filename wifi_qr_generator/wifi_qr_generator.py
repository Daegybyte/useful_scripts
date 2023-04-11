# !/usr/bin/env python3

import qrcode
from tqdm import tqdm
import pathlib
# import getpass

class QR_Code_Generator:
  def generate():
    # Get the SSID and password from the user
    # comment out line 13 and uncomment line 12 to hide password when being entered
    ssid = input("SSID: ")
    # password = getpass.getpass("Enter the password: ")
    password = input("Password: ")
    
    # Create a progress bar to show the status of the QR code generation
    progress_bar = tqdm(desc="Generating QR code", total=1)

    # Generate the QR code data
    qr_data = f"WIFI:T:WPA2;S:{ssid};P:{password};;"
  
    # convert the ssid to snake_case for the output file
    file_name = QR_Code_Generator.to_snake_case(ssid)
    
    # Save the QR code as a PNG file to the desktop
    try:
        path = pathlib.Path.home() / "Desktop" / f"{file_name}"
        qrcode.make(qr_data).save(f"{path}")
    except FileNotFoundError:        
        print("Error: Path does not exist.")
    except PermissionError:
        print("Error: Permission denied to write to path.")
    except Exception as e:
        print(f"Error: {e}")
    
    # Update and close the progress bar to indicate that the QR code has been saved
    progress_bar.update(1)
    progress_bar.close()
    
  # takes a string and returns a snake_case version of it "Example Ssid" -> "example_ssid
  def to_snake_case(ssid) -> str:
    return ssid.replace(" ", "_").lower() + "_wifi_qr_code.png"

if __name__ == "__main__":
  qr = QR_Code_Generator
  qr.generate()
