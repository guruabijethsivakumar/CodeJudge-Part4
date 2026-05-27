-- Transaction Scenarios

CREATE TABLE enrollments_txn AS SELECT * FROM enrollments;
CREATE TABLE submissions_txn AS SELECT * FROM submissions;
CREATE TABLE test_results_txn AS SELECT * FROM test_results;
CREATE TABLE regrade_txn AS SELECT * FROM regrade_requests;

--------------------------------------------------
-- Scenario 1: Student submission commit

BEGIN TRANSACTION;

INSERT INTO submissions_txn
VALUES (
    'SUB999001',
    'S0001',
    'P0001',
    NULL,
    'Python',
    '2025-07-01 10:00:00',
    'Accepted',
    '75',
    '120'
);

INSERT INTO test_results_txn
VALUES (
    'R999001',
    'SUB999001',
    'TC00001',
    'Passed',
    '120',
    '2048',
    '15'
);

COMMIT;

-- Final state:
-- Both submission and test result remain saved.

--------------------------------------------------
-- Scenario 2: Enrollment rollback

BEGIN TRANSACTION;

INSERT INTO enrollments_txn
VALUES (
    'E999999',
    'S9999',
    'C001',
    '2025-07-01',
    'active',
    NULL
);

ROLLBACK;

-- Final state:
-- Invalid enrollment is not saved.

--------------------------------------------------
-- Scenario 3: Savepoint partial rollback

BEGIN TRANSACTION;

UPDATE regrade_txn
SET request_status = 'approved'
WHERE request_id = 'RG0001';

SAVEPOINT before_score_update;

UPDATE submissions_txn
SET score = '999'
WHERE submission_id = 'SUB001225';

ROLLBACK TO before_score_update;

COMMIT;

-- Final state:
-- Request approval saved
-- Invalid score update cancelled