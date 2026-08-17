--Data Analyst Portfolio Project
-- show the data 
SELECT*
FROM covidDeth
ORDER BY 3,4
SELECT *
FROM covidVaccinaction
ORDER BY 3,4

-- select data that we are using from tables 
select location,date,total_cases,new_cases,total_deaths,population
FROM covidDeth
ORDER BY 1,2

--Looking at total cases vs total deaths 
select location,date,total_cases,total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as Death_Percentage
FROM covidDeth
where location like '%Egypt%' -- Can change it for any country you want 
ORDER BY 1,2

--Looking at total cases vs Population 
-- show what Percentage of Population got COVID
select location,date,population,total_cases, (total_cases/population)*100 as Prcentage_of_Population_infected
FROM covidDeth
--where location like '%Egypt%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to Population 
select location,population,MAX(total_cases) as Highest_Infection , MAX((total_cases/population))*100 as HighestPrcentage_of_Population_infected 
FROM covidDeth
GROUP BY location,population
ORDER BY HighestPrcentage_of_Population_infected DESC

--showing the countrey with Highest Deth count per Population 
select location, MAX(cast(total_deaths as int)) as Total_Death_count 
FROM covidDeth
Where continent is not null  --some of data are don't have the continent
GROUP BY location
ORDER BY Total_death_count DESC

--Let's show it up by continent where is NULL
select location, MAX(cast(total_deaths as int)) as Total_Death_count 
FROM covidDeth
Where continent is null  
GROUP BY location
ORDER BY Total_death_count DESC

-- Showing continents with Highest death count per Population
select continent,MAX(cast(total_deaths as int ))as Total_Death_count
from covidDeth
where continent is not null
GROUP BY continent
ORDER BY Total_Death_count DESC

-- SUM of new cases in the world
select location,SUM(new_cases) as SUM_OF_NewCases
from covidDeth
where continent is not null
GROUP BY location
ORDER BY SUM_OF_NewCases DESC

-- SUM of new Death in world 
select location,SUM(new_deaths) as SUM_OF_NewDeaths
from covidDeth
where continent is null
GROUP BY location
ORDER BY SUM_OF_NewDeaths DESC

-- Globle number and Percentage of total Death for recored new cases
Select date, SUM(new_cases) as total_cases, SUM( cast (new_deaths as int ))as Total_Death,
SUM( cast (new_deaths as int))/SUM(new_cases)*100 as Deth_percntage 
from covidDeth
where continent is not null and new_cases<>0
GROUP BY date
ORDER BY 1,2

--Showing the Avg ,Min of total death in evey country
select location, AVG(convert(int,total_deaths)) as AVG_of_Deaths,
MIN(convert (int,total_deaths)) as  Minmum_of_Deaths
from covidDeth
where continent is not null 
GROUP BY location
ORDER BY AVG_of_Deaths DESC

-- Showing the Fully Pepole vaccinated VS People vaccinated
Select date, location,people_vaccinated,people_fully_vaccinated
from covidVaccinaction
where continent is not null and people_vaccinated is not null
ORDER BY 2,1

--Looking for the View the first vaccination history, location and date
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from covidDeth dea
Join covidVaccinaction vac
on  dea.location= vac.location
and dea.date=vac.date
Where dea.continent is not null and vac.new_vaccinations is not null
ORDER BY 3,2

-- Looking at total Population vs vaccination 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as float )) OVER 
(partition by dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinations
from covidDeth dea
Join covidVaccinaction vac
on  dea.location= vac.location
and dea.date=vac.date
Where dea.continent is not null 
ORDER BY 2,3

--  Calculate the percentage of vaccination Use CTE 
with Popu_vs_Vac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinations)
as
(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as float )) OVER 
(partition by dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinations
from covidDeth dea
Join covidVaccinaction vac
on  dea.location= vac.location
and dea.date=vac.date
Where dea.continent is not null 
)
--Calculate the percentage of vaccination 
Select *, (RollingPeopleVaccinations/population)*100 as Percentage_of_Vaccination
from Popu_vs_Vac

-- Calculate the percentage of vaccination Use Temp Table 
DROP Table if exists #PercentagePopulationVaccination
Create Table #PercentagePopulationVaccination
(
continent nvarchar(225),
location nvarchar(225),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinations numeric
)
insert into #PercentagePopulationVaccination
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as float )) OVER 
(partition by dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinations
from covidDeth dea
Join covidVaccinaction vac
on  dea.location= vac.location
and dea.date=vac.date
Select *, (RollingPeopleVaccinations/population)*100 as Percentage_of_Vaccination
from #PercentagePopulationVaccination

-- creating View t store data for later visualization
Create view View_PercentagePopulationVaccination as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as float )) OVER 
(partition by dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinations
from covidDeth dea
Join covidVaccinaction vac
on  dea.location= vac.location
and dea.date=vac.date
Where dea.continent is not null 

-- showing the Data in View
select *
from View_PercentagePopulationVaccination
