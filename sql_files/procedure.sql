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
