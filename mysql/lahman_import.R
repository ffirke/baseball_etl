# Frank Firke
# Creates Lahman DB Tables in MySQL

require(readr)

tables <- c('AllstarFull',
'Appearances',
'AwardsManagers',
'AwardsPlayers',
'AwardsShareManagers',
'AwardsSharePlayers',
'Batting',
'BattingPost',
'CollegePlaying',
'Fielding',
'FieldingOF',
'FieldingOFsplit',
'FieldingPost',
'HallOfFame',
'HomeGames',
'Managers',
'ManagersHalf',
'Parks',
'People',
'Pitching',
'PitchingPost',
'Salaries',
'Schools',
'SeriesPost',
'Teams',
'TeamsFranchises',
'TeamsHalf')

foo<-dbConnect(MySQL(), host="localhost", dbname="lahman",user="root",port=3306)

y=Sys.time()
for (t in tables) {
  print(t)
  if (t != "AwardsSharePlayers"){
  a <- read_csv(paste0("https://github.com/chadwickbureau/baseballdatabank/raw/master/core/",
                       t,
                      ".csv"))
  } else {
    a <- read_csv(paste0("https://github.com/chadwickbureau/baseballdatabank/raw/master/core/",
                         t,
                         ".csv"),col_names = c("awardID","yearID","lgID","playerID",
                                               "pointsWon","pointsMax","votesFirst"),
                  skip=1,
                  col_types = "ciccdid")
  }
  
  dbSendQuery(foo, paste0("drop table if exists ",t,";"))

  dbWriteTable(foo, name=t, value=a %>% as.data.frame())
    
}
Sys.time()-y

dbDisconnect(foo)