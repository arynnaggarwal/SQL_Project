-- Select all data from the layoffs_staging2 table
select *
from layoffs_staging2;



-- Find the maximum values for total_laid_off and percentage_laid_off
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;


-- Select all records where the percentage_laid_off is equal to 1
select * 
from layoffs_staging2
where percentage_laid_off=1;


-- Select all records where the percentage_laid_off is equal to 1 and order by funds_raised_millions in descending order
select * 
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised_millions desc;


-- Sum the total_laid_off for each company and order by the sum in descending order
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by sum(total_laid_off) desc;



-- Sum the total_laid_off for each location and order by the sum in descending order
select location, sum(total_laid_off)
from layoffs_staging2
group by location
order by sum(total_laid_off) desc;


-- Sum the total_laid_off for each country and order by the sum in descending order
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by sum(total_laid_off) desc;



-- Sum the total_laid_off for each year and order by the sum in descending order
select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by sum(total_laid_off) desc;


-- Find the earliest and latest dates in the data
select min(`date`), max(`date`)
from layoffs_staging2;



-- Sum the total_laid_off for each industry and order by the sum in descending order
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by sum(total_laid_off) desc;



-- Sum the total_laid_off for each stage and order by the sum in descending order
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by sum(total_laid_off) desc;



-- Sum the total_laid_off for each month and order by the sum in descending order
select month(`date`), sum(total_laid_off)
from layoffs_staging2
group by month(`date`)
order by sum(total_laid_off) desc;



-- Sum the total_laid_off for each month (formatted as YYYY-MM) and order by the month
select substring(`date`, 1, 7) as `Month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `Month`
order by 1;



-- Calculate a rolling sum of total_laid_off for each month
with rolling_total as
(
	select substring(`date`, 1, 7) as `Month`, sum(total_laid_off) as total_laid
	from layoffs_staging2
	where substring(`date`, 1, 7) is not null
	group by `Month`
	order by 1
)
select `Month`, total_laid, sum(total_laid) over(order by `month`) as rolling_sum
from rolling_total;



-- Sum the total_laid_off for each company and order by the sum in descending order (duplicate query, consider removing)
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by sum(total_laid_off) desc;



-- Sum the total_laid_off for each company per year and order by the total_laid_off in descending order, limited to top 10 results
select company, year(`date`) as year, sum(total_laid_off) as total_laid
from layoffs_staging2
group by company, year(`date`)
order by 3 desc
limit 10;



-- Rank the top 5 companies with the highest total_laid_off per year
with company_year as
(
	select company, year(`date`) as year, sum(total_laid_off) as total_laid
	from layoffs_staging2
	group by company, year(`date`)
), company_year_rank as
(
select *, dense_rank() over(partition by year order by total_laid desc) as Ranking
from company_year
where year is not null
)
select *
from company_year_rank
where ranking <= 5;



-- Rank the top 5 industries with the highest total_laid_off per year
with industry_year as
(
	select industry, year(`date`) as year, sum(total_laid_off) as total_laid
	from layoffs_staging2
	group by industry, year(`date`)
), industry_year_rank as
(
select *, dense_rank() over(partition by year order by total_laid desc) as Ranking
from industry_year
where year is not null
)
select *
from industry_year_rank
where ranking <= 5;



-- Rank the top 5 countries with the highest total_laid_off per year
with country_year as
(
	select country, year(`date`) as year, sum(total_laid_off) as total_laid
	from layoffs_staging2
	group by country, year(`date`)
), country_year_rank as
(
select *, dense_rank() over(partition by year order by total_laid desc) as Ranking
from country_year
where year is not null
)
select *
from country_year_rank
where ranking <= 5;
