# Layoff Insights Project

This project focuses on cleaning and analyzing a dataset using SQL. The project is divided into two parts: data cleaning and data analysis.

## Part 1: Data Cleaning Process

### Steps in Data Cleaning Process

1. **Removing Duplicates**
   - Identified and eliminated duplicate entries to ensure data integrity.

2. **Standardizing Data**
   - **Industry Information:**
     - Addressed missing or null values in the industry field.
     - Filled in missing industry information for entries like Airbnb, where the industry (travel) was known but not consistently mentioned.
     - Standardized variations in industry names to maintain consistency.
   - **Country Names:**
     - Corrected inconsistencies and variations in country names.
   - **Dates:**
     - Converted dates from text format to a standardized date format.
   - **Location Names:**
     - Harmonized location names to ensure consistency.

3. **Handling Null or Blank Values**
   - Removed entries where both `total_laid_off` and `percentage_laid_off` were null or empty, as these entries lacked crucial data and were deemed uninformative.

4. **Removing Unnecessary Columns**
   - Dropped extra columns that were previously added solely for the data cleaning process and were no longer needed.

## Part 2: Data Analysis

### SQL Queries for Data Analysis

1. **Basic Data Retrieval:**
   - Retrieve all data from the table.
   - Find the maximum values for `total_laid_off` and `percentage_laid_off`.
   - Select records with specific conditions (e.g., `percentage_laid_off = 1`).

2. **Aggregations and Summaries:**
   - Sum of `total_laid_off` by company, location, country, industry, and stage.
   - Aggregate layoffs by year and month.

3. **Date Analysis:**
   - Find the earliest and latest dates in the dataset.
   - Calculate a rolling sum of layoffs by month.

4. **Ranking and Top Records:**
   - Rank top companies, industries, and countries with the highest layoffs per year.
   - Retrieve the top records based on specific criteria (e.g., top 10 companies with highest layoffs per year).

