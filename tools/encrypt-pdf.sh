#!/bin/bash

# Check if a password is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <password> [directory]"
  echo "Encrypts all PDF files in the specified directory (or the current directory) and its subdirectories using qpdf, then removes the original files and renames the directory. Finally, prints HTML links."
  exit 1
fi

password="$1"
directory="${2:-.}" # Use the provided directory, or the current directory if none is given

# Function to sanitize filenames and directory names
sanitize_name() {
  local name="$1"
  echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:].(]/-/g; s/)//g' # Replace space, ., ( with - and remove )
}

# Function to sanitize directory names recursively
sanitize_directories() {
  local dir="$1"

  # Find all subdirectories
  find "$dir" -mindepth 1 -type d | while read subdir; do
    local sanitized_subdir=$(sanitize_name "$(basename "$subdir")")
    local parent_dir=$(dirname "$subdir")
    local new_subdir="$parent_dir/$sanitized_subdir"

    if [ "$subdir" != "$new_subdir" ]; then
      mv "$subdir" "$new_subdir"
      echo "Renamed directory: $subdir -> $new_subdir"
    fi
  done
}

# Function to process a PDF file and store links
process_pdf() {
  local file="$1"
  local password="$2"

  # Extract the directory and filename without the extension
  local file_dir=$(dirname "$file")
  local filename=$(basename "$file" .pdf)
  local original_filename=$(basename "$file") #get original filename

  # Sanitize the filename
  local sanitized_filename=$(sanitize_name "$filename")

  # Construct the output filename
  local output_file="$file_dir/$sanitized_filename-pw.pdf"

  # Remove existing output file to prevent errors.
  rm -f "$output_file"

  # Encrypt the PDF using qpdf
  qpdf --encrypt "$password" "$password" 128 --use-aes=y -- "$file" "$output_file"

  # Check if the encryption was successful
  if [ $? -eq 0 ]; then
    echo "Encrypted: $file -> $output_file"
    # Remove the original file
    rm "$file"
    echo "Removed original file: $file"
    #remove the ./ from the path
    local relative_path=$(echo "$output_file" | sed 's/^\.\///')
    echo "<p><a href=\"https://kastaniegaardensilkeborg.github.io/kastaniegaarden/filer/moeder/$relative_path\" target=\"_blank\">${original_filename%.pdf}</a></p>" >> links.txt #store links in links.txt
    return 0
  else
    echo "Error encrypting: $file"
    return 1
  fi
}

# 1. Sanitize all directory names first
sanitize_directories "$directory"

# 2. Process all PDF files in the sanitized directories
find "$directory" -type f -name "*.pdf" | while read file; do
  process_pdf "$file" "$password"
done

# 3. Print the links from links.txt if it exists.
if [ -f "links.txt" ]; then
  echo "HTML Links:"
  cat links.txt
  rm links.txt
fi

echo "Encryption and directory renaming process completed."