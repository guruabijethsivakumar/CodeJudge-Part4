# ACID Explanation

Using Transaction Scenario 3:

## Atomicity
The transaction ensures grouped actions behave as one unit.
If something fails, rollback can undo related changes.

## Consistency
Database rules remain valid.
Invalid score update was rolled back, so incorrect data was not saved.

## Isolation
Other users should not see incomplete transaction changes while updates are in progress.

## Durability
Once COMMIT happens, approved regrade request remains permanently stored.