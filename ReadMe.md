# Notes
The notes are on the assignment 

## Reading Data
Initial part of the script checks whether the data folder exists and if not
attempts to download the file. I also added a line to check whether the folder
is not empty. I assume that if the folder exists and is not empty then it's
sensible to progress with the data linkage. I would expect that someone 
wouldn't like to keep the data folder empty or with messed up files.

## Data manipulation
The script creates the data frame from all the relevant files. The process
progresses as follows:

<ol>
<li>Vector with all the text files in the folder is created</li>
<li>Elements of the vector are filters to read files to data </li>
<li>Master data frame with all the data is created</li>
<li>Tidy data set is exported</li>
</ol>

## Endnotes
The repo also contains the exported tidy data but everything can be recreated 
by running the file. I also removed redundant data frames when transforming 
the data leaving only master and the tidy data.