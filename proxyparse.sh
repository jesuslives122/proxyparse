	#!/bin/bash

	# Function to convert IP addresses in a file to the desired format.
	# This function takes two arguments: the input file (-f) and the output file.
	convertIPAddresses() {
	    local inputFile="$1"
	    local outputFile="$2"

	    # Get the protocol from the input file name.
	    local protocol="${inputFile%.*}"

	    # Check if the input file exists.
	    if [ ! -f "$inputFile" ]; then
	        echo "Input file does not exist."
	        exit 1
	    fi

	    # Check if the output file already exists.
	    if [ -f "$outputFile" ]; then
	        echo "Output file already exists. Please choose a different name."
	        exit 1
	    fi

	    # Read each line of the input file.
	    while IFS= read -r line; do
	        # Split the line into host and port.
	        IFS=':' read -r host port <<< "$line"

	        # Replace : with a space.
	        line="${line/:/ }"

	        # Append the protocol, host, and port to the output file.
	        echo "$protocol $host $port" >> "$outputFile"
	    done < "$inputFile"
	}

	# Function to merge IP addresses from multiple files in a directory.
	# This function takes two arguments: the directory (-d) and the output file.
	mergeIPAddresses() {
	    local directory="$1"
	    local outputFile="$2"

	    # Check if the directory exists.
	    if [ ! -d "$directory" ]; then
	        echo "Directory does not exist."
	        exit 1
	    fi

	    # Check if the output file already exists.
	    if [ -f "$outputFile" ]; then
	        echo "Output file already exists. Please choose a different name."
	        exit 1
	    fi

	    # Loop through each file in the directory.
	    for file in "$directory"/*.txt; do
	        # Get the protocol from the file name.
	        local protocol="${file##*/}"
	        protocol="${protocol%.*}"

	        # Read each line of the file.
	        while IFS= read -r line; do
	            # Split the line into host and port.
	            IFS=':' read -r host port <<< "$line"

	            # Replace : with a space.
	            line="${line/:/ }"

	            # Append the protocol, host, and port to the output file.
	            echo "$protocol $host $port" >> "$outputFile"
	        done < "$file"
	    done
	}

	while getopts ":f:o:d:" opt; do
  case ${opt} in
    f )
      inputFile=$OPTARG
      ;;
    o )
      outputFile=$OPTARG
      ;;
    d )
      directory=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
  esac
done
shift $((OPTIND -1))

if [ -n "$inputFile" ] && [ -n "$outputFile" ]; then
  convertIPAddresses "$inputFile" "$outputFile"
elif [ -n "$directory" ] && [ -n "$outputFile" ]; then
  mergeIPAddresses "$directory" "$outputFile"
else
  echo "Invalid arguments"
fi
