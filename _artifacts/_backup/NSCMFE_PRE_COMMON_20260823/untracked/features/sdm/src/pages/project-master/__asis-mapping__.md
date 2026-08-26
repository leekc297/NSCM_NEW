# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `SDM5010_ProjectMaster_주요이벤트_상세분석.md`, `SDM5010_ProjectMaster_제약매트릭스.md`, `SDM5010_ProjectMaster_Cascade_Filter_전수.md` · 생성: asis_mapping_gate.py --init
> ⭐ **정본 원천 = 화면설계서 xlsx** (`Doc/화면설계서_SDM/SDM5010/SDM5010_ProjectMaster_화면설계서_20260813.xlsx` — 10시트 + drawings 도형) — AS-IS GSCM 대응 화면 부재(순수 신규, hook #134 §0).
> HANDLER 축 = AS-IS .cs 부재로 N/A(정당 제외 — hook #134 §2-2). 콤보 호출지점 대사(게이트 §8) 동일 사유 SKIP(리포트 사유 행 기재 의무).
> 정오표: `Doc/화면분석서/SDM5010_ProjectMaster_정오표.md` (PKG 결함 D1~D24[D1~D6·D10~D13 정정 승인 기확정] + 설계서 F-1~F-23 + 미결 T-1~T-12 — 미결 항목은 "설계 미완" 사유로 제외 처리, 임의 완성 금지)
> ⚠ E22/MODAL:ColumnSettingModal = 설계서 SP `?`(T-1) — SP 임의 배선 금지(SDM1010 정오표 #14 판례). MODAL:ProjectAuthRegModal = SDM1010 계열 공용 정본 재사용(F-22 — 신규 작성 금지). E20 TAB2 저장 = `P_SDM5010_SAVE_TAB2_PJT_MASTER` **PKG 부재 — D1 신규 작성 승인** 후 배선(2026-08-19 사내 적용 완료 — 계약 ①).
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.
> 구현 파일 약칭: PM=`ProjectMaster.tsx` / PMF=`components/ProjectMasterForm.tsx` / T1G=`components/ProjectMasterTab1Grid.tsx` / T2G=`components/ProjectMasterTab2Grid.tsx` / PMS=`useProjectMasterStore.ts` / VAL=`utils/project-master.validate.ts` / API=`utils/project-master.api.ts` / EL=`utils/project-master.editLock.ts` / **PAM**=`features/sdm/src/components/ProjectAuthRegModal.tsx` (SDM1010 공용 승격분 — 기능 무수정 재사용 F-22) / **AP**=`features/sdm/src/components/project-reg.authPopup.ts`

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E01 | 화면 진입(초기화) / 조회조건 콤보 적재 + 기간 기본값 M-1~Today + 컬럼 메타 + 버튼 권한 | PM:101-118 (period)·PM:131-135 (메타 fetch)·PM:81 (버튼 권한)·PMF:37-49 (콤보) |  | 구현 |
| E01-1 | 조회조건 콤보 적재(1RT `useTabComboQueries`): 사업부=`MyDivision`(사용자 권한 기반, 첫 번째 값 기본 선택·필수 — 개요 F1… | PMF:37-49 (MyDivision·EndCustomerByDivision·DmBizType·lookup 2종) · PM:189-196 (첫 값 기본 선택 보정) |  | 구현 |
| E01-2 | 등록 요청일 기본값: **M-1 ~ Today**(개요 F18). 설계 기재 SP `P_SDM1010_GET_PERIOD`(H18 — 7-param 설명)는 실… | PM:101-118 (period 시트 = P_SDM1010_GET_PERIOD 공유 배선 — 계약 ① SDM5010_period_SEARCH 등재 기준) · VAL:51-56 (defaultRegCompRange — YMD_FR 앵커 + Today dayjs 병행) |  | 구현 |
| E01-3 | 그리드 컬럼 메타: `fetchStaticColumns`(SCM_MST_SHEET_COLUMNS — TAB1 24행 + TAB2 24행, UI컬럼 정의 시트 실… | PMS:105-125 (fetchStaticColumns) · PM:131-135 (mount fetch 양 시트) · 계약 ④ SHEET_COLUMNS 24/24행 |  | 구현 |
| E01-4 | 버튼 권한: `useTabBtnPermissions` — SPMS Administrator 단독(F-19). | PM:81 (hasButton) · 계약 ② UGR_BTN 12행/MNU_MPG 3행 (단독 그룹 DISTINCT=1 실측) |  | 구현 |
| E01-5 | 초기 자동조회 여부는 설계서 미기재(T-6 — 확정 전 자동조회 미배선, Search 버튼 대기). | PM:131-135 (mount = clearFilters — 자동조회 미배선, Search 버튼 대기. T-6 확정 시 재배선) |  | 구현 |
| E02 | 사업부(Division) 변경 / 컬럼정보 재조회 + 그리드 초기화 + CRUD reset + 종속 콤보 재적재 | PM:181-186 (handleDivisionChange — clearFilters·양 탭 Tracker clear·메타 재조회) · PMF:82-91 (고객·Biz Type ALL reset) |  | 구현 |
| E03 | 탭 전환(TAB1↔TAB2) / 활성 그리드 전환 — 공통버튼 활성그리드 라우팅 + 수정 중 confirm | PM:199-205 (handleTabChange — 수정 중 confirm MSG00703) · PM:295-302 (hotkeyConfig 활성 탭 라우팅 — 저장 TAB2 전용) · PM:320-329 (SubTitle 활성 그리드) |  | 구현 |
| E04 | TAB1 조회(Search) / Session 기반 등록 요청 조회(조회조건 미소비 — F-3) | PM:158-176 (handleSearch TAB1 분기) · PMS:72-77 (Session filter — sesDivisionId+userGroup) |  | 구현 |
| E05 | TAB1 그리드 셀 편집 / 수정 항목 11종 편집 — '수정' 구분 행 D-PJT Code 편집 불가(F-9)·6자리(P-08) | T1G:269-315 (beginningEdit·cellEditEnded — CF-15 포함) · EL:19-29 (INPUT_TP_CD×MOD 행 게이트) · EL:42-44 (6자리) |  | 구현 |
| E06 | TAB1 승인(행 버튼) / Focused Row 단건 → confirm → 승인 처리 → 재조회 | PM:224-242 (handleConfirmRow — 6자리 선검증→MSG01008 confirm→MSG01009/01010→재조회) · T1G:229-249 (REG_COL 버튼 렌더) · API:88-90 · VAL:79-95 |  | 구현 |
| E07 | TAB1 반려(행 버튼) / Focused Row 단건 → confirm → 반려 처리 → 재조회 | PM:246-258 (handleCancelRow — MSG01011 confirm→MSG01012/01013→재조회) · T1G:229-249 · API:100-102 · VAL:97-103 (note 전달) |  | 구현 |
| E08 | 권한관리 링크 클릭 / 권한관리 팝업 오픈(프로젝트 키 전달) | T1G:213-226·T2G:140-153 (링크 렌더) · T1G:318-340·T2G:207-231 (클릭) · PM:287-292 (handleAuthRegCellClick) · PM:363-368 (모달·onSaved 재조회) |  | 구현 |
| E09 | 팝업 오픈(초기 조회) / 조직도 + 입력 권한 + 조회 권한 + 권한요청 4축 조회 | PAM:136-177 (POP1_TREE/GRID1~4 — MENU_ID SDM1010·P_SDM1010_* 재사용 F-22) |  | 구현 |
| E10 | 팝업 사용자 검색 / 사용자 조회 조건 값만 전달 → 사용자 목록 조회(조건 없으면 미출력) | PAM:143-150 (enabled 가드 — 조건 전무 시 미조회) · PAM:194-205 (applyUserSearch) |  | 구현 |
| E11 | 팝업 조직도 부서 클릭 / 부서 정보만 전달 → 사용자 목록 조회 | PAM:241-244 (selectDept — 부서 모드·userInfo 배타) · PAM:128-134 (deptId 만 전달) |  | 구현 |
| E12 | 팝업 (+) 버튼 / 사용자를 입력/조회 리스트에 추가(관리자·중복 가드) | PAM:308-310 (handleAdd) · AP:58-79 (addUsersToList — 중복 MSG00716/00717·관리자 MSG01007 가드) |  | 구현 |
| E13 | 팝업 (−) 버튼 / 입력/조회 리스트에서 제외 — 요청 이력 보유자는 요청 그리드 복귀 | PAM:312-315 (handleRemove) · AP:81-105 (removeUsersFromList — 요청 이력 보유자 요청 그리드 복귀) |  | 구현 |
| E14 | 팝업 요청 그리드 입력/조회 이동 / 요청 행을 입력/조회 리스트로 이동(요청 정보 보유) | PAM:335-380 (행내 [✓입력][✓조회] 버튼) · AP:134-169 (applyRequestDecision — 요청 정보 보유) |  | 구현 |
| E15 | 팝업 반려 버튼 / Alert 후 **즉시 SP 호출** → 반려 상태 즉시 표시 | PAM:335-380 ([x반려] pending 표시) · PAM:412-466 (handleOk 반려 단건) — ⚠ 정본 승계: 반려 **확정은 OK 시** (설계 '즉시 호출'과 차이 — 공용 정본 무수정 재사용 F-22, SDM1020 E15 동일 미해결 보고 승계) |  | 구현 |
| E16 | 팝업 OK(저장) / 입력/조회 그리드 전량 전달 저장 → 성공/실패 → 메인 재조회 | PAM:412-466 (handleOk — WRITE/READ replace-set + 반려 단건·EVENT 합산) · PM:363-368 (onSaved=refreshActive) |  | 구현 |
| E17 | 팝업 Close/X / 저장 없이 닫기(pending 폐기) | PAM:104-122 (open reset — pending 폐기) · PAM footer Close=modalClose |  | 구현 |
| E18 | TAB2 조회(Search) / 필수(Division·기간)·역전·3년 검증 → Master 조회 | PM:158-176 (handleSearch TAB2 분기) · VAL:59-73 (validateSearch — MSG00097/MSG00108/MSG00164) · PMS:78-89 (filter 빌드) |  | 구현 |
| E19 | TAB2 그리드 셀 편집 / **개발현황(콤보) + 비활성(체크) 2컬럼만** 편집(P-12) — CRUD 'M' 마킹 | T2G:187-204 (beginningEdit — IO 2컬럼만) · T2G:206-230 (DISABLE_YN 클릭 토글 + CRUD_TYPE 'M' 수동 마킹) · EL:31-40 |  | 구현 |
| E20 | TAB2 저장 버튼 / 필수·중복 확인 → 저장 → Toast → 재조회 | PM:263-284 (handleSave — 'M' 행별 단건·confirm 없음 명기·EVENT 0 = MSG00004) · API:113-115 (D1 신규 SP) · VAL:107-113 |  | 구현 |
| E21 | 엑셀 버튼 / 활성 그리드 엑셀 다운로드(콤보 NAME 출력) | PM:320-329 (SubTitle excelFileName='ProjectMaster' — 활성 그리드 라우팅) · T1G:371-378·T2G:262-269 (dataMap NAME — gridAction 승계) |  | 구현 |
| E22 | 컬럼 설정 버튼 / 공용 ColumnSettingModal 호출 — **SP `?` 미결(임의 배선 금지)** |  | 설계서 SP 미기재('?' — T-1) — SP 임의 배선 금지(SDM1010 정오표 #14 판례). 계약 ② 컬럼 설정 API 미등재 관례 동일. 설계서 확정 기재 시 배선 | 제외 |
| E23 | 기본 기능 / 조회조건 Condition/Reset Condition + 컬럼 Filter/Sort | PM:307-329 (MainTitle/SubTitle 공용 경로 — 계약 ② FILTER/SORT BTN 등재) · T1G/T2G allowSorting·gridFilterRef |  | 구현 |
| E24 | TAG·행 색상 렌더링 / 권한등록 상태 TAG + TAB1 '수정' 구분 행 색상(행 단위 — F-10) | T1G:195-211·T2G:122-138 (TAG — TAG_SOURCE NAME/COLOR 데이터 주도) · T1G:189 (rowMod — DPJT_REG_CAT='MOD') · scss:.rowMod (T-7 임시 warning 계열) |  | 구현 |
| CF-01 | 사업부 (LBL00001) / ComboBox(Single) | PMF:63-92 (MyDivision Single 필수) · PM:189-196 (첫 값 기본 보정) |  | 구현 |
| CF-02 | 고객 / ComboBox(Multi, 검색+ALL) | PMF:41-44 (EndCustomerByDivision — 따옴표 divisionId·사업부 종속) · PMF:94-110 (Multi+ALL) |  | 구현 |
| CF-03 | Cell 유형 / ComboBox(Multi) | PMF:50-52 (lookup SPMS_CELL_TYPE) · PMF:112-128 (Multi+ALL — 설계 원문 비종속 F-17) |  | 구현 |
| CF-04 | Biz Type / ComboBox(Multi) | PMF:41-46 (DmBizType — 조회조건은 설계서 기재. 그리드 셀만 BizTypeByDivision 계약 ④) · PMF:129-145 (Multi+ALL) |  | 구현 |
| CF-05 | 개발 현황 / ComboBox(Multi) | PMF:50-52 (lookup SPMS_DPJT_DEVELOP_STATUS — 임시 시드 DEV/PROD/DROP T-4) · PMF:150-166 (Multi+ALL, LBL00863 신규) |  | 구현 |
| CF-06 | 등록 요청일 / Date(From~To) | PMF:168-173 (PeriodField — 실필터 축 REG_COMP_DATE F-2·라벨 LBL00857) · PM:101-118 (기본 M-1~Today) |  | 구현 |
| CF-07 | Division 변경 cascade / 고객·Biz Type 콤보 재적재+ALL reset → 컬럼 메타 재조회 → 양 탭 그리드 비움+CRUD reset + … | PM:181-186 (handleDivisionChange — 자동 재조회 금지) · PMF:82-91 (ALL reset·쿼리키 변경 재적재) |  | 구현 |
| CF-08 | TAB1 필터 / Session Division + MGMT_USER_ID=본인(**설계 원문 유지 — 사용자 확정** D14) + WAITING/REQ_MOD… | PMS:72-77 (sesDivisionId 실전달 + userGroup '' — 본인 필터·상태 필터는 SP WHERE 3술어 처리, FE 는 세션 전달만) |  | 구현 |
| CF-09 | TAB2 필터 / 'ALL' 무필터 OR 단락 + `UF_FX_STRING_SPLIT` 멀티 5축 + `REG_COMP_DATE BETWEEN`(양 NULL 무… | PMS:78-89 (toMultiParam 'ALL' 센티널·콤마 연결 + ymdToDash 'YYYY-MM-DD') · VAL:38-46 |  | 구현 |
| CF-10 | DPJT_REG_CAT / `DpjtRegCat` | T1G:94-127 (메타 주도 콤보 — 표시 전용 'S'. ⚠ CMBO 'DpjtRegCat' 미등재 = 계약 발견사항 1: dataMap null 시 원문 코드 표시, 커서 DPJT_REG_CAT_NAME 보조 — 콤보 후속 등재 대기) |  | 구현 |
| CF-11 | DIVISION_ID / `Division` | T1G:94-127 (메타 주도 콤보 — IM 편집 P-07) |  | 구현 |
| CF-12 | DPJT_CLASS / `DpjtClass` | T1G:94-127 (메타 주도 콤보) |  | 구현 |
| CF-13 | END_CUSTOMER / `EndCustomerByDivisionDept` | T1G:94-127 (메타 주도 콤보 — 조회 Division 따옴표 전달·관대형 @dept 무토큰 무해) |  | 구현 |
| CF-14 | CELL_TYPE / `CellTypeByDivision` | T1G:94-127 (메타 주도 콤보 — 조회 Division 종속) |  | 구현 |
| CF-15 | STACK_METHOD / `StackMethodByCellType` | T1G:129-155 (CellType 코드별 선적재) · T1G:283-292 (행값 dataMap 스왑) · T1G:298-313 (CELL_TYPE 변경 시 clear + 원복 — hook #59 §5-G) |  | 구현 |
| CF-16 | BIZ_TYPE / `BizTypeByDivision` — **확정** (설계서 N13/N39 병기 "DmBizType (or BizTypeByDivision)… | T1G:94-127 (메타 주도 콤보 — 계약 ④ BizTypeByDivision 확정·조회 Division 종속) |  | 구현 |
| CF-17 | SOP_DATE / (FPDate `YYYY.MM.DD`) | T1G:252-256 (FPDate* 표시 'YYYY.MM.DD') · VAL:25-36 (toDisplayDate·toSopDateParam) |  | 구현 |
| CF-18 | SOP_PLANT_ID / `PlantByDivisionCompany` | T1G:94-127 (메타 주도 콤보 — 조회 Division 종속·관대형 @company 무토큰 무해) |  | 구현 |
| CF-19 | (TAB2) DPJT_DEVELOP_STATUS / DISABLE_YN / `DpjtDevelopStatus`(FPComboBox) / FPCheckBox | T2G:64-90 (DpjtDevelopStatus dataMap) · T2G:155-168 (DISABLE_YN 3상태 렌더) · T2G:206-230 (클릭 토글 — 계약 ⑥ CHECKED/UNCHECKED 왕복) |  | 구현 |
| CF-20 | lookup·마스터 INNER 소실 축 전수 / GET_TAB1 = INNER 9/LEFT 4 · GET_TAB2 = INNER 9/LEFT 6 — INNER … |  | SP 조회 축 관찰(D9/D13/D15 — 정오표 기록·D13 은 REGSTS 정정으로 해소) — FE 구현 대상 아님 | 해당없음 |
| CF-21 | 팝업 오픈(권한관리 링크) / 조직도/입력/조회/요청 4그리드 | PAM:136-177 (4축 조회 — P_DPJT_KEY = 행 DPJT_KEY invisible 전달) |  | 구현 |
| CF-22 | 조직도 부서 클릭 / 사용자 목록 | PAM:241-244 · PAM:128-134 (P_DEPT_ID 만 전달) |  | 구현 |
| CF-23 | 사용자 검색(Search) / 사용자 목록 | PAM:194-205 (P_USER_INFO 만 — 조건 없으면 미출력) |  | 구현 |
| CF-24 | (+)/(−)/요청 이동 / 입력/조회/요청 리스트 | PAM:308-315·335-380 · AP:58-169 (pending 상태 전이 — OK 저장 시 확정) |  | 구현 |
| CF-25 | 반려 버튼 / 요청 행 | PAM:335-380 ([x반려] pending) · PAM:412-466 (OK 시 반려 단건 확정 — E15 정본 승계 차이 부기) |  | 구현 |
| CF-26 | 팝업 OK 저장 완료 / 메인 그리드(활성 탭) | PM:363-368 (onSaved=refreshActive — 활성 탭 재조회 → 권한등록 상태 update) |  | 구현 |
| P-01 | 조회 / **Division 필수** — 미선택 시 조회 불가 | VAL:59-62 (MSG00097 — 선행 판정) · PM:164-168 |  | 구현 |
| P-02 | 조회 / **기간 필수 + 역전 금지**(시작일>종료일 불가) — 실필터 축 = `REG_COMP_DATE`(정오표 F-2 확정) | VAL:63-67 (MSG00108 — 빈 값/형식/역전. 개요 E18 필수 Y) |  | 구현 |
| P-03 | 조회 / **기간 3년 이내** — 종료월이 시작월 기준 3년 초과 불가 | VAL:68-71 (MSG00164 — 경계 포함 3년) |  | 구현 |
| P-04 | TAB1 표시 / TAB1 조회 범위 = **Session Division + 본인(MGMT_USER_ID=P_SES_USER_ID) + `DPJT_REG_ST… | PMS:72-77 (세션 전달만 — 본인 필터는 SP WHERE 처리, 설계 원문 유지 사용자 확정 D14) |  | 구현 |
| P-05 | TAB1 색상 / (등록) 구분 값 "수정" 행 색상 표시 — **`DPJT_REG_CAT` 기준 행 단위 확정**(커서에 원본값 부재 → 필드 diff 불가) | T1G:189 (rowMod 토글 — 행 단위) · EL:11-13 (isModRow — 'MOD' 확정) · scss:.rowMod (T-7 임시 warning 계열) |  | 구현 |
| P-06 | TAB1 편집 / 구분 "수정" 행 = **D-PJT Code 수정 불가** | EL:19-29 (isCellEditableTab1 — MOD 행 DPJT_CODE 잠금) · T1G:283 (beginningEdit cancel) |  | 구현 |
| P-07 | TAB1 편집 / 수정 항목 = **11종 한정**: 사업부/유형/고객/Project Name/셀 유형/Stack 공법/Biz Type/SOP 일정/SOP Si… | EL:15-29 (INPUT_TP_CD 메타 단일 원천 — 계약 ④ IM/IO 11종 재지정 F-14) · T1G:258-264 (편집색 동일 함수) |  | 구현 |
| P-08 | TAB1 편집 / **D-PJT Code = 6자리 필수 입력**("반드시 6글자") — SP WHERE `LENGTH(V_DPJT_CODE)=6` 가드. 가드… | EL:42-44 (isDpjtCodeValid) · PM:224-230 (승인 FE 선검증 — D12 정정분 CODE '-1' + EVENT 0 실패 처리 이중 방어) |  | 구현 |
| P-09 | 승인 / 승인 = GRID **Focused Row 단건** + confirm("승인하시겠습니까?") + 성공/실패 메시지 | PM:224-242 (MSG01008 confirm → MSG01009 toast/MSG01010 alert) · T1G:318-340 (클릭 행 단건 라우팅) |  | 구현 |
| P-10 | 반려 / 반려 = GRID Focused Row 단건 + confirm("반려하시겠습니까?") + **내용(P_NOTE) 전달** + 성공/실패 | PM:246-258 (MSG01011 confirm → MSG01012/MSG01013) · VAL:97-103 (toCancelPayload — note = 행 NOTE 전달) |  | 구현 |
| P-11 | NOTE 전파 / 내용 등록 시 **연결된 프로젝트(동일 D-PJT Code) 전행 동일 내역 Update** — 기존 내용 존재 시 딜리미터 후 연결(예: M… | VAL:79-103 (note 파라미터 전달 — MERGE 전파(`', '` 딜리미터)는 SP 내부 처리, PKG 원문 실측. 본행 덮어쓰기 상이 = D17 관찰) |  | 구현 |
| P-12 | TAB2 편집 / **편집 = 개발현황(DPJT_DEVELOP_STATUS) + 비활성(DISABLE_YN) 2컬럼만** — 나머지 전 컬럼 잠금 | EL:31-33 (isCellEditableTab2 — 메타 IO 축) · T2G:187-204 (beginningEdit 차단) · T2G:171-176 (편집색 동일 함수) |  | 구현 |
| P-13 | TAB2 저장 / P_ACTIVE_FLAG 계약 = I/D/M 이나 화면은 행 추가/삭제 부재 — **FE 는 'M' 행만 전달** | VAL:107-113 (activeFlag 'M' 고정) · PM:263-269 (CRUD_TYPE 'M' 행만 filter — D1 SP 는 'M' 외 CODE '1' 거부) |  | 구현 |
| P-14 | TAB2 표시 / TAB2 조회 범위 = `DPJT_REG_STATUS NOT IN ('WRITING','WAITING','REQ_MOD')`(작성중/승인대기/… |  | SP WHERE 고정 축(PKG 원문 실측 — REGSTS 'CHG_COMPLETE' 정합 정정 포함) — FE 구현 대상 아님 | 해당없음 |
| P-15 | 팝업 조회 / 검색 = **사용자 조회 조건 값만** 전달 — 조건 값 없으면 그리드 미출력 | PAM:143-150 (enabled 가드) · PAM:194-205 (userInfo 만 전달) |  | 구현 |
| P-16 | 팝업 조회 / 조직도 부서 클릭 = **부서 정보만** 전달하여 사용자 목록 호출 | PAM:241-244 · PAM:128-134 (deptId 만 전달) |  | 구현 |
| P-17 | 팝업 (+) / **관리자 추가 불가**("관리자는 권한을 추가할 수 없습니다." F81) + 입력/조회 리스트 기존재 중복 불가(F79/F80) — 입력·조회… | AP:58-79 (addUsersToList — 관리자 MSG01007·입력 MSG00716·조회 MSG00717 양쪽 체크) · PAM:308-310 |  | 구현 |
| P-18 | 팝업 (−) / 요청 이력 보유자를 입력/조회에서 제외 시 **요청 그리드 복귀** — 입력/조회 그리드는 최초 Load 부터 요청 정보 invisible 보유… | AP:81-105 (removeUsersFromList — 요청 정보 보유·요청 그리드 복귀) · PAM:312-315 |  | 구현 |
| P-19 | 팝업 반려 / 반려 = Alert(confirm) 후 **즉시 SP 호출**(OK 저장과 무관) → "반려" 상태 즉시 표시 | PAM:335-380 ([x반려] pending 표시) · PAM:412-466 — ⚠ 정본 승계: 확정은 OK 시 (설계 '즉시 호출'과 차이 — F-22 공용 정본 무수정, E15 미해결 보고 승계) |  | 구현 |
| P-20 | 팝업 저장 / OK = 최종 확정 — **입력/조회 그리드의 모든 값을 저장 SP 에 전달**("반려" 상태 Update + 권한 제외자 요청 이력 반려 처리) | PAM:412-466 (handleOk — WRITE/READ replace-set 전량 + 반려 단건) |  | 구현 |
| P-21 | 권한 / 접근 권한 그룹 = **SPMS Administrator 단독 확정** | PM:81 (useTabBtnPermissions 소비) · 계약 ② UGR_MNU 3계층 + UGR_BTN 12 (단독 그룹 실측 DISTINCT=1) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:E01:SEARCH | [SEARCH] 화면 진입(초기화) / 조회조건 콤보 적재 + 기간 기본값 M-1~Today + 컬럼 메타 + 버튼 권한 | PM:101-118 (period SEARCH) · PMF:37-52 (콤보/lookup 1RT) |  | 구현 |
| CRUD:E02:SEARCH | [SEARCH] 사업부(Division) 변경 / 컬럼정보 재조회 + 그리드 초기화 + CRUD reset + 종속 콤보 재적재 | PM:181-186 (자동 재조회 금지 — Search 버튼 대기) · PMS:105-125 (메타 재조회) |  | 구현 |
| CRUD:E04:SEARCH | [SEARCH] TAB1 조회(Search) / Session 기반 등록 요청 조회(조회조건 미소비 — F-3) | PM:158-176 · PMS:72-77 |  | 구현 |
| CRUD:E06:SEARCH | [SEARCH] TAB1 승인(행 버튼) / Focused Row 단건 → confirm → 승인 처리 → 재조회 | PM:240-242 (성공 시 refreshTab1 — setFilter 단독 재조회) |  | 구현 |
| CRUD:E07:SEARCH | [SEARCH] TAB1 반려(행 버튼) / Focused Row 단건 → confirm → 반려 처리 → 재조회 | PM:256-258 (성공 시 refreshTab1) |  | 구현 |
| CRUD:E09:SEARCH | [SEARCH] 팝업 오픈(초기 조회) / 조직도 + 입력 권한 + 조회 권한 + 권한요청 4축 조회 | PAM:136-177 |  | 구현 |
| CRUD:E10:SEARCH | [SEARCH] 팝업 사용자 검색 / 사용자 조회 조건 값만 전달 → 사용자 목록 조회(조건 없으면 미출력) | PAM:194-205 |  | 구현 |
| CRUD:E11:SEARCH | [SEARCH] 팝업 조직도 부서 클릭 / 부서 정보만 전달 → 사용자 목록 조회 | PAM:241-244 |  | 구현 |
| CRUD:E12:INSERT | [INSERT] 팝업 (+) 버튼 / 사용자를 입력/조회 리스트에 추가(관리자·중복 가드) | AP:58-79 (pending 추가 — OK 저장 시 확정) · PAM:308-310 |  | 구현 |
| CRUD:E12:SEARCH | [SEARCH] 팝업 (+) 버튼 / 사용자를 입력/조회 리스트에 추가(관리자·중복 가드) | PAM:143-150 (사용자 목록 조회 축 — 추가 원천) |  | 구현 |
| CRUD:E13:SEARCH | [SEARCH] 팝업 (−) 버튼 / 입력/조회 리스트에서 제외 — 요청 이력 보유자는 요청 그리드 복귀 | AP:81-105 (로컬 pending 전이 — 재조회는 OK 저장 후 E16 축) |  | 구현 |
| CRUD:E14:SEARCH | [SEARCH] 팝업 요청 그리드 입력/조회 이동 / 요청 행을 입력/조회 리스트로 이동(요청 정보 보유) | AP:134-169 (로컬 pending 전이) |  | 구현 |
| CRUD:E16:SAVE | [SAVE] 팝업 OK(저장) / 입력/조회 그리드 전량 전달 저장 → 성공/실패 → 메인 재조회 | PAM:412-466 (WRITE/READ replace-set + 반려 단건 — EVENT 합산 판정) |  | 구현 |
| CRUD:E16:SEARCH | [SEARCH] 팝업 OK(저장) / 입력/조회 그리드 전량 전달 저장 → 성공/실패 → 메인 재조회 | PM:363-368 (onSaved=refreshActive — 활성 탭 재조회) |  | 구현 |
| CRUD:E17:SAVE | [SAVE] 팝업 Close/X / 저장 없이 닫기(pending 폐기) |  | Close = 무저장 계약(pending 폐기 — PAM:104-122 open reset. SAVE 호출 자체가 없음) | 해당없음 |
| CRUD:E18:SEARCH | [SEARCH] TAB2 조회(Search) / 필수(Division·기간)·역전·3년 검증 → Master 조회 | PM:158-176 · VAL:59-73 · PMS:78-89 |  | 구현 |
| CRUD:E20:SAVE | [SAVE] TAB2 저장 버튼 / 필수·중복 확인 → 저장 → Toast → 재조회 | PM:263-284 (handleSave — 'M' 행별 단건) · API:113-115 |  | 구현 |
| CRUD:E20:SEARCH | [SEARCH] TAB2 저장 버튼 / 필수·중복 확인 → 저장 → Toast → 재조회 | PM:283 (성공 시 refreshTab2 — UC-07 필터 유지 재조회) |  | 구현 |
| CRUD:E23:SEARCH | [SEARCH] 기본 기능 / 조회조건 Condition/Reset Condition + 컬럼 Filter/Sort | PM:307-329 (MainTitle/SubTitle 공용 경로) |  | 구현 |
| MODAL:ColumnSettingModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | 설계서 SP 미기재('?' — T-1) — SP 임의 배선 금지(SDM1010 정오표 #14 판례). 설계서 확정 기재 시 배선 | 제외 |
| MODAL:ProjectAuthRegModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | PM:363-368 (오픈/닫힘/onSaved) · PAM (SDM1010 공용 정본 무수정 재사용 — F-22 신규 작성 금지·MENU_ID SDM1010 유지) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | 행 추가(Insert) 없는 화면 — TAB1/TAB2 모두 Insert/Delete 버튼 부재 (제약매트릭스 §3·P-13) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | PM:158-163 (handleSearch pending confirm) · PM:199-205 (탭 전환 confirm — E03) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) |  | 컬럼 설정 모달 미배선(E22 제외 — T-1 SP 미결·계약 ② API 미등재 관례) — 배선 시 hook #132 §2-2 함께 적용 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | PM:240-241 (승인 toast MSG01009) · PM:256-257 (반려 toast MSG01012) · PM:281-282 (저장 toast MSG00002) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | PM:325 (excelFileName='ProjectMaster') · T1G:371-378·T2G:262-269 (dataMap 재적용 — gridAction NAME 승계) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | VAL:42-46 (toMultiParam 콤마 연결) · PMS:78-89 (멀티 4축 SP 전달 — UF_FX_STRING_SPLIT 테이블화 실측) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | PM:152-154 (setFilter 단독 재조회 — 공용 DataGrid rebindFilterColumns 내장 경로) · T1G/T2G gridFilterRef |  | 구현 |
