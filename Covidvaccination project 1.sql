select* 
from [Sql Project 1]..Coviddeath
order by 3,4
--select* 
--from [Sql Project 1]..Covidvaccine
--order by 3,4

select location, date,total_cases,new_cases,total_deaths,population
from [Sql Project 1]..coviddeath
order by 1,2

--total cases vs total deaths
select location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as total_death_percentage
from [Sql Project 1]..coviddeath
where location like '%india%'
order by 1,2	

--total cases vs total population
--shows what percentage of poppulartion got covid
--
select location, date,total_cases,population,(total_cases/population)*100 as total_covidcase_percentage
from [Sql Project 1]..coviddeath
where location like '%india%'
order by 1,2	

--looking at countries with higest Infection Rate compared to Population

select location,population,max (total_cases) as HighginfectionCount,max(total_cases/population)*100 as PercentagepopulationInfected
from [Sql Project 1]..coviddeath
--where location like '%india%'
where continent is not null
group by location ,population
order by PercentagepopulationInfected desc

--showing countries highest death count per population

select location,max (cast(total_deaths as int)) as TotalDeathCount
from [Sql Project 1]..coviddeath
--where location like '%india%
where continent is not null
group by location 
order by TotalDeathCount desc

--lets break down by continent

select continent,max (cast(total_deaths as int)) as TotalDeathCount
from [Sql Project 1]..coviddeath
--where location like '%india%
where continent is not  null
group by continent 
order by TotalDeathCount desc


---GLOBAL NUMBERS

select  SUM(new_cases) as total_cases,SUM(cast (new_deaths as int))as total_deaths,
(sum (cast(new_deaths as int))/sum (new_cases))*100 as total_death_percentage
from [Sql Project 1]..coviddeath
where continent IS NOT NULL
--GROUP BY DATE
order by 1,2	

--Looking at total populaton vs vaccinations


select dea.continent,dea.date,dea.location,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as Rollingpeoplevaccinated
from [Sql Project 1]..Coviddeath dea
join [Sql Project 1]..covidvaccine vac
    On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3

--use ctc

with popvsvac (continent,location,date,population,new_vaccinations,Rollingpeoplevaccinated)
as
(
select dea.continent,dea.date,dea.location,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as Rollingpeoplevaccinated
from [Sql Project 1]..Coviddeath dea
join [Sql Project 1]..covidvaccine vac
    On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select*
From popvsvac

