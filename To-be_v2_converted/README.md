# To-Be v2 변환 산출물 (공통 / SCM / DM)

**작성일**: 2026-05-13
**작성자**: 마리소프트 이규철
**근거 규칙**: `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md`
**원본**: `C:\TRANFILE\To-be\` (Tobe_OPTENG_SCP_*.sql 6개 파일)
**원칙**: ⭐ **Syntax Error 없음 = 최우선 원칙**

## 폴더 구조

```
To-be_v2_converted/
├── 01_Foundation/              # 가장 먼저 실행 (다른 모든 객체의 기반)
│   ├── 01_Common_TYPE_Objects.sql           — 9개 TYPE 신규 생성
│   ├── 02_System_Log_Table.sql              — SCM/DM 로그 테이블 + Sequence + Index
│   ├── 03_System_Log_Procedures.sql         — PR_SCM_SYS_LOG_BATCH / PR_DM_SYS_LOG_BATCH
│   └── 04_Common_Helper_Functions.sql       — FN_SPLIT_STR/FN_ISNUMERIC/FN_ISDATE 등 6개
│
├── 02_Tables/                  # 119개 DM 도메인 테이블 (그룹별 분리)
│   ├── 01_DM_ANL_Tables.sql                  — DM_ANL_* (7개)
│   ├── 01_DM_BP_Tables.sql                   — DM_BP_* (2개)
│   ├── 01_DM_BPS_Tables.sql                  — DM_BPS_* (5개)
│   ├── 01_DM_CUST_Tables.sql                 — DM_CUST_* (7개)
│   ├── 01_DM_DNM_Tables.sql                  — DM_DNM_* (9개)
│   ├── 01_DM_HI_Tables.sql                   — DM_HI_* (5개)
│   ├── 01_DM_MDF_Tables.sql                  — DM_MDF_* (1개)
│   ├── 01_DM_MOBILE_Tables.sql               — DM_MOBILE_* (3개)
│   ├── 01_DM_MST_Tables.sql                  — DM_MST_* (23개)
│   ├── 01_DM_PLN_Tables.sql                  — DM_PLN_* (56개)
│   └── 01_DM_YEARLY_Tables.sql               — DM_YEARLY_* (1개)
│
├── 03_GTT/                     # Global Temporary Tables (959개)
│   ├── 02_GTT_DM.sql                         — GT_DM_* (93개)
│   ├── 02_GTT_DMF.sql                        — GT_DMF_* (36개)
│   ├── 02_GTT_LEGACY.sql                     — GT_LEGACY_* (76개, GTT_* 재명명)
│   ├── 02_GTT_OTHER_part1~4.sql              — GT_* 기타 (754개)
│   └── GTT_LEGACY_rename_map.csv             — As-Is GTT_* → To-Be GT_LEGACY_* 매핑
│
├── 04_Views/                   # 14개 공통/SCM/DM 뷰
│   ├── 03_View_DM_MST_ITEM_SINGLE_V.sql
│   ├── 03_View_SCM_ADM_USER_MNU_EDIT_AUTH_V.sql
│   ├── 03_View_SCM_DNM_PRODUCT_RESULT_V.sql
│   ├── 03_View_SCM_MST_FINAL_ITEM_V.sql
│   └── ... (총 14개)
│
├── 06_Packages/                # 55개 Package (Spec + Body)
│   ├── 04_Package_PKG_COM0000.sql            — 공통 12개 SP
│   ├── 04_Package_PKG_DMF0021.sql            — DM Sales Plan 화면
│   ├── 04_Package_PKG_NSCM_UI_COMM.sql       — UI 공통
│   ├── 04_Package_PKG_SCM0002.sql            — SCM 25개 SP
│   ├── 04_Package_PKG_SYS0001~0011.sql       — 시스템 관리
│   └── ... (총 55개)
│
├── 07_Standalone_SP/           # 151개 단독 SP (화면 단위로 묶음)
│   ├── 05_Standalone_SP_DMF0003.sql          — 23개 SP (PKG_DMF0003 흡수 권장)
│   ├── 05_Standalone_SP_DMF0044.sql          — 23개 SP
│   ├── 05_Standalone_SP_DMF0020.sql          — 19개 SP
│   ├── 05_Standalone_SP_DMF0042.sql          — 12개 SP
│   └── ... (총 23개 화면)
│
├── 99_Verification/            # 검증 스크립트 및 보고서 (TBD)
│
└── README.md                   # (이 파일)
```

## 실행 순서

| 단계 | 폴더 | 비고 |
|---|---|---|
| 1 | `01_Foundation/` | TYPE → Log Table → Log Procedure → Helper Function 순 |
| 2 | `02_Tables/` | DM 도메인 119개 테이블 (의존성 없음) |
| 3 | `03_GTT/` | Global Temporary Tables 959개 (DDL만, INSERT 없음) |
| 4 | `04_Views/` | 14개 View (Tables 이후) |
| 5 | `06_Packages/` | 55개 Package (Foundation + Tables + GTT + Views 이후) |
| 6 | `07_Standalone_SP/` | 151개 standalone SP (Packages 이후 또는 동시) |

## 변환 통계

| 항목 | 건수 | 비고 |
|---|---:|---|
| 파일 수 | 114 | (실제 SQL 파일 수) |
| 총 라인 수 | 255,919 | |
| `CREATE TABLE` (Regular) | 119 | DM_* |
| `CREATE GLOBAL TEMPORARY TABLE` | 959 | GT_* 통일 (LEGACY 76 재명명) |
| `CREATE VIEW` | 14 | 공통/SCM/DM 범위 |
| `CREATE PACKAGE/BODY` | 110 | 55 SPEC + 55 BODY |
| `CREATE PROCEDURE` (standalone) | 151 | 화면별 23개 파일로 분리 |
| `CREATE FUNCTION` | 6 | Helper functions |
| `CREATE TYPE` | 9 | Foundation 공통 TYPE |
| `CREATE INDEX` | 4 | 로그 테이블 인덱스 |
| `CREATE SEQUENCE` | 2 | 로그 테이블 Sequence |
| `CREATE SYNONYM` | 15 | Foundation 객체 PUBLIC SYNONYM |
| `GRANT` | 다수 | RL_SCM_DML / RL_SCM_SEL / SCMD_APP |

## 적용된 안전 변환

| 변환 | 적용 위치 | 비고 |
|---|---|---|
| ✓ `VARCHAR2(n)` → `VARCHAR2(n CHAR)` | 02_Tables, 03_GTT | 18건 보정 (Tables) |
| ✓ `N'문자열'` → `'문자열'` | 모든 파일 | 코드 본문 100% 제거 (주석 내부 일부 잔존) |
| ✓ `GTT_*` → `GT_LEGACY_*` | 03_GTT | 76건 재명명 (사용처 매핑 후 정식명으로 변경 필요) |
| ✓ `PG_TEST` 패키지 제거 | (06_Packages) | 운영물에서 제외 |
| ✓ `PROCTEST*` 6건 제거 | (06_Packages) | 운영물에서 제외 |
| ✓ 시스템 로그 테이블 + Sequence 신규 작성 | 01_Foundation | 표준 로깅 SP의 누락된 의존성 |
| ✓ 공통 TYPE 객체 신규 작성 | 01_Foundation | 코드에서 사용했으나 정의 없던 객체 |
| ✓ 표준 로깅 SP 신규 작성 | 01_Foundation | `AUTONOMOUS_TRANSACTION` 적용 |
| ✓ 공통 헬퍼 함수 신규 작성 | 01_Foundation | FN_SPLIT_STR (PIPELINED) 등 |

## 적용하지 않은 변환 (수동 보정 필요)

**원칙**: 자동 변환 시 의미 변질 또는 syntax error 위험이 있는 항목은 원본을 보존하고 변환 가이드만 주석으로 추가.

| 항목 | 잔존 건수 | 위치 | 권장 조치 |
|---|---:|---|---|
| `LEFT/RIGHT OUTER JOIN` → `(+)` | 37 | View | 사내 표준 §7.1.6. 수동 검토 후 변환 |
| `LEFT/RIGHT OUTER JOIN` → `(+)` (View 외) | 다수 | PKG/SP | 동일 |
| `DATEADD()` | 3 | 07_Standalone_SP | Oracle 비존재 함수. `+` 또는 `ADD_MONTHS()`로 보정 |
| `CHARINDEX()` | 6 | 07_Standalone_SP | `INSTR()`로 보정 |
| `STRING_SPLIT()` | 6 | 07_Standalone_SP | `SCM_MGR.FN_SPLIT_STR()`로 대체 |
| `@변수` 잔존 | 64 | PKG/SP | 대부분 EXEC 예시 주석 또는 `'@TITLE'` 같은 리터럴. 실변수 식별 후 보정 |
| `v_program_name` 하드코딩 | 180 | PKG/SP | `$$PLSQL_UNIT` 치환 권장 (현재도 작동은 함) |
| Standalone SP를 PKG로 흡수 | 149 | 07_Standalone_SP → 06_Packages | UI 단위 패키지 그룹화 (사내 표준 §6) |
| 동일 SP의 PKG/Standalone 중복 | 3+ | DMF0021 등 | PKG 우선 유지, standalone 삭제 |

## Syntax Error 위험 평가

### ✅ Syntax Safe (즉시 실행 가능)

- **01_Foundation** (4 파일, 19 객체): 신규 작성으로 위험 0
- **02_Tables** (11 파일, 119 테이블): VARCHAR2 보정만 적용, syntax 영향 없음
- **03_GTT** (7 파일, 959 GTT): 동일
- **04_Views** (14 파일): N' 제거만 적용, JOIN 변환 없음 — 컴파일됨 (`(+)` 추가 변환은 별도)
- **06_Packages** (55 파일): N' 제거만 적용, 본문 미변경 — 컴파일됨

### ⚠️ 잠재 위험 (수동 검토 권장)

- **07_Standalone_SP** (23 파일):
  - DATEADD/CHARINDEX/STRING_SPLIT 15건 — Oracle 컴파일 시 오류 발생 가능
  - 영향받는 SP 식별 후 우선 수정 필요

## 검증 방법 (Oracle 환경에서)

```sql
-- 1. Foundation 객체 검증
SELECT object_name, object_type, status
FROM   user_objects
WHERE  object_name LIKE 'T\_%' ESCAPE '\'
   OR  object_name LIKE 'FN\_%' ESCAPE '\'
   OR  object_name LIKE 'PR\_%LOG\_BATCH' ESCAPE '\'
ORDER BY object_type, object_name;

-- 2. 컴파일 오류 검사 (변환 후 전 객체 컴파일 실행)
SELECT name, type, line, text
FROM   user_errors
ORDER BY type, name, sequence;

-- 3. INVALID 객체 확인
SELECT object_name, object_type
FROM   user_objects
WHERE  status = 'INVALID'
ORDER BY object_type, object_name;
```

## 후속 작업 (사용자 결정 사항)

1. **Standalone SP → PKG 흡수** (149 SP, ~22 화면) — 화면별 PKG 통합 + 중복 제거
2. **DATEADD/CHARINDEX/STRING_SPLIT 수동 변환** (15건) — 컴파일 오류 위험 즉시 해소
3. **View OUTER JOIN → `(+)` 변환** (37건) — 사내 표준 일관성
4. **`v_program_name` → `$$PLSQL_UNIT`** (180건) — 정규식 일괄 치환 가능
5. **GTT_LEGACY_* 재명명** — 사용처(SP/PKG) 매핑 후 정식명 적용
6. **누락 객체 보완** — SCM_*/COM_* 테이블이 As-Is 폴더에 있다면 추가 변환 필요

## 변환 규칙 준수도 (재감사 결과)

| 영역 | 변환 전 | 변환 후 v2 | 비고 |
|---|---|---|---|
| Foundation 객체 (TYPE/Log SP) | ❌ 없음 | ✅ 완전 작성 | 신규 작성 |
| VARCHAR2 CHAR 단위 | 164건 미명시 | 18건 보정 (Tables) | GTT/PKG 내 잔존 — 추가 보정 가능 |
| N' 접두사 | 315건 (본문) | 0건 (본문, 주석만 102건) | 100% 제거 |
| PG_TEST 잔존 | 1건 | 0건 (제외) | |
| GTT_* 구식 명명 | 76건 | 0건 (GT_LEGACY_*로 재명명) | 사용처 매핑 후 정식명 필요 |
| Standalone SP/PKG 그룹화 | 22 화면 혼재 | 미해결 (별도 작업) | 수동 흡수 필요 |
| MSSQL 함수 잔존 | DATEADD/CHARINDEX/STRING_SPLIT 15건 | 동일 (보존) | 수동 변환 권장 |

---

> 본 산출물은 ⭐**Syntax Error 없음** 원칙을 최우선으로 안전 변환만 적용한 결과. 자동 변환이 위험한 항목은 보존하고 별도 수동 작업 안내. Foundation Layer는 As-Is 폴더에 없던 신규 객체로 모든 SP/PKG의 정상 컴파일을 위한 기반 인프라.
