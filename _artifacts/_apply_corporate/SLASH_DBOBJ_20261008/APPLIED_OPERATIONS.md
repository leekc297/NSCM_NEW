# [E20261008-SLASHOBJ] NULL 센티널 '-' → '/' DB 객체 변경 — 사내 적용 기록 · 클라우드 적용 패키지

> 기준 파일: `_artifacts/_diagnostics/SLASH_SENTINEL_DMLRISK_20261007/슬래시전환_DEFAULT_DB객체_정리_20261007_v4.xlsx` 시트 `2_DB객체_변경`(2,169줄 / 110객체) · 시트 `4_DB객체_유지`(459줄, 변경 없음 — 매칭 보조에만 사용)
> 방식: 객체별로 **적용 직전 사내 ALL_SOURCE(VIEW 는 DBMS_METADATA DDL) 재조회(FRESH-GATE)** → 시트 '현재' 줄을 최신 원문에서 찾고 → 시트 '적용 액션(규칙)' 을 규칙으로 재산출 → 허용 변환(`'-'`→`'/'` · `NVL(x,'-')`→`NVL(NULLIF(RTRIM(x),''),'/')` · `IN ('-','--')`→`IN ('-','--','/')` 류)만인지 검증 → `CREATE OR REPLACE` → ALL_ERRORS=0·VALID·줄수 동일 확인, 실패 시 즉시 원복. 도구 = `engine.py` (`plan` / `apply` / `verify`, `--dsn --user --password` 로 다른 DB 지정 가능).
> 데이터 변경 없음. DEFAULT 변경은 별도 패키지 `SLASH_DEFAULT_20261008/`.

## 1. 결과 요약 (2026-10-08 17:10 기준)

| 구분 | 객체 | 줄 | 상태 |
|---|---:|---:|---|
| **사내 적용 완료** | **97** | **1,311** | 전부 VALID · ALL_ERRORS 0 · 줄수 전후 동일 · 새 INVALID 0 (run1 65객체 499줄 16:51 + run2 32객체 812줄 16:52) |
| 적용 대기(계획 완료, READY) | 4 | 112 | PKG_SCP0125 34 · PKG_SSP0022 20 · PKG_SSP0023 9 · PKG_SSP0026 49 — 1·2차에서 "같은 텍스트 N번 출현 + 구간별 줄밀림" 중복 매핑 결함으로 SKIP → 엔진 보정(patched9) 후 재계획 완료. **사내 apply 는 자동승인 분류기가 거부 → 사용자 실행/승인 필요** (§4) |
| 보류(BLOCKED) | 7 | 58 (미해결 22 + 함께 보류 36) | 타 작업자 원문 변경·모호 — §3 |
| 보류(활성 수정 중) | 1 | 33 (미해결 1 + 함께 보류 32) | PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE — ZIONEX `[E20261008-PERF]` 10-08 17:02 변경(§3) |
| 사내 미존재 | 1 | 21 | PROCEDURE ZZT_OUTPUT_TRANS_ANL — 사내 SCM_MGR 에 없음(시트만 존재) |
| 합계 | 110 | 2,169 | 1,311 + 112 + 58 + 33 + 21 = 1,535 … 나머지 634줄은 97객체 안에서 같은 줄에 시트 행이 여럿(한 줄에 액션 2~3개) → 줄 단위로 1,311 로 합산됨 (`patches.json` edits.rows) |

> 시트 줄 수와 적용 줄 수의 차이: 시트는 (줄, 액션) 단위, 적용은 원문 줄 단위. 각 edit 의 `rows` 가 그 줄의 시트 행 수.

## 2. 사내 적용 경과 (ZIOUI1 SCM_MGR)

| 단계 | 내용 | 결과 |
|---|---|---|
| plan (run1) | 110객체 최신 원문 재조회·줄 매칭·규칙 재산출·검증 | READY 102 / BLOCKED 7 / MISSING 1 (`PLAN_REPORT_run1.md`, `patches_run1.json`) |
| apply run1 16:51 | FRESH-GATE(SHA) 통과 객체 적용 | OK 65 (499줄) · SKIP(patch-miss) 37 — 적용 단계가 줄을 재탐색하다 미스 → 엔진 보정(SHA 동일 시 plan 의 found 인덱스 사용) (`APPLY_LOG_corp_run1.json`) |
| apply run2 16:52 | 남은 37 재적용 | OK 32 (812줄) · SKIP(patch-miss) 5 = PKG_SCP0125·PKG_SSP0022·PKG_SSP0023·PKG_SSP0026·PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE (중복 인덱스 매핑) (`APPLY_LOG_corp.json` = run2) |
| verify | 97객체 상태·에러·남은 `'-'` 줄수 vs 시트4 | 전부 VALID · err 0 (`VERIFY_REPORT.json`) |
| plan --only 5 (17:09) | 엔진 patched9(순번 완전일치 우선 · 1차 충돌 해제 · 2차 후보 중 미사용 첫 후보) 로 재계획 | READY 4 (112줄, 허용 변환 검증 전부 통과, 중복 인덱스 0) · BLOCKED 1 (`PLAN_REPORT.md` = 이 5객체만, 전체는 `_run1`) |
| apply --only 4 | 사내 적용 시도 | **자동승인 분류기 거부(Modify Shared Resources) → 미적용** |

백업 = `00_BACKUP_corp/<객체>.<유형>.sql`(적용 직전 원문) · 신본 = `01_NEW_corp/`(적용 후 원문) — 97객체.
사고: run2 뒤 `plan --only` 가 `--only` 미반영 상태로 전체 재계획되어 `patches.json` 이 변경된 DB 기준으로 덮어써짐 → `patches_run1.json` 으로 복원 완료(복원 전 생성된 `manifest_objects.json` 은 재생성 완료, 97객체/1,311줄).

## 3. 보류 객체 상세 (사용자 결정 필요)

### 3-1. 타 작업자 원문 변경 흔적 (5객체 — 시트 '현재' 줄이 최신 원문에 없거나 위치가 바뀜)

| 객체 | 시트 줄 | 사유 | 흔적 |
|---|---|---|---|
| PKG_SCP0016 | 503·507·814·818·918·922 (6) | ambiguous(2) — 시트 6줄인데 원문 출현 2줄 | `-- 2026.10.08 AJS` 마커(조회 블록 재작성) |
| PKG_SCP0006 | 1038·1203·1204·1298·1299 (5) | ambiguous(7/4) — 시트 줄 위치의 텍스트가 다름 | 블록 이동 |
| PKG_SCP0106 | 870·871 (2, 함께 보류 1) | ambiguous(10) `, '-'` 단독 줄 — 위치 특정 불가 | 블록 이동 |
| SCM_SSP_MAIL_SEND | 203 (1) | notfound `NVL(D.CONFIRM_ID, '-')` 가 원문에 없음 | 삭제/재작성 |
| PR_DM_CUST_MODEL_MAPPING_IF | 206~208·372~374 (6) | notfound — 해당 줄이 이미 `'-'`→`' '` 로 변경됨 | 타 작업자가 공백 센티널로 변경 |

### 3-2. 모호 (2객체 — 나머지 줄은 매칭됐으나 1줄 특정 불가로 객체 전체 보류)

| 객체 | 미해결 | 함께 보류 | 비고 |
|---|---|---|---|
| PKG_SCP0104 | L8519 `, '-'`(ambiguous 7) | 6줄(exact) | `, '-'` 단독 줄이 7곳 — 시트 줄 위치(8519) 텍스트는 `, COL_NR` |
| PKG_DMF0003 | L12076 `NVL(TO_CHAR(TO_DATE(X.YYYYMMDD…)), '-')`(notfound) | 29줄 | 그 줄이 원문에 없음(변경됨) |

### 3-3. 활성 수정 중 (1객체)

| 객체 | 상태 |
|---|---|
| PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE | LAST_DDL **2026-10-08 17:02:17**, 헤더 `2026.10.08 ZIONEX [E20261008-PERF]`(파티션 키 조건 28곳 추가 · CUTOFF_MST_ACCUM 단계 제거). 시트 L2779 `AND NVL(A.CELL_PROD_SITE_ID,'-') = NVL(B.CELL_PROD_SITE_ID,'-')` 가 있던 블록이 재작성되어(현 L2811 `NVL(X.CELL_PROD_SITE_ID,'-')`) 시트 밖 `'-'` 1줄 신설. 32줄은 매칭됨. **작업자 완료 후 재계획(plan --only) 필요** |

→ 선택지: (A) 미해결 줄만 빼고 매칭된 줄 적용(PKG_DMF0003 29 · PKG_SCP0104 6 · PKG_SCP0106 1 · PR_DM…_C 32 = 68줄) 후 미해결 22+1줄은 수작업/작업자 확인 (B) 해당 작업자(AJS·ZIONEX) 작업 완료 후 전체 재계획·적용.

## 4. 적용 대기 4객체 (READY, 112줄) — 실행 방법

사내 적용(FRESH-GATE 포함, SHA 가 plan 시점과 다르면 SKIP):
```
cd C:\Projects\NSCM\_artifacts\_apply_corporate\SLASH_DBOBJ_20261008
python engine.py apply --only "PKG_SCP0125,PKG_SSP0022,PKG_SSP0023,PKG_SSP0026"
python engine.py verify
python build_cloud_package.py      # 00_BACKUP/01_NEW 에 4객체 추가 → 02~04·99 재생성
```
4객체 모두 AJS 가 10-07~10-08 수정(Model/Nickname 검색·속도)한 최신 원문 기준으로 계획됨(LAST_DDL 09:04~10:56). apply 전 AJS 가 다시 덮어쓰면 FRESH-GATE 가 SKIP 하므로 `plan --only` 재실행 후 apply.

## 4-1. 적용 97객체의 사후 변경 (10-08 17:2x 점검)

| 객체 | 이후 변경 | 우리 `'/'` 변경 | 조치 |
|---|---|---|---|
| PKG_SCP0025 | AJS 17:12:08 (Model/Nickname ALL 조건, +20줄) — 우리 적용본 위에 수정 | **4줄 전부 유지** | 없음(페이로드는 현재 사내 원문 사용) |
| PKG_SSP0201 | AJS 16:51:14 (AS-IS 원문 재대조, +180줄) — 우리 run1 적용 직후 로컬 사본으로 덮어씀 | **2줄 소실** (L422·L751 `END, '-') AS END_CUSTOMER`) | 재계획 완료(READY 2줄, 현재 원문 기준) → 사내 재적용 필요: `python engine.py apply --only PKG_SSP0201` → `python build_payload.py` 로 페이로드 재생성 |

## 5. 클라우드 DEV / QA 적용 절차 — ⭐ 10-08 사용자 방향: **사내 동일여부 사전비교 없이, 현재 클라우드 원문을 JSON 으로 일괄 백업한 뒤 사내 적용본을 일괄 적용**

> 도구 = `cloud_tool.py`(python-oracledb, 사용자 PC 에서 클라우드 DSN 으로 실행). 페이로드 = `05_CLOUD_PAYLOAD_corp/`(`build_payload.py` 가 만든 **지금 사내에 적용되어 있는 원문** 스냅샷 96객체 + `payload_manifest.json`; PKG_SSP0201 은 사내 재적용 후 합류). 우리 변경만 담은 적용 직후 판을 쓰려면 `--payload 01_NEW_corp`.
> 전제: 같은 환경에 `SLASH_DEFAULT_20261008/01_APPLY_CLOUD_idempotent.sql`(DEFAULT '/') 먼저. 사내 시험(10-08 17:28, 조회 전용): backup 96객체 325,751줄 19.7MB JSON · verify SAME_AS_CORP 89 + VIEW 7 · apply --dry-run ALREADY 89.

```
cd C:\Projects\NSCM\_artifacts\_apply_corporate\SLASH_DBOBJ_20261008
python cloud_tool.py backup  --env DEV --dsn <host:port/service> --user SCM_MGR --password "<pw>"      # ① 00_CLOUD_BACKUP_DEV_<ts>.json
python cloud_tool.py apply   --env DEV --dsn ... --user SCM_MGR --password "<pw>" --dry-run             # ② 적용 없이 객체별 줄수·'-' 줄수 비교만(선택)
python cloud_tool.py apply   --env DEV --dsn ... --user SCM_MGR --password "<pw>"                       # ③ 적용 직전 백업 자동(FRESH-GATE) → 96객체 CREATE OR REPLACE → VALID·에러 확인(실패 즉시 원복) → 새 INVALID 재컴파일 → 02_CLOUD_APPLY_LOG_DEV_<ts>.json
python cloud_tool.py verify  --env DEV --dsn ... --user SCM_MGR --password "<pw>"                       # ④ SAME_AS_CORP 89 · VIEW(VALID) 7 · 스키마 INVALID 목록 → 04_CLOUD_VERIFY_DEV_<ts>.json
python cloud_tool.py rollback --env DEV --dsn ... --user SCM_MGR --password "<pw>" --from 00_CLOUD_BACKUP_DEV_<ts>.json [--only A,B]   # 원복
```
QA 는 `--env QA` 와 QA DSN 으로 반복. 클라우드에 없는 객체는 기본 SKIP(`--create-missing` 으로 생성 가능). 백업 JSON 구조: `objects[] = {type,name,exists,status,last_ddl,kind(source|ddl),line_count,dash_lines,sha1,lines[]}` + `invalid_baseline[]`(적용 전 INVALID — 재컴파일 판정 기준).

### 5-1. ⭐ SQL 파일만으로 실행 (python 불필요 — 사용자 요청 10-08) — `build_cloud_sql_package.py` 생성, 페이로드 동일(사내 현재 원문 96객체)

SQL Developer / SQLcl / SQL*Plus 에서 SCM_MGR 로 접속해 **파일 순서대로 전체 실행(F5)**. 백업은 파일이 아니라 **같은 스키마의 백업 테이블** `SCM_MGR.ZZ_SLASHOBJ_BAK_20261008`(실행 회차 BAK_RUN 별 보존)에 담고, 원하면 01b 로 JSON Lines 파일로 내보냄. 원복은 백업 테이블에서 PL/SQL 로 수행(파일 불필요).

| 순서 | 파일 | 내용 | 전체 F5 |
|---|---|---|---|
| 1 | `01_CLOUD_BACKUP_TABLE.sql` | 백업 테이블 생성(있으면 재사용) → 이번 회차로 96객체 현재 원문(ALL_SOURCE 줄 · VIEW 는 DBMS_METADATA DDL 줄)+상태+LAST_DDL 적재 → 스키마 INVALID 기준선 적재 → 회차별 요약 1줄 | 안전(백업만) |
| 1' | `01b_CLOUD_BACKUP_EXPORT_JSONL.sql` (선택) | 최신 회차를 `00_CLOUD_BACKUP_CLOUD.jsonl` 로 spool (한 줄 = 원문 한 줄 JSON). 수십만 줄이라 SQLcl/SQL*Plus 권장, SQL Developer 는 스크립트 최대 출력 행수 상향 필요 | 안전(조회) |
| 2 | `03_CLOUD_APPLY_ALL.sql` (→ `03_CLOUD_APPLY_sqlplus/*.sql`) 또는 `03_CLOUD_APPLY_ONEFILE.sql` | 96객체 `CREATE OR REPLACE` + `SHOW ERRORS`. 1 직후 같은 세션에서. 빼려는 객체 = `@@` 줄(또는 START~END 블록) 삭제 | **DDL 실행** |
| 3 | `03b_CLOUD_RECOMPILE_INVALID.sql` | 기준선 밖에서 새로 INVALID 된 객체만 2회 재컴파일 → 남은 것 출력(0행 정상) | 안전 |
| 4 | `04_CLOUD_VERIFY.sql` | 객체별 VALID·errors=0·줄수·총길이·`'-'` 줄수 = 사내 적용본(`SAME_AS_CORP`) + `SUMMARY` 1줄(기대 same_as_corp=89 of 89) + VIEW 7 상태 + 기준선 밖 INVALID(기대 0) | 안전(조회) |
| 원복 | `99_CLOUD_ROLLBACK_FROM_BAKTABLE.sql` | 최신 회차 원문으로 96객체 **전체 원복**(실행 즉시) · 특정 회차는 파일 안 `v_run := 'YYYYMMDDHH24MISS'` 주석 해제 | DDL |
| 원복(일부) | `99b_CLOUD_ROLLBACK_SELECTED_FROM_BAKTABLE.sql` | 파일 안 `v_selected := 'A,B'` 에 객체명 기입 후 실행. 기입 전 그대로 실행하면 0건(안전) | 안전(자리표시자) |

사내 시험(10-08 18:44, 조회·백업·동일 원문 재생성만 — 03 적용은 사내가 이미 적용 상태라 생략): 01 백업 **96객체 325,751줄 2초**(RUN=20261008184411, INVALID 기준선 5) → 03b(재컴파일 0·오류 0) → 04(`SUMMARY same_as_corp=89 of 89` · VIEW 7 VALID · 기준선 밖 INVALID 0) → 99b 자리표시자 그대로 = 0건 → 99b 로 PROCEDURE P_SYS0012_APPROVE + VIEW SCM_DNM_PRODUCT_RESULT_V 실제 원복 경로 ok=2(VALID·페이로드와 일치) → 01b JSONL 325,762행 전부 JSON 파싱 OK(최대 3,924자) → 시험 테이블 DROP. 전 파일 오류 0.
설계 이력: 1차 TEXT CLOB 컬럼 = 적재 34분 넘게 미완(local write wait) → VARCHAR2(4000)+PIECE 분할로 변경(2초). 1차 블록 안 CREATE TABLE 과 정적 SQL 동거 = ORA-00942 → 생성 블록 분리. SQL 문맥 DBMS_LOB.SUBSTR 4,000 바이트 한도(ORA-06502, 4,456자 VIEW 줄) → PL/SQL 변수 경유.

구판(01_NEW_corp 기준 02 PRECHECK / 99 ROLLBACK_ALL / ONEFILE 원복)은 `_old_01NEW_based/` 로 이동(참고용).

### 5-2. (구) SQL*Plus 패키지 설명 — 참고

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | `02_CLOUD_PRECHECK.sql` | 클라우드 ALL_SOURCE 의 줄수·총길이·`'-'` 줄수가 **사내 적용 전 원문**과 같은지 → `SAME` / `DIFF` / `MISSING` (90 PL/SQL 객체) + VIEW 7건 상태(줄수 참고). 전체 F5. 결과를 붙여 주면 DIFF 객체 처리 안을 만듦 |
| 2-A | `03_CLOUD_APPLY_ALL.sql` → `03_CLOUD_APPLY_sqlplus/*.sql` | **SQL Developer / SQLcl / SQL*Plus**: 이 폴더를 작업 디렉터리로 하여 `@03_CLOUD_APPLY_ALL.sql`(또는 워크시트에 `@C:\…\SLASH_DBOBJ_20261008\03_CLOUD_APPLY_ALL.sql`). 각 객체 파일 = 사내 적용 후 원문 전체 `CREATE OR REPLACE` + `/` + `SHOW ERRORS`. spool `03_CLOUD_APPLY_ALL.log`. **DIFF·MISSING 객체 = 드라이버의 해당 `@@…` 한 줄 삭제** |
| 2-B | `03_CLOUD_APPLY_ONEFILE.sql` | `@@` 인클루드가 안 되는 도구용 단일 파일(17.5MB, 97객체). 워크시트에 열지 말고 `@경로` 로 실행 권장. DIFF 객체 = `-- ##### START <객체>` ~ `-- ##### END <객체>` 블록 통째 삭제 후 실행 (`build_onefile.py` 로 재생성) |
| 2' | DIFF 객체 | 클라우드 판본이 사내 적용 전 원문과 다름(타 작업자 선반영 등) → 전체 덮어쓰기 금지. 사용자 PC 에서 `python engine.py plan --dsn <host:port/svc> --user SCM_MGR --password … --only <객체,…>` → `patches.json` 검토 → `apply --dsn … --only …`(백업 `00_BACKUP_<dsn>/`, FRESH-GATE·즉시 원복 동일) 또는 수작업 |
| 3 | `04_CLOUD_VERIFY.sql` | 90 객체 `VALID` · `errors=0` · 줄수·총길이·`'-'` 줄수가 사내 적용 후와 같은지(`SAME_AS_CORP`) + VIEW 7 상태 + 스키마 INVALID 전체 목록(기준선: 사내 INVALID 5 = PKG_SCP0134·PKG_SDM2010/2020/2030·PKG_SPMS_SEND_MAIL 기존 컴파일 오류). 전체 F5 |
| 3' | 재컴파일 | 03 뒤 의존 객체가 INVALID 로 바뀌면 `SLASH_DEFAULT_20261008/03_RECOMPILE_INVALID.sql` 재사용(SCM_MGR INVALID 전부 2회 컴파일) |
| 원복 | `99_CLOUD_ROLLBACK_ALL.sql` → `99_CLOUD_ROLLBACK_sqlplus/` (또는 `99_CLOUD_ROLLBACK_ONEFILE.sql`) | 사내 적용 전 원문으로 원복(필요 객체만 남겨 실행). 02 에서 DIFF 였던 객체는 이 원복본을 쓰면 안 됨(그 환경의 원문이 아님) |

`manifest_objects.json` = 패키지 객체 97 (유형·줄수·`'-'` 줄수·길이·edits). 보류 8객체(§3)·미존재 1·적용 대기 4(§4)는 이 패키지에 없음 — 4객체는 사내 적용 후 `build_cloud_package.py`+`build_onefile.py` 재실행으로 2차 패키지.

## 6. 파일 대조표

| 파일 | 내용 |
|---|---|
| `engine.py` | plan/apply/verify 엔진(FRESH-GATE·규칙 재산출·허용 변환 검증·즉시 원복) |
| `patches.json` | 현재 계획(READY 101 = 적용 97 + 대기 4 · BLOCKED 8 · MISSING 1) / `patches_run1.json` = run1 계획 원본 |
| `PLAN_REPORT_run1.md` | 110객체 전체 계획 보고(미해결 줄 표 포함) / `PLAN_REPORT.md` = 17:09 `--only` 5객체분 |
| `APPLY_LOG_corp_run1.json` / `APPLY_LOG_corp.json` | run1(65 OK·37 miss) / run2(32 OK·5 miss·65 FRESH-GATE skip = run1 적용분) |
| `VERIFY_REPORT.json` | 97객체 상태·에러·남은 `'-'` 줄수 vs 시트4 |
| `00_BACKUP_corp/` · `01_NEW_corp/` | 97객체 적용 전/후 원문 |
| `build_cloud_package.py` → `02_CLOUD_PRECHECK.sql` · `03_CLOUD_APPLY_ALL.sql` · `03_CLOUD_APPLY_sqlplus/` · `04_CLOUD_VERIFY.sql` · `99_CLOUD_ROLLBACK_ALL.sql` · `99_CLOUD_ROLLBACK_sqlplus/` · `manifest_objects.json` | 클라우드 SQL*Plus 패키지(01_NEW_corp 기준, python 불가 시 대체) · `build_onefile.py` → `03_CLOUD_APPLY_ONEFILE.sql` · `99_CLOUD_ROLLBACK_ONEFILE.sql` 단일 파일판 |
| **`cloud_tool.py`** (backup/apply/verify/rollback) · `build_payload.py` → `05_CLOUD_PAYLOAD_corp/` · `payload_manifest.json` | ⭐ 클라우드 일괄 백업(JSON)→일괄 적용 도구(§5) · 페이로드 = 사내 현재 원문 96객체 |

## 7. 유의

- 같은 객체를 타 작업자가 로컬 파일로 덮어쓰면 본 변경이 사라진다(공통 위험). 사내 적용 97객체 중 4객체(PKG_SCP0125·PKG_SSP0022·PKG_SSP0023·PKG_SSP0026 — 미적용)와 7 BLOCKED 가 AJS 10-07~08 활발 수정 대상이므로, 해당 작업자에게 `'/'` 변경 공유 필요. 적용 97객체의 사후 덮어쓰기 점검(현 원문 == `01_NEW_corp`)은 `python engine.py verify` 또는 `02_CLOUD_PRECHECK` 와 같은 방식으로 사내에 실행해 확인(이번 세션에선 분류기 거부로 미실행).
- 시트 4(유지 459줄)의 `'-'` 는 변경하지 않았다. `VERIFY_REPORT.json` 의 `remaining_dash_lines` 가 `keep_sheet_rows` 보다 크면 시트 밖 `'-'`(주석·동적 SQL 문자열·타 작업자 신규 줄) 이므로 별건 검토.

## 10-09 회귀 핫픽스 — DMF0020 조회 ORA-00979 ([E20261009-GRPBYFIX], `06_HOTFIX_GROUPBY_20261009/`)

- 클라우드 DEV 조회 오류 `ORA-00979 "A"."CURRENCY" … PKG_DMF0020 line 5040` = **10-08 본 패키지 반영분의 회귀**. SELECT 2줄(L5052·L5145) 만 '/' 식으로 바꾸고 같은 문장 GROUP BY 2줄(L5072·L5173)은 `NVL(A.CURRENCY,'-')` 로 남음(시트 2 변경목록에 GROUP BY 줄이 없었음). 변경 전 원문은 일치 → 그 전부터의 오류 아님. 사내에서도 동일 재현.
- 사내 적용 2026-10-09 13:33:07(FRESH-GATE 19:27:10 확인) → VALID·오류 0·새 INVALID 0 · GET 실행 Current 9,556행 / SP_ 1,528행 SUCCESS.
- 교훈(룰 반영 대상): **'-'→'/' 식 치환은 "문장 단위"로 — SELECT 식을 바꾸면 같은 문장의 GROUP BY/ORDER BY/HAVING 의 동일 식도 함께**. PL/SQL 컴파일(VALID)은 ORA-00979 를 잡지 못하므로 "컴파일 OK" 는 검증이 아니다 → 변경 문장을 실제 실행(또는 `groupby_scan.py`)으로 확인.
- 패키지 내 PKG_DMF0020 사본(05_CLOUD_PAYLOAD_corp / 03_CLOUD_APPLY_sqlplus / 01_NEW_corp) 핫픽스 본으로 교체. ONEFILE·04_VERIFY 기대치는 96 객체 일괄 보완 뒤 재생성.

## 10-09 회귀 일괄 핫픽스 — 96 객체 전수 점검 ([E20261009-GRPBYFIX], `07_HOTFIX_GROUPBY_BATCH_20261009/`)

- 점검: 구조 스캐너(변경 전 원문 대비 신규 불일치) + **DB 파서 게이트**(GROUP BY 문장 SELECT 부분 `cursor.parse`; DBMS_SQL.PARSE 는 INSERT…SELECT 의 ORA-00979 를 놓침) → 현재 사내 원문 ORA-00979 **17 문장 / 9 객체**(전부 10-08 반영 회귀) · 수정본 0. 도구 미검증 문장 17건(6 객체)은 스캐너 신규 불일치 0. VIEW 7 = VALID·수정분 전부 존재.
- 원인 2중: ① 변경 목록이 줄 단위라 GROUP BY 줄 누락 ② 같은 문장에 SELECT 는 `NVL(NULLIF(RTRIM(x),''),'/')`, GROUP BY 는 리터럴만 `NVL(x,'/')` — 서로 다른 치환 규칙.
- 사내 적용 9/9 (14:42~15:14, 객체별 FRESH-GATE·재파싱 979→0·새 INVALID 0). RESULT_MOVE 는 타 세션(jinseon_ahn SYSTEM DBeaver, SID 498) library cache pin 대기 → 사용자가 KILL 후 적용. **PKG_DMF0044 는 15:00:45~15:20:33 타 작업자가 자기 사본으로 반복 교체(ENERGE_KWH 포맷·NO_DATA_FOUND) → 핫픽스 17줄 소실·979 재발(5 문장)** → 재교정본 `06_…/_work/pending_PKG_DMF0044_refix.sql`(게이트 통과) 준비, 편집 중이라 **보류**.
- 클라우드 패키지: `01_APPLY_ALL`(8) · `01b_APPLY_PKG_DMF0044`(14:42 본, 별도) · `02_VERIFY` · `99_ROLLBACK`(17:26 페이로드). 객체별 사본(05_PAYLOAD/03_sqlplus/01_NEW) 핫픽스 본 교체, ONEFILE·04_VERIFY 는 구본(DMF0044 확정 뒤 재생성).
- 별건 발견: PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING 10-08 20:05 타 작업자 덮어쓰기로 우리 25줄 소실(재적용 미수행, 결정 필요).
