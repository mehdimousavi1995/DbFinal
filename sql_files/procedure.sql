

ALTER TRIGGER update_scores
ON Game_teams
AFTER INSERT
AS
  DECLARE @t_1 INT;
  DECLARE @t_2 INT;
  DECLARE @t1_goal INT;
  DECLARE @t2_goal INT;
  DECLARE @game_id INT;
  DECLARE @game_type VARCHAR(50);

  SELECT  @t_1 = INSERTED.team_id1,
          @t_2 = INSERTED.team_id2,
          @t1_goal = INSERTED.team1_goals,
          @t2_goal = INSERTED.team2_goals,
          @game_id = INSERTED.game_id
          FROM INSERTED

        SELECT @game_type = Games.game_type FROM Games WHERE Games.game_id = @game_id

        IF @t1_goal > @t2_goal AND @game_type = 'group'
          BEGIN
            UPDATE Teams SET score = score + 3 ,diff_goal = diff_goal + (@t1_goal - @t2_goal) WHERE team_id = @t_1;
            UPDATE Teams SET diff_goal = diff_goal + (@t2_goal - @t1_goal) WHERE team_id = @t_2;
          END
        IF  @t1_goal < @t2_goal AND @game_type = 'group'
          BEGIN
            UPDATE Teams SET score = score + 3 ,diff_goal = diff_goal + (@t2_goal - @t1_goal) WHERE team_id = @t_2;
            UPDATE Teams SET diff_goal = diff_goal + (@t1_goal - @t2_goal) WHERE team_id = @t_1;
          END
        IF @t1_goal = @t2_goal AND @game_type = 'group'
          BEGIN
            UPDATE Teams SET score = score + 1 WHERE team_id = @t_1;
            UPDATE Teams SET score = score + 1 WHERE team_id = @t_2;
          END


-- find best player based on number of goals


CREATE FUNCTION find_best_player()
  RETURNS INT AS
BEGIN
  DECLARE @id INT;
  DECLARE @goals INT;
  DECLARE @idBestPlayer INT;
  DECLARE @goalsBestPlayer INT;
  SET @idBestPlayer = 0
  SET @goalsBestPlayer = 0
  DECLARE @c CURSOR;
  set @c= CURSOR for select Players.player_id , Players.n_goals FROM Players;
  OPEN @c
  fetch next from @c into @id,@goals;
  while @@fetch_status = 0
  BEGIN
    IF @goals > @goalsBestPlayer
      BEGIN
       SET @goalsBestPlayer = @goals
       SET @idBestPlayer = @id
      END
    fetch next from @c into @id,@goals;
  END
  RETURN @idBestPlayer
END

-- shows group A teams (name , score , diff_goals)
ALTER PROCEDURE table_group_A AS
BEGIN
  SELECT name,score,diff_goal FROM Teams WHERE Teams.t_group = 'A' ORDER BY Teams.score DESC , Teams.diff_goal DESC
END

-- shows group B teams (name , score , diff_goals)
ALTER PROCEDURE table_group_B AS
BEGIN
  SELECT name,score,diff_goal FROM Teams WHERE Teams.t_group = 'B' ORDER BY Teams.score DESC , Teams.diff_goal DESC
END

-- if number of players exceed from 22 all operations rolling back
CREATE TRIGGER LimitPlayers
ON Players
AFTER INSERT
AS
  DECLARE @tableCount INT;
  DECLARE @inserted_game_id INT;
  SELECT @inserted_game_id = INSERTED.team_id FROM INSERTED
  SELECT @tableCount = COUNT(*)
  FROM Players WHERE team_id = @inserted_game_id
  IF @tableCount > 22
  BEGIN
   ROLLBACK
  END


CREATE PROCEDURE qualify_to_semi_final AS
  BEGIN
    DECLARE @a CURSOR;
    DECLARE @b CURSOR;
    DECLARE @t_1A INT;
    DECLARE @t_2A INT;
    DECLARE @t_1B INT;
    DECLARE @t_2B  INT;
    set @a= CURSOR for  SELECT Teams.team_id FROM Teams WHERE Teams.t_group = 'A' ORDER BY Teams.score DESC ,Teams.diff_goal DESC
    set @b= CURSOR for  SELECT Teams.team_id FROM Teams WHERE Teams.t_group = 'B' ORDER BY Teams.score DESC ,Teams.diff_goal DESC
    OPEN @a
    OPEN @b
    fetch next from @a into @t_1A;
    fetch next from @a into @t_2A;
    fetch next from @b into @t_1B;
    fetch next from @b into @t_2B;
    INSERT INTO Game_teams (game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (1022,@t_1A,@t_2B,0,0);
    INSERT INTO Game_teams (game_id, team_id1, team_id2, team1_goals, team2_goals) VALUES (1023,@t_2A,@t_1B,0,0);
  END

  SELECT * FROM Games;

ALTER TRIGGER check_stadium
  ON Games AFTER INSERT
  AS
  DECLARE @game_time DATETIME;
  DECLARE @s_id INT;
  DECLARE @tableCount INT;
  SELECT @game_time = INSERTED.game_time,
         @s_id = INSERTED.staduim_id
         FROM INSERTED

  SELECT @tableCount = COUNT(*)
  FROM Games WHERE Games.game_time = @game_time AND Games.staduim_id = staduim_id
  IF @tableCount > 0
  BEGIN
   ROLLBACK;
   RAISERROR ('Two games can not take place in one stadium at a same time', 16,1);
  END
SELECT * FROM Teams;

ALTER TRIGGER limitTeams
  on Teams AFTER INSERT
  AS
  DECLARE @count_A INT;
  DECLARE @count_B INT;
  SELECT @count_A = count(*) FROM Teams WHERE Teams.t_group = 'A'
  SELECT @count_B = count(*) FROM Teams WHERE Teams.t_group = 'B'
  IF @count_B > 4 OR @count_A > 4
      BEGIN
        RAISERROR ('this tournament can not have more than 4 teams in each group ... ',16,1);
        ROLLBACK ;
      END


ALTER TRIGGER check_day_3_same_time
  ON Games AFTER INSERT
  AS
  DECLARE @time DATETIME;
  DECLARE @tableCount INT;
  DECLARE @tableCount_day3 INT;
  SELECT @tableCount = count(*) FROM INSERTED
      SELECT @time = t1.game_time FROM (select top 4 * FROM (SELECT * from Games except (SELECT top 8 * FROM Games)) as t) AS t1;
      SELECT @tableCount_day3 = count(*) FROM (select top 4 * FROM (SELECT * from Games except (SELECT top 8 * FROM Games)) as t) AS t1 WHERE t1.game_time != @time;
     IF @tableCount_day3 > 0
       BEGIN
         ROLLBACK;
         RAISERROR ('All games in third day must be in a same time', 16,1);
       END


-- ALTER TRIGGER check_final_after_R
--   ON Games AFTER INSERT
--   AS
--   DECLARE @time_final DATETIME;
--   DECLARE @time_R DATETIME;
--
--   SELECT @time_final = Games.game_time FROM Games WHERE Games.game_time = 'final'
--   SELECT @time_R = Games.game_time FROM Games WHERE Games.game_time = 'R'
--   if DATEDIFF(dd,cast(as date) = ''@time_final, cast(as DATE) = @time_R) >= 0
--       BEGIN
--         PRINT 'fuck'
--       END
































--
-- CREATE TRIGGER check_day_3_same_time
--   ON Games AFTER INSERT
--   AS
--   DECLARE @game_time DATETIME;
--   DECLARE @day3 DATETIME;
--   DECLARE @game_id INT;
--   DECLARE @tableCount INT;
--   DECLARE @c CURSOR ;
--
--   SELECT @tableCount = count(*) FROM INSERTED
--   IF @tableCount > 8
--       BEGIN
--         set @c= CURSOR for  SELECT Games.game_id , Games.game_time FROM Teams WHERE Games.game_type = 'group'
--         DECLARE @count INT;
--         SET @count = 8;
--         OPEN @c
--           while  @count != 0
--           BEGIN
--             fetch next from @c into @game_id, @game_time;
--             SET @count = @count - 1;
--           END
--       END
--   fetch next from @c into @game_id, @game_time;
--   SET @day3 = @game_time
--   WHILE @@fetch_status = 0
--     BEGIN
--       IF @day3 != @game_time
--         BEGIN
--            ROLLBACK;
--            RAISERROR ('All games in third day must be in a same time', 16,1);
--         END
--       fetch next from @c into @game_id, @game_time;
--     END
