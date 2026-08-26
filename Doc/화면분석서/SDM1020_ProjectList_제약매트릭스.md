# SDM1020 Project List — 제약매트릭스

> ⭐ 정본 원천 = `Doc/화면설계서_SDM/SDM1020/SDM1020_ProjectList_화면설계서_20260814.xlsx` (AS-IS 부재 — 순수 신규, hook #134).
> 정오표: `Doc/화면분석서/SDM1020_ProjectList_정오표.md`

## 0. 제약 전수표

| ID | 구분 | 제약 | 메시지/근거 |
|---|---|---|---|
| P-01 | 편집 | **관리자(나의 권한 ADMIN)인 경우만 항목 수정 가능** — 비관리자 행 전 셀 잠금 | 확인 사항 1.1 / 3.1.1 (입력 활성화 조건) — GET 커서 `DPJT_AUTH_TYPE` 행별 판정 |
| P-02 | 권한관리 | **권한관리 링크 = 나의 권한이 관리자인 경우만** — SP 가 ADMIN 행만 `''`(노출), 그 외 `'-'` | 확인 사항 1.2 — GET 커서 `DPJT_AUTH_MGMT` CASE 실측 |
| P-03 | 권한요청 | **권한요청 = 나의 권한이 권한없음·조회 권한인 경우만 가능** (관리자/입력 권한 행 = 링크 `-`) | 확인 사항 1.3 — GRID 목업 Q/Y열 대응 실측 |
| P-04 | 권한요청 | 권한요청 가능한 경우가 아니면 입력/조회 **Checkbox 비활성** — SP 행별 3상태(`DISABLED`/`CHECKED`/`UNCHECKED`) 단일 원천 | 확인 사항 1.3.1 — GET 커서 `DPJT_AUTH_REQ_WRITE`/`_READ` CASE 실측 |
| P-05 | 편집 | 입력/조회 Checkbox **상호배타** — 하나 선택하면 다른 쪽 자동 해제(Unchecked) | 확인 사항 2.1 / 2.1.1 |
| P-06 | 등록요청 | **변경 내역이 있는 경우만 등록요청 가능** — 없으면 "수정된 내용이 없습니다." | 확인 사항 3.2/3.2.1 + Project List F65 (MSG00004 재사용 후보) |
| P-07 | 등록요청 | Checked 선택 0건 시 불가 — "선택한 항목이 존재하지 않습니다." | Project List F66 (MSG00709 재사용 — 동문 실측) |
| P-08 | 등록요청 | 실행 전 Confirm "프로젝트를 등록/변경 하시겠습니까?" + 성공/실패 메시지 | Project List F67~F69 (MSG00710/00711/00712 재사용 — 동문 실측) |
| P-09 | 조회 | **Division 필수** — 미선택 시 조회 불가 | 개요 E13(필수 Y)·F24 "사업부(Div), 등록완료일 필수" — MSG00097(기재 확정) |
| P-10 | 조회 | **등록 완료일 필수 + 기간 역전 금지**(시작일>종료일 불가) | 개요 E17(필수 Y)·H17 "시작이 종료보다 클 수 없음" — MSG00108(기재 확정) |
| P-11 | 권한요청 | 입력/조회 선택(Checked) 값 없으면 불가 — "권한요청 항목이 없습니다." | Project List F70 (신규 채번 — 정오표 미결) |
| P-12 | 권한요청 | 실행 전 Confirm "권한요청 하시겠습니까?" / 취소 경로 "권한요청을 취소 하시겠습니까?"(요청 Checked 를 해제하고 요청하는 경우) + 성공/실패 | Project List F71~F74·I72 (신규 채번 4~5건 — 취소 경로는 정오표 D12) |
| P-13 | 팝업 조회 | 검색 = **사용자 조회 조건 값만** 전달 — 조건 값 없으면 그리드 미출력 | 팝업 확인 사항 1.1 / 1.1.1 |
| P-14 | 팝업 조회 | 조직도 부서 클릭 = **부서 정보만** 전달하여 사용자 목록 호출 | 팝업 확인 사항 2.1(§1) |
| P-15 | 팝업 (+) | **관리자는 권한 추가 불가** — "관리자는 권한을 추가할 수 없습니다." | 팝업 확인 사항 4.1 + F81 (신규 채번) |
| P-16 | 팝업 (+) | 입력 또는 조회 리스트 **기존재 사용자 추가 불가** — 추가 방향과 무관하게 입력/조회 리스트 모두 체크 | 팝업 확인 사항 4.2/4.2.1 + F79/F80 (MSG00716/00717 재사용 — 동문 실측) |
| P-17 | 팝업 저장 | 저장(OK) 버튼을 클릭해야 **최종 저장**(입력/조회 이동·요청 승인 이동은 pending) | 팝업 확인 사항 2.1(Process)·2.2.1 계열 |
| P-18 | 팝업 제외 | 요청 정보 존재 사용자를 입력/조회 그리드에서 삭제(−)하면 **요청 그리드에 복귀 추가** — 이를 위해 입력/조회 그리드 Load·이동 시 요청 정보 invisible 보유 의무 | 팝업 확인 사항 2.2 / 2.2.1 / 2.2.2 / 2.2.3 |
| P-19 | 팝업 반려 | 반려 버튼 = Alert 후 **바로 반려 처리(SP 즉시 호출 — OK 무관)** + "반려" 상태 즉시 표시 | 팝업 확인 사항 2.3 / 2.3.1 — `P_SDM1010_SAVE_POP_BTN_REJECT` |
| P-20 | 팝업 저장 | OK 저장 시 입력/조회 그리드 **모든 값 전달** — "반려" 상태 Update(3.1.1) + 권한 제외자의 요청 이력 반려 처리(3.1.2) | 팝업 확인 사항 3.1 ~ 3.1.2 |
| P-21 | 편집 | 편집 대상 컬럼 축 = Project Class/Customer/Project Name/Cell Type/Stack Method/Biz Type/SOP Date/SOP Plant/개발 현황 — INPUT_TP_CD 단일 원천(IM/IO 재지정, 설계서 전 행 'S' 는 정오표 D5) | UI컬럼 정의 시트 W열 vs 확인 사항 1.1 대조 |
| P-22 | 데이터 | 상태 TAG 도메인 = GRID 범례 9행(작성중/승인대기/등록완료/반려/변경등록/변경중/변경요청/등록완료(변경)/**'변경반려' 코드 미정**) — lookup `SPMS_DPJT_REG_STATUS` 단일 원천 | GRID R36~R45 (미정분은 정오표 미결) |
| P-23 | 데이터 | 콤보 컬럼 = CODE/NAME 페어 — 저장 CODE·표시 NAME(Visible=N/Y 쌍) | UI컬럼 정의 시트 S열 실측(DPJT_AUTH_TYPE/DPJT_REG_STATUS 등 페어) |
| P-24 | 권한 | 화면 접근 = `SPMS Administrator` / `SPMS Planner`(개요 B7) — 행 단위 권한은 그룹이 아니라 **프로젝트별 나의 권한(SPMS_PROJECT_USER_MAP)** 이 지배(P-01~P-04) | 개요 권한그룹 + GET 커서 USM 서브쿼리 실측 |
| P-25 | 저장 경로 | **저장 버튼 없음** — 그리드 수정 내역은 [등록요청] 에 의해서만 저장(변경본 신규 INSERT + 원본 MODIFYING 전이) | 개요 B27 + Project List B50/B51 `<해당없음>` |
| P-26 | 조회조건 | 사업부 변경 = 컬럼정보 재조회 + 그리드 초기화 + CRUD reset (재조회는 Search 버튼) | 개요 H13 — Division 변경 규약 |
| P-27 | 조회조건 | 기본값 = 사업부 첫 값 / 고객·나의 권한·등록 상태 ALL / 등록 완료일 M-1~Today(`PR_GET_DAY_RANGE`) | 개요 F13~F17 |
| P-28 | 팝업 후처리 | 팝업 처리 후(반환 E33 "POPUP 내에서 처리") 메인 그리드 재조회 → "입력/조회 권한등록" 상태 값 update | 개요 F33 |

## 1. 나의 권한(행) × 기능 매트릭스 (P-01~P-04 종합 — GET 커서 CASE 실측)

| 나의 권한 (DPJT_AUTH_TYPE) | 셀 편집 | 권한관리 링크 | 권한요청 링크 | 입력/조회 Checkbox |
|---|---|---|---|---|
| 관리자 (ADMIN, CONFIRM) | ✅ (유일) | ✅ ('') | ⛔ ('-') | DISABLED |
| 입력 권한 (WRITE, CONFIRM) | ⛔ | ⛔ ('-') | ⛔ ('-') | DISABLED |
| 조회 권한 (READ, CONFIRM) | ⛔ | ⛔ ('-') | ✅ ('권한요청') | UNCHECKED (선택 가능) |
| 권한 없음 (NONE — 매핑 없음 또는 REQUEST 상태) | ⛔ | ⛔ ('-') | ✅ ('권한요청') | UNCHECKED / 요청 중 CHECKED |
| 요청 중 (WRITE·READ + REQUEST) | ⛔ | ⛔ | ✅ (취소 경로 — D12) | CHECKED (해당 유형) |

- 근거: GET 커서 `DPJT_AUTH_MGMT`/`DPJT_AUTH_REQ_WRITE`/`DPJT_AUTH_REQ_READ` CASE + REQUEST 상태 → 'NONE'/'권한없음' 치환 실측. GRID 목업(Q/U/W/X/Y열) 행 패턴과 일치.
- ⚠ READ+CONFIRM 보유자의 READ 체크박스: SP 는 `READ`+`REQUEST` 만 CHECKED, `READ`+`CONFIRM` 은 UNCHECKED(재요청 가능 — WRITE 상향 요청 용도. 목업 3행 '조회 권한' 행에 입력/조회 둘 다 □ 표시와 정합).

## 2. 편집/콤보 컬럼 매트릭스 (UI컬럼 정의 시트 SDM1020 블록 30행 전수)

| 컬럼 | Cell object | 콤보(Cell Combo Data Type) | Visible | 편집(정오표 D5 재지정) |
|---|---|---|---|---|
| DPJT_KEY / DPJT_SEQ | — | — | N | S (키) |
| DPJT_CODE | — | — | Y | S |
| DIVISION_ID | FPComboBox | Division | Y | S (표시 콤보 — 조회조건 종속) |
| DPJT_CLASS | FPComboBox | DpjtClass | Y | IM |
| END_CUSTOMER | FPComboBox | EndCustomerByDivisionDept | Y | IM |
| DPJT_NAME | — | — | Y | IM |
| CELL_TYPE | FPComboBox | CellTypeByDivision | Y | IO |
| STACK_METHOD | FPComboBox | StackMethodByCellType | Y | IO |
| BIZ_TYPE | FPComboBox | BizTypeByDivision(확정 — 정오표 미결 참조) | Y | IO |
| SOP_DATE | FPDate | YYYY.MM.DD | Y | IO |
| SOP_PLANT_ID | FPComboBox | PlantByDivisionCompany | Y | IO |
| DEPT_ID / DEPT_NAME | — | — | N / Y | S (프로젝트 관리자·부서) |
| MGMT_USER_ID / USER_NAME | — | — | N / Y | S |
| DPJT_AUTH_TYPE / _NAME | — | — | N / Y | S (나의 권한 — Division 81 계열 한정 X열) |
| DPJT_REG_STATUS / _NAME / _COLOR_TYPE | TAG | — | Y / N / N | S (정오표 D1 참조 — NAME 페어 Visible 관례 역전 관찰) |
| REG_COMP_DATE | FPDate | YYYY.MM.DD | Y | S |
| DPJT_DEVELOP_STATUS | FPComboBox | DpjtDevelopStatus | Y | IO (개발 현황 — 편집 대상, X열 81·82) |
| DPJT_AUTH_MGMT | (공란 — 정오표 D7: FPModal+ATTRIBUTE1) | — | Y | S (링크) |
| DPJT_AUTH_REQ_STATUS / _NAME / _COLOR_TYPE | TAG | — | Y | S (정오표 D2 — 커서명 정합) |
| DPJT_AUTH_REQ_WRITE / _READ | FPCheckBox | — | Y | 체크 편집(P-04/P-05 가드) |
| DPJT_AUTH_REQ_READ(2번째 — Exec. Link) | Exec. Link | — | Y | S (정오표 D1 — FE 파생 컬럼으로 대체) |

- Sort Order 중복(120/170/180/190/200)은 정오표 D6 — GRID 목업 열 순서 기준 재부여.
- X(Division)/Y(Column param1)열: 나의 권한·권한 계열 컬럼 = 81 계열(81,81_UC,81_HM,81_ST,81_HD,81_HG) 또는 81·82(+REG_COMP_DATE 는 40 포함) — Division 종속 표시 컬럼.

## 3. 메시지 전수 (설계서 메시지 코드 블록 — Main 12행 + 팝업 5행)

| 트리거 | 문구(원문) | 코드 | 처리 |
|---|---|---|---|
| 조회 | Division 을 선택하세요. | MSG00097 | 기재 확정 (locales 동문 실측) |
| 조회 | 조회 기간이 잘못되었습니다 (시작일 > 종료일). | MSG00108 | 기재 확정 (동문 실측) |
| 등록요청 | 수정된 내용이 없습니다. | 공란 | MSG00004("수정한 내용이 없습니다.") 재사용 후보 — 문구 근사(정오표 미결) |
| 등록요청 | 선택한 항목이 존재하지 않습니다. | 공란 | MSG00709 재사용 (동문 실측) |
| 등록요청 | 프로젝트를 등록/변경 하시겠습니까? | 공란 | MSG00710 재사용 (동문+부가문 실측) |
| 등록요청 | 성공적으로 등록요청 되었습니다. | 공란 | MSG00711 재사용 (동문 실측) |
| 등록요청 | 등록요청에 실패하였습니다. | 공란 | MSG00712 재사용 (동문 실측) |
| 권한요청 | 권한요청 항목이 없습니다. | 공란 | 신규 채번 (01001+ 대역) |
| 권한요청 | 권한요청 하시겠습니까? | 공란 | 신규 채번 |
| 권한요청 | 권한요청을 취소 하시겠습니까? | 공란 | 신규 채번 (D12 취소 경로 종속) |
| 권한요청 | 성공적으로 권한요청 되었습니다. | 공란 | 신규 채번 |
| 권한요청 | 권한요청에 실패하였습니다. | 공란 | 신규 채번 |
| 팝업 (+) | User 는 입력 리스트에 이미 존재합니다. | 공란 | MSG00716 재사용 (동문 실측) |
| 팝업 (+) | User 는 조회 리스트에 이미 존재합니다. | 공란 | MSG00717 재사용 (동문 실측) |
| 팝업 (+) | 관리자는 권한을 추가할 수 없습니다. | 공란 | 신규 채번 |
| 팝업 OK | 성공적으로 저장되었습니다. | 공란 | MSG00002 재사용 (동문 실측 — Toast) |
| 팝업 OK | 저장에 실패하였습니다. | 공란 | MSG00003 재사용 (동문 실측) |

- 코드 공란 15건(Main 10 + 팝업 5) 전수 — 재사용 확정/후보 9건, 신규 채번 6건(01001+ 대역 — 전대역 max+1·공번 메우기 금지, MSG00704→MSG01001 재채번 판례). 상세 채번은 메타 SQL 단계.
