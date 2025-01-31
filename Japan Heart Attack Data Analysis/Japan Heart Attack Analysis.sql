-- Analyzing the contrbiution of various factors on heart attack occurrence in Japan.


SELECT *
FROM japan_heart_attack_dataset
LIMIT 5; 

/*
-- Drop extra columns that are not needed for analysis
ALTER TABLE heart_attack_dataset 
DROP COLUMN Extra_Column_1, DROP COLUMN Extra_Column_3, DROP COLUMN Extra_Column_4, DROP COLUMN Extra_Column_5, DROP COLUMN Extra_Column_6, DROP COLUMN Extra_Column_7, 
DROP COLUMN Extra_Column_8, DROP COLUMN Extra_Column_9, DROP COLUMN Extra_Column_10, DROP COLUMN Extra_Column_11, DROP COLUMN Extra_Column_12, DROP COLUMN Extra_Column_13, 
DROP COLUMN Extra_Column_14, DROP COLUMN Extra_Column_15;
*/



-- Detect the average age for heart attack in Japan
SELECT AVG(Age) AS avg_age_heart_attack,
	MAX(Age) AS maximum_age,
    MIN(Age) AS minimum_age
FROM japan_heart_attack_dataset
WHERE Heart_Attack_Occurrence = 'Yes';

-- Outcome: Average age for heart attack in Japan: 48.7807



/*
Number of all cases for each gender
Number of heart attack cases for each gender
Percentage of heart attack cases within each gender
Percentage of heart attack cases depending on gender
*/
SELECT Gender,
	COUNT(*) AS total_cases,
    SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) AS heart_attack_cases,
    (SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*)) AS heart_attack_rate_within_gender,
    (SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) * 100 / (
		SELECT COUNT(*)
		FROM japan_heart_attack_dataset
		WHERE Heart_Attack_Occurrence = 'Yes'
    )) AS heart_attack_rate_global
FROM japan_heart_attack_dataset
GROUP BY Gender;

-- Outcome:
-- Men have a slightly higher heart attack rate than women, but the difference is minor.
-- Heart disease affects both genders almost equally, future prevention strategies should target both groups.



/*
Number of all cases for each region
Number of heart attack cases for each region
Percentage of heart attack cases within each region
Percentage of heart attack cases depending on region
*/

SELECT Region,
	COUNT(*) AS total_cases,
	SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) AS heart_attack_cases,
    (SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*)) AS heart_attack_rate_region,
    (SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) * 100 / (
		SELECT COUNT(*)
		FROM japan_heart_attack_dataset
		WHERE Heart_Attack_Occurrence = 'Yes'
    )) AS heart_attack_rate_global
FROM japan_heart_attack_dataset
GROUP BY Region;

-- Outcome:
-- The heart attack rate is nearly the same in urban and rural areas, suggesting that geographical location alone may not be a significant risk factor.
-- Urban areas contribute more to total heart attack cases simply because they have a larger population in this dataset.



/*
Number of all cases based on smoking history
Number of heart attack cases for each option of smoking history
Percentage of heart attack cases within each option of smoking history
Percentage of heart attack cases depending on smoking
*/

SELECT Smoking_History,
       COUNT(*) AS total_cases,
       SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) AS heart_attack_cases,
       (SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS heart_attack_rate,
	    (SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) * 100 / (
		SELECT COUNT(*)
		FROM japan_heart_attack_dataset
		WHERE Heart_Attack_Occurrence = 'Yes'
    )) AS heart_attack_rate_global
FROM japan_heart_attack_dataset
GROUP BY Smoking_History;

-- Outcome:
-- Smoking appears to slightly increase the risk of a heart attack (10.20% vs. 9.74%).
-- The majority of heart attack cases still come from non-smokers, possibly due to their larger representation in the dataset.



-- Average Cholesterol Level in Heart Attack vs. Non-Heart Attack Patients

SELECT Heart_Attack_Occurrence,
       AVG(Cholesterol_Level) AS avg_cholesterol
FROM japan_heart_attack_dataset
GROUP BY Heart_Attack_Occurrence;

-- Outcome:
-- Average Cholesterol Level is almost identical for both heart attack and non-heart attack patients.
-- It appears that Cholesterol Level doesn't seem to have a substantial impact on heart attack.



-- Detect the BMI level and average age per BMI level influence on heart attack occurrence.

SELECT AVG(Age) AS avg_age_per_bmi,
    CASE 
        WHEN BMI < 18.5 THEN 'Underweight'
        WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal weight'
        WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END AS BMI_Category,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) AS heart_attack_cases,
    (SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS heart_attack_rate
FROM japan_heart_attack_dataset
GROUP BY BMI_Category;

-- Outcome:
-- Unexpected Observation: Lower Heart Attack Rate in Obese Individuals, the age column suggests that this outcome is not due to average age for these different bmi groups.
-- This unexpected result could be related to the possibility of obese individuals receiving more preventive medical care due to their known risk.



-- Detect the Family History influence on heart attack occurrence.
SELECT Family_History,
	COUNT(*) AS total_cases,
    SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) AS heart_attack_cases,
    (SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*)) AS heart_attack_rate
FROM japan_heart_attack_dataset
GROUP BY Family_History;

-- Outcome:
-- Surprisingly the heart attack rate of people who do not have a family history of heart attack is slightly higher than the ones who do.



-- Detect the Diet Quality and Alcohol Consumption influence on heart attack occurrence to analyze if a healthy lifestyle is effective for the prevention of heart attack.
SELECT Diet_Quality, Alcohol_Consumption,
       COUNT(*) AS total_cases,
       SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) AS heart_attack_cases,
       (SUM(CASE WHEN Heart_Attack_Occurrence = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS heart_attack_rate
FROM japan_heart_attack_dataset
GROUP BY Diet_Quality, Alcohol_Consumption
ORDER BY heart_attack_rate DESC;
-- ORDER BY FIELD(Diet_Quality, 'Good', 'Average', 'Poor'), FIELD(Alcohol_Consumption, 'None', 'Low', 'Moderate', 'High');

-- Outcome:
-- Surprisingly, the highest recorded rate (10.67%) appears in individuals with a good diet and no alcohol consumption.
-- Neither diet quality nor alcohol consumption appears to be a dominant predictor of heart attack risk.

