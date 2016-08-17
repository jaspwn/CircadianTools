## set working directory by choosing any file in directory

filename <- file.choose()
wd <- setwd(dirname(filename))

## create list of files in working directory

file_list <- list.files()

## function that creates a new list of filenames w/o file extension

rename.file <- function(x) {
  new_name <- tools::file_path_sans_ext(x)
}

## renames files in file_list to remove file extension 

file.rename(file_list, sapply(file_list, rename.file))
