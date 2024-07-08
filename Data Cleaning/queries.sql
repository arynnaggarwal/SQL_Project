SELECT * 
FROM layoffs;


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns



-- Remove Duplicates

CREATE TABLE layoffs_staging
LIKE layoffs;


SELECT * 
FROM layoffs_staging;


INSERT layoffs_staging
SELECT * 
FROM layoffs;


with duplicate_cte as
(
	SELECT *, 
	row_number() over(
		partition by company, location, 
		industry, total_laid_off, percentage_laid_off, `date`, stage, country, 
		funds_raised_millions) as row_num	
	from layoffs_staging
)


select *
from duplicate_cte 
where row_num > 1;


SELECT * 
FROM layoffs_staging
where company = 'Casper';


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` double DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * 
FROM layoffs_staging2;


insert into layoffs_staging2
SELECT *, 
row_number() over(
	partition by company, location, 
	industry, total_laid_off, percentage_laid_off, `date`, stage, country, 
	funds_raised_millions) as row_num
from layoffs_staging;



delete
from layoffs_staging2
where row_num > 1;

SET sql_safe_updates = 0;


select *
from layoffs_staging2
where row_num > 1;





-- Standardize the Data


select compant
from layoffs_staging2;


update layoffs_staging2
set company = trim(company);


select *
from layoffs_staging2
where industry like 'Crypto%';



update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';



select *
from layoffs_staging2
where country = 'united states.';


update layoffs_staging2
set country = 'United States'
where country = 'United States.';


select `date`
from layoffs_staging2;


update layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


alter table layoffs_staging2
modify column `date` date;


select *
from layoffs_staging2
where country='china'
order by 1;


update layoffs_staging2
set location = 'Other'
where location = 'Non-U.S.';



-- Null Values or Blank Values



select *
from layoffs_staging2
where industry='' or industry is null;


select *
from layoffs_staging2
where company like 'Bally%';


select t1.company, t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry = '' or t1.industry is null)	
	and (t2.industry is not null and t2.industry <> '');


update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry = '' or t1.industry is null)	
	and (t2.industry is not null and t2.industry <> '');


select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;



delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


-- Remove Any Columns


alter table layoffs_staging2
drop column row_num;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by sum(total_laid_off) desc;



select * 
from layoffs_staging2;









