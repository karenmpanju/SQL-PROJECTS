


SELECT * FROM 
dbo.CovidDeaths cd 
JOIN dbo.CovidVaccinations cv
ON cd.location = cv.location
AND cd.date =cv.date

select cd.location, cd.date, cd.population, cv.new_vaccinations
FROM dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
ON cd.location =cv.location
AND cd.date = cv.date
