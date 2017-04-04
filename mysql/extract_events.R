# Script to download/extract Retrosheet data and export as CSV
# Frank Firke
# Borrowing *substantially* from other sources

# Function taken from @bayesball
# https://gist.github.com/bayesball/8892981

parse.retrosheet2.pbp = function(season){
  # ADJUSTED FOR MAC -- function will work for WINDOWS and MAC
  # download, unzip, append retrosheet data
  # assume current directory has a folder download.folder
  # download.folder has two subfolders unzipped and zipped
  # program cwevent.exe is in unzipped folder (for windows)
  
  download.retrosheet <- function(season){
    # get zip file from retrosheet website
    download.file(
      url=paste("http://www.retrosheet.org/events/", season, "eve.zip", sep="")
      , destfile=paste("download.folder", "/zipped/", season, "eve.zip", sep="")
    )
  }
  unzip.retrosheet <- function(season){
    #unzip retrosheet files
    unzip(paste("download.folder", "/zipped/", season, "eve.zip", sep=""), 
          exdir=paste("download.folder", "/unzipped", sep=""))
  }
  create.csv.file=function(year){
    # http://chadwick.sourceforge.net/doc/cwevent.html#cwtools-cwevent
    # shell("cwevent -y 2000 2000TOR.EVA > 2000TOR.bev")
    wd = getwd()
    setwd("download.folder/unzipped")
    if (.Platform$OS.type == "unix"){
      system(paste(paste("cwevent -y", year, "-f 0-96"), 
                   paste(year,"*.EV*",sep=""),
                   paste("> all", year, ".csv", sep="")))} else {
                     shell(paste(paste("cwevent -y", year, "-f 0-96"), 
                                 paste(year,"*.EV*",sep=""),
                                 paste("> all", year, ".csv", sep="")))              
                   }
    setwd(wd)
  }
  create.csv.roster = function(year){
    # creates a csv file of the rosters
    filenames <- list.files(path = "download.folder/unzipped/")
    filenames.roster = 
      subset(filenames, substr(filenames, 4, 11)==paste(year,".ROS",sep=""))
    read.csv2 = function(file)
      read.csv(paste("download.folder/unzipped/", file, sep=""),header=FALSE)
    R = do.call("rbind", lapply(filenames.roster, read.csv2))
    names(R)[1:6] = c("Player.ID", "Last.Name", "First.Name", 
                      "Bats", "Pitches", "Team")
    wd = getwd()
    setwd("download.folder/unzipped")
    write.csv(R, file=paste("roster", year, ".csv", sep=""))
    setwd(wd)
  }
  cleanup = function(){
    # removes retrosheet files not needed
    wd = getwd()
    setwd("download.folder/unzipped")
    if (.Platform$OS.type == "unix"){
      system("rm *.EVN")
      system("rm *.EVA")
      system("rm *.ROS")
      system("rm TEAM*")} else {
        shell("del *.EVN")
        shell("del *.EVA")
        shell("del *.ROS")
        shell("del TEAM*")
      }       
    setwd(wd)
    setwd("download.folder/zipped")
    if (.Platform$OS.type == "unix"){
      system("rm *.zip")} else {
        shell("del *.zip")
      }
    setwd(wd)
  }
  download.retrosheet(season)
  unzip.retrosheet(season)
  create.csv.file(season)
  create.csv.roster(season)
  cleanup()
}

setwd("C:/Users/Frank/Documents/Blog/Retrosheet/R_script")

require(foreach)
require(doParallel)

# Parallelization speeds this up but it's still pretty time consuming

cl <- makeCluster(2)
registerDoParallel(cl)
y=Sys.time()
foreach(i=1930:2016) %dopar% parse.retrosheet2.pbp(i)
Sys.time()-y