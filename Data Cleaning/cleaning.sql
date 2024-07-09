-- Select all data from the layoffs table
SELECT * 
FROM layoffs;



-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Handle Null Values or Blank Values
-- 4. Remove Any Unnecessary Columns




-- Step 1: Remove Duplicates


-- Create a staging table with the same structure as the layoffs table
CREATE TABLE layoffs_staging
LIKE layoffs;


-- Verify the structure of the staging table
SELECT * 
FROM layoffs_staging;


-- Insert data from the layoffs table into the staging table
INSERT layoffs_staging
SELECT * 
FROM layoffs;



-- Identify duplicate records using a common table expression (CTE)
WITH duplicate_cte AS (
	SELECT *, 
	row_number() OVER (
		PARTITION BY company, location, industry, total_laid_off, 
		percentage_laid_off, `date`, stage, country, funds_raised_millions
	) AS row_num
	FROM layoffs_staging
)
-- Select duplicate records (row_num > 1 indicates duplicates)
SELECT *
FROM duplicate_cte 
WHERE row_num > 1;



-- Check data for a specific company to understand duplication
SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';



-- Create a new staging table to store non-duplicate records
CREATE TABLE `layoffs_staging2` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` DOUBLE DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



-- Verify the structure of the new staging table
SELECT * 
FROM layoffs_staging2;


-- Insert data into the new staging table, assigning row numbers to identify duplicates
INSERT INTO layoffs_staging2
SELECT *, 
row_number() OVER (
	PARTITION BY company, location, industry, total_laid_off, 
	percentage_laid_off, `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;



-- Delete duplicate records from the new staging table
DELETE
FROM layoffs_staging2
WHERE row_num > 1;




-- Disable safe updates mode for the current session to allow the deletion of duplicate records
SET sql_safe_updates = 0;


-- Verify that duplicates have been removed
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;





-- Step 2: Standardize the Data


-- Check for any inconsistencies in company names
SELECT company
FROM layoffs_staging2;


-- Trim whitespace from company names
UPDATE layoffs_staging2
SET company = TRIM(company);


-- Verify industry names to standardize them (example for 'Crypto')
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';



-- Standardize industry names (example for 'Crypto')
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';



-- Verify country names for standardization
SELECT *
FROM layoffs_staging2
WHERE country = 'united states.';



-- Standardize country names
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country = 'United States.';

-- Verify the date format
SELECT `date`
FROM layoffs_staging2;


-- Convert dates to a standardized format
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


-- Modify the date column to ensure it is of type DATE
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- Verify location names for standardization
SELECT *
FROM layoffs_staging2
WHERE country = 'china'
ORDER BY 1;


-- Standardize location names (example for 'Non-U.S.')
UPDATE layoffs_staging2
SET location = 'Other'
WHERE location = 'Non-U.S.';





-- Step 3: Handle Null Values or Blank Values


-- Identify records with null or empty industry values
SELECT *
FROM layoffs_staging2
WHERE industry = '' OR industry IS NULL;


-- Check for specific companies to fill in missing industry information
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';


-- Find corresponding industry values for companies with missing industry information
SELECT t1.company, t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry = '' OR t1.industry IS NULL)	
	AND (t2.industry IS NOT NULL AND t2.industry <> '');


-- Update missing industry values
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry = '' OR t1.industry IS NULL)	
	AND (t2.industry IS NOT NULL AND t2.industry <> '');



-- Identify records with both total_laid_off and percentage_laid_off as null
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;



-- Delete records with both total_laid_off and percentage_laid_off as null
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;





-- Step 4: Remove Any Unnecessary Columns


-- Drop the row_num column used for duplicate removal
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- Verify data after cleaning
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;


-- Select all data from the final cleaned table
SELECT * 
FROM layoffs_staging2;
