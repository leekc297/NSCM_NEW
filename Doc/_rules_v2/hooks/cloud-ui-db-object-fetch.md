# Hook #122 — cloud-ui-db-object-fetch ⭐⭐ (사용자 명시 2026-08-04)

> **트리거**: "클라우드에서 만든 UI/PKG/SP 를 로컬(사내)로 이관" / "클라우드 DB 객체 추출" — 통상 이관(사내→클라우드)의 **역방향**
> **한 줄**: 클라우드에서 생성된 UI 의 DB 객체는 **발견 4축 → DDL 원문 추출 → 메타 INSERT-only 생성 → 로컬 적용 → DISCOVER 대조 검증** 표준 절차로 이관한다.
> **템플릿 정본**: `_artifacts/_deploy_packages/SYS0016_CLOUD_FETCH_20260804_1310/` (cloud/01·02·03 + local/11·90 — `DEFINE UI_ID/OWNER/META_SINCE` 만 교체하면 타 UI 재사용)
> **선례**: CLOUD_DDL_FETCH_20260729 (PKG_SYS0014 — 고정 명칭 수동 추출의 원형)

---

## §1 발견 4축 (anti-simplification — 명칭 LIKE 1패턴만으로 추출 금지)

| 축 | 방법 | 잡는 것 |
|---|---|---|
| A 배선 메타 (권위) | `SCM_ADM_MNU_BTN_MPG_M(MNU_ID=UI)` → `SCM_ADM_API_M.API_URL` | UI 가 실제 호출하는 SP/PKG — **공용 SP 재사용분**(명칭이 UI 패턴 밖, 예: SCM0010_*)은 이 축만 잡는다 |
| B 명칭 | `ALL_OBJECTS LIKE '%UI_ID%'` | UI 전용 PKG/SP/TABLE/SEQ |
| C 의존 폐포 | A∪B 유닛의 `ALL_DEPENDENCIES` **BFS 반복 확장** (⛔ 재귀 CTE 금지 — 2026-08-04 실사고 2건: ①`UNION` 재귀 = ORA-32040 ②`UNION ALL` 재귀 = 전 경로 열거 → 다이아몬드 의존에서 지수 폭발·클라우드 hang. BFS = 레벨별 1쿼리 + 방문집합 dedup, 사내 실측 289객체 0.4초) | **GTT/TYPE/SEQ/참조 테이블** — 누락 시 로컬 컴파일 ORA-00942 (deploy-package-gtt-type-ddl 계보) |
| D 배선 메타 8테이블 | MNU_M / BTN_MPG / API_M / USER_GR_MNU(_BTN)_MPG / PROC_M / SHEET_COLUMNS / SHEET_MEASURE (+MSG_M 신규분, CMBO 사용 시) | 카운트 = 로컬 검증 대조 기준값 |

## §2 클라우드 측 3스크립트 (sqlplus/SQLcl)

1. `01_DISCOVER_UI_OBJECTS.sql` → `DISCOVER_{UI}.txt` — 4축 보고. **txt 도 반드시 회수** (로컬 검증 기준값)
2. `02_EXTRACT_DDL.sql` → `{UI}_DDL.sql` — 발견 기반 `DBMS_METADATA.GET_DDL` 일괄, **적용 순서 정렬**(TYPE→SEQ→TABLE(+INDEX/COMMENT/TRIGGER)→VIEW→PKG SPEC→BODY→SP→FN). 원문 1바이트 무수정. `!!` 오류 라인 0건 확인
3. `03_EXTRACT_META.sql` → `{UI}_META.sql` — 범용 PL/SQL 에미터(컬럼·PK 딕셔너리 동적)가 **INSERT-only(NOT EXISTS) + 감사컬럼 원본 보존** 문 생성. MSG_M 은 `META_SINCE` 이후 신규분. 행수 = DISCOVER [D] 와 일치 확인. ⛔ **DBMS_OUTPUT 분할은 개행 인식 필수** — 고정 N자 분할 = 토큰/리터럴 중간 개행 + TRIMSPOOL 행끝 공백 소실로 산출 SQL 파손 (2026-08-04 SYS0016 SHEET_COLUMNS 3/13 실사고 — 손상본 복원은 따옴표 홀짝+키워드 경계 파서)

## §3 로컬(사내) 적용 순서

```
0. 90_VERIFY §1·§3 사전 스냅샷 (기존재 확인 — 구조 다른 기존재는 -955 skip 이 못 고침 → diff 후 개별 조치/00A REBUILD)
1. {UI}_DDL.sql   (run_sql.sh/sqlplus — ⚠ ora.py exec 금지: 단순 분할기라 PKG BODY 파손)
2. 11_GRANT_SYNONYM.sql (SCMD_APP — UI 패턴 자동 + 공용 SP 수동 추가, scmd-app-grant-mandatory)
3. {UI}_META.sql  (INSERT-only 멱등 — 재실행 안전, 기존재 무변경)
4. 90_VERIFY.sql  — 객체 VALID·ALL_ERRORS 0·메타 카운트=DISCOVER [D]·PROC_M↔ALL_ARGUMENTS positional·GRANT/SYNONYM
5. FE smoke (조회→저장→SYS_LOG 오류 0) — "컴파일 PASS = 끝" 금지 (oracle-db-workflow §2)
```

## §4 절대 규칙

- ❌ 명칭 LIKE 단일 패턴 추출 (축 A 공용 SP·축 C GTT 누락 = 재작업) — 4축 전부
- ❌ 추출 DDL 수기 수정 / 메타 수기 작성 (PROC_M positional 어긋남 = PLS-00306)
- ❌ UPDATE/DELETE 동봉 (INSERT-only — 기존재 차이는 목록화·보고만)
- ✅ DISCOVER 카운트 ↔ 로컬 VERIFY 카운트 **1:1 대조 보고 의무** — 불일치 = 원인 규명 전 종료 금지
- ✅ locale JSON·FE 파일은 git 경로 (DB 패키지 범위 외 — 2026-07-24 사용자 확정)

---

> Cross-ref: 룰 22 §9(SP/메타 완전성) / deploy-package-gtt-type-ddl / scmd-app-grant-mandatory / proc-meta-signature-match / 32_CLAUDE_ORACLE_DIRECT(실행 도구) / 카테고리 12
