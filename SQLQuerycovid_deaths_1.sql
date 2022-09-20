SELECT * FROM 
dbo.CovidDeaths

Select location, date, total_deaths, total_cases, new_cases, population 
FROM dbo.CovidDeaths
Order by location, date;

--Looking at total Cases vs Total Deaths 
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















