# Frank Firke
# Reads in previously extracted events data and pushes to MySQL
# Pushing R into MySQL isn't particularly efficient so this takes a long friggin' time


library(RMySQL)
require(readr)
require(dplyr)


foo<-dbConnect(MySQL(), host="localhost", dbname="retrosheet",user="root",port=3306)

# Reads in SQL query to drop / create temp table

setwd("~")
sql <- read_file("Github/baseball_etl/mysql/create_events_table.sql")

dbSendQuery(foo, strsplit(sql,";")[[1]][1])
dbSendQuery(foo, strsplit(sql,";")[[1]][2])

cols = c('game_id','visiting_team','inning','batting_team','outs','balls','strikes','pitch_sequence','vis_score','home_score','batter','batter_hand','res_batter','res_batter_hand','pitcher','pitcher_hand','res_pitcher','res_pitcher_hand','catcher','first_base','second_base','third_base','shortstop','left_field','center_field','right_field','first_runner','second_runner','third_runner','event_text','leadoff_flag','pinchhit_flag','defensive_position','lineup_position','event_type','batter_event_flag','ab_flag','hit_value','sh_flag','sf_flag','outs_on_play','double_play_flag','triple_play_flag','rbi_on_play','wild_pitch_flag','passed_ball_flag','fielded_by','batted_ball_type','bunt_flag','foul_flag','hit_location','num_errors','1st_error_player','1st_error_type','2nd_error_player','2nd_error_type','3rd_error_player','3rd_error_type','batter_dest','runner_on_1st_dest','runner_on_2nd_dest','runner_on_3rd_dest','play_on_batter','play_on_runner_on_1st','play_on_runner_on_2nd','play_on_runner_on_3rd','sb_for_runner_on_1st_flag','sb_for_runner_on_2nd_flag','sb_for_runner_on_3rd_flag','cs_for_runner_on_1st_flag','cs_for_runner_on_2nd_flag','cs_for_runner_on_3rd_flag','po_for_runner_on_1st_flag','po_for_runner_on_2nd_flag','po_for_runner_on_3rd_flag','res_pitcher_for_runner_on_1st','res_pitcher_for_runner_on_2nd','res_pitcher_for_runner_on_3rd','new_game_flag','end_game_flag','pinch_runner_on_1st','pinch_runner_on_2nd','pinch_runner_on_3rd','runner_removed_for_pinch_runner_on_1st','runner_removed_for_pinch_runner_on_2nd','runner_removed_for_pinch_runner_on_3rd','batter_removed_for_pinch_hitter','position_of_batter_removed_for_pinch_hitter','fielder_with_first_putout','fielder_with_second_putout','fielder_with_third_putout','fielder_with_first_assist','fielder_with_second_assist','fielder_with_third_assist','fielder_with_fourth_assist','fielder_with_fifth_assist','event_id')
types = "cciiiiiciicccccccccccccccccccccciiicciccicciccicccciiciciciiiiccccccccccccccccccccccccciiiiiiiiii"

y=Sys.time()

# Try catch to protect the table switch at the end

tryCatch({
for (i in 1930:2016){
  print(i)
  x = Sys.time()
  z = read_csv(paste0("Blog/Retrosheet/R_script/download.folder/unzipped/all",i, ".csv")
             ,col_names=cols,
             col_types = types) %>% as.data.frame()

  dbWriteTable(foo, value = z, name = "events_temp", append = TRUE,row.names=F )
  print(Sys.time()-x)
  print(Sys.time()-y)}
  dbSendQuery(foo,"DROP TABLE IF EXISTS retrosheet.events")
  dbSendQuery(foo,"ALTER TABLE retrosheet.events_temp rename to  events")
}
)