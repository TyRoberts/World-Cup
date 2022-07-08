/* Winners and losers are queried seperately because selecting them with a single query causes their counts to return NULL. 
This not only leads to the results being visually unapealling but also causes issues with the running total.*/
WITH winners AS (SELECT
			   	DISTINCT ON(game_id) game_id,
			   	"year",
			   	CASE WHEN team_goals > opponent_goals THEN fifa.team
			   	WHEN team_goals < opponent_goals THEN opponent
			   	END AS team
			  FROM
			  	fifa),
	wins AS (SELECT
		   	fifa.year,
		   	fifa.team,
		   	COUNT(winners.team) AS num
		   FROM
		   	fifa
		   LEFT JOIN
		   	winners
		   	ON
		   	fifa.team = winners.team
		   	AND
		   	fifa.year = winners.year
			AND
			 fifa.game_id = winners.game_id
		   GROUP BY
		   	fifa.year,
		   	fifa.team),
	losers AS (SELECT
			   	DISTINCT ON(game_id) game_id,
			   	"year",
			   	CASE WHEN team_goals < opponent_goals THEN fifa.team
			   	WHEN team_goals > opponent_goals THEN opponent
			   	END AS team
			  FROM
			  	fifa),
	losses AS (SELECT
		   	fifa.year,
		   	fifa.team,
		   	COUNT(losers.team) AS num
		   FROM
		   	fifa
		   LEFT JOIN
		   	losers
		   	ON
		   	fifa.team = losers.team
		   	AND
		   	fifa.year = losers.year
			AND 
			fifa.game_id = losers.game_id
		   GROUP BY
		   	fifa.year,
		   	fifa.team),
	games AS (SELECT 
			  	"year",
			  	team,
			  	COUNT(game_id) AS played
			  FROM 
			  	fifa
			  GROUP BY
			  	"year",
			  	team)
				
SELECT
	wins.year AS "Year",
	SUM(wins.num) OVER(PARTITION BY wins.team ORDER BY wins.year) AS "Wins",
	SUM(losses.num) OVER(PARTITION BY losses.team ORDER BY losses.year) AS "Losses",
	SUM(games.played - (wins.num + losses.num)) OVER(PARTITION BY games.team ORDER BY games.year) AS "Draws",
	SUM(wins.num - losses.num) OVER(PARTITION BY wins.team ORDER BY wins.year) AS "Overall"
FROM 
	wins
INNER JOIN
	losses
	ON
	wins.team = losses.team
	AND 
	wins.year = losses.year
LEFT JOIN
	games
	ON
	losses.team = games.team
	AND
	losses.year = games.year
/* Team Filter
WHERE 
	wins.team = 'Argentina'*/
ORDER BY 
	wins.year;