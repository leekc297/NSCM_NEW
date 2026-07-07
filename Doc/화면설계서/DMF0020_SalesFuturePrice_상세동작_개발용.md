# DMF0020 Sales Future Price — 상세 동작 (개발용)

> **원천**: AS-IS 정본 `GSCM.DM.Forms.UIL/Master/DMF0020_SalesFuturePrice.cs`(3,969줄) + `.Designer.cs`(1,599) + `PKG_DMF0020`(4,609줄) + 사내 Oracle 실측.  
> **생성**: 2026-07-07 · hook #105 §3 · 이벤트 전수 ①→②③ 실제 발생순서(핸들러+호출메서드 1-depth).  
> **짝 산출물**: `DMF0020_SalesFuturePrice_UI분석서_v1.0.xlsx`(10시트, User 관점 가독본).

전수 카운트: 이벤트 32 · 버튼 16 · 조회조건 14 · Expression 9 · Validation 96(main 72/popup 24) · SP제약 41 · Function 8

---

## ⭐ 편집 가능 판정 — AS-IS vs TO-BE (핵심)

| 계층 | AS-IS 실측 | TO-BE 결정(2026-07-07) |
|---|---|---|
| 서버 편집권한 | `SCM_ADM_USER_MNU_EDIT_AUTH_V`(USER×MNU×UNIT_TP='D'×DIVISION) `NVL(EDIT_YN,'N')` — PKG 7 조회지점, 25 hit. **SP에 division 하드코딩 없음** | (유지) 사용자별 권한은 그대로 |
| 화면 편집대상 | `DM_UI_EDITABLE_DIVISION`(DMF0020) SEGMENT2=`40`(위임 목록) → 40=DMF0082 위임, 81·82 편집(필수컬럼 상이) | ⭐ `DM_EDITABLE_DIVISION_ALLOW`(DMF0020)=`82`만 (신규 lookup, DB 미등재→FE fallback `{'82'}`) |
| FE 하드코딩 | `SalesFuturePriceGrid` `divisionId!==40` / `SalesFuturePrice` `isDiv82(===82)` 혼재(셀81·82 vs 버튼82 불일치) | 제거 완료 → `isEditableDivision(editableSet)` 메타 구동 |
| .cs 편집 게이트 | `EditButton`: 40=EDIT_YN='N' return(MSG00448) / `isCurVersion`(Current 조회만) / 82&NewFlag lock / 필수컬럼 division별 | FE에 82만 편집 반영 |
| SAVE 재검증 | SAVE(ALL/POPUP)는 편집권한 재검증 **안 함** — 업무검증만 | (참고) 편집 게이팅=조회+FE 책임 |

> **함의**: AS-IS는 40만 제외(81·82 편집 가능)이고 진짜 편집권한은 사용자×사업부 EDIT_YN 메타 모델. 사용자 요구(82만 편집)는 AS-IS 대비 **81도 제약하는 의도적 규칙 변경**이며, LOOKUP 구동으로 소스화하여 하드코딩을 제거함.

---

## 1. 이벤트 상세 동작 (전수 32)

### 1.1 Form_Load
- **트리거**: 폼 최초 로드 (this.Load += Form_Load)
- **Division 분기**: 81(앞2자리): Excel Upload/Template 버튼 및 layoutControlItem12/29 노출, 그외: 숨김
- **소스라인**: cs 192-215
- **실제 발생 순서**:
  - ① InitForm() 기본 폼 초기화
  - ② InitControls() 조회조건 콤보 초기 세팅(Division/Team/EndCustomer/BizType/SalesSite/PlantSite cascade + dtMeasureCount/dtFuturePrice/dtWeek/dtBucketType 로드 + txtVersion='Current')
  - ③ CreateSpread() 3행 헤더 스프레드 생성(AddSheet 3,1,45) → siMain.ChangeSheet → InitSpread(true)
  - ④ DefineProperty() 날짜저장/clbDivisions='ALL'/이미지셀/권한(ADMIN·DM ADMIN→layoutControlItem5 Batch 표시)/KeyDown·SelectedIndexChanged 배선
  - ⑤ InitEvent() DefaultSheetDataModel.Changed=Dsdm_Changed 등록 + cboBucketType.SelectedIndexChanged 등록
  - ⑥ Division 분기: clbDivisions.ControlValues 앞2자리=='81' → btnExcelUpload/btnTemplate.Visible=true + layoutControlItem12/29 Always, else Never/false
- **호출 메서드**: InitForm, InitControls, CreateSpread, DefineProperty, InitEvent, SetChangeControl
- **TO-BE 상태**: useEffect(mount): 메타/콤보 fetch → 그리드 초기화 → division==81 일 때만 Excel Upload/Template 노출

### 1.2 InitControls
- **트리거**: Form_Load 내부 호출
- **Division 분기**: 81앞2자리/82 → Project·PlantSite·(82만 미등록제외 checkInvalidExec) enable; 40/기타 → disable, umltProject/clbPlantSite clear
- **소스라인**: cs 293-416
- **실제 발생 순서**:
  - ① drpDateTime.InitValue=GetDayRange() (DM.PR_GET_DAY_RANGE, p_month=6)
  - ② SetChangeControl('MyDivision') → dtDivision → clbDivisions 바인딩(CODE/NAME)
  - ③ Data.Common(UpperDeptId) dtDepartment, SetChangeControl('UserTeamByDivision',sDivision) → clbTeam
  - ④ Division 분기: (81 앞2자리 || 82) → EndCustomerByDivision+BizType 세팅, lblProject/lblPlantSite/layoutControlItem6 Enabled=true, sDivision=='82'만 checkInvalidExec.Enabled=true; else → EndCustomer/BizType 세팅, project/plantSite disable, checkInvalidExec.Enabled=false
  - ⑤ lblBizType.Enabled=true 고정
  - ⑥ SetChangeControl('UserSiteByEndCustomer') → clbSalesSite; 81 포함 시 UserPlantSiteByEndCustomer → clbPlantSite
  - ⑦ dtMeasureCount=GetMeasureCountInfo, dtFuturePrice=GetFuturePriceInfo, dtWeek=GetWeekData, dtBucketType=GetBucketType(첫행 제거) → cboBucketType
  - ⑧ txtVersion.Text='Current'
- **호출 메서드**: GetDayRange, SetChangeControl, clsCtrl.setListBox, GetMeasureCountInfo, GetFuturePriceInfo, GetWeekData, GetBucketType, CString.GetCheckedListValue
- **TO-BE 상태**: 조회조건 콤보 초기 fetch 훅. division 분기별 필드 enable/disable 상태 store

### 1.3 DefineProperty
- **트리거**: Form_Load 내부 호출
- **소스라인**: cs 436-472
- **실제 발생 순서**:
  - ① dtStartPeriod/dtEndPeriod 저장, usrConditionPanel2.Height=105, clbDivisions.ControlValues='ALL'
  - ② siMain.ImagePopUp=imageList1[0], cellTypeImage(우측 이미지, 대문자) 생성
  - ③ 권한 switch(NowGroupID): ADMIN/DM ADMIN → layoutControlItem5(Batch) Always, default Never
  - ④ umltProject.KeyDown/umltModel.KeyDown/clbDivisions.SelectedIndexChanged 핸들러 배선
- **TO-BE 상태**: 권한(role=ADMIN/DM ADMIN)일 때만 Batch 버튼 노출. 이미지 편집셀 = 팝업 셀 표준

### 1.4 cboBucketType_SelectedIndexChanged
- **트리거**: Bucket 콤보(Weekly/Monthly) 변경
- **소스라인**: cs 558-572
- **실제 발생 순서**:
  - ① siMain!=null 확인
  - ② SetSpreadColumn() W_/M_ 태그 컬럼 Visible 토글(Weekly→W_보임/M_숨김, Monthly 반대)
  - ③ 편집모드(!IsLock)면 EditButton() 2회 호출로 Edit 모드 유지
- **호출 메서드**: SetSpreadColumn, EditButton
- **TO-BE 상태**: Bucket 토글 시 주간/월간 컬럼 visible 스왑, 편집상태 재적용

### 1.5 cboBucketType_Click
- **트리거**: Bucket 콤보 클릭
- **소스라인**: cs 3817-3827
- **실제 발생 순서**:
  - ① 그리드 행 순회하여 action=='I'(Insert) 존재 시 MSG00227 후 return
- **MSG**: MSG00227(Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.)
- **TO-BE 상태**: 신규행 존재 시 Bucket 변경 차단 경고

### 1.6 FindButton / FindData (Search)
- **트리거**: 공통 Search 버튼 (protected override FindButton → FindData(true))
- **Division 분기**: 저장 SP 파라미터에 division 전달; isCurVersion(Current 조회) 아닐 시 Insert/Edit 전면 차단
- **소스라인**: cs 831-834, 1270-1536
- **실제 발생 순서**:
  - ① blnWork(연속작업) 이면 MSG00137 return; txtVersion 공백이면 MSG00283 return
  - ② isCurVersion=false 초기화, 기간/over_range(usrDiscard)/invalid_exec(checkInvalidExec) Flag 산출; period[0]>period[1] → MSG00108
  - ③ 조건 수집: division=CString.GetCheckedListValue, scm_site/plant_site/project/item/dept/end_customer/biztype/owner/version_type. division 공백 → MSG00097
  - ④ InitSpread(false) 헤더 재구성, SearchStartTime()
  - ⑤ async FoxDataClient DM.DMF0020_GET_SCM_MST_FUTURE_PRICE (CommandTimeout 10분) 실행
  - ⑥ 결과 정렬(Measure 좌측 컬럼 ASC) 후 siMain.Query(ds), LockColumn 전체 잠금
  - ⑦ SetSpreadColumn, 과거주차 Gainsboro/당월 White 배경(iResultCol/iResultMonth), ColList 토큰 Pink 배경, Project/Item 셀 이미지
  - ⑧ txtVersion=='Current' → isCurVersion=true (편집 허용 조건)
  - ⑨ SmartColMerge, dtFuturePrice 재로드, blnWork=false
- **호출 메서드**: InitSpread, SearchStartTime, SetSpreadColumn, GetFuturePriceInfo, SmartColMerge, CString.GetCheckedListValue
- **MSG**: MSG00137(이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요.), MSG00283(버전을 선택하세요.), MSG00108(조회 기간이 잘못되었습니다 (시작일 > 종료일).), MSG00097(Division 을 선택하세요.)
- **TO-BE 상태**: useTabProcQuery(GET_SCM_MST_FUTURE_PRICE). version 필수·기간역전·division 필수 검증. Current 조회만 편집가능 플래그

### 1.7 InsertButton / InsertRow
- **트리거**: 공통 Insert 버튼 (override InsertButton)
- **Division 분기**: 40 → EndCustomer40/CustomsHandbook 콤보 + ProjectStatus 계열 lock 스킵; 81 → PlantSite 편집; 82 계열 동일 Auth 콤보
- **소스라인**: cs 836-844, 1983-2211
- **실제 발생 순서**:
  - ① !isCurVersion 이면 return (Current 조회만 신규 허용), HaltAutoFilter=true
  - ② 활성행 기준 dtMeasureCount.Rows.Count(4행: LOC/USD/KRW/RTF) 만큼 Insert2
  - ③ Division별 권한 콤보 세팅: 40 → CustomsHandbook 콤보/UserSiteByEndCustomer; else → UserSiteByEndCustomerAuth/UserEndCustomerByDivisionDeptAuth. INCOTERMS=GetLookupValues('INCOTERMS','ALL','Y') 유효코드만
  - ④ DEPT_ID/SCM_SITE_ID/END_CUSTOMER(40)/PROJECT_CODE(이미지)/ITEM_ID(이미지) 컬럼 존재 시 콤보/셀타입 부여, DIVISION_ID 세팅+Lock
  - ⑤ MEASURE=LOOKUP_CODE 세팅, LOC 아닌 행은 Measure+1~끝 Lock, LOC 행은 과거주차 Lock, PRICE_EXIST Lock
  - ⑥ SetRowSpanFuc 로 좌측 정보열 4행 병합, ManualAutoFilter, IsChange=true
- **호출 메서드**: GetCellNumbersByRow, Insert2, Data.UserTeamByDivisionAuth, Data.UserSiteByEndCustomer(Auth), Data.UserEndCustomerByDivisionDeptAuth, GetCustomsHandbook, GetLookupValues, SetCellTypeCombo, CUIControl.SetRowSpanFuc
- **TO-BE 상태**: 신규행 4행(measure) 세트 추가. division별 combo 소스 분기. 좌측 정보 4행 세로 merge + 편집셀 컬러링

### 1.8 DeleteButton
- **트리거**: 공통 Delete 버튼 (override)
- **소스라인**: cs 846-859
- **실제 발생 순서**:
  - ① 활성행 Action 컬럼이 'I'(신규)가 아니면 return (신규행만 삭제)
  - ② GetCellNumbersByRow 로 4배수 행 묶음 획득 후 역순 SetActiveCell+Delete
- **호출 메서드**: GetCellNumbersByRow, siMain.Delete
- **TO-BE 상태**: 신규(I) 행 그룹(measure 4행)만 삭제 허용

### 1.9 EditButton
- **트리거**: 공통 Edit 버튼 (override) — 편집모드 진입/해제
- **Division 분기**: ★40=편집금지(DM_UI_EDITABLE_DIVISION EDIT_YN=N→MSG00448); 필수컬럼 셋 40/81/82 상이; 82&NewFlag=Y 행별 세부 Lock; LOC만 Currency 편집
- **소스라인**: cs 861-1222
- **실제 발생 순서**:
  - ① !isCurVersion return; fps!=null 확인
  - ② dtDM_UI_EDITABLE_DIVISION=GetLookupValues('DM_UI_EDITABLE_DIVISION','DMF0020',division...) EDIT_YN=='N' → MSG00448 return (★40사업부 편집금지: 40은 DMF0082에서 편집)
  - ③ Division별 필수 컬럼 존재 검증: 40(END_CUSTOMER40/SCM_SITE/ITEM/INCOTERMS/FCST/DOM_EXP/CURRENCY), 81(SCM_SITE/PROJECT/ITEM/INCOTERMS/FCST/DOM_EXP/CURRENCY/PLANT_SITE), 82(PLANT_SITE 제외) 미충족 → MSG00113 return
  - ④ PRICE_EXIST 컬럼 없으면 MSG00412 return
  - ⑤ siMain.SwitchLock() 편집 토글, 주차/월 컬럼 과거분 LockColumn2 (이번주 월요일 기준)
  - ⑥ 행별 Lock: 82 & NewFlag=='Y' → 좌측 정보열 각각 Lock; else 전체 좌측 Lock. AUTHORITY_YN!='Y' 행은 데이터 영역 Lock, action=='I' 편집행은 W_ 컬럼만 unlock
  - ⑦ Measure 값에 KRW/USD/RTF 포함행은 값 전체 Lock, LOC행만 CURRENCY unlock+MergePolicy None
  - ⑧ 과거주차 Gainsboro/당월 White 배경
- **호출 메서드**: GetLookupValues, siMain.SwitchLock, siMain.LockColumn2, siMain.LockRange2, siMain.SetBGColor2
- **MSG**: MSG00448(현재 버전이 아닙니다.), MSG00113(필수 입력 컬럼이 없습니다.), MSG00412(Price Exist 컬럼 정보 누락.)
- **TO-BE 상태**: 편집토글 시 division별 필수컬럼 검증(MSG00113)+40 편집금지(MSG00448)+PRICE_EXIST(MSG00412). 과거주차 gray+lock, LOC만 currency 편집, measure RTF/KRW/USD 잠금

### 1.10 SaveButton / SaveData
- **트리거**: 공통 Save 버튼 (override)
- **Division 분기**: 40→키 END_CUSTOMER40, 81→PROJECT_CODE+PLANT_SITE, 82→PROJECT_CODE(plantsite 없음). RTF/RTF_SYS_RP measure 저장 제외
- **소스라인**: cs 1224-1228, 1538-1970
- **실제 발생 순서**:
  - ① blnWork → MSG00137; !IsLock(편집모드) 일 때만 진행
  - ② 필수 검증 루프(4배수 행): action=='I'(+NewFlag=Y→I) 행의 Division/Project(40=EndCustomer40,81/82=ProjectCode)/SalesSite/(81 PlantSite)/Model/Currency/Measure/DomExp/FcstType/Incoterms 공백 → MSG00002(필드명)
  - ③ fnValidation() 중복(동일 키 2건 이상) → MSG00043
  - ④ 저장 payload 조립: 변경(빨강 ForeColor) 셀만, M_ 컬럼 제외 W_ 날짜별, LOC&price=0→action 'D'. '^' 아닌 iCUD 인덱스로 CString.AppendStringEx 누적
  - ⑤ p_PRICE 없으면 MSG00414(정보 표출) return
  - ⑥ async DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL (CommandTimeout 90분). Tables[0][0]!='success'→에러박스; Tables[3] 메시지 표출
  - ⑦ MSG00004(저장건수). Tables[2](Range 초과) 있으면 DMF0020_SalesPriceRangePopUp 표출
  - ⑧ blnInsert면 FindData(true) else FindData(false, updateRow, col) 재조회
- **호출 메서드**: fnValidation, GetCellNumbersByRow, GetCellIndexBySpanRowCells, CString.AppendStringEx, FindData, DMF0020_SalesPriceRangePopUp.LoadData
- **MSG**: MSG00137(이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요.), MSG00002(성공적으로 저장되었습니다.), MSG00043(저장시 중복 오류가 발생하였습니다. {0}), MSG00414(Division 40 환경에서 Project 필수.), MSG00004(수정한 내용이 없습니다.)
- **TO-BE 상태**: SAVE SP(^구분 bulk, apiClient.post 직접). 변경셀만 payload, LOC 0=삭제. 필수/중복/무가격 검증. Range 초과 팝업

### 1.11 ExcelButton
- **트리거**: 공통 Excel 버튼 (override)
- **소스라인**: cs 1231-1263
- **실제 발생 순서**:
  - ① SimpleExcelExportOption 구성(Merge None/Border All/ShowZero/소수3자리)
  - ② SimplexelService.ExportFpSpread(fps) 로 파일 저장
  - ③ finally MessageService.CloseProgress
- **호출 메서드**: SimplexelService.ExportFpSpread
- **TO-BE 상태**: 그리드 → Excel 다운로드(서버 없이 클라이언트 export)

### 1.12 clbDivisions_SelectedIndexChanged
- **트리거**: Division 콤보 변경
- **Division 분기**: 핵심 cascade 재구성. 81앞2자리/82 vs 40/기타로 필드 enable/콤보소스/Excel버튼 분기
- **소스라인**: cs 2465-2601
- **실제 발생 순서**:
  - ① blnWork return; FP_Log2 start
  - ② UserTeamByDivision → clbTeam 재바인딩
  - ③ Division 분기: (81앞2자리||82) → EndCustomerByDivision+BizType, lblProject/layoutControlItem6 enable, 81이면 PlantSiteByEndCustomer, 82이면 checkInvalidExec.Enabled=true+plantSite disable/clear; else → EndCustomer/BizType, project/plantSite disable, checkInvalidExec disable, plantSite clear
  - ④ lblBizType.Enabled=true, UserSiteByEndCustomer → clbSalesSite
  - ⑤ txtOwner/umltProject/umltModel clear, InitSpread(true) 헤더 재구성
  - ⑥ division 81앞2자리 → Excel/Template 버튼+layoutControlItem12/29 노출 else 숨김
- **호출 메서드**: SetChangeControl, clsCtrl.setListBox, GetBizTypebyDivision, InitSpread
- **TO-BE 상태**: division onChange → 하위 콤보 전량 재fetch + 필드 enable/disable + Excel버튼 노출 + 그리드 헤더 재빌드

### 1.13 clbTeam_SelectedIndexChanged
- **트리거**: Team 콤보 변경
- **Division 분기**: 81앞2자리/82 vs 기타 (동일 SP, 분기 형태만)
- **소스라인**: cs 3655-3680
- **실제 발생 순서**:
  - ① division 81앞2자리/82 → EndCustomerByDivision(division,team); else EndCustomerByDivision(division,team)
  - ② clbEndCustomer 재바인딩
  - ③ UserSiteByEndCustomer → clbSalesSite
- **호출 메서드**: SetChangeControl, clsCtrl.setListBox
- **TO-BE 상태**: team onChange → endCustomer → salesSite cascade

### 1.14 clbEndCustomer_SelectedIndexChanged
- **트리거**: End Customer 콤보 변경
- **소스라인**: cs 3539-3545
- **실제 발생 순서**:
  - ① SetChangeControl('UserSiteByEndCustomer', division, '', endCustomer)
  - ② clbSalesSite 재바인딩
- **호출 메서드**: SetChangeControl, clsCtrl.setListBox
- **TO-BE 상태**: endCustomer onChange → salesSite cascade

### 1.15 spdMain_ComboSelChange
- **트리거**: 그리드 콤보 셀 선택 변경 (FpSpread.ComboSelChange)
- **Division 분기**: 그리드 셀 division 값 기준 81/82(END_CUSTOMER Auth) vs 40(END_CUSTOMER40 Common) 콤보 소스 분기; 81 아니면 PlantSite lock
- **소스라인**: cs 2603-2904
- **실제 발생 순서**:
  - ① !IsLock(편집모드)에서만 동작
  - ② DIVISION_ID 변경 → DEPT_ID(UserTeamByDivision)/END_CUSTOMER(81/82 Auth)|END_CUSTOMER40(40 Common)/SCM_SITE_ID(UserSiteByEndCustomerAuth)/PLANT_SITE 콤보 재세팅+SetCellRangeAligement, 81 아니면 PlantSite Lock, 하위 셀 텍스트 clear
  - ③ DEPT_ID 변경 → EndCustomer/SalesSite 재세팅+하위 clear
  - ④ END_CUSTOMER 변경 → SalesSite 재세팅+하위 clear
  - ⑤ SCM_SITE_ID 변경 → Project/Item 하위 clear
  - ⑥ END_CUSTOMER40 변경 → SalesSite 재세팅
  - ⑦ INCOTERMS/FcstType/DomExp/CURRENCY 빈값 → sTempRow 값으로 auto-sync (다른 measure행 클릭 시 대표행 값 복사)
  - ⑧ CURRENCY 변경(action!='I') → 4배수 행 전체 Currency 재세팅+빨강, 과거주차 이후 컬럼 GetExchangeRate 재계산(dtFuturePrice), M_ 월합계면 하위 주차 SetExchangeValues
- **호출 메서드**: Data.UserTeamByDivision, Data.UserEndCustomerByDivisionDeptAuth, Data.Common(EndCustomerByDivision40), Data.UserSiteByEndCustomerAuth, SetCellTypeCombo, CUIControl.SetCellRangeAligement, GetExchangeRate, SetExchangeValues
- **TO-BE 상태**: 그리드 셀 cascade(beginningEdit dataMap 스왑+cellEditEnded 원복). currency 변경 시 환율 재계산 자동동기(hook #59 표준)

### 1.16 spdMain_CellClick
- **트리거**: 그리드 셀 클릭 (FpSpread.CellClick)
- **Division 분기**: 81 → PlantSite 콤보 갱신; 82 → Incoterms/FcstType/DomExp 4행 세로병합
- **소스라인**: cs 3684-3751
- **실제 발생 순서**:
  - ① CURRENCY 셀 & action!='I'(기존행) → MSG00447(기간 확인 경고)
  - ② Raw_CellClick: !IsLock에서 PLANT_SITE 셀 or division 81 → PlantSiteByItem 콤보 세팅
  - ③ INCOTERMS=GetLookupValues('INCOTERMS','ALL','Y') 유효코드 콤보; sTempRow 저장
  - ④ division 82 & INCOTERMS/FcstType/DomExp 셀 → SetRowSpanFucTwo 로 4행(+3) 세로 병합
- **호출 메서드**: Raw_CellClick, Data.Common(PlantSiteByItem), GetLookupValues, SetRowSpanFucTwo
- **MSG**: MSG00447(Currency 가 비어 있습니다.)
- **TO-BE 상태**: currency 기존행 클릭 경고. 82 대표속성 세로 merge. plantSite 동적 콤보

### 1.17 spdMain_CellDoubleClick
- **트리거**: 그리드 셀 더블클릭 (FpSpread.CellDoubleClick)
- **Division 분기**: 40 → EndCustomer40 사용; 기타 → Project/EndCustomer 사용
- **소스라인**: cs 3211-3345
- **실제 발생 순서**:
  - ① 데이터셀 & !IsLock & action=='I'(신규행)만: Project/ProjectName 셀 → SCM0002_ProjectbyDivisionPopupEx 팝업 → ProjectCode/Name/Status/BizType 세팅+하위 clear; Item 셀 → DM0002_ItembyDivisionPopupEx → ItemID/Class/Name+currency(4행 sync)
  - ② 컬럼헤더 더블클릭: M_ 헤더 → 해당 월 W_ 컬럼 visible 토글(확장/축소), W_ 헤더 → D_ 컬럼 토글
- **호출 메서드**: SCM0002_ProjectbyDivisionPopupEx, DM0002_ItembyDivisionPopupEx, SetTextCellsToRowSpanRange
- **TO-BE 상태**: 신규행 Project/Item 팝업 셀(dblClick+CRUD guard). 헤더 더블클릭 = 월→주차 drill 확장

### 1.18 Dsdm_Changed
- **트리거**: DefaultSheetDataModel.Changed (셀 값 변경 데이터모델 이벤트)
- **Division 분기**: 81 → Project/Item 변경 시 PlantSite 동적 콤보
- **소스라인**: cs 2973-3103
- **실제 발생 순서**:
  - ① IsLock(조회모드) return; e.Row/Col<0 or IsLockCell return
  - ② CellsUpdated & Measure 우측(가격) 컬럼: 대표행 Currency 없으면 값 clear; 값 입력 시 빨강+4행 GetExchangeRate 환율계산(RTF_SYS_RP 제외), action 'M' 세팅
  - ③ M_ 월합계 입력 시 같은 월 주차 컬럼에 SetExchangeValues 분배
  - ④ division 81 & PROJECT_CODE/ITEM_ID 변경 → PlantSite(SalesPlant) 콤보 재세팅
- **호출 메서드**: GetCellIndexBySpanRowCells, GetExchangeRate, SetExchangeValues, Data.Common(SalesPlant), SetCellTypeCombo, CUIControl.SetActionFlagEx
- **TO-BE 상태**: 가격셀 편집 시 measure별 환율 자동계산(LOC 기준)+월합계→주차 분배+빨강마킹+action M

### 1.19 spdMain_TopChange
- **트리거**: 그리드 세로 스크롤 (FpSpread.TopChange)
- **소스라인**: cs 3347-3352
- **실제 발생 순서**:
  - ① CanModelChange=false
  - ② SmartColMerge() 재병합
  - ③ CanModelChange=true
- **호출 메서드**: SmartColMerge
- **TO-BE 상태**: 세로 merge viewport sticky 재계산(hook #38)

### 1.20 spdMain_KeyUp
- **트리거**: 그리드 키업 (Ctrl+C / Ctrl+V)
- **소스라인**: cs 3753-3769
- **실제 발생 순서**:
  - ① Measure 좌측 컬럼이면 return
  - ② Ctrl+V → ClipboardPaste(AsStringSkipHidden)
  - ③ Ctrl+C → Clipboard.Clear + ClipboardCopy(AsStringSkipHidden)
- **TO-BE 상태**: 가격영역 클립보드 복사/붙여넣기(숨김열 skip)

### 1.21 usrButton1_Click (Project 찾기)
- **트리거**: Project 조회버튼 클릭 / umltProject Enter
- **Division 분기**: 40 이면 Project 팝업 미동작(40은 EndCustomer 사용)
- **소스라인**: cs 2423-2440, 474-480
- **실제 발생 순서**:
  - ① division!='40'일 때만 SCM0002_ProjectbyDivisionPopupEx 팝업(division/team/endCustomer/scmSite/project)
  - ② umltProject.Text=선택 ProjectCode
- **호출 메서드**: SCM0002_ProjectbyDivisionPopupEx.Form_Load
- **TO-BE 상태**: Project 검색 모달(division!=40). 조회조건 팝업 셀

### 1.22 btnModelType_Click (Model 찾기)
- **트리거**: Model 조회버튼(btnItemId) 클릭 / umltModel Enter
- **소스라인**: cs 2442-2463, 482-488
- **실제 발생 순서**:
  - ① DM0002_ItembyDivisionPopupEx 팝업(division/team/endCustomer/scmSite/project/item)
  - ② umltModel.Text=선택 ItemID
- **호출 메서드**: DM0002_ItembyDivisionPopupEx.Form_Load
- **TO-BE 상태**: Model/Item 검색 모달

### 1.23 btnOwner_Click
- **트리거**: Owner 조회버튼 클릭
- **소스라인**: cs 3771-3790
- **실제 발생 순서**:
  - ① DM0020_OwnerbyDivisionPopup 팝업(division/team/endCustomer/scmSite/project/item/owner)
  - ② txtOwner.Text=선택 OwnerID
- **호출 메서드**: DM0020_OwnerbyDivisionPopup.Form_Load
- **TO-BE 상태**: Owner 검색 모달

### 1.24 btnColumn_Click (Column Setting)
- **트리거**: Column 표시설정 버튼 클릭
- **Division 분기**: division 파라미터 전달(사업부별 컬럼셋)
- **소스라인**: cs 3792-3802
- **실제 발생 순서**:
  - ① DM0002_TitleSetForm_Popup('DMF0020', 'Sales Price', true, division) 팝업
  - ② DialogResult.OK → InitSpread(true) 헤더 재구성
- **호출 메서드**: DM0002_TitleSetForm_Popup, InitSpread
- **TO-BE 상태**: Column Setting Popup(공용 ColumnSettingModal, DMF0002_GET_TITLESET_POPUP) → 저장 시 헤더 재빌드

### 1.25 btnExchangeRate_Click
- **트리거**: Exchange Rate 버튼 클릭
- **소스라인**: cs 2395-2421
- **실제 발생 순서**:
  - ① !IsLock(편집모드) 아니면 MSG00142 return
  - ② DMF0020_SalesFuturePricePopUp(yyyyMM, +1년) 팝업
  - ③ OK면 dtFuturePrice 재로드 + FindData(true)
- **호출 메서드**: DMF0020_SalesFuturePricePopUp.LoadData, GetFuturePriceInfo, FindData
- **MSG**: MSG00142(환율 정보가 잠겨있어 변경할 수 없습니다.)
- **TO-BE 상태**: 편집모드에서만 환율 팝업 → 저장 후 재조회

### 1.26 btnSavePricePeriod_Click (Price 일괄입력)
- **트리거**: Price일괄입력 버튼 클릭
- **Division 분기**: endCustomer=CString.GetCheckedListValue 전달
- **소스라인**: cs 2360-2393
- **실제 발생 순서**:
  - ① !IsLock(편집모드) 아니면 MSG00408 return
  - ② DMF0020_SaveSalesFuturePrice_Popup.LoadData(division/기간/scmSite/project/endCustomer) 팝업 표출
- **호출 메서드**: DMF0020_SaveSalesFuturePrice_Popup.LoadData
- **MSG**: MSG00408(Price 일괄 입력 조건이 충족되지 않았습니다.)
- **TO-BE 상태**: 편집모드에서만 Price 일괄입력 팝업

### 1.27 btnSPVer_Click (Version)
- **트리거**: Version 조회버튼 클릭
- **Division 분기**: division 전달
- **소스라인**: cs 3895-3922
- **실제 발생 순서**:
  - ① DMF0073_VersionBySalesPricePopup.Form_Load(true,'SP',division,-3M~+3M) 팝업
  - ② 선택 버전 2개 초과 → MSG00255(읽기전용) return
  - ③ txtVersion.Text=선택 버전
- **호출 메서드**: DMF0073_VersionBySalesPricePopup.Form_Load, Data.MultiTimeZone
- **MSG**: MSG00255(버전은 최대 2개까지 선택할 수 있습니다.)
- **TO-BE 상태**: Version 선택 모달(SP 버전관리). 다중선택 시 읽기전용

### 1.28 btnBatch_Click (Batch Job)
- **트리거**: Batch Job 버튼 클릭 (ADMIN/DM ADMIN 권한만 노출)
- **Division 분기**: division '^' 구분 다중전달
- **소스라인**: cs 3458-3494 / Designer btnBatch.Visible=false 기본, 권한 시 layoutControlItem5 Always
- **실제 발생 순서**:
  - ① division ALL이면 실제코드 치환, ','→'^'
  - ② async DM.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(division,createdBy) 실행(3분)
  - ③ 결과 취합 → MSG00143(division, 결과메시지)
- **호출 메서드**: FoxAsyncProxy.ExecuteAsync
- **MSG**: MSG00143((AS-IS 문구, MSG_M 미등재) (MSG_M 미등재))
- **TO-BE 상태**: ADMIN 전용 Batch(Local KRW 매출계획 생성 SP) 실행

### 1.29 btnExcelUpload_Click
- **트리거**: Upload 버튼 클릭 (81사업부만 노출)
- **Division 분기**: 81사업부만 버튼 노출
- **소스라인**: cs 3935-3947
- **실제 발생 순서**:
  - ① ExcelUploadForm('DMF0020', sheetName, SaveExceptError=true) 팝업
  - ② MSG00265 Yes → FindData(true) 재조회
- **호출 메서드**: ExcelUploadForm
- **MSG**: MSG00265(Excel 업로드가 완료되었습니다. 재조회합니다.)
- **TO-BE 상태**: 81사업부 Excel 업로드 → 오류제외 저장 → 재조회

### 1.30 btnTemplate_Click (Excel Form)
- **트리거**: Excel Form 버튼 클릭 (81사업부만 노출)
- **Division 분기**: 81사업부만 노출
- **소스라인**: cs 3924-3933
- **실제 발생 순서**:
  - ① DMF0020_SalesPriceTemplatePopup(division) 팝업(템플릿+데이터 다운로드)
- **호출 메서드**: DMF0020_SalesPriceTemplatePopup
- **TO-BE 상태**: 81사업부 Excel 템플릿 다운로드 팝업

### 1.31 usrDiscard_CheckedChanged (Search over range)
- **트리거**: 'Search over range' 체크박스 변경
- **소스라인**: cs 3829-3834
- **실제 발생 순서**:
  - ① drpDateTime.Value1=이번주 월요일-7일, Value2=Value1+357일(52주)
- **TO-BE 상태**: over range 체크 시 기간 자동 52주 세팅(불일치 조회)

### 1.32 DMF0020_SalesFuturePrice_Resize
- **트리거**: 폼 리사이즈
- **소스라인**: cs 3530-3537
- **실제 발생 순서**:
  - ① panel1(progress) 보이면 화면 중앙 재배치
- **TO-BE 상태**: 진행 패널 중앙 정렬(ResizeObserver)

---

## 2. 버튼 (전수 16)

| 버튼 | hotkey | 연결 SP/팝업 | 활성/권한 | Division 규칙 | 줄 |
|---|---|---|---|---|---|
| Search(조회) | 공통 FindButton override | DM.DMF0020_GET_SCM_MST_FUTURE_PRICE (+GET_SPREAD_TITLE/TITLE_DATE) | version 필수/기간정합/division 필수 | division 파라미터 전달, Current 조회만 isCurVersion=true | cs 831-834,1270-1536 |
| Insert(신규) | 공통 InsertButton override | 클라이언트 행추가(measure 4행) | isCurVersion(Current 조회) 필수 | 40=EndCustomer40/CustomsHandbook, 81/82=Auth 콤보+PlantSite | cs 836-844,1983-2211 |
| Save(저장) | 공통 SaveButton override | DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL (90분) | 편집모드(!IsLock) | 키 구성 40=EndCustomer40 / 81=Project+PlantSite / 82=Project | cs 1224-1228,1538-1970 |
| Delete(삭제) | 공통 DeleteButton override | 클라이언트 행삭제 | 활성행 action=='I'(신규행)만 |  | cs 846-859 |
| Edit(편집토글) | 공통 EditButton override | DM.UP_FX_GetCommonDataList_DM(DM_UI_EDITABLE_DIVISION) | isCurVersion 필수 + 40 편집금지(MSG00448) + 필수컬럼(MSG00113) + PRICE_EXIST(MSG00412) | ★40=DMF0082에서 편집(여기 금지), 82&NewFlag=Y 세부 lock, LOC만 currency 편집 | cs 861-1222 |
| Excel(다운로드) | 공통 ExcelButton override | SimplexelService.ExportFpSpread | 상시 |  | cs 1231-1263 |
| Exchange Rate | 화면버튼 btnExchangeRate | DMF0020_SalesFuturePricePopUp | 편집모드(!IsLock) 아니면 MSG00142 |  | cs 2395-2421 / Designer 302-337 |
| Price일괄입력(btnSavePricePeriod) | 화면버튼 | DMF0020_SaveSalesFuturePrice_Popup | 편집모드 아니면 MSG00408 | 과거 82 전용였으나 현재 division/기간/site/project/endCustomer 전달 | cs 2360-2393 / Designer 908-944 |
| Version(btnSPVer) | 화면버튼 | DMF0073_VersionBySalesPricePopup | 상시; 2개 초과선택 MSG00255(읽기전용) | division 전달, -3M~+3M | cs 3895-3922 / Designer 980-1014 |
| Owner(btnOwner) | 화면버튼 | DM0020_OwnerbyDivisionPopup | 상시 |  | cs 3771-3790 / Designer 786-820 |
| Column Setting(btnColumn) | 화면버튼 | DM0002_TitleSetForm_Popup | 상시 | division 파라미터 | cs 3792-3802 / Designer 822-857 |
| Project 찾기(usrButton1) | 화면버튼 | SCM0002_ProjectbyDivisionPopupEx | division!='40' | 40은 미동작 | cs 2423-2440 / Designer 339-373 |
| Model 찾기(btnItemId) | 화면버튼 | DM0002_ItembyDivisionPopupEx | 상시 |  | cs 2442-2463 / Designer 409-443 |
| Batch Job(btnBatch) | 화면버튼(기본 Visible=false) | DM.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW | ADMIN/DM ADMIN 권한만 layoutControlItem5 노출 | division '^' 다중전달 | cs 3458-3494 / Designer 264-300 |
| Upload(btnExcelUpload) | 화면버튼 | ExcelUploadForm | 81사업부만 노출 | 81 전용 | cs 3935-3947 / Designer 1016-1057 |
| Excel Form(btnTemplate) | 화면버튼 | DMF0020_SalesPriceTemplatePopup | 81사업부만 노출 | 81 전용 | cs 3924-3933 / Designer 1059-1098 |

## 3. 조회조건 (전수 14)

| 조회조건 | 유형 | 데이터 원천 | Division 분기 | cascade | 줄 |
|---|---|---|---|---|---|
| Division(clbDivisions) | UsrCombo(DropDownList 단일) | SetChangeControl('MyDivision')=DataService.GetDMInnerTable(MyDivision) [CODE/NAME] | 핵심 트리거. 81앞2자리/82 vs 40/기타 분기 주도 | → Team/EndCustomer/BizType/SalesSite/PlantSite 전량 재구성 + 필드 enable + Excel버튼 | Designer 718-750 / cs 302-306,2465-2601 |
| Team(clbTeam) | UsrCheckedList(단일 One, ALL_VIEW) | SetChangeControl('UserTeamByDivision',division) |  | → EndCustomer → SalesSite | Designer 600-638 / cs 314-317,3655-3680 |
| End Customer(clbEndCustomer) | UsrCheckedList(단일 One, ALL_VIEW) | SetChangeControl('EndCustomerByDivision',division,team) — 81/82 Auth, 40 Common(EndCustomerByDivision40) | 81/82 vs 40 SP 소스 상이 | → SalesSite | Designer 560-598 / cs 324-353,3539-3545 |
| Sales Site(clbSalesSite) | UsrCheckedList(단일 One, ALL_VIEW, UserRvSearch) | SetChangeControl('UserSiteByEndCustomer',division,'',endCustomer) |  | leaf | Designer 487-524 / cs 381-382 |
| Plant Site(clbPlantSite) | UsrCheckedList(단일 One, ALL_VIEW) | SetChangeControl('UserPlantSiteByEndCustomer',division,'',endCustomer) | 81 포함 시에만 세팅/enable; 82는 disable+clear; 40/기타 disable | division/endCustomer 종속 | Designer 640-677 / cs 385-392,2508-2529 |
| Project(umltProject) | UsrMultiLineEditor + 찾기버튼(usrButton1) | SCM0002_ProjectbyDivisionPopupEx 팝업 | 40이면 disable/미동작(lblProject.Enabled) | Enter→팝업 | Designer 375-407 / cs 2423-2440 |
| Model/Nickname(umltModel) | UsrMultiLineEditor + 찾기버튼(btnItemId) | DM0002_ItembyDivisionPopupEx 팝업 |  | Enter→팝업 | Designer 526-558 / cs 2442-2463 |
| Biz.Type(clbBizType) | UsrCheckedList(단일 One, ALL_VIEW) | SetChangeControl('BizType',division) / GetBizTypebyDivision(SCM0001_GET_BIZ_TYPE_BY_DIVISION) | lblBizType 항상 Enabled=true | division 종속 | Designer 679-716 / cs 329-358 |
| Bucket(cboBucketType) | UsrCombo(DropDownList) Weekly/Monthly | GetBucketType(DM.DMF0003_GET_BUCKET_TYPE_CODE, 첫행제거) [CODE/NAME] |  | 변경 시 W_/M_ 컬럼 visible 스왑+편집유지 | Designer 859-894 / cs 408-410,558-572 |
| Owner(txtOwner + btnOwner) | UsrMultiLineEditor + 찾기버튼 | DM0020_OwnerbyDivisionPopup 팝업 |  | 팝업 | Designer 752-820 / cs 3771-3790 |
| Version(txtVersion + btnSPVer) | UsrMultiLineEditor(읽기) + 찾기버튼 | DMF0073_VersionBySalesPricePopup | division 전달 | 팝업 선택 | Designer 946-1014 / cs 415,3895-3922 |
| Period(drpDateTime) | UsrDateRangePicker (From:To) | GetDayRange(DM.PR_GET_DAY_RANGE, p_month=6) |  | over range 체크 시 자동 52주 | Designer 445-485 / cs 295-297,417-431 |
| Search over range(usrDiscard) | CheckEdit | 로컬(p_over_range Y/N) |  | 체크 시 기간 이번주월요일-7 ~ +357일 | Designer 896-906 / cs 1302,3829-3834 |
| Price 미등록 제외(checkInvalidExec) | CheckEdit (layoutControlItem10 기본 Never) | 로컬(p_invalid_exec Y/N) | ★division=='82'일 때만 Enabled=true, 그외 disable |  | Designer 253-262,1361-1369 / cs 339-346,2519-2527 |

## 4. Expression (전수 9)

### SUM 헤더 3단 병합(Large/Small/SUM) (줄 cs 597-678)
SetSpreadHeaderSpan: Measure 우측부터 LargeLabel/SmallLabel 변화 지점마다 ColumnHeaderSpan(0=Large,1=Small,2 SUM). B_ 접두 컬럼 VisibleColumns(false) 숨김. Measure+1 지점 Freeze + SmartColMerge

### 동적 주차 W_ 컬럼 생성+월 병합 (줄 cs 720-825)
SetSpreadColumn(dt)/InitSpread_X: DMF0020_GET_SPREAD_TITLE_DATE 로 AddNumColumn(주차별), M_ 접두는 'SUM' 텍스트. BASIS_YYYYMM 동일 구간 상단행 ColumnHeaderSpan 병합(년월)

### Bucket Visible 분기(W_/M_) (줄 cs 680-718)
SetSpreadColumn(): Weekly→W_ 컬럼 Visible=true/M_ 숨김, Monthly→M_ Visible=true/W_ 숨김+BackColor White

### 과거주차 Gray + 당월 White 배경 (줄 cs 1212-1216,1421-1446,2822-2825)
이번주 월요일(sYYYYMMDD) 기준 W_태그 < 오늘 → iResultCol; M_==당월 → iResultMonth. SetBGColor2(0,start,max,iResultCol,Gainsboro)+당월 White. FindData/EditButton/InsertRow 공통

### 범위초과 컬럼 Pink(ColList) (줄 cs 1476-1488)
행별 COL_LIST(','분리) 토큰 → siMain.GetColumnIndex → SetBGColor2 Pink (20% 초과 입력분 표시, PJ20200138)

### EditFlag(action) 자동 M/I 세팅 (줄 cs 3040-3042,1573-1578,1805)
가격셀 변경 시 ForeColor=Red 마킹 후 action 빈값이면 CUIControl.SetActionFlagEx 'M'. NewFlag=='Y'&&action=='M'이면 저장 시 'I'로 승격(신규). Save는 빨강셀+action I/M/D만 대상

### LockColumn/LockRange 편집 제어 (줄 cs 962-1210,1179-1197)
EditButton: 과거 W_/M_ 컬럼 LockColumn2, AUTHORITY_YN!='Y' 데이터영역 Lock, 82&NewFlag=Y 좌측정보 세부 Lock, measure(KRW/USD/RTF) 값 Lock, LOC만 CURRENCY unlock+MergePolicy None

### 환율 SetValue Auto-Sync(GetExchangeRate) (줄 cs 2851-2900,3021-3073,3105-3209)
가격 입력 시 대표행 Currency 기준 measure(KRW/USD/LOC)별 GetExchangeRate(dtFuturePrice EXCHANGE_PRICE 조회: 직접/역수1÷/KRW경유 USD환산)로 4행 자동계산+빨강. M_ 월합계 입력 시 SetExchangeValues로 하위 주차 분배

### 콤보 빈값 대표행 복사 + 82 세로병합 (줄 cs 2761-2777,2913-2922,3727-3738,3838-3875)
ComboSelChange: INCOTERMS/FcstType/DomExp/CURRENCY 빈값이면 sTempRow(대표행) 값 복사. CellClick: division=='82' & 해당 셀 → SetRowSpanFucTwo(4행+3 세로병합). SetTextCellsToRowSpanRange(FCST_TYPE는 코드만)

---

## 5. SP 제약 (소스 유래 전수 41행)

유형별: Division 8 · 편집제약 7 · 일자·캘린더 4 · Lookup 2 · NVL·기본값 3 · Bulk('^' split) 3 · 커서(OUT RC) 4 · 정렬(ORDER BY) 1 · 검증 8 · PK·중복(dedup) 1

### DMF0020_GET_SCM_MST_FUTURE_PRICE (PROCEDURE, 1194줄, 13건)
_역할: 메인/버전 그리드 조회. Division(40/81/82) 및 New-Model(ESS) 분기로 SalesPlan·FuturePrice 를 GTT에 적재 후 PIVOT 조회. 편집권한(EDIT_YN)은 SP가 아니라 메타 뷰에서 산출. OUT 2커서(O_RC1 헤더/타이틀 + O_RESULT_CURSOR 본문)._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | MSG | 줄 |
|---|---|---|---|---|---|
| Division | CASE WHEN P_DIVISION_ID='82' AND E.DM_RTF_YN='N' THEN VERSION_NO\|\|'('\|\|WEEK_NAME\|\|') (NO PLAN)' WHEN P_DIVISION_ID='82' THEN VERSION_NO\|\|'('\|\|WEEK_NAME\|\|')' (346-347,379-380,398-399,435-436) | 82(ESS)사업부는 버전명에 주차와 (NO PLAN) 표기를 붙여 구분한다 | SCM_SYS_CALENDAR_M, DM_PLN_SALES_PLAN |  | 346-347,379-380,398-399,435-436 |
| Division | IF P_DIVISION_ID='82' AND P_INVALID_EXEC='Z' THEN (GT_FTPR_DM_MST_ITEM_SINGLE_ORI_V 적재 = ESS New-Model 분기에서만 실행) | 82(ESS)사업부 신모델 실행(Z)일 때만 단품 원본 적재 — 성능상 유일 사용처로 이동(2026-07-03) | GT_FTPR_DM_MST_ITEM_SINGLE_ORI_V |  | 584,1008-1009 |
| Division | ITEM_TYPE = CASE WHEN T1.DIVISION_ID='82' THEN T2.ITEM_TYPE ELSE 'H' END OR ... ELSE 'P' END | 82사업부는 자체 ITEM_TYPE, 그 외 사업부는 H/P(모/자재)로 제한 |  |  | 1036-1037 |
| Division | CASE WHEN SI.DIVISION_ID='40' THEN '-' ELSE MPJT.PROJECT_NAME/STATUS/BIZ_TYPE END; IF P_DIVISION_ID<>'40' OR P_BIZTYPE='ALL' | 40(소형)사업부는 프로젝트가 없어 프로젝트명/상태/BizType 을 '-' 로 고정, PIVOT 키도 프로젝트 대신 END_CUSTOMER 사용 | SCM_MST_PROJECT |  | 587,699,701-702,735,738 |
| 편집제약 | 편집가능여부(EDIT_YN)는 이 GET SP 본문에 division 하드코딩 없음 — PKG 조회계열이 SCM_ADM_USER_MNU_EDIT_AUTH_V 조인으로 산출. 메인 GET은 AUTHORITY_YN 을 FN_GET_DEPT_LIST 로 계산 | 편집 가능 여부는 '사업부=82' 같은 코드가 아니라 사용자×메뉴×사업부 권한 메타로 결정된다 — FE의 division 하드코딩과 대비 필요 | SCM_ADM_USER_MNU_EDIT_AUTH_V/fn:FN_GET_DEPT_LIST |  | 677,746 |
| 편집제약 | AUTHORITY_YN = CASE WHEN (FN_GET_DEPT_LIST(P_CREATED_BY,PJT.DEPT_ID)='Y' OR V_GROUP_ID='ADMIN') THEN 'Y' ELSE 'N' END | 행 단위 편집/소유 권한은 로그인 사용자의 담당 부서목록 또는 ADMIN 그룹 여부로 결정 | /fn:FN_GET_DEPT_LIST |  | 677,746,1101 |
| 일자·캘린더 | JOIN SCM_SYS_CALENDAR_M D ON A.CUTOFF_YYYYMMDD=D.BASIS_YYYYMMDD (WEEK_NAME 부여); BASIS_YYYYMMDD BETWEEN TO_CHAR(SYSDATE,'YYYYMMDD') AND TO_CHAR(SYSDATE+52*7,'YYYYMMDD') | 조회 구간은 오늘부터 52주(1년) 앞까지, 주차명은 시스템 캘린더에서 가져온다 | SCM_SYS_CALENDAR_M |  | 366,416,452,934,943 |
| Lookup | LOOKUP_TYPE='GET_ADMIN_GROUP'(관리자 그룹 판정), LOOKUP_TYPE='SALES_PRICE_RANGE_RATE'(가격 허용편차율) | 관리자 그룹과 가격 허용편차율을 룩업 마스터에서 조회 | SCM_ADM_LOOKUP_MASTER_DETAIL |  | 187,560 |
| NVL·기본값 | NVL(...,'-') 로 PIVOT 그룹키 정규화 (END_CUSTOMER/BIZ_TYPE 등 27곳) | NULL 을 '-' 로 정규화해 PIVOT 행 분열(중복행)을 방지 — placeholder 표기차가 곧 행 분열 원인 |  |  | 735,738 외 27곳 |
| Bulk('^' split) | 멀티선택 파라미터를 REGEXP_SUBSTR('[^\^]+',1,LEVEL) CONNECT BY 로 분해 (18곳) | 조회조건 다중선택 값은 '^' 구분자로 넘어와 SP에서 토큰 분해 |  |  | REGEXP_SUBSTR 18곳 |
| 커서(OUT RC) | OPEN O_RC1 FOR (헤더/스프레드 타이틀) + OPEN O_RESULT_CURSOR FOR (본문). 이중 OUT 커서 | 타이틀(동적 컬럼)과 데이터 본문을 두 개의 OUT 커서로 반환 |  |  | 21-22 |
| 정렬(ORDER BY) | PIVOT 결과 ORDER BY 로 그리드 고정 정렬 (6곳) | 그리드 표시 순서를 SP에서 고정 |  |  | ORDER BY 6곳 |
| 검증 | EXCEPTION WHEN OTHERS THEN 로그적재 후 RAISE_APPLICATION_ERROR(-20001, '['\|\|PROGRAM\|\|'] SQLCODE=..SQLERRM=..BACKTRACE=..PARAMS=..') | 오류 시 표준 로그 적재 후 진단정보 포함 예외 재발생(공통 패턴) | (로그)/fn:PR_SCM_SYS_LOG_BATCH | -20001 [PROGRAM] SQLCODE/SQLERRM/BACKTRACE/PARAMS | 1188-1193 |

### DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL (PROCEDURE, 1028줄, 11건)
_역할: 메인 그리드 저장. '^' 일괄 파싱→GTT→ACTIVE_FLAG 기준 DELETE / DELETE+INSERT + 이력(_H). LOC 메저만 편집원천, 가격 허용편차 위반은 O_RC1 로 경고 반환(하드에러 아님)._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | MSG | 줄 |
|---|---|---|---|---|---|
| Bulk('^' split) | 16개 파라미터를 TRIM(REGEXP_SUBSTR(P_x,'[^\^]+',1,LEVEL)) CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID,...) IS NOT NULL 로 일괄 파싱해 GTT INSERT | 저장 데이터(여러 행)는 컬럼별 '^' 구분 문자열로 넘어와 SP가 한 번에 분해·적재 | GT_FCSV_RESULTS_MST |  | 143-160 |
| NVL·기본값 | V_ITEM_ID = REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_ITEM_ID_RAW),CHR(13),''),CHR(10),''),CHR(9),''),' ','') | ITEM_ID 에서 개행/탭/공백을 제거해 키 불일치·중복 방지 |  |  | 169-170 |
| 편집제약 | LOC 메저만 편집원천 — KRW/USD 입력값과 무관하게 ACTIVE_FLAG 를 LOC 기준으로 재설정(환율 0 로 KRW/USD가 0→D오판 방지) | 실제 편집 단위는 LOC 가격뿐이며 KRW/USD 는 파생 — LOC 기준으로 변경/삭제 판정 |  |  | 227-230 |
| 편집제약 | ACTIVE_FLAG='D' → 기존 데이터 DELETE만; <>'D' → 동일키 DELETE 후 INSERT (MERGE 대신 DELETE-INSERT, 2018/07/18 KHSONG) | 저장은 병합이 아니라 같은 키 삭제 후 재삽입 방식, D 플래그는 삭제만 | SCM_MST_FUTURE_PRICE |  | 62-63,687,718,737 |
| PK·중복(dedup) | DELETE FROM SCM_MST_FUTURE_PRICE S WHERE ...(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMMDD,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS 키) 후 INSERT | 저장 키(사업부·프로젝트·사이트·품목·일자·통화·메저·내수수출·예측유형·인코텀즈)로 기존행 제거 → 중복 방지 | SCM_MST_FUTURE_PRICE |  | 687,718,737 |
| 편집제약 | 이력 보관: V_ACTIVE_FLAG<>'D' 행을 SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL 와 함께 SCM_MST_FUTURE_PRICE_H INSERT | 삭제가 아닌 저장 건은 변경 이력 테이블(_H)에 시퀀스 부여해 보관 | SCM_MST_FUTURE_PRICE_H, SEQ1_SCM_MST_FUTURE_PRICE_H |  | 67,799,834-836 |
| 검증 | 가격편차 검증(O_RC1): MEASURE='LOC' AND (S.PRICE*L.RANGE_VAL) < ABS(S.PRICE - R.V_PRICE) 이고 YYYYMMDD IN (MIN,MAX주차) → 위반행을 O_RC1 로 반환 | 신규가격이 기존가격 대비 허용편차율(SALES_PRICE_RANGE_RATE)을 초과하면 위반목록을 경고 커서로 돌려줌(저장은 막지 않음) | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE | O_RC1 = Range Rate 위반 결과셋(경고) | 949-965 |
| 검증 | 편차검증 대상 제외: F.QTY<>0 AND F.FCST_TYPE NOT IN (LOOKUP_TYPE='SALES_TYPE_CODE' AND SEGMENT4='FREE') | 수량 0 이거나 무상제공(FREE) 예측유형은 가격편차 검증에서 제외 | SCM_ADM_LOOKUP_MASTER_DETAIL |  | 474-481,537-543 |
| 일자·캘린더 | 편차검증 구간: F.YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE,'IW')-7,'YYYYMMDD') (당주 월요일) AND < TRUNC(SYSDATE,'IW')-7+7*52 (52주후) | 검증/저장 대상 구간은 이번 주 월요일부터 52주 뒤까지 — 과거 주차는 대상 밖 |  |  | 470,533-534 |
| 커서(OUT RC) | O_RC1(Range Rate 위반)와 O_RESULT_CURSOR(작업결과) 이중 OUT. 위반 없을 땐 OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1=2 (빈 커서) | 항상 두 커서를 열되 위반 없으면 빈 커서 반환 — FE 이중커서 소비 필요 |  |  | 20-21,213-214,273-274 |
| 검증 | EXCEPTION WHEN OTHERS THEN 로그 후 RAISE_APPLICATION_ERROR(-20001,...) (delete_count/insert_count 도 END 로그에 기록) | 실패 시 표준 예외, 성공 시 삭제/삽입 건수를 로그에 남김 | /fn:PR_SCM_SYS_LOG_BATCH | -20001 표준 진단 메시지 | 1023,967-973 |

### DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP (PROCEDURE, 795줄, 6건)
_역할: PriceBatch(일괄입력) 팝업 저장. GTT(#results_MST) 적재 후 Project/Item/Site-Item 유효성을 e_invalid_data 커스텀 예외로 하드 검증, 통화(LOC/KRW/USD) split insert. OUT 단일 결과커서._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | MSG | 줄 |
|---|---|---|---|---|---|
| 검증 | IF v_DIVISION_ID<>'40' THEN: PROJECT_CODE 가 SCM_MST_PROJECT 에 없으면 'Invalid Project Code !' → RAISE e_invalid_data | 40(소형) 외 사업부에서 존재하지 않는 프로젝트코드로 저장 시 하드 에러(저장 차단) | SCM_MST_PROJECT, GT_DMF0020_RESULTS_MST | [PROJECT_CODE] Invalid Project Code ! | 478-488 |
| 검증 | ITEM_ID 가 SCM_MST_ITEM_SN 에 없으면 'Invalid Item ID !' → RAISE e_invalid_data | 등록되지 않은 품목ID 로 저장 시 하드 에러 | SCM_MST_ITEM_SN | [ITEM_ID] Invalid Item ID ! | 491-499 |
| 검증 | v_division_id IN ('81','40') 인 경우: scm_mst_site_item×DM_MST_ITEM_SINGLE_V 조합(ACTIVE_FLAG='Y',VALID_YN='Y')에 없는 site-item 이면 'Invalid Site Item ID !' → RAISE e_invalid_data | 자동차(81)·소형(40) 사업부는 사이트-품목 유효 조합까지 확인, 불일치 시 하드 에러 | SCM_MST_SITE_ITEM, DM_MST_ITEM_SINGLE_V | [ITEM_ID] Invalid Site Item ID ! | 505-541 |
| Division | 통화 split insert: v_CURRENCY<>'USD' / v_division_id IN('81','40') 조건별로 #results_MST → 실테이블 분기 insert | 통화·사업부별로 결과행을 분기해 저장(LOC/KRW/USD 3원천 처리) | GT_DMF0020_RESULTS_MST |  | 470,507,527-529 |
| 커서(OUT RC) | OUT p_result_cursor 단일. e_invalid_data 발생 시 v_log_type='INVALID' 결과를 커서로 반환 | 검증 실패도 예외 대신 결과커서 메시지로 FE에 전달(단일 커서) |  |  | 20 |
| 일자·캘린더 | SYSDATE 기반 CREATION/UPDATE 일자 세팅 (10곳) | 생성/수정 일시를 SYSDATE 로 기록 |  |  | SYSDATE 10곳 |

### PKG_DMF0020 (PACKAGE BODY, 주요 5멤버) (PACKAGE BODY, 4609줄, 11건)
_역할: 화면 부가기능 패키지. 조회(FuturePriceInfo/PriceTemplate/PricePopup/OwnerData/WeekData)·저장(ExchangeRate/PriceConversion)·엑셀업로드 등 16멤버. 편집권한(EDIT_YN)·동적컬럼(VISIBLE_FLAG)의 메타 기반 산출이 핵심._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | MSG | 줄 |
|---|---|---|---|---|---|
| 편집제약 | [GET_FUTUREPRICE_INFO / GET_SALES_PRICE_TEMPLATE / GET_SCM_MST_FUTURE_PRICE_POPUP 공통] INNER JOIN (SELECT * FROM SCM_ADM_USER_MNU_EDIT_AUTH_V WHERE USER_ID=P_USER_ID AND MNU_ID=P_MNU_ID AND UNIT_TP_CD='D') T2 ON DIVISION_ID=T2.UNIT_ID → NVL(T2.EDIT_YN,'N') AS EDIT_YN | 편집가능여부는 사용자×메뉴×사업부 권한메타(EDIT_AUTH_V)로 결정 — SP에 '82=편집' 같은 하드코딩 없음. FE가 division='82' 로 편집 판정하면 SP 권한모델과 불일치 | SCM_ADM_USER_MNU_EDIT_AUTH_V |  | 422-424,2736-2745,2986-2989,3015-3019,3135-3137,3163-3165,3847-3876 |
| Division | 동적 컬럼 노출: CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END (SALES_PRICE_TEMPLATE) | 컬럼의 DIVISION_ID 토큰에 현재 사업부가 포함될 때만 해당 컬럼을 노출(동적 컬럼 표시) | /fn:FN_GET_DIVISION_YN |  | 2431 (2325,3317,3417 주석) |
| Division | [GET_OWNER_DATA] IF P_DIVISION_ID='40' OR '82' THEN Owner=해당 사업부 SITE_ITEM.OWNER 만; IF P_DIVISION_ID LIKE '81%' THEN 사업부 Owner UNION ALL PM_TEAM_MAPPING 룩업(SEGMENT3=DEPT)→SEGMENT1 DEPT | 40/82 사업부는 자기 사업부 담당자만, 81%(자동차)는 담당자 + PM팀매핑 부서까지 확장해 소유자 목록 구성 | SCM_MST_SITE_ITEM, SCM_MST_SSO_USER_INFO, SCM_MST_SSO_DEPT_INFO, SCM_ADM_LOOKUP_MASTER_DETAIL |  | 3799-3838 |
| 일자·캘린더 | [GET_SALES_PRICE_TEMPLATE] 현재/미래: SP.YYYYMMDD BETWEEN FN_NEXT_DAY(T_VER.YYYYMMDD,'MON')-7 AND +52주-1 ; 과거: SP.YYYYMMDD < FN_NEXT_DAY(..,'MON')-7 | 버전기준일의 '차주 월요일-7일'(=당주 월요일)을 컷오프로 과거/현재를 분리하고 현재는 52주만 노출 — 과거 주차 잠금의 SP 근거 | /fn:FN_NEXT_DAY |  | 2798-2799,2874 |
| Lookup | 참조 LOOKUP_TYPE: FUTUREMEASURE(메저목록), DMF0020_CURRENCY(통화), GET_ADMIN_GROUP(관리자그룹), DM_OWNER_DEPT(소유부서), PM_TEAM_MAPPING(자동차 PM팀), SALES_PRICE_RANGE_RATE(가격편차율) | 메저·통화·관리자그룹·소유부서·PM팀·가격편차율을 모두 룩업 마스터에서 조회(하드코딩 아님) | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SHEET_MEASURE |  | 67,74,195,201,3003,3038,3151,3183,3769,3777,3784,3826 |
| Bulk('^' split) | [SAVE_DM_MST_EXCHANGE_RATE_ALL] REGEXP_COUNT(P_DIVISION_ID,'\^')+1 행수, TRUNCATE GT_F020_EXCHANGE_RATE 후 REGEXP_SUBSTR('[^\^]+',1,LEVEL) 8컬럼 일괄 INSERT | 환율 일괄저장도 '^' 구분 문자열을 토큰 분해해 GTT 적재 | GT_F020_EXCHANGE_RATE |  | 4112-4125 |
| 편집제약 | [SAVE_DM_MST_EXCHANGE_RATE_ALL] DELETE FROM DM_MST_EXCHANGE_RATE WHERE ...(R.ACTIVE_FLAG='D')... 후 재적재 (DELETE-INSERT) | 환율 저장도 ACTIVE_FLAG='D' 삭제 + DELETE-INSERT 패턴 | DM_MST_EXCHANGE_RATE |  | 4174-4178 |
| Division | [SAVE_SCM_MST_FUTURE_PRICE_CONVERSION] MEASURE='LOC' 원천을 통화변환: CASE WHEN CURRENCY='KRW' THEN 'KRW' WHEN 'USD' THEN 'USD' ELSE 'KRW'; PRICE=...ELSE PRICE*NVL(B.EXCHANGE_PRICE,1); WHERE DIVISION_ID=P_DIVISION_ID | LOC 가격을 환율로 KRW/USD 로 환산해 파생통화 행 생성(환율 없으면 1배). 사업부 단위 실행 | GT_F020_FUTURE_PRICE_TEMP2, DM_MST_EXCHANGE_RATE |  | 4353-4385 |
| 검증 | 각 멤버 EXCEPTION WHEN OTHERS THEN 로그 후 RAISE_APPLICATION_ERROR(-20001,...) (17곳) | 모든 멤버 공통 표준 예외 처리 | /fn:PR_SCM_SYS_LOG_BATCH | -20001 표준 진단 | 17곳(109,252,362,474,...4598) |
| NVL·기본값 | NVL(T2.EDIT_YN,'N'), NVL(EXCHANGE_PRICE,1) 등 106곳 NVL 로 기본값/NULL 방어 | 권한·환율·수치 NULL 을 기본값으로 방어 |  |  | NVL 106곳 |
| 커서(OUT RC) | 조회 멤버 O_RC1(타이틀)+O_RESULT_CURSOR(본문) 이중, 변환/저장 멤버 O_RESULT_CURSOR 단일 (SYS_REFCURSOR 66곳) | 조회는 타이틀+본문 이중커서, 저장/변환은 단일 결과커서 |  |  | 381-382,2637-2638,2947,4291 |

### Function / 호출 PROC

| Function | 호출 SP | 용도 |
|---|---|---|
| FN_GET_DIVISION_YN | P_DMF0020_GET_SALES_PRICE_TEMPLATE, P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP(주석) | 컬럼의 DIVISION_ID 토큰 목록에 현재 사업부 포함 여부(Y/N) — 동적 컬럼 VISIBLE_FLAG 판정 |
| FN_NEXT_DAY | P_DMF0020_GET_SALES_PRICE_TEMPLATE, P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION | 기준일 이후 특정 요일(주로 'MON') 반환 — 주차 컷오프(당주 월요일) 계산, 과거/현재 주차 분리 |
| FN_GET_DEPT_LIST | DMF0020_GET_SCM_MST_FUTURE_PRICE | 로그인 사용자의 담당 부서목록 포함 여부(Y/N) — 행 단위 AUTHORITY_YN(편집/소유권) 판정 |
| FN_GET_MULTI_OWNER_NAME | DMF0020_GET_SCM_MST_FUTURE_PRICE | 복수 소유자(OWNER)를 구분자로 결합/추출 — Owner 필터 매칭(LIKE) |
| PR_SCM_SYS_LOG_BATCH | ALL(80회) | 공통 배치 로그 적재(START/END/ERROR) |
| PR_TMPOUTPUT/PR_TMPOUTPUTALL/PR_TMPDATA/PR_TMPITEM/PR_TMPPLANDATA/PR_TMPSALESSITEMODEL(ALL)/PR_TMPOVERRANGE(LIST)/PR_TMPOUTPUTOMISSION | P_DMF0020_EXCEL_UPLOAD 등 | 엑셀업로드·조회 중간 GTT 적재/가공 헬퍼 프로시저(임시 결과 단계별 생성) |
| PR_SCM_MST_FUTURE_PRICE / PR_SCM_MST_FUTURE_PRICE_OVER / PR_DM_PLN_SALES_PLAN / PR_DM_MST_ITEM_SINGLE_ORI_V | GET/SAVE 계열 | 본 테이블·계획·단품원본 GTT 적재 및 편차초과(OVER) 목록 생성 헬퍼 |
| PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(_SINGLE) / PR_DM_ANL_SALES_PRICE_HIST / PR_DETAIL_AUTO | 저장·후처리 | 판매금액(LOCAL/KRW) 재생성·가격 이력·상세 자동생성 연계 프로시저 |

---

## 6. Validation 전수 (96 = main 72 + popup 24)

### 메인 (72)

| No | MSG ID | 카테고리 | 발생 조건 | MSG 문구 | Division | 줄 |
|---|---|---|---|---|---|---|
| 1 |  | 사업부분기 | clbDivisions.ControlValues.Substring(0,2)=="81" → 엑셀 업/다운로드 버튼 표시 |  | 81 | 203 |
| 2 |  | 사업부분기 | (sDivision.Substring(0,2)=="81")\|\|(sDivision=="82") → Project/PlantSite/BizType Enable |  | 81|82 | 320 |
| 3 |  | 사업부분기 | sDivision=="82" → checkInvalidExec Enable |  | 82 | 339 |
| 4 |  | 사업부분기 | sDivision.IndexOf("81")!=-1 → PlantSite by EndCustomer 로드 |  | 81 | 385 |
| 5 |  | Grid입력 | Enter 키 → usrButton1_Click(Project 조회) |  |  | 474 |
| 6 |  | Grid입력 | Enter 키 → btnModelType_Click(Model 조회) |  |  | 482 |
| 7 | MSG00448 | 편집제약 | DM_UI_EDITABLE_DIVISION.EDIT_YN=='N' (40사업부는 DMF0082에서 편집) → 편집 차단 | 현재 버전이 아닙니다. | 40 | 876 |
| 8 |  | 사업부분기 | clbDivisions.ControlValues=="40" 분기 |  | 40 | 881 |
| 9 | MSG00113 | 필수값 | 40: 필수컬럼(END_CUSTOMER40/SCM_SITE_ID/ITEM_ID/INCOTERMS/FCST_TYPE/DOM_EXP/CURRENCY) 미존재 → 복사 데이터 선택 | 필수 입력 컬럼이 없습니다. | 40 | 892 |
| 10 |  | 사업부분기 | clbDivisions.ControlValues.Substring(0,2)=="81" 분기 |  | 81 | 911 |
| 11 | MSG00113 | 필수값 | 81: 필수컬럼(SCM_SITE_ID/PROJECT_CODE/ITEM_ID/INCOTERMS/FCST_TYPE/DOM_EXP/CURRENCY/PLANT_SITE_ID) 미존재 | 필수 입력 컬럼이 없습니다. | 81 | 923 |
| 12 |  | 사업부분기 | clbDivisions.ControlValues=="82" 분기 |  | 82 | 927 |
| 13 | MSG00113 | 필수값 | 82: 필수컬럼(SCM_SITE_ID/PROJECT_CODE/ITEM_ID/INCOTERMS/FCST_TYPE/DOM_EXP/CURRENCY) 미존재 | 필수 입력 컬럼이 없습니다. | 82 | 938 |
| 14 | MSG00412 | 필수값 | siMain.GetColumnIndex(PRICE_EXIST)<0 → [PRICE_EXIST] 필수 입력사항 | Price Exist 컬럼 정보 누락. |  | 952 |
| 15 |  | 사업부분기 | clbDivisions=="82" && NewFlag 행 편집 컬럼 잠금 분기 |  | 82 | 1031 |
| 16 |  | 사업부분기 | clbDivisions.SelectedValue=="40" 편집 잠금 분기 |  | 40 | 1112 |
| 17 |  | 편집제약 | sThisWeek!=sLastWeek → 과거주차(전주까지) 컬럼 편집 잠금 |  |  | 1149 |
| 18 | MSG00137 | 사전검증분기 | blnWork(연속 작업 중) → 필수 컬럼 입력하세요 | 이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요. |  | 1279 |
| 19 | MSG00283 | 버전선택 | txtVersion.Text.Trim()=="" → Version 선택 후 조회 | 버전을 선택하세요. |  | 1286 |
| 20 | MSG00108 | 날짜기간 | int.Parse(sPeriod[0])>int.Parse(sPeriod[1]) → 기간 역전 | 조회 기간이 잘못되었습니다 (시작일 > 종료일). |  | 1307 |
| 21 | MSG00097 | 사업부분기 | p_division_id=="" → Division 선택 | Division 을 선택하세요. |  | 1327 |
| 22 |  | 사전검증분기 | ds.Tables[0].Rows.Count<=0 → 조회 결과 없음 종료 |  |  | 1380 |
| 23 | MSG00137 | 사전검증분기 | blnWork(연속 작업 중) → 필수 컬럼 입력하세요 | 이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요. |  | 1551 |
| 24 | MSG00002 | 필수값 | 행별 필수컬럼(DomExp/FcstType/INCOTERMS/Currency/Measure/EndCustomer/Project 등) 빈값 → [{}] 필수 입력 | 성공적으로 저장되었습니다. | 40|81|82 | 1679 |
| 25 | MSG00043 | 중복체크 | fnValidation 실패(키 중복) 40 분기 → 저장시 중복 오류 | 저장시 중복 오류가 발생하였습니다. {0} | 40|81|82 | 1703 |
| 26 |  | 사업부분기 | sDivision=="40" 저장 파라미터 분기 |  | 40 | 1881 |
| 27 | MSG00414 | 사업부분기 | sDivision=="40" 관련 검증 (ScmSite/Project/Item) → 통보 | Division 40 환경에서 Project 필수. | 40 | 1890 |
| 28 |  | 기타 | MessageBox.Show(sErrMsg) SP 오류 메시지 직접 표시 |  |  | 1924 |
| 29 |  | 기타 | MessageBox.Show(ds.Tables[3][0][0]) SP 오류 표시 |  |  | 1929 |
| 30 | MSG00004 | 확인메시지 | ds.Tables[3].Rows[0][0]!="" → 저장 건수 통보 | 수정한 내용이 없습니다. |  | 1933 |
| 31 |  | 사업부분기 | sDivision=="40" 신규행 컬럼 세팅 분기 |  | 40 | 2007 |
| 32 |  | 사업부분기 | clbDivisions.SelectedValue=="40" 잠금 분기 |  | 40 | 2078 |
| 33 |  | 편집제약 | sThisWeek!=sLastWeek → 과거주차 편집 잠금 |  |  | 2163 |
| 34 |  | 사업부분기 | (Substring(0,2)=="81")\|\|(=="82") 키 구성 분기 |  | 81|82 | 2231 |
| 35 |  | 사업부분기 | Substring(0,2)=="81" 키 비교 분기 |  | 81 | 2261 |
| 36 |  | 사업부분기 | Substring(0,2)=="81" 키 비교 분기 |  | 81 | 2269 |
| 37 |  | 중복체크 | sDivision==행 DIVISION_ID 비교(중복 카운트) |  | 81 | 2271 |
| 38 |  | 사업부분기 | clbDivisions.ControlValues=="82" 키 구성 분기 |  | 82 | 2286 |
| 39 |  | 중복체크 | sDivision==행 DIVISION_ID 비교(중복 카운트) |  | 82 | 2288 |
| 40 |  | 중복체크 | sDivision==행 DIVISION_ID 비교(중복 카운트) |  |  | 2318 |
| 41 |  | 중복체크 | iValidation>1 → 동일 키 중복 존재 → false 반환 |  |  | 2333 |
| 42 | MSG00408 | 모드분기 | !siMain.IsLock(SheetName) (수정모드) → 수정모드에서는 입력 불가 | Price 일괄 입력 조건이 충족되지 않았습니다. |  | 2369 |
| 43 | MSG00142 | 모드분기 | !siMain.IsLock(SheetName) (수정모드) → 환율 팝업 호출 불가 통보 | 환율 정보가 잠겨있어 변경할 수 없습니다. |  | 2404 |
| 44 |  | 사업부분기 | clbDivisions.SelectedValue!="40" → Project 팝업 분기 |  | 40 | 2425 |
| 45 |  | 사업부분기 | (Substring(0,2)=="81")\|\|(=="82") 컨트롤 Enable 분기 |  | 81|82 | 2491 |
| 46 |  | 사업부분기 | sDivision.IndexOf("81")!=-1 PlantSite 분기 |  | 81 | 2508 |
| 47 |  | 사업부분기 | sDivision=="82" checkInvalidExec 분기 |  | 82 | 2519 |
| 48 |  | 사업부분기 | Substring(0,2)=="81" 분기 |  | 81 | 2579 |
| 49 |  | 사업부분기 | sDivision.Substring(0,2)!="81" 분기 |  | 81 | 2660 |
| 50 |  | 사업부분기 | (Substring(0,2)=="81")\|\|(=="82") 분기 |  | 81|82 | 2688 |
| 51 |  | 사전검증분기 | sCurrency=="" → 환율 계산 건너뜀 |  |  | 2834 |
| 52 |  | 사전검증분기 | e.Column<0\|\|e.Row<0 → 이벤트 무시 종료 |  |  | 2992 |
| 53 |  | 사전검증분기 | sCurrency=="" → 환율 재계산 건너뜀 |  |  | 3008 |
| 54 |  | 사업부분기 | sDivision.Substring(0,2)=="81" && 특정 컬럼 → 값 재계산 |  | 81 | 3080 |
| 55 |  | 사업부분기 | else if sDivision.Substring(0,2)=="81" && 컬럼 분기 |  | 81 | 3089 |
| 56 |  | 사전검증분기 | sCurrency=="" → 환산 건너뜀 |  |  | 3116 |
| 57 |  | 사전검증분기 | e.ColumnHeader==false → 헤더 아니면 종료 |  |  | 3213 |
| 58 |  | 사업부분기 | sDivision=="40" 팝업 분기 |  | 40 | 3237 |
| 59 |  | 사전검증분기 | siMain.ActiveSheet.Columns[iCol].Visible 확인 |  |  | 3325 |
| 60 | MSG00143 | 기타 | 일괄 처리 결과 통보(p_division_id, sRMsg) | (AS-IS 문구, MSG_M 미등재) (MSG_M 미등재) |  | 3493 |
| 61 |  | 사전검증분기 | dtStart.DayOfWeek==DayOfWeek.Monday 판정 |  |  | 3505 |
| 62 |  | 사업부분기 | (SelectedValue.Substring(0,2)=="81")\|\|(=="82") 분기 |  | 81|82 | 3661 |
| 63 | MSG00447 | 기타 | e.Column==CURRENCY && GetText 조건 → 통보 | Currency 가 비어 있습니다. |  | 3690 |
| 64 |  | 사전검증분기 | sender==null\|\|e==null → 종료 |  |  | 3693 |
| 65 |  | 사업부분기 | _Column==PLANT_SITE_ID \|\| sDivision.Substring(0,2)=="81" 편집 허용 분기 |  | 81 | 3707 |
| 66 |  | 사업부분기 | sDivision=="82" && _Column==INCOTERMS 편집 분기 |  | 82 | 3727 |
| 67 |  | 사업부분기 | sDivision=="82" && _Column==FcstType 편집 분기 |  | 82 | 3731 |
| 68 |  | 사업부분기 | sDivision=="82" && _Column==DomExp 편집 분기 |  | 82 | 3735 |
| 69 |  | 사업부분기 | sDivision=="82" && _Column==CURRENCY 편집 분기 |  | 82 | 3743 |
| 70 | MSG00227 | 버킷 | siMain.GetText(iRow,0)==FlagI (신규행) → 버킷 변경 불가 통보 | Insert 된 행이 있어 Bucket 을 변경할 수 없습니다. |  | 3823 |
| 71 | MSG00265 | 확인메시지 | 엑셀 업로드 후 재조회 확인(Yes→FindData) | Excel 업로드가 완료되었습니다. 재조회합니다. | 81 | 3943 |
| 72 | MSG00255 | 버전선택 | 선택 Version(sVersion.Split(',')).Length>2 → 읽기전용(2개 초과 조회 불가) [문서 validation.md 71목록 누락분] | 버전은 최대 2개까지 선택할 수 있습니다. |  | 3913 |

### 팝업 (24)

| No | MSG ID | 카테고리 | 발생 조건 | MSG 문구 | Division | 줄 |
|---|---|---|---|---|---|---|
| 1 | MSG00113 | 필수값 | 40: 필수컬럼(END_CUSTOMER40/SCM_SITE_ID/ITEM_ID/INCOTERMS/FCST_TYPE/DOM_EXP/CURRENCY) 미존재 | 필수 입력 컬럼이 없습니다. | 40 | 832 |
| 2 | MSG00113 | 필수값 | 81: 필수컬럼(+PROJECT_CODE/PLANT_SITE_ID) 미존재 | 필수 입력 컬럼이 없습니다. | 81 | 863 |
| 3 | MSG00113 | 필수값 | 82: 필수컬럼(SCM_SITE_ID/PROJECT_CODE/ITEM_ID/INCOTERMS/FCST_TYPE/DOM_EXP/CURRENCY) 미존재 | 필수 입력 컬럼이 없습니다. | 82 | 878 |
| 4 | MSG00137 | 사전검증분기 | blnWork(연속 작업 중) → 필수 컬럼 입력 | 이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요. |  | 1145 |
| 5 | MSG00108 | 날짜기간 | int.Parse(sPeriod[0])>int.Parse(sPeriod[1]) → 기간 역전 | 조회 기간이 잘못되었습니다 (시작일 > 종료일). |  | 1162 |
| 6 | MSG00409 | 편집제약 | 이번주 월요일(gMondayDate)>시작일(sStartDate) → 과거구간은 일괄입력 불가 (과거주차 잠금) | 이번 주 이전 구간은 일괄 입력할 수 없습니다 (AS-IS 문구, MSG_M 미등재) (MSG_M 미등재) |  | 1180 |
| 7 | MSG00330 | 날짜기간 | dateYmdF.DayOfWeek!=Monday \|\| dateYmdT.DayOfWeek!=Monday → 시작/종료가 월요일 아님 | From/To 는 월요일이어야 합니다 (AS-IS 문구, MSG_M 미등재) (MSG_M 미등재) |  | 1189 |
| 8 | MSG00097 | 사업부분기 | p_division_id=="" → Division 선택 | Division 을 선택하세요. |  | 1209 |
| 9 | MSG00137 | 사전검증분기 | blnWork(연속 작업 중) → 필수 컬럼 입력 | 이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요. |  | 1445 |
| 10 | MSG00133 | 편집제약 | isEdit==false (빨간색 변경 셀 없음) → 변경 내용 없음 | 변경된 셀이 없습니다 (AS-IS 문구, MSG_M 미등재) (MSG_M 미등재) |  | 1466 |
| 11 | MSG00002 | 필수값 | 행 필수컬럼(Division/EndCustomer\|ProjectCode/SalesSite/Model/Currency/Measure/CustomsHandbook/FCSTType/Incoterms) 빈값 → [{}] 필수 입력 | 성공적으로 저장되었습니다. | 40|81|82 | 1606 |
| 12 | MSG00043 | 중복체크 | fnValidation 실패(키 중복) → 저장시 중복 오류 | 저장시 중복 오류가 발생하였습니다. {0} | 40|81|82 | 1630 |
| 13 |  | 기타 | MessageBox.Show(sErrMsg) SP 오류 직접 표시 |  |  | 1861 |
| 14 | MSG00004 | 확인메시지 | 저장 건수(iCUD_Total) 통보 | 수정한 내용이 없습니다. |  | 1870 |
| 15 | MSG00109 | 편집제약 | this.fps!=null → 읽기전용(환율 화면 편집 불가) | 읽기전용 상태입니다. |  | 225 |
| 16 | MSG00096 | 권한 | NowGroupID not in (ADMIN/DM ADMIN) → 저장 권한 없음 | 권한이 없습니다. |  | 279 |
| 17 | MSG00002 | 필수값 | 신규행 DIVISION_ID/CURRENCY/UNIT_CURRENCY 빈값 → [{}] 필수 입력 | 성공적으로 저장되었습니다. |  | 385 |
| 18 | MSG00002 | 필수값 | 환율(EXCHANGE_PRICE) 전부 0/빈값 → [EXCHANGE_PRICE] 필수 입력 | 성공적으로 저장되었습니다. |  | 446 |
| 19 |  | 기타 | MessageBox.Show(sErrMsg) SP 오류(sResultMsg!=success) 표시 |  |  | 478 |
| 20 | MSG00004 | 확인메시지 | 저장 건수(iCUD_R) 통보 | 수정한 내용이 없습니다. |  | 484 |
| 21 | MSG00002 | 필수값 | 신규행 필수컬럼(EndCustomer/Project/SalesSite/Model/Incoterms/Currency/FCSTType/Measure/DomExp) 빈값 → [{}] 필수 입력 | 성공적으로 저장되었습니다. |  | 310 |
| 22 | MSG00002 | 필수값 | 가격(EXCHANGE_PRICE) 전부 0/빈값 → [EXCHANGE_PRICE] 필수 입력 | 성공적으로 저장되었습니다. |  | 421 |
| 23 |  | 기타 | MessageBox.Show(sErrMsg) SP 오류 표시 |  |  | 454 |
| 24 | MSG00004 | 확인메시지 | 저장 건수(iCUD_R) 통보 | 수정한 내용이 없습니다. |  | 459 |

---

## 각주 — 데이터 접근 (AS-IS ↔ TO-BE)

- AS-IS `DataService.GetDMInnerTable('MyDivision')` → TO-BE `useTabComboQueries({filters:['MyDivision']})`
- AS-IS `FoxDataClient` SP 호출 → TO-BE `useTabProcQuery`/`useProcMutation` (메타 API_M/PROC_M 경유)
- Bulk 저장: 16컬럼 `'^'` split(`REGEXP_SUBSTR '[^\^]+' CONNECT BY`) → TO-BE `apiClient.post` 직접 payload
- 편집권한: AS-IS `SCM_ADM_USER_MNU_EDIT_AUTH_V` EDIT_YN → TO-BE 화면 LOOKUP `DM_EDITABLE_DIVISION_ALLOW`(82) + 사용자권한 유지