
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


