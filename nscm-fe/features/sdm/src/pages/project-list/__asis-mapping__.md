# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `SDM1020_ProjectList_주요이벤트_상세분석.md`, `SDM1020_ProjectList_제약매트릭스.md`, `SDM1020_ProjectList_Cascade_Filter_전수.md` · 생성: asis_mapping_gate.py --init
> ⭐ **정본 원천 = 화면설계서 xlsx** (`Doc/화면설계서_SDM/SDM1020/SDM1020_ProjectList_화면설계서_20260814.xlsx` — 루트 0730 구판 참조 금지) — AS-IS GSCM 대응 화면 부재(순수 신규, hook #134 §0).
> HANDLER 축 = AS-IS .cs 부재로 N/A(정당 제외 — hook #134 §2-2). 콤보 호출지점 대사(게이트 §8) 동일 사유 SKIP(리포트 사유 행 기재 의무).
> 정오표: `Doc/화면분석서/SDM1020_ProjectList_정오표.md` (확정 결함 D1~D12 + 관찰 O-1~O-6 + 미결 U-01~U-09 — 미결 항목은 "설계 미완" 사유로 제외 처리, 임의 완성 금지)
> ⚠ E19/MODAL:ColumnSettingModal = 설계서 SP `?`(U-01) — SP 임의 배선 금지. MODAL:FPModal 행 = D7 Cell object 규약(DPJT_AUTH_MGMT 링크 셀)에서 추출된 행 — 별도 모달 아님(E08 권한관리 팝업 오픈 배선으로 충족).
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.
> 구현 파일 약칭: PL=`ProjectList.tsx` / PLF=`components/ProjectListForm.tsx` / PLG=`components/ProjectListGrid.tsx` / PLS=`useProjectListStore.ts` / VAL=`utils/project-list.validate.ts` / API=`utils/project-list.api.ts` / EL=`utils/project-list.editLock.ts` / **PAM**=`features/sdm/src/components/ProjectAuthRegModal.tsx` (SDM1010 공용 승격분 — 2026-08-19 이동, 기능 무수정) / **AP**=`features/sdm/src/components/project-reg.authPopup.ts`

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E01 | 화면 진입(초기화) / 조회조건 콤보 적재 + 기간 기본값 M-1~Today + 컬럼 메타 + 버튼 권한 | PL:83-113 (period·메타 fetch) · PLF:34-43 (콤보) · PL:70 (버튼 권한) |  | 구현 |
| E01-1 | 조회조건 콤보 적재(1RT `useTabComboQueries`): 사업부=`MyDivision`(사용자 권한 기반, 첫 번째 값 기본 선택·필수 — 개요 F1… | PLF:34-43 (MyDivision·EndCustomerByDivision·lookup 2종) · PL:156-163 (첫 값 기본 선택 보정) |  | 구현 |
| E01-2 | 등록 완료일 기본값: `PR_GET_DAY_RANGE`(개요 H17 — P_FR/TO_BUCKET·DATE_VAL·BUCKET_TYPE·P_SES_USER_ID… | PL:83-100 (period 시트 소비 — 실서명 2-IN 계약 ⑤) · VAL:52-60 (defaultRegCompRange M-1~Today — dayjs 병행) |  | 구현 |
| E01-3 | 그리드 컬럼 메타: `fetchStaticColumns`/`fetchStaticMeasures`(SCM_MST_SHEET_COLUMNS — mount 시). D… | PLS:94-110 (fetchStaticColumns) · PL:107-113 (mount fetch) · 계약 ④ SHEET_COLUMNS 30행 (Measure 시트 없음 — 단일 그리드 비메저 화면) |  | 구현 |
| E01-4 | 버튼 권한: `useTabBtnPermissions` — SPMS Administrator/SPMS Planner 그룹별 버튼 매핑. | PL:70 (hasButton) · 계약 ② UGR_BTN 21행/MNU_MPG 3행 |  | 구현 |
| E01-5 | 초기 자동조회 여부는 설계서 미기재(정오표 미결 — 확정 전 자동조회 미배선). | PL:107-113 (mount = clearFilters — 자동조회 미배선, Search 버튼 대기. U-08 확정 시 재배선) |  | 구현 |
| E02 | 사업부(Division) 변경 / 컬럼정보 재조회 + 그리드 초기화 + CRUD reset + 종속 콤보 재적재 | PL:148-153 (handleDivisionChange) · PLF:69-84 (고객 ALL reset·재적재) |  | 구현 |
| E03 | 조회(Search) / 필수(Division·기간)·기간 역전 검증 → 조회 | PL:130-144 (handleSearch) · VAL:63-72 (validateSearch — MSG00097/MSG00108) |  | 구현 |
| E04 | 그리드 셀 편집 / 관리자 행만 편집 + CODE/NAME 콤보 dataMap + 종속 셀 처리 | PLG:285-332 (beginningEdit·cellEditEnded) · EL:11-30 (ADMIN×INPUT_TP_CD) · PLG:96-133 (dataMap) |  | 구현 |
| E05 | 권한요청 입력/조회 체크박스 / 상호배타(하나 선택 시 반대쪽 자동 해제) + 비활성 가드 | PLG:252-267 (3상태 렌더) · PLG:352-372 (클릭 토글·상호배타·원본 스냅샷) · EL:33-36 |  | 구현 |
| E06 | 등록요청 버튼 / Checked·변경내역 가드 → confirm → 변경 등록 요청 → 재조회 | PL:193-225 (handleReq — 'M' 행만·행별 단건) · API:79-97 (callReqProjectReg) · VAL:75-92 (toReqPayload) |  | 구현 |
| E07 | 권한요청 링크(그리드 내) / 체크값 가드 → confirm(요청/취소) → 권한 요청 → 재조회 | PL:227-263 (handleAuthReq — MSG01002/01003/01004/01005/01006) · API:99-113 (callReqProjectAuth) |  | 구현 |
| E08 | 권한관리 링크 클릭 / 관리자 행만 — 권한관리 팝업 오픈(프로젝트 키 전달) | PLG:229-239 (링크 렌더 — '-' 봉인) · PLG:344-347 (클릭) · PL:265-271 (handleAuthMgmt) · PL:332-337 (모달·onSaved 재조회) |  | 구현 |
| E09 | 팝업 오픈(초기 조회) / 조직도 + 입력 권한 + 조회 권한 + 권한요청 4축 조회 | PAM:136-177 (POP1_TREE/GRID2/GRID3/GRID4 — MENU_ID SDM1010·P_SDM1010_* 재사용 O-5) |  | 구현 |
| E10 | 팝업 사용자 검색 / 사용자 조회 조건 값만 전달 → 사용자 목록 조회(조건 없으면 미출력) | PAM:143-150 (enabled 가드 — 조건 전무 시 미조회) · PAM:194-205 (applyUserSearch) |  | 구현 |
| E11 | 팝업 조직도 부서 클릭 / 부서 정보만 전달 → 사용자 목록 조회 | PAM:241-244 (selectDept — 부서 모드·userInfo 배타 해제) · PAM:128-134 (deptId 만 전달) |  | 구현 |
| E12 | 팝업 (+) 버튼 / 사용자를 입력/조회 리스트에 추가(관리자·중복 가드) | PAM:308-310 (handleAdd) · AP:58-79 (addUsersToList — 중복 MSG00716/717. 관리자 가드는 P-15 행 참조 — 제외 사유) |  | 구현 |
| E13 | 팝업 (−) 버튼 / 입력/조회 리스트에서 제외 — 요청 이력 보유자는 요청 그리드 복귀 | PAM:312-315 (handleRemove) · AP:81-105 (removeUsersFromList — 승인분 결정 원복. 기존 권한자 제외 확정 = OK replace-set §11/§12 반려 → 재조회 반영) |  | 구현 |
| E14 | 팝업 요청 그리드 입력/조회 이동 / 요청 행을 입력/조회 리스트로 이동(요청 정보 보유) | PAM:335-380 (행내 [✓입력][✓조회] 버튼) · AP:134-169 (applyRequestDecision — 요청 정보 `_reqUser` 보유) |  | 구현 |
| E15 | 팝업 반려 버튼 / Alert 후 **즉시 SP 호출** → 반려 상태 즉시 표시 | PAM:335-380 ([x반려] pending 표시) · handleOk rejectIds (§13 단건) — ⚠ 정본 승계: 반려 **확정은 OK 시** (설계 '즉시 호출'과 차이 — 공용 정본 무수정 승격, 미해결 보고 항목) |  | 구현 |
| E16 | 팝업 OK(저장) / 입력/조회 그리드 전량 전달 저장 → 성공/실패 → 메인 재조회 | PAM:412-466 (handleOk — WRITE/READ replace-set + 반려 단건·EVENT 합산) · PL:332-337 (onSaved=refreshMain) |  | 구현 |
| E17 | 팝업 Close/X / 저장 없이 닫기(pending 폐기) | PAM:104-122 (open reset — pending 폐기) · PAM footer Close=modalClose |  | 구현 |
| E18 | 엑셀 버튼 / 엑셀 다운로드(콤보 NAME 출력) | PL:307-318 (SubTitle excelFileName='ProjectList') · PLG:399-412 (dataMap NAME — gridAction 승계) |  | 구현 |
| E19 | 컬럼 설정 버튼 / 공용 ColumnSettingModal 호출 — **SP `?` 미결(임의 배선 금지)** |  | 설계서 SP 미기재('?' — 정오표 U-01) — SP 임의 배선 금지(SDM1010 정오표 #14 판례). 설계서 확정 기재 시 배선 | 제외 |
| E20 | 기본 기능 / 조회조건 Condition/Reset Condition + 컬럼 Filter/Sort | PL:296-318 (MainTitle/SubTitle 공용 경로 — 계약 ② FILTER/SORT BTN 등재) · PLG allowSorting |  | 구현 |
| E21 | 상태 TAG 렌더링 / 등록 상태 TAG + 권한요청 상태 TAG(warning-major) | PLG:213-227 (TAG 렌더 — TAG_SOURCE D2 보정·pillClass warning-major 정규화) · constants:92-103 · scss tagWarningMajor |  | 구현 |
| CF-01 | 사업부 (LBL00001) / ComboBox(Single) | PLF:64-85 (MyDivision Single·필수) |  | 구현 |
| CF-02 | 고객 / ComboBox(Multi, 검색+ALL) | PLF:86-103 (EndCustomerByDivision — division 종속 따옴표 전달·multiple allOption) |  | 구현 |
| CF-03 | 나의 권한 / ComboBox(Multi) | PLF:104-121 (lookup SPMS_DPJT_AUTH_TYPE — useTabLookupQueries) |  | 구현 |
| CF-04 | 등록 상태 / ComboBox(Multi) | PLF:122-139 (lookup SPMS_DPJT_REG_STATUS) |  | 구현 |
| CF-05 | 등록 완료일 / Date(From~To) | PLF:140-148 (PeriodField — LBL00857) · PL:83-100 (기본값 M-1~Today) |  | 구현 |
| CF-06 | (버튼) 기본 기능 / — | PL:274-291 (hotkeyConfig·customButtons) · PL:307-318 (SubTitle) |  | 구현 |
| CF-07 | DIVISION_ID / `Division` | PLG:96-133 (메타 FPComboBox dataMap — CODE 바인딩·NAME 표시. 편집 여부 = 메타 INPUT_TP_CD 계약 ④) |  | 구현 |
| CF-08 | DPJT_CLASS / `DpjtClass` | PLG:96-133 (dataMap — 독립 lookup) |  | 구현 |
| CF-09 | END_CUSTOMER / `EndCustomerByDivisionDept` | PLG:96-133 (dataMap — 조회 Division 따옴표 전달·그리드 전용 콤보) |  | 구현 |
| CF-10 | CELL_TYPE / `CellTypeByDivision` | PLG:96-133 (dataMap) · PLG:315-330 (변경 시 STACK_METHOD clear) |  | 구현 |
| CF-11 | STACK_METHOD / `StackMethodByCellType` | PLG:135-166 (cellType 별 선적재) · PLG:302-309 (beginningEdit 행값 스왑) · PLG:322-329 (cellEditEnded 기본 dataMap 원복 — hook #59 §5-G) |  | 구현 |
| CF-12 | BIZ_TYPE / `BizTypeByDivision` — **확정** (설계서 N12 병기 "DmBizType (or BizTypeByDivision)" 중 … | PLG:96-133 (dataMap — BizTypeByDivision 확정값·@division 전달) |  | 구현 |
| CF-13 | SOP_DATE / (FPDate `YYYY.MM.DD`) | PLG:269-275 (FPDate* 표시) · VAL:24-37 (toDisplayDate·toSopDateParam) |  | 구현 |
| CF-14 | SOP_PLANT_ID / `PlantByDivisionCompany` | PLG:96-133 (dataMap — @division 전달·@company 관대형) |  | 구현 |
| CF-15 | DPJT_DEVELOP_STATUS / `DpjtDevelopStatus` | PLG:96-133 (dataMap — lookup 원장 0행 = 빈 콤보 허용·null 폴백 표시 전용, 계약 ⑤ U 항목. lookup 등재 후 자동 활성) |  | 구현 |
| CF-16 | 팝업 오픈(권한관리 링크) / 조직도/입력/조회/요청 4그리드 | PAM:136-177 (4축 조회 — P_DPJT_KEY = 클릭 행 DPJT_KEY) |  | 구현 |
| CF-17 | 조직도 부서 클릭 / 사용자 목록 | PAM:241-244 · PAM:128-134 (deptId 만 전달) |  | 구현 |
| CF-18 | 사용자 검색(Search) / 사용자 목록 | PAM:194-205 (userInfo 만 전달 — 조건 없으면 미출력 143-150) |  | 구현 |
| CF-19 | (+)/(−)/입력↔조회 이동/승인 이동 / 입력/조회/요청 리스트 | PAM:308-320 · AP:58-169 (pending 상태 전이 — OK 저장 시 확정) |  | 구현 |
| CF-20 | 반려 버튼 / 요청 행 | PAM:335-380 (pending REJECT) + handleOk §13 단건 (정본 승계 — E15 차이 보고 참조) |  | 구현 |
| CF-21 | 팝업 OK 저장 완료 / 메인 그리드 | PAM:412-466 (handleOk) · PL:332-337 (onSaved → refreshMain — 권한요청/권한관리 상태 update) |  | 구현 |
| P-01 | 편집 / **관리자(나의 권한 ADMIN)인 경우만 항목 수정 가능** — 비관리자 행 전 셀 잠금 | EL:11-30 (isAdminRow·isCellEditable) · PLG:276-281 (색 동기) · PLG:299-301 (beginningEdit cancel) · editLock.test 매트릭스 |  | 구현 |
| P-02 | 권한관리 / **권한관리 링크 = 나의 권한이 관리자인 경우만** — SP 가 ADMIN 행만 `''`(노출), 그 외 `'-'` | EL:38-40 (canOpenAuthMgmt — SP 값 단일 원천) · PLG:229-239 · PL:265-271 |  | 구현 |
| P-03 | 권한요청 / **권한요청 = 나의 권한이 권한없음·조회 권한인 경우만 가능** (관리자/입력 권한 행 = 링크 `-`) | EL:42-45 (canReqAuth — 3상태 파생) · PLG:241-250 ('-' 봉인 렌더) |  | 구현 |
| P-04 | 권한요청 / 권한요청 가능한 경우가 아니면 입력/조회 **Checkbox 비활성** — SP 행별 3상태(`DISABLED`/`CHECKED`/`UNCHECKE… | EL:33-36 (isReqCheckToggleable) · PLG:252-267 (DISABLED 렌더 잠금) · PLG:352-356 (토글 차단) |  | 구현 |
| P-05 | 편집 / 입력/조회 Checkbox **상호배타** — 하나 선택하면 다른 쪽 자동 해제(Unchecked) | PLG:362-371 (CHECKED 시 반대쪽 UNCHECKED) |  | 구현 |
| P-06 | 등록요청 / **변경 내역이 있는 경우만 등록요청 가능** — 없으면 "수정된 내용이 없습니다." | PL:200-206 ('M' 행 0건 = MSG00004) · PLG:294-298 (체크 토글 EditTracker 격리 — 'M' 오염 방지) |  | 구현 |
| P-07 | 등록요청 / Checked 선택 0건 시 불가 — "선택한 항목이 존재하지 않습니다." | PL:195-199 (MSG00709) |  | 구현 |
| P-08 | 등록요청 / 실행 전 Confirm "프로젝트를 등록/변경 하시겠습니까?" + 성공/실패 메시지 | PL:207-224 (MSG00710 confirm → MSG00711 toast / MSG00712) |  | 구현 |
| P-09 | 조회 / **Division 필수** — 미선택 시 조회 불가 | VAL:64-65 (MSG00097) · validate.test |  | 구현 |
| P-10 | 조회 / **등록 완료일 필수 + 기간 역전 금지**(시작일>종료일 불가) | VAL:66-71 (MSG00108 — 빈 값 포함 차단, SDM1010 TAB2 와 달리 전체 조회 불허) · validate.test |  | 구현 |
| P-11 | 권한요청 / 입력/조회 선택(Checked) 값 없으면 불가 — "권한요청 항목이 없습니다." | PL:234-240 (MSG01002 — 원본 스냅샷도 무체크일 때) |  | 구현 |
| P-12 | 권한요청 / 실행 전 Confirm "권한요청 하시겠습니까?" / 취소 경로 "권한요청을 취소 하시겠습니까?"(요청 Checked 를 해제하고 요청하는 경우) … | PL:227-244 (MSG01003 / 취소 경로 = 원본 CHECKED + 현재 무체크 → MSG01004. ⚠ SP 취소 처리(D12)는 PKG 정정 대기 — no-op 시 EVENT 0 안내) |  | 구현 |
| P-13 | 팝업 조회 / 검색 = **사용자 조회 조건 값만** 전달 — 조건 값 없으면 그리드 미출력 | PAM:128-134 (검색 모드 deptId '') · PAM:143-150 (조건 전무 enabled false) |  | 구현 |
| P-14 | 팝업 조회 / 조직도 부서 클릭 = **부서 정보만** 전달하여 사용자 목록 호출 | PAM:128-134 (부서 모드 userInfo '') · PAM:241-244 |  | 구현 |
| P-15 | 팝업 (+) / **관리자는 권한 추가 불가** — "관리자는 권한을 추가할 수 없습니다." |  | §7 사용자 목록 커서(6컬럼)·§8/§9 리스트 커서에 관리자 식별 컬럼 부재 — FE 판별 불가 + 공용 정본(SDM1010) 무수정 승격 원칙. MSG01007 은 등재 완료 — SP/커서 보강 후 배선 (설계자 확인 요청) | 제외 |
| P-16 | 팝업 (+) / 입력 또는 조회 리스트 **기존재 사용자 추가 불가** — 추가 방향과 무관하게 입력/조회 리스트 모두 체크 | AP:58-79 (addUsersToList — 대상 리스트 중복 가드 MSG00716/717) · AP:107-132 (이동 도착 가드). ⚠ 교차 리스트(반대편) 체크는 SDM1010 정본 동작 승계 — 차이 보고 항목 |  | 구현 |
| P-17 | 팝업 저장 / 저장(OK) 버튼을 클릭해야 **최종 저장**(입력/조회 이동·요청 승인 이동은 pending) | PAM:96-122 (pending 로컬) · PAM:412-466 (handleOk 확정) |  | 구현 |
| P-18 | 팝업 제외 / 요청 정보 존재 사용자를 입력/조회 그리드에서 삭제(−)하면 **요청 그리드에 복귀 추가** — 이를 위해 입력/조회 그리드 Load·이동 시 요… | AP:81-105 (승인 추가분 결정 원복 → 요청 그리드 원행 복귀) · 기존 권한자 = OK replace-set 반려(§11/§12) 후 재조회 반영 — SDM1010 정본 방식 |  | 구현 |
| P-19 | 팝업 반려 / 반려 버튼 = Alert 후 **바로 반려 처리(SP 즉시 호출 — OK 무관)** + "반려" 상태 즉시 표시 | PAM:335-380 (반려 pending pill 즉시 표시) + handleOk §13 단건 확정 — ⚠ 정본 승계: SP 호출은 OK 시 (설계 '즉시'와 차이 — 미해결 보고 항목) |  | 구현 |
| P-20 | 팝업 저장 / OK 저장 시 입력/조회 그리드 **모든 값 전달** — "반려" 상태 Update(3.1.1) + 권한 제외자의 요청 이력 반려 처리(3.1.2) | PAM:412-466 (WRITE/READ 두 리스트 **연속 전량 저장** replace-set + rejectIds §13) |  | 구현 |
| P-21 | 편집 / 편집 대상 컬럼 축 = Project Class/Customer/Project Name/Cell Type/Stack Method/Biz Type/SOP… | EL:16-30 (INPUT_TP_CD 단일 원천 — 계약 ④ IM/IO 재지정분 소비. 하드코딩 컬럼 목록 금지) |  | 구현 |
| P-22 | 데이터 / 상태 TAG 도메인 = GRID 범례 9행(작성중/승인대기/등록완료/반려/변경등록/변경중/변경요청/등록완료(변경)/**'변경반려' 코드 미정**) —… | PLG:213-227 (lookup 데이터 주도 렌더 — NAME/COLOR 커서 소비. U-04 '변경반려' 코드 미정분은 lookup 등재 시 자동 반영 — FE 하드코딩 0) |  | 구현 |
| P-23 | 데이터 / 콤보 컬럼 = CODE/NAME 페어 — 저장 CODE·표시 NAME(Visible=N/Y 쌍) | PLG:96-133 (CODE 컬럼 직결 dataMap — 저장 CODE·표시 NAME) · 계약 ④ H/표시 쌍 메타 소비 |  | 구현 |
| P-24 | 권한 / 화면 접근 = `SPMS Administrator` / `SPMS Planner`(개요 B7) — 행 단위 권한은 그룹이 아니라 **프로젝트별 나의 권… | 계약 ② (UGR_MNU 3·UGR_BTN 21 — DB 메타) · PL:70 (hasButton) · 행 단위 = P-01~P-04 (EL — DPJT_AUTH_TYPE/3상태 단일 원천) |  | 구현 |
| P-25 | 저장 경로 / **저장 버튼 없음** — 그리드 수정 내역은 [등록요청] 에 의해서만 저장(변경본 신규 INSERT + 원본 MODIFYING 전이) | PL:274-281 (hotkeyConfig save/insert/delete=false) · PL:193-225 (REQ 경유 저장 — 행별 단건) |  | 구현 |
| P-26 | 조회조건 / 사업부 변경 = 컬럼정보 재조회 + 그리드 초기화 + CRUD reset (재조회는 Search 버튼) | PL:148-153 (handleDivisionChange — clearFilters·tracker/스냅샷 reset·메타 재조회. 자동 재조회 금지) |  | 구현 |
| P-27 | 조회조건 / 기본값 = 사업부 첫 값 / 고객·나의 권한·등록 상태 ALL / 등록 완료일 M-1~Today(`PR_GET_DAY_RANGE`) | PLS:38-46 (initSearch — 멀티 []=ALL) · PL:156-163 (첫 값) · PL:83-100+VAL:52-60 (M-1~Today) |  | 구현 |
| P-28 | 팝업 후처리 / 팝업 처리 후(반환 E33 "POPUP 내에서 처리") 메인 그리드 재조회 → "입력/조회 권한등록" 상태 값 update | PL:332-337 (onSaved=refreshMain — setFilter 재조회 경로) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:E01:SEARCH | [SEARCH] 화면 진입(초기화) / 조회조건 콤보 적재 + 기간 기본값 M-1~Today + 컬럼 메타 + 버튼 권한 | PL:83-113 · PLF:34-43 |  | 구현 |
| CRUD:E02:SEARCH | [SEARCH] 사업부(Division) 변경 / 컬럼정보 재조회 + 그리드 초기화 + CRUD reset + 종속 콤보 재적재 | PL:148-153 · PLF:69-84 |  | 구현 |
| CRUD:E03:SEARCH | [SEARCH] 조회(Search) / 필수(Division·기간)·기간 역전 검증 → 조회 | PL:130-144 (setFilter 단독 — refetch 금지) · PLS:66-81 (PROC_M COL_NM payload) |  | 구현 |
| CRUD:E05:SEARCH | [SEARCH] 권한요청 입력/조회 체크박스 / 상호배타(하나 선택 시 반대쪽 자동 해제) + 비활성 가드 | PLG:252-267·352-372 (서버 3상태 재조회 반영 — PL:103-107 스냅샷 폐기) |  | 구현 |
| CRUD:E06:SEARCH | [SEARCH] 등록요청 버튼 / Checked·변경내역 가드 → confirm → 변경 등록 요청 → 재조회 | PL:193-225 (성공/부분실패 시 refreshMain) |  | 구현 |
| CRUD:E07:SEARCH | [SEARCH] 권한요청 링크(그리드 내) / 체크값 가드 → confirm(요청/취소) → 권한 요청 → 재조회 | PL:227-263 (성공 시 refreshMain — CHECKED 반영) |  | 구현 |
| CRUD:E09:SEARCH | [SEARCH] 팝업 오픈(초기 조회) / 조직도 + 입력 권한 + 조회 권한 + 권한요청 4축 조회 | PAM:136-177 (staleTime 0 — 재오픈 재조회) |  | 구현 |
| CRUD:E10:SEARCH | [SEARCH] 팝업 사용자 검색 / 사용자 조회 조건 값만 전달 → 사용자 목록 조회(조건 없으면 미출력) | PAM:143-150·194-205 |  | 구현 |
| CRUD:E11:SEARCH | [SEARCH] 팝업 조직도 부서 클릭 / 부서 정보만 전달 → 사용자 목록 조회 | PAM:128-134·241-244 |  | 구현 |
| CRUD:E12:INSERT | [INSERT] 팝업 (+) 버튼 / 사용자를 입력/조회 리스트에 추가(관리자·중복 가드) | PAM:308-310 · AP:58-79 (pending INSERT — OK 시 §11/§12 확정) |  | 구현 |
| CRUD:E12:SEARCH | [SEARCH] 팝업 (+) 버튼 / 사용자를 입력/조회 리스트에 추가(관리자·중복 가드) | PAM:187-190 (userRows — 추가 원천 조회) · AP:58-79 (중복 체크) |  | 구현 |
| CRUD:E13:SEARCH | [SEARCH] 팝업 (−) 버튼 / 입력/조회 리스트에서 제외 — 요청 이력 보유자는 요청 그리드 복귀 | PAM:312-315 · AP:81-105 |  | 구현 |
| CRUD:E14:SEARCH | [SEARCH] 팝업 요청 그리드 입력/조회 이동 / 요청 행을 입력/조회 리스트로 이동(요청 정보 보유) | PAM:335-380 · AP:134-169 |  | 구현 |
| CRUD:E16:SAVE | [SAVE] 팝업 OK(저장) / 입력/조회 그리드 전량 전달 저장 → 성공/실패 → 메인 재조회 | PAM:412-466 (handleOk — replace-set 2본 + §13 단건. CODE '0'+EVENT 합산 판정) |  | 구현 |
| CRUD:E16:SEARCH | [SEARCH] 팝업 OK(저장) / 입력/조회 그리드 전량 전달 저장 → 성공/실패 → 메인 재조회 | PL:332-337 (onSaved=refreshMain) |  | 구현 |
| CRUD:E17:SAVE | [SAVE] 팝업 Close/X / 저장 없이 닫기(pending 폐기) | PAM:104-122 (open reset — SP 미호출·pending 폐기) |  | 구현 |
| CRUD:E20:SEARCH | [SEARCH] 기본 기능 / 조회조건 Condition/Reset Condition + 컬럼 Filter/Sort | PL:296-318 (MainTitle/SubTitle 공용) · PLG allowSorting·gridFilterRef |  | 구현 |
| MODAL:ColumnSettingModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | 설계서 SP `?`(U-01) — SP 임의 배선 금지 (E19 동일 사유. master 공용 정본 모달은 SP 확정 후 배선) | 제외 |
| MODAL:FPModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | PLG:229-239·344-347 (DPJT_AUTH_MGMT FPModal 셀 — D7 규약. 별도 모달 아님 — E08 권한관리 오픈 배선으로 충족) |  | 구현 |
| MODAL:ProjectAuthRegModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | features/sdm/src/components/ProjectAuthRegModal.tsx (SDM1010 공용 승격분 — MENU_ID SDM1010 유지·기능 무수정 이동. 4영역 분석 = 주요이벤트 md E09~E17 + 제약 P-13~P-20 행별 판정) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 행 추가(Insert) 이벤트 부재 화면 — 조회/변경 전용(P-25 저장 버튼 없음·hotkeyConfig insert=false PL:274-281). keepRowVisibleUnderFilter 대상 신규행 없음 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | PL:119-135 (hasPendingChanges — 셀 편집 'M'·체크박스 토글 스냅샷 + MSG00703 confirm) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) |  | 컬럼 설정 기능 자체 제외(설계서 SP 미기재 '?' — U-01·SP 임의 배선 금지, SDM1010 UC-03 판례 동일) — 대상 기능 부재 | 제외 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | PL:220-224 (REQ toast MSG00711) · PL:256-262 (AUTHREQ toast MSG01005) · PAM:459-462 (모달 OK toast MSG00002) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | PLG:96-133 (CODE/NAME DataMap) · PLG:399-412 (컬럼 dataMap 적용 — gridAction 승계. TAG 컬럼(DPJT_REG_STATUS)은 코드 출력 — 계약 ④ 가 코드 컬럼을 표시 축으로 등재, dataMap 원천(콤보) 아님) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | VAL:40-44 (toMultiParam 콤마 연결) · PLS:66-81 (SP 전달) · SP UF_FX_STRING_SPLIT 테이블화 (PKG L120~133 실측. Key-in 텍스트 조회조건은 없음 — 멀티 콤보 콤마 계약 충족) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | 공용 DataGrid 내장 경로 (`packages/shared/src/components/organisms/data-grid/DataGrid.tsx:684-686` rebindFilterColumns) + PL:130-144 (재조회 = setFilter 참조 교체 — 정적 컬럼 유지·그리드 remount 없음) |  | 구현 |
