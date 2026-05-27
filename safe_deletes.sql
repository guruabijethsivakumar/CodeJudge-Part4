-- Safe DELETE Operations

CREATE TABLE enrollments_staging AS SELECT * FROM enrollments;
CREATE TABLE submissions_staging_delete AS SELECT * FROM submissions;

-- DELETE 1: Duplicate enrollments
SELECT student_id, course_id, COUNT(*)
FROM enrollments_staging
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

DELETE FROM enrollments_staging
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM enrollments_staging
    GROUP BY student_id, course_id
);

SELECT student_id, course_id, COUNT(*)
FROM enrollments_staging
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

-- Safe because only duplicate copies removed

--------------------------------------------------

-- DELETE 2: Invalid student submission
SELECT *
FROM submissions_staging_delete
WHERE student_id = 'S9999';

DELETE FROM submissions_staging_delete
WHERE student_id = 'S9999';

SELECT *
FROM submissions_staging_delete
WHERE student_id = 'S9999';

-- Safe because exact invalid record targeted