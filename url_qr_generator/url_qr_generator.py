# !/usr/bin/env python3

import qrcode
from tqdm import tqdm
import pathlib
# import getpass

class URL_QR_Code_Generator:
  def generate(self):
    # Get the SSID from user
    url = input("URL: ")
    
    desc = input("Brief description: ")
    
    # Generate the QR code data string
    qr_data = f"'{url}'"
    print(f"QR data string: {qr_data}")
    
    # convert the ssid to snake_case for the output file
    file_name = URL_QR_Code_Generator.create_file_name(desc)
    
    # Create a progress bar to show the status of the QR code generation
    progress_bar = tqdm(desc="Generating QR code", total=1)
    
    # Save the QR code as a PNG file to the desktop
    path = pathlib.Path.home() / "Desktop" / f"{file_name}"
    try:    
        with open(path, 'wb') as qr_code_file: # open the file in binary mode, w might cause data loss
            qrcode.make(qr_data).save(qr_code_file)
    except FileNotFoundError:        
        print("Error: Path does not exist.")
    except PermissionError:
        print("Error: Permission denied to write to path.")
    except Exception as e:
        print(f"Error: {e}")
    
    # Update and close the progress bar to indicate that the QR code has been saved
    progress_bar.update(1)
    progress_bar.close()
    print(f"file saved to {path}")
    
  # takes a string and returns a snake_case version of it "Example DeScription" -> "example_description_url_qr_code.png"
  def create_file_name(desc: str) -> str:
    return desc.replace(" ","_").lower() + "_url_qr_code.png"
  


if __name__ == "__main__":
  qr = URL_QR_Code_Generator()
  qr.generate()
#     URL_QR_Code_Generator.generate()