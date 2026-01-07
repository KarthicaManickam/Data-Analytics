CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100)
);
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    SeatsAvailable INT
);
CREATE TABLE Enrollments (
    EnrollmentID SERIAL PRIMARY KEY,
    StudentID INT REFERENCES Students(StudentID),
    CourseID INT REFERENCES Courses(CourseID),
    EnrollmentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO Students VALUES (1, 'John Doe'), (2, 'Jane Smith');
INSERT INTO Courses VALUES (101, 'Intro to SQL', 1); -- Only 1 seat left!

select * from students;
select * from Courses;
select * from enrollments;

CREATE OR REPLACE PROCEDURE sp_EnrollStudent(
    IN p_StudentID INT,
    IN p_CourseID INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_seats INT;
 
BEGIN
    --1. Check available seats
    SELECT SeatsAvailable INTO v_seats
    FROM Courses
    WHERE CourseID = p_CourseID;  
 
    --2.check if the course exists
    IF v_seats IS NULL THEN
        RAISE EXCEPTION 'Course % does not exist.', p_CourseID;
    END IF;    
 
    --3 ARE SEATS AVAILABLE?
    IF v_seats > 0 THEN
        --4. Enroll the student
        INSERT INTO Enrollments (StudentID, CourseID)
        VALUES (p_StudentID, p_CourseID);
 
        --5. Decrease available seats
        UPDATE Courses
        SET SeatsAvailable = SeatsAvailable - 1
        WHERE CourseID = p_CourseID;
 
        RAISE EXCEPTION 'No seats available for course %.', p_CourseID;
    END IF;
 
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Transaction Error: %', SQLERRM;
            ROLLBACK;
END;
$$;

call sp_EnrollStudent(1,101);
call sp_EnrollStudent(2,101);
