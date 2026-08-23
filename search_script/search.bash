#!/bin/bash


all_sites=false
# Parse command line options
while getopts ":a" opt; do # opt is used to store the option and OPTARG is used to store the value of the option.
  case "${opt}" in # ${opt} is used to get the value of the variable opt.
    a) # -a is used to search all sites
      all_sites=true
      ;; #;; Is used to indicate that the case statement is complete.
    \?) 
      echo "Invalid option: -$OPTARG" >&2 # >&2 is used to redirect the output to the standard error stream.
      exit 1 
      ;;
  esac # end of case statement
done # end of while loop getopts
 # OPTIND is used to get the index of the next argument. 
 # $((OPTIND -1)) is used to get the number of arguments that have been parsed. 
 # shift is used to shift the arguments to the left by the number of arguments that have been parsed.
shift $((OPTIND -1))

# Get the search query from the command line arguments
query="$@" # $@ is used to get all the command line arguments.
query_encoded=${query// /+} # Replace spaces in the query with + for URL encoding
url="https://www.google.com/search?q=$query_encoded"
if [ "$all_sites" == false ]; then
  # Define the array of sites
  sites=("github.com" "w3schools.com" "stackoverflow.com" "medium.com" "reddit.com" "youtube.com" "geeksforgeeks.org")
  site_filter="" # Will hold the "+OR+site:X" clauses for each site
  for site in "${sites[@]}"; do
    site_filter+="+OR+site:$site" # Append each site with +OR+ prefix
  done # end of for loop
  url+="+($site_filter)" # Append the grouped site filters to the URL
fi # end of if statement

# Open the search URL in the default browser
open "$url"
