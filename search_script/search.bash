#!/bin/bash


all_sites=false
# Parse command line options
while getopts ":a" opt; do
  case "${opt}" in
    a)
      all_sites=true
      ;; #;; Is used to indicate that the case statement is complete.
    \?) 
      echo "Invalid option: -$OPTARG" >&2 # >&2 is used to redirect the output to the standard error stream.
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Get the search query from the command line arguments
query="$@" # $@ is used to get all the command line arguments.

# Construct the search URL
url="https://www.google.com/search?q=$query"
if [ "$all_sites" != true ]; then
  # Define the array of sites
  sites=("github.com" "w3schools.com" "stackoverflow.com" "medium.com" "reddit.com" "youtube.com" "geeksforgeeks.org")
  url+=$(printf "+site:%s" "${sites[@]}") # Append the sites to the URL
  url=${url// /+OR+} # Replace spaces with +OR+
fi

# Open the search URL in the default browser
open "$url"
