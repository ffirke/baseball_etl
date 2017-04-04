-- Taken from
-- https://github.com/alexreisner/baseball_data/blob/master/retrosheet/events.sql

DROP TABLE IF EXISTS retrosheet.events;
CREATE TABLE retrosheet.events (
  game_id VARCHAR(12) NOT NULL,
  visiting_team CHAR(3),                      -- 3-letter code
  inning TINYINT NOT NULL,                    -- 1 or higher
  batting_team BOOLEAN NOT NULL,              -- 0=visitor, 1=home
  outs TINYINT NOT NULL,                      -- 0, 1, or 2
  balls TINYINT DEFAULT NULL,                 -- 0-3
  strikes TINYINT DEFAULT NULL,               -- 0-2
  pitch_sequence VARCHAR(40) DEFAULT NULL,    -- string of letter codes for each pitch
  vis_score TINYINT NOT NULL,                 -- visiting team's runs before play
  home_score TINYINT NOT NULL,
  batter VARCHAR(8) NOT NULL,                 -- batter's player code
  batter_hand ENUM('L','R'),
  res_batter VARCHAR(8) NOT NULL,             -- responsible batter's player code
  res_batter_hand ENUM('L','R'),
  pitcher VARCHAR(8) NOT NULL,                -- pitcher's player code
  pitcher_hand ENUM('L','R'),
  res_pitcher VARCHAR(8) NOT NULL,
  res_pitcher_hand ENUM('L','R'),
  catcher VARCHAR(8) DEFAULT NULL,
  first_base VARCHAR(8) DEFAULT NULL,
  second_base VARCHAR(8) DEFAULT NULL,
  third_base VARCHAR(8) DEFAULT NULL,
  shortstop VARCHAR(8) DEFAULT NULL,
  left_field VARCHAR(8) DEFAULT NULL,
  center_field VARCHAR(8) DEFAULT NULL,
  right_field VARCHAR(8) DEFAULT NULL,
  first_runner VARCHAR(8) DEFAULT NULL,
  second_runner VARCHAR(8) DEFAULT NULL,
  third_runner VARCHAR(8) DEFAULT NULL,
  event_text VARCHAR(50) NOT NULL,            -- Project Scoresheet format (approx) play description
  leadoff_flag ENUM('T','F') NOT NULL,        -- leadoff batter?
  pinchhit_flag ENUM('T','F') NOT NULL,       -- pinch hitter?
  defensive_position TINYINT NOT NULL,        -- 0-9
  lineup_position TINYINT NOT NULL,           -- 1-9
  event_type TINYINT NOT NULL,                -- 0-24 (see Retrosheet documentation format.txt for details)
  batter_event_flag ENUM('T','F') NOT NULL,   -- event terminated batter's appearance?
  ab_flag ENUM('T','F') NOT NULL,             -- batter charged with an AB?
  hit_value TINYINT NOT NULL,                 -- 0-4
  sh_flag ENUM('T','F') NOT NULL,             -- sac hit?
  sf_flag ENUM('T','F') NOT NULL,             -- sac fly?
  outs_on_play TINYINT NOT NULL,              -- 0-3
  double_play_flag ENUM('T','F'),             -- double play occurred?
  triple_play_flag ENUM('T','F'),             -- triple play occurred?
  rbi_on_play TINYINT NOT NULL,               -- 0-4
  wild_pitch_flag ENUM('T','F'),              -- was a wild pitch?
  passed_ball_flag ENUM('T','F'),             -- was a passed ball?
  fielded_by TINYINT UNSIGNED,                -- position of fielding player
  batted_ball_type ENUM('','F','L','P','G'),  -- fly, line, popup, ground
  bunt_flag ENUM('T','F'),
  foul_flag ENUM('T','F'),
  hit_location VARCHAR(5),                    -- Project Scoresheet field location description or 0
  num_errors TINYINT UNSIGNED,                -- 0-3
  1st_error_player TINYINT UNSIGNED,          -- 1-9
  1st_error_type ENUM('T','F','N','D'),       -- T=throwing, F=fielding
  2nd_error_player TINYINT UNSIGNED,          -- 1-9
  2nd_error_type ENUM('T','F','N','D'),       -- T=throwing, F=fielding
  3rd_error_player TINYINT UNSIGNED,          -- 1-9
  3rd_error_type ENUM('T','F','N','D'),       -- T=throwing, F=fielding
  batter_dest TINYINT UNSIGNED,               -- 0-4, 5 if scores and unearned, 6 if scores team unearned
  runner_on_1st_dest TINYINT UNSIGNED,        -- 0-4, 5 if scores and unearned, 6 if scores team unearned
  runner_on_2nd_dest TINYINT UNSIGNED,        -- 0-4, 5 if scores and unearned, 6 if scores team unearned
  runner_on_3rd_dest TINYINT UNSIGNED,        -- 0-4, 5 if scores and unearned, 6 if scores team unearned
  play_on_batter VARCHAR(20),                 -- Project Scoresheet-style play description
  play_on_runner_on_1st VARCHAR(20),          -- Project Scoresheet-style play description
  play_on_runner_on_2nd VARCHAR(20),          -- Project Scoresheet-style play description
  play_on_runner_on_3rd VARCHAR(20),          -- Project Scoresheet-style play description
  sb_for_runner_on_1st_flag ENUM('T','F'),
  sb_for_runner_on_2nd_flag ENUM('T','F'),
  sb_for_runner_on_3rd_flag ENUM('T','F'),
  cs_for_runner_on_1st_flag ENUM('T','F'),
  cs_for_runner_on_2nd_flag ENUM('T','F'),
  cs_for_runner_on_3rd_flag ENUM('T','F'),
  po_for_runner_on_1st_flag ENUM('T','F'),
  po_for_runner_on_2nd_flag ENUM('T','F'),
  po_for_runner_on_3rd_flag ENUM('T','F'),
  res_pitcher_for_runner_on_1st VARCHAR(8) NOT NULL, -- responsible pitcher's player code ("" if none)
  res_pitcher_for_runner_on_2nd VARCHAR(8) NOT NULL, -- responsible pitcher's player code ("" if none)
  res_pitcher_for_runner_on_3rd VARCHAR(8) NOT NULL, -- responsible pitcher's player code ("" if none)
  new_game_flag ENUM('T','F'),
  end_game_flag ENUM('T','F'),
  pinch_runner_on_1st ENUM('T','F'),
  pinch_runner_on_2nd ENUM('T','F'),
  pinch_runner_on_3rd ENUM('T','F'),
  runner_removed_for_pinch_runner_on_1st VARCHAR(8) DEFAULT NULL, -- replaced player code ("" if none)
  runner_removed_for_pinch_runner_on_2nd VARCHAR(8) DEFAULT NULL, -- replaced player code ("" if none)
  runner_removed_for_pinch_runner_on_3rd VARCHAR(8) DEFAULT NULL, -- replaced player code ("" if none)
  batter_removed_for_pinch_hitter VARCHAR(8) DEFAULT NULL,        -- replaced player code ("" if none)
  position_of_batter_removed_for_pinch_hitter TINYINT UNSIGNED,   -- zero if no pinch hitter
  fielder_with_first_putout TINYINT DEFAULT NULL,
  fielder_with_second_putout TINYINT DEFAULT NULL,
  fielder_with_third_putout TINYINT DEFAULT NULL,
  fielder_with_first_assist TINYINT DEFAULT NULL,
  fielder_with_second_assist TINYINT DEFAULT NULL,
  fielder_with_third_assist TINYINT DEFAULT NULL,
  fielder_with_fourth_assist TINYINT DEFAULT NULL,
  fielder_with_fifth_assist TINYINT DEFAULT NULL,
  event_id SMALLINT NOT NULL,
  PRIMARY KEY (game_id,event_id)
) ENGINE=MyISAM;