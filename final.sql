
CREATE DATABASE db_final;

USE db_final;

CREATE TABLE Stadium(
  staduim_id INT NOT NULL,
  staduim_name VARCHAR(100),
  location VARCHAR(100),
  capacity INT,
  PRIMARY KEY (staduim_id)
);

CREATE TABLE Games (
  game_id INT NOT NULL,
  staduim_id INT,
  game_time DATETIME,
  game_type VARCHAR(100),
  CONSTRAINT game_type CHECK(game_type = 'group' or 'semi_final' or 'final' or 'R'),
  PRIMARY KEY (game_id),
  FOREIGN KEY (staduim_id) REFERENCES Stadium(staduim_id)
)

CREATE TABLE Referees(
  referee_id INT NOT NULL,
  name VARCHAR(100),
  age INT,
  type VARCHAR(40),
  CONSTRAINT type CHECK (type= 'referee' or'assistant'or'forth_referee'),
  PRIMARY KEY (referee_id)
)

CREATE table Game_Referees(
  game_referee_id INT,
  game_id INT,
  referee_id INT,
  PRIMARY KEY (game_referee_id),
  FOREIGN KEY (game_id) REFERENCES Games(game_id),
  FOREIGN KEY (referee_id) REFERENCES Referees(referee_id)
)

CREATE TABLE Teams(
  team_id INT,
  name VARCHAR(40),
  t_group VARCHAR(40),
  score INT,
  diff_goal INT,
  PRIMARY KEY (team_id)
)

CREATE TABLE Game_teams(
  game_team_id INT,
  game_id INT,
  team_id1 INT,
  team_id2 INT,
  team1_goals INT,
  team2_goals INT,
  PRIMARY KEY (game_team_id),
  FOREIGN KEY (game_id) REFERENCES Games(game_id),
  FOREIGN KEY (team_id1) REFERENCES Teams(team_id),
  FOREIGN KEY (team_id2) REFERENCES Teams(team_id)
)

CREATE TABLE Players(
  player_id INT NOT NULL,
  team_id INT,
  name VARCHAR(100),
  age INT,
  hieght_cm INT,
  n_goals INT,
  post VARCHAR(40),
  PRIMARY KEY (player_id),
  FOREIGN KEY (team_id) REFERENCES Teams(team_id)
)

CREATE TABLE Couches_supervisor(
  couches_id INT,
  team_id INT,
  name VARCHAR(40),
  age INT,
  couches_type VARCHAR(40),
  CONSTRAINT couches_type CHECK(couches_type = 'head_couche' or 'couch'),
  PRIMARY KEY (couches_id),
  FOREIGN KEY (team_id) REFERENCES Teams(team_id)
)

