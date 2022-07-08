WITH game_rank AS(
		SELECT team,
			COUNT(game_id) AS game_count,
			RANK() OVER(ORDER BY COUNT(game_id) DESC) AS gpr
		FROM fifa
		GROUP BY team)
SELECT
	team AS "Team",
	game_count AS "Games Played",
	ROUND(game_count/(SELECT SUM(game_count) FROM game_rank)*100,2) || '%' AS "Percent of Total Games Played"
FROM 
	game_rank
WHERE 
	gpr <= 10
ORDER BY 
	team;