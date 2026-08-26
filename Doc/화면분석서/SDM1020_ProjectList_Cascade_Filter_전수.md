# SDM1020 Project List — 조회조건·GRID Cascade/Filter 전수

> ⭐ 정본 원천 = `Doc/화면설계서_SDM/SDM1020/SDM1020_ProjectList_화면설계서_20260814.xlsx` (AS-IS 부재 — 순수 신규, hook #134).

## 1. 조회조건 5종 — 원천·종속·기본값 (개요 B11:H17 전수)

| # | 필드 | 컨트롤 | 필수 | 기본값 | 데이터 원천 | 종속(cascade) |
|---|---|---|---|---|---|---|
| CF-01 | 사업부 (LBL00001) | ComboBox(Single) | Y | 첫 번째 값 | 공통 콤보 `MyDivision` (사용자 권한 범위 — 개요 H13) | — (루트) |
| CF-02 | 고객 | ComboBox(Multi, 검색+ALL) | N | ALL | 공통 콤보 `EndCustomerByDivision` | **사업부 종속** — Division 변경 시 재적재 + ALL reset (개요 H14 "최종 고객을 고른다(사업부에 종속)") |
| CF-03 | 나의 권한 | ComboBox(Multi) | N | ALL | `SCM0001_GET_LOOKUP_VALUES` p_lookup_type=`SPMS_DPJT_AUTH_TYPE` | 독립 |
| CF-04 | 등록 상태 | ComboBox(Multi) | N | ALL | 동 SP `SPMS_DPJT_REG_STATUS` | 독립 |
| CF-05 | 등록 완료일 | Date(From~To) | Y | M-1 ~ Today | `PR_GET_DAY_RANGE`(P_FR/TO_BUCKET·DATE_VAL·BUCKET_TYPE + P_SES_USER_ID — 개요 H17 전문) | 독립. From>To 금지(MSG00108) |
| CF-06 | (버튼) 기본 기능 | — | — | — | 조회조건 Condition/Reset Condition + 컬럼 Filter/Sort (개요 B23) | — |

- 다중선택 콤보 = 검색+ALL 표준(hook #112), SP 전달 = 콤마 연결(UC-06). Search 라벨 = LBL00112 고정(hook #120 §5).
- 조회조건 LBL: 사업부만 LBL00001 기재 — 고객/나의 권한/등록 상태/등록 완료일 4건 공란(정오표 미결).

## 2. Division 변경 cascade (개요 H13)

| 순서 | 대상 | 처리 |
|---|---|---|
| 1 | 고객 콤보(CF-02) | `EndCustomerByDivision` 재조회(@division 따옴표 전달) + 선택값 ALL reset |
| 2 | 컬럼 메타 | `fetchStaticColumns`/`fetchStaticMeasures` 재조회 (H13 "변경 시 컬럼정보를 재조회" — X/Y열 Division 종속 컬럼: 나의 권한·권한 계열=81 계열/81·82, REG_COMP_DATE=40·81·82) |
| 3 | 그리드 | 데이터 비움 + CRUD pending(체크·편집 tracker) reset (H13 "그리드 내용 초기화") |
| 4 | 재조회 | 자동 재조회 금지 — Search 버튼으로만 (Division 변경 규약) |

## 3. 그리드 셀 콤보 cascade (UI컬럼 정의 시트 SDM1020 블록 실측)

| # | 컬럼 | 콤보(Cell Combo Data Type) | 파라미터(따옴표 전달 계약) | 종속 |
|---|---|---|---|---|
| CF-07 | DIVISION_ID | `Division` | — | 표시용(편집 S — 조회 Division 부여) |
| CF-08 | DPJT_CLASS | `DpjtClass` | — | 독립(lookup `SPMS_DPJT_CLASS`) |
| CF-09 | END_CUSTOMER | `EndCustomerByDivisionDept` | @division(+@dept 관대형) | **조회 Division 종속** — ⚠ 조회조건(CF-02 `EndCustomerByDivision`)과 콤보명 상이(그리드 전용) |
| CF-10 | CELL_TYPE | `CellTypeByDivision` | @division | 조회 Division 종속 |
| CF-11 | STACK_METHOD | `StackMethodByCellType` | @cellType(+@division) | **행 CELL_TYPE 종속** — Cell Type 변경 시 Stack Method 값 clear + dataMap 스왑 (조회 SP SMD 조인 = SEGMENT1 division + SEGMENT2 cellType + SEGMENT4 stackMethod 실측 — division·cellType 2축) |
| CF-12 | BIZ_TYPE | `BizTypeByDivision` — **확정** (설계서 N12 병기 "DmBizType (or BizTypeByDivision)" 중 후자 확정. 정오표 미결 참조) | @division | 조회 Division 종속 — ⚠ 조회 SP BIZ 조인은 lookup `DM_BIZ_TYPE` 무-division 매칭(정오표 O-2 관찰) |
| CF-13 | SOP_DATE | (FPDate `YYYY.MM.DD`) | — | 날짜 셀 |
| CF-14 | SOP_PLANT_ID | `PlantByDivisionCompany` | @division(+@company 관대형) | 조회 Division 종속 |
| CF-15 | DPJT_DEVELOP_STATUS | `DpjtDevelopStatus` | — | 독립(lookup `SPMS_DPJT_DEVELOP_STATUS` — 조회 SP DVL 조인 실측) |

- CODE/NAME 페어: dataMap 은 CODE 컬럼 바인딩·NAME 표시(cellEditEnded CODE 동기 기입). 편집 자체는 관리자 행만(P-01).
- 조회 Division 이 셀 콤보의 상위축 — Division 변경 시 그리드가 비워지므로 dataMap 재구성으로 충분. 행 단위 종속은 CF-11(Cell Type→Stack Method) 1건뿐.

## 4. 팝업 cascade

| # | 트리거 | 대상 | 처리 |
|---|---|---|---|
| CF-16 | 팝업 오픈(권한관리 링크) | 조직도/입력/조회/요청 4그리드 | `P_SDM1010_GET_POP_USER_ORG` + `GET_POP_PJT_AUTH_WRITE` + `GET_POP_PJT_AUTH_READ` + `GET_POP_PJT_AUTH_REQ` (P_DPJT_KEY=Parent GRID Focused Row) |
| CF-17 | 조직도 부서 클릭 | 사용자 목록 | `P_SDM1010_GET_POP_USER_BY_DEPT`(P_DEPT_ID만 — 팝업 확인 사항 2.1) |
| CF-18 | 사용자 검색(Search) | 사용자 목록 | 동 SP(P_USER_INFO만 — 조건 없으면 미출력 1.1.1) |
| CF-19 | (+)/(−)/입력↔조회 이동/승인 이동 | 입력/조회/요청 리스트 | pending 상태 전이(관리자·중복 가드, 요청 정보 보유) — OK 저장 시 확정 |
| CF-20 | 반려 버튼 | 요청 행 | 즉시 SP(`P_SDM1010_SAVE_POP_BTN_REJECT`) → 반려 상태 즉시 표시 |
| CF-21 | 팝업 OK 저장 완료 | 메인 그리드 | 재조회 → "입력/조회 권한등록" 상태 update (개요 F33) |

## 5. 조회 SP 필터 계약 (P_SDM1020_GET_PJT_LIST 원문 실측)

| 파라미터 | 필터 방식 | 'ALL'/공백 처리 |
|---|---|---|
| P_DIVISION_ID | `WT_FILTER_DIV` = `UF_FX_STRING_SPLIT(p, ',')` → `DIVISION_ID IN (SELECT TOKEN …)` | `= 'ALL'` 이면 무필터 (OR 단락) |
| P_END_CUSTOMER | 동일 패턴 `WT_FILTER_EC` | `= 'ALL'` 무필터 |
| P_DPJT_AUTH_TYPE | `CASE WHEN USM.DPJT_AUTH_STATUS='REQUEST' THEN 'NONE' ELSE USM.DPJT_AUTH_TYPE END IN (…)` — **요청 중 = 권한없음으로 판정** | `= 'ALL'` 무필터 |
| P_DPJT_REG_STATUS | 동일 패턴 `WT_FILTER_REG_STATUS` | `= 'ALL'` 무필터 |
| P_REG_COMP_DATE_FR/TO | `TO_DATE(SUBSTR(p,1,10),'YYYY-MM-DD')` → `REG_COMP_DATE BETWEEN` | FR·TO **둘 다 NULL 일 때만** 무필터 — ⚠ REG_COMP_DATE NULL(미완료) 행은 기간 지정 시 전멸(SDM1010 R8 동형 — 정오표 D-보류 관찰, 화면 필수 조건이라 기간은 항상 전달됨) |
| P_SES_USER_ID | USM 서브쿼리(`SPMS_PROJECT_USER_MAP WHERE USER_ID = P_SES_USER_ID`) — 나의 권한 산출 축 | Session 필수 |

- FROM 축 JOIN 전수: INNER = DIV(SCM_MST_DIVISION)/PCL(`SPMS_DPJT_CLASS`)/CLT(`SPMS_CELL_TYPE`)/SMD(`SPMS_CELL_STACK_METHOD`)/BIZ(`DM_BIZ_TYPE`)/RGS(`SPMS_DPJT_REG_STATUS`)/USR(SCM_MST_SSO_USER_INFO)/DPT(SCM_MST_SSO_DEPT_INFO) 8곳, LEFT = EDC(SITE 고객)/PLT(SITE PLANT)/USM(내 권한)/PAT(요청 수)/DVL(개발 현황) 5곳 — INNER 축 행 소실 리스크는 정오표 D9/D10(미결·실측 대기).
- 멀티 토큰 함수 = `SCM_MGR.UF_FX_STRING_SPLIT` (NR, TOKEN) — 콤마 구분(UC-06).
