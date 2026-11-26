# db: AS-IS SCM DB(LGCE_SCMDEV) 추출 결과

`tools/AsisFacts` 의 DB 단계(`db.ps1`)와 Grid 단계(`grid.ps1`) 결과입니다.

- 읽기 전용: SELECT 만 실행합니다. SP 는 Grid 단계에서 쓰기가 없는 `*_SPREAD_TITLE` 만 트랜잭션 안에서 실행하고 항상 ROLLBACK 했습니다.
- 접속 정보는 `.env.asis` 를 읽으며, 비밀번호는 어떤 파일에도 남기지 않습니다.

| 항목 | 값 |
|---|---|
| 접속 기록 | `_db.log` 첫 줄 `connected: ... / LGCE_SCMDEV` |
| 객체 수 | 5,271 (`_db.log`) |
| SP·함수·뷰 원문 | 3,523개, 원문 없음 0 (`_db.log`) |
| 추출일 | `db_objects.csv` 수정일 2026-10-16 |

## 카탈로그·분석 CSV

| 파일 | 내용 |
|---|---|
| `db_objects.csv` | SP, 함수, 뷰, 테이블, 트리거, 동의어 목록과 생성·수정일 |
| `db_module_refs.csv` | SP·함수·뷰 원문 ScriptDom 분석. 테이블별 SELECT/INSERT/UPDATE/DELETE/MERGE, EXEC, 함수, 임시테이블, 동적 SQL(주석 제외) |
| `db_code_branches.csv` | `IF @Code = 'X'`, `IN (...)` 분기별 참조 객체. 공통코드·API 디스패치 SP 해석용 |
| `db_params.csv` | SP·함수 파라미터 |
| `db_columns.csv` | 테이블·뷰 컬럼 |
| `db_indexes.csv` | 인덱스 |
| `db_dependencies.csv` | SQL Server 의존 관계 |
| `db_synonyms.csv` | 동의어 |
| `db_rowcounts.csv` | 테이블 행 수 |
| `db_resultsets.csv` | SP 결과셋 컬럼(`dm_exec_describe_first_result_set_for_object`, 실행 없음) |
| `db_meta_tables.csv` | 데이터까지 뽑은 메타 테이블 목록과 선정 이유 |
| `_db.log` | 추출 실행 기록 |

## 하위 폴더

| 폴더 | 내용 |
|---|---|
| `modules/` | SP·함수·뷰 원문 `.sql` (3,523개) |
| `meta/` | 메타 테이블 데이터 CSV (126개). 메타 SP(예: `*SPREAD_TITLE*`, 권한·공통코드 SP)가 읽는 테이블 + 설정의 메타 테이블 패턴 |
| `grid/` | Grid 단계: `*_SPREAD_TITLE` SP 를 Division × 시트별로 실행(ROLLBACK)한 결과와 안전 판정 `grid_sp_safety.csv` (68개) |
| `batch/` | 배치 관련: SQL Agent 작업·단계·일정, `ssp_int_systemexe` 실행 기록 요약. `_extract_log.md` 에 2026-11-09 추출 건수 |

화면 폴더의 `dbmeta_*.csv`, `grid_rule.csv`, `grid_diff.csv`, `grid_effective.csv` 는 Pack 이 이 폴더 결과를 화면별로 결합한 것입니다.
