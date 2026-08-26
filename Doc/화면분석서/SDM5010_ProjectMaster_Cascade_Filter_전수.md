# SDM5010 Project Master — 조회조건·GRID Cascade/Filter 전수

> ⭐ 정본 원천 = `Doc/화면설계서_SDM/SDM5010/SDM5010_ProjectMaster_화면설계서_20260813.xlsx` (AS-IS 부재 — 순수 신규, hook #134) + `SQL_PACKAGE/PKG_SDM5010.txt` 원문.
> 정오표: `Doc/화면분석서/SDM5010_ProjectMaster_정오표.md`

## 1. 조회조건 6종 — 원천·종속·기본값 (개요 B11:H18 전수)

| # | 필드 | 컨트롤 | 필수 | 기본값 | 데이터 원천 | 종속(cascade) |
|---|---|---|---|---|---|---|
| CF-01 | 사업부 (LBL00001) | ComboBox(Single) | Y | 첫 번째 값 | 공통 콤보 `MyDivision` (사용자 권한 범위 — 개요 H13) | — (루트) |
| CF-02 | 고객 | ComboBox(Multi, 검색+ALL) | N | ALL | 공통 콤보 `EndCustomerByDivision` | **사업부 종속** — Division 변경 시 재적재 + ALL reset (개요 H14 "최종 고객 선택 (사업부에 종속)") |
| CF-03 | Cell 유형 | ComboBox(Multi) | N | ALL | `SCM0001_GET_LOOKUP_VALUES` p_lookup_type=`SPMS_CELL_TYPE` (개요 H15) | 설계 기재상 독립 — ⚠ lookup 실구조는 SEGMENT1=DIVISION 축 보유(PKG CLT 조인 실측) → 전 division 값 노출(정오표 F-17 관찰, 원문 유지) |
| CF-04 | Biz Type | ComboBox(Multi) | N | ALL | **`BizTypeByDivision` 확정**(개요 G16 `DmBizType` 기재 + H16 "사업부에 종속" — 정오표 F-18) | **사업부 종속** — Division 변경 시 재적재 + ALL reset |
| CF-05 | 개발 현황 | ComboBox(Multi) | N | ALL | 동 SP `SPMS_DPJT_DEVELOP_STATUS` (개요 H17 — lookup 시드 미기재: DEV/PROD/DROP 임시, T-4) | 독립 |
| CF-06 | 등록 요청일 | Date(From~To) | Y | M-1 ~ Today | 설계 기재 `P_SDM1010_GET_PERIOD`(H18 7-param 설명) → **실배선 `PR_GET_DAY_RANGE` 5-arg 실서명**(`p_created_by`/`p_month` IN 2 + `O_RC1`/`O_RC2`/`O_RESULT_CURSOR` OUT 3 — census 원문 실측, 정오표 F-1. o_rc2 DAY_RANGE 앵커 + FE dayjs 병행 = SDM1020 계약 ⑤ 판례) | 독립. From>To 금지(MSG00108)·3년 제한(P-03). **실필터 축 = REG_COMP_DATE**(F-2 확정 — 라벨 '등록 요청일'과 상이) |

- 다중선택 콤보 = 검색+ALL 표준(hook #112), SP 전달 = 콤마 연결(UC-06). Search 라벨 = LBL00112 고정(hook #120 §5).
- 조회조건 LBL: 사업부만 LBL00001 기재 — 고객/Cell 유형/Biz Type/개발 현황/등록 요청일 5건 공란(정오표 T-3).
- **조회조건 소비 = TAB2 전용**(정오표 F-3): TAB1 SP 는 Session 4종만 수신. TAB1 은 조회조건 무관 세션 범위 조회.

## 2. Division 변경 cascade (개요 H13)

| # | 축 | 요지 |
|---|---|---|
| CF-07 | Division 변경 cascade | 고객·Biz Type 콤보 재적재+ALL reset → 컬럼 메타 재조회 → 양 탭 그리드 비움+CRUD reset → 자동 재조회 금지(Search 버튼만) |

| 순서 | 대상 | 처리 |
|---|---|---|
| 1 | 고객 콤보(CF-02) | `EndCustomerByDivision` 재조회(@division 따옴표 전달) + 선택값 ALL reset |
| 2 | Biz Type 콤보(CF-04) | `BizTypeByDivision` 재조회 + ALL reset |
| 3 | 컬럼 메타 | `fetchStaticColumns` 재조회 (H13 "변경 시 컬럼정보를 재조회") |
| 4 | 그리드 | TAB1·TAB2 데이터 비움 + CRUD pending reset (H13 "그리드 내용 초기화") |
| 5 | 재조회 | 자동 재조회 금지 — Search 버튼으로만 (Division 변경 규약) |

## 3. 그리드 필터 계약 (SP 원문 실측)

| # | 축 | 요지 |
|---|---|---|
| CF-08 | TAB1 필터 | Session Division + MGMT_USER_ID=본인(**설계 원문 유지 — 사용자 확정** D14) + WAITING/REQ_MOD 고정 — 조회조건 미소비(F-3) |
| CF-09 | TAB2 필터 | 'ALL' 무필터 OR 단락 + `UF_FX_STRING_SPLIT` 멀티 5축 + `REG_COMP_DATE BETWEEN`(양 NULL 무필터 — T-12) + NOT IN 3상태 |

### CF-08. TAB1 필터 — `P_SDM5010_GET_TAB1_PJT_REG_REQ`

| 술어 | 방식 | 비고 |
|---|---|---|
| `PJM.DIVISION_ID = P_SES_DIVISION_ID` | 등호 단건 (Session) | 조회조건 사업부와 별개 축 — Session 주입(TAB1 시트 K26 "Session 정보 참조") |
| `PJM.MGMT_USER_ID = P_SES_USER_ID` | 등호 단건 (Session) | **본인 관리 프로젝트 한정 — 설계 원문 유지(사용자 확정, 정오표 D14)** |
| `PJM.DPJT_REG_STATUS IN ('WAITING','REQ_MOD')` | 고정 2상태 | 등록요청/변경요청만 (SP 주석 원문) |

- `P_SES_MENU_ID`/`P_SES_USER_GR_ID` 는 수신만 하고 WHERE/SELECT 미사용(정오표 D7).

### CF-09. TAB2 필터 — `P_SDM5010_GET_TAB2_PJT_MASTER`

| 파라미터 | 필터 방식 | 'ALL'/공백 처리 |
|---|---|---|
| P_DIVISION_ID | `WT_FILTER_DIV` = `UF_FX_STRING_SPLIT(p, ',')` → `DIVISION_ID IN (SELECT TOKEN …)` | `= 'ALL'` 이면 무필터(OR 단락) — 화면은 Single 필수라 항상 단일 전달 |
| P_END_CUSTOMER | 동일 패턴 `WT_FILTER_EC` | `= 'ALL'` 무필터 |
| P_CELL_TYPE | 동일 패턴 `WT_FILTER_CELL_TYPE` | `= 'ALL'` 무필터 |
| P_BIZ_TYPE | 동일 패턴 `WT_FILTER_BIZ_TYPE` | `= 'ALL'` 무필터 |
| P_DPJT_DEVELOP_STATUS | 동일 패턴 `WT_FILTER_DEVELOP_STATUS` | `= 'ALL'` 무필터 |
| P_REG_COMP_DATE_FR/TO | `TO_DATE(SUBSTR(p,1,10),'YYYY-MM-DD')` → `REG_COMP_DATE BETWEEN` | FR·TO **둘 다 NULL 일 때만** 무필터 — ⚠ REG_COMP_DATE NULL 행(REJECT 등 미완료 계열)은 기간 지정 시 전멸(SDM1010 R8 동형 — 정오표 T-12, 확정 전 SP 무수정) |
| P_SES_USER_ID | 로그/예외 축만 — WHERE 미사용 | Session |
| (고정) | `DPJT_REG_STATUS NOT IN ('WRITING','WAITING','REQ_MOD')` | 작성중/승인대기/변경요청 제외(P-14) |

- 멀티 토큰 함수 = `SCM_MGR.UF_FX_STRING_SPLIT` (NR, TOKEN) — 콤마 구분(UC-06).

## 4. 그리드 셀 콤보 cascade (UI컬럼 및 Measure정의 시트 SDM5010 블록 실측)

| # | 컬럼 | 콤보(Cell Combo Data Type) | 파라미터(따옴표 전달 계약) | 종속 |
|---|---|---|---|---|
| CF-10 | DPJT_REG_CAT | `DpjtRegCat` | — | 독립(lookup `SPMS_DPJT_REG_CAT`) — 표시용(구분 신규/수정, 행 색상 축 P-05) |
| CF-11 | DIVISION_ID | `Division` | — | 표시용 — 편집 시 TAB1 수정 항목(P-07) |
| CF-12 | DPJT_CLASS | `DpjtClass` | — | 독립(lookup `SPMS_DPJT_CLASS`) |
| CF-13 | END_CUSTOMER | `EndCustomerByDivisionDept` | @division(+@dept 관대형) | **조회 Division 종속** — ⚠ 조회조건(CF-02 `EndCustomerByDivision`)과 콤보명 상이(그리드 전용 — SDM1020 CF-09 동형) |
| CF-14 | CELL_TYPE | `CellTypeByDivision` | @division | 조회 Division 종속 |
| CF-15 | STACK_METHOD | `StackMethodByCellType` | @cellType(+@division) | **행 CELL_TYPE 종속** — Cell Type 변경 시 Stack Method 값 clear + dataMap 스왑 (조회 SP SMD 서브쿼리 = SEGMENT1 division + SEGMENT2 cellType + SEGMENT4 stackMethod 실측 — 단 ON 절은 division+stackMethod 2축뿐, 정오표 D15) |
| CF-16 | BIZ_TYPE | `BizTypeByDivision` — **확정** (설계서 N13/N39 병기 "DmBizType (or BizTypeByDivision)" 중 후자 확정 — 정오표 F-18, SDM1020 CF-12 판례) | @division | 조회 Division 종속 — ⚠ 조회 SP BIZ 조인은 lookup `DM_BIZ_TYPE` 무-division 매칭(SDM1020 O-2 동형 관찰) |
| CF-17 | SOP_DATE | (FPDate `YYYY.MM.DD`) | — | 날짜 셀 |
| CF-18 | SOP_PLANT_ID | `PlantByDivisionCompany` | @division(+@company 관대형) | 조회 Division 종속 |
| CF-19 | (TAB2) DPJT_DEVELOP_STATUS / DISABLE_YN | `DpjtDevelopStatus`(FPComboBox) / FPCheckBox | — | 독립(lookup `SPMS_DPJT_DEVELOP_STATUS` — GET_TAB2 DVL LEFT 조인 실측) — **TAB2 편집 2컬럼**(P-12). DISABLE_YN 은 CHECKED/UNCHECKED ↔ `DPJT_MGMT_STATUS` 'DISABLED'/'NORMAL' 매핑(F-20 — 'DIABLED' 오타 정정 D2 전제) |

- CODE/NAME 페어: dataMap 은 CODE 컬럼 바인딩·NAME 표시(cellEditEnded CODE 동기 기입).
- TAB1 편집 = 수정 항목 11종(P-07 — '수정' 행 D-PJT Code 제외 F-9) / TAB2 편집 = CF-19 2컬럼만 — 그 외 콤보 컬럼은 **표시용 dataMap NAME 변환만**.
- 조회 Division 이 셀 콤보의 상위축 — Division 변경 시 그리드가 비워지므로 dataMap 재구성으로 충분. 행 단위 종속은 CF-15(Cell Type→Stack Method) 1건뿐.

## 5. lookup·마스터 INNER 조인 소실 축 전수 (PKG 원문 실측)

| # | 축 | 요지 |
|---|---|---|
| CF-20 | lookup·마스터 INNER 소실 축 전수 | GET_TAB1 = INNER 9/LEFT 4 · GET_TAB2 = INNER 9/LEFT 6 — INNER 축 미등재 코드 행 소실(RGS 'MODIFIED'=D13·SSO=D9·SMD 행 곱=D15) |

GET_TAB1 = **INNER 9 / LEFT 4**, GET_TAB2 = **INNER 9 / LEFT 6**:

| 별칭 | 원천 | 조인 | 소실 축(INNER 시 행 소실 조건) | 적용 SP |
|---|---|---|---|---|
| DIV | SCM_MST_DIVISION | INNER | DIVISION_ID 미등재 | TAB1·TAB2 |
| PRC | lookup `SPMS_DPJT_REG_CAT` (SEG1=코드/SEG2=명) | INNER | 구분 코드 미등재·VALID_YN≠'Y' | TAB1·TAB2 |
| PCL | lookup `SPMS_DPJT_CLASS` | INNER | 유형 코드 미등재 | TAB1·TAB2 |
| CLT | lookup `SPMS_CELL_TYPE` (SEG1=division/SEG2=cellType/SEG3=명) | INNER | division+cellType 조합 미등재 | TAB1·TAB2 |
| SMD | lookup `SPMS_CELL_STACK_METHOD` (SEG1=division/SEG2=cellType/SEG4=stackMethod/SEG5=명) | INNER | division+stackMethod 조합 미등재 — ⚠ ON 절 cellType 축 부재로 동일 공법 다 cellType 등재 시 **행 곱**(정오표 D15) | TAB1·TAB2 |
| BIZ | lookup `DM_BIZ_TYPE` | INNER | bizType 미등재 (무-division 매칭) | TAB1·TAB2 |
| RGS | lookup `SPMS_DPJT_REG_STATUS` | INNER | 등록 상태 미등재 — **CONFIRM 이 기록하는 'MODIFIED' 가 확정 9항목 도메인(SDM1020 D13)에 부재 → TAB2 소실**(정오표 D13 정정 승인) | TAB1·TAB2 |
| USR | SCM_MST_SSO_USER_INFO | INNER | MGMT_USER_ID 미등재(퇴사 등) — 행 소실(정오표 D9 관찰) | TAB1·TAB2 |
| DPT | SCM_MST_SSO_DEPT_INFO | INNER | USR.DEPT_ID 미등재 — 행 소실(D9) | TAB1·TAB2 |
| EDC | SCM_MST_SITE (고객 DISTINCT) | LEFT | — (NVL 로 원값 표시) | TAB1·TAB2 |
| PLT | SCM_MST_SITE (SITE_TYPE='PLANT') | LEFT | — (SOP_PLANT_NAME NULL 표시) | TAB1·TAB2 |
| USM | SPMS_PROJECT_USER_MAP 카운트 | LEFT | — (0=WRITING 판정. REQUEST 포함 카운트 — 정오표 D24 관찰) | TAB1·TAB2 |
| ARS | lookup `SPMS_DPJT_AUTH_REG_STATUS` | LEFT | — (미등재 시 TAG 3형제 NULL) | TAB1·TAB2 |
| DVL | lookup `SPMS_DPJT_DEVELOP_STATUS` | LEFT | — (미등재 시 NAME NULL) | TAB2 |
| CUS | SSO USER+DEPT (Confirm User) | LEFT | — (CNFM_USER_NAME NULL) | TAB2 |

## 6. 팝업 cascade

| # | 트리거 | 대상 | 처리 |
|---|---|---|---|
| CF-21 | 팝업 오픈(권한관리 링크) | 조직도/입력/조회/요청 4그리드 | `P_SDM1010_GET_POP_USER_ORG` + `GET_POP_PJT_AUTH_WRITE` + `GET_POP_PJT_AUTH_READ` + `GET_POP_PJT_AUTH_REQ` (P_DPJT_KEY=Parent GRID Focused Row invisible) |
| CF-22 | 조직도 부서 클릭 | 사용자 목록 | `P_SDM1010_GET_POP_USER_BY_DEPT`(P_DEPT_ID만 — 팝업 확인 사항 2.1 §1) |
| CF-23 | 사용자 검색(Search) | 사용자 목록 | 동 SP(P_USER_INFO만 — 조건 없으면 미출력 1.1.1) |
| CF-24 | (+)/(−)/요청 이동 | 입력/조회/요청 리스트 | pending 상태 전이(관리자·중복 가드, 요청 정보 보유) — OK 저장 시 확정 |
| CF-25 | 반려 버튼 | 요청 행 | 즉시 SP(`P_SDM1010_SAVE_POP_BTN_REJECT`) → 반려 상태 즉시 표시 |
| CF-26 | 팝업 OK 저장 완료 | 메인 그리드(활성 탭) | 재조회 → "입력/조회 권한등록" 상태 update (개요 F34) |
