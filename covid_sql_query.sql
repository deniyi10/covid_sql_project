--PAGE 1
--SELECT ALL AND CHANGE CHANGE LOCATION AND DATE TO ASC ORDER

SELECT * 
FROM CovidDeaths
ORDER BY 3,4

SELECT * 
FROM CovidVaccinations
ORDER BY 3,4
 

-- PAGE 2
--SELECT DATA I WILL BE USING TO ANALYSE
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2


-- LOOKING AT TOTAL CASES VS TOTAL DEATHS
-- SHOWS DEATH PERCENTAGES PER COVID CASES IN DIFFERENT COUNTRIES
SELECT Location, date, total_cases, total_deaths, (total_deaths*1.0/total_cases)*100 AS DeathPerCases
FROM CovidDeaths
WHERE Location Like '%Kingdom%'
ORDER BY 1,2


-- LOOKING AT THE TOTAL CASES VS POPULATION
-- SHOWS PERCENTAGES OF POPULATION THAT HAS COVIDS
SELECT Location, date, population, total_cases, (total_cases*1.0/ population)*100 AS CovidCases
FROM CovidDeaths
WHERE Location Like '%kingdom%'
ORDER BY 1,2


-- LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases*1.0/ population)*100 AS PercentagePopulationInfected
FROM CovidDeaths
GROUP BY Location, population
ORDER BY PercentagePopulationInfected DESC


-- COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION
SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL --TO REMOVE THE NOT NULL CONTINENTS--
GROUP BY location
ORDER BY TotalDeathCount DESC


-- PAGE 3
-- BREAKING THINGS DOWN BY CONTINENTS
SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL --TO REMOVE THE NOT NULL CONTINENTS--
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBER
SELECT SUM(new_cases) as GlobalCases, SUM(new_deaths) as GlobalDeaths, SUM(new_deaths)*1.0/SUM(NEW_cases)*100 as GlobalDeathsPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL --TO REMOVE THE NOT NULL CONTINENTS--
ORDER BY 1,2


-- PAGE 4
-- BRING BACK COVID VACCINATIONS TABLE
SELECT *
FROM CovidVaccinations


-- JOIN COVIDVACCINATION TABLE TO COVID DEATH TABLE
SELECT *
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.Location = vac.location
    AND dea.date = vac.date


-- LOOKING AT TOTAL POLPULATION VS VACCINATIONS
SELECT DEA.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.Location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL --TO REMOVE THE NOT NULL CONTINENTS--
ORDER BY 2,3


-- LOOKING AT TOTAL VACCINATED POPULATION
SELECT DEA.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.Location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL --TO REMOVE THE NOT NULL CONTINENTS--
ORDER BY 2,3


--PAGE 5
-- USING CTE
-- TO KNOW TOTAL PERCENTAGE OF VACCINATED PEOPLE PER LOCATION

WITH PopVsVac (continent, location, date, population, new_vaccinations,RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.Location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL --TO REMOVE THE NOT NULL CONTINENTS--
)
SELECT *, (RollingPeopleVaccinated*1.0/population)*100 AS VaccinatedPercentagePerLocation
FROM PopVsVac
order by 2


--PAGE 6
-- USING TEMP TABLE
-- TO KNOW TOTAL PERCENTAGE OF VACCINATED PEOPLE PER LOCATION

DROP TABLE IF EXISTS #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated
(continent nvarchar(225),
location nvarchar(225),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

INSERT INTO #PercentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.Location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL --TO REMOVE THE NOT NULL CONTINENTS--

SELECT *, (RollingPeopleVaccinated*1.0/population)*100 AS VaccinatedPercentagePerLocation
FROM #PercentagePopulationVaccinated
order by 2

--PAGE 7
--CREATING VIEW TO STORE DATA VISUALIZATION
DROP TABLE IF EXISTS PercentagePopulationVaccinated
CREATE VIEW PercentagePopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.Location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL --TO REMOVE THE NOT NULL CONTINENTS--
