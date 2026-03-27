# Windows Privacy Script

A personalized Windows privacy and security hardening script based on [privacy.sexy](https://privacy.sexy/), with additional custom restrictions tailored to my setup.

## What It Does

Applies a curated set of privacy and security tweaks to Windows 11, including registry changes, service configurations, and system policy adjustments. Based on the privacy.sexy script generator with additional custom modifications.

## Setup

### 1. Download the Script

Download the raw file from GitHub and place it in your local `bin` folder:

```powershell
curl -o C:\Users\<your-username>\bin\windows-privacy-script.bat https://raw.githubusercontent.com/Daegybyte/useful_scripts/main/privacy/windows-privacy-script.bat
```

### 2. Create the bin Folder (if it doesn't exist)

```powershell
mkdir C:\Users\<your-username>\bin
```

### 3. Add to PATH

Run this in PowerShell to add your `bin` folder to your user PATH:

```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Users\<your-username>\bin", "User")
```

Open a new terminal for the change to take effect.

### 4. Run Manually

Open Command Prompt as Administrator and run:

```
windows-privacy-script
```

---

## Automate at Startup via Task Scheduler

To have the script run automatically on every reboot with system-level access:

1. Open **Task Scheduler** (search from Start)
2. Click **Create Task** (not Basic Task)

### General Tab
- **Name:** `Windows Privacy Script`
- **Security options:**
  - Select **Run whether user is logged on or not**
  - Check **Run with highest privileges**
  - **Configure for:** Windows 10 *(compatible with Windows 11)*

### Triggers Tab
- Click **New**
- **Begin the task:** At startup
- **Delay task for:** 30 seconds
- Ensure **Enabled** is checked

### Actions Tab
- Click **New**
- **Action:** Start a program
- **Program/script:** `C:\Users\<your-username>\bin\windows-privacy-script.bat`
- Leave **Start in** blank

### Settings Tab
- Check **Run task as soon as possible after a scheduled start is missed**

3. Click **OK** and enter your Windows password when prompted

---

## Verifying It Ran

1. Open **Task Scheduler**
2. Find the task in the library
3. Check **Last Run Result** — `0x0` means success
4. For detailed logs, go to **Properties → History tab**

> If History is blank, enable it via **View → Enable All Tasks History** in Task Scheduler.

---

## Notes

- The script must be run as Administrator to apply system-level changes
- Re-download the script from GitHub after any updates to get the latest version
- Tested on Windows 11
