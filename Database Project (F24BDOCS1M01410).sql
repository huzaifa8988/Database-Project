-- TABLE 1: universities
-- Purpose: Stores university information
-- Relations: Referenced by professors table
CREATE TABLE universities (
    id SERIAL PRIMARY KEY,
    university TEXT,                -- Full university name
    university_shortname TEXT,      -- Abbreviated name (e.g., IUB)
    university_city TEXT            -- Location city
);
-- Populate universities table from source data
INSERT INTO universities (university, university_shortname, university_city)
SELECT DISTINCT university, university_shortname, university_city
FROM university_professors;
-- Verify data insertion
SELECT * FROM universities;

-- TABLE 2: professors
-- Purpose: Tracks professor details
-- Relations: Links to universities (many-to-one)
CREATE TABLE professors (
    id SERIAL PRIMARY KEY,
    firstname TEXT,                 -- Professor's first name
    lastname TEXT,                  -- Professor's last name
    university_id INT,              -- Foreign key to universities
    FOREIGN KEY (university_id) REFERENCES universities(id)
);
-- Populate professors with data from university_professors
INSERT INTO professors (firstname, lastname, university_id)
SELECT up.firstname, up.lastname, u.id
FROM university_professors up
JOIN universities u
  ON up.university = u.university
 AND up.university_shortname = u.university_shortname
 AND up.university_city = u.university_city;
-- Verify data insertion
SELECT * FROM professors;

-- TABLE 3: organizations
-- Purpose: Stores organization details
-- Relations: Linked via affiliations table
CREATE TABLE organizations (
    id SERIAL PRIMARY KEY,
    organization TEXT,              -- Organization name
    organization_sector TEXT       -- Sector (e.g., Education, Research)
);
-- Populate organizations from source data
INSERT INTO organizations (organization, organization_sector)
SELECT DISTINCT organization, organization_sector
FROM university_professors;
-- Verify data insertion
SELECT * FROM organizations;

-- TABLE 4: affiliations
-- Purpose: Connects professors to organizations (junction table)
-- Relations: Many-to-many between professors and organizations
CREATE TABLE affiliations (
    id SERIAL PRIMARY KEY,
    firstname TEXT,                 -- Redundant for quick access
    lastname TEXT,                  -- Redundant for quick access
    organization_id INT,            -- Foreign key to organizations
    professor_id INT,               -- Foreign key to professors
    function TEXT,                  -- Role (e.g., Professor)
    FOREIGN KEY (organization_id) REFERENCES organizations(id),
    FOREIGN KEY (professor_id) REFERENCES professors(id)
);
-- Populate affiliations table
INSERT INTO affiliations (firstname, lastname, organization_id, professor_id, function)
SELECT up.firstname, up.lastname, o.id, p.id, 'Professor'
FROM university_professors up
JOIN professors p ON up.firstname = p.firstname AND up.lastname = p.lastname
JOIN organizations o ON up.organization_sector = o.organization_sector;
-- Verify data insertion
SELECT * FROM affiliations;

-- DEMONSTRATION QUERIES (Instruction #6 Requirements)

-- QUERY TYPE 1: CREATE TABLE
-- Purpose: Demonstrates table creation syntax

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name TEXT NOT NULL,      -- Course title
    department TEXT                 -- Academic department
);
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE,
    course_id INT REFERENCES courses(course_id)  -- Foreign key
);

-- QUERY TYPE 2: INSERT DATA
-- Purpose: Shows how to add records

INSERT INTO courses (course_name, department)
VALUES ('Database Systems', 'Computer Science');
-- Verify insertion
SELECT * FROM courses;

INSERT INTO students (first_name, last_name, email, course_id)
VALUES 
    ('Sara', 'Ahmed', 'sara.ahmed@example.com', 1);
-- Verify insertion
SELECT * FROM students;

-- QUERY TYPE 3: UPDATE DATA
-- Purpose: Modifies existing records
UPDATE students
SET course_id = 1
WHERE student_id = 1;


-- QUERY TYPE 4: JOIN QUERY
-- Purpose: Combines data from multiple tables
SELECT 
    s.first_name,
    s.last_name,
    c.course_name,
    c.department
FROM students s
JOIN courses c ON s.course_id = c.course_id;

-- QUERY TYPE 5: DELETE DATA
-- Purpose: Removes records with referential integrity
DELETE FROM students
WHERE student_id = 1;

-- QUERY TYPE 6: REFERENTIAL INTEGRITY TEST
-- Purpose: Attempt to violate foreign key constraint
-- Expected: Should fail if students.course_id references courses
DELETE FROM courses
WHERE course_id = 1;