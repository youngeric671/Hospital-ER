--Create Databse
CREATE DATABASE DHUHospital

USE DHUHospital
Go
--ETL USING SSIS IN VISUAL STUDIO
SELECT *
FROM dbo.[ADO NET Destination]

--1.Total Number of Patients Visiting ER
SELECT COUNT(*) [Total Number of Patients Visiting ER]
FROM dbo.[ADO NET DESTINATION]

--2.Total Number of Distinct Patient Visits to ER
SELECT  DISTINCT COUNT(*) [Total Number of Distinct Patient Visit to ER]
FROM dbo.[ADO NET DESTINATION]


--3.AVERAGE PATIENT SATISFACTION
SELECT year(date) Year, AVG(Patient_satisfaction_score) [AVERAGE PATIENT SATISFACTION]
FROM dbo.[ADO NET Destination]
GROUP BY year(date)

--4.percentage of gender and the average ages of the genders at our hospital
SELECT patient_gender Gender, COUNT(patient_gender) [Count of Gender], (COUNT(patient_gender)*100/ SUM(COUNT(patient_gender)) OVER())  [Gender Presence %], AVG(patient_age) [Average Patient Age]
FROM dbo.[ADO NET Destination]
GROUP BY patient_gender
ORDER BY [Gender Presence %] DESC

--5.prevalent patient race at the hospital
SELECT patient_race, COUNT(patient_race) [Count of Race], (COUNT(patient_race)*100/ SUM(COUNT(patient_race)) OVER()) [Race Presence %]
FROM dbo.[ADO NET Destination]
GROUP BY patient_race
ORDER BY [Race Presence %] DESC

--6.Admin flagged (Special information sent before patient came to ER with respect to how to care for patient)
SELECT department_referral, COUNT(patient_admin_flag), patient_admin_flag
FROM dbo.[ADO NET Destination]
GROUP
BY department_referral, patient_admin_flag
ORDER BY department_referral

--7.Department referral percentage
SELECT department_referral, COUNT(department_referral) [Number of Referrals], ROUND((CAST(COUNT(department_referral) AS decimal(10,2)) / SUM(COUNT(department_referral)) OVER() * 100),2) AS Percentage
FROM dbo.[ADO NET Destination]
GROUP BY department_referral
ORDER BY Percentage DESC

--8.Patient wait time by years and month
SELECT YEAR(date) YEAR, MONTH(date) MONTH, AVG([patient_wait_time(mins)]) [AVERAGE WAIT TIME]
FROM dbo.[ADO NET Destination]
GROUP BY YEAR(date), MONTH(date)
ORDER BY YEAR(date) DESC, MONTH(date) DESC

--CREATING A VIEW FOR Age Groupings to perform analysis on it.
CREATE VIEW patient_grouping AS
SELECT patient_age,
CASE WHEN patient_age <=17 THEN 'CHILD'
	WHEN patient_age <=24 THEN 'TEENAGER'
	WHEN patient_age <=49 THEN 'ADULT'
	ELSE 'OLD'
	END AS patient_age_group
FROM dbo.[ADO NET DESTINATION]

--9.Age Groupings by Year and Month
SELECT YEAR(a.date) Year, MONTH(a.date) Month, pg.patient_age_group AS [Age Group], COUNT(pg.patient_age) [Number of Patient], CAST(COUNT(pg.patient_age)*100/ SUM(COUNT(pg.patient_age)) OVER() AS decimal(5,2)) [Percentage of Patients]  
FROM patient_grouping pg
JOIN dbo.[ADO NET Destination] a
ON pg.patient_age = a.patient_age
GROUP BY YEAR(date), MONTH(date), patient_age_group
ORDER BY Year DESC, Month DESC

--10.Age Groupings
SELECT patient_age_group AS [Age Group], COUNT(patient_age) [Number of Patient], CAST(COUNT(patient_age)*100/ SUM(COUNT(patient_age)) OVER() AS decimal(5,2)) [Percentage of Patients]  
FROM patient_grouping
GROUP BY patient_age_group
ORDER BY [Number of Patient] DESC

--11.Prevalent HOUR for emergency
SELECT DATEPART(HOUR,date) AS HOUR, COUNT(patient_id) [Number of Patients], (COUNT(patient_id) *100/SUM(COUNT(patient_id)) OVER()) [Percentage of Patients]
FROM dbo.[ADO NET DESTINATION]
GROUP BY DATEPART(HOUR,date)
ORDER BY [Number of Patients] DESC

--12.Prevalent DAY for emergency
SELECT DATENAME(DW, date) DAY, COUNT(patient_id) [Number of Patients], (COUNT(patient_id) *100/SUM(COUNT(patient_id)) OVER()) [Percentage of Patients]
FROM dbo.[ADO NET DESTINATION]
GROUP BY DATENAME(DW, date)
ORDER BY [Number of Patients] DESC


--13.Prevalent TIME for emergency
SELECT DATENAME(DW, date) DAY, DATEPART(HOUR,date) AS HOUR, COUNT(patient_id) [Number of Patients], (COUNT(patient_id) *100/SUM(COUNT(patient_id)) OVER()) [Percentage of Patients]
FROM dbo.[ADO NET DESTINATION]
GROUP BY DATENAME(DW, date), DATEPART(HOUR,date)
ORDER BY [Number of Patients] DESC


SELECT *
FROM dbo.[ADO NET Destination]