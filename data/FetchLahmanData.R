# http://stackoverflow.com/questions/3053833/using-r-to-download-zipped-data-file-extract-and-import-data

URL <- "http://seanlahman.com/files/database/lahman-csv_2014-02-14.zip"

temp <- tempfile()
download.file(URL, temp)

# Have a look at the files to see what we're about to extract
whatFiles <- unzip(temp, list = TRUE)
View(whatFiles)

unzip(temp, exdir = "./data/", junkpaths = TRUE)
unlink(temp)
