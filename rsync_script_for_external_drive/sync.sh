#!/bin/bash
start_time=$(date +%s)
# A function for rsync with common options and I/O redirection muted
rsync_with_I_O_redirect_muted() {
    rsync -a --ignore-errors --delete "$@" 2>/dev/null
}

# Give time for drive to load
echo "Checking for drive. Please standy..."
sleep 60

path="PATH_TO_DRIVE"
# Check if /dev/sda1 is mounted at PATH_TO_DRIVE
if [ "$(df -P /dev/sda1 | awk 'NR==2 {print $6}')" = $path ]; then
        drive="sda1"

# Check if /dev/sdb1 is mounted at PATH_TO_DRIVE
elif [ "$(df -P /dev/sdb1 | awk 'NR==2 {print $6}')" = $path ]; then
        drive="sdb1"

# Check if /dev/sdc1 is mounted at PATH_TO_DRIVE
elif [ "$(df -P /dev/sdc1 | awk 'NR==2 {print $6}')" = $path ]; then
        drive="sdc1"


else
    echo "No matching drives found."
    exit 1

fi

echo ""
echo "Drive found at location: "$drive
echo "Preparing to sync..."
sleep 5

echo "Syncing media"
rsync_with_I_O_redirect_muted SOURCE DEST
echo ""

echo "Unmounting "$drive"..."
udisksctl unmount -b /dev/$drive
echo "Standby..."
# Give drive time to unmount
sleep 60
echo ""
echo "Done!"

# Record the end time
end_time=$(date +%s)
# Calculate the time difference in minutes
time_difference_in_minutes=$(( (end_time - start_time) / 60 ))
echo "Time to transfer: $time_difference_in_minutes minutes"

echo ""
echo "You may now unplug the hard drive"
