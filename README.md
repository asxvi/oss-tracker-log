# OSS Contributions for asxvi

_Last updated: 2026-09-17 14:15 CDT_

_Scoped to repos listed in repos.md_

## Summary

| Repo | Merged PRs | Open PRs | Closed PRs | Issues Opened | Issues Commented | Total |
|---|---|---|---|---|---|---|
| duckdb/duckdb | 3 | 5 | 2 | 3 | 10 | 23 |
| facebook/rocksdb | 0 | 1 | 0 | 0 | 2 | 3 |
| facebookincubator/cinderx | 0 | 0 | 1 | 0 | 0 | 1 |

## Merged Pull Requests

- [duckdb/duckdb] [Fix uint32_t blob offset overflow when casting oversized rows to VARIANT](https://github.com/duckdb/duckdb/pull/25181)
- [duckdb/duckdb] [Report missing prepared statement parameters in declaration order (#25299)](https://github.com/duckdb/duckdb/pull/25336)
- [duckdb/duckdb] [Allow integral types in variant_extract via cast to UINTEGER](https://github.com/duckdb/duckdb/pull/25031)

## Open Pull Requests

- [facebook/rocksdb] [Validate CuckooTableReader table geometry against file size](https://github.com/facebook/rocksdb/pull/15233)
- [duckdb/duckdb] [Reject SET/DROP NOT NULL,SET DEFAULT,ALTER TYPE on nested struct fields](https://github.com/duckdb/duckdb/pull/25479)
- [duckdb/duckdb] [Fix checkpoint corrupting -0.0 into 0.0 for FLOAT/DOUBLE columns](https://github.com/duckdb/duckdb/pull/25592)
- [duckdb/duckdb] [Fix ORDER BY turning -0.0 into 0.0 for FLOAT/DOUBLE columns](https://github.com/duckdb/duckdb/pull/25540)
- [duckdb/duckdb] [fix crash casting a string to STRUCT with a VARIANT field](https://github.com/duckdb/duckdb/pull/25344)
- [duckdb/duckdb] [Fix OOB vector access in PIVOT map() constant folding](https://github.com/duckdb/duckdb/pull/25341)

## Closed (Unmerged) Pull Requests

- [facebookincubator/cinderx] [Fix AssertionError when a dynamic value is returned as a primitive int](https://github.com/facebookincubator/cinderx/pull/156)
- [duckdb/duckdb] [Fix integer truncation in ArgMinMaxValueAssign::Assign](https://github.com/duckdb/duckdb/pull/25596)
- [duckdb/duckdb] [Fix OOB vector access in map() PIVOT constant folding (#25276, #25278)](https://github.com/duckdb/duckdb/pull/25333)

## Issues Opened

- [duckdb/duckdb] [CHECKPOINT turns +0.0 into -0.0 for FLOAT/DOUBLE columns](https://github.com/duckdb/duckdb/issues/25580) (open)
- [duckdb/duckdb] [D_ASSERT in ExpressionBinder::BindInEnclosingScope uses a variable declared only under #ifdef DEBUG](https://github.com/duckdb/duckdb/issues/25345) (closed)
- [duckdb/duckdb] [Constant-folding a literal cast to VARIANT that overflows silently returns a wrong result instead of erroring](https://github.com/duckdb/duckdb/issues/25231) (open)

## Issues Participation (not opened by me)

- [facebook/rocksdb] [[BUG] Crash / OOB read in CassandraValueMergeOperator when a merge operand is malformed (format.cc deserialization has no bounds checks)](https://github.com/facebook/rocksdb/issues/15212) (open)
- [facebook/rocksdb] [[BUG] Crash / OOB read and SIGFPE in CuckooTableReader when cuckoo SST table properties are inconsistent with the file](https://github.com/facebook/rocksdb/issues/15213) (open)
- [duckdb/duckdb] [Vuln184: Integer Truncation in `ArgMinMaxValueAssign::Assign` Leads to Heap Buffer Overflow with Large Strings](https://github.com/duckdb/duckdb/issues/25577) (closed)
- [duckdb/duckdb] [Vuln45: Heap Buffer Overflow from uint32_t Blob-Offset Wraparound When Casting Large Rows to VARIANT](https://github.com/duckdb/duckdb/issues/25078) (closed)
- [duckdb/duckdb] [ORDER BY changes -0.0 to +0.0 for DOUBLE values](https://github.com/duckdb/duckdb/issues/25417) (open)
- [duckdb/duckdb] [v2: wrong order of missing parameters in prepared statements](https://github.com/duckdb/duckdb/issues/25299) (closed)
- [duckdb/duckdb] [Bug102: OOB Vector Access in PIVOT Backwards-Compat Serialization via Zero-Argument map()](https://github.com/duckdb/duckdb/issues/25279) (open)
- [duckdb/duckdb] [Bug100: Out-of-Bounds Vector Access in `ConstructConstantFromExpression` map Branch](https://github.com/duckdb/duckdb/issues/25276) (open)
- [duckdb/duckdb] [Bug33: Unbounded Recursion in VariantVisitor Array/Object Traversal Causes Stack Overflow](https://github.com/duckdb/duckdb/issues/25074) (open)
- [duckdb/duckdb] [calling `variant_extract( val, intliteral )` throws binder error "'variant_extract' expects the second argument to be of type VARCHAR or UINTEGER, not INTEGER"](https://github.com/duckdb/duckdb/issues/24941) (closed)
- [duckdb/duckdb] [Vuln47: Signed Integer Overflow via Negation of INT64_MIN Interval Microseconds in TIME/TIMETZ Subtraction](https://github.com/duckdb/duckdb/issues/25084) (closed)
- [duckdb/duckdb] [Decimal AVG Internal Overflow](https://github.com/duckdb/duckdb/issues/24067) (open)

