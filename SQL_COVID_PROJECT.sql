Select *
From PortfolioProject..covid_deaths$
Where continent is not null
order by 3,4


--Select *
--From PortfolioProject..covid_vaccinations$
--order by 3,4

-- Selecting the Data that we are going to use

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..covid_deaths$
order by 1,2

-- Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject..covid_deaths$
--Where location like '%Ireland%'
order by 1,2

-- Looking at Total Cases vs Population
-- Showing what percentage of population got Covid

Select Location, population, total_cases, (total_cases/population)*100 as percentage_population_infected
From PortfolioProject..covid_deaths$
--Where location like '%Ireland%'
order by 1,2

-- Looking at Countries with highest infection rate compared to Population

Select Location, Population, Max(total_cases) as highest_infection_count, Max((total_cases)/population)*100 as
percentage_population_infected
From PortfolioProject..covid_deaths$
--Where location like '%Ireland%'
Group by Location, Population
order by percentage_population_infected desc


--Showing Countries with highest death count per Population

Select Location, Max(cast(total_deaths as int)) as total_deaths_count
From PortfolioProject..covid_deaths$
--Where location like '%Ireland%'
Where continent is not null
Group by Location
order by total_deaths_count desc

-- Breaking things down by continent



-- Showing the continents with the highest death count per population

Select continent, Max(cast(total_deaths as int)) as total_deaths_count
From PortfolioProject..covid_deaths$
--Where location like '%Ireland%'
Where continent is not null
Group by continent
order by total_deaths_count desc



-- Global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
From PortfolioProject..covid_deaths$
--Where location like '%Ireland%'
where continent is not null
--Group by date
order by 1,2

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as rooling_people_vaccinated
, (rooling_people_vaccinated/population)*100
From PortfolioProject..covid_deaths$ dea
Join PortfolioProject..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3

-- Looking at Total Population vs Vaccinations


--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
--dea.date) as rooling_people_vaccinated
--, (rooling_people_vaccinated/population)*100
--From PortfolioProject..covid_deaths$ dea
--Join PortfolioProject..covid_vaccinations$ vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

-- The previous command is not suppost to work, because we can't use a column that you just create and add something on there
-- For that we use the CTE or Temp Table

--USE CTE

With PopvsVac (continent, Location, Date, Population, new_vaccinations, rooling_people_vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as rooling_people_vaccinated
--, (rooling_people_vaccinated/population)*100
From PortfolioProject..covid_deaths$ dea
Join PortfolioProject..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (rooling_people_vaccinated/Population)*100
From PopvsVac


--Temp table

DROP table if exists #percent_population_vaccinated
Create Table #percent_population_vaccinated
(
Continent nvarchar(255),
Location nvarchar(255), 
Date datetime,
Population numeric,
new_vaccinations numeric,
rooling_people_vaccinated numeric
)


insert into #percent_population_vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint )) OVER (Partition by dea.location Order by dea.location,
dea.date) as rooling_people_vaccinated
--, (rooling_people_vaccinated/population)*100
From PortfolioProject..covid_deaths$ dea
Join PortfolioProject..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (rooling_people_vaccinated/Population)*100
From #percent_population_vaccinated



-- Creating a view to store data visualizations

DROP view if exists percent_population_vaccinated
Create View percent_population_vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as rooling_people_vaccinated
--, (rooling_people_vaccinated/population)*100
From PortfolioProject..covid_deaths$ dea
Join PortfolioProject..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3



Select * 
From percent_population_vaccinated

