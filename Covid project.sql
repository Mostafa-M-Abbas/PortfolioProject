select location,date,total_cases , new_cases , total_deaths, population
from CovidDeath$

-- Looking at Total Cases vs Total Deaths

select location , date , total_cases , total_deaths ,(total_deaths / total_cases) * 100 as DeathPercentage
from CovidDeath$
where location like '%state%' and continent is not null
order by 1,2 Desc

-- Looking at Total Cases vs Population
-- shows what percentage of population got covid
select location , date , total_cases , population ,(total_cases / population) * 100 as DeathPercentage
from CovidDeath$

-- where location like '%state%'
order by 1,2 Desc

 -- Looking at Country with Highest Infection Rate Compared to population
select location , population , max(total_cases) as HighestInfectionCount , population ,max((total_cases / population)) * 100 as PercentPopulationInfected
from CovidDeath$
-- where location like '%state%'
group by location , population
order by PercentPopulationInfected Desc

-- Showing Countries With Highest Death Count Per Population
select location , max(total_deaths) as TotalDeathCount
from CovidDeath$
-- where location like '%state%'
group by location , population
order by TotalDeathCount Desc

-- Let's Break Things Down By continent
select location, max(total_deaths) as TotalDeathCount
from CovidDeath$
-- where location like '%state%'
where continent is not Null
group by location
order by TotalDeathCount Desc

-- Showing Continent With The Highest Death Count Per Population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeath$
where continent is not Null
group by location
order by TotalDeathCount Desc


-- Global Numbers
select date , sum(new_cases) as total_cases ,sum(cast(new_deaths as int)) as total_deaths 
,sum(cast(new_deaths as int)) / sum(new_cases) * 100 as DeathPercentage
from CovidDeath$
where continent is not null
Group by date
order by 1,2 Desc

---------------------------------------------------------------------------

--Looking at Total Population vs Vaccinations
-- Use CTE
with popvsvac(continent,location,date,Population,new_vaccinations,RollingPeopleVaccinated)
as (
Select cd.continent , cd.location , cd.date , cd.population ,cv.new_vaccinations
,sum(convert(int,cv.new_vaccinations)) over (partition by cd.location 
order by cd.location ,cd.date) as RollingPeopleVaccinated
from CovidVaccinations$ as cv
Join CovidDeath$ as cd
	ON cv.location = cd.location
	and cv.date = cd.date
where cd.continent is Not Null
--order by cd.location , cd.date
)

select * ,(RollingPeopleVaccinated / Population ) * 100
from popvsvac


-- Temp Table
-- Drop Table #PercnetPopulationVaccinated
create table #PercnetPopulationVaccinated (
continent varchar(255),
location varchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);
Insert Into #PercnetPopulationVaccinated

Select cd.continent , cd.location , cd.date , cd.population ,cv.new_vaccinations
,sum(convert(int,cv.new_vaccinations)) over (partition by cd.location 
order by cd.location ,cd.date) as RollingPeopleVaccinated
from CovidVaccinations$ as cv
Join CovidDeath$ as cd
	ON cv.location = cd.location
	and cv.date = cd.date
where cd.continent is Not Null


-- Creating View
 create view percpopuvacc as
 Select cd.continent , cd.location , cd.date , cd.population ,cv.new_vaccinations
,sum(convert(int,cv.new_vaccinations)) over (partition by cd.location 
order by cd.location ,cd.date) as RollingPeopleVaccinated
from CovidVaccinations$ as cv
Join CovidDeath$ as cd
	ON cv.location = cd.location
	and cv.date = cd.date
where cd.continent is Not Null