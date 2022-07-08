SELECT
	winner AS "Team", 
	COUNT(winner) AS "Times Won", 
	COUNT(winner)*100/(SELECT COUNT("year") FROM wc_results) || '%' AS "Percent of World Cups"
FROM 
	wc_results
GROUP BY 
	winner
ORDER BY 
	"Times Won" DESC;