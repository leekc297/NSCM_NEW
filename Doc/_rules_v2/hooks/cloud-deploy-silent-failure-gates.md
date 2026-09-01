# Hook #148 — 클라우드 이관 "조용한 실패" 6계보 게이트 + 진단 순서

> 신설 2026-08-28 (사용자 지시 — "현재까지의 보완내용 중 RULE 적용 필요한 부분 정리해서 MD, HOOK 보완").
> 계기 = 2026-08-27 DMF0040/DMF0053/DMF0035 클라우드 이관 후 **하루에 5건**의 "SQL ERROR / 데이터 미조회" 가
> 전부 **DB 객체가 아닌 이관 축 누락**이었고, 그중 1건(메뉴 행 부재)은 **8일 전(§4.7-B, 2026-08-20) 룰로 성문화된 것이
> 생성기에 미구현되어 그대로 재발**한 건이다.
>
> 카테고리 = `12_process_ops`(주) · `10_diagnosis_troubleshoot` · `09_sp_db_conversion`.
> 짝 룰: [[deploy-package-completeness]](#14 §4.7/§4.7-B/§4.8) · [[oracle-nls-implicit-conversion]](#109 §6) ·
> [[scmd-app-grant-mandatory]](#44) · [[deploy-axis-sweep-mandatory]] · [[get-zero-dup-invisible-diagnosis]](#100).

---

## §0. 원칙 — 룰은 문서가 아니라 **생성기 코드**에 있어야 한다

| 원칙 | 내용 |
|---|---|
| P1 | 이관 패키지의 필수 축은 **생성기(`_ui_cloud_pkg_build_*.py`)가 기계적으로 산출**한다. hook 본문에만 있고 생성기에 없는 의무 = **미구현 룰** (§4.7-B V11 이 그 실사고). |
| P2 | `90_VERIFY.sql` 은 "적재 건수" 가 아니라 **화면이 실제로 의존하는 것**(메뉴 행·권한 뷰 반환 행·앱계정 권한·종속 PROGRAM_ID 메타·NLS 무관)을 검증한다. |
| P3 | "SP 는 정상인데 화면만 실패" 는 **오류 코드 → 단계 카운트 → BE 응답 → FE** 순으로 좁힌다(§2). 추측으로 파일을 더 적용하지 않는다. |

---

## §1. 조용한-실패 5계보 (2026-08-27 실측 — 전부 이관 축 누락)

| # | 증상 | 실제 원인 | 판정 근거 | 패키지 산출물 / 게이트 |
|---|---|---|---|---|
| S1 | DMF0040 "SQL ERROR" | 앱 계정(`SCMP_APP`) 에 `PKG_DMF0040` **EXECUTE + private synonym 부재** (SCM_MGR 직접 호출은 정상) | `ALL_TAB_PRIVS` 에 해당 객체 행 없음 → PLS-00201 | **`40_GRANT_SYNONYM.sql`**(사내 실측 GRANT/시노님 재현, 멱등) · `90_VERIFY` **V12** |
| S2 | DMF0040 "SQL ERROR" (S1 해소 후) | 동적 SQL 의 `CAST(F.CUTOFF_YYYYMMDD AS DATE)` 7곳 = 세션 **NLS_DATE_FORMAT 의존** — BE JDBC 세션(`DD-MON-RR`) 만 ORA-01861 | SP 로그 `SQL_ERR_CODE=-1861 @ DBMS_SQL` | `TO_DATE(x,'YYYYMMDD')` 명시 + **클라우드 NLS 모사 검증**(#109 §6) |
| S3 | DMF0053 "SQL ERROR" | S1 과 동일(GRANT) | 동일 | 동일 |
| S4 | DMF0035 MKT FCST 0행 (오류 없음) | 클라우드 `SCM_ADM_MNU_M` 에 **DMF0035 행 부재** → `SCM_ADM_USER_MNU_EDIT_AUTH_V` INNER JOIN 전량 탈락 (§4.7-B 재발) | 단계 카운트 G2 5,956 정상인데 `o_rc1: []` / 뷰 0행 | `20_MENU_WIRING_AUTH.sql` · `90_VERIFY` **V11** |
| S5 | DMF0035 Biz Plan 만 0행 | 통합 3UI 의 **종속 PROGRAM_ID(DMF0051) 시트 메타 미동봉** — PKG_DMF0051 은 `V_PROGRAM_ID:='DMF0051'` 로 자기 메타를 읽음 | 22_SHEET_META 가 화면 ID(DMF0035)만 스윕 | **`22A_SHEET_META_DEP_PROGRAMS.sql`**(PKG 본문 `:= 'DMFnnnn'` 스윕) · `90_VERIFY` **V13** |
| **S7** | DMF0035 **배포 버전만** 0행·무오류 (로컬 기동은 정상, 같은 QA DB) — 2026-08-28 | 클라우드 QA `SCM_ADM_MNU_M` 의 **다른 메뉴 행(`SCM0020`)이 MNU_URL=`demand-plan-waterfall`·MNU_DESC "Demand Plan Waterfall"** 로 등재(사내 SCM0020 은 `scm0020`) → 사용자가 그 메뉴로 진입 = viewRegistry 는 URL 로 DMF0035 컴포넌트를 띄우지만 탭 MNU_ID=SCM0020 으로 버튼권한·call-proc 배선이 흘러 **오류 없이 0행** | `retrieveMenus` 로그(`SCM_COM_SQL_LOG`)에 동일 MNU_URL 2행 / `SCM_COM_SYS_LOG` 에 MNU_ID=DMF0035 호출 부재 / 사용자 실측 "SCM0020 을 조회하고 있었다" | 92 `Q3-MENUS`(MNU_URL 중복 스윕) · `90_VERIFY` **V14**(같은 MNU_URL 을 가진 타 MNU_ID 0행) · 메뉴 경로 확인이 §2 **⓪** |
| S6 | (부수) `procedures.d.ts` 병합물 결함 | 블록 경계를 헤더 주석 위치로 잡아 DMF0035 는 파일 끝까지(타 메뉴 26개), DMF0040/0053 은 11줄만 캡처 | 블록 내 시트 키 목록 대조 | 블록 = **`  MENU: {`~다음 top-level 직전** + 위 JSDoc, 머리에 시트 키 목록 명시·전체본 덮어쓰기 ⛔ |

---

## §2. 진단 순서 — "SP 는 되는데 화면만" (추측 적용 금지)

```
⓪ 사용자가 **어느 메뉴(MNU_ID)로 진입했는지** 먼저 — `SCM_COM_SYS_LOG.MNU_ID` / Network call-proc URL 첫 세그먼트. 화면 ID 와 다르면 MNU_URL 중복 메뉴(S7) — 아래 ①~⑥ 전부 불필요
① SCM_SYS_LOG_BATCH  : PROGRAM_NAME LIKE '%<UI>%' 최근 1h — SQL_ERR_CODE/SQL_BACKTRACE 가 있으면 그것이 정답 (S2)
   ⚠ LIKE 패턴에 spreadTitle 등 보조 SP 이름도 포함('%DMF0035%' 처럼 넓게)
② 로그 0건·오류 없음 → 앱 계정 축: ALL_TAB_PRIVS(TABLE_SCHEMA='SCM_MGR', GRANTEE='SCMP_APP') + ALL_SYNONYMS(OWNER='SCMP_APP') (S1/S3)
③ 오류 없이 0행 → 단계별 LOG_COUNT 를 사내 정상 실행과 같은 파라미터로 대조 — 처음 0 이 되는 단계가 원인 축
   (이 SP 계열은 단계마다 LOG_COUNT 를 남긴다: D2/D5/E5/G2/H …)
④ 단계 카운트까지 정상(G2>0) 인데 BE 응답 o_rc1=[] → 최종 동적 SQL 의 INNER JOIN 축: 권한 뷰(MNU_M) / SEL_MEASURE / CALENDAR (S4)
⑤ 특정 GUBUN/TYPE 만 0행 → 그 분기 PKG 의 V_PROGRAM_ID 메타 (S5)
⑥ 그래도 남으면 브라우저 Network 응답(키 이름 o_rc1 소문자·길이)·Payload·Console → FE 세대(폴더 전체·FE_MERGE 반영)
```
- SCM_MGR 재현(DBeaver) 정상은 **①~② 를 배제하지 못한다** (권한·NLS 는 세션/계정 의존).
- 클라우드 NLS 모사: `ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-RR'` 후 SP 호출 — `RR/MM/DD` 는 4자리 연도를 관용 허용해 재현이 안 된다.

---

## §3. 생성기 의무 (PRE-PACKAGE — 기계 산출, 손나열 ⛔)

| # | 산출물 | 원천 | 상태 (2026-08-28) |
|---|---|---|---|
| G1 | `40_GRANT_SYNONYM.sql` — 패키지 내 PKG/PROC/FUNC 전부 × (SCMP_APP, SCMD_APP) GRANT EXECUTE + `CREATE OR REPLACE SYNONYM` | 사내 `ALL_TAB_PRIVS`/`ALL_SYNONYMS` 실측 | `_ui_cloud_pkg_add_grants_20260827.py` (본체 흡수 대기) |
| G2 | `22A_SHEET_META_DEP_PROGRAMS.sql` — 동봉 PKG BODY 의 `:= 'DMFnnnn'` 리터럴 전수 → 화면 ID 외 PROGRAM_ID 의 SHEET_COLUMNS/MEASURE (SHEET 단위 DELETE+INSERT) + EXCEL_COLUMNS MERGE | PKG 본문 스윕 | `_dmf0035_add_dep_program_meta_20260827.py` (본체 흡수 대기) |
| G3 | `90_VERIFY` **V11**(MNU_M 행 + 권한 뷰 ≥1) / **V12**(앱계정 EXECUTE+시노님) / **V13**(종속 PROGRAM_ID 메타 >0) | — | 4 패키지 수기 추가 완료 · 본체 흡수 대기 |
| G4 | `FE_MERGE/procedures.d.ts.<MENU>_BLOCK.txt` — 경계 = `^  MENU: \{` ~ 다음 `^  \w+: \{` 직전(꼬리 JSDoc 제외) + 위 JSDoc, 머리에 `L{s}~L{e}`·시트 키 목록 | `procedures.d.ts` | 3본 재생성 완료 · 본체 흡수 대기 |
| G5 | NLS 스캔 — 동봉 SP 원문에서 `CAST(\w+ AS DATE)`·무마스크 `TO_DATE(x)`·`TO_CHAR(date)` 적출 → 0건 아니면 패키지 생성 **차단** | 주석 제거본 정규식 | 수기 스캔 완료(DMF0014 1건 선제 정정) · 본체 흡수 대기 |
| G6 | standalone API SP(`API_M.API_URL` 에 `.` 없는 것) 원문 동봉 | `SCM_ADM_API_M` | `_ui_cloud_pkg_add_standalone_20260827.py` |

> "본체 흡수 대기" 항목은 다음 패키지 생성 전 `_ui_cloud_pkg_build_*.py` 에 합류시켜야 한다 — 합류 전 생성한 패키지는 **G1~G5 스크립트를 순서대로 추가 실행**해야 완성이다.

---

## §4. 자기 점검 (패키지 인계 직전)

- [ ] `40_GRANT_SYNONYM.sql` 존재 + 대상 = 10~39 의 모든 객체
- [ ] PKG BODY `:= 'DMFnnnn'` 리터럴 집합 ⊆ 22/22A 의 PROGRAM_ID 집합
- [ ] `90_VERIFY` 에 V11/V12/V13/**V14**(동일 MNU_URL·ROUTE_PATH 를 가진 타 MNU_ID = 0행) 존재 (V11-B 의 `<TEST_USER>` 치환 안내 포함)
- [ ] NLS 스캔 0건 (있으면 사내 먼저 정정·`DD-MON-RR` 세션 실증 후 동봉)
- [ ] `procedures.d.ts` 블록 머리의 시트 키 목록 = 화면 `SHEETS` 상수와 일치, "전체본 덮어쓰기 ⛔" 문구
- [ ] README 에 §2 진단 순서 + 패키지별 `91_DIAGNOSE_*.sql`(사내 기대값 주석 포함) 동봉
