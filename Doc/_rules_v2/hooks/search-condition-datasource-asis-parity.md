# Hook #117 — 조회조건 데이터 추출 AS-IS 정합 + 공유 CMBO 보호 프로토콜

> **트리거**: 조회조건 콤보/팝업의 **데이터 소스** 작성·수정 · "AS-IS 와 후보가 다르다" 류 이슈 · `SCM_ADM_CMBO_SQL_M` 공유 SQL_ID 수정 시도
>
> #112(명칭·유형·기능 카탈로그)와 별개 축 — 본 hook 은 **각 항목이 어떤 쿼리로 데이터를 뽑는가** 의 1:1 정합.

작성: 2026-07-23 (DMF0003 조회조건 14항목 전수 대조 — 6건 불일치[BizType 81/82 후보 전량 누락·EndCustomer 929행 누락·Team 소스 상이·SalesSite cascade/AS분기 누락·SenderCode 표시명·Period 기본값] 실측 후 전건 보완. 사용자 지시)
관련 메모리: `project_dmf0003_searchcond_asis_align.md` / 패키지: `_deploy_packages/DMF0003_SEARCHCOND_ASIS_ALIGN_20260723`

---

## §1. AS-IS 데이터 소스 원천 (DM 화면)

| AS-IS 호출 | 원천 정본 | 비고 |
|---|---|---|
| `DataService.GetDMInnerTable("키", Filter)` | `GSCM/04.WSL/FoxQuery/DM/Common/BigFilter.xml` (키별 SQL 블록: MyDivision/TeambyDivision/EndCustomerByDivision/BizType/SiteByEndCustomer(40)/FromSiteByDivision/PlantSiteByEndCustomer/EdiSender/ScmSitebyEndCustomer40) | **DM 화면 조회조건 콤보 전부 이 파일이 원천** |
| `UP_FX_GetCommonDataList_DM(CODE=...)` | AS-IS MSSQL SP — `.env.asis` pyodbc `OBJECT_DEFINITION(OBJECT_ID('...'))` 실측 | 화면 개별 override 분기(예 SalesSite AS 분기·OPERATION_GROUP 'W' 제외) 포함 |
| `PR_GET_DAY_RANGE` 등 기본값 SP | 동일 (OBJECT_DEFINITION) | Period 기본값 = 해당월 1일~+p_month개월 구간 말일 |
| SCP/FP/SSP | 각 `04.WSL/FoxQuery/{도메인}/Common/BigFilter.xml` | 도메인별 상이 — DM 것 재사용 금지 |

## §2. 정합 점검 절차 (조회조건 항목별 — 의무)
1. AS-IS: 화면 .cs 의 `SetChangeControl`/로컬 Get* 함수 → 키·파라미터 확정 → §1 원천에서 SQL 원문 확보.
2. TO-BE: 콤보(SQL_ID)·카탈로그 필드·팝업 SP 의 실제 SQL 을 사내 DB 실측.
3. **의미 대조**: 소스 테이블/조인 키/필터(권한·VALID·특수 제외)/표시명(NAME 소스)/정렬/cascade 파라미터/기본값 산식.
4. 불일치 의심 = **사내 데이터로 양식 실행 차집합(MINUS) 실측** 후 판정 (추측 금지 — DMF0003 Team 35/64 차집합 선례).

## §3. 공유 CMBO 보호 프로토콜 (⭐ 절대 규칙)
1. **공유 SQL_ID(`SCM_ADM_CMBO_SQL_M`) 수정 전 소비자 전수 grep 의무**:
   `grep -rn "'<SQL_ID>'" nscm-fe/features` — 조회조건 + **grid 셀 콤보(_comboKey)** + array-form(무바인드) 호출 전부.
   (사고: `SiteByEndCustomer` 를 덮었다가 waterfall·DMF0020 셀콤보 등 **소비자 5곳** 파급 직전 복원 — 2026-07-23)
2. 소비자 2곳 이상 or 바인드 시그니처 변경 → **화면 전용 신규 SQL_ID 등록**(`{공유명}_{화면ID}` 또는 AS-IS BigFilter 키 명칭) + 해당 화면만 전환. 공유본 무변경.
3. 카탈로그 필드(@master/searchFields) 확장은 **opt-in prop**(`comboId?`/`division?` — 기본값 = 기존 동작)으로만. shared 기본 동작 변경 금지(`feedback_shared_global_prop_change_forbidden`).
4. 서버 바인드 콤보(@divisionId 등)는 값 quoting 의무 + cascade 는 바인드 queryKey 반응(재조회)으로 구현 (`feedback_bind_combo_value_quoting`).
5. 신규/정정 CMBO 는 바인드 치환 실행 검증(행수) 후 멱등 MERGE 로 이관 패키지 동봉.

## §4. Grid Cell Combo Data Type 축 대조 (2026-07-23 보강 — 5UI 전수 대조 선례)
조회조건과 별개로 그리드 셀 콤보(`SHEET_COLUMNS.CELL_COMBO_DATA_TYPE`)도 동일 원칙으로 대조:
1. **양 DB 직접 diff**: AS-IS(MSSQL) ↔ TO-BE(Oracle) SHEET_COLUMNS 를 (PROGRAM_ID, SHEET_NAME, COLUMN_NAME) 키로 CELL_CONTROL_OBJECT_TYPE_CODE + CELL_COMBO_DATA_TYPE 비교 (행 누락/값 상이/양측 only).
2. **AS-IS 셀 콤보 해석기 = `UP_FX_GetCommonDataList`(공용판)** — 분기 위치는 `sys.sql_modules` definition LIKE 검색으로 확정(추측 금지).
3. **rename 판정 = 값 집합 MINUS**: camelCase 등록명 rename(CURRENCY_LIST→CurrencyList 등)은 AS-IS 분기 SQL ↔ TO-BE CMBO SQL 을 양 DB 에서 실행해 (CODE,NAME) 집합 동일하면 "실질 일치". 다르면 결함(예: FcstType ATTR2 제외 12종 vs AS-IS 14종 / DmBizType 'ALL' UNION — 셀 에디터 ALL 저장 오염 위험).
4. **AS-IS .cs 동적 SetComboCol 확인 의무** — SHEET_COLUMNS 메타가 빈값이어도 화면 코드가 콤보를 설정하는 경우 존재(DMF0042 CELL_PROD_SITE). 메타 빈값=콤보 아님 단정 금지.
5. **사문 컨트롤 = 미이관 정당**: AS-IS 핸들러가 전부 주석인 컨트롤(DMF0021 KRW/USD/LOC, DMF0082 EdiSender[컨트롤 자체 부재])은 TO-BE 미구현이 파리티.
6. 조회조건 콤보에 'ALL' 행 UNION 은 허용(FE allOption 과 별개 판단), **셀 콤보에 'ALL' 행은 결함**(저장값 오염).
