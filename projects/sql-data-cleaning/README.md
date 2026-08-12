# SQL Data Cleaning Project

## Overview

This project focuses on cleaning and preparing housing data using SQL Server. The objective was to improve data quality, standardize values, remove inconsistencies, and create a dataset ready for analysis and reporting.

## Dataset

Nashville Housing Dataset

## Tools Used

- SQL Server
- SQL Queries
- Common Table Expressions (CTEs)
- Window Functions

## Data Cleaning Process

### 1. Standardized Date Format
Converted the SaleDate column into a consistent date format and created a new SaleDateConverted column for improved usability.

### 2. Populated Missing Property Addresses
Filled missing PropertyAddress values by matching records with the same ParcelID.

### 3. Split Property Address
Separated PropertyAddress into:
- PropertySplitAddress
- PropertySplitCity

This transformation improves data organization and simplifies analysis.

### 4. Split Owner Address
Used SQL functions to split OwnerAddress into:
- OwnerSplitAddress
- OwnerSplitCity
- OwnerSplitState

### 5. Standardized Categorical Values
Converted SoldAsVacant values from:
- Y → Yes
- N → No

to improve readability and reporting consistency.

### 6. Removed Duplicate Records
Used a Common Table Expression (CTE) and ROW_NUMBER() function to identify and remove duplicate records while preserving unique entries.

### 7. Removed Unused Columns
Dropped unnecessary columns after the cleaning process to create a streamlined dataset.

## SQL Skills Demonstrated

- Data Cleaning
- Data Transformation
- Data Standardization
- String Functions
- CTEs
- Window Functions
- Data Quality Management

## Project Outcome

The dataset was transformed from raw housing data into a clean, structured dataset ready for reporting, visualization, and further analysis.

## Files

- SQL Data Cleaning.sql

## Project Preview

*Add screenshots here if available.*
