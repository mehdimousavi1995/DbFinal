
-- Updates scores and diff_goals in group games
CREATE PROCEDURE updateScores AS
BEGIN
  DECLARE @t_1 INT;
  DECLARE @t_2 INT;
  DECLARE @t1_goal INT;
  DECLARE @t2_goal INT;
  DECLARE @c CURSOR;
  set @c= CURSOR for select Game_teams.team_id1,Game_teams.team_id2,Game_teams.team1_goals,Game_teams.team2_goals from Game_teams,Games WHERE Games.game_id = Game_teams.game_id and Games.game_type = 'group' ;
  open @c
  fetch next from @c into @t_1,@t_2,@t1_goal,@t2_goal;
  while @@fetch_status=0
  BEGIN
    PRINT @t_1;
    PRINT @t_2;
    PRINT @t1_goal;
    PRINT @t2_goal;
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
    fetch next from @c into @t_1,@t_2,@t1_goal,@t2_goal;
  END
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
