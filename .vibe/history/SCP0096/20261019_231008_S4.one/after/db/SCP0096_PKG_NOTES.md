# PKG_SCP0096 이식 메모

프로시저 3개(하네스 골격) + 사내 기존 SAVE 1개 보존. O_RC 수는 As-is 최상위 SELECT 수에서 추정 — FE 플랜(e2e_plan.json procs)과 맞춘다.

- P_DM0003_GET_BUCKET_TYPE_CODE: 첫 결과셋 컬럼(As-is 실측 2): CODE(nvarchar(100)), NAME(nvarchar(100))
- P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP: 임시테이블 #TBLDYNAMICPIVOT_SCP0096 → GTT(03_GTT) 또는 WITH 절/컬렉션으로 / 동적 SQL(sp_executesql) → EXECUTE IMMEDIATE 또는 정적 분기
- P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 첫 결과셋 컬럼(As-is 실측 6): COLUMN_NAME(nvarchar(10)), COLUMN_LABEL_NAME(nvarchar(30)), SMALL_CLASS_LABEL_NAME(nvarchar(30)), LARGE_CLASS_LABEL_NAME(nvarchar(30)), DAY_CODE(nvarchar(3)), SORT_ORDER_NO(nvarchar(10))

## 2026-10-19 이식 결과 (port_pkg.md 수행 · round 2)

### 0. 기준본 = 사내오라클 현행 PKG_SCP0096 (hook #152)
- ZIOUI1 `SCM_MGR.PKG_SCP0096` 이 **이미 존재**(ZIONEX 2026.09.24 변환, LAST_DDL 2026-10-09 13:38, VALID) — 조회 `P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`(6인자) + 저장 `P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP`(9인자) + 내부 `P_SPLIT/F_TK/F_TO_NUM`, GTT `GT_SCP0096_PIVOT`(9컬럼) 동반. PROC_M 도 6행/9행 등록 상태.
- 착수 시 ALL_SOURCE 재조회 → `_artifacts/_diagnostics/SCP0096_PORT_20261019/DB_PKG_SCP0096_PACKAGE{,_BODY}.sql` (SOURCE-FRESH 스탬프). 하네스 골격(`gen-pkg.js`)은 이 사실을 모르고 3 프로시저 TODO 골격을 만들었다.
- 처리: 현행 spec/body 를 **1바이트 무변경** 보존(`verify_verbatim.py` → helpers/GET/SAVE/spec 전부 SAME) 하고 그 위에 미이식 2개만 추가. 적용 직전 FRESH-GATE(LAST_DDL 2026-10-09 13:38:44 동일) 통과.

### 1. 이식 내용
| 프로시저 | 처리 | 비고 |
|---|---|---|
| P_DM0003_GET_BUCKET_TYPE_CODE | As-is 원문 이식 | `SCM_ADM_LOOKUP_MASTER_DETAIL` SEGMENT1/SEGMENT2, LOOKUP_TYPE='BUCKET_TYPE_CODE', VALID_YN='Y', ORDER BY DISPLAY_SEQ. 선언만 된 `@p_end_week`·`WITH(NOLOCK)` 제거. (PKG_DMF0003.P_DMF0003_GET_BUCKET_TYPE_CODE 와 동일 SQL) |
| P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | **사내 현행 본문 그대로**(ZIONEX 변환본) | As-is 대조 결과 충실: #TBLDYNAMICPIVOT→`GT_SCP0096_PIVOT`(DELETE 선행), 2갈래 UNION, LEFT JOIN 2종, MAX(CASE…) 동적 일자 칸, GROUP BY, ORDER BY(LAST_INPUT_DATE, DIVISION_ID, PLANT_SITE_ID, MEASURE — NLSSORT BINARY_CI 로 MSSQL CI 정렬 모사). As-is 의 미사용 `LEFT JOIN SCM_SYS_CALENDAR_M O`(선택 컬럼 없음·PK 조인이라 행수 영향 0)는 변환본에 없음 |
| P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | 사내 현행 본문 그대로 보존 | 하네스 골격에는 없던 프로시저 — 삭제하면 사내 PROC_M 9행·FE TODO 배선(ShipmentWorkingDayOsp.tsx:113) 이 깨지므로 유지 |
| P_SCP0009_GET_SHEET_CALENDAR_3SPAN | As-is 원문 이식 | `'D_'+x`→`'D_'||x`, `x + CONVERT(CHAR(2),31)`→`x||'31'`(21/01 동일), `'' AS DAY_CODE`→`NULL`(Oracle 빈문자=NULL, 표시 위치 — 부록 C-7 무해), 3 UNION ALL + ORDER BY SORT_ORDER_NO. 사내 선례 PKG_SSP0045.P_SSP0045_GET_SHEET_CALENDAR_3SPAN 과 동형 |

### 2. 골격과 다른 점 (사유)
1. **P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP 에 `P_DEBUG_MODE` 없음** — 골격은 As-is `@debug_mode`(기본 'F', `PRINT @MEXEC` 전용·결과 영향 0)를 인자로 두었으나, 사내 현행 시그니처는 6인자이고 PROC_M 6행·FE(`procedure.d.ts`)가 그 기준으로 배선되어 있다. 인자를 추가하면 PROC_M 위치 불일치(PLS-00306)로 사내 화면이 즉시 깨지고, 하네스 `SCP0096_registration.sql` BLOCK 2 는 이 프로시저를 재등록하지 않는다(아래 4). FE 는 `debugMode` 를 보내지 않는다(grep 0). → 사내 현행 유지.
2. 골격의 "필수값 검사"(`IF P_DIVISION_ID IS NULL … RAISE_INVALID`, `P_START_YYYYMMDD`) 는 As-is 에 없는 로직(As-is 는 NULL 이면 0건)이라 두지 않았다. `RAISE_INVALID` 헬퍼·`EX_BIZ_EX` 골격은 유지.
3. 사내 현행 GET/SAVE 의 EXCEPTION 은 ZIONEX 양식(O_RESULT_CURSOR 로 오류 반환, `RAISE_APPLICATION_ERROR(-20001` 아님) — 최소변경 원칙(sp-body-minimal-change)으로 손대지 않음 → check-pkg 는 들여쓰기(4칸) 프로시저를 PROC 로 세지 않아 P93 WARN 미발생. 신규 2개는 하네스 골격 그대로.
4. check-pkg WARN 5건(P37 REGEXP) 은 전부 사내 현행 본문(ZIONEX)의 `REGEXP_SUBSTR`(Plant Site 콤마 분해)·`REGEXP_LIKE`(숫자 검증) — 신규 코드 아님. 성능 보완은 별건(#110 GTT 사전적재)으로 사용자 결정.

### 3. 검증 증빙 (사내오라클 ZIOUI1, 2026-10-19 22:53~22:58)
- `node tools/Harness/check-pkg.js SCP0096` → **BLOCK 0 / WARN 5 (PROC 2)** — P00/P20/P21 전부 해소 (`CHECK_PKG.md`).
- `python tools/DbConn/run_sql.py Doc/gen/SCP0096/SCP0096_PKG.sql` → 컴파일 OK PACKAGE/BODY · `ALL_ERRORS` 0 · STATUS VALID · LAST_DDL 2026-10-19 22:53:27 · 의존 INVALID 0 · `verify_db_equals_file.py` DB 원문 == 파일(1행 `SCM_MGR.` 공백 치환만 차이).
- `ALL_ARGUMENTS`: 4 프로시저 2/4/6/9 인자 (기존 GET 6·SAVE 9 무변경).
- 스모크+골든(`smoke_and_golden.py`, As-is MSSQL readOnly 직접 실행 대조):
  - P_DM0003_GET_BUCKET_TYPE_CODE: 3행(DAILY/WEEKLY/MONTHLY) — As-is 3행 **컬럼·값 동일**
  - P_SCP0009_GET_SHEET_CALENDAR_3SPAN('20260101','20260131'): 37행(D 31+W 5+M 1) — As-is 37행 **컬럼·값·순서 동일**
  - P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP('40','','20260101','20260110'): 21행 · 16컬럼(D_ 10칸) — 기존 기능 회귀 정상
- PROC_M: `02_PROC_M_new_procs.sql`(NOT EXISTS 멱등) 로 신규 2 프로시저 2행/4행 등록·COMMIT → 4 프로시저 모두 PROC_M 행수 = ALL_ARGUMENTS.

### 4. 남은 항목 (사람 확인)
1. **`SCP0096_registration.sql` 전체 COMMIT 보류** — 드라이런(ROLLBACK) 결과: BLOCK 2 가 `PKG_SCP0096.P_`(register.json 의 sp 공란 2건 → 프로시저명 공백) 를 "임시 등록" 하고, BLOCK 3/5/6/7 이 사내 현행 메타를 DELETE 후 재삽입한다(SHEET_COLUMNS 6→6, **MNU_BTN_MPG_M 5→2**, USER_GR 매핑 전량 교체). 사내에서 이미 운용 중인 화면이라 그대로 커밋하면 버튼 매핑 3행이 사라진다. register.json 의 빈 sp 2건 정리 + 사내 메타와 3-way 대조 후 적용 여부 결정 필요.
2. FE 저장 배선 TODO(`ShipmentWorkingDayOsp.tsx:113`) — 사내 현행 `P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` 는 '^' bulk 7 CLOB 인자 규약(JSON P_DATA 아님). FE 가이드만 제공 대상(DB 객체 우선 원칙).
3. 클라우드 이관: 본 파일이 곧 이관 SQL(SOURCE-FRESH 24h) — 클라우드에 PKG_SCP0096 이 없으면 `GT_SCP0096_PIVOT` DDL(03_GTT 자급) 동봉 필요(사내에서 DDL 추출). 이관 패키지 생성은 별도 지시 시.
4. e2e_plan.json procs 의 sp 공란 2건(`candidate: PKG_SCP0096.P_`) 은 하네스 추출 결함 — O_RC 수 변경은 없어 `__asis-mapping__.md` §4 는 수정 불필요.
