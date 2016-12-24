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
CREATE PROCEDURE table_group_A AS
BEGIN
  SELECT name,score,diff_goal FROM Teams WHERE Teams.t_group = 'A' ORDER BY Teams.score DESC , Teams.diff_goal DESC
END

-- shows group B teams (name , score , diff_goals)
CREATE PROCEDURE table_group_B AS
BEGIN
  SELECT name,score,diff_goal FROM Teams WHERE Teams.t_group = 'B' ORDER BY Teams.score DESC , Teams.diff_goal DESC
END

-- if number of players exceed from 22 all operations rolling back
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




