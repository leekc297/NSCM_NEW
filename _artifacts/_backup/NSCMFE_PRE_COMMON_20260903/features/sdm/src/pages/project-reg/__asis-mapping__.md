# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `SDM1010_ProjectReg_주요이벤트_상세분석.md`, `SDM1010_ProjectReg_제약매트릭스_상세.md`, `SDM1010_ProjectReg_Cascade_Filter_전수.md` · 생성: asis_mapping_gate.py --init
> ⭐ **정본 원천 = 화면설계서 xlsx** (`Doc/화면설계서_SDM/SDM1010_ProjectReg_화면설계서_20260806.xlsx`) — AS-IS GSCM 대응 화면 부재(순수 신규, 2026-08-12 사용자 확정).
> HANDLER 축 = AS-IS .cs 부재로 N/A(정당 제외). 콤보 호출지점 대사(게이트 §8) 동일 사유.
> 정오표: `Doc/화면분석서/SDM1010_ProjectReg_정오표.md` (설계서 오류·미결 13건 정정 구현)
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E01 | 화면 진입(초기화) / 탭 2 구성 + 조회조건 콤보 적재 + 기간 기본값 M-1~Today | ProjectReg.tsx:108-113 · ProjectRegForm.tsx:31-39 · useProjectRegStore.ts:48-55 |  | 구현 |
| E01-1 | 탭 2 구성: TAB1 `프로젝트 등록`(기본 활성) / TAB2 `나의 프로젝트 현황`. | ProjectReg.tsx:383-409 (TabWrapper — TAB1 기본 activeTab=useProjectRegStore.ts:61) |  | 구현 |
| E01-2 | 조회조건 콤보 적재 (1RT `useTabComboQueries`): 사업부=`MyDivision`(사용자 권한 기반, 첫 번째 값 기본 선택·필수), 고객=`… | ProjectRegForm.tsx:31-39 (콤보·lookup) · ProjectRegForm.tsx:47-55 (첫 값 기본 선택) |  | 구현 |
| E01-3 | 등록 완료일 기본값: `PR_GET_DAY_RANGE(p_created_by=UserID, p_month=-1)` → **M-1 ~ Today** (설계서 개요… | useProjectRegStore.ts:48-55 (initSearch — dayjs M-1~Today 등가 구현, FE 단독 산출) |  | 구현 |
| E01-4 | 그리드 컬럼 메타: `fetchStaticColumns`/`fetchStaticMeasures`(SCM_MST_SHEET_COLUMNS — mount 시). | ProjectReg.tsx:108-113 · useProjectRegStore.ts:110-127 · SDM1010_04_META_20260812.sql:301-512 |  | 구현 |
| E01-5 | 버튼 권한: `useTabBtnPermissions` — SPMS Administrator/SPMS Planner 그룹별 버튼 매핑. | ProjectReg.tsx:80 · SDM1010_04_META_20260812.sql:717-735 |  | 구현 |
| E02 | 사업부(Division) 변경 / 컬럼정보 재조회 + 그리드 초기화 + CRUD reset + 종속 콤보 재적재 | ProjectReg.tsx:154-159 (handleDivisionChange) · ProjectRegForm.tsx:83-87·34-36 (고객 재적재) |  | 구현 |
| E03 | TAB1 조회 / 필수·기간 검증 → 조회 | ProjectReg.tsx:131-150 (handleSearch) · project-reg.validate.ts:12-28 · SDM1010_02_PKG_SDM1010_20260812.sql:117-210 |  | 구현 |
| E04 | TAB1 행 추가 / 신규 행 삽입(CRUD_TYPE C) + 편집 활성 | ProjectReg.tsx:162-170 (handleInsert) · project-reg.editLock.ts:11-15 (신규행 C 편집 개방) |  | 구현 |
| E05 | TAB1 행 삭제 / 상태 가드(신규/작성중만) → confirm → 삭제 마킹 | ProjectReg.tsx:173-196 (handleDelete — 가드 178-184·confirm 188·마킹 190-194) |  | 구현 |
| E06 | TAB1 저장 / 필수·중복 검증 → confirm → 저장 → Toast | ProjectReg.tsx:200-243 (handleSave) · project-reg.api.ts:59-60 · SDM1010_02_PKG_SDM1010_20260812.sql:308-471 |  | 구현 |
| E07 | 등록요청 버튼 / Checked 행 상태 가드 → confirm → 요청 | ProjectReg.tsx:258-291 (handleReq) · project-reg.api.ts:63-64 · SDM1010_02_PKG_SDM1010_20260812.sql:474-500 |  | 구현 |
| E08 | 요청취소 버튼 / Checked 행 상태 가드(승인대기만) → confirm → 취소 | ProjectReg.tsx:294-321 (handleCancelReq) · project-reg.api.ts:67-68 · SDM1010_02_PKG_SDM1010_20260812.sql:503-529 |  | 구현 |
| E09 | TAB1 권한등록 링크(DPJT_AUTH_REG_STR) 클릭 / ProjectAuthRegModal 오픈(행 프로젝트 코드 전달) → 닫힘 후 재조회 | ProjectRegTab1Grid.tsx:213-223 (FPModal 클릭) · ProjectReg.tsx:324-334 (오픈)·415 (onSaved 재조회) |  | 구현 |
| E10 | TAB1 엑셀 / 엑셀 다운로드(콤보 NAME 출력) | ProjectReg.tsx:371-381 (SubTitle excelFileName·활성 grid 라우팅) · ProjectRegTab1Grid.tsx:254-258 (dataMap NAME) |  | 구현 |
| E11 | 컬럼 설정 버튼 / 공용 ColumnLayoutModal → 저장 시 그리드 비움 |  | 설계서 SP 미기재('?') — SP 임의 배선 금지(사용자 지시 2026-08-12, 정오표 #14) | 제외 |
| E12 | Measure 설정 버튼 / 공용 MeasureSelectModal → 저장 시 그리드 비움 |  | 설계서 SP 미기재('?') — SP 임의 배선 금지(사용자 지시 2026-08-12, 정오표 #14) | 제외 |
| E13 | TAB1 셀 편집 / 상태·컬럼별 편집 가드 + CODE/NAME 콤보 dataMap | ProjectRegTab1Grid.tsx:165-210 (beginningEdit·cellEditEnded) · project-reg.editLock.ts:18-33 |  | 구현 |
| E14 | TAB2 조회 / 필수·기간·3년 검증 → 조회 | ProjectReg.tsx:131-150 (else 분기 146-149) · project-reg.validate.ts:21-26 · SDM1010_02_PKG_SDM1010_20260812.sql:213-305 |  | 구현 |
| E15 | TAB2 My Work 아이콘 클릭 / MyWorkModal 오픈(조회 전용 — 설계 미완 최소구현) | ProjectRegTab2Grid.tsx:88-98 (FPModal 클릭) · ProjectReg.tsx:406 · MyWorkModal.tsx:24-93 |  | 구현 |
| E16 | TAB2 엑셀 / 엑셀 다운로드 | ProjectReg.tsx:371-381 (SubTitle — isTab1=false 시 tab2GridRef 라우팅 373-374) |  | 구현 |
| E17 | ProjectAuthRegModal 오픈 / 조직도 조회 + 기존 권한(입력/조회)·요청 목록 조회 | ProjectAuthRegModal.tsx:74-121 · SDM1010_02_PKG_SDM1010_20260812.sql:532-552·586-625·628-663 |  | 구현 |
| E18 | 팝업 조직도 부서 선택 / 부서별 사용자 조회(조건 없으면 그리드 미출력) | ProjectAuthRegModal.tsx:182-188 (노드 선택)·98-105 (enabled 가드) · SDM1010_02_PKG_SDM1010_20260812.sql:555-583 |  | 구현 |
| E19 | 팝업 (+) 버튼(입력/조회) / 선택 사용자를 입력/조회 리스트에 추가(중복 가드) | ProjectAuthRegModal.tsx:221-255 (handleAddInput/handleAddRead — 중복 가드 227-235·245-253) |  | 구현 |
| E20 | 팝업 요청 승인 버튼 / 요청 행 → 해당 권한 리스트에 추가(OK 저장 시 확정) | ProjectAuthRegModal.tsx:267-275 (handleDecision)·457-464 (승인 버튼) · SDM1010_02_PKG_SDM1010_20260812.sql:744-751 |  | 구현 |
| E21 | 팝업 요청 반려 버튼 / 요청 행 → 반려 상태 표시(OK 저장 시 확정) | ProjectAuthRegModal.tsx:267-275·465-472 (반려 버튼)·280-306 (pending pill 표시) |  | 구현 |
| E22 | 팝업 리스트 x(제외) / 권한 리스트에서 제외 — 해당 사용자 요청 존재 시 반려 처리 | ProjectAuthRegModal.tsx:258-264 (handleRemove) · SDM1010_02_PKG_SDM1010_20260812.sql:676-683 (P-24 반려) |  | 구현 |
| E23 | 팝업 OK(저장) / 권한·요청 일괄 저장 → 성공/실패 메시지 → 메인 그리드 재조회(권한등록 상태 update) | ProjectAuthRegModal.tsx:309-346 (handleOk) · project-reg.api.ts:71-76 · SDM1010_02_PKG_SDM1010_20260812.sql:666-763 |  | 구현 |
| E24 | 팝업 Close/X / 저장 없이 닫기 | ProjectAuthRegModal.tsx:499-506 (Close=LBL00627)·355 (handleClose)·74-84 (재오픈 시 pending 폐기) |  | 구현 |
| E25 | 상태 TAG 렌더링 / DPJT_REG_STATUS_NAME / DPJT_AUTH_REG_STATUS / AUTH_REQ_STATUS TAG 셀 색 표시 | ProjectRegTab1Grid.tsx:124-137 · ProjectRegTab2Grid.tsx:59-72 · project-reg.constants.ts:113-128 · SDM1010_04_META_20260812.sql:347·359·451 |  | 구현 |
| CF-01 | 사업부 (LBL00001) / ComboBox(Single) | ProjectRegForm.tsx:73-91 (MyDivision Single — 쿼리 31) |  | 구현 |
| CF-02 | 고객 / ComboBox(Multi, 검색+ALL) | ProjectRegForm.tsx:92-109 (Multi·allOption — 쿼리 34-36, division 종속 따옴표 전달) |  | 구현 |
| CF-03 | 나의 권한 / ComboBox(Multi) | ProjectRegForm.tsx:110-127 (lookup SPMS_DPJT_AUTH_TYPE — 쿼리 37-39) |  | 구현 |
| CF-04 | 등록 상태 / ComboBox(Multi) | ProjectRegForm.tsx:128-145 (lookup SPMS_DPJT_REG_STATUS — 쿼리 37-39) |  | 구현 |
| CF-05 | 등록 완료일 / Date(From~To) | ProjectRegForm.tsx:148-154 (PeriodField — 기본값 useProjectRegStore.ts:53-54) |  | 구현 |
| CF-07 | DPJT_CLASS / `DpjtClass` (신설) | SDM1010_04_META_20260812.sql:321 (TAB1 DPJT_CLASS_NAME=FPComboBox DpjtClass) · ProjectRegTab1Grid.tsx:54-80 |  | 구현 |
| CF-08 | END_CUSTOMER / `EndCustomer` (기존) | SDM1010_04_META_20260812.sql:323 (TAB1 END_CUSTOMER=FPComboBox EndCustomer) · ProjectRegTab1Grid.tsx:54-80 |  | 구현 |
| CF-09 | CELL_TYPE / `CellTypeByDivision` (신설) | SDM1010_04_META_20260812.sql:329 (TAB1 CELL_TYPE_NAME) · ProjectRegTab1Grid.tsx:54-80 (divisionId 따옴표 전달 61-66) |  | 구현 |
| CF-10 | STACK_METHOD / `StackMethod` (신설) | SDM1010_04_META_20260812.sql:333 (TAB1 STACK_METHOD_NAME) · ProjectRegTab1Grid.tsx:54-80 |  | 구현 |
| CF-11 | BIZ_TYPE / `BizTypeByDivision` (기존) | SDM1010_04_META_20260812.sql:337 (TAB1 BIZ_TYPE_NAME) · ProjectRegTab1Grid.tsx:54-80 |  | 구현 |
| CF-12 | SOP_PLANT_ID / `PlantByDivisionCompany` (기존) | SDM1010_04_META_20260812.sql:343 (TAB1 SOP_PLANT_NAME) · ProjectRegTab1Grid.tsx:54-80 |  | 구현 |
| CF-13 | ProjectAuthRegModal 조직도 노드 선택 / 사용자 목록 그리드 | ProjectAuthRegModal.tsx:182-188 (선택)·98-105 (deptFilters 쿼리)·130-133 (미선택=빈 그리드) |  | 구현 |
| CF-14 | 팝업 (+) 클릭 / 입력/조회 리스트 | ProjectAuthRegModal.tsx:236 (입력 리스트 추가)·254 (조회 리스트 추가) |  | 구현 |
| CF-15 | 팝업 OK 저장 완료 / 메인 TAB1 그리드 | ProjectAuthRegModal.tsx:341 (onSaved) · ProjectReg.tsx:415 (refetchTab1) |  | 구현 |
| P-01 | 조회(공통) / Division 미선택 시 조회 불가 | project-reg.validate.ts:13 (MSG00097) · ProjectReg.tsx:136-140 |  | 구현 |
| P-02 | 조회(공통) / 조회 시작일 > 종료일 불가 | project-reg.validate.ts:14-20 (MSG00108 — yyyymmdd 형식·역전 판정) |  | 구현 |
| P-03 | 조회(TAB2) / 조회 기간 3년 초과 불가 | project-reg.validate.ts:21-26 (MSG00715 — TAB2 한정) |  | 구현 |
| P-04 | 저장 / 필수 입력 컬럼(IM: Project Class/Customer/Project Name) 누락 시 저장 불가 | ProjectReg.tsx:209-217 (MSG00113) · project-reg.validate.ts:31-44 · project-reg.editLock.ts:36-38 · SDM1010_02_PKG_SDM1010_20260812.sql:320-332 |  | 구현 |
| P-05 | 저장 / 중복 시 저장 불가 — 논리키 DIVISION_ID+DPJT_CLASS+END_CUSTOMER+DPJT_NAME (정오표 #9) | project-reg.validate.ts:47-55 (MSG00043) · project-reg.constants.ts:131 · SDM1010_02_PKG_SDM1010_20260812.sql:334-367 (payload+원장 대조) |  | 구현 |
| P-06 | 저장 / 실행 전 Confirm "저장 하시겠습니까?" (신규 채번) | ProjectReg.tsx:225 (MSG00001 confirm — 기등재 재사용) |  | 구현 |
| P-07 | 삭제 / 신규 행 또는 '작성중' 상태만 삭제 가능 | project-reg.editLock.ts:41-42 (isRowDeletable) · ProjectReg.tsx:178-184 (MSG00706) · SDM1010_02_PKG_SDM1010_20260812.sql:437-457 (DRAFT 한정 서버 재가드) |  | 구현 |
| P-08 | 삭제 / 실행 전 Confirm "프로젝트를 삭제 하시겠습니까?" (신규 채번 — SPMS 확인 팝업) | ProjectReg.tsx:188 (MSG00707) · SDM1010_04_META_20260812.sql:41-45 |  | 구현 |
| P-09 | 등록요청 / '작성중' 상태만 가능 + 신규(미저장) 행 불가 (확인사항 5.1) | project-reg.editLock.ts:44-46 (isRowRequestable) · ProjectReg.tsx:264-277 (MSG00708·신규행 제외 안내) · SDM1010_02_PKG_SDM1010_20260812.sql:486 |  | 구현 |
| P-10 | 등록요청 / Checked 선택 0건 시 불가 | ProjectReg.tsx:260-263 (MSG00709) |  | 구현 |
| P-11 | 등록요청 / Confirm "프로젝트를 등록/변경 하시겠습니까? *…승인 요청토록 하겠습니다." + 성공/실패 메시지 (신규 채번 3건) | ProjectReg.tsx:278-290 (MSG00710/00711/00712) · SDM1010_04_META_20260812.sql:59-78 |  | 구현 |
| P-12 | 요청취소 / '승인대기' 상태만 가능 | project-reg.editLock.ts:48-50 (isRowCancelable) · ProjectReg.tsx:300-307 (MSG00713) · SDM1010_02_PKG_SDM1010_20260812.sql:515 |  | 구현 |
| P-13 | 요청취소 / Checked 선택 0건 시 불가 | ProjectReg.tsx:296-299 (MSG00709) |  | 구현 |
| P-14 | 요청취소 / Confirm "프로젝트 등록요청을 취소 하시겠습니까?" (신규 채번) | ProjectReg.tsx:308 (MSG00714) · SDM1010_04_META_20260812.sql:86-90 |  | 구현 |
| P-15 | 편집 / 신규 행 또는 '작성중' 상태 행만 셀 편집 가능 (확인사항 2.1.2) | project-reg.editLock.ts:11-15 (isRowEditable) · ProjectRegTab1Grid.tsx:165-181 · SDM1010_02_PKG_SDM1010_20260812.sql:427 |  | 구현 |
| P-16 | 편집 / 편집 대상 컬럼 = Project Class(IM)/Customer(IM)/Project Name(IM)/Cell Type(IO)/Stack Metho… | project-reg.editLock.ts:18-33 (INPUT_TP_CD 단일 원천) · SDM1010_04_META_20260812.sql:321-343 (IM/IO 메타) |  | 구현 |
| P-17 | 편집 / '승인대기' 상태 = 수정·삭제 불가, **권한등록 링크는 허용** (확인사항 1.1) | project-reg.editLock.ts:11-15 (REQUEST 잠금) · ProjectReg.tsx:178-184 (삭제 차단) · project-reg.editLock.ts:52-54·ProjectRegTab1Grid.tsx:213-223 (링크는 상태 무관 허용) |  | 구현 |
| P-18 | 팝업 조회 / 사용자 조회 조건(부서 선택) 없으면 그리드 미출력 (확인사항 1.1) | ProjectAuthRegModal.tsx:102-105 (enabled)·130-133 (빈 배열) · SDM1010_02_PKG_SDM1010_20260812.sql:561-573 |  | 구현 |
| P-19 | 팝업 (+) / 입력 리스트 기존재 사용자 추가 불가 | ProjectAuthRegModal.tsx:227-235 (MSG00716) |  | 구현 |
| P-20 | 팝업 (+) / 조회 리스트 기존재 사용자 추가 불가 | ProjectAuthRegModal.tsx:245-253 (MSG00717) |  | 구현 |
| P-21 | 팝업 승인 / 승인 = 권한 리스트 추가, **OK(저장) 클릭 시 최종 확정** (확인사항 2.2) | ProjectAuthRegModal.tsx:267-275 (pending)·309-346 (OK 확정) · SDM1010_02_PKG_SDM1010_20260812.sql:729-751 |  | 구현 |
| P-22 | 팝업 반려 / 반려 = 반려 상태 변경, OK 클릭 시 최종 확정 (확인사항 2.3) | ProjectAuthRegModal.tsx:267-275·280-306 (pending pill)·309-346 · SDM1010_02_PKG_SDM1010_20260812.sql:730-742 |  | 구현 |
| P-23 | 팝업 표시 / 요청 권한 ≠ 부여 권한이면 요청 상태 구분 표시 (확인사항 2.4) | SDM1010_02_PKG_SDM1010_20260812.sql:600-603 (AUTH_REQ_STATUS CASE) · SDM1010_04_META_20260812.sql:451 (TAG 메타) |  | 구현 |
| P-24 | 팝업 제외 / 권한 삭제(x) 대상 사용자의 미처리 요청 존재 시 반려 처리 (확인사항 2.5) | SDM1010_02_PKG_SDM1010_20260812.sql:676-683 (SAVE_POP_PJT_AUTH_MGMT 선반려) |  | 구현 |
| P-25 | 데이터 / 콤보 컬럼 = CODE/NAME 페어 — 저장 CODE·표시 NAME (Visible=N/Y 쌍) | project-reg.constants.ts:94-100 (CODE_PAIR) · ProjectRegTab1Grid.tsx:189-202 (CODE 동기 기입) · SDM1010_04_META_20260812.sql:319-343 (N/Y 쌍) |  | 구현 |
| P-26 | 상태머신 / 전이 규칙: 작성중→(등록요청)승인대기→(승인)등록완료/(반려)반려, 승인대기→(요청취소)작성중, 등록완료→변경등록→변경요청→승인대기→등록완료 | SDM1010_02_PKG_SDM1010_20260812.sql:481-488 (DRAFT→REQUEST)·510-517 (REQUEST→DRAFT)·387 (신규=DRAFT) · project-reg.constants.ts:30-38 | 승인/반려·변경등록 전이는 관리자 승인 화면 관할 — 본 화면 관할 전이 전수 구현 | 구현 |
| P-27 | 조회조건 / 사업부 변경 = 컬럼정보 재조회 + 그리드 초기화 + CRUD reset (개요 H13, 재조회는 Search 버튼) | ProjectReg.tsx:154-159 (handleDivisionChange — 자동 재조회 없음) · ProjectRegForm.tsx:83-87 |  | 구현 |
| P-28 | 조회조건 / 등록 완료일 기본값 = M-1 ~ Today (PR_GET_DAY_RANGE p_month=-1), 사업부=첫 값 기본, 고객/권한/상태=ALL | useProjectRegStore.ts:48-55 (M-1~Today·빈 배열=ALL) · ProjectRegForm.tsx:47-55 (첫 값) · useProjectRegStore.ts:16-19 (ALL 변환) |  | 구현 |
| P-29 | 권한 / 화면 접근 = SPMS Administrator/SPMS Planner (신설 그룹) + ADMIN. 사업부 콤보 = 사용자 권한 범위(MyDivisi… | SDM1010_04_META_20260812.sql:717-735 (그룹 신설+메뉴/버튼 권한) · ProjectRegForm.tsx:31 (MyDivision) |  | 구현 |
| P-30 | 권한 / TAB1 조회 결과 = 서버측 권한 필터(P_USER_ID/P_MENU_ID/P_USER_GR_ID Session 전달) | useProjectRegStore.ts:76-91 (sesUserId·userGroup) · SDM1010_02_PKG_SDM1010_20260812.sql:93-102·193-198 |  | 구현 |
| P-31 | 데이터 / 프로젝트:권한 = Master-Detail 1:N — 신규 프로젝트는 저장 후 권한등록 가능 (확인사항 2.2 미결 → 정오표 #10 확정) | project-reg.editLock.ts:52-54 (canOpenAuthRegModal) · ProjectReg.tsx:324-329 (신규행 진입 차단 toast) · SDM1010_02_PKG_SDM1010_20260812.sql:438-451 (종속 삭제 1:N) |  | 구현 |
| P-32 | TAB2 / TAB2 = 조회 전용 (저장/삭제 `<해당없음>` — 설계서 TAB2 B35/B36) | ProjectRegTab2Grid.tsx:151 (isReadOnly) · ProjectReg.tsx:337-344 (TAB2=Search/Excel 만 활성) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:E01:SEARCH | [SEARCH] 화면 진입(초기화) / 탭 2 구성 + 조회조건 콤보 적재 + 기간 기본값 M-1~Today | ProjectReg.tsx:108-113 (mount — 콤보·메타 적재. 자동 조회 없음=Search 버튼 대기) · ProjectRegForm.tsx:31-39 |  | 구현 |
| CRUD:E02:SEARCH | [SEARCH] 사업부(Division) 변경 / 컬럼정보 재조회 + 그리드 초기화 + CRUD reset + 종속 콤보 재적재 | ProjectReg.tsx:154-159 (clearFilters=그리드 비움·fetchStaticColumns 재조회) |  | 구현 |
| CRUD:E03:SEARCH | [SEARCH] TAB1 조회 / 필수·기간 검증 → 조회 | ProjectReg.tsx:141-145 (setFilter TAB1) · SDM1010_02_PKG_SDM1010_20260812.sql:117-210 |  | 구현 |
| CRUD:E04:INSERT | [INSERT] TAB1 행 추가 / 신규 행 삽입(CRUD_TYPE C) + 편집 활성 | ProjectReg.tsx:162-170 · project-reg.constants.ts:135-162 (INSERT_ROW_DEFAULTS) |  | 구현 |
| CRUD:E05:DELETE | [DELETE] TAB1 행 삭제 / 상태 가드(신규/작성중만) → confirm → 삭제 마킹 | ProjectReg.tsx:173-196 · SDM1010_02_PKG_SDM1010_20260812.sql:437-457 (CRUD_TYPE 'D' 처리) |  | 구현 |
| CRUD:E06:SAVE | [SAVE] TAB1 저장 / 필수·중복 검증 → confirm → 저장 → Toast | ProjectReg.tsx:200-243 · project-reg.validate.ts:58-61 (toSaveRow) · SDM1010_02_PKG_SDM1010_20260812.sql:308-471 |  | 구현 |
| CRUD:E09:SEARCH | [SEARCH] TAB1 권한등록 링크(DPJT_AUTH_REG_STR) 클릭 / ProjectAuthRegModal 오픈(행 프로젝트 코드 전달) → 닫힘 후 재조회 | ProjectAuthRegModal.tsx:91-121 (모달 내 조회) · ProjectReg.tsx:415 (onSaved 재조회) |  | 구현 |
| CRUD:E11:SAVE | [SAVE] 컬럼 설정 버튼 / 공용 ColumnLayoutModal → 저장 시 그리드 비움 |  | 설계서 SP 미기재('?') — SP 임의 배선 금지(사용자 지시 2026-08-12, 정오표 #14) | 제외 |
| CRUD:E12:SAVE | [SAVE] Measure 설정 버튼 / 공용 MeasureSelectModal → 저장 시 그리드 비움 |  | 설계서 SP 미기재('?') — SP 임의 배선 금지(사용자 지시 2026-08-12, 정오표 #14) | 제외 |
| CRUD:E14:SEARCH | [SEARCH] TAB2 조회 / 필수·기간·3년 검증 → 조회 | ProjectReg.tsx:146-149 (setFilter TAB2) · SDM1010_02_PKG_SDM1010_20260812.sql:213-305 |  | 구현 |
| CRUD:E15:SEARCH | [SEARCH] TAB2 My Work 아이콘 클릭 / MyWorkModal 오픈(조회 전용 — 설계 미완 최소구현) | MyWorkModal.tsx:41-48 (useTabProcQuery POP2_GRID5) · SDM1010_02_PKG_SDM1010_20260812.sql:766-811 |  | 구현 |
| CRUD:E17:SEARCH | [SEARCH] ProjectAuthRegModal 오픈 / 조직도 조회 + 기존 권한(입력/조회)·요청 목록 조회 | ProjectAuthRegModal.tsx:91-121 · SDM1010_02_PKG_SDM1010_20260812.sql:532-552·586-625·628-663 |  | 구현 |
| CRUD:E18:SEARCH | [SEARCH] 팝업 조직도 부서 선택 / 부서별 사용자 조회(조건 없으면 그리드 미출력) | ProjectAuthRegModal.tsx:98-105 · SDM1010_02_PKG_SDM1010_20260812.sql:555-583 |  | 구현 |
| CRUD:E19:INSERT | [INSERT] 팝업 (+) 버튼(입력/조회) / 선택 사용자를 입력/조회 리스트에 추가(중복 가드) | ProjectAuthRegModal.tsx:221-255 (pending 리스트 추가) |  | 구현 |
| CRUD:E19:SEARCH | [SEARCH] 팝업 (+) 버튼(입력/조회) / 선택 사용자를 입력/조회 리스트에 추가(중복 가드) | ProjectAuthRegModal.tsx:199-207 (checked 사용자 수집)·239-255 ((+)조회 리스트 추가) |  | 구현 |
| CRUD:E20:INSERT | [INSERT] 팝업 요청 승인 버튼 / 요청 행 → 해당 권한 리스트에 추가(OK 저장 시 확정) | ProjectAuthRegModal.tsx:267-275 · SDM1010_02_PKG_SDM1010_20260812.sql:744-751 (승인분 권한 INSERT) |  | 구현 |
| CRUD:E20:SAVE | [SAVE] 팝업 요청 승인 버튼 / 요청 행 → 해당 권한 리스트에 추가(OK 저장 시 확정) | ProjectAuthRegModal.tsx:325-338 (OK 시 확정 전송) · SDM1010_02_PKG_SDM1010_20260812.sql:721-763 |  | 구현 |
| CRUD:E21:SAVE | [SAVE] 팝업 요청 반려 버튼 / 요청 행 → 반려 상태 표시(OK 저장 시 확정) | ProjectAuthRegModal.tsx:267-275·325-338 · SDM1010_02_PKG_SDM1010_20260812.sql:730-742 |  | 구현 |
| CRUD:E23:SAVE | [SAVE] 팝업 OK(저장) / 권한·요청 일괄 저장 → 성공/실패 메시지 → 메인 그리드 재조회(권한등록 상태 update) | ProjectAuthRegModal.tsx:309-346 · SDM1010_02_PKG_SDM1010_20260812.sql:666-718·721-763 |  | 구현 |
| CRUD:E23:SEARCH | [SEARCH] 팝업 OK(저장) / 권한·요청 일괄 저장 → 성공/실패 메시지 → 메인 그리드 재조회(권한등록 상태 update) | ProjectAuthRegModal.tsx:341 (onSaved) · ProjectReg.tsx:415 (refetchTab1) |  | 구현 |
| CRUD:E24:SAVE | [SAVE] 팝업 Close/X / 저장 없이 닫기 | ProjectAuthRegModal.tsx:499-506 (Close — 저장 호출 없음)·74-84 (재오픈 초기화=pending 폐기) |  | 구현 |
| MODAL:ColumnSettingModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | 설계서 SP 미기재('?') — SP 임의 배선 금지(사용자 지시 2026-08-12, 정오표 #14) | 제외 |
| MODAL:MeasureSelectModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | 설계서 SP 미기재('?') — SP 임의 배선 금지(사용자 지시 2026-08-12, 정오표 #14) | 제외 |
| MODAL:MyWorkModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | MyWorkModal.tsx:24-93 (하단 승인/반려 블록 = 설계 미완(정오표 #13) — 사용자 확정 최소구현·주석 명기 13-16) |  | 구현 |
| MODAL:ProjectAuthRegModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | ProjectAuthRegModal.tsx:50-512 |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 추가 행이 보이도록 (그리드 필터 clear — 1st 행3) | ProjectReg.tsx:162-170 (handleInsert — tab1FilterRef.current?.clear() 163) |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | ProjectReg.tsx:124-135 (hasPendingChanges + MSG00703 confirm) · project-reg.constants.ts:77 |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) |  | 컬럼/Measure 설정 기능 자체 제외(설계서 SP 미기재('?') — SP 임의 배선 금지, 정오표 #14) — 대상 기능 부재 | 제외 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ProjectReg.tsx:228 (SAVE)·283 (REQ)·313 (CANCEL) · ProjectAuthRegModal.tsx:340 (모달 OK) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | ProjectRegTab1Grid.tsx:72-80 (CODE/NAME DataMap)·254-258 (컬럼 dataMap 적용 — gridAction 승계) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | useProjectRegStore.ts:16-19 (toMultiParam 콤마 연결)·80-91 (SP 전달) · SDM1010_02_PKG_SDM1010_20260812.sql:180-192 (INSTR 다중 파싱) |  | 구현 |

## 토큰 대사표 (hook #117 §5.6 — 2026-08-13 실측)

> SDM1010 은 AS-IS 부재(순수 신규 — hook #134) — 콤보는 설계서 Cell Combo Data Type 기재명 그대로이며
> 원천 SQL 은 기존 공유 콤보 5본 재사용 + 신설 3본(DpjtClass/StackMethod/CellTypeByDivision — SPMS lookup 기반).
> BE `makeComboQuery` 관례 동일: `@토큰` raw 치환, 미전달 = `''`, 서버 자동 = `@sesUserId`/`@sesLangCd`.
> FE 전달 지점 = `components/ProjectRegForm.tsx`(조회조건)·`components/ProjectRegTab1Grid.tsx`(셀 콤보 — `'${division}'` 따옴표 계약).

| SQL_ID | 필요 토큰 | 서버 자동 | FE 전달 | 미전달 | 판정 | 미전달 사유 |
|---|---|---|---|---|---|---|
| MyDivision | sesUserId | sesUserId | — | — | ✅ | |
| EndCustomerByDivision | divisionId(, deptId) | — | divisionId | deptId | ⚠ 관대형 | SDM1010 조회조건에 부서 축 없음(설계서 개요 B11:H17 — 사업부/고객/나의권한/등록상태/등록완료일 5종뿐). 관대형 SQL 이 deptId 빈값=전체 허용 |
| EndCustomer | divisionId | — | divisionId | — | ✅ | |
| DpjtClass | — | — | — | — | ✅ | 무토큰(lookup 전체) |
| StackMethod | — | — | — | — | ✅ | 무토큰(lookup 전체) |
| CellTypeByDivision | divisionId | — | divisionId | — | ✅ | 관대형(ATTRIBUTE1 NULL=전 division) |
| BizTypeByDivision | divisionId | — | divisionId | — | ✅ | |
| PlantByDivisionCompany | divisionId, companyId | — | divisionId | companyId | ⚠ 관대형 | SDM1010 은 company 조회조건이 없는 화면 — 설계서 콤보 지정이 'PlantByDivisionCompany' 단일 기재이고 파라미터 명세 부재. 관대형 SQL 이 companyId 빈값=division 전체 plant 허용 = 의도 동작 (E2E D2 축 동일 사유 수용) |
