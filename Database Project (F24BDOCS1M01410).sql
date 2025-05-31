CREATE TABLE universities (
    id SERIAL PRIMARY KEY,
    university TEXT,
    university_shortname TEXT,
    university_city TEXT
);
INSERT INTO universities (university, university_shortname, university_city)
SELECT DISTINCT university, university_shortname, university_city
FROM university_professors;

SELECT *
FROM universities;


CREATE TABLE professors (
    id SERIAL PRIMARY KEY,
    firstname TEXT,
    lastname TEXT,
    university_id INT,
    FOREIGN KEY (university_id) REFERENCES universities(id)
);
INSERT INTO professors (firstname, lastname, university_id)
SELECT up.firstname, up.lastname, u.id
FROM university_professors up
JOIN universities u
  ON up.university = u.university
 AND up.university_shortname = u.university_shortname
 AND up.university_city = u.university_city;

 SELECT *
FROM professors;


CREATE TABLE organizations (
    id SERIAL PRIMARY KEY,
    organization TEXT,
    organization_sector TEXT
);
INSERT INTO organizations (organization,organization_sector)
SELECT DISTINCT organization,organization_sector
FROM university_professors;

SELECT *
FROM organizations;

   


CREATE TABLE affiliations (
    id SERIAL PRIMARY KEY,
    firstname TEXT,
    lastname TEXT,
    organization_id INT,
    professor_id INT,
    function TEXT,
    FOREIGN KEY (organization_id) REFERENCES organizations(id),
    FOREIGN KEY (professor_id) REFERENCES professors(id)
);
INSERT INTO affiliations (firstname, lastname, organization_id, professor_id, function)
SELECT up.firstname, up.lastname, o.id, p.id, 'Professor'  -- You can replace 'Professor' with actual function if available
FROM university_professors up
JOIN professors p
  ON up.firstname = p.firstname AND up.lastname = p.lastname
JOIN organizations o
  ON up.organization_sector = o.organization_sector;

SELECT *
FROM affiliations;

--Example  Queries
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name TEXT NOT NULL,
    department TEXT
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE,
    course_id INT REFERENCES courses(course_id)  
);
INSERT INTO courses (course_name, department)
VALUES ('Database Systems', 'Computer Science');
SELECT * 
FROM courses;

INSERT INTO students (first_name, last_name, email, course_id)
VALUES ('Sara', 'Ahmed', 'sara.ahmed@example.com', 1);
SELECT * 
FROM students;

UPDATE students
SET course_id = 1
WHERE student_id = 1;

SELECT 
    s.first_name,
    s.last_name,
    c.course_name,
    c.department
FROM students s
JOIN courses c ON s.course_id = c.course_id;

DELETE FROM students
WHERE student_id = 1