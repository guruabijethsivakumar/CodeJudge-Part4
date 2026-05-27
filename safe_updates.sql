-- Safe UPDATE Operations

CREATE TABLE students_staging AS SELECT * FROM students;
CREATE TABLE submissions_staging AS SELECT * FROM submissions;
CREATE TABLE operation_requests_staging AS SELECT * FROM operation_requests;

-- UPDATE 1: Fix blank email
SELECT * FROM students_staging WHERE student_id = 'S0005';

UPDATE students_staging
SET email = 'pending_review@codejudge.edu'
WHERE student_id = 'S0005'
AND (email IS NULL OR email = '');

SELECT * FROM students_staging WHERE student_id = 'S0005';

-- Safe because WHERE targets exact student_id

--------------------------------------------------

-- UPDATE 2: Fix invalid email
SELECT * FROM students_staging WHERE student_id = 'S0018';

UPDATE students_staging
SET email = 'corrected_pending@codejudge.edu'
WHERE student_id = 'S0018'
AND email NOT LIKE '%@%.%';

SELECT * FROM students_staging WHERE student_id = 'S0018';

-- Safe because exact ID + validation condition

--------------------------------------------------

-- UPDATE 3: Fix invalid contest reference
SELECT * FROM submissions_staging
WHERE contest_id IS NOT NULL
AND contest_id NOT IN (SELECT contest_id FROM contests);

UPDATE submissions_staging
SET contest_id = NULL
WHERE contest_id IS NOT NULL
AND contest_id NOT IN (SELECT contest_id FROM contests);

SELECT * FROM submissions_staging
WHERE contest_id IS NOT NULL
AND contest_id NOT IN (SELECT contest_id FROM contests);

-- Safe because only orphan contest references updated

--------------------------------------------------

-- UPDATE 4: Update operation request status
SELECT * FROM operation_requests_staging
WHERE operation_id = 'OP0001';

UPDATE operation_requests_staging
SET approval_status = 'approved'
WHERE operation_id = 'OP0001'
AND approval_status = 'pending';

SELECT * FROM operation_requests_staging
WHERE operation_id = 'OP0001';

-- Safe because exact operation_id used