WITH game_rank AS(
		SELECT team,
			COUNT(game_id) game_count,
			DENSE_RANK() OVER(ORDER BY COUNT(game_id) DESC) AS dr
		FROM fifa
		GROUP BY team)
SELECT
	team,
	game_count,
	ROUND(game_count/(SELECT SUM(game_count) FROM game_rank)*100,2) || '%' AS percent_of_total_games_played
FROM 
	game_rank
WHERE 
	dr <= 10
ORDER BY 
	team;