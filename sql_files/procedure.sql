
-- Updates scores and diff_goals in group games

SELECT * FROM Game_teams;

UPDATE Game_teams SET team1_goals = 3 , team2_goals = 2 WHERE game_team_id = 10001

SELECT * FROM Teams;

CREATE TRIGGER update_scores
ON Game_teams
AFTER INSERT
AS
  DECLARE @t_1 INT;
  DECLARE @t_2 INT;
  DECLARE @t1_goal INT;
  DECLARE @t2_goal INT;
  DECLARE @game_id INT;

  SELECT @t_1 = INSERTED.team_id1,
      @t_2 = INSERTED.team_id2,
      @t1_goal = INSERTED.team1_goals,
      @t2_goal = INSERTED.team2_goals
      FROM INSERTED

        IF @t1_goal > @t2_goal
          BEGIN
            UPDATE Teams SET score = score + 3 ,diff_goal = diff_goal + (@t1_goal - @t2_goal) WHERE team_id = @t_1;
            UPDATE Teams SET diff_goal = diff_goal + (@t2_goal - @t1_goal) WHERE team_id = @t_2;
          END
        IF  @t1_goal < @t2_goal
          BEGIN
            UPDATE Teams SET score = score + 3 ,diff_goal = diff_goal + (@t2_goal - @t1_goal) WHERE team_id = @t_2;
            UPDATE Teams SET diff_goal = diff_goal + (@t1_goal - @t2_goal) WHERE team_id = @t_1;
          END
        IF @t1_goal = @t2_goal
          BEGIN
            UPDATE Teams SET score = score + 1 WHERE team_id = @t_1;
            UPDATE Teams SET score = score + 1 WHERE team_id = @t_2;
          END



-- find best player based on number of goals
CREATE PROCEDURE find_best_player AS
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
  PRINT @idBestPlayer
END

-- shows group A teams (name , score , diff_goals)
CREATE PROCEDURE table_group_A AS
BEGIN
  SELECT name,score,diff_goal FROM Teams WHERE Teams.t_group = 'A' ORDER BY Teams.score DESC
END

-- shows group B teams (name , score , diff_goals)
CREATE PROCEDURE table_group_B AS
BEGIN
  SELECT name,score,diff_goal FROM Teams WHERE Teams.t_group = 'B' ORDER BY Teams.score DESC
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

ALTER PROCEDURE qualify_to_semi_final AS
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


  END

EXEC qualify_to_semi_final

  SELECT * FROM Games;
  SELECT * FROM Game_teams;

