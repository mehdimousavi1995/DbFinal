---------------------------------- Stadium ---------------------------------------------------------------------------
INSERT INTO Stadium (staduim_id, staduim_name, location, capacity) VALUES (1,'Signal Iduna Park','Dortmund',81359);
INSERT INTO Stadium (staduim_id, staduim_name, location, capacity) VALUES (2,'Olympic Stadium','Berlin',76233);
INSERT INTO Stadium (staduim_id, staduim_name, location, capacity) VALUES (3,'Allianz Arena','Munich',75464);
INSERT INTO Stadium (staduim_id, staduim_name, location, capacity) VALUES (4,'Olympic Stadium ','Munich',100000);
INSERT INTO Stadium (staduim_id, staduim_name, location, capacity) VALUES (5,'Veltins-Arena','Hamburg',62271);
INSERT INTO Stadium (staduim_id, staduim_name, location, capacity) VALUES (6,'Red Bull Arena','Leipzig',85851);
INSERT INTO Stadium (staduim_id, staduim_name, location, capacity) VALUES (7,'New Tivoli','Aachen',485855);
INSERT INTO Stadium (staduim_id, staduim_name, location, capacity) VALUES (8,'MCV Arena','Duisburg',54323);
-----------------------------------------------------------------------------------------------------------------

------------------------------------ Games -----------------------------------------------------------------
INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1010,1,'2016-8-1 23:15:00','group');
INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1011,2,'2016-8-1 23:15:00','group');
INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1012,3,'2016-8-1 23:15:00','group');
INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1013,4,'2016-8-1 23:15:00','group');

INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1014,5,'2016-8-2 23:15:00','group');
INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1015,6,'2016-8-2 23:15:00','group');
INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1016,7,'2016-8-2 23:15:00','group');
INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1017,8,'2016-8-2 23:15:00','group');

INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1018,2,'2016-8-3 23:15:00','group');
INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1019,4,'2016-8-3 23:15:00','group');
INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1020,6,'2016-8-3 23:15:00','group');
INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1021,8,'2016-8-3 23:15:00','group');

INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1022,2,'2016-8-4 23:15:00','semi_final');
INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1023,2,'2016-8-4 23:15:00','semi_final');

INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1024,2,'2016-8-5 23:15:00','R');

INSERT INTO Games (game_id, staduim_id, game_time, game_type) VALUES (1025,2,'2016-8-6 23:15:00','final');
-------------------------------------------------------------------------------------------------------------------------

--------------------------------------Teams ----------------------------------------------------------
INSERT INTO Teams (team_id, name, t_group, score, diff_goal) VALUES (100,'Germany','A',0,0);
INSERT INTO Teams (team_id, name, t_group, score, diff_goal) VALUES (101,'Brazil','B',0,0);
INSERT INTO Teams (team_id, name, t_group, score, diff_goal) VALUES (102,'Iran','B',0,0);
INSERT INTO Teams (team_id, name, t_group, score, diff_goal) VALUES (103,'Spain','A',0,0);
INSERT INTO Teams (team_id, name, t_group, score, diff_goal) VALUES (104,'South Africa','A',0,0);
INSERT INTO Teams (team_id, name, t_group, score, diff_goal) VALUES (105,'USA','B',0,0);
INSERT INTO Teams (team_id, name, t_group, score, diff_goal) VALUES (106,'Australia','A',0,0);
INSERT INTO Teams (team_id, name, t_group, score, diff_goal) VALUES (107,'Netherlands','B',0,0);
-----------------------------------------------------------------------------------------------------------------

-----------------------------------------Game_teams----------------------------------------------------------------------------
INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10001,1010,100,103,3,2);
INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10002,1011,104,106,2,2);
INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10003,1012,102,101,4,0);
INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10004,1013,107,105,2,0);

INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10005,1014,100,106,3,1);
INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10006,1015,103,104,4,2);
INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10007,1016,107,101,2,2);
INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10008,1017,102,105,3,0);

INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10009,1018,100,104,3,0);
INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10010,1019,103,106,3,0);
INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10011,1020,107,102,2,6);
INSERT INTO Game_teams (game_team_id, game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (10012,1021,101,105,3,2);
-------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------Couch_supervisor------------------------------------------------------------------------
INSERT INTO Couches_supervisor (couches_id, team_id, name, age, couches_type) VALUES (1100,100,'Joachim Löw',45,'head_couche');
INSERT INTO Couches_supervisor (couches_id, team_id, name, age, couches_type) VALUES (1101,101,'Luiz Felipe',55,'head_couche');
INSERT INTO Couches_supervisor (couches_id, team_id, name, age, couches_type) VALUES (1102,102,'Carlos Keyrosh',65,'head_couche');
INSERT INTO Couches_supervisor (couches_id, team_id, name, age, couches_type) VALUES (1103,103,'vicente del bosque',43,'head_couche');
INSERT INTO Couches_supervisor (couches_id, team_id, name, age, couches_type) VALUES (1104,104,'Mamelodi_Sundowns_F.C',56,'head_couche');
INSERT INTO Couches_supervisor (couches_id, team_id, name, age, couches_type) VALUES (1105,105,'Chuck Kyle',59,'head_couche');
INSERT INTO Couches_supervisor (couches_id, team_id, name, age, couches_type) VALUES (1106,106,'Ange Postecoglou',46,'head_couche');
INSERT INTO Couches_supervisor (couches_id, team_id, name, age, couches_type) VALUES (1107,107,'Danny Blind',78,'head_couche');
-------------------------------------------------------------------------------------------------------------------------------------------

