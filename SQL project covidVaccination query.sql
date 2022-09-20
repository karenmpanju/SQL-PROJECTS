      
SELECT * FROM 
dbo.CovidDeaths cd 
JOIN dbo.CovidVaccinations cv
ON cd.location = cv.location
AND cd.date =cv.date

--Total population vs vaccinations

select cd.location, cd.date, cd.population, cd.continent, cv.new_vaccinations
FROM dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
ON cd.location =cv.location
AND cd.date = cv.date
WHERE cd.continent is not NULL

select cd.location, cd.date, cd.population, cd.continent, cv.new_vaccinations,
SUM(CONVERT(bigint,cv.new_vaccinations)) OVER (PARTITION by cd.location order by cd.location, cd.date) as Rolling_People_vaccinated
FROM dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
ON cd.location =cv.location
AND cd.date = cv.date
WHERE cd.continent is not NULL;

--use CTE

With Popvsvac (location, date, population, continet, new_vaccinations, Rolling_People_Vaccinated)
AS
(select cd.location, cd.date, cd.population, cd.continent, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations AS bigint)) OVER (PARTITION by cd.location order by cd.location, cd.date) as Rolling_People_vaccinated 
FROM dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
ON cd.location =cv.location
AND cd.date = cv.date
WHERE cd.continent is not NULL) 
SELECT *, (Rolling_People_Vaccinated)/Population * 100 FROM Popvsvac as percent_population_vaccinated;
--created popvsvac so that I can use Rolling_people_vaccinated to perform calculations.

With CTE_vaccinations (location, date, population, continent, new_vaccinations, Rolling_population_vaccinated)
AS
(select cd.location, cd.date, cd.population, cd.continent, cv.new_vaccinations,
AVG(CAST(cv.new_vaccinations AS bigint)) OVER (PARTITION by cd.location order by cd.location, cd.date) as Rolling_People_vaccinated_avg 
FROM dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
ON cd.location =cv.location
AND cd.date = cv.date
WHERE cd.continent is not NULL)
SELECT location, population, new_vaccinations FROM CTE_Vaccinations;

 
DROP table if EXISTS perpopulation_vacc
CREATE TABLE perpopulation_vacc
(
cotinent NVARCHAR(255),
location NVARCHAR(255),
date Datetime,
population numeric,
new_vaccinations numeric,
Rolling_People_Vaccinated numeric)
INSERT into Perpopulation_vacc
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CONVERT(bigint,cv.new_vaccinations)) OVER (PARTITION by cd.location order by cd.location, cd.date ) as Rolling_People_vaccinated 
FROM dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
ON cd.location =cv.location
AND cd.date = cv.date
WHERE cd.continent is not NULL          
SELECT *, (Rolling_People_Vaccinated)/Population * 100 FROM Perpopulation_vacc as percent_population_vaccinated;


select cd.location, cd.date, cd.population, cd.continent, cv.new_vaccinations,
MAX(CONVERT(bigint,cv.new_vaccinations)) OVER (PARTITION by cd.location order by cd.location, cd.date) as Rolling_People_vaccinated
FROM dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
ON cd.location =cv.location
AND cd.date = cv.date
WHERE cd.continent is not NULL;


GO
CREATE VIEW  population_vaccinated AS
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CONVERT(bigint,cv.new_vaccinations)) OVER (PARTITION by cd.location order by cd.location, cd.date ) as Rolling_People_vaccinated 
FROM dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
ON cd.location =cv.location
AND cd.date = cv.date
WHERE cd.continent is not NULL;  

GO
CREATE VIEW maxvac_population
AS 
select cd.location, cd.date, cd.population, cd.continent, cv.new_vaccinations,
MAX(CONVERT(bigint,cv.new_vaccinations)) OVER (PARTITION by cd.location order by cd.location, cd.date) as Rolling_People_vaccinated
FROM dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
ON cd.location =cv.location
AND cd.date = cv.date
WHERE cd.continent is not NULL;







