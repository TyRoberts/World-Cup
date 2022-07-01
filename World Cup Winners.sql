SELECT
	CASE WHEN winner IS NULL THEN 'All' 
	ELSE winner END AS team, 
	COUNT(winner) AS times_won, 
	COUNT(winner)*100/(SELECT COUNT("year") FROM wc_results) || '%' AS percent_of_wc
FROM wc_results
GROUP BY ROLLUP(winner)
ORDER BY times_won DESC;