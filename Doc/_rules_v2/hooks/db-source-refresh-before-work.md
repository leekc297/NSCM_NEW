# Hook #152 — db-source-refresh-before-work (DB 작업 = 새로고침한 최신 원문 기준 의무) ⭐ 실행 hook 동반

> **트리거**: Oracle DB 객체(PACKAGE/BODY/PROCEDURE/FUNCTION/VIEW/TRIGGER/TYPE)·메타 행을 **수정·재반영·원복·이관 패키지 작성**하는 모든 작업 (사내 ZIOUI1 · 클라우드 패키지 공통)
> **사용자 지시 (2026-09-15)**: "DB 작업 시 항상 새로고침 후 최신화 적용된 소스를 읽어서 작업 할 수 있도록 RULE 추가해주세요. 이 RULE 은 반드시 지켜져야할 HOOK 로"
> **강제 수단**: `.claude/hooks/check-db-fresh-source.ps1` (PostToolUse Write/Edit — 위반 시 exit 2 차단). 문서 hook + 실행 hook 이중.
> **상위 룰**: `anti-simplification.md` · 진입 `oracle-db-workflow.md` §1-0

---

## §1 원칙 (불변)

| # | 규칙 |
|---:|---|
| 1 | **작업 기준 원문 = 착수 시점에 DB 에서 새로 조회한 원문** (`ALL_SOURCE` / `DBMS_METADATA.GET_DDL` / 메타는 대상 행 `SELECT`). 동시에 `ALL_OBJECTS.LAST_DDL_TIME`·`STATUS` 를 기록한다. |
| 2 | ⛔ **로컬 사본을 기준으로 삼지 않는다** — `_apply_corporate/**` 백업·적용본, `_deploy_packages/**`, `db_object_census_*/sources`, 공통소스 저장소 SQL, 이전 세션/대화에서 읽은 내용, 에디터에 열린 파일. 이들은 **비교 대상**일 뿐이다. |
| 3 | **적용 직전 재조회 게이트(FRESH-GATE)** — CREATE OR REPLACE / MERGE 실행 바로 전에 DB 원문을 다시 읽어 **착수 시 기준본과 동일한지** 확인한다. 다르면 **즉시 중단** → 변경분(마커·diff) 확인 → 최신 원문 위에 내 변경만 다시 얹는다(3-way). 전체 덮어쓰기 금지. |
| 4 | 수정은 **최신 원문 위의 외과적 치환**(고유 매칭 assert)으로 한다. 과거 파일 전체를 CREATE OR REPLACE 로 되돌려 넣지 않는다. |
| 5 | 이관 패키지의 객체 파일은 **빌드 시점 DB 에서 추출**하고, 파일 머리에 `SOURCE-FRESH` 스탬프(객체·LAST_DDL·조회시각)를 남긴다. 24시간이 지난 패키지는 재빌드 후 전달한다. |
| 6 | 메타 행(EXCEL_COLUMNS·SHEET_COLUMNS·PROC_M·LOOKUP 등)도 동일 — 수정 전 대상 행 현재값을 새로 조회해 기록하고, 적용 직전 다시 조회해 다르면 중단. |
| 7 | 보고문에 **조회 DB·조회시각·LAST_DDL** 을 병기한다. 적용 후 LAST_DDL 이 내 적용 시각으로 바뀐 것까지 확인한다. |

## §2 왜 (실사고 — 전부 "기준 원문이 최신이 아니었다")

| 일시 | 객체 | 경위 | 결과 |
|---|---|---|---|
| 2026-09-09 15:59 | `PKG_DMF0040` (VERLABEL) | 선택 버전 표시 보완이 들어간 뒤, **구 사본 기준 전체 재컴파일**로 덮임 | 클라우드·사내 모두 `VERSION(A)/(B)` 로 회귀 · 로컬 SQL ERROR (09-15 재반영) |
| 2026-09-11 09:29 | `PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40` | 공통소스에 유입된 **08-18 구 사본**(`DMF0014_CLOUD_20260818`·census sources)으로 재컴파일 | `[E20260827-NLSDATE]` 소실 → NLS 따라 ORA-01861 (09-15 재반영) |
| 2026-09-14 14:10 | 사내 PDB 재생성 | DB 내용 시점 ≈ 10:24 로 되돌아감 | 그 사이 적용분 소실 — 적용 산출물 파일만 믿었으면 "반영됨"으로 오판 (`_BATCH_REAPPLY_20260914`) |
| 2026-09-14 17:12 | `PKG_DMF0074` | 타 작업자 `hook#150 (DEPT_ID)` 반영 | 09-15 클라우드 패키지를 **08-31 패키지 파일 기준**으로 만들었다면 hook#150 을 조용히 되돌렸을 것 — DB 재조회로 83줄 차이 발견 |

⇒ **파일은 자신이 최신인지 증명하지 못한다.** DB 에는 감사/DDL 트리거가 없어(ZIOUI1) 덮어쓴 뒤에는 추적도 어렵다. 유일한 방어는 "작업할 때마다 DB 를 새로 읽고, 적용 직전 한 번 더 읽는 것" 이다.

## §3 절차 (의무)

### §3.1 착수 — 새로고침
```python
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", ...)
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", ...)
base = "".join(r[0] for r in cur.fetchall())          # ← 이것만 기준본
(backup_dir / f"{name}.ASIS.sql").write_text(ddl(base))  # 원복용 백업 = 방금 조회본
```
- 로컬에 같은 객체 파일이 있으면 **base 와 diff** 해서 차이를 먼저 보고한다(누가 무엇을 바꿨는지 = 마커·LAST_DDL 로 추적, `feedback_corp_pkg_overwrite_trace_method`).

### §3.2 수정 — 최신 원문 위 외과 치환
```python
assert base.count(OLD) == 1, "대상 매칭 != 1 — 원문이 바뀌었거나 이미 반영됨"
tobe = base.replace(OLD, NEW)
```

### §3.3 적용 직전 — FRESH-GATE (생략 금지)
```python
# FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
now = fetch(cur, owner, name, typ)
assert ddl(now) == ASIS.read_text(encoding="utf-8"), "FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합"
cur.execute(tobe_ddl)
```
- 적용 후: `STATUS=VALID` · `ALL_ERRORS 0` · 적용본 == DB 원문 · LAST_DDL 갱신 · 의존 INVALID 0.

### §3.4 이관 패키지 (클라우드)
- 빌더가 DB 에서 직접 추출(`build_package.py` 패턴) — 기존 패키지 폴더 파일 복사로 만들지 않는다.
- 객체 파일 머리 스탬프 (실행 hook 검사 대상):
  ```sql
  -- SOURCE-FRESH: SCM_MGR.PKG_DMF0074 PACKAGE BODY LAST_DDL=2026-09-14 17:12:53 FETCHED=2026-09-15 16:40 DB=ZIOUI1
  ```
  신규 객체(사내에도 없음): `-- SOURCE-FRESH: NEW-OBJECT SCM_MGR.<NAME> <TYPE> FETCHED=<조회시각> DB=ZIOUI1` (ALL_OBJECTS 부재 확인 시각)
- 클라우드는 직접 조회 불가 → `00_PRECHECK`(마커 기대/클라우드 전용 마커) 로 **클라우드 현재 원문**을 판정하게 한다(전체교체 여부는 그 결과로 결정).

## §4 실행 hook — `check-db-fresh-source.ps1` (PostToolUse Write/Edit/MultiEdit, exit 2)

| 대상 파일 | 조건 | 차단 |
|---|---|---|
| `_artifacts/**/*.sql` | `CREATE OR REPLACE (PACKAGE|PROCEDURE|FUNCTION|TRIGGER|VIEW|TYPE)` 포함 | `SOURCE-FRESH:` 스탬프 없음 / `FETCHED=` 없음 / FETCHED 가 **24시간 초과** |
| `_artifacts/**/*.py` | `CREATE OR REPLACE` 문자열 포함 (DDL 실행·생성기) | DB 재조회 흔적(`ALL_SOURCE`·`USER_SOURCE`·`DBMS_METADATA`) 없음 또는 `FRESH-GATE` 토큰 없음 |

- 제외(원복·백업 전용): 파일명/경로에 `ROLLBACK` · `BACKUP` · `.ASIS.` · `00_BACKUP` · `99_` 포함.
- 우회 없음. 과거 산출물은 해당 파일을 **수정할 때** 검사된다 — 재사용하려면 재조회·재빌드.
- 한계(명시): Python 이 파일을 직접 쓰는 경우(빌더 출력)는 Write/Edit 이벤트가 아니므로, 생성기 `.py` 자체에 FRESH-GATE·재조회를 강제하는 방식으로 막는다. PowerShell/Bash 로 `sqlplus @파일` 직접 실행은 이 hook 이 보지 못한다 → §3.3 게이트는 문서 의무로 병행.

## §5 자기점검 (적용·패키지 전달 직전)

- [ ] 기준본을 **이번 작업 중 DB 에서 새로 조회**했는가 (로컬 파일·이전 세션 기억 아님)
- [ ] 로컬 사본과 DB 원문 차이를 확인·보고했는가 (타 작업자 변경 보존)
- [ ] 적용 **직전** FRESH-GATE 를 통과했는가 (실패 시 중단했는가)
- [ ] 패키지 SQL 에 `SOURCE-FRESH` 스탬프(LAST_DDL·FETCHED) 가 있고 24시간 이내인가
- [ ] 보고문에 조회 DB·시각·LAST_DDL 을 적었는가

관련: `oracle-db-workflow.md` §1-0 · `db-corporate-apply.md` §3.0 · `sp-body-minimal-change.md` · `deploy-package-completeness.md` ·
`asis-db-live-connection-mandatory.md`(#151 AS-IS 측 동일 원칙) · 메모리 `feedback_corp_pkg_overwrite_trace_method` / `feedback_db_source_refresh_before_work`
