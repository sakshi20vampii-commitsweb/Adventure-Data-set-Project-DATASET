

1. Students Table 
Fields: 
• StudentID 
• FirstName 
• LastName 
• Email 
• BirthDate 
• EnrollmentDate 

Sample Data: 
StudentID   FirstName   LastName   Email                  BirthDate    EnrollmentDate 
1           John        Doe        john.doe@email.com     2000-01-15   2022-08-01
2           Jane        Smith      jane.smith@email.com   1999-05-25   2021-08-01


2. Courses Table 
Fields: 
• CourseID 
• CourseName 
• DepartmentID 
• Credits 

Sample Data: 
 CourseID    CourseName              DepartmentID       Credits 
101         Introduction to SQL     1                  3 
102         Data Structures         2                  4 
 
3. Instructors Table 
Fields: 
• InstructorID 
• FirstName 
• LastName 
• Email 
• DepartmentID 

Sample Data: 
InstructorID   FirstName LastName Email DepartmentID 
1 Alice Johnson alice.johnson@univ.com 1 
2 Bob Lee bob.lee@univ.com 2 
 
4. Enrollments Table 
Fields: 
• EnrollmentID 
• StudentID 
• CourseID 
• EnrollmentDate 
Sample Data: 
EnrollmentID StudentID CourseID EnrollmentDate 
1 1 101 2022-08-01 
2 2 102 2021-08-01 
 
5. Departments Table 
Fields: 
• DepartmentID 
• DepartmentName 
Sample Data: 
DepartmentID DepartmentName 
1 Computer Science 
2 Mathematics


--ADD COLOMN SALARY IN INSTRUCTURE--
ALTER TABLE Instructors
ADD COLUMN Salary DECIMAL(10,2);

UPDATE Instructors
SET Salary = 80000
WHERE InstructorID = 1;

UPDATE Instructors
SET Salary = 75000
WHERE InstructorID = 2;

--1 . CRUD  OPERATION--

-- Create Departments Table
CREATE TABLE Departmentsss (
DepartmentID INT PRIMARY KEY,
DepartmentName VARCHAR(100) NOT NULL
);
SELECT * FROM Departmentsss;
 
-- Create Students Table
CREATE TABLE Studentss (
StudentID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Email VARCHAR(100) UNIQUE NOT NULL,
BirthDate DATE,
EnrollmentDate DATE
);
SELECT * FROM Studentss;
 
-- Create Courses Table
CREATE TABLE Coursesss (
CourseID INT PRIMARY KEY,
CourseName VARCHAR(100) NOT NULL,
DepartmentID INT,
Credits INT NOT NULL,
FOREIGN KEY (DepartmentID) REFERENCES Departmentsss(DepartmentID)
);
SELECT * FROM Coursesss;
 
-- Create Instructors Table
CREATE TABLE Instructors (
InstructorID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Email VARCHAR(100) UNIQUE NOT NULL,
DepartmentID INT,
FOREIGN KEY (DepartmentID) REFERENCES Departmentsss(DepartmentID)
);
SELECT * FROM Instructors;
 
-- Create Enrollments Table
CREATE TABLE Enrollments (
EnrollmentID INT PRIMARY KEY,
StudentID INT,
CourseID INT,
EnrollmentDate DATE,
FOREIGN KEY (StudentID) REFERENCES Studentss(StudentID),
FOREIGN KEY (CourseID) REFERENCES Coursesss(CourseID)
);
SELECT * FROM Enrollments;

 
--------------------------------------------------
-- Insert Sample Data
--------------------------------------------------
 
-- Departments
INSERT INTO Departmentsss (DepartmentID, DepartmentName)
VALUES
(1, 'Computer Science'),
(2, 'Mathematics');
 
-- Students
INSERT INTO Studentss
(StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate)
VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01')
 
-- Courses
INSERT INTO Coursesss
(CourseID, CourseName, DepartmentID, Credits)
VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);
 
-- Instructors
INSERT INTO Instructors
(InstructorID, FirstName, LastName, Email, DepartmentID)
VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2);
 
-- Enrollments
INSERT INTO Enrollments
(EnrollmentID, StudentID, CourseID, EnrollmentDate)
VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');


-- List all students and their enrolled courses
SELECT
s.StudentID,
s.FirstName,
s.LastName,
c.CourseName
FROM Studentss s
JOIN Enrollments e ON s.StudentID = s.StudentID
JOIN Coursesss c ON c.CourseID = c.CourseID;


-- List courses with department names
SELECT
c.CourseID,
c.CourseName,
d.DepartmentName,
c.Credits
FROM Coursesss c
JOIN Departmentsss d
ON c.DepartmentID = d.DepartmentID;

--DELETE --
DELETE FROM Coursesss
WHERE CourseID = 103;


--2 . Retrieve students who enrolled after 2022 --

SELECT *
FROM Studentss
WHERE EnrollmentDate >= '2023-01-01';


--3. Retrieve courses offered by the Mathematics department with a limit of 5 courses. --

SELECT c.CourseID,
c.CourseName,
c.Credits
FROM Coursesss c
JOIN Departmentsss d
ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;


--4. Get the number of students enrolled in each course, filtering for courses with more than 5 students.-- 

SELECT
    c.CourseID,
    c.CourseName,
    COUNT(e.StudentID) AS TotalStudents
FROM Coursesss c
JOIN Enrollments e
    ON c.CourseID = e.CourseID
GROUP BY
    c.CourseID,
    c.CourseName
HAVING COUNT(e.StudentID) > 5;

--5. Find students who are enrolled in both Introduction to SQL and Data Structures.-- 

SELECT s.StudentID,
       s.FirstName,
       s.LastName
FROM Studentss s
JOIN Enrollments e
    ON s.StudentID = e.StudentID
WHERE e.CourseID IN (101, 102)
GROUP BY s.StudentID, s.FirstName, s.LastName
HAVING COUNT(DISTINCT e.CourseID) = 2;

--6. Find students who are either enrolled in Introduction to SQL or Data Structures--
SELECT DISTINCT
       s.StudentID,
       s.FirstName,
       s.LastName
FROM Studentss s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Coursesss c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures');

--7. Calculate the average number of credits for all courses.-- 
SELECT AVG(Credits) AS AverageCredits
FROM Coursesss;

--8. Find the maximum salary of instructors in the Computer Science department.-- 
SELECT MAX(i.Salary) AS MaxSalary
FROM Instructors i
INNER JOIN Departmentsss d
ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';

--9. Count the number of students enrolled in each department.--
SELECT d.DepartmentName,
COUNT(DISTINCT e.StudentID) AS TotalStudents
FROM Departmentsss d
JOIN Coursesss c
ON d.DepartmentID = c.DepartmentID
JOIN Enrollments e
ON c.CourseID = e.CourseID
GROUP BY d.DepartmentName;

--10. INNER JOIN: Retrieve students and their corresponding courses.-- 
SELECT s.StudentID,
       s.FirstName,
       s.LastName,
       c.CourseName
FROM Studentss s
INNER JOIN Enrollments e
ON s.StudentID = e.StudentID
INNER JOIN Coursesss c
ON e.CourseID = c.CourseID;
	
--11. LEFT JOIN: Retrieve all students and their corresponding courses, if any.--  
SELECT s.StudentID,
       s.FirstName,
       s.LastName,
       c.CourseName
FROM Studentss s
LEFT JOIN Enrollments e
    ON s.StudentID = e.StudentID
LEFT JOIN Coursesss c
    ON e.CourseID = c.CourseID;
	
--12. Subquery: Find students enrolled in courses that have more than 10 students.-- 
SELECT DISTINCT
       s.StudentID,
       s.FirstName,
       s.LastName
FROM Studentss s
JOIN Enrollments e
    ON s.StudentID = e.StudentID
WHERE e.CourseID IN (
    SELECT CourseID
    FROM Enrollments
    GROUP BY CourseID
    HAVING COUNT(StudentID) > 10
);

--13. Extract the year from the EnrollmentDate of students.--
SELECT s.StudentID,
       s.FirstName,
       s.LastName
YEAR(EnrollmentDate) AS EnrollmentYear
FROM Studentss;

SELECT s.StudentID,
       s.FirstName,
       s.LastName
EXTRACT(YEAR FROM EnrollmentDate) AS EnrollmentYear
FROM Studentss;

SELECT
StudentID,
    FirstName,
    LastName,
    DATE_PART('year', EnrollmentDate) AS EnrollmentYear
FROM Studentss;

--14. Concatenate the instructor's first and last name.--
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Instructors;

--15. Calculate the running total of students enrolled in. courses.-- 
SELECT
    CourseID,
    StudentCount,
SUM(StudentCount) OVER (
ORDER BY CourseID)
AS RunningTotal
FROM (
SELECT CourseID,
COUNT(StudentID) AS StudentCount
FROM Enrollments
GROUP BY CourseID
) AS CourseCounts;


--16. Label students as 'Senior' or 'Junior' based on their year of enrollment. (If the enrollment date is more than 4 years from the current date, put the label 'Senior' otherwise 'Junior')--

SELECT
    StudentID,
    FirstName,
    LastName,
    EnrollmentDate,
    CASE
WHEN DATEDIFF (YEAR, EnrollmentDate, GETDATE()) > 4
THEN 'Senior'
ELSE 'Junior'
END AS StudentLevel
FROM Studentss;








