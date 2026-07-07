# DMF0003 MKT Forecast — 상세 동작 명세 (개발 이관용)

> **원천**: AS-IS `GSCM.DM.Plan.UIL\DMF0003_MktFcst.cs` (5,920줄) + `Designer.cs` 전수 실측
> **데이터 접근**: 레거시 FoxData `DM.UP_FX_GetCommonDataList_DM`(CODE 셀렉터) / `Data.Common(Data.Type.X)` — TO-BE 대응 = `PKG_DMF0003` SP (시트 7·8)
> **범위**: 화면 이벤트/액션 30 전수 상세 (핸들러 + 호출메서드 본문 1-depth). MSG 코드 문구=사내 MSG_M, 우클릭 일부=하드코드 한글 리터럴.

> ⚠️ 이 문서는 개발자용 기술 상세본입니다. User 관점 가독본은 분석서(시트 5) 참조.

---

## 1. 이벤트 · 액션 상세 (30)

### ▣ 초기화

#### [1] Form_Load
- **트리거**: Form load  ·  **컨트롤/소스**: this.Load (wired in ctor L286)
- **소스라인**: `286(wire)/290-306(body); InitControls 408-530; CreateSpread 580-587; InitSpread 589-600; DefineProperty 532-578; InitSaveDataTable 725`  ·  **호출 메서드**: InitForm, InitControls, CreateSpread(AddSheet/GetSheetInfo/InitSpread), DefineProperty, InitSaveDataTable, SetChangeControl, Data.Common
- **데이터/SP**: DataService.GetDMInnerTable(codes: MyDivision/UserTeamByDivision/EndCustomerByDivision/BizType/UserSiteByEndCustomer/UserPlantSiteByEndCustomer/EdiSender) via FoxData 'DM.UP_FX_GetCommonDataList_DM'; Data.Common(Data.Type.MktFcstEditMeasure); GetBucketType/GetItemType/GetDayRange
- **Division 분기**: Division 81xx or 82 branch pre-loads edit Measure master
- **실제 동작 (실측)**:

    ① clsCtrl = new CControl(this) 로 공통 컨트롤 헬퍼 생성
    ② InitForm() (BaseForm 초기화)
    ③ InitControls(): SetChangeControl("MyDivision")
    setListBox(clbDivision), SetChangeControl("UserTeamByDivision")
    clbTeam, 이후 Division 분기 — 40 이면 BizType/EndCustomerByDivision 로드 + Project·PlantSite·btnProject 비활성 + cboCellQty 활성 + checkInvalidExec 비활성 / else 이면 Project·PlantSite 활성, 82 이면 checkInvalidExec 활성+체크, 81 이면 lblEDISender 활성 + EdiSender 콤보 로드
    ④ EndCustomer setListBox(clbCustomer), UserSiteByEndCustomer
    clbSalesSite, 81 이면 UserPlantSiteByEndCustomer
    clbPlantSite
    ⑤ GetBucketType()
    cboBucketType, drpPeriod.InitValue=GetDayRange(), GetItemType()
    clbItemType, btnColumn/btnMeasure 툴팁
    ⑥ CreateSpread(): AddSheet(spdMain,shtMain,3,1,20)+GetSheetInfo
    siMain+ChangeSheet+InitSpread()
    ⑦ DefineProperty(): 조회패널 Height=108, cboBucketType=Weekly, siMain.ImagePopUp 이미지셀 셋업, CanModelChange=true, NowGroupID(ADMIN/DM ADMIN/DM Planner) 별 btnIncotermsChg 활성/가시 + 이벤트 배선(spdMain_Changed, clbDivision.SelectedIndexChanged, cboBucketType.SelectedIndexChanged)
    ⑧ InitSaveDataTable() 로 dtSave 스키마 생성
    ⑨ Division 이 81xx 또는 82 이면 dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure) 로 편집용 Measure 마스터 사전 로드

#### [2] OnShown (override)
- **트리거**: Form first shown  ·  **컨트롤/소스**: Form
- **소스라인**: `308-328`  ·  **호출 메서드**: base.OnShown, CString.GetCheckedListValue
- **데이터/SP**: UserInfoContext.Current[NowGroupID]; BucketType.Daily/Weekly (enum); dtDivision (로컬 캐시)
- **Division 분기**: W/S planner group forces AS on; 82=Daily default vs Weekly
- **실제 동작 (실측)**:

    ① base.OnShown(e) 호출
    ② UserInfoContext.Current["NowGroupID"] == 'DM Planner (W/S)' 이면 cboAS.Checked=true 로 A/S 강제 ON + cboAS.Enabled=false 로 잠금(W/S 플래너는 항상 A/S)
    ③ CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) 로 현재 Division 코드 추출
    ④ Division=='82' 이면 cboBucketType.ControlValues=BucketType.Daily(ESS 는 일단위 기본)
    ⑤ 그 외 Division 은 cboBucketType.ControlValues=BucketType.Weekly(주단위 기본)

### ▣ 그리드

#### [3] spdMain_Changed
- **트리거**: Grid cell value changed (edit/paste)  ·  **컨트롤/소스**: spdMain DefaultSheetDataModel.Changed (wired L573)
- **소스라인**: `573(wire)/2883-4340(body); ValidationCheck 4332-4341; 중복검사 3200-3257; SetSaveDataRemove 4324`  ·  **호출 메서드**: ValidationCheck, SetSaveData, SetSaveDataRemove, CString.GetCheckedListValue, siMain.SetText/GetText, CanModelChange 토글
- **데이터/SP**: 그리드 셀(dtSave 내부 누적) — SP 직접 호출 없음(저장은 SaveData 에서); DefColumns.* 컬럼 인덱스; BucketType enum; MSG00002/MSG00225/MSG00260
- **MSG**: MSG00002, MSG00225, MSG00260
- **Division 분기**: Div40 vs 81/82 use different key columns (ItemId40/ScmSiteId40); MSG00225 blocks qty < actual
- **실제 동작 (실측)**:

    ① 재진입 가드: !CanModelChange 이면 즉시 return
    ② e.Type==CellsUpdated 케이스: 현재 BucketType/변경 컬럼 Tag(sColName) 취득, AS_FROM_SITE 컬럼 있으면 값 취득
    ③ Validation 영역 — 변경 컬럼이 현 Bucket 의 수량 컬럼(D_/W_/M_)일 때만 진입, Division 분기로 키값 수집: 81/82
    Division·Project·ScmSiteId·ItemId / 40
    Division40·Customer40·ScmSiteId40·ItemId40, 공통으로 DomExp·FcstType·Incoterms·Measure·PlantSiteId 수집
    ④ 필수 키 공란 검사: 빈 키마다 ValidationCheck(e,'컬럼명') 호출(bPasteContinue 시 MSG00002 표시) 후 셀 원복(SetText='')하고 return
    ⑤ 모델 중복 검사: 동일 행 세트가 그리드 내 2건 이상(iDouble>=2)이면 CanModelChange 토글 off/셀 clear/on 후 MSG00260(중복 모델) 표시 return — 81 은 PlantSite 포함 8키, 82 는 7키, 40 은 별도 키로 비교
    ⑥ BUCKET 패턴(요일 7자리, Insert 행은 '0000010'=금요일 기본) 파싱
    ⑦ 입력 수량을 Bucket(Daily/Weekly/Monthly)별로 일자 셀에 분배(iWeeklySum/iMonthlySum 재계산), 각 일자마다 SetSaveData(sAction,…,sYYYYMMDD,iDailyQty,…) 로 dtSave 누적
    ⑧ 실적(Actual) 구간보다 작은 수량 입력 시 MSG00225(실적 수량보다 작은 숫자 불가) 차단
    ⑨ 모델 정보 셀을 지운 경우: 해당 행 모든 수량 컬럼 clear 후 SetSaveDataRemove(...) 로 삭제 반영
    ⑩ 마무리: 미기재 컬럼 있으면 MSG00002, 재진입 방지 위해 CanModelChange=false
    (자기 자신에 대한 재계산 처리)
    CanModelChange=true 로 복원

#### [18] spdMain_CellClick
- **트리거**: Grid single cell click (edit mode only)  ·  **컨트롤/소스**: spdMain.CellClick (designer L1399)
- **소스라인**: `5451-5488`  ·  **호출 메서드**: siMain.IsLock, Data.Common(Data.Type.PlantSiteByItem), Data.Common(Data.Type.MktFcstEditMeasure), SetCellTypeCombo
- **데이터/SP**: Data.Type.PlantSiteByItem 콤보, Data.Type.MktFcstEditMeasure 콤보
- **Division 분기**: Only when sheet unlocked (edit)
- **실제 동작 (실측)**:

    ① siMain.IsLock(활성시트) 확인 — 잠긴(조회) 상태면 전체 무시, Edit 모드일 때만 진행
    ② 클릭 컬럼이 PlantSiteId 이거나 Division 앞2자리=='81' 이면 해당 행의 Division/Project/ItemId 값 취득
    ③ col0(Action)!='' 인 실제 데이터 행에 한해(머지 버그 회피) dtPlantSite = Data.Common(PlantSiteByItem, false, '', division, project, item) 재조회
    ④ SetCellTypeCombo 로 PlantSite 셀 콤보 교체
    ⑤ Division=='82' 이고 클릭 컬럼==Measure 이고 NewFlag(해당행)=='Y' 이면 Division/ScmSiteId/Project 취득
    ⑥ dtMeasure = Data.Common(MktFcstEditMeasure, false, div, site, project, UserId, '') 재조회 후 Measure 셀 콤보 교체(ESS 신규행 기준정보 자동완성)

#### [19] spdMain_CellDoubleClick
- **트리거**: Grid cell / column-header double click  ·  **컨트롤/소스**: spdMain.CellDoubleClick (designer L1400)
- **소스라인**: `2520-2882`  ·  **호출 메서드**: GetColumnTag, Columns[].Visible 토글, FoxDataRequest('DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP'), DMF0003_SspSyncComparePopUp.LoadData, SCM0002_ProjectbyDivisionPopupEx.Form_Load, DM0002_ItembyDivisionPopupEx.Form_Load
- **데이터/SP**: SP DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP; 팝업 SCM0002_ProjectbyDivisionPopupEx / DM0002_ItembyDivisionPopupEx / DMF0003_SspSyncComparePopUp
- **Division 분기**: Also re-invoked from KeyUp Ctrl+V to validate pasted model
- **실제 동작 (실측)**:

    ① e.ColumnHeader 이면 컬럼 접기/펼치기: 태그가 'M_'(월) 헤더면 다음 M_ 전까지 W_ 컬럼 Visible 토글 + 보이는 D_ 컬럼 숨김 / 'W_'(주) 헤더면 다음 W_ 전까지 하위 D_ 컬럼 Visible 토글
    ② 본문 셀이면 sBucketType(cboBucketType)·sColName(태그) 판정
    ③ 동기화 비교 영역: 버킷과 셀 태그가 일치(Daily·D_ / Weekly·W_ / Monthly·M_ / W·M 상태의 D_)하면 행에서 Measure/Action/ScmSiteId40/Team/Customer40/Project/ItemId(또는40)/DomExp/FcstType/Incoterms 취득
    ④ Division=='40' && Measure=='MKT_FCST_RP' && 셀 BackColor 가 PaleGreen(A=완전동기) 또는 PapayaWhip(P=부분동기) 이면 FoxData 'DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP'(CommandTimeout 30분) 호출
    ⑤ 기간은 당주 월요일~+20일로 재계산, 파라미터 division/scm_site/project_code(=Customer)/item/dom_exp/fcst_type/incoterms/yyyymmdd 세팅
    ⑥ 결과로 DMF0003_SspSyncComparePopUp.LoadData(table, division) 후 ShowDialog(MKT FCST vs SSP 수량 비교)
    ⑦ 이후 IsLock 이거나 Action!='I'(신규행 아님)면 return(드릴 편집 차단)
    ⑧ Project 셀이면 SCM0002_ProjectbyDivisionPopupEx.Form_Load(false,...) 로 Project 선택
     ProjectCode/Name/Status/BizType/Owner 를 각 컬럼에 SetText
    ⑨ ItemId/ItemId40 셀이면 DM0002_ItembyDivisionPopupEx.Form_Load(false,...,sMdmActive_Sw='Y', sMeasure_info) 로 모델 선택
     ItemID/Name/Type/NickName SetText (사용중지 모델 정보 제공 E20231019-001234)

#### [20] spdMain_ComboSelChange
- **트리거**: In-grid combo cell selection change  ·  **컨트롤/소스**: spdMain.ComboSelChange (designer L1401)
- **소스라인**: `2311-2519`  ·  **호출 메서드**: Data.UserTeamByDivisionAuth, Data.UserEndCustomerByDivisionDeptAuth, Data.Common(EndCustomerByDivision40 / MktFcstEditMeasure), Data.UserSiteByEndCustomerAuth, Data.UserSiteByEndCustomer, GetBizTypebyDivision, GetIncotermsType, SetCellTypeCombo, LockRange, SetText
- **데이터/SP**: 콤보: UserTeamByDivisionAuth, UserEndCustomerByDivisionDeptAuth, EndCustomerByDivision40, UserSiteByEndCustomer(Auth), MktFcstEditMeasure; GetBizTypebyDivision→SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION; GetIncotermsType
- **Division 분기**: Full in-grid cascade; Div40 vs 81/82 separate branches
- **실제 동작 (실측)**:

    ① 변경 컬럼이 Division 셀이면: Team 콤보=Data.UserTeamByDivisionAuth(NowGroupID,UserId,div) 재설정
    ② Customer 콤보=Data.UserEndCustomerByDivisionDeptAuth(...,div,team), Customer40 콤보=Data.Common(EndCustomerByDivision40,...) 재설정(team 비면 clbTeam 값 대체)
    ③ SalesSite: div 앞2자리 81 또는 82
    Data.UserSiteByEndCustomerAuth
    ScmSiteId 셀 / else
    Data.UserSiteByEndCustomer(40)
    ScmSiteId40 셀
    ④ BizType=GetBizTypebyDivision(clbDivision) 로 clbBizType 리스트박스 재바인딩
    ⑤ PlantSiteId 셀 LockRange: div 81 이면 unlock(false) 아니면 lock(true)
    ⑥ Measure 콤보=Data.Common(MktFcstEditMeasure, div, site, project, UserId) 를 81/82(ScmSiteId 기준) 및 40(ScmSiteId40 기준) 각각 재설정
    ⑦ 변경 컬럼이 Team 셀이면 Customer/SalesSite 콤보 재설정(40 은 Customer40/SalesSite40)
    ⑧ Customer 셀이면 SalesSite(=UserSiteByEndCustomerAuth), Customer40 셀이면 SalesSite40(=UserSiteByEndCustomer) 재설정
    ⑨ ScmSiteId 셀이면 Project/ProjectName/Status/BizType SetText('') 초기화 후 Measure 콤보 + Incoterms 콤보(GetIncotermsType(div,site)) 재설정
    ⑩ ScmSiteId40 셀이면 Measure 콤보 재설정
    ⑪ Measure 셀이면 Action=='I' && 선택 measure 가 'AS_In_Req'/'BNPIn' 이 아닐 때 ItemId(40)/ItemName/ItemType/NickName SetText('') 초기화(MDM ACTIVE_FLAG 기반 DP 입력 차단 목적, 20231213)

#### [21] spdMain_EditChange
- **트리거**: Grid cell edit begin/change  ·  **컨트롤/소스**: spdMain.EditChange (designer L1402)
- **소스라인**: `5407-5413`  ·  **호출 메서드**: siMain.GetColumnIndex(DefColumns.Measure), ActiveColumnIndex, bPasteContinue 플래그
- **데이터/SP**: 없음(플래그 세팅만)
- **Division 분기**: Guards left/measure columns from edit-flag handling
- **실제 동작 (실측)**:

    ① 활성 컬럼 인덱스가 Measure 컬럼 이하(좌측 키/메타 영역)이면 즉시 return — 편집 플래그 처리 대상 아님
    ② 그 외(수량/우측 편집영역)면 bPasteContinue=true 세팅하여 후속 Changed/Paste 재계산 파이프라인이 이어지도록 표시(가드 플래그)

#### [22] spdMain_ClipboardPasted
- **트리거**: After clipboard paste into grid  ·  **컨트롤/소스**: spdMain.ClipboardPasted (designer L1398)
- **소스라인**: `5416-5448`  ·  **호출 메서드**: e.CellRange 순회, Data.Common(Data.Type.MktFcstEditMeasure), GetIncotermsType, SetCellTypeCombo
- **데이터/SP**: Data.Type.MktFcstEditMeasure 콤보, GetIncotermsType 콤보
- **Division 분기**: [C20200306-000306] Div40 paste SalesSite -> Measure list update
- **실제 동작 (실측)**:

    ① 붙여넣기 CellRange(Row~Row+RowCount, Col~Col+ColCount) 를 이중 루프로 순회
    ② 순회 컬럼이 ScmSiteId40(40사업부 SalesSite) 이면 해당 행 Division40/ScmSiteId40 값 취득
    ③ dtMeasure=Data.Common(MktFcstEditMeasure, false, div, site, '', UserId, '') 재조회 후 그 행 Measure 셀 콤보 교체(붙여넣기로 사이트 바뀌면 Measure 목록 갱신, C20200306-000306)
    ④ 순회 컬럼이 ScmSiteId(81/82) 이면 Division/ScmSiteId 취득
    ⑤ dtIncotermsType=GetIncotermsType(div, site) 재조회 후 Incoterms 셀(ActiveRow 기준) 콤보 교체

#### [23] spdMain_TopChange
- **트리거**: Grid vertical scroll (top row change)  ·  **컨트롤/소스**: spdMain.TopChange (designer L1403)
- **소스라인**: `4569-4574`  ·  **호출 메서드**: CanModelChange 가드, siMain.SmartColMerge()
- **데이터/SP**: 없음(그리드 병합 재계산)
- **실제 동작 (실측)**:

    ① 세로 스크롤로 최상단 행이 바뀔 때 발생
    ② CanModelChange=false 로 모델변경 재진입 가드
    ③ siMain.SmartColMerge() 호출하여 뷰포트에 새로 들어온 좌측 키 컬럼(Division/Site/Item 등)의 세로 병합(merge) 재계산
    ④ CanModelChange=true 복원. (스크롤 시 병합 셀이 깨져 보이는 문제 방지용 최소 로직)

#### [24] spdMain_KeyUp
- **트리거**: Key up in grid (Ctrl+C / Ctrl+V / bare C / V)  ·  **컨트롤/소스**: spdMain.KeyUp (designer L1404)
- **소스라인**: `4584-4648`  ·  **호출 메서드**: ClipboardPaste(AsStringSkipHidden), ClipboardCopy(AsStringSkipHidden), spdMain_CellDoubleClick(합성 호출), bPasteContinue
- **데이터/SP**: 없음(클립보드) — 단 CellDoubleClick 경유 DM0002_ItembyDivisionPopupEx 모델검증
- **Division 분기**: [E20231019-001234] model 사용중지 정보 제공; treats bare C/V same as Ctrl+C/V
- **실제 동작 (실측)**:

    ① 활성 컬럼이 ItemId 또는 ItemId40 이면(모델코드 열): V(Ctrl+V 및 bare V)
    ClipboardPaste(AsStringSkipHidden) 로 숨김열 제외 붙여넣기 후 bPasteContinue=true
    ② div=='40' 이면 ItemId40, else ItemId 컬럼/텍스트로 활성 셀 좌표·모델코드 취득
    ③ 합성 CellClickEventArgs 로 spdMain_CellDoubleClick 을 강제 호출하여 붙여넣은 모델의 유효성/사용중지 여부 검증 및 Name/Type/NickName 자동 채움(E20231019-001234)
    ④ 같은 열에서 C(Ctrl+C/ bare C)
    Clipboard.Clear() 후 ClipboardCopy(AsStringSkipHidden)
    ⑤ 이후 활성 컬럼이 Measure 이하이면 return
    ⑥ 수량(Measure 우측) 열에서 V
    ClipboardPaste(AsStringSkipHidden)+bPasteContinue=true, C
    Clipboard.Clear+ClipboardCopy(AsStringSkipHidden). (bare C/V 를 Ctrl+C/V 와 동일 취급)

### ▣ 조회조건

#### [4] cboDivision_SelectedIndexChanged
- **트리거**: Division combo change  ·  **컨트롤/소스**: clbDivision (UsrCombo, wired L575)
- **소스라인**: `575(wire)/2074-2210(body)`  ·  **호출 메서드**: InitSpread, InitSaveDataTable, SetChangeControl, clsCtrl.setListBox, CString.GetCheckedListValue, DataService.FP_Log2
- **데이터/SP**: DataService.GetDMInnerTable(UserTeamByDivision/EdiSender/EndCustomerByDivision/ScmSitebyEndCustomer40/UserSiteByEndCustomer/BizType/UserPlantSiteByEndCustomer) via FoxData 'DM.UP_FX_GetCommonDataList_DM'
- **Division 분기**: 40: Project/PlantSite disabled, CellQty enabled; 82: checkInvalidExec on+checked, PlantSite off; 81: EDISender enabled
- **실제 동작 (실측)**:

    ① DataService.FP_Log2('SpeedUp',...,'start') 속도 마커
    ② Division 코드 추출 후 InitSpread()+InitSaveDataTable() 로 시트/저장테이블 재구성
    ③ SetChangeControl('UserTeamByDivision')
    setListBox(clbTeam), SetChangeControl('EdiSender')
    setListBox(clbEDISender)
    ④ lblEDISender.Enabled=false 기본
    ⑤ Division=='40' 분기: lblProject/lblPlantSite/btnProject 비활성 + cboCellQty 활성 + clbPlantSite 비움, EndCustomerByDivision
    clbCustomer, ScmSitebyEndCustomer40
    clbSalesSite, BizType
    clbBizType, checkInvalidExec 비활성
    ⑥ else(81/82 등): lblProject/btnProject 활성, cboCellQty 비활성+uncheck, EndCustomerByDivision
    clbCustomer, UserSiteByEndCustomer
    clbSalesSite, BizType
    clbBizType, Division 에 '81' 포함 시 UserPlantSiteByEndCustomer
    clbPlantSite
    ⑦ Division=='82': checkInvalidExec 활성+체크 + lblPlantSite 비활성 + clbPlantSite 비움 / else: checkInvalidExec 비활성+uncheck + lblPlantSite 활성, '81' 이면 lblEDISender 활성
    ⑧ lblBizType 활성, txtProject/txtItemId/txtOwner 초기화('')
    ⑨ FP_Log2 'end' 마커

#### [5] cboBucketType_SelectedIndexChanged
- **트리거**: Bucket (Daily/Weekly/Monthly) change  ·  **컨트롤/소스**: cboBucketType (UsrCombo, wired L576 & designer L725)
- **소스라인**: `576/725(wire)/2263-2309(body)`  ·  **호출 메서드**: SetSpreadColumn, EditButton, siMain.IsLock, BevelBorder, GetColumnIndex
- **데이터/SP**: 그리드 컬럼 재렌더링 전용 — SP 없음; this_YYYYMMWW/sResultYYYYMMDD 현재기간 캐시
- **Division 분기**: Wired twice (DefineProperty + designer)
- **실제 동작 (실측)**:

    ① siMain==null 이면 무동작
    ② SetSpreadColumn() 로 Bucket(Daily/Weekly/Monthly)에 맞는 컬럼 표시 재구성
    ③ chkColor 미체크 시 현재기간 초록 테두리(BevelBorder Green) 재배치: Daily 면 'D_'+오늘 컬럼에 테두리 + 주차 컬럼 ResetBorder / Weekly·Monthly 면 count>=2 이면 'W_'+년월+ISO주차 컬럼, 아니면 this_YYYYMMWW 컬럼에 테두리 + 'D_'오늘 ResetBorder
    ④ 시트가 잠금 아님(!IsLock, 즉 편집모드)이면 편집 잠금 상태 유지를 위해 EditButton() 을 2회 연속 호출(1회는 lock off, 2회째 재적용)

#### [6] cboBucketType_Click
- **트리거**: Bucket combo click  ·  **컨트롤/소스**: cboBucketType (designer L726)
- **소스라인**: `726(wire)/5395-5405(body)`  ·  **호출 메서드**: siMain.GetText, siMain.GetMaxRowIndex, MessageHelper.GMessageBox
- **데이터/SP**: 그리드 Action 컬럼(col0) 검사 — SP 없음; MSG00227; CAppSetting.FlagI
- **MSG**: MSG00227
- **실제 동작 (실측)**:

    ① 그리드 전체 행 순회(0..GetMaxRowIndex)
    ② 각 행 0번 컬럼(Action) 텍스트가 CAppSetting.FlagI('I', 신규 삽입행)이면
    ③ MSG00227(삽입 행 존재 시 Bucket 변경 불가) 경고 후 return 하여 Bucket 변경 차단
    ④ 삽입행이 하나도 없으면 무동작(SelectedIndexChanged 가 실제 변경 처리)

#### [7] clbTeam_SelectedIndexChanged
- **트리거**: Team checklist change  ·  **컨트롤/소스**: clbTeam (UsrCheckedList, designer L960)
- **소스라인**: `960(wire)/2212-2248(body)`  ·  **호출 메서드**: SetChangeControl, clsCtrl.setListBox, CString.GetCheckedListValue
- **데이터/SP**: DataService.GetDMInnerTable(EndCustomerByDivision, UserSiteByEndCustomer) via FoxData 'DM.UP_FX_GetCommonDataList_DM'
- **Division 분기**: 81/82 use UserSiteByEndCustomer; 40 uses Team as dept key
- **실제 동작 (실측)**:

    ① Division·Team 코드 추출
    ② Division 이 81(Substring 0,2=='81') 또는 82 분기: SetChangeControl('EndCustomerByDivision', division, team)
    setListBox(clbCustomer), 선택 EndCustomer 로 SetChangeControl('UserSiteByEndCustomer', division, '', endCustomer)
    ③ else(40 등) 분기: SetChangeControl('EndCustomerByDivision', division, clbTeam.ControlValues)
    setListBox(clbCustomer), SetChangeControl('UserSiteByEndCustomer', division, clbTeam.ControlValues, clbCustomer.ControlValues) — 40 은 Team 을 부서키로 SalesSite 재조회
    ④ 공통 마무리: setListBox(dtSalesSite, clbSalesSite) 로 SalesSite 체크리스트 갱신

#### [8] clbCustomer_SelectedIndexChanged
- **트리거**: End Customer checklist change  ·  **컨트롤/소스**: clbCustomer (UsrCheckedList, designer L920)
- **소스라인**: `920(wire)/2250-2261(body); GetSalesSite 5825-5841; GetSalesSite40 5847-5863`  ·  **호출 메서드**: GetSalesSite, GetSalesSite40, clsCtrl.setListBox
- **데이터/SP**: FoxData 'DM.UP_FX_GetCommonDataList_DM' CODE=SiteByEndCustomer / SiteByEndCustomer40, PARAM5=AS(Y/N)
- **Division 분기**: AS checkbox value feeds PARAM5 of SiteByEndCustomer(40)
- **실제 동작 (실측)**:

    ① Division 이 81(Substring 0,2=='81') 또는 82 이면
    dtSalesSite = GetSalesSite(division, customer, NowGroupID, UserId)
    ② else(40 등) 이면
    dtSalesSite = GetSalesSite40(team, customer, NowGroupID, UserId)
    ③ 두 메서드 모두 FoxData 'DM.UP_FX_GetCommonDataList_DM' 를 CODE=SiteByEndCustomer(또는 SiteByEndCustomer40)로 호출하며 PARAM5 에 cboAS.Checked?'Y':'N'(A/S 여부)를 전달
    ④ setListBox(dtSalesSite, clbSalesSite) 로 SalesSite 목록 갱신

#### [9] chkColor_CheckedChanged
- **트리거**: Color checkbox toggle  ·  **컨트롤/소스**: chkColor (UsrCheckBox, designer L236)
- **소스라인**: `236(wire)/4576-4582(body)`  ·  **호출 메서드**: SetSpreadColumn, siMain null 가드
- **데이터/SP**: 그리드 색상 재렌더링 전용 — SP 없음
- **실제 동작 (실측)**:

    ① siMain!=null 가드 확인
    ② SetSpreadColumn() 호출 — 색상 체크 상태에 따라 셀 배경/현재기간 초록테두리 등 컬럼 색상 재적용(체크 시 색상표시, 해제 시 초록 현재기간 테두리 로직 활성). 셀 데이터 자체는 불변, 렌더링만 재계산

#### [10] chkSum_CheckedChanged
- **트리거**: Sum checkbox toggle  ·  **컨트롤/소스**: chkSum (UsrCheckBox, designer L469)
- **소스라인**: `469(wire)/4723-4729(body)`  ·  **호출 메서드**: SetSpreadColumn, siMain null 가드
- **데이터/SP**: 그리드 SUM 컬럼 가시성 재렌더링 전용 — SP 없음
- **실제 동작 (실측)**:

    ① siMain!=null 가드 확인
    ② SetSpreadColumn() 호출 — SUM(주간/월간 합계) 컬럼의 표시/숨김을 chkSum 상태에 따라 재구성. 데이터 불변, 컬럼 가시성만 재계산(합계 컬럼은 InitSpreadFooterSum 의 SumIgnoreHidden 집계와 연동)

#### [11] cboAS_CheckedChanged
- **트리거**: AS checkbox toggle  ·  **컨트롤/소스**: cboAS (UsrCheckBox, designer L273)
- **소스라인**: `273(wire)/5865-5876(body)`  ·  **호출 메서드**: GetSalesSite, GetSalesSite40, clsCtrl.setListBox
- **데이터/SP**: FoxData 'DM.UP_FX_GetCommonDataList_DM' CODE=SiteByEndCustomer / SiteByEndCustomer40, PARAM5=AS(Y/N)
- **Division 분기**: Same logic as clbCustomer change; AS toggles A/S site list
- **실제 동작 (실측)**:

    ① Division 이 81(Substring 0,2=='81') 또는 82 이면
    dtSalesSite = GetSalesSite(division, customer, NowGroupID, UserId)
    ② else(40 등) 이면
    dtSalesSite = GetSalesSite40(team, customer, NowGroupID, UserId)
    ③ 두 호출 모두 FoxData 'DM.UP_FX_GetCommonDataList_DM' 의 PARAM5 에 cboAS.Checked?'Y':'N' 를 실어 A/S 사이트만/일반 사이트 목록을 구분 조회(clbCustomer 변경과 동일 로직)
    ④ setListBox(dtSalesSite, clbSalesSite) 로 SalesSite 갱신

#### [12] btnProject_Click
- **트리거**: Project '...' button click  ·  **컨트롤/소스**: btnProject (UsrButton, designer L618)
- **소스라인**: `618(wire)/4650-4671(body)`  ·  **호출 메서드**: SCM0002_ProjectbyDivisionPopupEx.Form_Load, ShowDialog
- **데이터/SP**: SCM0002_ProjectbyDivisionPopupEx 팝업(내부 SP) — 본 핸들러는 SP 직접호출 없음
- **Division 분기**: Disabled when Division==40
- **실제 동작 (실측)**:

    ① 조회조건에서 Division/Team/EndCustomer/SalesSite/Project 값 수집(clbDivision·clbTeam·clbCustomer·clbSalesSite.ControlValues, txtProject.Text)
    ② new SCM0002_ProjectbyDivisionPopupEx() 생성
    ③ popProject.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) 로 컨텍스트 전달 초기화
    ④ StartPosition=CenterParent, ShowDialog() 모달 표시
    ⑤ 팝업 반환 popProject.ProjectCode 취득
    ⑥ ProjectCode 가 공란이 아니면 txtProject.Text=선택값 반영(공란이면 미변경). Division==40 에서는 btnProject 자체가 비활성이라 호출 불가

#### [13] btnItemId_Click
- **트리거**: Model '...' button click  ·  **컨트롤/소스**: btnItemId (UsrButton, designer L688)
- **소스라인**: `688(wire)/4673-4695(body)`  ·  **호출 메서드**: DM0002_ItembyDivisionPopupEx.Form_Load, ShowDialog
- **데이터/SP**: DM0002_ItembyDivisionPopupEx 팝업(내부 SP) — 본 핸들러는 SP 직접호출 없음
- **실제 동작 (실측)**:

    ① 조회조건 Division/Team/EndCustomer/SalesSite/Project/ItemId 값 수집(txtItemId.Text 포함)
    ② new DM0002_ItembyDivisionPopupEx() 생성(구 SCM0002_ItembyDivisionPopupEx 는 주석 처리됨)
    ③ popItem.Form_Load(true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) 로 컨텍스트 초기화
    ④ StartPosition=CenterParent, ShowDialog() 모달
    ⑤ popItem.ItemID 반환 취득
    ⑥ ItemID 공란 아니면 txtItemId.Text=선택 모델코드 반영

#### [14] btnOwner_Click
- **트리거**: Owner '...' button click  ·  **컨트롤/소스**: btnOwner (UsrButton, designer L356)
- **소스라인**: `356(wire)/5374-5393(body)`  ·  **호출 메서드**: DM0020_OwnerbyDivisionPopup.Form_Load, ShowDialog, CString.GetCheckedListValue
- **데이터/SP**: DM0020_OwnerbyDivisionPopup 팝업(내부 SP) — 본 핸들러는 SP 직접호출 없음
- **실제 동작 (실측)**:

    ① Division(CString.GetCheckedListValue 로 코드화)/Team/EndCustomer/Project/SalesSite/ItemId/Owner 값 수집
    ② new DM0020_OwnerbyDivisionPopup() 생성
    ③ popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) 로 8개 컨텍스트 전달 초기화
    ④ StartPosition=CenterParent, ShowDialog() 모달
    ⑤ 반환 즉시 txtOwner.Text = popItem.OwnerID 로 무조건 반영(공란 가드 없음 — 취소 시 빈 OwnerID 로 덮일 수 있음)

#### [15] btnColumn_Click
- **트리거**: Column Show button click  ·  **컨트롤/소스**: btnColumn (UsrButton, designer L582)
- **소스라인**: `582(wire)/4697-4708(body)`  ·  **호출 메서드**: DM0002_TitleSetForm_Popup(ctor bColumnMode=true), ShowDialog, InitSpread
- **데이터/SP**: DM0002_TitleSetForm_Popup 팝업(컬럼셋 저장 SP) → OK 시 InitSpread 가 GetSpdTitle 재조회
- **Division 분기**: true = column-set mode
- **실제 동작 (실측)**:

    ① new DM0002_TitleSetForm_Popup('DMF0003', SpdSheet.shtMain, true, clbDivision.ControlValues) 생성 — 4번째 인자 true = 컬럼셋(Column Show) 모드, Division 을 넘겨 사업부별 컬럼 세트 관리 (구 SCM0002_TitleSetForm_Popup 은 주석 처리)
    ② StartPosition=CenterParent, ShowDialog() 모달
    ③ 반환 DialogResult==OK 이면 InitSpread() 재호출로 변경된 컬럼 타이틀/스팬/색상/footer 를 그리드에 재적용

#### [16] btnMeasure_Click
- **트리거**: Measure button click  ·  **컨트롤/소스**: btnMeasure (UsrButton, designer L545)
- **소스라인**: `4710-4721`  ·  **호출 메서드**: DM0002_TitleSetForm_Popup(화면ID, shtMain, false, division), InitSpread()
- **데이터/SP**: DM0002_TitleSetForm_Popup 내부(TitleSet 메타 저장); 본 핸들러는 SP 직접 호출 없음
- **Division 분기**: false = measure-set mode
- **실제 동작 (실측)**:

    ① clbDivision.ControlValues 취득
    ② DM0002_TitleSetForm_Popup 생성 시 4번째 인자 false(=measure-set 모드; column-set 인 btnColumn_Click 은 true) + 1번째 인자 'DMF0003' 화면ID + 2번째 SpdSheet.shtMain
    ③ StartPosition=CenterParent 로 ShowDialog(모달)
    ④ 사용자가 화면별 Measure 표시/순서 저장
    ⑤ frm.DialogResult==OK 이면 InitSpread() 재실행하여 새 Measure 셋으로 그리드 컬럼/시트 재구성(조회데이터는 초기화)

#### [17] btnIncotermsChg_Click (Master Chg)
- **트리거**: Master Chg button click  ·  **컨트롤/소스**: btnIncotermsChg 'Master Chg' (UsrButton, designer L393)
- **소스라인**: `5359-5372`  ·  **호출 메서드**: DMF0003_MatsterChgPopup.Form_Load(true, div, team, cust, site, project)
- **데이터/SP**: DMF0003_MatsterChgPopup 내부 SP(본 핸들러 직접 호출 없음)
- **Division 분기**: Visible/Enabled only ADMIN, DM ADMIN, DM Planner (DefineProperty L550-570)
- **실제 동작 (실측)**:

    ① 조회조건 5종(Division/Team/EndCustomer/SalesSite/Project) ControlValues 및 txtProject.Text 취득
    ② DMF0003_MatsterChgPopup 생성
    ③ popAdjst.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) 로 팝업에 현재 필터 컨텍스트 전달(Incoterms/기준정보 일괄 변경 팝업)
    ④ StartPosition=CenterParent, ShowDialog(모달)
    ⑤ 반환값 후처리 없음(팝업 내부에서 Master 변경 저장). 버튼 자체는 DefineProperty(L550-570)에서 ADMIN / DM ADMIN / DM Planner 그룹만 Visible+Enabled

### ▣ 우클릭 메뉴

#### [25] contextMenuStrip1_ItemClicked
- **트리거**: Grid right-click context menu item click  ·  **컨트롤/소스**: contextMenuStrip1 (designer L1416)
- **소스라인**: `5510-5753`  ·  **호출 메서드**: GetSelections, CString.GetCheckedListValue, GetColumnTag('D_'), Distinct 모델체크, DMF0003_PRPopup.Form_Load, DMF0003_PRHistoryPopup.Form_Load
- **데이터/SP**: 팝업 DMF0003_PRPopup / DMF0003_PRHistoryPopup(내부 PR SP); 본 핸들러는 검증만·SP 직접호출 없음
- **MSG**: MessageBox literals (선택된 셀 없음/실적 구간 포함/일자컬럼만/Model 중복/Project 동일/Request 내용 없음)
- **Division 분기**: 4 menu items Request PR / View PR / Add History / View History
- **실제 동작 (실측)**:

    ① 선택 CellRange 취득 + division=CString.GetCheckedListValue
    선택 셀 0개면 MessageBox '선택된 셀이 없습니다.' return
    ② Request_PR: 선택 범위를 순회하며 태그 'D_'(일자) 열에 대해 Measure=='BNPIn' & 값!=0/'' 행만 수집(div40 은 ItemId40/ScmSiteId40, else ItemId/ScmSiteId + DomExp/FcstType/Incoterms/PlantSite/Project/YYYYMMDD/Qty)
    ③ 당주 월요일(checkYYYYMMDD) 보다 과거 일자열 포함 시 '실적 구간이 포함되어 있습니다.' return
    ④ 일자열 아닌 열에 값 있으면 '일자컬럼에서만 사용가능합니다.' return
    ⑤ 수집 Qty 0건이면 'Request 할 내용이 없습니다.' return
    ⑥ 모델 중복 시 'Model 은 중복될 수 없습니다.', Project 불일치 시 'Project 는 동일해야 합니다.' return
    ⑦ 값들을 '^' 로 join 하여 DMF0003_PRPopup.Form_Load(메뉴명,'',div,project,site,item,domExp,fcstType,incoterms,plantSite,yyyymmdd,qty) ShowDialog
    ⑧ View_PR/Add_History/View_History: 셀 1개만 허용(아니면 '한 개의 셀만' 안내), Measure!='BNPIn' 이면 'BNP In 메저행에서만', 일자열 아니면 '일자컬럼에서만' 안내 후 단일 셀 값 수집
    ⑨ View_History
    DMF0003_PRHistoryPopup, 그 외
    DMF0003_PRPopup 로 Form_Load+ShowDialog

### ▣ CRUD 버튼

#### [26] FindButton (override) → FindData()
- **트리거**: Find toolbar button / F-key (mapped by BaseForm)  ·  **컨트롤/소스**: Common toolbar Find/Retrieve (BaseForm hotkey)
- **소스라인**: `768-773 (override) / 1199-1462 (FindData)`  ·  **호출 메서드**: FindData(), FoxAsyncProxy.ExecuteAsync, FoxDataRequest('DM.DMF0003_GET_MKT_FCST_DATA'), siMain.Query/SmartColMerge/LockColumn2, SetSpreadColumn, Data.Common(DefaultBucketDay)
- **데이터/SP**: SP DM.DMF0003_GET_MKT_FCST_DATA (3 result tables: data / dt8Week / this_YYYYMMWW+iso_week); Data.Type.DefaultBucketDay
- **MSG**: MSG00097, MSG00108, MSG00164
- **Division 분기**: F-key handled by BaseForm common toolbar, not local ProcessCmdKey
- **실제 동작 (실측)**:

    ① CanModelChange=false + ProgressForm 준비
    ② division(CString.GetCheckedListValue) 빈값이면 MSG00097 return
    ③ 기간 split(':'); from>to 이면 MSG00108 return
    ④ Value1.AddYears(3)<Value2(3년 초과) 이면 MSG00164 표시 + Value2 를 Value1+2년으로 되돌리고 return
    ⑤ prg.Show + InitSpread + SearchStartTime
    ⑥ FoxAsyncProxy.ExecuteAsync 로 'DM.DMF0003_GET_MKT_FCST_DATA'(CommandTimeout 30분) 비동기 호출, 파라미터 약 20종(division/scm_site/plant_site/team/customer/biz_type/project/item/from~to_yyyymmdd/created_by/user_group/item_type/owner/qty_yn/cell_yn/invalid_exec(ESS Sales Price 미등록 제외)/as_yn(W/S)/user_dept_id(JV)/sender_code)
    ⑦ ds.Tables[1]
    dt8Week 보관, SearchEndTime
    ⑧ siMain.Query(Tables[0].DataSet)+SmartColMerge+LockColumn2(전체 잠금)
    ⑨ Tables[2]
    this_YYYYMMWW/iso_week
    ⑩ SetSpreadColumn 후 dtSave/dtSaveFinal.Clear, 당주 결과열(iResultCol)/월(iResultMonth)/주(count) 계산
    ⑪ chkColor.Checked 면 과거구간 Gainsboro·당월 White 채색, 아니면 당주/당일 컬럼에 Green Bevel 테두리
    ⑫ div 40/82 면 ATTR1('일자/동기화여부' ^구분) 파싱하여 동기화셀 A=PaleGreen / P=PapayaWhip 채색(SSP 동기화 표시)
    ⑬ DefaultBucketDay 조회
    catch: GMessageBoxForException, finally: prg.Close + ResumeLayout

#### [27] InsertButton (override) → InsertRow()
- **트리거**: Insert toolbar button  ·  **컨트롤/소스**: Common toolbar Insert (BaseForm)
- **소스라인**: `775-778 (override) / 1687-1806+ (InsertRow)`  ·  **호출 메서드**: InsertRow(), siMain.Insert, GetCustomsHandbook, GetFcstType, Data.UserTeamByDivisionAuth, Data.Common(EndCustomerByDivision40 / MktFcstEditMeasure), Data.UserSiteByEndCustomer(Auth), Data.UserEndCustomerByDivisionDeptAuth, SetCellTypeCombo, LockRange
- **데이터/SP**: 콤보: GetCustomsHandbook, GetFcstType, UserTeamByDivisionAuth, EndCustomerByDivision40, UserSiteByEndCustomer(Auth), UserEndCustomerByDivisionDeptAuth, MktFcstEditMeasure
- **Division 분기**: [E20230509-000677] insert under filter
- **실제 동작 (실측)**:

    ① siMain !=null && IsLock==false && SheetName==shtMain 일 때만 진행(Edit 모드 강제)
    ② SuspendLayout + siMain.Insert()(신규행, Action='I')
    ③ 81/82: Project·ItemId 셀 CellType=cellTypeImage(팝업 트리거), Division 셀에 clbDivision 값 세팅 / 40: ItemId40 셀 image, Division40 값 세팅 + DomExp 셀에 GetCustomsHandbook 콤보(C20220704-000441)
    ④ PlantSiteId 셀에 dtPlantSite 콤보
    ⑤ Team 콤보=Data.UserTeamByDivisionAuth, FcstType 콤보=GetFcstType(권한/부서 DB 판단)
    ⑥ div=='40' 분기: EndCustomer40=Data.Common(EndCustomerByDivision40), SalesSite=Data.UserSiteByEndCustomer, Team/Customer40/ScmSiteId40 콤보 세팅 후 Measure=Data.Common(MktFcstEditMeasure, div40, site40) 콤보
    ⑦ else(81/82): EndCustomer=Data.UserEndCustomerByDivisionDeptAuth, SalesSite=Data.UserSiteByEndCustomerAuth, Team/Customer/ScmSiteId 콤보 세팅 후 Measure 콤보(div, site, project)
    ⑧ Measure 셀 기본값 'MKT_FCST_RP' SetValue
    ⑨ Division/Division40/BizType/SoldToCustomer/CountryName 등 좌측 키·메타 컬럼 LockRange(true) 로 잠금(UnFilterInsertRow=true 라 필터 상태에서도 삽입 허용, E20230509-000677)

#### [28] DeleteButton (override)
- **트리거**: Delete toolbar button  ·  **컨트롤/소스**: Common toolbar Delete (BaseForm)
- **소스라인**: `780-786`  ·  **호출 메서드**: siMain.GetText(Action), siMain.DeleteRow()
- **데이터/SP**: 없음(로컬 그리드 행 삭제; 실제 삭제는 미지원, 신규행 취소만)
- **Division 분기**: Cannot delete persisted rows
- **실제 동작 (실측)**:

    ① 활성행 Action 컬럼(CAppSetting.StringAction) 텍스트를 읽어
    ② 값이 'I'(당 세션에서 Insert 된 신규행)일 때만 siMain.DeleteRow() 실행
    ③ 조회로 로드된 기존(persisted) 행은 조건 불일치로 삭제 불가(아무 동작 없음). 별도 확인 메시지/재계산 없음

#### [29] EditButton (override)
- **트리거**: Edit toolbar button (also called from bucket change)  ·  **컨트롤/소스**: Common toolbar Edit (BaseForm)
- **소스라인**: `788-1188 (bucket 변경 시에도 호출됨)`  ·  **호출 메서드**: siMain.GetColumnIndex(필수컬럼), MessageHelper.GMessageBox('MSG00113'/'MSG00259'), GetSheetInfo, siMain.SwitchLock, LockColumn/LockRange, SetBGColor, BevelBorder
- **데이터/SP**: 없음(로컬 잠금/채색); dt8Week(FindData 2번째 테이블)을 40 8주 기준으로 사용
- **MSG**: MSG00113, MSG00259
- **Division 분기**: 40 8-week lock logic largely commented; per-division column checks differ (81/82/40)
- **실제 동작 (실측)**:

    ① fps!=null 확인 후 division 별 필수컬럼 존재검사: 81
    Division/Project/ScmSiteId/ItemId/DomExp/FcstType/Incoterms/Measure/PlantSiteId, 82
    (PlantSite 제외 동일), 40
    Division40/Customer40/ScmSiteId40/ItemId40/DomExp/FcstType/Incoterms/Measure 중 하나라도 없으면 MSG00113 return
    ② dt8Week null/0행(미조회)이면 MSG00259 return
    ③ GetSheetInfo 재취득 후 siMain.SwitchLock()(잠금↔편집 토글)
    ④ 당주 월요일(sYYYYMMDD) 기준 Measure 우측 컬럼 순회하며 버킷별 과거구간 잠금: Daily
    오늘 이전 D_ 열 LockColumn, 비 D_ 열 전부 잠금(당월 M_ 은 iResultMonth 기록) / Weekly
    해당 주의 익일 D_ 가 과거면 W_ 열 잠금, 그 외 D_/M_ 열 잠금(40 8주 잠금 로직은 대부분 주석처리) / Monthly
    당월 이전 M_ 잠금, 40 은 dt8Week MONTH_NAME 기준 8주차까지 추가 잠금
    ⑤ 행 순회: 0~Measure 좌측영역 LockRange(true)
    ⑥ EditFlag!='Y' 인 행은 Measure 우측 전부 잠금; Action=='I' && IsEditMode 인 신규행은 ProjectName/Status/CellType/BizType/Country/ItemName/Type/NickName/Owner/MeasureGroup 등 메타 잠금 + Project/ItemId 셀만 unlock, sResultYYYYMMDD 기준 결과열까지 잠금
    ⑦ chkColor 면 과거 Gainsboro·당월 White 채색, 아니면 당주 W_ / 당일 D_ 컬럼에 Green Bevel 테두리
    ⑧ 버킷 태그와 다른 열(비 D_/W_/M_) LockRange, Division 열 잠금으로 마무리

#### [30] SaveButton (override) → SaveData()
- **트리거**: Save toolbar button  ·  **컨트롤/소스**: Common toolbar Save (BaseForm)
- **소스라인**: `1190-1193 (override) / 1464-1664 (SaveData) / 4829+ (fnValidation)`  ·  **호출 메서드**: SaveData(), fnValidation(out bInputCheck), FoxAsyncProxy/FoxDataRequest('DM.DMF0003_SAVE_MKT_FCST'), DMF0003_SspSyncPopUp.LoadData, FindData(재조회)
- **데이터/SP**: SP DM.DMF0003_SAVE_MKT_FCST (^-delimited bulk payload); 팝업 DMF0003_SspSyncPopUp; 성공 후 재조회 DM.DMF0003_GET_MKT_FCST_DATA
- **MSG**: MSG00043, MSG00034, MSG00366, MSG00004
- **Division 분기**: async void; SSP sync popup on Div synchronize
- **실제 동작 (실측)**:

    ① siMain!=null && IsLock==false && SheetName==shtMain(편집상태) 확인, procedure='DM.DMF0003_SAVE_MKT_FCST'
    ② fnValidation(out bInputCheck): 신규('I')행들의 중복조합(division/project/site/item/domExp/fcstType/incoterms/measure(+81 은 plantSite)) 검사 및 dtSaveFinal 구성; 반환 false 면 MSG00043(저장할 데이터 없음) return
    ③ bInputCheck==false 면 MSG00034 return
    ④ dtSaveFinal 행 순회하며 active_flag='M', division/project(81/82=Project, 40=Customer40)/site/item/domExp/fcstType/incoterms/measure/plantSite/yyyymmdd/qty/createdBy 를 '^' 로 누적 join
    ⑤ sASFromSite = cboAS.Checked ? clbSalesSite(콤마
    ^) : ''; AS 체크인데 값이 'ALL' 이면 MSG00366 return
    ⑥ iCount>0 이면 FoxData SAVE(CommandTimeout 10분) 비동기 호출(위 ^-payload 파라미터)
    ⑦ 응답 Tables.Count!=0 이면 Tables[0][0][0] 반환메시지 표시 + Tables[1] 행 있으면 DMF0003_SspSyncPopUp.LoadData(table,'40') ShowDialog(동기화수량보다 작게 수정된 내역)
    ⑧ Tables 비었으면 MSG00004(iCount 건) 표시 + 현재 top row 보존한 채 FindData() 재조회 + top row 복원 + base.IsChange=false
    catch: GMessageBoxForException, finally: dtSaveFinal.Clear
    ⑨ iCount==0 이면 MSG00034

---
## 2. 버튼 인벤토리 (17) — AS-IS 실측

| # | 버튼 | 위치 | 동작 | 연결 SP/팝업 | MSG | 활성/권한 | 라인 |
|---|---|---|---|---|---|---|---|
| 1 | Find / Retrieve (common toolbar) | toolbar (BaseForm common CRUD) | FindButton() -> FindData(): validate + async FoxData query + bind grid | DM FoxData query SP (via FoxAsyncProxy); ProgressForm | MSG00097 (no division), MSG00108 (period order), MSG00164 (>3yr span) | Always (button code SEARCH/RETRIEVE via common toolbar) | 768-773 / 1199-1462 |
| 2 | Insert (common toolbar) | toolbar | InsertButton() -> InsertRow() |  |  | UnFilterInsertRow=true (insert allowed while grid filtered) | 775-778 |
| 3 | Delete (common toolbar) | toolbar | DeleteButton() -> if active row action=='I' delete row |  |  | Only deletes inserted ('I') rows; persisted rows ignored | 780-786 |
| 4 | Edit (common toolbar) | toolbar | EditButton() -> SwitchLock + lock past-period columns per bucket type |  | MSG00113 (missing required cols), MSG00259 (no data queried) | Requires queried data; required-column set differs by Division 81/82/40 | 788-1188 |
| 5 | Save (common toolbar) | toolbar | SaveButton() -> SaveData(): build dtSaveFinal, async DM save SP; SSP sync opens popup | DMF0003_SspSyncPopUp (L1612) | MSG00043, MSG00034, MSG00366, MSG00004 | Edit mode; async void | 1190-1193 / 1464-1662 |
| 6 | Excel (common toolbar) | toolbar | ExcelButton override is COMMENTED OUT (ExcelButtonWithoutCopy) -> falls back to BaseForm default excel export |  |  | Default base behavior (local override disabled) | 5878-5881 (commented) |
| 7 | btnColumn 'Column Show' | form (search/condition area) | Open column-set popup (mode=true); on OK InitSpread() | DM0002_TitleSetForm_Popup('DMF0003', shtMain, true, Division) |  | Always; tooltip 'Column Show' | 582 (wire) / 4697-4708 |
| 8 | btnMeasure 'Measure' | form (search/condition area) | Open measure-set popup (mode=false); on OK InitSpread() | DM0002_TitleSetForm_Popup('DMF0003', shtMain, false, Division) |  | Always; tooltip 'Measure' | 545 (wire) / 4710-4721 |
| 9 | btnProject '...' | form (Project field) | Open project selector; set txtProject.Text | SCM0002_ProjectbyDivisionPopupEx |  | Disabled when Division==40 (Enabled=false in InitControls/cboDivision change) | 618 (wire) / 4650-4671 |
| 10 | btnItemId '...' | form (Model field) | Open item selector; set txtItemId.Text | DM0002_ItembyDivisionPopupEx |  | Always | 688 (wire) / 4673-4695 |
| 11 | btnOwner '...' | form (Owner field) | Open owner selector; set txtOwner.Text | DM0020_OwnerbyDivisionPopup |  | Always | 356 (wire) / 5374-5393 |
| 12 | btnIncotermsChg 'Master Chg' | form (right side) | Open master-change popup (Incoterms/master adjust) | DMF0003_MatsterChgPopup |  | Visible+Enabled only ADMIN / DM ADMIN / DM Planner (DefineProperty L550-570); hidden otherwise | 393 (wire) / 5359-5372 |
| 13 | Request_PR (context menu 'Request PR') | grid-context (contextMenuStrip1) | Validate selection (BNPIn, date col, no actual period, single project, unique models) then open PR request popup with '^'-joined multi-cell payload | DMF0003_PRPopup | MessageBox literals | Selection must be BNPIn measure rows on future date columns | 89/1420 (decl) / 5550-5694 |
| 14 | View_PR (context menu 'View PR') | grid-context | Single BNPIn date cell -> open PR view popup | DMF0003_PRPopup | MessageBox literals | Exactly 1 cell, BNPIn measure, date column | 90/1426 (decl) / 5695-5750 |
| 15 | Add_History (context menu 'Add History') | grid-context | Single BNPIn date cell -> open PR popup (add history) | DMF0003_PRPopup | MessageBox literals | Exactly 1 cell, BNPIn measure, date column | 91/1432 (decl) / 5695-5750 |
| 16 | View_History (context menu 'View History') | grid-context | Single BNPIn date cell -> open PR history popup | DMF0003_PRHistoryPopup | MessageBox literals | Exactly 1 cell, BNPIn measure, date column | 92/1438 (decl) / 5737-5743 |
| 17 | btnCutOff / Version (Cut-Off) — LEGACY/DISABLED | form (layoutControlItem6=Version, layoutControlItem7) | btnCutOff_Click fully COMMENTED OUT (would open VersionCutOffPopUp). Only layout item Visibility toggled for ADMIN/DM ADMIN/DM Planner | GSCM.DM.Plan.UIL.POPUP.VersionCutOffPopUp (commented) |  | layoutControlItem6 Always for ADMIN/DM ADMIN; item7 for DM Planner too; underlying button inactive | 4731-4754 (commented); visibility L548-568 |

---
## 3. 조회조건 컨트롤 (19) — AS-IS 실측

| # | 컨트롤 | 라벨 | 유형 | 초기상태 | Division 분기 | Cascade | 기본값 | 라인 |
|---|---|---|---|---|---|---|---|---|
| 1 | clbDivision | Division | combo (UsrCombo, single-select) | enabled/visible; loaded from MyDivision master | Root selector; ControlValues drive 40 vs 81xx vs 82 branching everywhere | SelectedIndexChanged(cboDivision_SelectedIndexChanged) -> resets spread + rebuilds Team/EndCustomer/SalesSite/BizType/EDISender/PlantSite; toggles Project/PlantSite/CellQty/checkInvalidExec | first user division | designer L58/986; wire L575; body L2074 |
| 2 | clbTeam | Team | checkbox-list (UsrCheckedList) | enabled/visible; loaded UserTeamByDivision | Used as dept key; for 40 team is the customer-fetch key | SelectedIndexChanged(clbTeam_SelectedIndexChanged) -> re-query EndCustomer + SalesSite | ALL | designer L57/948; wire L960; body L2212 |
| 3 | clbCustomer | End Customer | checkbox-list (UsrCheckedList) | enabled/visible; loaded EndCustomerByDivision | 40 loads via EndCustomerByDivision(team); 81/82 via UserEndCustomerByDivisionDept | SelectedIndexChanged(clbCustomer_SelectedIndexChanged) -> re-query SalesSite (GetSalesSite/40 with AS flag) | ALL | designer L56/908; wire L920; body L2250 |
| 4 | clbBizType | Biz Type | checkbox-list (UsrCheckedList) | enabled/visible; label lblBizType Enabled=true | 40 -> Data.Type BizType master; others -> GetBizTypebyDivision | rebuilt on Division change / in-grid Division combo change | ALL | designer L55/869 |
| 5 | clbSalesSite | Sales Site | checkbox-list (UsrCheckedList) | enabled/visible; loaded UserSiteByEndCustomer | 40 -> GetSalesSite40 / ScmSitebyEndCustomer40; 81/82 -> GetSalesSite / UserSiteByEndCustomer | Re-queried by Team, Customer, and AS checkbox changes | ALL | designer L53/796 |
| 6 | clbPlantSite | Plant Site | checkbox-list (UsrCheckedList) | enabled only for Division containing 81; disabled/cleared for 40 and 82 | 40: lblPlantSite disabled + cleared; 82: disabled + cleared; 81: UserPlantSiteByEndCustomer | loaded when Division 81 selected | ALL / empty | designer L45/497; enable logic L442,463,2179,2186 |
| 7 | clbItemType | Item Type | checkbox-list (UsrCheckedList) | enabled/visible; loaded GetItemType | none | static (loaded once in InitControls L523-524) | ALL | designer L43/421 |
| 8 | clbEDISender | Sender Code | checkbox-list (UsrCheckedList) | lblEDISender.Enabled=false by default | Enabled ONLY when Division==81 (EdiSender / EDI_SENDER_CODE); disabled otherwise | loaded via SetChangeControl('EdiSender') on Division 81 | ALL | designer L95/1514; enable L481-487, 2188-2191 |
| 9 | txtProject (+ btnProject) | Project | text + modal (UsrMultiLineEditor) | enabled; lblProject/btnProject disabled when Division==40 | 40: Project disabled; 81/82: enabled | cleared on Division change; set by btnProject popup | empty | designer L49/645; disable L442,462,2104,2137 |
| 10 | txtItemId (+ btnItemId) | Model / Nickname | text + modal (UsrMultiLineEditor) | enabled/visible | none | cleared on Division change; set by btnItemId popup | empty | designer L54/834; label lblModel L1172 |
| 11 | txtOwner (+ btnOwner) | Owner | text + modal (UsrMultiLineEditor) | enabled/visible | none | cleared on Division change; set by btnOwner popup | empty | designer L59/1021; label lblOwner L1313 |
| 12 | cboBucketType | Bucket | combo (UsrCombo DropDownList: Daily/Weekly/Monthly) | enabled; default Weekly (DefineProperty L536) | 82 -> Daily default (OnShown); others -> Weekly | SelectedIndexChanged -> SetSpreadColumn/green border/re-edit; Click -> block if inserted rows (MSG00227) | Weekly (Daily for 82) | designer L51/716; wire L576/725/726 |
| 13 | drpPeriod | Period | date range (UsrDateRangePicker) | enabled; InitValue = GetDayRange() | none | validated in FindData: start<=end (MSG00108), span<=3yr (MSG00164) | GetDayRange() (L521) | designer L52/728 |
| 14 | chkSum | Sum | checkbox (UsrCheckBox) | enabled; reset to false in InitControls (L497) | none | CheckedChanged -> SetSpreadColumn() (toggle SUM columns) | N (unchecked) | designer L44/459; wire L469 |
| 15 | chkColor | Color | checkbox (UsrCheckBox) | enabled; reset to false in InitControls (L496) | none | CheckedChanged -> SetSpreadColumn() (recolor); also gates green current-period border logic | N (unchecked) | designer L37/226; wire L236 |
| 16 | cboAS | AS | checkbox (UsrCheckBox) | enabled; forced Checked=true + Enabled=false for group 'DM Planner (W/S)' (OnShown) | PARAM5 (Y/N) to SiteByEndCustomer / SiteByEndCustomer40 | CheckedChanged -> re-query SalesSite (GetSalesSite/40) | N (Y+locked for W/S planner) | designer L38/263; wire L273; body L5865 |
| 17 | cboQty | Qty≥0 | checkbox (UsrCheckBox) | enabled/visible | none (query filter flag: only qty>=0) | no handler wired (read as filter param at query time) | N (InitValue 'N') | designer L40/311 |
| 18 | cboCellQty | Cell Qty | checkbox (UsrCheckBox) | enabled ONLY when Division==40; disabled+unchecked otherwise | 40: Enabled=true; else Enabled=false, Checked=false (InitControls L445,465; cboDivision L2107,2140) | no CheckedChanged handler (read as query flag) | N | designer L60/1055 |
| 19 | checkInvalidExec | MKT FCST 미등록 제외 | checkbox (DevExpress CheckEdit) | disabled by default | 82: Enabled=true + Checked=true; 40 and others: Enabled=false, Checked=false | no handler (read in FindData/compare as 'Y'/'N' PARAM) | N (Y+enabled for 82) | designer L39/278; logic L447,471-477,2133,2177-2185 |