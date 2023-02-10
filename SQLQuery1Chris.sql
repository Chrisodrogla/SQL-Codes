-- GLOBAL NUMBERS TESTING
WITH firstCTE_test as
(SELECT * FROM CovidDeaths  Where NOt total_deaths IS null AND Not total_cases IS null),

secondCTE_test as
(SELECT SUM( CAST(total_deaths as int)) as Tdeaths,
SUM(total_cases) as Tcase
FROM firstCTE_test)


Select Tdeaths, Tcase,(Tdeaths/Tcase) * 100 as World_Death
FROM  secondCTE_test 

-- END TESTINGS


SELECT  continent, location,iso_code, date, population, total_cases, total_deaths,total_cases, (total_deaths/total_cases)*100 as Death_Chances
FROM CovidDeaths
WHERE location like '%Philippines%'
order by date ASC

-- Chances of Death 
-- total deaths/total cases - example 6/20 = 0.3 or 30% of patients who have Covid died on that country with respect to date

SELECT  continent, location,iso_code, date, population, total_cases, total_deaths,total_cases, (total_deaths/total_cases)*100 as Chances_Death
FROM CovidDeaths-- With Nulls


 -- Population and Cases
 -- Cases/Population - 100/8000 = 0125 or 1.25% of the Population has covid 

SELECT  continent, location,iso_code, date, population, total_cases, total_deaths,total_cases, (total_cases/population)*100 as Cases_In_Population
FROM CovidDeaths


--WITH CTE_det as (SELECT Location,MAX(total_deaths) as End_Death
--FROM CovidDeaths
--Group by Location)
--SELECT *
--FROM CTE_det
--ORDER BY End_Death DESC

SELECT location,population, MAX(total_cases) as EndCountcase, (MAX(total_cases)/population)*100 as Cases_In_Population
FROM CovidDeaths

Group by location,population
order by Cases_In_Population DESC

SELECT location,population, MAX(total_deaths) as EndCountdeath, (MAX(total_deaths)/population)*100 as Death_In_Population
From CovidDeaths
Group By location,population
order by Death_In_Population DESC

-- SSSSSSSSSSSSSSSSSS

SELECT location,population, MAX(CAST(total_deaths as Int)) as End_Death
From CovidDeaths
WHERE continent is not null
group by location,population
Order by End_Death DESC

-- CONTINENT HIGHEST DEATH COUNT

SELECT Location ,MAX(CAST(total_deaths as Int)) as End_Death
FROM CovidDeaths
WHERE continent is null
group by Location
ORDER by End_Death DESC

--GLOBAL NUMBERS By Date
 SELECT date ,SUM(CAST(total_deaths as Int)) as Death_Count, SUM(total_cases) as Cases_Count
FROM CovidDeaths
Where total_deaths is not null
Group By date
Order by date ASC 

-- JOINING POPULATION VS VACCINATION per Country


SELECT  de.location, MAX(de.population) as Country_Population , MAX(va.total_vaccinations) as Vaccinated, MAX(de.total_cases) as Infected
 FROM CovidDeaths de
 Join CovidBaksi va
  on de.location = va.location
  where va.total_vaccinations is not null and va.total_vaccinations != 0 and de.continent is not null
  group by de.location,va.total_vaccinations,de.total_cases

-- 

SELECT de.location, MAX(de.population) as Country_Population , MAX(CAST(va.total_vaccinations as float )) as Vaccinated, MAX(de.total_cases) as Infected
 FROM CovidDeaths de
 Join CovidBaksi va
  on de.location = va.location and de.date = va. date 
  where va.total_vaccinations is not null and va.total_vaccinations != 0 and de.continent is not null and de.total_cases is not null
  group by de.location
  order by Vaccinated

  --FIXED COUNTRY POPULATION VS VACCINATED AND INFECTED
  
  WITH CTE_allvac as (SELECT de.location, MAX(de.population) as Country_Population , MAX(CAST(va.total_vaccinations as float )) as Vaccinated, MAX(de.total_cases) as Infected
 FROM CovidDeaths de
 Join CovidBaksi va
  on de.location = va.location and de.date = va. date 
  where va.total_vaccinations is not null and va.total_vaccinations != 0 and de.continent is not null and de.total_cases is not null
  group by de.location) ,
  --order by Vaccinated)

  -- USING CTE_ MAKE PERCENTAGE Country Population/ VAccinated

CTE_vacent as (SELECT *, (Vaccinated/Country_Population)*100 as Vaccinated_Count
  FROM CTE_allvac)
 
  -- USING CTE_ MAKE PERCENTAGE Country Population/Infected)

  SELECT*,(Infected/Country_Population)*100 as Infected_Count
  FROM CTE_vacent

  -- CREATE VIEWS
  CREATE VIEW CHRISTIAN as 
(SELECT * FROM CovidDeaths  Where NOt total_deaths IS null AND Not total_cases IS null)
   