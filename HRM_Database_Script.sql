-- 1. Setup Environment & Drop Tables in Correct Order
DROP TABLE IF EXISTS Employee_Shift;
DROP TABLE IF EXISTS Employee_Training;
DROP TABLE IF EXISTS Training_skill;
DROP TABLE IF EXISTS Performance;
DROP TABLE IF EXISTS Login;
DROP TABLE IF EXISTS Notification_Type;
DROP TABLE IF EXISTS Notification;
DROP TABLE IF EXISTS Attendance;
DROP TABLE IF EXISTS [Leave];
DROP TABLE IF EXISTS Payroll;
DROP TABLE IF EXISTS Shift;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Training;
DROP TABLE IF EXISTS Department;
GO

-- 2. Create Tables (Based on PDF structure)
CREATE TABLE Department (
    Depart_id INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    Shift_Type NVARCHAR(50)
);

CREATE TABLE Training (
    Training_id INT PRIMARY KEY,
    Name_trainer NVARCHAR(100) NOT NULL
);

CREATE TABLE Employee (
    Employee_id INT PRIMARY KEY,
    Employee_name NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255),
    Email NVARCHAR(100) UNIQUE,
    Hire_date DATE,
    Gender NVARCHAR(10),
    Job_title NVARCHAR(100),
    Depart_id INT,
    FOREIGN KEY (Depart_id) REFERENCES Department (Depart_id)
);

CREATE TABLE Shift (
    Shift_id INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Start_time TIME,
    End_time TIME,
    Depart_id INT,
    FOREIGN KEY (Depart_id) REFERENCES Department (Depart_id)
);

CREATE TABLE Payroll (
    Payroll_id INT PRIMARY KEY,
    Employee_id INT UNIQUE,
    salary DECIMAL(10, 2) NOT NULL,
    netbay DECIMAL(10, 2),
    bouns DECIMAL(10, 2),
    FOREIGN KEY (Employee_id) REFERENCES Employee (Employee_id)
);

CREATE TABLE [Leave] (
    Leave_id INT PRIMARY KEY,
    Employee_id INT NOT NULL,
    Start_date DATE,
    End_date DATE,
    reason NVARCHAR(255),
    FOREIGN KEY (Employee_id) REFERENCES Employee (Employee_id)
);

CREATE TABLE Attendance (
    Attendance_id INT PRIMARY KEY,
    Employee_id INT NOT NULL,
    Time_in TIME,
    Time_out TIME,
    [date] DATE,
    FOREIGN KEY (Employee_id) REFERENCES Employee (Employee_id)
);

CREATE TABLE Notification (
    Notification_id INT PRIMARY KEY,
    Employee_id INT NOT NULL,
    Message NVARCHAR(MAX),
    status NVARCHAR(50),
    Created_at DATETIME2,
    FOREIGN KEY (Employee_id) REFERENCES Employee (Employee_id)
);

CREATE TABLE Notification_Type (
    Notification_id INT PRIMARY KEY,
    Type NVARCHAR(50),
    FOREIGN KEY (Notification_id) REFERENCES Notification (Notification_id)
);

CREATE TABLE Login (
    Login_id INT PRIMARY KEY,
    Employee_id INT UNIQUE NOT NULL,
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    FOREIGN KEY (Employee_id) REFERENCES Employee (Employee_id)
);

CREATE TABLE Performance (
    Performance_id INT PRIMARY KEY,
    Employee_id INT UNIQUE NOT NULL,
    Evaluation_date DATE,
    Evaluator_name NVARCHAR(100),
    score INT,
    comments NVARCHAR(MAX),
    Goals_met BIT,
    Next_review_date DATE,
    FOREIGN KEY (Employee_id) REFERENCES Employee (Employee_id)
);

CREATE TABLE Training_skill (
    Training_id INT,
    skill NVARCHAR(100),
    PRIMARY KEY (Training_id, skill),
    FOREIGN KEY (Training_id) REFERENCES Training (Training_id)
);

CREATE TABLE Employee_Training (
    Employee_id INT,
    Training_id INT,
    PRIMARY KEY (Employee_id, Training_id),
    FOREIGN KEY (Employee_id) REFERENCES Employee (Employee_id),
    FOREIGN KEY (Training_id) REFERENCES Training (Training_id)
);

CREATE TABLE Employee_Shift (
    Employee_id INT,
    Shift_id INT,
    PRIMARY KEY (Employee_id, Shift_id),
    FOREIGN KEY (Employee_id) REFERENCES Employee (Employee_id),
    FOREIGN KEY (Shift_id) REFERENCES Shift (Shift_id)
);
GO

-- 3. Insert Data (Translated and corrected)
INSERT INTO Department VALUES (1, 'Administration', 'Morning');
INSERT INTO Department VALUES (2, 'Finance', 'Morning');
INSERT INTO Department VALUES (3, 'Development', 'Flexible');

INSERT INTO Training VALUES (101, 'Badawi El Gendi');
INSERT INTO Training VALUES (102, 'Adel Islam');

INSERT INTO Employee VALUES (10, 'Ahmed Samir', 'Cairo', 'ahmed.s@company.com', '2022-01-15', 'Male', 'Manager', 1);
INSERT INTO Employee VALUES (20, 'Mona Jaber', 'Giza', 'mona.j@company.com', '2023-05-20', 'Female', 'Accountant', 2);
INSERT INTO Employee VALUES (30, 'Khaled Hussein', 'Alexandria', 'khaled.h@company.com', '2024-01-01', 'Male', 'Developer', 3);

INSERT INTO Payroll VALUES (1000, 10, 8000.00, 7500.00, 500.00);
INSERT INTO Payroll VALUES (2000, 20, 5500.00, 5000.00, 300.00);
INSERT INTO Payroll VALUES (3000, 30, 9500.00, 9000.00, 500.00);

INSERT INTO Shift VALUES (301, 'Morning', '08:00:00', '16:00:00', 1);
INSERT INTO Shift VALUES (302, 'Morning', '08:00:00', '16:00:00', 2);
INSERT INTO Shift VALUES (303, 'Flexible', '10:00:00', '18:00:00', 3);

INSERT INTO [Leave] VALUES (401, 10, '2024-03-01', '2024-03-05', 'Annual Leave');
INSERT INTO Attendance VALUES (501, 10, '07:55:00', '16:05:00', '2024-05-01');

INSERT INTO Performance VALUES (601, 10, '2023-12-31', 'General Manager', 95, 'Excellent Performance', 1, '2024-12-31');
INSERT INTO Performance VALUES (602, 20, '2024-01-31', 'Supervisor', 60, 'Needs Improvement', 0, '2024-07-31');

INSERT INTO Employee_Training VALUES (10, 101), (20, 102), (30, 101);
INSERT INTO Employee_Shift VALUES (10, 301), (20, 302), (30, 303);
GO

-- 4. Sample Updates and Advanced Queries
UPDATE Payroll SET salary = salary * 1.10 WHERE Employee_id = 10;
UPDATE Performance SET score = 95 WHERE Employee_id = 10;

-- Complex Join Query for Portfolio
SELECT E.Employee_name, T.Name_trainer, P.comments
FROM Employee E
INNER JOIN Employee_Training ET ON E.Employee_id = ET.Employee_id
INNER JOIN Training T ON ET.Training_id = T.Training_id
INNER JOIN Performance P ON E.Employee_id = P.Employee_id
WHERE P.comments = 'Needs Improvement';
