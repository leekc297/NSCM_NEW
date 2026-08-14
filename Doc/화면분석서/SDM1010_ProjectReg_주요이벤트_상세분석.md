# SDM1010 Project Registration — 주요 이벤트 상세분석

> ⭐ **정본 원천 = 화면설계서 xlsx** (AS-IS GSCM 대응 화면 부재 — 순수 신규 화면, 2026-08-12 사용자 확정).
> 본 md 는 hook #105 E번호 양식으로 재기술한 설계서 전수 분석이며, `asis_mapping_gate --init` 의 원천이다.

## 원천 (전수 Read 실측)

| 구분 | 경로 | 비고 |
|---|---|---|
| 정본 설계서 | `Doc/화면설계서_SDM/SDM1010_ProjectReg_화면설계서_20260806.xlsx` | 15시트 전수 덤프 (v1.1, 2026-08-05) |
| 구판(참고) | `Doc/화면설계서_SDM/SDM1010_ProjectAuthReg_화면설계서_20260728.xlsx` | 0806 판이 정본 — My Work 팝업·Stack 공법/SOP 컬럼 추가분 |
| AS-IS 구조 참조(팝업만) | `GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_ProjectbyDivisionPopup.cs` | AS-IS 화면 부재 — 콤보/컬럼 구조 참조원 |
| 정오표 | `Doc/화면분석서/SDM1010_ProjectReg_정오표.md` | 설계서 오류·미결 13건 정정 근거 |

- 화면 구조: 탭 2 (TAB1 `프로젝트 등록` CRUD+워크플로우 / TAB2 `나의 프로젝트 현황` 조회 전용) + 팝업 2 (권한등록 `ProjectAuthRegModal` / My Work `MyWorkModal`) + 공용 설정 모달 2 (`ColumnSettingModal` / `MeasureSelectModal`)
- 권한 그룹: `SPMS Administrator`, `SPMS Planner` (신설)
- 조회조건 5종: 사업부(`MyDivision`, 필수)/고객(`EndCustomerByDivision`, Multi)/나의 권한(`SCM0001_GET_LOOKUP_VALUES` p_lookup_type=`SPMS_DPJT_AUTH_TYPE`, Multi)/등록 상태(동 SP, `SPMS_DPJT_REG_STATUS`, Multi)/등록 완료일(Date, `PR_GET_DAY_RANGE` p_month=-1 — 기본 M-1~Today, 필수)
- SP 12본 (설계서 기재명 그대로, PKG_SDM1010 취합): `P_SDM1010_GET_TAB1_PJT_REG` / `P_SDM1010_SAVE_TAB1_PJT_REG` / `P_SDM1010_BTN_REQ_PJT_REG` / `P_SDM1010_BTN_CANCEL_PJT_REG` / `P_SDM1010_GET_TAB2_PJT_LIST` / `P_SDM1010_GET_POP_USER_ORG` / `P_SDM1010_GET_POP_USER_BY_DEPT` / `P_SDM1010_GET_POP_PJT_AUTH_MGMT` / `P_SDM1010_GET_POP_PJT_AUTH_REQ` / `P_SDM1010_SAVE_POP_PJT_AUTH_MGMT` / `P_SDM1010_SAVE_POP_PJT_AUTH_REQ` / `P_SDM1010_GET_POP_MY_WORK`(정오표 #5 — `P_` 접두 통일)

## 이벤트 전수 요약표

| EID | 트리거 | 처리 | SP / 대상 |
|---|---|---|---|
| E01 | 화면 진입(초기화) | 탭 2 구성 + 조회조건 콤보 적재 + 기간 기본값 M-1~Today | MyDivision·EndCustomerByDivision·LOOKUP 2종·PR_GET_DAY_RANGE |
| E02 | 사업부(Division) 변경 | 컬럼정보 재조회 + 그리드 초기화 + CRUD reset + 종속 콤보 재적재 | fetchStaticColumns / 콤보 재조회 |
| E03 | TAB1 조회 | 필수·기간 검증 → 조회 | P_SDM1010_GET_TAB1_PJT_REG |
| E04 | TAB1 행 추가 | 신규 행 삽입(CRUD_TYPE C) + 편집 활성 | — |
| E05 | TAB1 행 삭제 | 상태 가드(신규/작성중만) → confirm → 삭제 마킹 | (저장 SP 경유 D) |
| E06 | TAB1 저장 | 필수·중복 검증 → confirm → 저장 → Toast | P_SDM1010_SAVE_TAB1_PJT_REG |
| E07 | 등록요청 버튼 | Checked 행 상태 가드 → confirm → 요청 | P_SDM1010_BTN_REQ_PJT_REG |
| E08 | 요청취소 버튼 | Checked 행 상태 가드(승인대기만) → confirm → 취소 | P_SDM1010_BTN_CANCEL_PJT_REG |
| E09 | TAB1 권한등록 링크(DPJT_AUTH_REG_STR) 클릭 | ProjectAuthRegModal 오픈(행 프로젝트 코드 전달) → 닫힘 후 재조회 | 팝업 SP 6본 |
| E10 | TAB1 엑셀 | 엑셀 다운로드(콤보 NAME 출력) | — |
| E11 | 컬럼 설정 버튼 | 공용 ColumnSettingModal → 저장 시 그리드 비움 | — |
| E12 | Measure 설정 버튼 | 공용 MeasureSelectModal → 저장 시 그리드 비움 | — |
| E13 | TAB1 셀 편집 | 상태·컬럼별 편집 가드 + CODE/NAME 콤보 dataMap | — |
| E14 | TAB2 조회 | 필수·기간·3년 검증 → 조회 | P_SDM1010_GET_TAB2_PJT_LIST |
| E15 | TAB2 My Work 아이콘 클릭 | MyWorkModal 오픈(조회 전용 — 설계 미완 최소구현) | P_SDM1010_GET_POP_MY_WORK |
| E16 | TAB2 엑셀 | 엑셀 다운로드 | — |
| E17 | ProjectAuthRegModal 오픈 | 조직도 조회 + 기존 권한(입력/조회)·요청 목록 조회 | P_SDM1010_GET_POP_USER_ORG / GET_POP_PJT_AUTH_MGMT / GET_POP_PJT_AUTH_REQ |
| E18 | 팝업 조직도 부서 선택 | 부서별 사용자 조회(조건 없으면 그리드 미출력) | P_SDM1010_GET_POP_USER_BY_DEPT |
| E19 | 팝업 (+) 버튼(입력/조회) | 선택 사용자를 입력/조회 리스트에 추가(중복 가드) | — |
| E20 | 팝업 요청 승인 버튼 | 요청 행 → 해당 권한 리스트에 추가(OK 저장 시 확정) | — |
| E21 | 팝업 요청 반려 버튼 | 요청 행 → 반려 상태 표시(OK 저장 시 확정) | — |
| E22 | 팝업 리스트 x(제외) | 권한 리스트에서 제외 — 해당 사용자 요청 존재 시 반려 처리 | — |
| E23 | 팝업 OK(저장) | 권한·요청 일괄 저장 → 성공/실패 메시지 → 메인 그리드 재조회(권한등록 상태 update) | P_SDM1010_SAVE_POP_PJT_AUTH_MGMT / SAVE_POP_PJT_AUTH_REQ |
| E24 | 팝업 Close/X | 저장 없이 닫기 | — |
| E25 | 상태 TAG 렌더링 | DPJT_REG_STATUS_NAME / DPJT_AUTH_REG_STATUS / AUTH_REQ_STATUS TAG 셀 색 표시 | — |

---

## E01. 화면 진입(초기화)

1. 탭 2 구성: TAB1 `프로젝트 등록`(기본 활성) / TAB2 `나의 프로젝트 현황`.
2. 조회조건 콤보 적재 (1RT `useTabComboQueries`): 사업부=`MyDivision`(사용자 권한 기반, 첫 번째 값 기본 선택·필수), 고객=`EndCustomerByDivision`(Multi, 기본 ALL, 사업부 종속), 나의 권한=`SCM0001_GET_LOOKUP_VALUES(p_lookup_type='SPMS_DPJT_AUTH_TYPE')`(Multi, ALL), 등록 상태=동 SP `'SPMS_DPJT_REG_STATUS'`(Multi, ALL).
3. 등록 완료일 기본값: `PR_GET_DAY_RANGE(p_created_by=UserID, p_month=-1)` → **M-1 ~ Today** (설계서 개요 B15).
4. 그리드 컬럼 메타: `fetchStaticColumns`/`fetchStaticMeasures`(SCM_MST_SHEET_COLUMNS — mount 시).
5. 버튼 권한: `useTabBtnPermissions` — SPMS Administrator/SPMS Planner 그룹별 버튼 매핑.

## E02. 사업부(Division) 변경

- 설계서 개요 H13 원문: "변경 시 컬럼정보를 재조회, 그리드 내용 초기화".
- 처리: ①종속 콤보 재적재(고객 EndCustomerByDivision — ALL reset) ②`fetchStaticColumns` 재조회 ③TAB1/TAB2 그리드 데이터 비움 + CRUD pending(insertedRows/editTracker) reset. 재조회는 Search 버튼(자동 재조회 금지).

## E03. TAB1 조회

- 검증: Division 미선택 → `MSG00097`(P-01) / 시작일>종료일 → `MSG00108`(P-02).
- SP: `P_SDM1010_GET_TAB1_PJT_REG` — 파라미터(정오표 #2 정정: 조회조건 4종 추가):
  `P_DIVISION_ID`(조회조건) / `P_END_CUSTOMER`(Multi, 콤마) / `P_DPJT_AUTH_TYPE`(Multi) / `P_DPJT_REG_STATUS`(Multi) / `P_REG_COMP_DATE_FR` / `P_REG_COMP_DATE_TO` / `P_USER_ID`(Session) / `P_MENU_ID`(Session) / `P_USER_GR_ID`(Session).
- 조회 성공 시 CRUD pending reset. 수정 중 재조회 시 confirm `MSG00703`(UC-02).

## E04. TAB1 행 추가

- 신규 행 삽입(CRUD_TYPE='C', EditTracker 공통 규약 — 자체 행상태 필드 금지).
- 기본값: DIVISION_ID=현재 조회 Division, DPJT_REG_STATUS='작성중'(코드), 등록요청일 공란.
- 신규 행 편집 활성 컬럼(P-16): Project Class(IM)/Customer(IM)/Project Name(IM)/Cell Type(IO)/Stack Method(IO)/Biz Type(IO)/SOP Date(IO)/SOP Plant(IO).
- 필터 걸린 상태에서 Insert → 필터 clear 후 행 표시(UC-01).

## E05. TAB1 행 삭제

- 가드(P-07): 신규 행 또는 등록 상태 '작성중' 행만 삭제 가능. 위반 시 메시지 "승인대기, 등록완료 상태의 프로젝트는 삭제할 수 없습니다"(신규 채번 — 정오표 #4).
- confirm "프로젝트를 삭제 하시겠습니까?"(신규 채번) → 삭제 마킹(CRUD_TYPE='D') — 실제 삭제는 저장 시 SAVE SP 경유.

## E06. TAB1 저장

- 검증(P-04/P-05): 필수 컬럼 누락 → `MSG00113` / 중복(논리키 DIVISION_ID+DPJT_CLASS+END_CUSTOMER+DPJT_NAME — 정오표 #9) → `MSG00043 {0}`.
- confirm "저장 하시겠습니까?"(신규 채번) → `P_SDM1010_SAVE_TAB1_PJT_REG`(sesUserId, data CLOB — CRUD_TYPE I/M/D) → 성공 `MSG00002` **Toast**(hook #132 §3) / 실패 `MSG00003`.
- Master-Detail: 프로젝트:권한 = 1:N — 프로젝트 삭제 시 권한·요청 종속 삭제(SP 내).

## E07. 등록요청 버튼

- 대상: 그리드 Checked 행.
- 가드(P-09/P-10): '작성중' 상태만 가능(신규 미저장 행 불가 — 확인사항 5.1) / 선택 0건 → "선택한 항목이 존재하지 않습니다."(신규 채번).
- confirm(SPMS 확인 팝업 — TAB1 도형 원문): "프로젝트를 등록 / 변경 하시겠습니까? * 프로젝트의 등록/변경 사항에 대하여 시스템 관리자에게 승인 요청토록 하겠습니다."
- SP: `P_SDM1010_BTN_REQ_PJT_REG` → 상태 '작성중'→'승인대기', 등록요청일=오늘. 성공 "성공적으로 등록요청 되었습니다." / 실패 "등록요청에 실패하였습니다."(신규 채번) → 재조회.

## E08. 요청취소 버튼

- 가드(P-12/P-13): '승인대기' 상태만 가능 — "작성중, 등록완료 상태의 프로젝트는 요청취소할 수 없습니다." / 선택 0건 동일.
- confirm "프로젝트 등록요청을 취소 하시겠습니까?" → `P_SDM1010_BTN_CANCEL_PJT_REG` → 상태 '승인대기'→'작성중' → 재조회.

## E09. TAB1 권한등록 링크 클릭

- 컬럼 `DPJT_AUTH_REG_STR`(Cell object=POPUP Link — 정오표 #1 철자 정정) 클릭 → `ProjectAuthRegModal` 오픈, 입력=행 프로젝트 키/코드/명.
- 승인대기 상태에서도 허용(확인사항 1.1 — P-17 예외).
- 신규(미저장) 행: 권한등록 불가 — 저장 후 가능(확인사항 2.1.4/2.2 미결 → 정오표 #10 정정: Master 선저장 필요).
- 닫힘 후: 메인 그리드 재조회 → `DPJT_AUTH_REG_STATUS` TAG 갱신(개요 F38).

## E10. TAB1 엑셀 / E16. TAB2 엑셀

- 엑셀 다운로드 — 콤보 컬럼은 NAME 출력(UC-05). TAB2 는 조회/엑셀만 유효(저장·삭제 `<해당없음>`).

## E11. 컬럼 설정 / E12. Measure 설정

- CustomButton → 공용 `ColumnSettingModal` / `MeasureSelectModal` 호출(hook #132 §2-1 — 사본 금지).
- 설정 저장 시: 그리드 비움 + CRUD reset(자동 재조회 금지 — UC-03/hook #132 §2-2), 저장 성공 Toast.

## E13. TAB1 셀 편집 가드·콤보

- 편집 가능 조건(P-15): 신규 행(CRUD_TYPE C) 또는 '작성중' 상태 행만. '승인대기'/'등록완료'/'반려' 행 편집 불가(P-17).
- 셀 콤보(CODE/NAME 페어 — 저장은 CODE, 표시는 NAME): Project Class=`DpjtClass`, Customer=`EndCustomer`, Cell Type=`CellTypeByDivision`, Stack Method=`StackMethod`, Biz Type=`BizTypeByDivision`, SOP Plant=`PlantByDivisionCompany`(Division 종속 — @division 따옴표 전달 계약).
- SOP Date=DATE 셀(YYYY.MM.DD). 편집 셀 Yellow / 잠금 Gray(3색 표준).

## E14. TAB2 조회

- 검증: `MSG00097`(Division) / `MSG00108`(기간 역전) / **3년 초과 → "조회 기간은 3년 이내로 입력해주세요."**(신규 채번 — P-03).
- SP: `P_SDM1010_GET_TAB2_PJT_LIST` — `P_DIVISION_ID`/`P_END_CUSTOMER`/`P_DPJT_AUTH_TYPE`/`P_DPJT_REG_STATUS`/`P_REG_COMP_DATE_FR`/`P_REG_COMP_DATE_TO`/`P_USER_ID`(Session).
- 결과: 본인이 권한 보유한 프로젝트 목록(나의 권한=DPJT_AUTH_TYPE) — 조회 전용(편집 없음).

## E15. TAB2 My Work 아이콘 클릭

- 컬럼 `MY_WORK`(ICON=Search Icon) 클릭 → `MyWorkModal` 오픈(입력=행 프로젝트 키).
- SP: `P_SDM1010_GET_POP_MY_WORK` — 조회 전용 최소 구현(그리드 15컬럼: 사업부/유형/고객/PJT Name/Sample A~D 일정/SOP 일정/SOP Site).
- 하단 요청 승인/반려 블록 = **설계 미완('내용 추가' 명시) — 이번 범위 제외**(사용자 확정, 후속 보완).

## E17. ProjectAuthRegModal 오픈

- 오픈 시: 조직도 조회 `P_SDM1010_GET_POP_USER_ORG`(트리 — DEPT_ID/DEPT_NAME/PARENT_DEPT_ID) + 기존 권한 조회 `P_SDM1010_GET_POP_PJT_AUTH_MGMT`(입력/조회 리스트) + 요청 조회 `P_SDM1010_GET_POP_PJT_AUTH_REQ`.
- 헤더: `* Project Name : {행 DPJT_NAME}` 표기(목업 도형).

## E18. 팝업 조직도 부서 선택 → 사용자 조회

- `P_SDM1010_GET_POP_USER_BY_DEPT`(부서 ID) → 사용자 목록(USER_ID/USER_NAME/JOB_CODE/JOB_NAME/DEPT).
- 조회 조건 값 없으면 그리드 미출력(확인사항 1.1 — P-18).

## E19. 팝업 (+) 버튼 — 입력/조회 리스트 추가

- 선택 사용자를 입력 또는 조회 리스트로 이동.
- 중복 가드(P-19/P-20): "User 는 입력 리스트에 이미 존재합니다." / "User 는 조회 리스트에 이미 존재합니다."(신규 채번 2건).

## E20~E22. 팝업 요청 승인/반려/제외

- E20 승인: 요청 행 → 해당 권한(입력/조회) 리스트에 추가 — OK 저장 시 확정(확인사항 2.2/P-21).
- E21 반려: 요청 행 → 반려 상태 표시 — OK 저장 시 확정(2.3/P-22). 요청 권한≠부여 권한이면 요청 상태 구분 표시(2.4/P-23).
- E22 x(제외): 권한 리스트에서 사용자 제거. 그 사용자의 미처리 요청이 존재하면 반려 처리(2.5/P-24).

## E23. 팝업 OK(저장)

- `P_SDM1010_SAVE_POP_PJT_AUTH_MGMT`(권한 리스트 전체) + `P_SDM1010_SAVE_POP_PJT_AUTH_REQ`(요청 처리 상태) 저장.
- 성공 "성공적으로 저장되었습니다."(MSG00002 Toast) / 실패 "저장에 실패하였습니다."(MSG00003).
- 닫힘 후 메인 그리드 재조회 → 권한등록 상태 TAG 갱신(E09 후처리와 동일).

## E24. 팝업 Close/X — 저장 없이 닫기 (pending 폐기)

## E25. 상태 TAG 렌더링

- `DPJT_REG_STATUS_NAME`(TAG): 작성중/승인대기/등록완료/반려/변경등록/변경요청 — 상태별 색.
- `DPJT_AUTH_REG_STATUS`(TAG, TAB1): 권한등록 진행 상태. `AUTH_REQ_STATUS`(TAG, 팝업 요청 리스트).
- 상태머신(TAB1_GRID 도형 범례 실측): `작성중 →(등록요청) 승인대기 →(승인) 등록완료 / →(반려) 반려`, `승인대기 →(요청취소) 작성중`, `등록완료 → 변경등록 → 변경요청 → 승인대기 → 등록완료`("변경요청 후 승인완료도 동일 상태 표시", "변경 후 원래 프로젝트 상태").
