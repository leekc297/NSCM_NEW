# SDM5010 Project Master — 제약매트릭스

> ⭐ 정본 원천 = `Doc/화면설계서_SDM/SDM5010/SDM5010_ProjectMaster_화면설계서_20260813.xlsx` (AS-IS 부재 — 순수 신규, hook #134) + `SQL_PACKAGE/PKG_SDM5010.txt` 원문.
> 정오표: `Doc/화면분석서/SDM5010_ProjectMaster_정오표.md`

## 0. 제약 전수표

| ID | 구분 | 제약 | 메시지/근거 |
|---|---|---|---|
| P-01 | 조회 | **Division 필수** — 미선택 시 조회 불가 | 개요 E13(필수 Y)·F25 "사업부(Div), 등록완료일 필수" — MSG00097(TAB1 E57/TAB2 E52 기재 확정) |
| P-02 | 조회 | **기간 필수 + 역전 금지**(시작일>종료일 불가) — 실필터 축 = `REG_COMP_DATE`(정오표 F-2 확정) | 개요 E18(필수 Y)·H18 "시작이 종료보다 클 수 없음" — MSG00108(E58/E53 기재 확정) |
| P-03 | 조회 | **기간 3년 이내** — 종료월이 시작월 기준 3년 초과 불가 | TAB2 F54 "조회 기간은 3년 이내로 입력해주세요."(MSG 공란 — MSG00164 재사용 후보, 정오표 F-8/T-2) |
| P-04 | TAB1 표시 | TAB1 조회 범위 = **Session Division + 본인(MGMT_USER_ID=P_SES_USER_ID) + `DPJT_REG_STATUS IN ('WAITING','REQ_MOD')`** — 조회조건 미소비(TAB2 전용 F-3) | PKG GET_TAB1 WHERE 원문 실측 — 본인 필터는 **설계 원문 유지 사용자 확정**(정오표 D14) |
| P-05 | TAB1 색상 | (등록) 구분 값 "수정" 행 색상 표시 — **`DPJT_REG_CAT` 기준 행 단위 확정**(커서에 원본값 부재 → 필드 diff 불가) | TAB1 확인 사항 1.1/1.1.1 + GET_TAB1 커서 실측(정오표 F-10 — 색상 토큰 미기재 T-7) |
| P-06 | TAB1 편집 | 구분 "수정" 행 = **D-PJT Code 수정 불가** | TAB1 확인 사항 2.1 — SP CONFIRM 수정 Case CODE 유지 원문 정합 |
| P-07 | TAB1 편집 | 수정 항목 = **11종 한정**: 사업부/유형/고객/Project Name/셀 유형/Stack 공법/Biz Type/SOP 일정/SOP Site/D-PJT Code/내용 — 그 외 잠금. D-PJT Code 는 F-9 모순 확정으로 **'신규' 행만** 편집 | TAB1 확인 사항 2.2/C82 + 정오표 F-9·F-14(Input Type 전 행 'S' 재지정) |
| P-08 | TAB1 편집 | **D-PJT Code = 6자리 필수 입력**("반드시 6글자") — SP WHERE `LENGTH(V_DPJT_CODE)=6` 가드. 가드 불충족 시 0건 갱신 허위성공은 정오표 D12 정정 승인(FE 선검증 + SP EVENT=0 실패 반환) | TAB1 확인 사항 2.3 + PKG CONFIRM WHERE 원문 |
| P-09 | 승인 | 승인 = GRID **Focused Row 단건** + confirm("승인하시겠습니까?") + 성공/실패 메시지 | TAB1 시트 K41~K55(GRID Focused Row)·F68~F70(MSG 공란 T-2, "실해" 오타 F-7) |
| P-10 | 반려 | 반려 = GRID Focused Row 단건 + confirm("반려하시겠습니까?") + **내용(P_NOTE) 전달** + 성공/실패 | TAB1 시트 H35~K39·F64~F66 |
| P-11 | NOTE 전파 | 내용 등록 시 **연결된 프로젝트(동일 D-PJT Code) 전행 동일 내역 Update** — 기존 내용 존재 시 딜리미터 후 연결(예: MC25/26/27 → "AA, BB") | TAB1_GRID S16~S21 목업 규약 + PKG CANCEL/CONFIRM MERGE(`NOTE ⏐⏐ ', ' ⏐⏐ P_NOTE`) 원문 — 반려 본행 덮어쓰기 상이는 정오표 D17 |
| P-12 | TAB2 편집 | **편집 = 개발현황(DPJT_DEVELOP_STATUS) + 비활성(DISABLE_YN) 2컬럼만** — 나머지 전 컬럼 잠금 | TAB2 시트 저장 파라미터 축 H43~H47(P_ACTIVE_FLAG/P_DPJT_KEY/P_DPJT_DEVELOP_STATUS/P_DISABLED/P_SES_USER_ID — 2컬럼뿐) + 정오표 F-14 |
| P-13 | TAB2 저장 | P_ACTIVE_FLAG 계약 = I/D/M 이나 화면은 행 추가/삭제 부재 — **FE 는 'M' 행만 전달** | TAB2 시트 K43(I/D/M) + 화면 구성(Insert/Delete 버튼 부재) — 신규 SP(D1) 계약에 반영 |
| P-14 | TAB2 표시 | TAB2 조회 범위 = `DPJT_REG_STATUS NOT IN ('WRITING','WAITING','REQ_MOD')`(작성중/승인대기/변경요청 제외 — COMPLETE/REJECT/MODIFIED 등 표시) | PKG GET_TAB2 WHERE 원문 — 'MODIFIED' lookup 정합은 정오표 D13 |
| P-15 | 팝업 조회 | 검색 = **사용자 조회 조건 값만** 전달 — 조건 값 없으면 그리드 미출력 | 팝업 확인 사항 1.1/1.1.1 |
| P-16 | 팝업 조회 | 조직도 부서 클릭 = **부서 정보만** 전달하여 사용자 목록 호출 | 팝업 확인 사항 2.1(§1) |
| P-17 | 팝업 (+) | **관리자 추가 불가**("관리자는 권한을 추가할 수 없습니다." F81) + 입력/조회 리스트 기존재 중복 불가(F79/F80) — 입력·조회 **양쪽 모두 체크** | 팝업 확인 사항 4.1/4.2/4.2.1 (MSG 공란 T-2) |
| P-18 | 팝업 (−) | 요청 이력 보유자를 입력/조회에서 제외 시 **요청 그리드 복귀** — 입력/조회 그리드는 최초 Load 부터 요청 정보 invisible 보유 의무 | 팝업 확인 사항 2.2/2.2.1~2.2.3("invisible but exists in SQL") |
| P-19 | 팝업 반려 | 반려 = Alert(confirm) 후 **즉시 SP 호출**(OK 저장과 무관) → "반려" 상태 즉시 표시 | 팝업 확인 사항 2.3/2.3.1 — 공용 모달 정본과의 승계 차이는 이벤트 E15 부기 |
| P-20 | 팝업 저장 | OK = 최종 확정 — **입력/조회 그리드의 모든 값을 저장 SP 에 전달**("반려" 상태 Update + 권한 제외자 요청 이력 반려 처리) | 팝업 확인 사항 2.1(§2)/3.1/3.1.1/3.1.2 |
| P-21 | 권한 | 접근 권한 그룹 = **SPMS Administrator 단독 확정** | 개요 C7 (정오표 F-19) |

## 1. 메시지 코드 전수 (설계서 기재분)

| 위치 | MSG | 문구(원문) | 조건 |
|---|---|---|---|
| TAB1 E57/TAB2 E52 | MSG00097 | Division 을 선택하세요. | Division 미선택 |
| TAB1 E58/TAB2 E53 | MSG00108 | 조회 기간이 잘못되었습니다 (시작일 > 종료일). | 기간 역전 |
| TAB2 F54 | (공란 — T-2) | 조회 기간은 3년 이내로 입력해주세요. | 3년 초과 (MSG00164 재사용 후보) |
| TAB1 F64~F66 | (공란 — T-2) | 반려 confirm / 성공 / 실패("실해" 오타 F-7) | 반려 버튼 |
| TAB1 F68~F70 | (공란 — T-2) | 승인 confirm / 성공 / 실패("실해" 오타 F-7) | 승인 버튼 |
| 팝업 F79~F81 | (공란 — T-2) | 입력 리스트 기존재 / 조회 리스트 기존재 / 관리자 추가 불가 | (+) 버튼 |
| 팝업 F83~F84 | (공란 — T-2) | 저장 성공(MSG00002 Toast) / 저장 실패(MSG00003) | OK 버튼 |

- TAB1 저장/삭제 버튼 메시지 = `<해당없음>`(B60/B62) — TAB1 은 저장 버튼 자체가 없음(B31/B33).
- 미기재 MSG 는 구현 시 locales 실문구 대조 후 재사용 우선, 없을 때만 01001+ 대역 신규 채번(T-2 — 공번 메우기 금지).

## 2. SP 가드·검증 축 (PKG 원문 실측)

| SP | 가드 | 원문 근거 |
|---|---|---|
| GET_TAB1 | division=Session·본인·WAITING/REQ_MOD 3중 필터 (P-04) | WHERE 절 3술어 |
| BTN_TAB1_CONFIRM | `SELECT INTO` 대상 행 실존 전제(무가드 — D10) / 6자리 CODE WHERE 가드(P-08 — 허위성공 D12) / 수정 Case CODE·KEY 유지(P-06) | L649~688 |
| BTN_TAB1_CANCEL | 가드 없음 — confirm 은 FE 몫(P-10) | 전문 |
| GET_TAB2 | 'ALL' 무필터 5축 + REG_COMP_DATE BETWEEN(양 NULL 무필터) + NOT IN 3상태(P-14) | WHERE 절 |
| SAVE_TAB2 (D1 신규) | 필수값(P_DPJT_KEY/P_DPJT_DEVELOP_STATUS)·계약 외 CRUD_TYPE 거부(SDM1010 [가드 0] 판례)·'M' 한정(P-13) | 설계 계약 H43~K47 |

## 3. 공통 축 (COMMON:UC-01~07 — 대사표 상시 축)

- UC-01 Insert 필터 유지 / UC-02 수정 중 재조회 confirm MSG00703 / UC-03 설정 저장=그리드 비움 / UC-04 저장 성공 Toast / UC-05 Excel Name·콤보 NAME / UC-06 콤마 다중 조회 / UC-07 재조회 필터 유지(`rebindFilterColumns`) — 단일 소스 `asis_mapping_gate.py::UI_COMMON_ITEMS`. 행 추가 없는 화면이므로 UC-01 은 해당없음 사유 처리 예정(대사표에서 판정).
