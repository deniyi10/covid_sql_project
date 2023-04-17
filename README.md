# covid_sql_project

README FILE

This repository contains SQL queries to analyze COVID-19 data. The data consists of two tables: CovidDeaths and CovidVaccinations.
Usage

Clone the repository to your local machine and open the SQL file in your preferred SQL editor.
Data

The CovidDeaths table contains data on the total number of cases and deaths per day in different countries. The CovidVaccinations table contains data on the number of people who have received a COVID-19 vaccine per day in different countries.
Queries

The following queries are included in this repository:
Page 1

    Selects all data from the CovidDeaths and CovidVaccinations tables and orders it by location and date in ascending order.

Page 2

    Selects the location, date, total_cases, new_cases, total_deaths, and population from the CovidDeaths table and orders it by location and date in ascending order.
    Calculates the death percentage per COVID case in different countries and orders the results by location and date in ascending order.
    Calculates the percentage of the population that has COVID-19 in different countries and orders the results by location and date in ascending order.
    Lists the countries with the highest infection rate compared to population and orders the results by percentage of population infected in descending order.
    Lists the countries with the highest death count per population and orders the results by total death count in descending order.

Page 3

    Lists the continents with the highest death count and orders the results by total death count in descending order.
    Calculates the global number of COVID cases and deaths and the percentage of global deaths per new case.

Page 4

    Selects all data from the CovidVaccinations table.

Page 5

    Uses a Common Table Expression (CTE) to calculate the total percentage of vaccinated people per location and orders the results by location in ascending order.

Page 6

    Uses a temporary table to calculate the total percentage of vaccinated people per location and orders the results by location in ascending order.

Conclusion

These SQL queries provide useful insights into COVID-19 data and can be used to further analyze the pandemic's impact on different countries and continents.
