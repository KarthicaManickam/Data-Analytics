-- Setup Tables
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
 
-- Insert Sample Data
INSERT INTO Students VALUES (1, 'Alice'), (2, 'Bob');
INSERT INTO Courses VALUES (101, 'Database Systems', 1); -- Only 1 seat!
INSERT INTO Enrollments VALUES (501, 1,101,'2026-01-06');

select * from Students;
select * from Courses;
select * from Enrollments;

---PROCEDURE

CREATE PROCEDURE sp_EnrollStudent(
    IN p_StudentID INT,
    IN p_CourseID INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Start the transaction (PostgreSQL procedures run in their own transaction context)
    
    -- Check available seats
    IF (SELECT SeatsAvailable FROM Courses WHERE CourseID = p_CourseID) <= 0 THEN
        RAISE EXCEPTION 'No seats available for CourseID %', p_CourseID;
    END IF;

    -- Insert enrollment
    INSERT INTO Enrollments (StudentID, CourseID)
    VALUES (p_StudentID, p_CourseID);

    -- Decrement seats
    UPDATE Courses
    SET SeatsAvailable = SeatsAvailable - 1
    WHERE CourseID = p_CourseID;

EXCEPTION
    WHEN OTHERS THEN
        -- Rollback is automatic for the procedure if an exception occurs
        RAISE NOTICE 'Enrollment failed: %', SQLERRM;
        -- Reraise to ensure the error is visible
        RAISE;
END;
$$;

CALL sp_EnrollStudent(2, 101);
CALL sp_EnrollStudent(1, 101);


