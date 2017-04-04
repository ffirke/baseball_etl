# Frank Firke
# Imports Retrosheet gamelogs via Chadwick and pushes them into MySQL

require(readr)
require(dplyr)

cls = c('date','game_number','day','visitor','visitor_lg','visitor_game_number','home','home_lg','home_game_number','visitor_score','home_score','outs','daynight','completion','forfeit','protest','park','attendance','game_minutes','visitor_linescore','home_linescore','visitor_ab','visitor_h','visitor_2b','visitor_3b','visitor_hr','visitor_rbi','visitor_sh','visitor_sf','visitor_hbp','visitor_bb','visitor_ibb','visitor_so','visitor_sb','visitor_cs','visitor_gidp','visitor_ci','visitor_lob','visitor_pitchers_used','visitor_individual_er','visitor_team_er','visitor_wp','visitor_balks','visitor_putouts','visitor_assists','visitor_errors','visitor_passed_balls','visitor_double_plays','visitor_triple_plays','home_ab','home_h','home_2b','home_3b','home_hr','home_rbi','home_sh','home_sf','home_hbp','home_bb','home_ibb','home_so','home_sb','home_cs','home_gidp','home_ci','home_lob','home_pitchers_used','home_individual_er','home_team_er','home_wp','home_balks','home_putouts','home_assists','home_errors','home_passed_balls','home_double_plays','home_triple_plays','hp_ump_id','hp_ump_name','1b_ump_id','1b_ump_name','2b_ump_id','2b_ump_name','3b_ump_id','3b_ump_name','lf_ump_id','lf_ump_name','rf_ump_id','rf_ump_name','visitor_manager_id','visitor_manager_name','home_manager_id','home_manager_name','winning_pitcher_id','winning_pitcher_name','losing_pitcher_id','losing_pitcher_name','saving_pitcher_id','saving_pitcher_name','gwrbi_batter_id','gwrbi_batter_name','visitor_starting_pitcher_id','visitor_starting_pitcher_name','home_starting_pitcher_id','home_starting_pitcher_name','visitor_batter_1_id','visitor_batter_1_name','visitor_batter_1_pos','visitor_batter_2_id','visitor_batter_2_name','visitor_batter_2_pos','visitor_batter_3_id','visitor_batter_3_name','visitor_batter_3_pos','visitor_batter_4_id','visitor_batter_4_name','visitor_batter_4_pos','visitor_batter_5_id','visitor_batter_5_name','visitor_batter_5_pos','visitor_batter_6_id','visitor_batter_6_name','visitor_batter_6_pos','visitor_batter_7_id','visitor_batter_7_name','visitor_batter_7_pos','visitor_batter_8_id','visitor_batter_8_name','visitor_batter_8_pos','visitor_batter_9_id','visitor_batter_9_name','visitor_batter_9_pos','home_batter_1_id','home_batter_1_name','home_batter_1_pos','home_batter_2_id','home_batter_2_name','home_batter_2_pos','home_batter_3_id','home_batter_3_name','home_batter_3_pos','home_batter_4_id','home_batter_4_name','home_batter_4_pos','home_batter_5_id','home_batter_5_name','home_batter_5_pos','home_batter_6_id','home_batter_6_name','home_batter_6_pos','home_batter_7_id','home_batter_7_name','home_batter_7_pos','home_batter_8_id','home_batter_8_name','home_batter_8_pos','home_batter_9_id','home_batter_9_name','home_batter_9_pos','additional_info','acquisition')

# z = read_csv("https://github.com/chadwickbureau/retrosheet/raw/master/gamelog/GL2016.TXT",
#              col_names=cls) %>% as.data.frame()

library(RMySQL)

foo<-dbConnect(MySQL(), host="localhost", dbname="retrosheet",user="root",port=3306)

# dbWriteTable(foo, value = z, name = "revised_games", append = TRUE,row.names=F )


for (k in 1871:2016) {
  print(Sys.time())
  print(k)
  z = read_csv(paste0("https://github.com/chadwickbureau/retrosheet/raw/master/gamelog/GL",k,".TXT"),
               col_names=cls) %>% as.data.frame()
  dbWriteTable(foo, value = z, name = "revised_games", append = TRUE,row.names=F )
}