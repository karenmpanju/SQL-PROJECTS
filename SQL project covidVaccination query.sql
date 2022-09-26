SELECT * FROM 
dbo.CovidDeaths

Select location, date, total_deaths, total_cases, new_cases, population 
FROM dbo.CovidDeaths
Order by location, date;

--shows likelihood of dying if infected with covid 

select location, date, total_cases, total_deaths, ((total_deaths/ CAST (total_cases AS float) * 100)) AS DeathPercentage
From dbo.CovidDeaths
order by location

--Total Cases vs population 

--shows what  percentage of the population that got covid 
SELECT location, date, total_cases, population, ((total_cases/population) * 100 ) as case_percentange
FROM dbo.CovidDeaths
order by location

--countries with the highest Infection Rate Compared to the population 
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as Max_pop_percentange 
FROM dbo.CovidDeaths 
Group by location, population 
order by LOCATION

SELECT location, date, AVG(CAST(total_cases AS bigint)) as AVG_CASES
FROM dbo.CovidDeaths 
GROUP BY location,date
Order by date 

--Showing Countires with Highest Death Count per Population 

Select location, population, Max(total_deaths) AS MAXtotal_Death_count, MAX((total_deaths/population)) * 100 as MAXdeath_per_populationpercent
FROM dbo.CovidDeaths
WHERE continent is NOT NULL
Group by location,population
order by MAXtotal_Death_count DESC

Select location, Max(total_deaths) AS MAXtotal_Death_count FROM dbo.CovidDeaths
WHERE continent is NULL
Group by location
order by MAXtotal_Death_count DESC

--Showing continent with the highest death count per population

select continent, MAX(total_deaths) as totaldeath_continent, MAX((total_deaths/population)) * 100 as totaldeathcontinent_perpopulation
FROM dbo.CovidDeaths
WHERE continent is not NULL
GROUP BY continent
order by totaldeath_continent DESC

--Global Numbers
Select date, SUM(new_cases) as sum_newcases, SUM(new_deaths) as sum_newdeaths
FROM dbo.CovidDeaths
Group by date

Select date, SUM(new_cases) as sum_newcases, SUM(new_deaths) as sum_newdeaths, SUM(CAST(new_deaths as float))/ SUM(new_cases) * 100 AS sum_deaths_per_case
FROM dbo.CovidDeaths
WHERE continent is NOT NULL
Group by date

--Covid_Vaccinations Table

SELECT * FROM dbo.CovidVaccinations

SELECT * FROM 
dbo.CovidDeaths cd 
JOIN dbo.CovidVaccinations cv
ON cd.location = cv.location
AND cd.date = cd.date

---loking at total population vs vaccinate

select cd.location, cd.date, cd.population, cv.new_vaccinations
FROM dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
ON cd.location =cv.location
AND cd.date = cv.date

Select continent, Max(total_deaths) as Total_deathCount From dbo.CovidDeaths Where
continent is not null 
Group by continent
Order by Total_deathCount desc 
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







