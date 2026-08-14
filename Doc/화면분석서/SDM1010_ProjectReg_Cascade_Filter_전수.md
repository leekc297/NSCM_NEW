# SDM1010 Project Registration — 조회조건·GRID Cascade/Filter 전수

> ⭐ 정본 원천 = `Doc/화면설계서_SDM/SDM1010_ProjectReg_화면설계서_20260806.xlsx` (AS-IS 부재 — 순수 신규).

## 1. 조회조건 5종 — 원천·종속·기본값 (개요 B11:H17 전수)

| # | 필드 | 컨트롤 | 필수 | 기본값 | 데이터 원천 | 종속(cascade) |
|---|---|---|---|---|---|---|
| CF-01 | 사업부 (LBL00001) | ComboBox(Single) | Y | 첫 번째 값 | 공통 콤보 `MyDivision` (사용자 권한 범위) | — (루트) |
| CF-02 | 고객 | ComboBox(Multi, 검색+ALL) | N | ALL | 공통 콤보 `EndCustomerByDivision` | **사업부 종속** — Division 변경 시 재적재 + ALL reset |
| CF-03 | 나의 권한 | ComboBox(Multi) | N | ALL | `SCM0001_GET_LOOKUP_VALUES` p_lookup_type=`SPMS_DPJT_AUTH_TYPE` | 독립 |
| CF-04 | 등록 상태 | ComboBox(Multi) | N | ALL | 동 SP `SPMS_DPJT_REG_STATUS` | 독립 |
| CF-05 | 등록 완료일 | Date(From~To) | Y | M-1 ~ Today | `PR_GET_DAY_RANGE`(p_created_by=UserID, p_month=-1) | 독립. From>To 금지(MSG00108)·TAB2 3년 제한 |

- 다중선택 콤보 = 검색+ALL 버튼 표준(hook #112), SP 전달 = 콤마 연결(UC-06 콤마 다중 조회).
- Search 버튼 라벨 = LBL00112 고정(hook #120 §5).

## 2. Division 변경 cascade (CF-06)

| 순서 | 대상 | 처리 |
|---|---|---|
| 1 | 고객 콤보(CF-02) | `EndCustomerByDivision` 재조회(@division 따옴표 전달) + 선택값 ALL reset |
| 2 | 컬럼 메타 | `fetchStaticColumns`/`fetchStaticMeasures` 재조회 (개요 H13 "컬럼정보를 재조회") |
| 3 | TAB1·TAB2 그리드 | 데이터 비움 + CRUD pending(insertedRows/editTracker) reset (개요 H13 "그리드 내용 초기화") |
| 4 | 재조회 | 자동 재조회 금지 — Search 버튼으로만 (Division 변경 규약) |

## 3. TAB1 그리드 셀 콤보 cascade (CF-07~CF-12)

| # | 컬럼 | 콤보 | 파라미터(따옴표 전달 계약) | 종속 |
|---|---|---|---|---|
| CF-07 | DPJT_CLASS | `DpjtClass` (신설) | — | 독립 |
| CF-08 | END_CUSTOMER | `EndCustomer` (기존) | @division | 조회 Division 종속 |
| CF-09 | CELL_TYPE | `CellTypeByDivision` (신설) | @division | 조회 Division 종속 |
| CF-10 | STACK_METHOD | `StackMethod` (신설) | — | 독립 |
| CF-11 | BIZ_TYPE | `BizTypeByDivision` (기존) | @division | 조회 Division 종속 |
| CF-12 | SOP_PLANT_ID | `PlantByDivisionCompany` (기존) | @division(+@company 규약 확인) | 조회 Division 종속 |

- CODE/NAME 페어: dataMap 은 CODE 컬럼(Visible=N)에 바인딩, NAME 컬럼(Visible=Y) 표시 — 편집은 NAME 컬럼 콤보로 수행하고 CODE 동기 기입(cellEditEnded).
- 조회 Division 이 셀 콤보의 유일 상위축 — 행별 값 종속 cascade(행값 dataMap 스왑) 없음(설계서에 행 종속 정의 부재). Division 변경 시 그리드가 비워지므로 dataMap 재구성으로 충분.
- POP2_GRID5(My Work) SOP_PLANT 콤보 = `PlantByDivisionCompany`(정오표 #6 — 설계서 오기 `CellTypeByDivision` 정정). 단 My Work 는 조회 전용이라 dataMap 은 표시용.

## 4. 팝업 cascade (CF-13~CF-15)

| # | 트리거 | 대상 | 처리 |
|---|---|---|---|
| CF-13 | ProjectAuthRegModal 조직도 노드 선택 | 사용자 목록 그리드 | `P_SDM1010_GET_POP_USER_BY_DEPT`(부서) — 미선택 시 그리드 미출력(P-18) |
| CF-14 | 팝업 (+) 클릭 | 입력/조회 리스트 | 사용자 이동(중복 가드 P-19/P-20) — pending, OK 저장 시 확정 |
| CF-15 | 팝업 OK 저장 완료 | 메인 TAB1 그리드 | 재조회 → DPJT_AUTH_REG_STATUS TAG 갱신 (개요 F38) |

## 5. 필터/정렬 공통 (CF-16)

- 기본 기능(개요 B22): 조회조건 Condition/Reset Condition + 컬럼 Filter/Sort — 공용 DataGrid 표준 기능 사용.
- Insert 시 필터 clear 후 신규 행 표시(UC-01). 수정 pending 중 재조회 confirm MSG00703(UC-02).
