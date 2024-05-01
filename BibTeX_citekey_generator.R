# Define the main function
parse_and_update_bib_file <- function(input_file, output_file) {
  # Load file
  file_content <- readLines(input_file)
  
  # Initialize variables
  entries <- list()
  current_entry <- NULL
  
  # Iterate through the lines of the file content
  for (line in file_content) {
    if (startsWith(line, "@")) {
      # If a new entry starts, save the previous entry (if any) and start a new entry
      if (!is.null(current_entry)) {
        entries <- c(entries, list(current_entry))
      }
      # Start a new entry with the line starting with "@"
      current_entry <- list(line)
    } else {
      # Append the current line to the current entry
      current_entry <- c(current_entry, line)
    }
  }
  
  # Add the last entry
  if (!is.null(current_entry)) {
    entries <- c(entries, list(current_entry))
  }
  
  # Function to extract information from lines containing "author = {" and "year = {"
  extract_info <- function(entry) {
    author <- NULL
    year <- NULL
    
    for (line in entry) {
      if (grepl("^\\s*author\\s*=\\s*\\{", line)) {
        author <- gsub("^\\s*author\\s*=\\s*\\{|[[:punct:]].*", "", line)
      } else if (grepl("^\\s*year\\s*=\\s*\\{", line)) {
        year <- gsub("^\\s*year\\s*=\\s*\\{|[[:punct:]].*", "", line)
      }
    }
    
    return(paste(author, year, sep = ""))
  }
  
  # Iterate through entries, extract info, and add it as the first element in each entry
  entries_with_info <- lapply(entries, function(entry) {
    info <- extract_info(entry)
    entry[[1]] <- paste(entry[[1]], info, sep = "")
    return(entry)
  })
  
  # Function to check for duplicates in the cite key and rename them
  check_and_rename_duplicates <- function(entries_with_info) {
    cite_keys <- sapply(entries_with_info, "[[", 1) # Extract the cite keys
    
    # Create a dictionary to store the counts of each cite key
    key_counts <- list()
    
    # Rename duplicate cite keys
    for (i in seq_along(entries_with_info)) {
        key <- entries_with_info[[i]][[1]]
        if (key %in% names(key_counts)) {
            if (key_counts[[key]] == 0) {
                # Rename the first occurrence of the duplicate key to "a"
                new_key <- paste0(key, "a,")
                key_counts[[key]] <- 1
            } else {
                # Increment the count for this key
                key_counts[[key]] <- key_counts[[key]] + 1
                # Append a letter to the key based on the count
                new_key <- paste0(key, letters[key_counts[[key]]], ",")
            }
        } else {
            # Initialize the count for this key
            key_counts[[key]] <- 0
            new_key <- paste0(key, ",")
        }
        # Update the entry with the new key
        entries_with_info[[i]][[1]] <- new_key
    }
    
    return(entries_with_info)
  }
  
  # Check for duplicates and rename them
  entries_with_info <- check_and_rename_duplicates(entries_with_info)
  
  # Function to convert entries list back to text
  entries_to_text <- function(entries) {
    # Initialize empty character vector to store lines
    lines <- character()
    
    # Iterate over each entry
    for (entry in entries) {
      # Append entry header line
      lines <- c(lines, entry[[1]])
      
      # Append entry content lines
      lines <- c(lines, entry[-1])
    }
    lines <- unlist(lines)
    return(lines)
  }
  
  # Convert entries list back to text
  regenerated_text <- entries_to_text(entries_with_info)
  
  # Write the regenerated text to a file
  writeLines(regenerated_text, output_file)
}

# Extract command-line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if the correct number of arguments are provided
if (length(args) != 2) {
  stop("Usage: Rscript script_name.R input_file.bib output_file.bib")
}

# Call the function with input and output filenames as arguments
parse_and_update_bib_file(args[1], args[2])
