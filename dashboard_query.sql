Select*
From PortfolioProject..owid_covid_data

-- 1. Percentage of deaths from covid-19 (world)

Select SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths,
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as death_percentage
From PortfolioProject..owid_covid_data
-- Where location like '%Ireland%'
where continent is not null
-- Group by date
order by 1,2

-- 2. Percentage of deaths from covid-19 (Continent)

Select location, SUM(CAST(new_deaths as int)) as total_deaths_count
From PortfolioProject..owid_covid_data
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by total_deaths_count desc

-- 3. Percent of population infected from Covid-19 (Countries)

Select location, population, MAX(total_cases) as highest_infection_count,
MAX((total_cases/population))*100 as percent_population_infected
From PortfolioProject..owid_covid_data
Group by location, population
order by percent_population_infected desc

-- 4. Percent of population infected from Covid-19 (Countries and date)

Select location, population, date, MAX(total_cases) as highest_infection_count,
MAX((total_cases/population))*100 as percent_population_infected
From PortfolioProject..owid_covid_data
Group by location, population, date
order by percent_population_infected desc