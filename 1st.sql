use covid_19;
-- show the covid deaths table 
select *
from covid_deaths 
where continent is not null
order by 1,2;
-- show the covid vaccinations table
select *
from covid_vaccinations
where continent is not null limit 50;
-- select data that going to use 
select location,date,population,total_cases,new_cases,total_deaths
from covid_deaths
where continent is not null
order by 1,2;

-- Looking at the percentage of deaths in Bangladesh 
select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS death_percentage
from covid_deaths 
where location ='Bangladesh'
order by 1,2;
-- Looking the number of total cases vs population
select location,date,population,total_cases, (total_cases/population)*100 AS PercentagePopulationInfected
from covid_deaths 
where location ='Bangladesh'
order by 1,2;
-- Looking at countries with highest infection rate compare to population
select location,population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 AS PercentagePopulationInfected
from covid_deaths 
-- where location ='Bangladesh'
group by location,population 
order by PercentagePopulationInfected DESC;
-- Looking at countries with highest death rate 
select location, max(total_deaths) as TotalDeathCount
from covid_deaths
where continent is not null
group by location
order by TotalDeathCount desc;
-- Looking at continent with highest death rate 
select continent, max(total_deaths) as TotalDeathCount
from covid_deaths
where continent is not null
group by continent
order by TotalDeathCount desc;
-- Looking global death percentage 
select sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,sum(new_deaths)/sum(new_cases) as DeathPercentage
from covid_deaths
where continent is not null
-- group by date
order by 1,2;
-- Looking at total population vs vaccination accross the world 
select de.continent,de.location,de.date,de.population,va.new_vaccinations,
sum(va.new_vaccinations) over (partition by de.location) as RollingPeopleVaccinated
from covid_deaths de
join covid_vaccinations va
on de.location = va.location
and de.date = va.date
where de.continent is not null
order by 2,3
;
-- Looking the percentage of people got vaccinated in bangladesh. 
with PopVsVac ( continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as 
(
select de.continent,de.location,de.date,de.population,va.new_vaccinations,
sum(va.new_vaccinations) over (partition by de.location) as RollingPeopleVaccinated
from covid_deaths de
join covid_vaccinations va
on de.location = va.location
and de.date = va.date
where de.continent is not null
order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 
from PopVsVac
where location like '%bang%';





-- Temp Table 

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #percentPopulationVaccinated
select de.continent,de.location,de.date,de.population,va.new_vaccinations,
sum(va.new_vaccinations) over (partition by de.location) as RollingPeopleVaccinated
from covid_deaths de
join covid_vaccinations va
on de.location = va.location
and de.date = va.date
where de.continent is not null
order by 2,3
select *, (RollingPeopleVaccinated/population)*100 
from #percentPopulationVaccinated;




-- Creating View to store data for later visualizations

CREATE view percentPopulationVaccinated as 
select de.continent,de.location,de.date,de.population,va.new_vaccinations,
sum(va.new_vaccinations) over (partition by de.location) as RollingPeopleVaccinated
from covid_deaths de
join covid_vaccinations va
on de.location = va.location
and de.date = va.date
where de.continent is not null
order by 2,3

