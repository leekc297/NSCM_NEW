# SCP0100 Global PSI Report(Global PSI New) — 클라우드 이관 패키지 (DB 만: PKG·META·MENU) · 2026-10-30

원천 = 사내 ZIOUI1(SCM_MGR, SERVER_HOST=localhost) **2026-10-30 16:17:24 새로 조회한 원문**(`_build_facts.json`, SOURCE-FRESH 스탬프 각 파일 머리).
FE·BE 는 넣지 않았다(메뉴 선택 = DB 만). 클라우드 DB 에는 접속·실행하지 않았다. 사내 DB 객체·화면 기능은 바꾸지 않았다.

## 1. 무엇이 바뀌나 (적용 대상 = 이 화면 작업으로 새로 생기거나 바뀐 행만)

| # | 대상 | 행 | 방식 | 사내 근거(실측) |
|---|---|---:|---|---|
| 1 | `SCM_MST_SHEET_COLUMNS` — SCP0100 시트 3개(REPORT · SEARCH_LEVEL · SEARCH_LEVEL_DETAIL)의 **PLAN_TYPE 컬럼** | 3 | 멱등 MERGE(논리키) · 값 다를 때만 UPDATE · DELETE 없음 | 2026-10-23 등록. SEARCH_LEVEL·SEARCH_LEVEL_DETAIL 은 minyonglee1 이 10-23 12:14:50 수정(라벨 'Plan Type'). REPORT 행은 같은 날 15:25 CONVERT_SCP0100 등록 — 같은 화면 기능(Plan Type 열) 3시트 묶음이라 함께 담음(아래 §2 비고). 5월 클라우드 미러·10-20 사내 미러(33행) 모두 PLAN_TYPE 없음 → 클라우드 신규 가능성 높음 |
| 2 | `SCM_ADM_MSG_M` — 화면 FE 가 쓰는 신규 라벨 **LBL01163 'Scale'**(cboUnitQty 배율) · **LBL01167 'A/S'**(chkAS) × KO/EN/CN | 6 | `INSERT … WHERE NOT EXISTS` 전용(#140) | minyonglee1 등록 2026-10-15 17:11:29 / 2026-10-19 09:52:20. 공통소스 FE `global-psi-report.constants.ts` LBL.SCALE/LBL.AS 가 참조 |

그 밖의 축은 **변경이 없어 이관 대상이 아니다** — `00_PRECHECK_CLOUD.sql` 이 존재·상태만 확인한다(§2).

## 2. 이관 축 점검표 (전용/공용 · 신규/보완 · 포함 여부와 근거)

| 축 | 사내 실측(2026-10-30 16:17) | 전용/공용 | 클라우드 신규/보완 | 이 화면 작업으로 바뀌었나 | 패키지 |
|---|---|---|---|---|---|
| `PKG_SCP0100` SPEC/BODY | VALID · SPEC 108줄(LAST_DDL 2026-10-09 13:38:32) · BODY 5,107줄(LAST_DDL **2026-10-16 09:42:30**) · 서브프로그램 6 · BODY md5 `6c5c08d0…` | 전용 | 기존(ZIONEX 2026-09-23 변환 산출물 — 10-08 `SLASH_DBOBJ` 클라우드 패키지가 이 BODY 를 포함했으므로 클라우드 기존재 추정) | **아니오** — Doc/gen/SCP0100 PKG 는 사내 미적용(`REPAIR_PKG.md`·메모리 10-22 "사내 PKG 무변경") · BODY 변경 2건은 타 작업자 AJS(`2026.10.07 속도` · `2026.10.16 Project 쉼표 복수 조회`) | 미포함(PRECHECK P1 존재·VALID·줄수·마커 확인). AJS 변경분은 "사용자 본인 작업만 이관" 규칙(2026-10-13)으로 목록만 §4 |
| GTT `GT_SCP0100_*` 26개 | 전부 TEMPORARY=Y SYS$SESSION · 생성 2026-10-09(신 PDB 적재) | 전용 | 기존 | 아니오 | 미포함 → 10_DDL 없음(PRECHECK P2 26개 존재 확인) |
| PKG 외부 참조 16개 (`FN_CHAR_TO_DATE`·`FN_GET_REPORT_USER_COLUMNS`·`FN_SPLITSTRING`·`SCP_PLAN_VERSION_V`·`SCM_MST_ITEM_SN`→FP_MGR.SCM_ITEM_M·테이블 11) | 전부 VALID | 공용 | 기존 | 아니오 | 미포함(PRECHECK P3) |
| 앱 계정 권한·시노님 | `SCMP_APP` EXECUTE ON PKG_SCP0100(DBA_TAB_PRIVS) · `SCMP_APP.PKG_SCP0100` 시노님(2026-10-13 07:26 신 DB 적재분) | 전용 | 기존 | 아니오 — 이번 작업 중 실행한 GRANT·시노님·재컴파일 없음(`Doc/verify/_synonym_history.csv` SCP0100 0건 · `Doc/cloud_sql` SCP0100 0건) | 미포함 → 40_GRANT 없음(PRECHECK P4 가 0행이면 §4 DBA 요청문) |
| `SCM_ADM_MNU_M` | 1행(UPPR Supply_Plan · URL global-psi-report · ROUTE_PATH supply/global-psi-report · MNU_MSG_ID MNU_SCP0100 · USE_YN Y) — ZIONEX 09-23 등록 · AJS 09-30 수정 | 전용 | 기존 | 아니오 | 미포함 → 35_MENU 없음(PRECHECK P5·P6) |
| `SCM_ADM_API_M` | 4행(P_SCP0100_GET/CALENDAR_GET/PLAN_DATE_GET/SITE_GET) ZIONEX 09-23 | 전용 | 기존 | 아니오 | 미포함(P5·P7) |
| `SCM_ADM_MNU_BTN_MPG_M` | 9행 CONVERT_SCP0100 09-24 | 전용 | 기존 | 아니오 | 미포함(P5·P7) |
| `SCM_ADM_PROC_M` | 33행(19+5+4+5) ZIONEX 09-23 · `P_SCP0100_GET_SITE.pSiteTpye` AJS 10-07 수정 | 전용 | 기존 | 아니오(AJS 1행은 타 작업자) | 미포함(P5·P7 배선 역추적 = ALL_ARGUMENTS 인자수 일치) |
| `SCM_ADM_USER_GR_MNU_MPG_M` / `_BTN_MPG_M` | 5그룹 / 45행 — AS-IS 2023~2024 등록 | 전용 | 기존 | 아니오 | 미포함(P5) |
| `SCM_MST_SHEET_COLUMNS` 기존 33행 | 2024 등록(iamarock·yschoithira) · 5월 미러와 값 동일 | 전용 | 기존 | 아니오 | 미포함(P5 33행 확인) |
| **`SCM_MST_SHEET_COLUMNS` PLAN_TYPE 3행** | §1 | 전용 | **신규(미러 기준)** | **예(2행 사용자 수정 + 1행 동일 묶음)** | **30 파일** |
| `SCM_MST_SHEET_MEASURE` 'Global PSI New' | 36행 AS-IS(2023~2025) | 전용 | 기존 | 아니오 | 미포함(P5) |
| `SCM_ADM_MSG_M` MNU_SCP0100 | 3행 CONVERT_ZIONEX 09-23 | 전용 | 기존 | 아니오 | 미포함(P5) |
| **`SCM_ADM_MSG_M` LBL01163·LBL01167** | §1 | 공용 테이블의 이 화면 몫 | **신규 채번** | **예** | **31 파일** (P10 선점 충돌 시 중단) |
| `SCM_ADM_MSG_M` 재사용 코드 23개(LBL00001…MSG00704) | 전부 존재 | 공용 | 기존 | 아니오 — 단 `MSG00703` KO 문구를 minyonglee1 이 10-29 14:47 수정(공유 메시지) | 미포함(P8 존재 확인만). MSG00703 문구 변경은 INSERT-only 규칙상 미반영 → §4 목록 |
| `SCM_ADM_CMBO_SQL_M` 화면 콤보 4(Division_SCP · PlanType1_SCP_ALL · PLAN_END_DATE_REPORT · SCPPlanPeriod_SCP) | admin 09-10 등록 · AJS 09-17/10-12 수정 | 공용 | 기존 | 아니오 | 미포함(P5) |
| `SCM_ADM_LOOKUP_MASTER_DETAIL` SHEET_PRSL_YN(SCP0100 4행) · 화면 lookup 5 TYPE | CONVERT_SCP0100 09-29 · AS-IS | 공용 | 기존 | 아니오 | 미포함(P5) |
| `SCM_MST_TITLESET_USER`(268행) · `SCM_ADM_USER_MNU_SRCH_COND_M`(7행) | 사용자 개인화·저장 조회조건(minyonglee1 등 4인, 10-23~10-30) | 개인 데이터 | — | 예(테스트 중 생성) | **제외** — 타 환경 사용자 설정 덮어쓰기 금지(`feedback_deploy_axis_sweep_mandatory` §4) |
| `SCM_ADM_PROC_M_BAK20261007_SCP0100` · `SCM_MST_SHEET_COLUMNS_BK20260909` | 백업 테이블 | — | — | 아니오 | 제외 |

축 도출 = 사람 나열이 아니라 **기계 스윕**(`_inventory/inv3.py`: SCM_ADM_%/SCM_MST_% 166 테이블 × 문자열 컬럼 전수에서 'SCP0100' 포함 행 → 14 테이블 적중, 쿼리 실패 시 즉시 중단) + PKG 의존(`ALL_DEPENDENCIES`) + FE 소스 grep(시트·콤보·lookup·LBL/MSG 25코드). 결과 원문 = `_inventory/inv*.out.txt`.

비고(판정 근거) — PLAN_TYPE REPORT 행(CONVERT_SCP0100 10-23 15:25)은 사용자 계정 수정 흔적이 없다. 그러나 SEARCH_LEVEL·SEARCH_LEVEL_DETAIL 행(사용자 10-23 12:14 수정)과 같은 날 같은 화면의 'Plan Type 열 추가' 한 묶음이고, 2행만 보내면 클라우드 3시트가 어긋나므로 3행을 함께 담았다. 제외하려면 `30_META_SHEET_COLUMNS_PLAN_TYPE.sql` 의 `-- [REPORT]` MERGE 1문만 빼면 된다(다른 문장과 독립).

## 3. 패키지 구성과 실행 순서 (클라우드 · SCM_MGR 계정 · 파일 전체 F5 1회씩 · 치환변수/바인드 없음)

```
A_DB/
  00_PRECHECK_CLOUD.sql                 조회 전용. P1~P9 결과를 아래 기대값과 대조, P10 만 선점 충돌 시 ORA-20001 로 중단
  30_META_SHEET_COLUMNS_PLAN_TYPE.sql   PLAN_TYPE 3행 MERGE (+COMMIT, 사후 SELECT)
  31_MSG_LBL_SCP0100.sql                LBL01163·LBL01167 × 3언어 INSERT NOT EXISTS (+COMMIT, 사후 SELECT)
  90_VERIFY.sql                         값 단언 V1~V7 (조회 전용)
  99_ROLLBACK.sql                       이 패키지가 INSERT 한 행(CREATED_BY='admin')만 삭제
build_package.py                        생성기 — 사내 DB 재조회 → SQL 생성 → FRESH-GATE(재조회 동일) → 린트(&·:바인드·탭·블록주석·'claude' 0)
run_rehearsal.py                        사내 리허설 실행기 (SCM_MGR 세션 · 문장 단위 실행 · 끝 상태 대조 · INSERT 경로 트랜잭션 시험)
_build_facts.json                       빌드 시점 사내 실측값(기대값 원천) · _rehearsal_out/ 리허설 결과 · _inventory/ 축 스윕 원문
```
10_DDL(GTT/TYPE) · 20_PKG · 35_MENU · 40_GRANT 파일은 **해당 없음**(§2 — 이 화면 작업으로 생기거나 바뀐 객체·메뉴·권한이 없다).

실행: `00` → (P5 의 `SCM_MST_SHEET_COLUMNS(PLAN_TYPE)` 가 0/1/2/3 어느 값이든 진행 가능, 단 3 이고 P9 값이 사내와 다르면 P9 결과를 보관) → `30` → `31` → `90`.
재실행 안전: 30 은 값이 같으면 0행, 31 은 0행. 원복: `99`(INSERT 분만) · MATCHED-UPDATE 가 있었던 행은 P9 보관값으로 수동 UPDATE.

기대값(사내 실측): P1 VALID·VALID(SPEC 108 / BODY 5,107줄) · P2 26/26 · P3 16행 전부 VALID · P4 SCMP_APP EXECUTE 1행 + 시노님 1행 · P5 13행 전부 OK(PLAN_TYPE 만 적용 전 DIFF 허용) · P6 SCP0100 행 1 · P7 6행 PROC_M_ROWS=ARG_CNT(4/5/19/19/19/5) · P8 MISSING 0(적용 전엔 LBL01163·LBL01167 2개만 허용) · P10 통과.
90: V1 3행 OK · V2 36/36 OK DUP 0 · V3 0행 · V3b S=36 · V4 6행 OK · V5 0행 · V6 0행 · V7 VALID 2행 ERR 0.

## 4. 클라우드 담당자가 할 일 · 범위 밖 항목

1. `00_PRECHECK_CLOUD.sql` 실행 → P1 이 0행(PKG_SCP0100 부재)이면 **이 패키지로는 화면이 동작하지 않는다**. PKG_SCP0100·GTT 26·PROC_M·API_M·BTN_MPG 의 기본 등록(ZIONEX 2026-09-23 변환 산출물)을 먼저 받아야 한다 — 본 패키지 범위 밖(사용자 본인 작업이 아님). P2/P3 MISSING, P4 0행(→ `GRANT EXECUTE ON SCM_MGR.PKG_SCP0100 TO SCMP_APP;` `CREATE OR REPLACE SYNONYM SCMP_APP.PKG_SCP0100 FOR SCM_MGR.PKG_SCP0100;` DBA 요청), P5 DIFF 도 같은 성격으로 보고한다.
2. P10 ORA-20001 이면 LBL01163/LBL01167 이 클라우드에서 다른 문구로 선점된 것 — 적용 중단 후 사내에 재채번 요청(FE 상수·사내 MSG_M 동반 변경 필요).
3. `30` → `31` → `90` 실행, 90 결과를 기대값과 대조해 회신.
4. 범위 밖(목록만 — 본 패키지 미반영): ① `PKG_SCP0100` BODY 타 작업자 AJS 변경 2건(2026.10.07 최종 피벗 성능 · 2026.10.16 Project 쉼표 구분 복수 조회) — 클라우드 BODY 줄수·P1b 마커로 세대 확인 후 작성자(ZIONEX/AJS) 경로로 이관 ② `SCM_ADM_PROC_M` `P_SCP0100_GET_SITE.pSiteTpye` AJS 10-07 수정 ③ `SCM_ADM_MSG_M` `MSG00703` KO 문구 사용자 10-29 수정(공유 메시지 — INSERT-only 규칙으로 UPDATE 미동봉) ④ 정합검증 10-30 발견 결함(공용 `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_MEASURE_LIST` 개인화 분기에서 단일 Division 전달 시 공통 measure 0건) — 보완 미실행 상태라 미포함.

## 5. 사내 리허설 결과 (ZIOUI1 · SCM_MGR 세션 · 2026-10-30 16:17:30 ~ 16:17:37 · `_rehearsal_out/`)

| 순서 | 파일 | 오류 | DML 결과 |
|---|---|---:|---|
| 01 | 00_PRECHECK_CLOUD | 0 | P1~P9 전부 기대값 일치 · P10 통과 |
| 02·03 | 30 → 31 (APPLY 1회차) | 0 | MERGE 0·0·0 / INSERT 0×6 (사내는 이미 같은 값 — 멱등·무변경) |
| 04·05 | 30 → 31 (APPLY 2회차, 멱등) | 0 | 전부 0행 |
| 06 | 90_VERIFY | 0 | V1 OK×3 · V2 36/36 DUP 0 · V3 0행 · V4 OK×6 · V5 0행 · V6 0행 · V7 VALID·VALID ERR 0 |
| 07 | 99_ROLLBACK | 0 | DELETE 0·0 (사내 원본 행은 CREATED_BY 가 admin 이 아니라 보호됨) |
| 08·09 | 30 → 31 (재적용) | 0 | 전부 0행 |
| 10 | 90_VERIFY | 0 | 06 과 동일 |

끝 상태 대조: PLAN_TYPE 3행 값 서명 `db0a2ca9…` · LBL 6행 서명 `dd10e071…` · SHEET_COLUMNS 36행 · PKG_SCP0100 BODY md5 `6c5c08d0…` — 시작 상태·빌드 실측(`_build_facts.json`)과 **모두 동일**. 사내 행의 감사 컬럼도 변하지 않았다(MATCHED-UPDATE 는 값이 다를 때만).

INSERT 경로 증명(사내 원본을 지우지 않기 위해 트랜잭션 안에서, 커밋 없음): PLAN_TYPE 3행·LBL 6행 DELETE → 30/31 DML 실행 → 9문 전부 rowcount 1(INSERT 분기) · 값 서명 원본과 동일 · admin 표식 3행 → ROLLBACK → 원상 복귀 확인(`_summary.json.insert_path_trial`).

리허설하지 않은 것: 없음(업무 원장을 바꾸는 단계가 없는 패키지). 클라우드 실제 적용은 하지 않았다.

## 6. 생성 규약 자기점검
- [x] 기준본 = 이번 작업 중 DB 새로 조회(16:17:24) · FRESH-GATE(생성 직후 재조회 동일) · 리허설 시작 시 빌드 서명 재확인
- [x] SOURCE-FRESH 스탬프(파일 5개) · 24시간 내 전달(넘기면 `python build_package.py` 재실행)
- [x] MERGE ON = 논리키 실측(PK/UK 없음 · 사내 중복 0) · DELETE 없음 · MSG_M INSERT NOT EXISTS 전용 · 감사 컬럼 'admin'
- [x] 치환변수·바인드·탭·블록주석·'claude' 0 (생성기 린트) · 전체 F5 기준 오류 0(리허설 10단계)
- [x] 축 = 기계 스윕(166 테이블) + ALL_DEPENDENCIES + FE grep · 카운트는 축 이름과 함께 기재 · 배선 역추적(V6) 동봉
- [x] 제외 축(개인화 2 테이블·백업 2 테이블·타 작업자 변경 3건)을 사유와 함께 명시
