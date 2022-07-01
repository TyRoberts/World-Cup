SELECT
	tea,
	ROUND(AVG(team_goals),2) AS goals_per_game
FROM
	fifa
WHERE 
	"year" BETWEEN 1936 AND 2014
GROUP BY 
	team
ORDER BY 
	AVG(team_goals) DESC
LIMIT 10;