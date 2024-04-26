--Data Analyst Portfolio Project
-- showing the data working on it 
Select *
From Heart_health
ORDER BY 1,2

Select *
From patient_information
ORDER BY 1,2

--This line in order to clear an empty column in the table 
ALTER TABLE patient_information
DROP COLUMN F8

-- Showing the MAX,MIN,AVG of Age,Height,Weight  
Select ID,Name,MAX(Age) as MAX_of_Age,MIN([Height(cm)]) as MIN_of_Height,
AVG([Weight(kg)]) as AVG_of_Weight
from patient_information
GROUP BY ID,Name
ORDER BY 3 DESC

--Looking from MAX,	MIN Blood pressure 
Select Name,Age,Gender,[Blood Pressure(mmHg)],
MAX([Blood Pressure(mmHg)]) OVER (partition by Name) AS MAX_Blood_Pressure,
MIN([Blood Pressure(mmHg)]) OVER (partition by Name) AS MIN_Blood_Pressure
from Heart_health
ORDER BY Name

--Looking for MAX,MIN of Cholesterol
Select Name,Age,Gender,[Cholesterol(mg/dL)],
MAX([Cholesterol(mg/dL)]) OVER (partition by Name) AS MAX_Cholesterol,
MIN([Cholesterol(mg/dL)]) OVER (partition by Name) AS MIN_Cholesterol
from Heart_health
ORDER BY Name

-- Showing the data for the maximum Exercise 
Select ID,Name,Age,Gender,Max([Exercise(hours/week)]) AS MAX_Exercise
FROM Heart_health
GROUP BY ID,Name,Age,Gender
ORDER BY MAX_Exercise DESC

--Count the number of women and men
Select COUNT(Gender) as Number_of_Female
from Heart_health
where Gender ='Female'
Select COUNT(Gender) as Number_of_men
from Heart_health
where Gender ='Male'

--Showing smoker vs Heart Attack 
select Name,Smoker,[Heart Attack]
from Heart_health
where [Heart Attack]=1

-- showing The ratio of smokers 
select Name,COUNT(smoker) as Number_of_smoker
FROM  Heart_health
where Smoker='yes'
GROUP BY Name
ORDER BY 1 DESC

--Looking for percentage The number of smokers out of the number of people 
Select (count(Smoker)/count(Name))*100 as percentage_number_smokers
FROM Heart_health
Where smoker='Yes'
 
--Looking for SUM of Glucose for each Name
-- Normal Blood glucose are between 70 mg/dL and 100 mg/dL 
select pat.ID,hea.Name,hea.[Glucose(mg/dL)], SUM([Glucose(mg/dL)]) 
over (partition by hea.Name) as Sum_of_Glucose
from Heart_health  hea
JOIN patient_information pat
on hea.ID=pat.ID
and hea.Name=pat.Name

-- Calculate the percentage of Glucose Use CTE
with Per_of_Glucose (ID,Name,[Glucose(mg/dL)],Sum_of_Glucose,Number_of_pepole)
as
(select pat.ID,hea.Name,hea.[Glucose(mg/dL)], SUM([Glucose(mg/dL)]) 
over (partition by hea.Name) as Sum_of_Glucose,COUNT(pat.ID) as Number_of_pepole
from Heart_health  hea
JOIN patient_information pat
on hea.ID=pat.ID
and hea.Name=pat.Name
Group by pat.ID,hea.Name,hea.[Glucose(mg/dL)]
)
-- Calculate the percentage
Select *, (Sum_of_Glucose/Number_of_pepole)*100 as prec_of_Glucose
from Per_of_Glucose

-- creating View t store data for later visualization
Create view View_percentageofGlucose as
select pat.ID,hea.Name,hea.[Glucose(mg/dL)], SUM([Glucose(mg/dL)]) 
over (partition by hea.Name) as Sum_of_Glucose,COUNT(pat.ID) as Number_of_pepole
from Heart_health  hea
JOIN patient_information pat
on hea.ID=pat.ID
and hea.Name=pat.Name
Group by pat.ID,hea.Name,hea.[Glucose(mg/dL)]
-- showing the Data in View
select *
from View_percentageofGlucose 