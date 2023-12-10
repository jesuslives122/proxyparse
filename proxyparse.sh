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
	 
	## Unit Tests
	 
	# Test convertIPAddresses function with a valid input file.
	test_convertIPAddresses_valid() {
	    local inputFile="socks5.txt"
	    local outputFile="fixsocks5.txt"
	 
	    # Create a sample input file.
	    echo "104.200.135.46:4145" > "$inputFile"
	 
	    # Call the function.
	    convertIPAddresses "$inputFile" "$outputFile"
	 
	    # Check if the output file is created.
	    if [ -f "$outputFile" ]; then
	        # Check the content of the output file.
	        local expectedOutput="socks5 104.200.135.46 4145"
	        local actualOutput=$(cat "$outputFile")
	 
	        if [ "$actualOutput" = "$expectedOutput" ]; then
	            echo "Test 1 Passed!"
	        else
	            echo "Test 1 Failed!"
	        fi
	    else
	        echo "Test 1 Failed!"
	    fi
	 
	    # Clean up the files.
	    rm "$inputFile" "$outputFile"
	}
	 
	# Test convertIPAddresses function with a non-existent input file.
	test_convertIPAddresses_nonexistentInputFile() {
	    local inputFile="nonexistent.txt"
	    local outputFile="output.txt"
	 
	    # Call the function.
	    convertIPAddresses "$inputFile" "$outputFile"
	 
	    # Check if the error message is displayed.
	    if [ $? -eq 1 ]; then
	        echo "Test 2 Passed!"
	    else
	        echo "Test 2 Failed!"
	    fi
	}
	 
	# Test convertIPAddresses function with an existing output file.
	test_convertIPAddresses_existingOutputFile() {
	    local inputFile="input.txt"
	    local outputFile="existing.txt"
	 
	    # Create a sample input file.
	    echo "192.168.0.1:8080" > "$inputFile"
	 
	    # Create an existing output file.
	    touch "$outputFile"
	 
	    # Call the function.
	    convertIPAddresses "$inputFile" "$outputFile"
	 
	    # Check if the error message is displayed.
	    if [ $? -eq 1 ]; then
	        echo "Test 3 Passed!"
	    else
	        echo "Test 3 Failed!"
	    fi
	 
	    # Clean up the files.
	    rm "$inputFile" "$outputFile"
	}
	 
	# Test mergeIPAddresses function with a valid directory.
	test_mergeIPAddresses_valid() {
	    local directory="proxies"
	    local outputFile="mergedproxies.txt"
	 
	    # Create sample input files.
	    mkdir "$directory"
	    echo "104.200.135.46:4145" > "$directory/socks5.txt"
	    echo "192.168.0.1:8080" > "$directory/http.txt"
	 
	    # Call the function.
	    mergeIPAddresses "$directory" "$outputFile"
	 
	    # Check if the output file is created.
	    if [ -f "$outputFile" ]; then
	        # Check the content of the output file.
	        local expectedOutput="socks5 104.200.135.46 4145\nhttp 192.168.0.1 8080"
	        local actualOutput=$(cat "$outputFile")
	 
	        if [ "$actualOutput" = "$expectedOutput" ]; then
	            echo "Test 4 Passed!"
	        else
	            echo "Test 4 Failed!"
	        fi
	    else
	        echo "Test 4 Failed!"
	    fi
	 
	    # Clean up the files.
	    rm -r "$directory" "$outputFile"
	}
	 
	# Test mergeIPAddresses function with a non-existent directory.
	test_mergeIPAddresses_nonexistentDirectory() {
	    local directory="nonexistent"
	    local outputFile="output.txt"
	 
	    # Call the function.
	    mergeIPAddresses "$directory" "$outputFile"
	 
	    # Check if the error message is displayed.
	    if [ $? -eq 1 ]; then
	        echo "Test 5 Passed!"
	    else
	        echo "Test 5 Failed!"
	    fi
	}
	 
	# Test mergeIPAddresses function with an existing output file.
	test_mergeIPAddresses_existingOutputFile() {
	    local directory="proxies"
	    local outputFile="existing.txt"
	 
	    # Create a sample input file.
	    mkdir "$directory"
	    echo "104.200.135.46:4145" > "$directory/socks5.txt"
	 
	    # Create an existing output file.
	    touch "$outputFile"
	 
	    # Call the function.
	    mergeIPAddresses "$directory" "$outputFile"
	 
	    # Check if the error message is displayed.
	    if [ $? -eq 1 ]; then
	        echo "Test 6 Passed!"
	    else
	        echo "Test 6 Failed!"
	    fi
	 
	    # Clean up the files.
	    rm -r "$directory" "$outputFile"
	}
	 
	# Run the unit tests.
	test_convertIPAddresses_valid
	test_convertIPAddresses_nonexistentInputFile
	test_convertIPAddresses_existingOutputFile
	test_mergeIPAddresses_valid
	test_mergeIPAddresses_nonexistentDirectory
	test_mergeIPAddresses_existingOutputFile