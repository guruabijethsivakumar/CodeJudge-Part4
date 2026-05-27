# Reliability Incident Note

## Incident
A developer accidentally runs:

UPDATE submissions SET score = 0;

without a WHERE clause.

## Impact
All submission scores in CodeJudge would be overwritten.

This would affect:
- rankings
- performance analytics
- regrade accuracy
- contest results

## Detection
Issue could be detected by:
- sudden score anomalies
- audit review
- unexpected reporting changes

## Recovery
If transaction was active:
ROLLBACK can undo changes.

If already committed:
restore from backup is required.

## Prevention
Best practices:
- always test with SELECT first
- use transactions
- use staging tables
- review WHERE clauses
- restrict production permissions