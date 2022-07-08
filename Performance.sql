SELECT
	team AS "Team",
	RANK() OVER(ORDER BY AVG(team_goals) DESC) AS "Rank",
	ROUND(AVG(team_goals),2) AS "Goals per Game"
FROM
	fifa
WHERE 
	"year" BETWEEN 1930 AND 2014
GROUP BY 
	team
ORDER BY 
	AVG(team_goals) DESC
LIMIT 10;