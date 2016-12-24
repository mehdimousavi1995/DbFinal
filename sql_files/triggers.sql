CREATE TRIGGER update_scores
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
DROP TRIGGER check_stadium
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

  SELECT @tableCount = COUNT(*) FROM Games WHERE Games.game_time = @game_time AND Games.staduim_id = @s_id
  IF @tableCount > 1
  BEGIN
   ROLLBACK;
   RAISERROR ('Two games can not take place in one stadium at a same time', 16,1);
  END


CREATE TRIGGER limitTeams
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


CREATE TRIGGER check_day_3_same_time
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
