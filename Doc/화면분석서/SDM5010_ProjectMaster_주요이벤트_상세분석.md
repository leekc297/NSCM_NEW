# SDM5010 Project Master — 주요 이벤트 상세분석

> ⭐ **정본 원천 = 화면설계서 xlsx** (AS-IS GSCM 대응 화면 부재 — 순수 신규 화면, hook #134 §0/§2).
> 본 md 는 hook #105 E번호 양식으로 재기술한 설계서 전수 분석이며, `asis_mapping_gate --init` 의 원천이다.

## 원천 (전수 Read 실측)

| 구분 | 경로 | 비고 |
|---|---|---|
| 정본 설계서 | `Doc/화면설계서_SDM/SDM5010/SDM5010_ProjectMaster_화면설계서_20260813.xlsx` | 10시트 전수 덤프 (openpyxl + xl/drawings/*.xml 도형 텍스트 파싱. v1.0 확정 2026-08-04, 작성 김태종) |
| SP 원문 | `Doc/화면설계서_SDM/SDM5010/SQL_PACKAGE/PKG_SDM5010.txt` (1,122줄 전문) | 신규 4본 (KTJ 2026-08-14) — **TAB2 저장 SP 부재** (정오표 D1: 신규 작성 승인) |
| 테이블 DDL | `Doc/화면설계서_SDM/SDM5010/TABLE/SPMS_PROJECT_MST.txt` / `SPMS_PROJECT_USER_MAP.txt` | ⚠ **구본** — MST 34컬럼(PKG 사용 `DPJT_MGMT_STATUS`/`DPJT_KEY_PARENT`/`CNFM_USER_ID` 3컬럼 부재)·USER_MAP 21컬럼. **DB 실물 37/22컬럼이 정본 확정** (정오표 T-5) |
| 팝업 SP 재사용 실존 확인 | `_artifacts/_apply_corporate/SDM1010_DBSWAP_20260813/04_PKG_RECEIVED_PATCHED.sql` | 설계서 기재 `P_SDM1010_*` 팝업 8본 전부 수신 PKG_SDM1010 에 실존 — SDM1020 O-5 판례와 동일 대조 |
| 기간 SP 실서명 | `_artifacts/_diagnostics/db_object_census_20260728/sources/SCM_MGR.PR_GET_DAY_RANGE.PROCEDURE.sql` | **5-arg 실서명**: `p_created_by`/`p_month` IN 2 + `O_RC1`/`O_RC2`/`O_RESULT_CURSOR` OUT 3 (정오표 F-1) |
| 정오표 | `Doc/화면분석서/SDM5010_ProjectMaster_정오표.md` | PKG 결함 D1~D24 + 설계서 F-1~F-23 + 미결 T-1~T-12 |

- 화면 구조: **탭 2본**(TAB1 프로젝트 등록 요청 / TAB2 프로젝트 Master 관리 — 레이아웃 시트 B5/B41 + drawing6/7 도형 실측) + 팝업 1(`권한관리` — SDM1010 ProjectAuthRegModal 계열 재사용) + 공용 설정 모달(`ColumnSettingModal` — SP `?` 미결 T-1).
- 화면 성격: 프로젝트 **등록 요청의 승인/반려**(TAB1 — 관리자) + **전체 프로젝트 리스트 관리**(TAB2 — 개발현황·비활성 편집). 개요 C6 원문.
- 권한 그룹: `SPMS Administrator` **단독** (개요 C7 — 정오표 F-19 확정).
- 조회조건 6종(개요 B11:H18): 사업부(`MyDivision`, Single, 필수, 첫 값 — LBL00001)/고객(`EndCustomerByDivision`, Multi, ALL, 사업부 종속)/Cell 유형(`SCM0001_GET_LOOKUP_VALUES` p_lookup_type=`SPMS_CELL_TYPE`, Multi, ALL)/Biz Type(**`BizTypeByDivision` 확정** — F-18, Multi, ALL, 사업부 종속)/개발 현황(동 SP `SPMS_DPJT_DEVELOP_STATUS`, Multi, ALL)/등록 요청일(Date, 필수, M-1~Today — **실필터 축 = REG_COMP_DATE 확정** F-2, 실서명 SP = `PR_GET_DAY_RANGE` 5-arg F-1). **조회조건은 TAB2 전용 소비**(TAB1 SP 는 Session 4종만 — F-3).
- SP: **신규 4본**(PKG_SDM5010) `P_SDM5010_GET_TAB1_PJT_REG_REQ` / `P_SDM5010_BTN_TAB1_CANCEL` / `P_SDM5010_BTN_TAB1_CONFIRM` / `P_SDM5010_GET_TAB2_PJT_MASTER` + **신규 작성 1본**(D1 승인) `P_SDM5010_SAVE_TAB2_PJT_MASTER` + **재사용 8본**(PKG_SDM1010) `P_SDM1010_GET_POP_USER_ORG` / `GET_POP_USER_BY_DEPT` / `GET_POP_PJT_AUTH_WRITE` / `GET_POP_PJT_AUTH_READ` / `GET_POP_PJT_AUTH_REQ` / `SAVE_POP_PJT_AUTH_WRITE` / `SAVE_POP_PJT_AUTH_READ` / `SAVE_POP_BTN_REJECT`.

## 이벤트 전수 요약표

| EID | 트리거 | 처리 | SP / 대상 |
|---|---|---|---|
| E01 | 화면 진입(초기화) | 조회조건 콤보 적재 + 기간 기본값 M-1~Today + 컬럼 메타 + 버튼 권한 | MyDivision·EndCustomerByDivision·LOOKUP 2종·BizTypeByDivision·PR_GET_DAY_RANGE |
| E02 | 사업부(Division) 변경 | 컬럼정보 재조회 + 그리드 초기화 + CRUD reset + 종속 콤보 재적재 | fetchStaticColumns / 콤보 재조회 |
| E03 | 탭 전환(TAB1↔TAB2) | 활성 그리드 전환 — 공통버튼 활성그리드 라우팅 + 수정 중 confirm | — |
| E04 | TAB1 조회(Search) | Session 기반 등록 요청 조회(조회조건 미소비 — F-3) | P_SDM5010_GET_TAB1_PJT_REG_REQ |
| E05 | TAB1 그리드 셀 편집 | 수정 항목 11종 편집 — '수정' 구분 행 D-PJT Code 편집 불가(F-9)·6자리(P-08) | — |
| E06 | TAB1 승인(행 버튼) | Focused Row 단건 → confirm → 승인 처리 → 재조회 | P_SDM5010_BTN_TAB1_CONFIRM |
| E07 | TAB1 반려(행 버튼) | Focused Row 단건 → confirm → 반려 처리 → 재조회 | P_SDM5010_BTN_TAB1_CANCEL |
| E08 | 권한관리 링크 클릭 | 권한관리 팝업 오픈(프로젝트 키 전달) | 팝업 SP 8본 |
| E09 | 팝업 오픈(초기 조회) | 조직도 + 입력 권한 + 조회 권한 + 권한요청 4축 조회 | P_SDM1010_GET_POP_USER_ORG / GET_POP_PJT_AUTH_WRITE / _READ / _REQ |
| E10 | 팝업 사용자 검색 | 사용자 조회 조건 값만 전달 → 사용자 목록 조회(조건 없으면 미출력) | P_SDM1010_GET_POP_USER_BY_DEPT |
| E11 | 팝업 조직도 부서 클릭 | 부서 정보만 전달 → 사용자 목록 조회 | P_SDM1010_GET_POP_USER_BY_DEPT |
| E12 | 팝업 (+) 버튼 | 사용자를 입력/조회 리스트에 추가(관리자·중복 가드) | — (pending) |
| E13 | 팝업 (−) 버튼 | 입력/조회 리스트에서 제외 — 요청 이력 보유자는 요청 그리드 복귀 | — (pending) |
| E14 | 팝업 요청 그리드 입력/조회 이동 | 요청 행을 입력/조회 리스트로 이동(요청 정보 보유) | — (pending) |
| E15 | 팝업 반려 버튼 | Alert 후 **즉시 SP 호출** → 반려 상태 즉시 표시 | P_SDM1010_SAVE_POP_BTN_REJECT |
| E16 | 팝업 OK(저장) | 입력/조회 그리드 전량 전달 저장 → 성공/실패 → 메인 재조회 | P_SDM1010_SAVE_POP_PJT_AUTH_WRITE / _READ |
| E17 | 팝업 Close/X | 저장 없이 닫기(pending 폐기) | — |
| E18 | TAB2 조회(Search) | 필수(Division·기간)·역전·3년 검증 → Master 조회 | P_SDM5010_GET_TAB2_PJT_MASTER |
| E19 | TAB2 그리드 셀 편집 | **개발현황(콤보) + 비활성(체크) 2컬럼만** 편집(P-12) — CRUD 'M' 마킹 | — |
| E20 | TAB2 저장 버튼 | 필수·중복 확인 → 저장 → Toast → 재조회 | P_SDM5010_SAVE_TAB2_PJT_MASTER (**D1 신규 작성**) |
| E21 | 엑셀 버튼 | 활성 그리드 엑셀 다운로드(콤보 NAME 출력) | — |
| E22 | 컬럼 설정 버튼 | 공용 ColumnSettingModal 호출 — **SP `?` 미결(임의 배선 금지)** | (미결 T-1) |
| E23 | 기본 기능 | 조회조건 Condition/Reset Condition + 컬럼 Filter/Sort | — |
| E24 | TAG·행 색상 렌더링 | 권한등록 상태 TAG + TAB1 '수정' 구분 행 색상(행 단위 — F-10) | — |

---

## E01. 화면 진입(초기화)

1. 조회조건 콤보 적재(1RT `useTabComboQueries`): 사업부=`MyDivision`(사용자 권한 기반, 첫 번째 값 기본 선택·필수 — 개요 F13), 고객=`EndCustomerByDivision`(Multi, 기본 ALL, 사업부 종속 — 개요 H14), Cell 유형=`SCM0001_GET_LOOKUP_VALUES(p_lookup_type='SPMS_CELL_TYPE')`(Multi, ALL — 개요 H15), Biz Type=`BizTypeByDivision`(Multi, ALL, 사업부 종속 — 개요 G16 `DmBizType` 기재이나 H16 "사업부에 종속" 요건으로 **BizTypeByDivision 확정** F-18), 개발 현황=동 SP `'SPMS_DPJT_DEVELOP_STATUS'`(Multi, ALL — 개요 H17, lookup 시드는 목업 도메인 DEV/PROD/DROP 임시 — T-4).
2. 등록 요청일 기본값: **M-1 ~ Today**(개요 F18). 설계 기재 SP `P_SDM1010_GET_PERIOD`(H18 — 7-param 설명)는 실배선 시 `PR_GET_DAY_RANGE` **5-arg 실서명**(p_created_by/p_month + O_RC1/O_RC2/O_RESULT_CURSOR — census 실측)으로 대체(F-1 — SDM1010 R4·SDM1020 계약 ⑤ 판례: o_rc2 DAY_RANGE 앵커 + FE dayjs 병행 산출).
3. 그리드 컬럼 메타: `fetchStaticColumns`(SCM_MST_SHEET_COLUMNS — TAB1 24행 + TAB2 24행, UI컬럼 정의 시트 실측. mount 시).
4. 버튼 권한: `useTabBtnPermissions` — SPMS Administrator 단독(F-19).
5. 초기 자동조회 여부는 설계서 미기재(T-6 — 확정 전 자동조회 미배선, Search 버튼 대기).

## E02. 사업부(Division) 변경

- 설계서 개요 H13 원문: "사용자 권한에 따라 표시 - 변경 시 컬럼정보를 재조회, 그리드 내용 초기화".
- 처리: ①종속 콤보 재적재(고객 `EndCustomerByDivision`·Biz Type `BizTypeByDivision` — ALL reset) ②`fetchStaticColumns` 재조회 ③양 탭 그리드 데이터 비움 + CRUD pending reset. 재조회는 Search 버튼(자동 재조회 금지 — Division 변경 규약).

## E03. 탭 전환(TAB1 프로젝트 등록 요청 ↔ TAB2 프로젝트 Master 관리)

- 레이아웃 시트 B5/B41 + drawing6/7 도형("프로젝트 등록 요청"/"프로젝트 Master 관리") 실측 — 탭 2본.
- 공통버튼(조회/저장/엑셀/컬럼설정)은 **활성 그리드 라우팅**(hook #97). 저장 버튼은 TAB2 전용 활성(TAB1 시트 B31 저장=`<해당없음>`), 승인/반려는 TAB1 행 버튼 전용(TAB2 시트에 부재).
- 수정 중 탭 전환/재조회 confirm = MSG00703(UC-02 공통 축).

## E04. TAB1 조회(Search)

- SP: `P_SDM5010_GET_TAB1_PJT_REG_REQ` — **Session 4 IN**(`P_SES_DIVISION_ID`/`P_SES_USER_ID`/`P_SES_MENU_ID`/`P_SES_USER_GR_ID`) + O_CURSOR + O_RESULT_CURSOR (TAB1 시트 H26~K29 = SP 시그니처 일치 실측). 조회조건 파라미터 부재 — **조회조건 = TAB2 전용**(F-3). `P_SES_MENU_ID`/`P_SES_USER_GR_ID` 는 수신만 하고 미사용(D7).
- SP 내부 필터(원문 실측): `DIVISION_ID = P_SES_DIVISION_ID` + `MGMT_USER_ID = P_SES_USER_ID`(**본인 관리 프로젝트 한정 — 설계 원문 유지 사용자 확정** D14) + `DPJT_REG_STATUS IN ('WAITING','REQ_MOD')`(등록요청/변경요청만).
- 커서 산출(원문 실측): PJM 원장 + lookup NAME 페어(DPJT_REG_CAT/DPJT_CLASS/CELL_TYPE/STACK_METHOD/BIZ_TYPE) + `'권한관리' AS DPJT_ATUH_REG_STR`(POPUP Link — ATUH 오타 alias 는 **커서 실명 유지 확정** F-12) + ARS 권한등록 상태 3형제(`DPJT_ATUH_REG_STATUS`/`_NAME`/`_COLOR_TYPE` — USM 카운트 0=WRITING/1+=COMPLETE) + `'' AS REG_COL`(승인/반려 버튼 자리 — FE 파생 렌더 F-15) + `DPJT_KEY_PARENT`(invisible).
- INNER 9곳/LEFT 4곳 — 행 소실 축 전수는 Cascade 문서 CF-20.
- 검증/메시지: Division 미선택 `MSG00097`(TAB1 E57)·기간 역전 `MSG00108`(E58) — 단 TAB1 SP 는 기간 미소비이므로 실검증은 TAB2 조회 축(P-01/P-02). 조회 성공 시 CRUD pending reset. ORDER BY 없음(D20 — 정렬 FE 몫).

## E05. TAB1 그리드 셀 편집

- 수정 항목(TAB1 확인 사항 2.2/C82 — 11종): 사업부, 유형, 고객, Project Name, 셀 유형, Stack 공법, Biz Type, SOP 일정, SOP Site, D-PJT Code, 내용.
- 제약: '수정' 구분(DPJT_REG_CAT) 행은 **D-PJT Code 수정 불가**(확인 2.1 — F-9 모순 확정: '신규' 행만 D-PJT Code 편집) / D-PJT Code = **6자리 필수**(확인 2.3 — P-08).
- UI컬럼 시트 Input Type 전 행 'S' 는 확인 사항 2.2 와 모순 — 편집 컬럼에 한해 INPUT_TP_CD 재지정(F-14, SDM1010 #11 판례).
- 셀 콤보(CODE/NAME — 저장 CODE·표시 NAME): Division=`Division`, Project Class=`DpjtClass`, Customer=`EndCustomerByDivisionDept`, Cell Type=`CellTypeByDivision`, Stack Method=`StackMethodByCellType`(**행 Cell Type 종속** — 변경 시 clear), Biz Type=`BizTypeByDivision`(F-18), SOP Plant=`PlantByDivisionCompany`, SOP Date=FPDate(YYYY.MM.DD) — Cascade 문서 CF-10~CF-18.
- 편집 발생 시 CRUD_TYPE='M' 마킹 — 편집값은 승인 버튼(E06) 파라미터로 전달되는 구조(TAB1 저장 버튼 없음 — B31 `<해당없음>`).

## E06. TAB1 승인(행 내 [등록] 버튼)

- 트리거: REG_COL(등록 컬럼 — TAB1_GRID T6 '등록') 내 승인 버튼, GRID Focused Row 단건.
- confirm: "선택한 프로젝트 등록 요청을 승인하시겠습니까?"(TAB1 F68 — MSG 공란 T-2) → 성공 F69/실패 F70(오타 "실해" — F-7).
- SP: `P_SDM5010_BTN_TAB1_CONFIRM` — **15 IN**(`P_DPJT_KEY`/`P_DPJT_CODE`/`P_DPJT_SEQ`/`P_DPJT_KEY_PARENT`/`P_DIVISION_ID`/`P_DPJT_CLASS`/`P_END_CUSTOMER`/`P_DPJT_NAME`/`P_CELL_TYPE`/`P_STACK_METHOD`/`P_BIZ_TYPE`/`P_SOP_DATE`/`P_SOP_PLANT_ID`/`P_NOTE`/`P_SES_USER_ID`) + O_RESULT_CURSOR — TAB1 시트 H41~K55 와 일치(시트는 P_DPJT_KEY 를 2행 표기·실서명 15 IN).
- SP 처리(원문 실측): ①`SELECT INTO` 로 현재 KEY/CODE/SEQ 취득(NO_DATA_FOUND 무가드 — D10) ②수정 Case(PARENT 有)=KEY/CODE 유지, 신규 Case=`V_DPJT_KEY := V_DPJT_CODE || '_' || TO_CHAR(N_DPJT_SEQ,'000000')` — **SEQ 채번 없음 + TO_CHAR 리딩 공백**(D11: MAX+1 채번 정정 승인) ③본행 UPDATE: COMPLETE/NORMAL 전이 + 편집값 15종 반영 + `CNFM_USER_ID`/`REG_COMP_DATE=TRUNC(SYSDATE)` — WHERE 6자리 가드(`LENGTH(V_DPJT_CODE)=6`) 불충족 시 **0건 갱신인데 CODE='0' 허위성공**(D12) ④PARENT 有 시 원본행 MODIFIED/DIABLED 전이 — **WHERE 가 P_DPJT_KEY(자기 행)** 라 승인 직후 본행을 되덮음(D3·D4 부모행 WHERE 정정 승인) + 'DIABLED' 오타(D2) + 'MODIFIED' lookup 미등재(D13) ⑤동일 DPJT_CODE 전행 NOTE MERGE 전파(딜리미터 `', '` — P-11) ⑥**SPMS_PROJECT_USER_MAP 동기 부재**(신규 Case KEY 재구성 시 권한 원장 고아화 — D5 동기 승인). 내부 COMMIT(D21).
- 결과: O_RESULT_CURSOR(CODE/MSG/EVENT — CODE 이름 기반 판정) → 재조회.

## E07. TAB1 반려(행 내 [등록] 버튼)

- confirm: "선택한 프로젝트 등록 요청을 반려하시겠습니까?"(TAB1 F64) → 성공 F65/실패 F66(오타 "실해" — F-7).
- SP: `P_SDM5010_BTN_TAB1_CANCEL` — 5 IN(`P_DIVISION_ID`/`P_DPJT_KEY`/`P_DPJT_KEY_PARENT`/`P_NOTE`/`P_SES_USER_ID`) + O_RESULT_CURSOR — TAB1 시트 H35~K39 일치.
- SP 처리(원문 실측): ①본행 UPDATE: `DPJT_REG_STATUS='REJECT'` + `DPJT_MGMT_STATUS='DIABLED'`(오타 — D2. GET_TAB2 DISABLE_YN 판정 철자는 'DISABLED') + `NOTE=P_NOTE` 덮어쓰기(딜리미터 연결 규약과 상이 — D17) ②PARENT 有 시 원본행 COMPLETE/NORMAL 복구 — **WHERE 가 P_DPJT_KEY(자기 행)** 라 반려 직후 본행을 COMPLETE 로 되돌려 **반려가 소멸**(D3 정정 승인: `WHERE DPJT_KEY = P_DPJT_KEY_PARENT`) ③동일 CODE 전행 NOTE MERGE 전파. 내부 COMMIT(D21). USER_MAP 동기 부재(D5).

## E08. 권한관리 링크 클릭 → 팝업 오픈

- 컬럼 `DPJT_ATUH_REG_STR`(POPUP Link — TAB1/TAB2 공통, SP 가 '권한관리' 리터럴 반환). 클릭 → 권한관리 팝업 오픈, 입력 = 해당 행 프로젝트 코드(개요 D34 — 실전달 키는 DPJT_KEY invisible).
- 닫힘 후: 그리드 재조회 → "입력/조회 권한등록" 상태 값 update(개요 F34).
- 팝업 구현체 = SDM1010 계열 공용 `ProjectAuthRegModal`(features/sdm/src/components — SDM1020 공용 승격분) 재사용 — 신규 작성 금지(F-22).

## E09. 팝업 오픈(초기 조회 4축)

- ①조직도: `P_SDM1010_GET_POP_USER_ORG`(P_SES_DIVISION_ID/P_SES_USER_ID — Session, 팝업 시트 H43~K44) ②입력 권한: `P_SDM1010_GET_POP_PJT_AUTH_WRITE`(P_DPJT_KEY=Parent GRID Focused Row invisible/P_SES_DIVISION_ID/P_SES_USER_ID — H49~K51) ③조회 권한: `P_SDM1010_GET_POP_PJT_AUTH_READ`(동일 — H52~K54) ④권한요청: `P_SDM1010_GET_POP_PJT_AUTH_REQ`(동일 — H55~K57).
- 입력/조회 그리드 최초 Load 시 요청 정보 invisible 보유 의무(팝업 확인 사항 2.2.2 — "invisible but exists in SQL").

## E10. 팝업 사용자 검색(Search)

- 검색 버튼 클릭 → **사용자 조회 조건 값만** 파라미터로 전달(팝업 확인 사항 1.1) → `P_SDM1010_GET_POP_USER_BY_DEPT`(P_USER_INFO=User ID(Name)/P_DEPT_ID/P_SES_DIVISION_ID/P_SES_USER_ID — H45~K48).
- 조건 값 없으면 그리드 미출력(확인 사항 1.1.1 — P-15).

## E11. 팝업 조직도 부서 클릭

- 부서 클릭 → **부서 정보만** 파라미터로 전달(확인 사항 2.1 §1 — P-16) → 동 SP(P_DEPT_ID=조직도 GRID Focused Row).

## E12. 팝업 (+) 버튼 — 입력/조회 리스트 추가

- 가드 3종(확인 사항 4.1/4.2/4.2.1 — P-17): 관리자 추가 불가("관리자는 권한을 추가할 수 없습니다." F81) / 입력 리스트 기존재(F79) / 조회 리스트 기존재(F80) — 입력으로 추가하든 조회로 추가하든 **양쪽 리스트 모두 체크**. pending — OK 저장 시 확정.

## E13. 팝업 (−) 버튼 — 리스트 제외

- 요청 정보가 존재하는 사용자 제외 시 **요청 그리드에 해당 사용자 정보를 추가**(확인 사항 2.2/2.2.1 — P-18). 최종 반려 처리는 OK 저장 시(확인 사항 3.1.2).

## E14. 팝업 요청 그리드 → 입력/조회 이동(그리드 버튼 입력/조회)

- 요청 행을 입력/조회 영역으로 이동(팝업 시트 B69/D69·D70) — 이동 시 요청 정보 보유(확인 사항 2.2.3/C101). pending — OK 저장 시 확정(확인 사항 2.1 §2 — P-20).

## E15. 팝업 반려 버튼

- 반려 클릭 → Alert(confirm) 후 **바로 반려 처리(SP 호출 — OK 저장과 무관)**: `P_SDM1010_SAVE_POP_BTN_REJECT`(P_DPJT_KEY/P_USER_ID=요청 GRID Focused Row/P_SES_USER_ID — H71~K73) — 확인 사항 2.3, SP 정상 동작 후 "반려" 상태 즉시 표시(2.3.1 — P-19).
- ⚠ 공용 `ProjectAuthRegModal` 정본은 반려 확정을 OK 시 일괄 처리(SDM1020 E15 승계 차이 — 미해결 보고 항목 동일 승계).

## E16. 팝업 OK(저장)

- `P_SDM1010_SAVE_POP_PJT_AUTH_WRITE` + `P_SDM1010_SAVE_POP_PJT_AUTH_READ`(각 P_ACTIVE_FLAG=I/D/M / P_DPJT_KEY / P_USER_ID / P_SES_DIVISION_ID / P_SES_USER_ID — H58~K67).
- **입력/조회 그리드의 모든 값을 저장 SP 에 전달**(확인 사항 3.1 — P-20): "반려" 상태 Update(3.1.1) + 권한 제외자의 요청 이력 반려 처리(3.1.2).
- 성공 "성공적으로 저장되었습니다."(F83 — MSG00002 Toast, hook #132 §3)/실패 F84(MSG00003) → 닫힘 후 메인 그리드 재조회(E08 후처리).

## E17. 팝업 Close/X — 저장 없이 닫기(pending 폐기)

## E18. TAB2 조회(Search)

- 검증: Division 미선택 → `MSG00097`(TAB2 E52 — P-01) / 시작일>종료일 → `MSG00108`(E53 — P-02) / **기간 3년 초과 → "조회 기간은 3년 이내로 입력해주세요."**(F54 — MSG 공란, MSG00164 재사용 후보 F-8 — P-03).
- SP: `P_SDM5010_GET_TAB2_PJT_MASTER` — 8 IN + O_CURSOR + O_RESULT_CURSOR (TAB2 시트 H35~K42 = SP 시그니처 일치 실측): `P_DIVISION_ID`/`P_END_CUSTOMER`(Multi 콤마)/`P_CELL_TYPE`(Multi)/`P_BIZ_TYPE`(Multi)/`P_DPJT_DEVELOP_STATUS`(Multi)/`P_REG_COMP_DATE_FR`/`P_REG_COMP_DATE_TO`/`P_SES_USER_ID`(Session).
- SP 내부(원문 실측): 멀티 필터 5종 = `UF_FX_STRING_SPLIT(p, ',')` WITH 테이블화 + `'ALL'` 무필터(OR 단락) / 기간 = `REG_COMP_DATE BETWEEN`(FR·TO 양쪽 NULL 이면 무필터 — NULL 완료일 행은 기간 지정 시 전멸 T-12) / 상태 = `DPJT_REG_STATUS NOT IN ('WRITING','WAITING','REQ_MOD')`(작성중/승인대기/변경요청 제외 — P-14).
- 커서 산출: TAB1 축 + `REG_REQ_DATE`/`REG_COMP_DATE`(SELECT 2회 중복 — D16)/`CNFM_USER_ID`/`CNFM_USER_NAME`(CUS LEFT)/`DPJT_DEVELOP_STATUS`+`_NAME`(DVL LEFT)/`DISABLE_YN`(CASE `DPJT_MGMT_STATUS='DISABLED'` → CHECKED — D2 오타 행은 UNCHECKED 표시).
- INNER 9곳/LEFT 6곳 — CF-20. ORDER BY 없음(D20). 조회 성공 시 CRUD pending reset·수정 중 재조회 confirm MSG00703(UC-02).

## E19. TAB2 그리드 셀 편집

- **편집 = 개발현황(`DPJT_DEVELOP_STATUS`, FPComboBox `DpjtDevelopStatus`) + 비활성(`DISABLE_YN`, FPCheckBox) 2컬럼만**(P-12 — 저장 SP 파라미터 축 H43~H47 이 2컬럼뿐임이 근거). 나머지 전 컬럼 잠금(Gray).
- UI컬럼 시트 Input Type 전 행 'S' — 2컬럼에 한해 재지정(F-14).
- 편집 시 CRUD_TYPE='M' 마킹 — 행 추가/삭제 없음(P-13: P_ACTIVE_FLAG 는 'M' 만 실사용).

## E20. TAB2 저장 버튼

- 개요 B26: "저장 처리 — 필수값, 중복값 확인 후 저장". confirm 없음 명기 — 공통 규약(저장 성공 Toast, hook #132 §3).
- SP: `P_SDM5010_SAVE_TAB2_PJT_MASTER` — **PKG 부재, 신규 작성 승인(D1)**. 설계 계약(TAB2 시트 H43~K47): `P_ACTIVE_FLAG`(I/D/M — GRID DATA)/`P_DPJT_KEY`/`P_DPJT_DEVELOP_STATUS`/`P_DISABLED`/`P_SES_USER_ID` + O_RESULT_CURSOR. `P_DISABLED` ↔ 원장 `DPJT_MGMT_STATUS`('DISABLED'/'NORMAL') 매핑(F-20).
- 결과: CODE/MSG/EVENT 이름 기반 판정 → 성공 Toast → 재조회(UC-07 필터 유지).

## E21. 엑셀 버튼

- 엑셀 다운로드(개요 B27) — 활성 그리드 라우팅(E03)·콤보 컬럼 NAME 출력·Excel Name 규약(UC-05).

## E22. 컬럼 설정 버튼

- CustomButton → 공용 `ColumnSettingModal` 호출(개요 F28). 설정 저장 시 그리드 비움 + CRUD reset(UC-03/hook #132 §2-2), 저장 성공 Toast.
- ⚠ 호출 SP = 설계서 `?`(개요 K28) — **SP 임의 배선 금지**(T-1, SDM1010 정오표 #14 판례).

## E23. 기본 기능

- 조회조건 Condition/Reset Condition + 컬럼 Filter/Sort(개요 B24 — 공통 필수). 행 추가 없는 화면이나 UC-01(필터 유지)·UC-07(재조회 필터 유지 `rebindFilterColumns`) 공통 축은 대사표에서 판정.

## E24. TAG·행 색상 렌더링

- `DPJT_ATUH_REG_STATUS`(TAG — M21~M23 3형제: 값/NAME/COLOR_TYPE, lookup `SPMS_DPJT_AUTH_REG_STATUS` — WRITING/COMPLETE 2상태. USM 카운트가 REQUEST 행 포함 — D24 관찰).
- TAB1 **'수정' 구분 행 색상**(확인 사항 1.1/1.1.1): `DPJT_REG_CAT` 기준 **행 단위** 색상 확정(F-10 — 커서에 원본값 부재로 필드 diff 불가). 색상 토큰 미기재(T-7).
