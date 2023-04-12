# !/usr/bin/env python3

import qrcode
from tqdm import tqdm
import pathlib
# import getpass

class QR_Code_Generator:
  def generate():
    # Get the SSID from user
    ssid = input("SSID: ")
    # Get the password from the user
    # password = getpass.getpass("Password: ")
    password = input("Password: ")
    # get the auth type from user input
    auth_type = QR_Code_Generator.get_auth_type(input("Authorisation Type (WPA2, etc): "))
    
    # Create a progress bar to show the status of the QR code generation
    progress_bar = tqdm(desc="Generating QR code", total=1)

    # Generate the QR code data string
    qr_data = f"WIFI:T:{auth_type};S:{ssid};P:{password};;"
    print(qr_data)
    
    # convert the ssid to snake_case for the output file
    file_name = QR_Code_Generator.create_file_name(ssid)
    
    try:    
        # Save the QR code as a PNG file to the desktop
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
    
  # takes a string and returns a snake_case version of it "Example Ssid" -> "example_ssid_wifi_qr_code.png"
  def create_file_name(ssid: str) -> str:
    return ssid.replace(" ", "_").lower() + "_wifi_qr_code.png"
  
  # Takes a string from user input and returns the auth type. If empty, returns WPA2 as a default
  def get_auth_type(auth_type: str) -> str:
      auth_type = auth_type.strip().upper()
      auth_types = {
          "": "WPA2",
          "WEP": "WEP",
          "WPA": "WPA",
          "WPA2": "WPA2",
          "WPA3": "WPA3",
          "OPEN": "Open"
      }
      if auth_type in auth_types:
          return auth_types[auth_type]
      else:
          raise ValueError("Invalid authentication type")


if __name__ == "__main__":
  qr = QR_Code_Generator
  qr.generate()
