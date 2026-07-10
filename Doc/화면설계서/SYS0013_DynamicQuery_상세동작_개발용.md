# SYS0013 Dynamic Query — 상세 동작 (개발용)

> **AS-IS 정본**: `GSCM\06.UIL\GSCM.SCM.Master.UIL\SCM0005_DynamicQueryList.cs`(1,255줄) + `.Designer.cs`(957줄) / `POPUP\SCM0005_DynamicQueryListPopUp.cs`(782줄) + `.Designer.cs`(666줄)  
> **DB 실측**: 사내 Oracle(SCM_MGR@OCGSCMD_P01) — PKG_SYS0013(멤버 10) + standalone 34객체 ALL_SOURCE 전문 + AS-IS MSSQL(LGCE_SCMDEV) 원본 16종 교차  
> **생성**: 2026-07-09 · hook #105 §3 · 이벤트 전수 ①→②③ 실제 발생순서(핸들러+호출메서드 1-depth)  
> **짝 산출물**: `SYS0013_DynamicQuery_UI분석서_v1.0.xlsx` (10시트, User 관점 가독본)

**전수 카운트**: 이벤트 11(메인)+12(팝업)=23 · 데이터접근 활성 16+9=25 (주석 8+1) · Validation 22(main 12/popup 10) · SP 제약 60(PKG)+167(standalone)=227행 · MSSQL 교차 16종/격차 11건

---

## 0. 화면 개요 (개발자용 요약)

- **AS-IS**: SCM0005 Dynamic Query List — 관리자/개발자용 동적 쿼리 도구. Register 탭(쿼리 목록 CRUD) + View 탭(선택 쿼리의 Column/Condition 구성 + SQL 뷰어 + 결과 그리드) + SQL Query 팝업(신규/상세 편집).
- **TO-BE**: `features/admin/src/pages/dynamic-query/` (SYS0013, MNU_URL=dynamic-query, 메뉴경로 Admin ▸ Admin_Menu ▸ Dynamic Query List). 시트 4종: main/columns/parameters/history.
- **AS-IS 저장 SQL은 MSSQL 문법**(`SELECT TOP 1000`, `[LGCE-SCMPROD].[DBO]`, `@PARAM_*`) — TO-BE는 Oracle 문법 SQL을 SCM_ADM_DQ_LIST에 보관·실행. 기존 27건 등록 데이터 전환 상태가 운영 포인트.
- **핵심 구조 차이**: AS-IS 팝업은 DB 직접 저장 없이 `DyamicSqlPopup`(clsData) 직렬화 문자열('^' 필드, '|' 행)을 부모 폼에 반환 → 메인 SaveButton이 PR_DM_ADM_DQ_* 4종 호출. TO-BE는 FE가 SAVE SP를 직접 호출.

---

## 1. 메인 폼 이벤트 상세 (전수 11)

_인벤토리 근거: 3중 대사(① .cs 핸들러 grep ② Designer.cs `+=` wiring ③ .cs 런타임 wiring) — `event_inventory_raw.json`. 주석 처리 wiring 2건(L1164/L1205 dsdm.Changed) 제외._

### 1.1 Form_Load  (L132)
- **트리거**: 화면 최초 로드 (생성자 L129 this.Load += Form_Load)
- **Division 분기**: 없음 (단, dtDivision 은 사용자 NowGroupID 기준 MyDivision 콤보 데이터를 선적재 — 이후 Where VALUE 콤보 분기에서 사용)
- **실제 발생 순서**:
  **0** 생성자 이전 필드 초기화 시점에 공통 콤보 2종 선조회: dtYesOrNo=Data.Common(Data.Type.YesOrNo), dtDataType=clsQuerys.mDataType()  _(L37-38 · `(field initializer)`)_
  **1** clsCtrl = new CControl(this) — 폼 컨트롤 헬퍼 생성  _(L134 · `Form_Load`)_
  **2** InitForm() 호출 — 본 파일에 정의 없음(BaseForm 상속 공통 초기화)  _(L136 · `InitForm(BaseForm)`)_
  **3** InitControls() 전개: dtRole=clsQuerys.GetCommonDataByDB("ROLES") 조회 후 Register 탭 clbRole·View 탭 clbRoleResult 체크리스트에 동일 바인딩 (setListBox 3번째 인자 true)  _(L145-151 · `InitControls` · SP `GetCommonDataByDB('ROLES')`)_
  **4** DefineProperty() 전개: dtDivision=Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserId), dtSalesSite=Data.UserSiteByEndCustomer(NowGroupID, UserId, "ALL", "ALL") — View 탭 Where VALUE 셀 콤보 원천 선적재  _(L157-164 · `DefineProperty`)_
  **5** CreateSpread() 전개: AddSheet 4개 — spdMain(DynamicList,1,1,30) / fpResult(DynamicResult,1,1,30) / fpWhere(DynamicWhere,2,1,45) / fpGroup(DynamicGroup,2,1,45)  _(L174-178 · `CreateSpread`)_
  **6** GetSheetInfo 4개(siMain/siResult/siWhere/siGRoup) 취득 후 siMain.ChangeSheet()  _(L181-187 · `CreateSpread`)_
  **7** InitSpread_Register() → InitSpread_Group() → InitSpread_Where() → InitSpread_Result() 순서로 4개 시트 컬럼 정의 (grids 섹션 전수 참조)  _(L189-193 · `CreateSpread`)_
  **8** fps = siMain.SpreadObject (BaseForm 활성 spread 지정)  _(L195 · `CreateSpread`)_
  **9** dsdmWhere(DynamicWhere 시트 DataModel).Changed += DsdmWhere_Changed / dsdmGroup(DynamicGroup).Changed += DsdmGroup_Changed 런타임 wiring  _(L198-203 · `CreateSpread`)_
- **비고(AS-IS 사실)**: AS-IS: 로드 시 조회 없음(그리드 빈 상태). 콤보 원천 5종(YesOrNo/DataType/ROLES/MyDivision/UserSiteByEndCustomer)만 선적재하고 시트 4개 골격 생성.

### 1.2 FindButton (override)  (L285)
- **트리거**: 조회 버튼(BaseForm 표준 버튼 슬롯) 클릭
- **Division 분기**: 없음 (Register 조회 파라미터에 DIVISION 없음. View 실행 SQL 은 사용자가 저장한 쿼리 그대로)
- **실제 발생 순서**:
  **1** IsChange = false (변경플래그 해제)  _(L287 · `FindButton`)_
  **2** FindData(true) 호출 (async void). tabQuery.SelectedIndex 로 Register/View 분기  _(L288 · `FindButton→FindData`)_
  **3** [Register 탭, SelectedIndex==0] ProgressForm 표시 → CanModelChange=false → InitSpread_Register() 시트 재초기화  _(L333-337 · `FindData`)_
  **4** [Register 탭] FoxAsyncProxy(ShowProgress=false)로 목록 SP 비동기 호출. 파라미터: p_dq_id=txtDescription.Text(소스 주석 원문: 'p_dq_id이 Description임' — 파라미터명과 실값 불일치 원본 그대로), p_dq_name=umltReportName.Text, p_role=clbRole.ControlValues. CommandTimeout=600초  _(L339-355 · `FindData` · SP `DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST`)_
  **5** [Register 탭] siMain.Query(ds) 바인딩 → siMain.LockColumn(0~MaxCol, true) 전체 잠금(조회모드)  _(L357-358 · `FindData`)_
  **6** [Register 탭] blnInsert==false 인 경우(저장 후 재조회)만 마지막 수정 셀(iUpdateRow, iUpdateCol)로 ActiveCell 이동 + ShowActiveCell(Center). FindButton 경로는 blnInsert=true 라 이동 없음. prg.Close, CanModelChange=true  _(L364-371 · `FindData`)_
  **7** [View 탭, SelectedIndex==1] siMain.ActiveRowIndex==-1 이면 즉시 return (Register 에서 선택된 행 없으면 실행 불가)  _(L375-376 · `FindData`)_
  **8** [View 탭] sSql=선택행 DQ_TEXT 취득 → siGRoup 시트를 clsQuerys.GetDatatableFromSpread 로 DataTable 변환 후 SEQNO ASC 정렬  _(L386-392 · `FindData`)_
  **9** [View 탭] SELECT 절 조립: Group 행 순회 — USE=='N' 제외. TYPE=='System.String' 이면 컬럼명을 SELECT·GROUP BY 양쪽에 추가, 그 외(숫자형)는 AGGREGATE(기본값 SUM)를 적용해 'AGG(col) AS col' 형태로 SELECT 에만 추가. 말미 콤마 제거  _(L394-420 · `FindData`)_
  **10** [View 탭] WHERE 절 조립: '1=1 ' 시작, siWhere 행 순회 — USE=='N' 제외. Column 값에 '@' 포함 시 WHERE 에 넣지 않고 nvcParameter[컬럼]=VALUE 로 치환용 수집. 그 외 OPORATOR(공백이면 '=') 분기: '='/'>'/'<' → N'값', 'IN' → 콤마 split 하여 (N'v1',N'v2',...), 'LIKE' → N'값%'  _(L422-471 · `FindData`)_
  **11** [View 탭] FindData_Result() 1-depth: WITH #tmpTable AS ({원본SQL}) SELECT {컬럼} FROM #tmpTable WHERE {조건} GROUP BY {그룹} 템플릿을 .ToUpper() 로 조립. SQL 내 '@PARAM' 토큰 존재 시 구분자(공백/CR/LF/,/]/)/+/&) 로 파라미터명 추출 → Sort → 중복제거 → 역순으로 치환: nvcParameter 값 있으면 N'값', 없으면 N'' 로 대체  _(L638-698 · `FindData_Result`)_
  **12** [View 탭] 동적 SQL 실행: v_sql_text=Substitute(sFinalSql) — Substitute(L1214)는 SELECT/FROM/WHERE/UPDATE/JOIN/AND/GROUP BY/UNION ALL/UNION/ORDER BY 예약어를 사전정의 고정 토큰 문자열로 치환해 전송(서버측 복원 전제). CommandTimeout=600초. 전체 try{}catch{} — 실패해도 오류 표시 없이 진행  _(L494-515 · `FindData` · SP `DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2`)_
  **13** [View 탭] 실행 이력 기록: p_DQ_ID=lbl_DQ_ID.Text, p_DQ_TEXT=Substitute(sFinalSql), p_CREATED_BY=UserId, p_LAST_UPDATED_BY=DateTime.Now(파라미터명은 UPDATED_BY 이나 실값은 현재시각 — 원본 그대로). try{}catch{} 무시  _(L517-539 · `FindData` · SP `DM_H.PR_DM_ADM_DQ_EXECUTE_HIST`)_
  **14** [View 탭] rtxtSQL.Text=sFinalSql (치환 전 최종 SQL 원문 표시) → InitSpread_Result() 초기화 → siResult.SpreadObject.DataSource=ds 로 결과 동적 바인딩(컬럼 자동 생성) → CUIControl.SetPreferredWidth 로 컬럼폭 자동 조절. 수동 동적 컬럼 생성 로직(L548-584)은 전부 주석 처리 상태. finally 에서 CanModelChange=true, prg.Close  _(L541-600 · `FindData`)_
- **비고(AS-IS 사실)**: AS-IS: 탭 위치에 따라 완전히 다른 2개 동작 — Register=리포트 목록 조회, View=선택 리포트의 동적 SQL 조립·실행·이력기록. View 실행 실패는 catch{} 로 침묵.

### 1.3 InsertButton (override)  (L291)
- **트리거**: 신규 버튼(BaseForm 표준 버튼 슬롯) 클릭
- **실제 발생 순서**:
  **1** InsertRow() 호출  _(L293 · `InsertButton`)_
  **2** 가드: siMain!=null && siMain.IsLock(SheetName)==false (Edit 모드) && SheetName=="DynamicList" 일 때만 동작 — 조회모드(잠금)에서는 무동작  _(L944-946 · `InsertRow`)_
  **3** siMain.Insert() 로 신규 행 추가 (action 컬럼 'I')  _(L948 · `InsertRow`)_
  **4** 신규 행의 ROLE(GROUP_NAME) 셀 LockRange 잠금 + CREATED_BY~ADMIN_ONLY_YN 구간 LockRange 잠금 (신규 행에서 직접 입력 불가 — Role 은 팝업에서 지정)  _(L951-952 · `InsertRow`)_
  **5** 기본값 SetValue: VALID_YN='Y', ADMIN_ONLY_YN='Y'  _(L955-959 · `InsertRow`)_
- **비고(AS-IS 사실)**: AS-IS: Edit 모드에서만 행 추가 가능. 신규 행 Role·감사컬럼 잠금 + Valid/Admin 기본 'Y'.

### 1.4 DeleteButton (override)  (L296)
- **트리거**: 삭제 버튼(BaseForm 표준 버튼 슬롯) 클릭
- **실제 발생 순서**:
  **1** siMain.Delete() — 현재 행 삭제 표시(action 'D'). 확인 메시지·가드 없음(SpreadInfo 공통 동작에 위임). 실 DB 삭제는 SaveButton 의 PR_DM_ADM_DQ_CREATE(p_active_flag='D') 시점  _(L298 · `DeleteButton`)_
- **비고(AS-IS 사실)**: AS-IS: 그리드 행 삭제 마킹만. 저장 시 D 플래그로 SP 전달. D 행은 하위(Role/Column/Parameter) 저장 로직 skip(L814-822, 하위 테이블 삭제 SQL 은 주석 처리 상태).

### 1.5 EditButton (override)  (L301)
- **트리거**: 수정(Edit) 버튼(BaseForm 표준 버튼 슬롯) 클릭
- **실제 발생 순서**:
  **1** 가드: tabQuery.SelectedIndex==0 (Register 탭)일 때만 동작. View 탭에서는 무동작  _(L304 · `EditButton`)_
  **2** fps=siMain.SpreadObject 재지정 후 siMain=GetSheetInfo(spdMain.Name, ActiveSheetIndex) 재취득  _(L306-307 · `EditButton`)_
  **3** siMain.SwitchLock() — 조회(전체잠금)↔편집 상태 토글  _(L308 · `EditButton`)_
  **4** 편집 전환 후에도 변경 불가 컬럼 재잠금: ROLE(GROUP_NAME) 컬럼 LockColumn + CREATED_BY~ADMIN_ONLY_YN 컬럼 구간 LockColumn (행 단위 LockRange 버전은 주석 처리 상태)  _(L310-313 · `EditButton`)_
- **비고(AS-IS 사실)**: AS-IS: Register 탭 전용 편집 토글. Role·감사컬럼·Admin 플래그는 그리드 직접 편집 금지(팝업/서버 채움).

### 1.6 SaveButton (override)  (L318)
- **트리거**: 저장 버튼(BaseForm 표준 버튼 슬롯) 클릭
- **Division 분기**: 없음 (p_DIVISION_ID 는 그리드 숨김컬럼 값을 그대로 전달)
- **실제 발생 순서**:
  **1** SaveData() 호출 (async void)  _(L320 · `SaveButton`)_
  **2** 가드: siMain!=null && IsLock==false(Edit 모드) 필수, SheetName!="DynamicList" 이면 return. sUserId=base.UserInfo.UserId  _(L744-750 · `SaveData`)_
  **3** 1차 Validation 루프는 빈 구현 (L754-758 '필수 값 체크 로직' 주석만 존재 — 실제 검증 없음, 원본 그대로)  _(L753-758 · `SaveData`)_
  **4** 행 순회: action=GetText(i,0). 'I' 존재 시 blnInsert=true. I/M/D 외 행 skip. 처리행마다 iCUD++, iUpdateRow=i  _(L764-779 · `SaveData`)_
  **5** ① 마스터 저장 SP 행 단위 await 호출 (10 params: p_active_flag=action, p_DQ_ID, p_DIVISION_ID, p_DQ_NAME, p_DESCRIPTION, p_DQ_TEXT, p_VALID_YN, p_ADMIN_ONLY_YN, p_CREATED_BY=sUserId, p_LAST_UPDATED_BY=sUserId). CommandTimeout=600초  _(L780-800 · `SaveData` · SP `DM_H.PR_DM_ADM_DQ_CREATE`)_
  **6** 응답 마지막 테이블 [0][0] 이 'success' 아니면 throw Exception(메시지 원문) — 이후 행 처리 중단  _(L802-806 · `SaveData`)_
  **7** action=='I' 이면 sDB_ID=응답 [0][1](서버 채번 신규 DQ_ID), 그 외에는 그리드 DQ_ID 사용. action=='D' 이면 하위 저장 없이 continue(하위 테이블 삭제 SQL 은 주석 처리 상태)  _(L808-822 · `SaveData`)_
  **8** ② Role 매핑 저장 (동기 호출): p_DQ_ID=sDB_ID, p_GROUP_ID=그리드 ROLE_ID(GROUP_ID), p_VALID_YN='Y', p_CREATED_BY/p_LAST_UPDATED_BY=sUserId  _(L824-843 · `SaveData` · SP `DM_H.PR_DM_ADM_DQ_CREATE_USER_GROUP`)_
  **9** ③ 컬럼 저장: 숨김컬럼 COMUMNS 문자열(팝업이 '|'/'^' 인코딩으로 채움)을 clsQuerys.mGetGroupDataByPopUp 로 DataTable 파싱, A(action)∈{I,M,D} 행만 반복 호출 (9 params: p_active_flag, p_DQ_ID=sDB_ID, p_COLUMN_NAME, p_VALUE_YN='Y'(char 고정), p_VALUE_TYPE, p_VALID_YN, p_SEQNO, p_CREATED_BY, p_LAST_UPDATED_BY)  _(L845-879 · `SaveData` · SP `DM_H.PR_DM_ADM_DQ_CREATE_COLUMN`)_
  **10** ④ 파라미터 저장: 숨김컬럼 PARAMETERS 문자열을 clsQuerys.mGetWhereDataByPopUp 로 파싱, A∈{I,M,D} 행만 반복 호출 (11 params: p_active_flag, p_DQ_ID=sDB_ID, p_PARAMETER_ID, p_PARAMETER_TYPE(원천은 TYPE 열), p_OPERATION_ID=''(빈값 고정), p_VALID_YN, p_SEQNO, p_REP_YN=''(빈값 고정), p_CREATED_BY, p_LAST_UPDATED_BY)  _(L882-917 · `SaveData` · SP `DM_H.PR_DM_ADM_DQ_CREATE_PARAMETER`)_
  **11** 완료 메시지: MessageHelper.GMessageBox("MSG00004", {iCUD}) — '{0}개의 데이터가 저장되었습니다'  _(L923 · `SaveData` · MSG MSG00004)_
  **12** 저장 후 재조회: blnInsert(신규 포함) 이면 FindData(true), 아니면 FindData(false, iUpdateRow, ActiveColumnIndex) — 마지막 수정 셀로 포커스 복원  _(L926-929 · `SaveData→FindData` · SP `DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST`)_
- **비고(AS-IS 사실)**: AS-IS: 행 단위 4-SP 체인(마스터→Role→컬럼N→파라미터N) 순차 호출. 마스터만 성공 검사('success' 문자열), 하위 3 SP 는 결과 미검사. Role/Column/Parameter 원천은 팝업이 채운 숨김컬럼 문자열.

### 1.7 spdMain_CellDoubleClick  (L969)
- **트리거**: Register 탭 메인 그리드 셀 더블클릭 (Designer L148 wiring)
- **Division 분기**: 있음 — Setting_ViewTab Where VALUE 콤보 분기: PARAMETER_TYPE=='Combo' && PARAMETER_ID=='DIVISION_ID' → dtDivision(Data.Common MyDivision, NowGroupID+UserId 기준), =='SCM_SITE_ID' → dtSalesSite(Data.UserSiteByEndCustomer). 그 외 컬럼명은 콤보 미지정
- **실제 발생 순서**:
  **1** 가드: siMain.Sheet().Rows.Count<=0 이면 return  _(L971-972 · `spdMain_CellDoubleClick`)_
  **2** [조회모드 IsLock==true 분기] action(0열)=='I'(미저장 신규행)이면 return → tabQuery.SelectTab(1) View 탭 강제 전환 → lbl_DQ_ID.Text=선택행 DQ_ID(숨김 Label 보관, 이후 EXECUTE_HIST 파라미터) → Setting_ViewTab((int)DQ_ID, e.Row) 호출  _(L974-990 · `spdMain_CellDoubleClick`)_
  **3** [Setting_ViewTab 전개-1: Group] CanModelChange=false → InitSpread_Group() 재초기화(기존 행 CELL TYPE 잔존 방지 주석) → GroupData(dq_id) 로 컬럼 목록 조회(p_dq_id) → siGRoup.Query(ds) → LockColumn(0~max-3) 앞쪽 잠금 → AGGREGATE~USE 구간 LockRange 해제  _(L1029-1043 · `Setting_ViewTab→GroupData` · SP `DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS`)_
  **4** [Setting_ViewTab 전개-2: Group 행별] TYPE=='System.String' 이면 AGGREGATE='Group' 고정 텍스트 + 해당 셀 잠금 / 그 외에는 AGGREGATE 셀을 GetCommonDataByDB("AGGREGATE") 콤보로 교체 + 기본값 'SUM'. SEQNO=='0' 이면 (i+1) 자동 채번. USE='Y' 기본  _(L1044-1063 · `Setting_ViewTab` · SP `GetCommonDataByDB('AGGREGATE')`)_
  **5** [Setting_ViewTab 전개-3: Where] InitSpread_Where() → ParameterData(dq_id) 로 파라미터 목록 조회(p_dq_id) → siWhere.Query(ds) → LockColumn(0~max-3) 잠금 → OPORATOR~끝 LockRange 해제  _(L1067-1074 · `Setting_ViewTab→ParameterData` · SP `DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS`)_
  **6** [Setting_ViewTab 전개-4: Where 행별] OPORATOR 셀을 GetCommonDataByDB("OPORATOR") 콤보로 교체 + 기본 '=' 후 해당 셀 즉시 재잠금(소스 주석 'PARAMETER 는 LOCK'). USE='Y'. TYPE 별 VALUE 셀 타입 분기: 'Combo'→COLUMN=='DIVISION_ID' 면 dtDivision 콤보 / =='SCM_SITE_ID' 면 dtSalesSite 콤보, 'DateTime'→DateTime 셀, 'Number'→Number 셀  _(L1075-1106 · `Setting_ViewTab` · SP `GetCommonDataByDB('OPORATOR')`)_
  **7** [Setting_ViewTab 전개-5] View 탭 상단 컨트롤 채움: umltReportNameResult=DQ_NAME, txtDescrptionResult=DESCRIPTION, clbRoleResult.ControlValues=ROLE_ID, rtxtSQL=DQ_TEXT → InitSpread_Result() 결과 그리드 clear → CanModelChange=true  _(L1109-1119 · `Setting_ViewTab`)_
  **8** [편집모드 IsLock==false 분기] SCM0005_DynamicQueryListPopUp(SQL Query 팝업) 생성 → clsData(DyamicSqlPopup)에 선택행 8필드 전달: sDq_ID/sReport_Name(DQ_NAME)/sDes(DESCRIPTION)/sSql(DQ_TEXT)/sRole_ID(GROUP_ID)/sRole_Name(GROUP_NAME)/sColumns(COMUMNS)/sParameters(PARAMETERS)/sFlag(POPUPFLAG) → popup.LoadData(clsData) → ShowDialog() 모달  _(L992-1009 · `spdMain_CellDoubleClick`)_
  **9** [편집모드] 팝업 복귀 후 clsData.sFlag!='' 이면 그리드 8컬럼 SetText 역반영: DQ_NAME/DESCRIPTION/DQ_TEXT/GROUP_NAME/GROUP_ID/COMUMNS/PARAMETERS/POPUPFLAG (SetText → action 'M' 마킹은 Spread 공통 동작)  _(L1011-1021 · `spdMain_CellDoubleClick`)_
- **비고(AS-IS 사실)**: AS-IS 핵심 이벤트: 조회모드 더블클릭=View 탭 전환+실행조건 시트 구성, 편집모드 더블클릭=SQL 정의 팝업 왕복 편집. 동일 제스처가 잠금 상태에 따라 상반된 2 기능.

### 1.8 fpGroup_CellDoubleClick  (L1122)
- **트리거**: View 탭 Group(Column) 그리드 셀 더블클릭 (Designer L467 wiring)
- **실제 발생 순서**:
  **1** 빈 구현 — 본문은 주석 '//siGRoup.' 1줄뿐, 실행 로직 없음 (원본 그대로)  _(L1122-1125 · `fpGroup_CellDoubleClick`)_
- **비고(AS-IS 사실)**: AS-IS: 배선만 존재하는 무동작 핸들러.

### 1.9 DsdmWhere_Changed  (L1127)
- **트리거**: View 탭 Where 시트(DynamicWhere) 셀 값 변경 (.cs L199 런타임 wiring)
- **실제 발생 순서**:
  **1** 가드: e.Column<0 || e.Row<0 이면 return (소스 주석: IsLockCell 에 -1 전달 시 이후 InitSpread 에러 방지). IsEditMode/CanModelChange/IsLock 가드는 전부 주석 처리 상태  _(L1139-1140 · `DsdmWhere_Changed`)_
  **2** e.Type==CellsUpdated 이면 IsChange=false 설정 (그 외 타입은 무동작). Where 시트 편집이 폼 변경플래그를 세우지 않도록 해제 — 실행조건 편집은 '저장 대상 변경' 으로 취급하지 않음  _(L1144-1156 · `DsdmWhere_Changed`)_
  **3** catch 는 throw ex 재던짐, finally 는 주석뿐(재구독 코드 주석 처리)  _(L1158-1165 · `DsdmWhere_Changed`)_
- **비고(AS-IS 사실)**: AS-IS: Where 시트 셀 수정 시 IsChange 플래그를 false 로 되돌려 화면 이탈/조회 시 '변경사항 있음' 경고가 뜨지 않게 함.

### 1.10 DsdmGroup_Changed  (L1168)
- **트리거**: View 탭 Group 시트(DynamicGroup) 셀 값 변경 (.cs L203 런타임 wiring)
- **실제 발생 순서**:
  **1** DsdmWhere_Changed 와 동일 로직: e.Column<0||e.Row<0 return → CellsUpdated 시 IsChange=false → catch throw / finally 주석뿐  _(L1180-1206 · `DsdmGroup_Changed`)_
- **비고(AS-IS 사실)**: AS-IS: Group 시트(AGGREGATE/SEQNO/USE) 편집도 저장 대상 변경으로 취급하지 않음 (조회 실행 조건일 뿐).

### 1.11 tabQuery_SelectedIndexChanged  (L1209)
- **트리거**: Register/View 탭 전환 (Designer L200 wiring)
- **실제 발생 순서**:
  **1** 빈 구현 — 본문 없음 (원본 그대로). 탭 전환 자체에는 로직 없고, View 탭 진입 구성은 spdMain_CellDoubleClick 의 SelectTab(1)+Setting_ViewTab 이 수행, 탭별 동작 분기는 FindButton/EditButton 이 SelectedIndex 를 직접 검사  _(L1209-1212 · `tabQuery_SelectedIndexChanged`)_
- **비고(AS-IS 사실)**: AS-IS: 무동작 핸들러. 탭 상태는 다른 이벤트의 분기 조건으로만 사용.

---

## 2. SQL Query 팝업 이벤트 상세 (전수 12)

### 2.1 Form_Load  (L106)
- **트리거**: .cs L103 생성자에서 this.Load += Form_Load 런타임 배선 (폼 로드 시 1회)
- **Division 분기**: 없음 (DIVISION_ID 분기 없음)
- **실제 발생 순서**:
  **1** clsCtrl = new CControl(this) — 컨트롤 헬퍼 생성  _(108 · `Form_Load`)_
  **2** InitForm() — BaseForm 표준 초기화 (프레임워크)  _(110 · `InitForm`)_
  **3** InitControls() — clsQuerys.GetCommonDataByDB("ROLES") 로 dtRole 조회 후 clsCtrl.setListBox(dtRole, clbRole, true) 로 Role 체크리스트 바인딩  _(131 · `InitControls` · SP `clsQuerys.GetCommonDataByDB('ROLES') — 공통 코드 조회 (L134)`)_
  **4** DefineProperty() — this.IsPopup = true (팝업 선언)  _(152 · `DefineProperty`)_
  **5** CreateSpread() — AddSheet(spdMain,'XXXX',2,1,45) + AddSheet(fpWhere,'XXXX2',2,1,45), GetSheetInfo 로 siMain/siWhere 획득, InitSpread_Group()/InitSpread_Where() 로 컬럼 구성, siMain 데이터모델에 dsdm.Changed += Dsdm_Changed 배선 (L175)  _(158 · `CreateSpread`)_
  **6** FindData("LOAD") — 초기 데이터 로드 (하단 FindData LOAD 분기 참조)  _(115 · `FindData` · SP `LOAD 분기: DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST / _COLUMNS / _PARAMETERS`)_
- **비고**: FindData('LOAD') 2분기: ① clsData.sFlag != '' (부모 폼이 OK로 닫힌 팝업을 재오픈한 경우) → clsData 의 sReport_Name/sDes/sRole_ID/sSql 을 각각 txtReportName/txtDescription/clbRole/rtxtSQL 에 복원 후 GroupData()+ParameterData() SP 조회로 siMain/siWhere Query() 셋팅, 전체 LockColumn(0..max,true) 잠금 + CUIControl.SetPreferredWidth 폭 자동조절 (CanModelChange=false~true 로 감쌈). ② sFlag=='' → lbl_DQ_ID.Text=='' 이면 return 0 (신규 모드, 빈 팝업); DQ_ID 존재 시 DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST(p_dq_id=lbl_DQ_ID, p_dq_name='', p_role='') 호출 → Tables[0] 의 DQ_NAME/DESCRIPTION/DQ_TEXT 를 화면 셋팅, 전 행의 GROUP_ID 를 CString.AppendString 콤마 조립하여 clbRole.ControlValues 셋팅 → GroupData()+ParameterData() 로 스프레드 셋팅+잠금. 팝업 오픈 전 부모가 public LoadData(clsData) 호출하여 this.clsData 주입 + lbl_DQ_ID.Text=clsData.sDq_ID 셋 (L118~125).

### 2.2 Dsdm_Changed  (L177)
- **트리거**: .cs L175 CreateSpread() 내 siMain 시트 DefaultSheetDataModel.Changed += 런타임 배선 (siMain 데이터 변경 시)
- **실제 발생 순서**:
  **1** switch(e.Type) — default 케이스만 존재, 실동작 없음 (no-op 골격)  _(179 · `Dsdm_Changed`)_
- **비고**: 케이스가 default: break 뿐인 빈 스위치. siWhere 쪽에는 Changed 배선 자체가 없음.

### 2.3 FindButton (override)  (L193)
- **트리거**: BaseForm 표준 조회 버튼 슬롯 (팝업에서는 공통 버튼바가 아닌 자체 btnButtonList 를 쓰므로 실질 미사용)
- **실제 발생 순서**:
  **1** 본문 전체 주석 처리 (//FindData("FIND")) — no-op  _(195 · `FindButton`)_
- **비고**: SQL 검증(FindData('FIND'))은 팝업 상단 Confirm 버튼(btnButtonList)으로 이동됨.

### 2.4 InsertButton (override)  (L198)
- **트리거**: BaseForm 표준 슬롯 + btnButtonList Insert 버튼에서 직접 호출 (L485)
- **실제 발생 순서**:
  **1** InsertRow() 호출  _(200 · `InsertButton`)_
  **2** [InsertRow 1-depth] fps==null 이면 return (활성 스프레드 미지정 가드)  _(630 · `InsertRow`)_
  **3** [InsertRow] fps.Name=='spdMain' && siMain 비잠금(IsLock==false) && SheetName=='XXXX' → siMain.Insert() 로 행 삽입, 신규 행의 COLUMN_NAME 셀에 SetCellTypeCombo(dtCols: SQL 파생 컬럼목록), VALUE_TYPE 셀에 SetCellTypeCombo(dtTypes: SQL 파생 타입목록), 기본값 VALID_YN='Y' + SEQNO=행인덱스+1 SetValue  _(633 · `InsertRow`)_
  **4** [InsertRow] fps.Name=='fpWhere' && siWhere 비잠금 && SheetName=='XXXX2' → siWhere.Insert(), PARAMETER_TYPE 셀에 combo(dtDataType=clsQuerys.mDataType()), PARAMETER_ID 셀에 combo(dtCols), 기본값 VALID_YN='Y' + SEQNO=행인덱스+1  _(657 · `InsertRow`)_
- **비고**: dtCols/dtTypes 는 Confirm(FindData 'FIND') 성공 후에만 채워짐 — Confirm 없이 Insert 하면 콤보 원천이 null 인 상태로 SetCellTypeCombo 됨(AS-IS 잠재 결함). Edit 로 잠금 해제(SwitchLock) 전에는 IsLock 가드로 삽입 차단.

### 2.5 DeleteButton (override)  (L203)
- **트리거**: BaseForm 표준 슬롯 + btnButtonList Delete 버튼에서 직접 호출 (L491)
- **실제 발생 순서**:
  **1** fps.Name=='spdMain' 이면 siMain.Delete() (Column 그리드 활성행 삭제/Action 'D' 마킹), 아니면 siWhere.Delete() (Condition 그리드)  _(206 · `DeleteButton`)_
- **비고**: 활성 스프레드(fps) 기준 라우팅. 동일 로직의 private Delete_Button() (L499~507) 이 별도로 존재하나 어디서도 호출되지 않는 dead code.

### 2.6 EditButton (override)  (L214)
- **트리거**: BaseForm 표준 슬롯 + btnButtonList Edit 버튼에서 직접 호출 (L488)
- **실제 발생 순서**:
  **1** dtCols==null (SQL 미검증) 이면 FindData("FIND") 선행 수행, 반환 -1(검증 실패) 시 return — 편집 진입 차단  _(217 · `EditButton` · SP `FIND 분기: clsQuerys.GetDataByDB(SQL)` · MSG 간접: MSG00148 또는 'No SQL.'/'Error : ...')_
  **2** fps=siMain.SpreadObject 포커스 이동 → siMain 재획득 → siMain.SwitchLock() (잠금 토글=편집 활성화) → LockColumn(COLUMN_NAME~VALUE_TYPE, true) 로 Column/Type 컬럼은 잠금 유지 (콤보 선택 자동세팅 전용)  _(225 · `EditButton`)_
  **3** siMain 에 행이 없으면(GetMaxRowIndex()<0) dtCompareList 행수만큼 InsertRow() 반복 후, 각 행에 SetValue(i,1,CODE)=컬럼명, SetValue(i,2,NAME)=타입, SetValue(i,4,i+1)=SeqNo — SQL 검증 결과의 컬럼 목록을 자동 채움. CUIControl.SetPreferredWidth 로 폭 자동조절  _(232 · `EditButton`)_
  **4** fps=siWhere.SpreadObject 포커스 이동 → siWhere 재획득 → siWhere.SwitchLock() → LockColumn(PARAMETER_TYPE~PARAMETER_ID, true) 로 Type/Column 컬럼 잠금 유지  _(249 · `EditButton`)_
- **비고**: siMain 자동 채움은 '행이 하나도 없을 때만' 수행 (기존 리스트 존재 시 패스). L228 LockColumn 은 Edit 로 시트가 열린 뒤에도 NAME/TYPE 두 컬럼은 직접 타이핑 불가(콤보/자동세팅 경유)를 의도. L254~275 포커싱 재처리 로직은 전부 주석.

### 2.7 SaveButton (override)  (L278)
- **트리거**: BaseForm 표준 슬롯 (팝업 버튼바에 Save 버튼 없음 — btnButtonList 의 Save 케이스도 L493~495 주석)
- **실제 발생 순서**:
  **1** 본문 전체 주석 처리 (//SaveData()) — no-op. 실제 '저장' 의미 동작은 OK 버튼의 SetItem() (clsData 로 부모 폼 전달) 이 담당하고, DB 저장 SP 호출부는 미호출 dead code 인 mSave() (L509) 에 남아 있음  _(280 · `SaveButton`)_

### 2.8 btnButtonList_UsrButtonList_Click_Detected  (L470)
- **트리거**: Designer L334 btnButtonList.UsrButtonList_Click_Detected += del_EventHandler — 팝업 상단 버튼바 (버튼 6종: Confirm/Edit/Insert/Delete/OK/Close, Designer L296~331 buttonItem7~12)
- **실제 발생 순서**:
  **1** switch(buttonItem.UserType) 로 6개 버튼 분기 (하단 button_branches 전수)  _(472 · `btnButtonList_UsrButtonList_Click_Detected`)_
- **비고**: 버튼바 표시 순서(Designer UsrButtonItems.Add 순): Confirm → Edit → Insert → Delete → OK → Close. 모든 아이콘 표시(UsrIconVisible=true)+텍스트 표시.

### 2.9 fpWhere_CellDoubleClick  (L707)
- **트리거**: Designer L546 fpWhere.CellDoubleClick += CellClickEventHandler (Condition 그리드 셀 더블클릭)
- **실제 발생 순서**:
  **1** siWhere.Sheet().Rows.Count<=0 이면 return (빈 그리드 가드)  _(709 · `fpWhere_CellDoubleClick`)_
  **2** if(siWhere.IsLock(SheetName)) {} else {} — 양쪽 분기 모두 빈 몸체, 실동작 없음 (no-op 골격)  _(712 · `fpWhere_CellDoubleClick`)_
- **비고**: 가드 이후 구현이 비어 있는 미완성/보류 핸들러.

### 2.10 rtxtSQL_TextChanged  (L721)
- **트리거**: Designer L503 rtxtSQL.TextChanged += EventHandler (Query 편집기 내용 변경 시)
- **실제 발생 순서**:
  **1** 본문 전체 주석 (//FoxMessageBox.Show("내용이 바뀌었음")) — 완전 no-op  _(723 · `rtxtSQL_TextChanged`)_
- **비고**: SQL 텍스트에서의 컬럼/파라미터 자동 추출은 TextChanged 에 없음 — 실제 파싱은 Confirm(FindData 'FIND') 에서 수행: ① clsQuerys.ReplaceFirstOccurence 로 첫 SELECT→'SELECT TOP 0 ' 치환 + SQL 문자열 내 @Param 토큰을 sParamArray 로 추출 ② 치환 SQL 을 GetDataByDB 로 실행해 결과 스키마에서 GetColumnList(컬럼명)/GetColumnTypeList(타입)/GetColumnCompareList(컬럼-타입 쌍) 도출 ③ GetParameterList(sParamArray) 로 파라미터 DataTable 생성. 즉 텍스트 정규식 파싱이 아니라 'TOP 0 실행 → 결과 메타데이터 역추출' 방식.

### 2.11 spdMain_ComboSelChange  (L726)
- **트리거**: Designer L125 spdMain.ComboSelChange += EditorNotifyEventHandler (Column 그리드 콤보 선택 변경)
- **실제 발생 순서**:
  **1** e.Column == COLUMN_NAME 컬럼인 경우에만 처리  _(728 · `spdMain_ComboSelChange`)_
  **2** dtCompareList 를 LINQ 로 조회: CODE == 선택된 셀 값(GetValue) 인 행을 FirstOrDefault 로 획득  _(730 · `spdMain_ComboSelChange`)_
  **3** 같은 행의 VALUE_TYPE 컬럼에 row["NAME"](해당 컬럼의 타입명) 을 SetText 로 자동 세팅 — Column 선택 → Type 자동 연동  _(736 · `spdMain_ComboSelChange`)_
- **비고**: row null 가드 없음 — dtCompareList 에 CODE 미존재 시 NullReferenceException 잠재(AS-IS 결함). SetPreferredWidth 재호출은 주석 처리.

### 2.12 fpWhere_ComboSelChange  (L743)
- **트리거**: Designer L547 fpWhere.ComboSelChange += EditorNotifyEventHandler (Condition 그리드 콤보 선택 변경)
- **실제 발생 순서**:
  **1** e.Column == PARAMETER_TYPE 컬럼인 경우에만 처리, sType = 해당 행 Type 셀 값  _(745 · `fpWhere_ComboSelChange`)_
  **2** sType=='Combo' → 같은 행 col2(PARAMETER_ID) 셀 콤보 원천을 clsQuerys.GetCommonDataByDB("COMBO") 조회 결과로 교체 (매 선택 시 DB 호출)  _(748 · `fpWhere_ComboSelChange` · SP `clsQuerys.GetCommonDataByDB('COMBO') (L750)`)_
  **3** sType=='Parameter' → col2 콤보 원천을 dtParameter(SQL 의 @Param 추출 목록)로 교체  _(752 · `fpWhere_ComboSelChange`)_
  **4** 그 외(else) → col2 콤보 원천을 dtCols(SQL 컬럼 목록)로 교체. DateTime 전용 분기(SetCellTypeDateTime)는 주석 처리  _(756 · `fpWhere_ComboSelChange`)_
- **비고**: Type 값에 따라 Column 셀의 입력 후보를 동적 스왑하는 cascade 콤보. col2 는 하드코딩 인덱스(2) 사용.

### 2.A 내부 DTO — DyamicSqlPopup (원본 오타 그대로)
- 정의: L769 · 역할: 팝업 ↔ 메인 폼(SCM0005_DynamicQueryList) 간 유일한 데이터 전달 DTO. 팝업은 DB 저장을 직접 수행하지 않고(mSave dead code) OK 시 clsData 에 직렬화해 부모가 저장 SP 를 호출하는 구조.

| 필드 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| sFlag | string | "" | 팝업 상태 플래그. 부모→팝업: ''(신규/DB조회 모드) vs 값 있음(이전 OK 결과 복원 모드, FindData LOAD 분기 키). 팝업→부모: OK 시 'true' 로 세팅되어 '사용자가 OK 로 닫음'을 표시 |
| sDq_ID | string | "" | Dynamic Query ID — LoadData() 시 lbl_DQ_ID(숨김 라벨)로 옮겨져 SP 3종의 p_dq_id 로 사용, OK 시 회수 |
| sReport_Name | string | "" | Report Name — txtReportName 과 양방향 매핑 |
| sDes | string | "" | Description — txtDescription 과 양방향 매핑 |
| sRole_ID | string | "" | 선택 Role ID 목록 (clbRole.ControlValues, 콤마 구분) |
| sRole_Name | string | "" | 선택 Role 명칭 목록 (clbRole.NameList) — OK 시에만 채움 (LOAD 복원 시 미사용) |
| sSql | string | "" | SQL 원문 — rtxtSQL 과 양방향 매핑 |
| sColumns | string | "" | Column 그리드 직렬화 문자열: 행='action^COLUMN_NAME^VALUE_TYPE^VALID_YN^SEQNO', 행 구분 '|' — OK(SetItem) 시 조립, 부모 폼이 저장 SP 의 bulk 파라미터로 사용 |
| sParameters | string | "" | Condition 그리드 직렬화 문자열: 행='action^PARAMETER_ID^PARAMETER_TYPE^VALID_YN^SEQNO', 행 구분 '|' — 동일 용도 |

clsData 사용처: L38 public DyamicSqlPopup clsData = null — 팝업 공개 필드 (부모 폼이 직접 접근) · L118 public LoadData(clsData): 부모 → 팝업 주입 + lbl_DQ_ID.Text = clsData.sDq_ID · L295 FindData('LOAD'): clsData.sFlag != '' 이면 clsData 필드값으로 화면 복원 (sReport_Name/sDes/sRole_ID/sSql) · L574 SetItem() (OK): clsData 신규 생성 후 화면값 + 그리드 직렬화 문자열 전부 채움 → 팝업 → 부모 반환 통로

---

## 3. 데이터 접근 인벤토리 (활성 25건 전수 + 주석 9건)

### 3-메인 폼

| 줄 | 호출 | 소속 메서드 | 소속 이벤트 | 파라미터 |
|---|---|---|---|---|
| L37 | `Data.Common(Data.Type.YesOrNo)` | (field initializer) dtYesOrNo | Form 생성(constructor) |  |
| L38 | `clsQuerys.mDataType()` | (field initializer) dtDataType | Form 생성(constructor) |  |
| L147 | `clsQuerys.GetCommonDataByDB("ROLES")` | InitControls | Form_Load | 'ROLES' |
| L159 | `Data.Common(Data.Type.MyDivision, false, NowGroupID, UserId)` | DefineProperty | Form_Load | Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId |
| L161 | `Data.UserSiteByEndCustomer(NowGroupID, UserId, "ALL", "ALL")` | DefineProperty | Form_Load | NowGroupID, UserId, 'ALL', 'ALL' |
| L346 | `new FoxDataRequest("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST")` | FindData (tab Register) | FindButton (+ SaveButton 후 재조회) | p_dq_id=txtDescription.Text (소스 주석: p_dq_id이 Description임), p_dq_name=umltReportName.Text, p_role=clbRole.ControlValues |
| L505 | `new FoxDataRequest("DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2")` | FindData (tab View) | FindButton (View 탭) | v_sql_text=Substitute(sFinalSql) |
| L527 | `new FoxDataRequest("DM_H.PR_DM_ADM_DQ_EXECUTE_HIST")` | FindData (tab View) | FindButton (View 탭) | p_DQ_ID=lbl_DQ_ID.Text, p_DQ_TEXT=Substitute(sFinalSql), p_CREATED_BY=UserId, p_LAST_UPDATED_BY=DateTime.Now |
| L612 | `new FoxDataRequest("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS")` | GroupData | spdMain_CellDoubleClick (Setting_ViewTab) | p_dq_id=dq_id |
| L628 | `new FoxDataRequest("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS")` | ParameterData | spdMain_CellDoubleClick (Setting_ViewTab) | p_dq_id=dq_id |
| L785 | `new FoxDataRequest("DM_H.PR_DM_ADM_DQ_CREATE")` | SaveData | SaveButton | p_active_flag=action(I/M/D), p_DQ_ID, p_DIVISION_ID, p_DQ_NAME, p_DESCRIPTION, p_DQ_TEXT, p_VALID_YN, p_ADMIN_ONLY_YN, p_CREATED_BY=sUserId, p_LAST_UPDATED_BY=sUserId |
| L832 | `new FoxDataRequest("DM_H.PR_DM_ADM_DQ_CREATE_USER_GROUP")` | SaveData | SaveButton | p_DQ_ID=sDB_ID, p_GROUP_ID=sRole_ID, p_VALID_YN='Y', p_CREATED_BY=sUserId, p_LAST_UPDATED_BY=sUserId |
| L863 | `new FoxDataRequest("DM_H.PR_DM_ADM_DQ_CREATE_COLUMN")` | SaveData (COMUMNS 파싱 루프) | SaveButton | p_active_flag=행 A(I/M/D), p_DQ_ID=sDB_ID, p_COLUMN_NAME, p_VALUE_YN='Y'(char 고정), p_VALUE_TYPE, p_VALID_YN, p_SEQNO, p_CREATED_BY=sUserId, p_LAST_UPDATED_BY=sUserId |
| L900 | `new FoxDataRequest("DM_H.PR_DM_ADM_DQ_CREATE_PARAMETER")` | SaveData (PARAMETERS 파싱 루프) | SaveButton | p_active_flag=행 A(I/M/D), p_DQ_ID=sDB_ID, p_PARAMETER_ID, p_PARAMETER_TYPE(원천 열명 TYPE), p_OPERATION_ID='', p_VALID_YN, p_SEQNO, p_REP_YN='', p_CREATED_BY=sUserId, p_LAST_UPDATED_BY=sUserId |
| L1056 | `clsQuerys.GetCommonDataByDB("AGGREGATE")` | Setting_ViewTab (Group 행 루프, 비 String 타입) | spdMain_CellDoubleClick | 'AGGREGATE' |
| L1077 | `clsQuerys.GetCommonDataByDB("OPORATOR")` | Setting_ViewTab (Where 행 루프) | spdMain_CellDoubleClick | 'OPORATOR' |

### 3-팝업

| 줄 | 호출 | 소속 메서드 | 소속 이벤트 | 파라미터 |
|---|---|---|---|---|
| L44 | `Data.Common(Data.Type.YesOrNo)` | 필드 초기화 (dtYesOrNo) | 생성자 시점 (Form_Load 이전) | Data.Type.YesOrNo |
| L45 | `clsQuerys.mDataType()` | 필드 초기화 (dtDataType) | 생성자 시점 | (없음) |
| L134 | `clsQuerys.GetCommonDataByDB("ROLES")` | InitControls | Form_Load | 'ROLES' |
| L349 | `FoxDataRequest("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST") + client.ExecuteDataSet (L353)` | FindData('LOAD' else 분기) | Form_Load | p_dq_id=lbl_DQ_ID.Text, p_dq_name='', p_rol e='' (원문 p_role='') |
| L411 | `clsQuerys.GetDataByDB(sSQL)` | FindData('FIND') | btnButtonList Confirm (+ EditButton 의 dtCols==null 선행 호출 경유) | sSQL = 사용자 SQL ToUpper 후 첫 SELECT→'SELECT TOP 0 ' 치환문 |
| L443 | `FoxDataRequest("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS") + ExecuteDataSet (L445)` | GroupData | Form_Load → FindData('LOAD') 양 분기 공통 | p_dq_id=lbl_DQ_ID.Text |
| L458 | `FoxDataRequest("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS") + ExecuteDataSet (L460)` | ParameterData | Form_Load → FindData('LOAD') 양 분기 공통 | p_dq_id=lbl_DQ_ID.Text |
| L524 | `FoxDataRequest("DM.PR_DM_ADM_DQ_CREATE") + ExecuteDataSet (L535)` | mSave (⚠ dead code — 호출자 0) | (미배선) | p_active_flag='I'|'U', p_DQ_ID, p_DIVISION_ID='', p_DQ_NAME, p_DESC, p_QUERY, p_VALID_YN='Y', p_ADMIN_ONLY_YN='Y', p_CREATED_BY='DB', p_LAST_UPDATED_BY='DB' |
| L750 | `clsQuerys.GetCommonDataByDB("COMBO")` | fpWhere_ComboSelChange | fpWhere_ComboSelChange (Type='Combo' 선택 시) | 'COMBO' |

_주석 처리(비활성) 호출: 메인 L159 //clsQuerys.GetComboDataByDB("SCM.SCM0001_GET_DIVISION"); L160 //clsQuerys.GetComboDataByDB("SCM.SCM0001_GET_SITE_BY_DIVISI; L484 //new FoxDataRequest("DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LI; L492 //(new CUIControl()).GetAsyncDataUsingByDBEx(..., "DM.DMF002; L706 //new FoxDataRequest("DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LI; L719 //new FoxDataRequest("DM_H.PR_DM_ADM_DQ_EXECUTE_HIST") (dead; L820 //(new CUIControl()).GetDataUsingSQLByDB2(sSQL) — D 행 하위 테이블; L1050 //siGRoup.SetCellTypeCombo(..., GetCommonDataByDB("AGGREGATE / 팝업 L144 FoxDataRequest("DM.DMF0027_GET_DM_DYNAMIC_QUERYS") — private_

### 3-C. AS-IS SP ↔ TO-BE FE 호출 매핑 (FE 코드 실측 12건)

| # | FE 호출 | sheet/tab | TO-BE SP | AS-IS SP | 비고 |
|---|---|---|---|---|---|
| 1 | useTabProcQuery SEARCH(기본) | main/props.tabId | PKG_SYS0013.P_SYS0013_GET_QUERY_LIST (types.ts L9 주석 근거) | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST (main L346, popup L349) | filters = searchCondition(reportName/description/role). AS-IS 파라미터 p_dq_id(=Description)/p_dq_name/p_role 대응 |
| 2 | useTabProcQuery EXECUTE (procedureAction 명시) | result/props.tabId | PKG_SYS0013.P_SYS0013_GET_DYNAMIC_QUERYS(P_SQL_TEXT) — BTN_MPG_M(SYS0013, result, EXECUTE) → API_M 라우팅 (L86-87 주석) | DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 (main L505, v_sql_text=Substitute(sFinalSql)) | filters = { sqlText } (store.setExecuteFilter L178-187). AS-IS Base64 키워드 치환(Substitute) 은 TO-BE 미사용 |
| 3 | useTabProcQuery SEARCH(기본) | columns/props.tabId | P_SYS0013_GET_COLUMNS (types.ts L29 주석 근거) | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS (main L612, popup L443) | filters = { dqId } (store L214). enabled = filters && selectedQueryId (TEMP_ 제외) |
| 4 | useTabProcQuery SEARCH(기본) | parameters/props.tabId | P_SYS0013_GET_PARAMETERS (types.ts L41 주석 근거) | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS (main L628, popup L458) | filters = { dqId } (store L215-218) |
| 5 | apiClient.post  | / | P_SYS0013_SAVE_QUERY_LIST (MainGrid.tsx L2 주석 근거) | DM_H.PR_DM_ADM_DQ_CREATE (main L785, 행별 단건 호출) | pData = JSON.stringify(mainPayload[]) — crudType/dqId/divisionId/dqName/description/dqText/validYn/adminOnlyYn. AS-IS 행별 호출 → TO-BE JSON array 일괄 |
| 6 | apiClient.post  | / | PKG_SYS0013 columns SAVE (BTN_MPG_M 라우팅) | DM_H.PR_DM_ADM_DQ_CREATE_COLUMN (main L863) | pData = JSON array — crudType/dqId/columnName/valueYn/valueType/aggregate/validYn/seqno |
| 7 | apiClient.post  | / | PKG_SYS0013 parameters SAVE (BTN_MPG_M 라우팅) | DM_H.PR_DM_ADM_DQ_CREATE_PARAMETER (main L900) | pData = JSON array — crudType/dqId/parameterId/parameterType/operationId/validYn/repYn/seqno/defaultValue |
| 8 | apiClient.post  | / | SYS0013_SAVE_USER_GROUP (MetaForm.tsx L4 주석 근거, SHT_NM='userGroup') | DM_H.PR_DM_ADM_DQ_CREATE_USER_GROUP (main L832) | role diff 저장 — 추가=validYn 'Y' / 해제='N' 그룹별 단건 호출. body: dqId/groupId/validYn/createdBy/lastUpdatedBy |
| 9 | apiClient.post  | / | admin 공통 SHEET_COLUMNS 메타 조회 | (대응 없음 — AS-IS 는 코드 하드코딩 InitSpread_*) | fetchStaticColumns — sheetNm=main/columns/parameters 3병렬. result 시트는 동적 컬럼이라 메타 미사용([]) |
| 10 | apiClient.get  | / | admin 공통 조회조건 저장값 복원 | (대응 없음) | fetchSearchConditions — 실패 시 silent |
| 11 | useTabComboQueries  | / | 공통 콤보 registry 'UserGroup' | clsQuerys.GetCommonDataByDB("ROLES") (main L147, popup L134) | Register 검색 Role 콤보('ALL' 선두) + View MetaForm Role 다중선택 |
| 12 | useTabBtnPermissions  | / | admin BTN_MPG_M + USER_GR 권한 (checkMenuBtnAuth) | (BaseForm 공통 버튼 프레임워크) | hasButton(SEARCH/SAVE/INSERT/DELETE/EXECUTE) — hotkeyConfig + customButtons 게이트 |

> ⚠️ **격차**: `DM_H.PR_DM_ADM_DQ_EXECUTE_HIST (main L527, 실행 이력 기록)` — TO-BE FE 미호출 — constants.ts L7 주석: 'History 는 화면에서 제거됨(2026-06-26 DESIGN 정합) — SP/메타는 보존하나 FE 미사용'. 실행 이력 기록이 FE 경로에 없음 (BE/SP 내부 처리 여부는 PKG_SYS0013 본문 확인 필요 — FE 범위 밖)

---

## 4. Validation 전수 (22건) + TO-BE 대응

| # | 폼 | 줄 | 유형 | MSG | 발생 조건 | 동작 | 이벤트 | TO-BE 상태 | TO-BE 위치 |
|---|---|---|---|---|---|---|---|---|---|
| 1 | main | L376 | guard |  | Result 탭(tabQuery.SelectedIndex==1)에서 조회 실행 시 Register 그리드에 선택된 행이 없음(siMain.ActiveRowIndex == -1) | 차단(무메시지 — 조용히 실행 중단) | FindButton → FindData(tab=1) | 구현 | DynamicQuery.tsx:384 |
| 2 | main | L594 | throw |  | Result 탭 동적 쿼리 실행(FindData tab=1) 중 예외 발생 — catch(ex) 후 throw ex 재던짐 (단, 내부 DB 호출 자체는 L515/L539 의 catch{} 로 삼켜져 SQL 오류는 빈 결과로 은폐됨) | 경고(프레임워크 공통 에러 다이얼로그) | FindButton → FindData(tab=1) catch | 부분 | DynamicQuery.tsx:383 |
| 3 | main | L747 | guard |  | 저장 시 활성 시트가 'DynamicList' 메인 시트가 아님(siMain.SheetName != shtMain) — 또한 외곽 L744 조건상 Edit 모드(IsLock==false)가 아니면 저장 로직 전체가 무동작 | 차단(무메시지) | SaveButton → SaveData | 구현 | DynamicQuery.tsx:209 |
| 4 | main | L803 | sp_result |  | 행별 저장 SP(DM_H.PR_DM_ADM_DQ_CREATE) 마지막 result set 첫 컬럼(sRMSG)이 'success' 가 아님 → L805 throw new Exception(sRMSG) 로 저장 루프 중단, L936 rethrow 경유 에러 다이얼로그 | 차단(에러 다이얼로그, 이후 행 저장 중단) | SaveButton → SaveData (행 저장 결과 판정) | 구현 | DynamicQuery.tsx:317 |
| 5 | main | L923 | MSG | MSG00004  | 저장 루프 정상 완료 — '{0}개의 데이터가 저장되었습니다.' (iCUD = I/M/D 처리 건수) | 확인(정보 알림, 저장 후 재조회 FindData 수행) | SaveButton → SaveData | 구현 | DynamicQuery.tsx:313 |
| 6 | main | L936 | throw |  | SaveData 전체 try 블록 내 예외(SP 실패 throw 포함) — catch(ex) 후 throw ex 재던짐 | 경고(프레임워크 공통 에러 다이얼로그) | SaveButton → SaveData catch | 구현 | DynamicQuery.tsx:317 |
| 7 | main | L972 | guard |  | 메인 그리드 행 더블클릭 시 데이터 행이 0건(siMain.Sheet().Rows.Count <= 0) | 차단(무메시지 — 더블클릭 무시) | spdMain_CellDoubleClick | 구현 | components/DynamicQueryMainGrid.tsx:93 |
| 8 | main | L978 | guard |  | 조회(Lock) 모드에서 더블클릭한 행의 action flag == 'I'(저장 전 신규 행) — DQ_ID 미채번 상태이므로 Result 탭 전환/자식 조회 차단 | 차단(무메시지) | spdMain_CellDoubleClick (조회모드 분기) | 부분 | useDynamicQueryStore.ts:213 |
| 9 | main | L1140 | guard |  | Where(Condition) 시트 데이터모델 Changed 이벤트에서 e.Column<0 \|\| e.Row<0 (음수 인덱스 기술 가드 — InitSpread 오류 방지) | 차단(기술 가드) | DsdmWhere_Changed | 구현 | components/DynamicQueryMainGrid.tsx:60 |
| 10 | main | L1160 | throw |  | DsdmWhere_Changed 처리 중 예외 — catch 후 throw ex 재던짐 | 경고(프레임워크 공통 에러 다이얼로그) | DsdmWhere_Changed catch | 미구현 |  |
| 11 | main | L1181 | guard |  | Group(Columns) 시트 데이터모델 Changed 이벤트에서 e.Column<0 \|\| e.Row<0 (음수 인덱스 기술 가드) | 차단(기술 가드) | DsdmGroup_Changed | 구현 | components/DynamicQueryColumnsGrid.tsx:45 |
| 12 | main | L1201 | throw |  | DsdmGroup_Changed 처리 중 예외 — catch 후 throw ex 재던짐 | 경고(프레임워크 공통 에러 다이얼로그) | DsdmGroup_Changed catch | 미구현 |  |
| 13 | popup | L220 | guard |  | 팝업 Edit 버튼 클릭 시 SQL 검증 미수행 상태(dtCols==null)에서 FindData("FIND") 검증이 -1(실패: SQL 빈값 또는 문법 오류) 반환 — Edit(잠금해제) 전환 차단 | 차단(선행 검증의 메시지로 안내) | EditButton | 미구현 |  |
| 14 | popup | L343 | guard |  | 팝업 로드(FindData "LOAD") 시 신규 행(lbl_DQ_ID.Text == "") — 기존 데이터 조회 스킵(return 0)하고 빈 팝업 표시 | 차단(로드 스킵) | Form_Load → FindData("LOAD") | 구현 | useDynamicQueryStore.ts:213 |
| 15 | popup | L398 | MSG | (하드코딩) "No SQL." | Confirm(SQL 검증) 버튼 클릭 시 SQL 입력창(rtxtSQL)이 공백 — FoxMessageBox 후 return -1 (L399) | 차단 | btnButtonList Confirm → FindData("FIND") | 구현 | DynamicQuery.tsx:390 |
| 16 | popup | L415 | MSG | (하드코딩) "Error : {DB오류메시지}" | SQL 문법 사전검증(SELECT TOP 0 치환 실행, clsQuerys.GetDataByDB) 결과가 오류 1행 반환 — FoxMessageBox 로 DB 오류 표시 후 return -1 (L416) | 차단 | btnButtonList Confirm → FindData("FIND") | 부분 | DynamicQuery.tsx:383 |
| 17 | popup | L426 | MSG | MSG00148 (MSG_M 미등재) | SQL 문법 사전검증 통과 — 'The SQL syntax has been verified.' + 컬럼/타입/파라미터 목록(dtCols/dtTypes/dtCompareList/dtParameter) 추출 완료 | 확인(정보 알림) | btnButtonList Confirm → FindData("FIND") | 미구현 |  |
| 18 | popup | L543 | sp_result |  | mSave: DM.PR_DM_ADM_DQ_CREATE 결과 sRMSG == 'success' 판정 분기 (⚠️ mSave 는 어디서도 호출되지 않는 데드코드 — SaveButton 은 주석 처리됨) | 확인/차단 분기 (데드코드) | mSave (미호출) | 구현 | DynamicQuery.tsx:317 |
| 19 | popup | L548 | MSG | MSG00004  | mSave 저장 성공 시 — '저장 되었습니다.' (⚠️ 데드코드: mSave 미호출) | 확인 (데드코드) | mSave (미호출) | 구현 | DynamicQuery.tsx:313 |
| 20 | popup | L561 | MSG | (하드코딩) sRMSG + "Error!" | mSave 저장 실패(sRMSG != 'success') 시 SP 오류 메시지 FoxMessageBox 표시 (⚠️ 데드코드: mSave 미호출) | 경고 (데드코드) | mSave (미호출) | 구현 | DynamicQuery.tsx:318 |
| 21 | popup | L631 | guard |  | Insert 버튼 클릭 시 포커스된 스프레드 없음(fps == null) — 어느 그리드(Columns/Where)에 행을 추가할지 결정 불가 | 차단(무메시지) | InsertButton → InsertRow | 구현 | DynamicQuery.tsx:148 |
| 22 | popup | L710 | guard |  | Where(Condition) 그리드 더블클릭 시 데이터 행 0건(siWhere.Sheet().Rows.Count <= 0) — (통과 후 본문도 빈 구현) | 차단(무메시지) | fpWhere_CellDoubleClick | 미구현 |  |

**TO-BE 대응 통계**: {"구현": 14, "부분": 3, "미구현": 5, "합계": 22}

**미구현 핵심 격차**:
- no 13/16/17: AS-IS 팝업의 SQL 사전 문법검증(Confirm → SELECT TOP 0 실행 → 성공 시 컬럼 목록 자동 추출·MSG00148) 흐름 전체가 TO-BE 에 없음 — Execute 시 사후 오류 노출로 대체, Columns 메타는 수동 입력
- no 10/12: FarPoint changed 핸들러 rethrow — Wijmo 구조상 불필요 (실질 격차 아님)
- no 22: Condition 그리드 더블클릭 — AS-IS 도 빈 구현이라 기능 손실 아님

### 4-B. TO-BE 전용 validation (10건 — AS-IS에 없던 신규)

| 유형 | MSG | 위치 | 조건 |
|---|---|---|---|
| MSG | MSG00630  | DynamicQuery.tsx:134, 150 | Delete/View Insert 시 Query 미선택(또는 TEMP_) — 'Query 를 선택하세요' alert 차단 |
| MSG | MSG00012  | DynamicQuery.tsx:138-141 | Main 행 삭제 전 confirm '선택한 행을 삭제하시겠습니까?' — 취소 시 중단 |
| MSG | MSG00014  | DynamicQuery.tsx:176, 183 | View 탭 Delete 시 Columns/Condition 그리드 선택 행 없음 — '삭제할 행을 선택하세요' alert 차단 |
| MSG | MSG00617  | DynamicQuery.tsx:214-217 | 저장 전 confirm '{0} 행을 저장하시겠습니까?' (totalDirty 건수) |
| MSG | MSG00629  | DynamicQuery.tsx:405 | Execute 실행 트리거 성공 toast '실행 완료' |
| guard |   | components/DynamicQueryForm.tsx:29-35 | 영속 store 의 비유효 role 값을 콤보 로드 후 'ALL' 로 정규화 (stale persist 방어) |
| guard |   | DynamicQuery.tsx:330-333, 408 | hasButton(SEARCH/SAVE/INSERT/DELETE/EXECUTE) 권한 없으면 버튼/hotkey 비활성 (admin BTN_MPG_M + USER_GR 동적 게이트) |
| guard |   | components/DynamicQueryMainGrid.tsx:25-32, 69-85 | EDITABLE_BINDINGS 외 컬럼 편집 차단(beginningEdit) — AS-IS EditButton L310-311 ROLE/CREATED_BY~ADMIN_ONLY_YN LockColumn 대응 (Columns/Parameters 그리드 동일 패턴) |
| guard |   | DynamicQuery.tsx:201-206 | Role 변경 diff 판정 — 저장된 query(비-TEMP)에서 선택/원본 차이 있을 때만 dirty 계상 |
| guard |   | DynamicQuery.tsx:402 | 미입력 @PARAM/:PARAM 토큰 잔존 시 '' 로 강제 치환 (AS-IS L687-688 N'' 치환 정합, ORA-01008 방지) |

---

## 5. SP 제약 전수 — TO-BE Oracle 정본 (227행 = PKG 60 + standalone 167)

### 5-A. PKG_SYS0013 (멤버 10 — SPEC 96줄 / BODY 942줄)

#### P_SYS0013_EXECUTE_QUERY  (3건)
_역할: 사용자가 화면에서 작성/선택한 동적 쿼리(SQL 문자열)를 인젝션 방어 정규화 후 실제 실행하여 결과를 반환한다._  
_쉬운 설명: Dynamic Query 화면에서 사용자가 만든 SQL을 서버에서 직접 실행해 주는 실행기입니다. 실행 전에 FN_GET_NORMAL_STRING2 함수로 문자열을 정규화하여 SQL 인젝션(악의적 SQL 삽입)을 방어합니다. 실행 결과 데이터는 O_RC1로, 처리 성공/실패 상태는 O_RESULT_CURSOR로 이중 반환합니다._
- **동적 SQL**: {'method': 'OPEN O_RC1 FOR V_S_QUERY (커서 변수에 SQL 문자열 직접 오픈 — EXECUTE IMMEDIATE 미사용)', 'bind': '바인드 변수 없음 — P_SQL_TEXT 전체가 문자열로 전달되어 그대로 실행됨', 'injection_guard': "V_S_QUERY := FN_GET_NORMAL_STRING2(P_SQL_TEXT) — 2019/04/16, 2019/04/25 '쿼리 인젝션 방비 수정' 이력이 있는 정규화 함수로 위험 문자열 제거/정규화 후 실행", 'column_where_build': '컬럼/WHERE 조립 없음 — 완성된 SQL 문자열을 통째로 받아 실행 (조립은 FE 또는 GET_COLUMNS/GET_PARAMETERS 메타 기반으로 화면에서 수행)', 'line': '35-37'}
- **함수 호출**: {"fn": "FN_GET_NORMAL_STRING2", "purpose": "동적 SQL 인젝션 방어 문자열 정규화", "line": "35"}, {"fn": "SCM_MGR.PR_SCM_SYS_LOG_BATCH", "purpose": "예외 발생 시 시스템 로그 기록", "line": "53"}

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 검증 | V_S_QUERY := FN_GET_NORMAL_STRING2(P_SQL_TEXT) 후 OPEN O_RC1 FOR V_S_QUERY — 원문이 아닌 정규화된 문자열만 실행 | 사용자가 입력한 SQL을 그대로 실행하지 않고 인젝션 방어 함수를 반드시 거친 뒤 실행합니다. 위험한 구문이 섞인 SQL이 DB에 도달하는 것을 막는 안전장치입니다. |  |  | 35-37 |
| 커서 | 이중 OUT 커서 표준 — O_RC1(데이터) + O_RESULT_CURSOR(SELECT '0' AS CODE, 'SUCCESS' AS MSG, EVENT FROM DUAL) | 조회 데이터와 처리 성공 여부를 별도의 두 커서로 나눠 반환하는 NSCM GET SP 표준 패턴입니다. 프론트엔드는 O_RESULT_CURSOR의 CODE='0'으로 성공을 판정합니다. | DUAL |  | 37-40 |
| 검증 | EXCEPTION WHEN OTHERS: ROLLBACK → SQLCODE/SQLERRM/BACKTRACE/입력파라미터(JSON_OBJECT, P_SQL_TEXT 앞 500자) 캡처 → PR_SCM_SYS_LOG_BATCH 로그 → RAISE_APPLICATION_ERROR(-20001) + RAISE | 실행 중 오류가 나면 변경사항을 되돌리고, 어떤 SQL이 어떤 에러를 냈는지 시스템 로그에 남긴 뒤, 호출자(BE)에게 상세 에러 메시지를 전달합니다. 디버깅 시 로그만 보면 원인을 추적할 수 있습니다. | SCM_COM_SYS_LOG(간접, PR_SCM_SYS_LOG_BATCH 경유) | RAISE_APPLICATION_ERROR(-20001, '[PKG_SYS0013] SQLCODE=... / SQLERRM=... / BACKTRACE=... / PARAMS={P_SQL_TEXT 앞 500자}') 후 RAISE 재전파 | 42-66 |

#### P_SYS0013_GET_DYNAMIC_QUERYS  (3건)
_역할: 전달받은 동적 쿼리 SQL 문자열을 정규화 없이 그대로 실행하여 결과를 반환한다 (EXECUTE_QUERY의 무가드 변형)._  
_쉬운 설명: EXECUTE_QUERY와 동일하게 SQL 문자열을 실행하지만, 인젝션 방어 함수(FN_GET_NORMAL_STRING2)를 거치지 않고 P_SQL_TEXT 원문을 그대로 커서에 오픈합니다. 신뢰된 내부 조립 SQL(관리자 등록 Dynamic Query 본문) 실행 용도로, 호출 경로가 통제되어야 하는 프로시저입니다._
- **동적 SQL**: {'method': 'OPEN O_RC1 FOR P_SQL_TEXT (파라미터 원문 직접 오픈 — EXECUTE IMMEDIATE 미사용)', 'bind': '바인드 변수 없음', 'injection_guard': '없음 — EXECUTE_QUERY와 달리 FN_GET_NORMAL_STRING2 미적용 (원문 그대로 실행). 호출측 통제 전제.', 'column_where_build': '조립 없음 — 완성 SQL 통째 실행', 'line': '98'}
- **함수 호출**: {"fn": "SCM_MGR.PR_SCM_SYS_LOG_BATCH", "purpose": "예외 발생 시 시스템 로그 기록", "line": "115"}

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 검증 | OPEN O_RC1 FOR P_SQL_TEXT — 입력 SQL 원문 무가드 실행 (인젝션 정규화 부재가 EXECUTE_QUERY와의 유일한 본질 차이) | 등록된 Dynamic Query 본문처럼 이미 신뢰된 SQL을 실행하는 통로입니다. 사용자 자유입력 SQL에는 이 프로시저가 아닌 EXECUTE_QUERY(가드 있음)를 사용해야 합니다. |  |  | 98 |
| 커서 | 이중 OUT 커서 표준 — O_RC1(데이터) + O_RESULT_CURSOR('0'/'SUCCESS') | 조회 데이터와 성공 상태를 두 커서로 나눠 반환하는 표준 패턴입니다. | DUAL |  | 98-101 |
| 검증 | EXCEPTION WHEN OTHERS: ROLLBACK → 에러정보 캡처(P_SQL_TEXT 앞 500자 JSON) → PR_SCM_SYS_LOG_BATCH → RAISE_APPLICATION_ERROR(-20001) + RAISE | 실행 오류 시 롤백하고 로그를 남긴 뒤 상세 에러를 호출자에게 전파합니다. | SCM_COM_SYS_LOG(간접) | RAISE_APPLICATION_ERROR(-20001, '[PKG_SYS0013] SQLCODE=... / SQLERRM=... / BACKTRACE=... / PARAMS=...') 후 RAISE 재전파 | 104-128 |

#### P_SYS0013_GET_ROLE_DATA  (3건)
_역할: 사용 중(USE_YN='Y')인 사용자 그룹(Role) 목록을 콤보 데이터(CODE/NAME)로 반환한다._  
_쉬운 설명: Dynamic Query에 접근 권한을 부여할 때 선택하는 '역할(사용자 그룹)' 콤보의 데이터 소스입니다. 사용자 그룹 마스터에서 현재 사용 중인 그룹만 골라 그룹ID를 CODE, 그룹명을 NAME으로 내려줍니다._
- **함수 호출**: {"fn": "SCM_MGR.PR_SCM_SYS_LOG_BATCH", "purpose": "예외 발생 시 시스템 로그 기록", "line": "176"}

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Lookup | SELECT USER_GR_ID AS CODE, USER_GR_NM AS NAME FROM SCM_ADM_USER_GR_M WHERE USE_YN = 'Y' | 사용자 그룹 마스터에서 '사용' 상태인 그룹만 콤보 목록으로 제공합니다. 폐기된 그룹은 화면에 나타나지 않습니다. | SCM_ADM_USER_GR_M |  | 157-162 |
| 커서 | 이중 OUT 커서 표준 — O_RC1(콤보 데이터) + O_RESULT_CURSOR('0'/'SUCCESS') | 콤보 데이터와 성공 상태를 두 커서로 나눠 반환합니다. | DUAL |  | 157-165 |
| 검증 | EXCEPTION WHEN OTHERS: ROLLBACK → 캡처(파라미터 없음이므로 JSON_OBJECT('NO_PARAM' VALUE 'N/A')) → PR_SCM_SYS_LOG_BATCH → RAISE_APPLICATION_ERROR(-20001) + RAISE | 조회 오류 시 로그를 남기고 상세 에러를 전파합니다. | SCM_COM_SYS_LOG(간접) | RAISE_APPLICATION_ERROR(-20001, '[PKG_SYS0013] SQLCODE=... / SQLERRM=... / BACKTRACE=... / PARAMS={NO_PARAM:N/A}') 후 RAISE 재전파 | 167-189 |

#### P_SYS0013_GET_PARAMETERS  (5건)
_역할: 특정 Dynamic Query(DQ_ID)에 등록된 실행 파라미터 목록(파라미터ID/타입/연산자/순번/기본값)을 조회한다._  
_쉬운 설명: 선택한 Dynamic Query를 실행할 때 사용자에게 입력받을 조건(파라미터) 정의 목록을 내려줍니다. ATTRIBUTE1을 순번(SEQNO), ATTRIBUTE2를 기본값(DEFAULT_VALUE)으로 별칭 매핑해 화면 그리드 컬럼과 1:1로 맞춥니다. 순번 오름차순, 같은 순번이면 최종수정일 순으로 정렬됩니다._
- **함수 호출**: {"fn": "SCM_MGR.PR_SCM_SYS_LOG_BATCH", "purpose": "예외 발생 시 시스템 로그 기록", "line": "253"}

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Lookup | SELECT DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID, VALID_YN, REP_YN, 감사컬럼4, SEQNO, DEFAULT_VALUE FROM SCM_ADM_DQ_PARAMETER WHERE DQ_ID = P_DQ_ID | 해당 쿼리ID에 등록된 파라미터만 정확 일치 조건으로 조회합니다. VALID_YN 필터가 없으므로 무효 처리된 파라미터도 관리 화면에는 모두 표시됩니다. | SCM_ADM_DQ_PARAMETER |  | 221-236 |
| NVL·기본값 | NVL(ATTRIBUTE1, '0') AS SEQNO / NVL(ATTRIBUTE2, '') AS DEFAULT_VALUE — 확장속성 컬럼을 화면 의미 컬럼으로 별칭 매핑 + NULL 방어 | 순번이 비어 있으면 '0'으로 간주해 정렬이 깨지지 않게 하고, 기본값이 없으면 빈 값으로 내려줍니다. 주의: Oracle에서 NVL(x,'')는 빈 문자열이 NULL과 동일하므로 DEFAULT_VALUE의 NVL은 실질 효과가 없는 형식적 방어입니다. | SCM_ADM_DQ_PARAMETER |  | 232-233 |
| 정렬 | ORDER BY TO_NUMBER(NVL(ATTRIBUTE1, '0')), LAST_UPDATE_DATE | 파라미터를 사용자가 지정한 순번(숫자 변환) 순으로, 순번이 같으면 나중에 수정한 것이 뒤로 오도록 정렬합니다. ATTRIBUTE1에 숫자가 아닌 값이 들어가면 TO_NUMBER에서 ORA-01722가 발생할 수 있는 잠재 위험이 있습니다. | SCM_ADM_DQ_PARAMETER |  | 237 |
| 커서 | 이중 OUT 커서 표준 — O_RC1(파라미터 목록) + O_RESULT_CURSOR('0'/'SUCCESS') | 데이터와 성공 상태를 두 커서로 나눠 반환합니다. | DUAL |  | 221-240 |
| 검증 | EXCEPTION WHEN OTHERS: ROLLBACK → JSON_OBJECT('P_DQ_ID' VALUE P_DQ_ID) 캡처 → PR_SCM_SYS_LOG_BATCH → RAISE_APPLICATION_ERROR(-20001) + RAISE | 조회 오류 시 어떤 쿼리ID로 호출했는지까지 로그에 남기고 상세 에러를 전파합니다. | SCM_COM_SYS_LOG(간접) | RAISE_APPLICATION_ERROR(-20001, '[PKG_SYS0013] SQLCODE=... / SQLERRM=... / BACKTRACE=... / PARAMS={P_DQ_ID}') 후 RAISE 재전파 | 242-266 |

#### P_SYS0013_GET_QUERY_LIST_COMMON  (11건)
_역할: 닉네임 키워드(COLTYPES/COMBO/AGGREGATE/OPORATOR/ROLES/BIZ_TYPE/ITEM_TYPE_CODE/INCOTERMS) 별 공통 콤보 데이터를 분기 반환한다._  
_쉬운 설명: SYS0013 화면의 여러 콤보박스가 하나의 프로시저를 공유하는 멀티 콤보 소스입니다. P_NICKNAME 값에 따라 8종의 콤보 데이터를 IF-ELSIF 분기로 내려주며, 일부는 DUAL 기반 고정 목록(컬럼타입/집계함수/연산자 등), 일부는 마스터 테이블 조회(역할/Lookup 코드)입니다. 등록되지 않은 닉네임이 오면 빈 결과(0행)를 반환합니다._
- **함수 호출**: {"fn": "SCM_MGR.PR_SCM_SYS_LOG_BATCH", "purpose": "예외 발생 시 시스템 로그 기록", "line": "392"}

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Lookup | P_NICKNAME='COLTYPES': DUAL UNION ALL 고정 3종 — System.String/String, System.Int/Int, System.Date/Date | 동적 쿼리 컬럼의 데이터 타입 선택 콤보입니다. .NET 타입 표기(System.*)를 코드로 쓰는 AS-IS 호환 고정 목록 3종입니다. | DUAL |  | 292-299 |
| Lookup | P_NICKNAME='COMBO': DUAL UNION ALL 고정 2종 — DIVISION_ID, SCM_SITE_ID | 파라미터를 콤보 형태로 입력받을 때 사용할 수 있는 콤보 종류 목록입니다. 사업부(DIVISION_ID)와 사이트(SCM_SITE_ID) 두 가지만 허용됩니다. | DUAL |  | 301-306 |
| Lookup | P_NICKNAME='AGGREGATE': DUAL UNION ALL 고정 4종 — SUM/MAX/MIN/COUNT (GROUP 항목은 주석 처리로 제외됨) | 동적 쿼리 컬럼에 적용할 집계 함수 선택 콤보입니다. 합계/최대/최소/건수 4종만 허용하며, 과거 있던 GROUP 옵션은 소스에서 주석으로 비활성화되어 있습니다. | DUAL |  | 308-319 |
| Lookup | P_NICKNAME='OPORATOR'(철자 오타 그대로 사용): DUAL UNION ALL 고정 5종 — '=', 'IN', 'LIKE', '>', '<' | 파라미터 조건에 쓸 비교 연산자 콤보입니다. 5종만 허용해 임의 연산자 주입을 막습니다. 닉네임 철자가 'OPERATOR'가 아닌 'OPORATOR'로, AS-IS 오타를 그대로 계승했으므로 FE 호출 시 반드시 동일 철자를 사용해야 합니다. | DUAL |  | 321-332 |
| Lookup | P_NICKNAME='ROLES': SELECT USER_GR_ID, USER_GR_NM FROM SCM_ADM_USER_GR_M WHERE USE_YN = 'Y' (GET_ROLE_DATA와 동일 쿼리) | 사용 중인 사용자 그룹만 역할 콤보로 제공합니다. | SCM_ADM_USER_GR_M |  | 334-340 |
| Lookup | P_NICKNAME='BIZ_TYPE': SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'BIZ_TYPE_BPMS' (SEGMENT1=CODE, SEGMENT2=NAME) ORDER BY DISPLAY_SEQ — VALID_YN 필터 없음 | 사업 유형 콤보를 공통 Lookup 마스터에서 가져옵니다. 다른 Lookup 분기와 달리 유효여부(VALID_YN) 필터가 없어 무효 코드도 노출될 수 있는 차이점이 있습니다. | SCM_ADM_LOOKUP_MASTER_DETAIL |  | 342-349 |
| Lookup | P_NICKNAME='ITEM_TYPE_CODE': SCM_ADM_LOOKUP_MASTER_DETAIL WHERE VALID_YN = 'Y' AND LOOKUP_TYPE = 'ITEM_TYPE_CODE' ORDER BY DISPLAY_SEQ | 품목 유형 콤보를 Lookup 마스터에서 유효한 코드만 표시 순서대로 제공합니다. | SCM_ADM_LOOKUP_MASTER_DETAIL |  | 351-359 |
| Lookup | P_NICKNAME='INCOTERMS': SCM_ADM_LOOKUP_MASTER_DETAIL WHERE VALID_YN = 'Y' AND LOOKUP_TYPE = 'INCOTERMS' ORDER BY DISPLAY_SEQ | 인코텀즈(무역 거래조건) 콤보를 Lookup 마스터에서 유효한 코드만 표시 순서대로 제공합니다. | SCM_ADM_LOOKUP_MASTER_DETAIL |  | 361-369 |
| 검증 | ELSE 분기: SELECT NULL AS CODE, NULL AS NAME FROM DUAL WHERE 1 = 0 — 미등록 닉네임은 에러 대신 0행 반환 | 정의되지 않은 콤보 이름으로 호출되면 오류를 내지 않고 빈 목록을 돌려줍니다. 화면이 죽지 않는 대신, 콤보가 조용히 비어 보이므로 닉네임 오타 시 원인 파악이 어려울 수 있는 fail-silent 설계입니다. | DUAL |  | 371-376 |
| 커서 | 분기별 O_RC1 OPEN(9곳) + 공통 O_RESULT_CURSOR('0'/'SUCCESS') 1곳 — 프로시저 내 OPEN FOR 총 10곳 | 어떤 분기를 타든 데이터 커서와 성공 상태 커서가 항상 쌍으로 반환됩니다. | DUAL |  | 292-379 |
| 검증 | EXCEPTION WHEN OTHERS: ROLLBACK → JSON_OBJECT('P_NICKNAME' VALUE P_NICKNAME) 캡처 → PR_SCM_SYS_LOG_BATCH → RAISE_APPLICATION_ERROR(-20001) + RAISE | 오류 시 어떤 콤보 이름으로 호출했는지 로그에 남기고 상세 에러를 전파합니다. | SCM_COM_SYS_LOG(간접) | RAISE_APPLICATION_ERROR(-20001, '[PKG_SYS0013] SQLCODE=... / SQLERRM=... / BACKTRACE=... / PARAMS={P_NICKNAME}') 후 RAISE 재전파 | 381-405 |

#### P_SYS0013_GET_QUERY_LIST  (11건)
_역할: Dynamic Query 목록을 검색조건(ID/이름/역할 — 콤마 다중값)과 사용자 Division 권한으로 필터링하고, 행별 접근 그룹·편집가능여부(EDIT_YN)를 붙여 조회한다._  
_쉬운 설명: SYS0013 메인 그리드의 조회 프로시저입니다. 쿼리ID/쿼리명/역할 조건을 콤마로 여러 개 넣어 검색할 수 있고, 각 행에는 접근 허용 그룹 목록(GROUP_ID/GROUP_NAME)과 현재 사용자가 그 행을 수정할 수 있는지(EDIT_YN)가 함께 내려갑니다. 사용자의 메뉴별 Division 권한(SCM_ADM_USER_MNU_EDIT_AUTH_V)에 해당하지 않는 사업부의 쿼리는 아예 목록에서 제외됩니다._
- **함수 호출**: {"fn": "SCM_MGR.PR_SCM_SYS_LOG_BATCH", "purpose": "START/END/ERROR 로그 기록 (3곳)", "line": "454, 546, 571"}

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Bulk구분자 | SPLIT_DQ_ID / SPLIT_DQ_NAME / SPLIT_ROLE 3개 CTE — TRIM(REGEXP_SUBSTR(파라미터, '[^,]+', 1, LEVEL)) FROM DUAL CONNECT BY ... IS NOT NULL 로 콤마 구분 다중값 분해 (MSSQL UF_FX_String_Split 대체) | 검색조건 3종(ID/이름/역할)에 '1,2,3'처럼 콤마로 여러 값을 넣으면 값별로 쪼개어 OR 검색합니다. 구분자는 '^'가 아닌 콤마(,)임에 주의해야 합니다. | DUAL |  | 458-472 |
| Division | WHERE EXISTS (SELECT 1 FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2 WHERE T2.USER_ID=P_USER_ID AND T2.MNU_ID=P_MNU_ID AND T2.UNIT_TP_CD='D' AND (A.DIVISION_ID=T2.UNIT_ID OR A.DIVISION_ID='-')) | 현재 사용자가 이 메뉴에서 권한을 가진 사업부(Division)의 쿼리이거나, 사업부 무관('-' placeholder)인 쿼리만 목록에 보입니다. 권한 없는 사업부의 쿼리는 조회 자체가 차단되는 행 단위 데이터 권한 필터입니다. | SCM_ADM_DQ_LIST, SCM_ADM_USER_MNU_EDIT_AUTH_V |  | 508-512 |
| 편집제약 | NVL((SELECT MAX(T2A.EDIT_YN) FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2A WHERE T2A.USER_ID=P_USER_ID AND T2A.MNU_ID=P_MNU_ID AND T2A.UNIT_TP_CD='D' AND (A.DIVISION_ID=T2A.UNIT_ID OR A.DIVISION_ID='-')), 'N') AS EDIT_YN | 행별로 '이 사용자가 이 쿼리를 수정할 수 있는가'를 계산합니다. 권한 뷰에 편집 권한이 하나라도 있으면(MAX='Y') 편집 가능, 권한 행이 아예 없으면 기본값 'N'(수정 불가)입니다. FE는 이 값으로 행 편집 잠금을 제어합니다. | SCM_ADM_USER_MNU_EDIT_AUTH_V, SCM_ADM_DQ_LIST |  | 504-506 |
| NVL·기본값 | GROUP_ID = 'ALL,' \|\| NVL((SELECT LISTAGG(B.GROUP_ID, ',') WITHIN GROUP (ORDER BY B.GROUP_ID) FROM SCM_ADM_DQ_USER_GROUP B LEFT JOIN SCM_ADM_USER_GR_M C ON B.GROUP_ID=C.USER_GR_ID AND C.USE_YN='Y' WHERE B.VALID_YN='Y' AND B.DQ_ID=A.DQ_ID), '') | 쿼리별 접근 허용 그룹ID들을 콤마로 이어붙이되 맨 앞에 'ALL,'을 항상 붙입니다. 그룹 매핑이 없으면 'ALL,'만 남아 모든 사용자가 접근 가능한 쿼리로 취급됩니다. 유효(VALID_YN='Y')한 매핑만 집계합니다. | SCM_ADM_DQ_USER_GROUP, SCM_ADM_USER_GR_M |  | 486-494 |
| NVL·기본값 | GROUP_NAME = NVL((SELECT LISTAGG(C.USER_GR_NM, ',') WITHIN GROUP (ORDER BY C.USER_GR_NM) ... 동일 조인/필터), 'ALL') | 접근 그룹의 '이름' 목록도 콤마로 이어붙이며, 매핑이 없으면 화면에 'ALL'로 표시됩니다. | SCM_ADM_DQ_USER_GROUP, SCM_ADM_USER_GR_M |  | 495-503 |
| 검증 | (NVL(P_DQ_ID,'')='' OR EXISTS (SELECT 1 FROM SPLIT_DQ_ID P WHERE A.DQ_ID LIKE P.TOKEN \|\| '%')) — 미입력 시 전체, 입력 시 토큰별 전방일치 | 쿼리ID 조건을 안 넣으면 전체를 보여주고, 넣으면 각 콤마 토큰으로 시작하는 ID를 모두 찾습니다. 주의: Oracle에서 ''=NULL이므로 NVL(x,'')='' 비교는 'x IS NULL' 판정으로 동작합니다(공백 미입력 시 전체 조회 의도는 충족). | SCM_ADM_DQ_LIST |  | 514 |
| 검증 | (NVL(P_DQ_NAME,'')='' OR EXISTS (SELECT 1 FROM SPLIT_DQ_NAME P WHERE A.DQ_NAME LIKE P.TOKEN \|\| '%')) — 쿼리명 토큰별 전방일치 | 쿼리명 조건도 동일하게 미입력 시 전체, 입력 시 콤마 토큰별 '~로 시작' 검색입니다. | SCM_ADM_DQ_LIST |  | 515 |
| 검증 | 외부 WHERE: (NVL(P_ROLE,'')='' OR EXISTS (SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%' \|\| P.TOKEN \|\| '%')) — 조립된 GROUP_ID 문자열('ALL,g1,g2')에 대한 부분일치 | 역할 조건을 넣으면 해당 그룹이 접근 그룹 목록에 포함된 쿼리만 남깁니다. 'ALL' 접두어 때문에 P_ROLE='ALL' 검색 시 모든 행이 매칭되며, 부분일치(LIKE %토큰%) 방식이라 그룹ID가 다른 그룹ID의 부분 문자열이면 오탐 가능성이 있는 구조입니다. | SCM_ADM_DQ_USER_GROUP, SCM_ADM_USER_GR_M |  | 534 |
| 정렬 | ORDER BY TO_NUMBER(DQ_ID) | 쿼리ID를 숫자로 변환해 오름차순 정렬합니다. DQ_ID 컬럼이 VARCHAR2 파라미터로 다뤄지므로 숫자가 아닌 ID가 존재하면 ORA-01722 위험이 있습니다. | SCM_ADM_DQ_LIST |  | 535 |
| 커서 | 이중 OUT 커서 표준 — O_RC1(WITH~SELECT 결과 14컬럼) + O_RESULT_CURSOR('0'/'SUCCESS'). START/END 로그 PR_SCM_SYS_LOG_BATCH 동반 | 목록 데이터와 성공 상태를 두 커서로 나눠 반환하고, 프로시저 시작/종료 시점을 시스템 로그에 남깁니다. | DUAL |  | 449-546 |
| 검증 | EXCEPTION WHEN OTHERS: ROLLBACK → 5개 파라미터 전부 JSON_OBJECT 캡처(P_DQ_ID/P_DQ_NAME/P_ROLE/P_USER_ID/P_MNU_ID) → ERROR 로그 → RAISE_APPLICATION_ERROR(-20001) + RAISE (O_RESULT_CURSOR 미오픈 상태로 에러 전파) | 오류 시 검색조건 전부를 로그로 남기고, 성공 커서를 열지 않은 채 에러를 그대로 올려보내 FE가 실패를 명확히 인지하게 합니다. | SCM_COM_SYS_LOG(간접) | RAISE_APPLICATION_ERROR(-20001, '[PKG_SYS0013] SQLCODE=... / SQLERRM=... / BACKTRACE=... / PARAMS={P_DQ_ID,P_DQ_NAME,P_ROLE,P_USER_ID,P_MNU_ID}') 후 RAISE 재전파 | 548-585 |

#### P_SYS0013_GET_COLUMNS  (5건)
_역할: 특정 Dynamic Query(DQ_ID)의 유효한 결과 컬럼 정의 목록(컬럼명/값여부/타입/순번/집계함수)을 조회한다._  
_쉬운 설명: 선택한 Dynamic Query의 결과 그리드에 어떤 컬럼을 어떤 타입·순서·집계 방식으로 보여줄지 정의한 메타 목록을 내려줍니다. GET_PARAMETERS와 달리 VALID_YN='Y'인 유효 컬럼만 조회하며, ATTRIBUTE1=순번(SEQNO), ATTRIBUTE2=집계함수(AGGREGATE: SUM/MAX/MIN/COUNT) 매핑입니다. 원본 MSSQL의 다중 DQ_ID/DQ_NAME 필터(UF_FX_String_Split)는 주석으로 보존되어 있고 실제로는 단일 DQ_ID 정확 일치만 사용합니다._
- **함수 호출**: {"fn": "SCM_MGR.PR_SCM_SYS_LOG_BATCH", "purpose": "START/END/ERROR 로그 기록 (3곳)", "line": "631, 671, 692"}

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 검증 | WHERE A.VALID_YN = 'Y' AND A.DQ_ID = P_DQ_ID — 유효 컬럼만 + 단일 쿼리ID 정확 일치 (MSSQL 시절 다중 ID split 필터는 L650-660 주석으로 비활성 보존) | 무효 처리된 컬럼은 결과 그리드 구성에서 제외하고, 요청한 쿼리ID의 컬럼만 조회합니다. | SCM_ADM_DQ_COLUMN |  | 634-660 |
| NVL·기본값 | NVL(A.ATTRIBUTE1, '0') AS SEQNO / A.ATTRIBUTE2 AS AGGREGATE (2026-06-26 주석: AGGREGATE(SUM/MAX/MIN/COUNT)=ATTRIBUTE2) | 순번이 비어 있으면 '0'으로 간주하고, 확장속성2를 집계함수 컬럼으로 별칭 매핑합니다. AGGREGATE는 NVL 없이 NULL 그대로 내려가 '집계 미지정'을 표현합니다. | SCM_ADM_DQ_COLUMN |  | 644-645 |
| 정렬 | ORDER BY TO_NUMBER(NVL(A.ATTRIBUTE1, '0')), A.LAST_UPDATE_DATE | 컬럼을 지정 순번(숫자) 순으로, 같은 순번이면 최종수정일 순으로 정렬합니다. ATTRIBUTE1 비숫자 값 유입 시 ORA-01722 잠재 위험은 GET_PARAMETERS와 동일합니다. | SCM_ADM_DQ_COLUMN |  | 649 |
| 커서 | 이중 OUT 커서 표준 — O_RC1(컬럼 메타 11컬럼) + O_RESULT_CURSOR('0'/'SUCCESS'). START/END 로그 동반 | 컬럼 메타와 성공 상태를 두 커서로 나눠 반환하고 시작/종료를 로그에 남깁니다. | DUAL |  | 626-671 |
| 검증 | EXCEPTION WHEN OTHERS: ROLLBACK → JSON_OBJECT('P_DQ_ID' VALUE P_DQ_ID) 캡처 → ERROR 로그 → RAISE_APPLICATION_ERROR(-20001) + RAISE (O_RESULT_CURSOR 미오픈) | 오류 시 쿼리ID를 로그로 남기고 에러를 그대로 전파합니다. | SCM_COM_SYS_LOG(간접) | RAISE_APPLICATION_ERROR(-20001, '[PKG_SYS0013] SQLCODE=... / SQLERRM=... / BACKTRACE=... / PARAMS={P_DQ_ID}') 후 RAISE 재전파 | 673-706 |

#### P_SYS0013_SAVE_QUERY_LIST  (7건)
_역할: Dynamic Query 목록(SCM_ADM_DQ_LIST)의 신규(I)/수정(M)/삭제(D)를 JSON 배열 payload로 일괄 저장한다._  
_쉬운 설명: 화면 그리드에서 편집한 쿼리 목록 행들을 JSON 배열로 받아 crudType(I/M/D)별로 등록·수정·삭제합니다. 신규 등록 시 쿼리ID는 현재 최대값+1로 자동 채번되고, 입력이 비어 있는 항목은 사업부 '-', 유효 'Y', 관리자전용 'N' 등 안전한 기본값으로 채워집니다. 처리 건수(AFFECTED)를 O_RC1로 돌려줍니다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Bulk구분자 | FOR rec IN (SELECT * FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(crudType/dqId/divisionId/dqName/description/dqText(CLOB)/validYn/adminOnlyYn))) LOOP — JSON 배열 행 단위 커서 루프, CRUD_TYPE 'I'/'M'/'D' 분기 | 저장 데이터를 '^' 구분자 대신 JSON 배열로 받아 행마다 등록/수정/삭제를 판별해 처리합니다. 표준 SAVE SP 패턴('$[*]' + cursor LOOP)입니다. | SCM_ADM_DQ_LIST |  | 726-772 |
| PK·중복 | I 분기: SELECT NVL(MAX(DQ_ID), 0) + 1 INTO V_NEW_DQ_ID FROM SCM_ADM_DQ_LIST — MAX+1 자동 채번 후 INSERT | 신규 쿼리의 ID를 테이블의 현재 최대 ID+1로 자동 부여해 PK 중복을 피합니다. 단, 동시 저장 세션이 겹치면 같은 ID를 채번할 수 있는 동시성 한계가 있는 방식입니다. | SCM_ADM_DQ_LIST |  | 740 |
| NVL·기본값 | INSERT VALUES: NVL(rec.DIVISION_ID,'-') / NVL(rec.DQ_NAME,'') / NVL(rec.DESCRIPTION,'') / NVL(rec.VALID_YN,'Y') / NVL(rec.ADMIN_ONLY_YN,'N') / 감사컬럼 = V_USER(NVL(P_USER_ID,'admin')) + SYSDATE | 신규 행의 누락 값을 안전한 기본값으로 채웁니다. 사업부 미지정은 '-'(전체), 유효여부는 'Y', 관리자전용은 'N'이 기본이고, 작성자/수정자는 로그인 사용자(없으면 'admin')로 기록됩니다. | SCM_ADM_DQ_LIST |  | 724, 741-754 |
| NVL·기본값 | M 분기 UPDATE: SET 컬럼 = NVL(rec.컬럼, 기존컬럼) 6종 (DIVISION_ID/DQ_NAME/DESCRIPTION/DQ_TEXT/VALID_YN/ADMIN_ONLY_YN) — payload에 없는(NULL) 필드는 기존값 유지하는 부분 갱신 | 수정 시 화면에서 보내지 않은 항목은 건드리지 않고 기존 값을 그대로 보존합니다. 단, 이 방식 특성상 값을 'NULL로 지우는' 갱신은 불가능합니다. | SCM_ADM_DQ_LIST |  | 756-767 |
| PK·중복 | M/D 분기 대상 특정: WHERE DQ_ID = rec.DQ_ID (단일 PK 키) / D: DELETE FROM SCM_ADM_DQ_LIST WHERE DQ_ID = rec.DQ_ID, 처리건수 SQL%ROWCOUNT 누적 | 수정·삭제는 쿼리ID 하나로만 대상을 특정하므로 다른 행이 영향받을 수 없습니다. 실제 반영된 건수를 세어 화면에 알려줍니다. | SCM_ADM_DQ_LIST |  | 766-770 |
| 커서 | OPEN O_RC1 FOR SELECT V_AFFECTED AS AFFECTED FROM DUAL + O_RESULT_CURSOR('0'/'SUCCESS') | 총 처리 건수와 성공 상태를 두 커서로 반환합니다. COMMIT 문이 없어 트랜잭션 확정은 호출자(BE) 책임입니다. | DUAL |  | 774-777 |
| 검증 | EXCEPTION WHEN OTHERS: ROLLBACK → RAISE_APPLICATION_ERROR(-20001, SQLCODE/SQLERRM/BACKTRACE) — GET 계열과 달리 PR_SCM_SYS_LOG_BATCH 로그 기록·PARAMS 캡처·bare RAISE 없음 | 저장 오류 시 전체를 되돌리고 에러 내용을 호출자에게 전달합니다. 조회 프로시저들과 달리 시스템 로그 테이블 기록은 생략된 간소화 예외 처리입니다. |  | RAISE_APPLICATION_ERROR(-20001, '[PKG_SYS0013] SQLCODE=... / SQLERRM=... / BACKTRACE=...') | 779-788 |

#### P_SYS0013_SAVE_COLUMNS  (6건)
_역할: Dynamic Query 컬럼 정의(SCM_ADM_DQ_COLUMN)의 신규/수정/삭제를 JSON 배열 payload로 일괄 저장한다._  
_쉬운 설명: 쿼리 결과 컬럼 정의 그리드의 편집 내용을 JSON 배열로 받아 crudType별로 반영합니다. 신규 컬럼은 값여부 'Y', 타입 'System.String', 유효 'Y', 순번 '0'이 기본값이며, 순번은 ATTRIBUTE1, 집계함수는 ATTRIBUTE2에 저장됩니다. 수정·삭제 대상은 쿼리ID+컬럼명 복합키로 특정합니다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Bulk구분자 | JSON_TABLE(P_DATA, '$[*]' COLUMNS(crudType/dqId/columnName/valueYn/valueType/validYn/seqno/aggregate)) cursor LOOP + CRUD_TYPE 'I'/'M'/'D' 분기 | 컬럼 편집 행들을 JSON 배열로 받아 행마다 등록/수정/삭제를 처리합니다. | SCM_ADM_DQ_COLUMN |  | 806-844 |
| NVL·기본값 | I 분기 INSERT: NVL(rec.VALUE_YN,'Y') / NVL(rec.VALUE_TYPE,'System.String') / NVL(rec.VALID_YN,'Y') / ATTRIBUTE1=NVL(rec.SEQNO,'0') / ATTRIBUTE2=rec.AGGREGATE(기본값 없음) / 감사컬럼 V_USER+SYSDATE | 신규 컬럼의 누락 값을 기본값으로 채웁니다. 데이터 타입을 안 정하면 문자열(System.String)로, 순번을 안 정하면 '0'으로 저장됩니다. 집계함수는 지정하지 않으면 비워둡니다(집계 안 함). | SCM_ADM_DQ_COLUMN |  | 804, 819-827 |
| NVL·기본값 | M 분기 UPDATE: SET 컬럼 = NVL(rec.컬럼, 기존컬럼) 5종 (VALUE_YN/VALUE_TYPE/VALID_YN/ATTRIBUTE1=SEQNO/ATTRIBUTE2=AGGREGATE) — 부분 갱신, NULL 지우기 불가 | 수정 시 보내지 않은 항목은 기존 값을 유지합니다. 한번 지정한 집계함수를 NULL로 되돌리는 갱신은 이 패턴으로는 불가능합니다. | SCM_ADM_DQ_COLUMN |  | 829-839 |
| PK·중복 | M/D 대상 특정: WHERE DQ_ID = rec.DQ_ID AND COLUMN_NAME = rec.COLUMN_NAME (복합키) / D: DELETE 동일 키, SQL%ROWCOUNT 누적 | 수정·삭제는 '어느 쿼리의 어느 컬럼인지' 두 키를 모두 맞춰야 반영되므로 다른 쿼리의 동명 컬럼이 영향받지 않습니다. | SCM_ADM_DQ_COLUMN |  | 838-842 |
| 커서 | OPEN O_RC1 FOR SELECT V_AFFECTED AS AFFECTED FROM DUAL + O_RESULT_CURSOR('0'/'SUCCESS') | 총 처리 건수와 성공 상태를 두 커서로 반환합니다. COMMIT은 호출자 책임입니다. | DUAL |  | 846-848 |
| 검증 | EXCEPTION WHEN OTHERS: ROLLBACK → RAISE_APPLICATION_ERROR(-20001, SQLCODE/SQLERRM/BACKTRACE) — 로그 기록·PARAMS·bare RAISE 없음 | 저장 오류 시 전체 롤백 후 에러를 호출자에게 전달합니다. |  | RAISE_APPLICATION_ERROR(-20001, '[PKG_SYS0013] SQLCODE=... / SQLERRM=... / BACKTRACE=...') | 850-859 |

#### P_SYS0013_SAVE_PARAMETERS  (6건)
_역할: Dynamic Query 파라미터 정의(SCM_ADM_DQ_PARAMETER)의 신규/수정/삭제를 JSON 배열 payload로 일괄 저장한다._  
_쉬운 설명: 쿼리 실행 파라미터 정의 그리드의 편집 내용을 JSON 배열로 받아 crudType별로 반영합니다. 신규 파라미터는 타입 'Parameter', 연산자 '-', 유효 'Y', 대표여부 'N', 순번 '0'이 기본값이며, 순번은 ATTRIBUTE1, 기본값은 ATTRIBUTE2에 저장됩니다. 수정·삭제 대상은 쿼리ID+파라미터ID 복합키로 특정합니다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Bulk구분자 | JSON_TABLE(P_DATA, '$[*]' COLUMNS(crudType/dqId/parameterId/parameterType/operationId/validYn/repYn/seqno/defaultValue)) cursor LOOP + CRUD_TYPE 'I'/'M'/'D' 분기 | 파라미터 편집 행들을 JSON 배열로 받아 행마다 등록/수정/삭제를 처리합니다. | SCM_ADM_DQ_PARAMETER |  | 876-924 |
| NVL·기본값 | I 분기 INSERT: NVL(rec.PARAMETER_TYPE,'Parameter') / NVL(rec.OPERATION_ID,'-') / NVL(rec.VALID_YN,'Y') / NVL(rec.REP_YN,'N') / ATTRIBUTE1=NVL(rec.SEQNO,'0') / ATTRIBUTE2=rec.DEFAULT_VALUE(기본값 없음) / 감사컬럼 V_USER(NVL(P_USER_ID,'admin'))+SYSDATE | 신규 파라미터의 누락 값을 기본값으로 채웁니다. 유형 미지정은 'Parameter', 연산자 미지정은 '-'(placeholder), 대표여부는 'N'이 기본입니다. | SCM_ADM_DQ_PARAMETER |  | 874, 890-905 |
| NVL·기본값 | M 분기 UPDATE: SET 컬럼 = NVL(rec.컬럼, 기존컬럼) 6종 (PARAMETER_TYPE/OPERATION_ID/VALID_YN/REP_YN/ATTRIBUTE1=SEQNO/ATTRIBUTE2=DEFAULT_VALUE) — 부분 갱신, NULL 지우기 불가 | 수정 시 보내지 않은 항목은 기존 값을 유지합니다. 기본값(DEFAULT_VALUE)을 빈 값으로 되돌리는 갱신은 이 패턴으로는 불가능합니다. | SCM_ADM_DQ_PARAMETER |  | 907-918 |
| PK·중복 | M/D 대상 특정: WHERE DQ_ID = rec.DQ_ID AND PARAMETER_ID = rec.PARAMETER_ID (복합키) / D: DELETE 동일 키, SQL%ROWCOUNT 누적 | 수정·삭제는 '어느 쿼리의 어느 파라미터인지' 두 키를 모두 맞춰야 반영됩니다. | SCM_ADM_DQ_PARAMETER |  | 917-922 |
| 커서 | OPEN O_RC1 FOR SELECT V_AFFECTED AS AFFECTED FROM DUAL + O_RESULT_CURSOR('0'/'SUCCESS') | 총 처리 건수와 성공 상태를 두 커서로 반환합니다. COMMIT은 호출자 책임입니다. | DUAL |  | 926-928 |
| 검증 | EXCEPTION WHEN OTHERS: ROLLBACK → RAISE_APPLICATION_ERROR(-20001, SQLCODE/SQLERRM/BACKTRACE) — 로그 기록·PARAMS·bare RAISE 없음 | 저장 오류 시 전체 롤백 후 에러를 호출자에게 전달합니다. |  | RAISE_APPLICATION_ERROR(-20001, '[PKG_SYS0013] SQLCODE=... / SQLERRM=... / BACKTRACE=...') | 930-939 |

### 5-B. standalone 34객체 (PROC 24 / FUNC 4 / TYPE 6 — 전 객체 ≥1행)

#### SYS0013_GET_QUERY_LIST (PROC, 8건)
_역할: Dynamic Query 목록을 DQ_ID/DQ_NAME/역할(GROUP) 필터 + 사용자 Division 편집권한(EDIT_YN)과 함께 조회._  
_쉬운 설명: 관리자가 등록한 동적 쿼리 목록 화면의 메인 조회 — 검색조건과 내 권한그룹에 보이는 쿼리만, 수정 가능 여부(EDIT_YN)까지 붙여서 반환._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Bulk구분자 | SPLIT_DQ_ID/SPLIT_DQ_NAME/SPLIT_ROLE — TRIM(REGEXP_SUBSTR(p,'[^,]+',1,LEVEL)) CONNECT BY | 검색조건 3개(P_DQ_ID/P_DQ_NAME/P_ROLE)를 콤마로 분해해 다중값 검색 지원 | DUAL |  | 49-63 |
| 검증 | EXISTS(... A.DQ_ID LIKE token\|\|'%') AND EXISTS(... A.DQ_NAME LIKE token\|\|'%') | 쿼리ID·쿼리명은 각 토큰의 전방일치(LIKE 접두)로 필터 | SCM_ADM_DQ_LIST |  | 105-106 |
| 검증 | EXISTS(SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%'\|\|P.TOKEN\|\|'%') | 역할 필터는 집계된 GROUP_ID 문자열에 대한 부분일치('ALL' 포함이라 빈 역할도 통과) |  |  | 125 |
| Division | INNER JOIN SCM_ADM_USER_MNU_EDIT_AUTH_V T2 ON A.DIVISION_ID=T2.UNIT_ID, WHERE USER_ID=P_USER_ID AND MNU_ID=P_MNU_ID AND UNIT_TP_CD='D' | 사용자·메뉴별 Division 권한 뷰와 INNER JOIN — 권한 뷰에 없는 Division의 쿼리는 목록에서 아예 제외됨(AS-IS에 없던 TO-BE 추가 제약) | SCM_ADM_USER_MNU_EDIT_AUTH_V |  | 97-102 |
| Lookup | LISTAGG(B.GROUP_ID/C.USER_GR_NM) — SCM_ADM_DQ_USER_GROUP B.VALID_YN='Y' LEFT JOIN SCM_ADM_USER_GR_M C.USE_YN='Y' | 쿼리별 허용 사용자그룹 ID/명칭을 콤마 집계(유효 그룹만) | SCM_ADM_DQ_USER_GROUP, SCM_ADM_USER_GR_M |  | 77-94 |
| NVL·기본값 | 'ALL,'\|\|NVL(LISTAGG...,'') AS GROUP_ID / NVL(LISTAGG...,'ALL') AS GROUP_NAME / NVL(T2.EDIT_YN,'N') AS EDIT_YN | 그룹 미지정 쿼리는 'ALL'(전체 공개)로 표시, 편집권한 미확인 시 'N' |  |  | 77, 86, 95 |
| 커서 | 이중 OUT 커서: O_RC1(데이터) + O_RESULT_CURSOR('0'/'SUCCESS'/EVENT NULL) | NSCM 표준 Dual OUT 커서 — 데이터와 처리결과를 분리 반환 | DUAL |  | 48, 128-129 |
| 커서 | EXCEPTION WHEN OTHERS → ROLLBACK + PR_SCM_SYS_LOG_BATCH(JSON_OBJECT 파라미터) + RAISE_APPLICATION_ERROR(-20001) + RAISE | 오류 시 입력 파라미터를 JSON으로 로그에 남기고 -20001로 전파(O_RESULT_CURSOR 미오픈) |  | [SYS0013_GET_QUERY_LIST] SQLCODE=.. / SQLERRM=.. / BACKTRACE=.. / PARAMS=.. | 138-175 |

#### SYS0013_GET_QUERY_LIST_COMMON (PROC, 9건)
_역할: P_NICKNAME 분기(9종)로 화면 공통 콤보(컬럼타입/집계/연산자/역할/Lookup 3종) 코드-명칭 목록 반환._  
_쉬운 설명: Dynamic Query 편집 화면의 각종 드롭다운(데이터타입, SUM/MAX 같은 집계, =/IN/LIKE 연산자, 사용자그룹, 사업유형 등) 내용물 공급기._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Lookup | P_NICKNAME='COLTYPES' → 고정 3행(System.String/Int/Date) UNION ALL FROM DUAL | 파라미터 값 타입 콤보(하드코딩 목록) | DUAL |  | 23-30 |
| Lookup | P_NICKNAME='COMBO' → 고정 2행(DIVISION_ID/SCM_SITE_ID) | 콤보형 파라미터로 쓸 수 있는 컬럼 목록(하드코딩) | DUAL |  | 32-37 |
| Lookup | P_NICKNAME='AGGREGATE' → SUM/MAX/MIN/COUNT 4행('GROUP'은 주석 제외 — AS-IS 동일) | 집계함수 콤보 | DUAL |  | 39-50 |
| Lookup | P_NICKNAME='OPORATOR'(원문 오탈자 그대로) → =/IN/LIKE/>/< 5행 | 조건 연산자 콤보 — 닉네임 철자 오류(OPORATOR)가 AS-IS부터 계약이므로 보존됨 | DUAL |  | 52-63 |
| Lookup | P_NICKNAME='ROLES' → SCM_ADM_USER_GR_M WHERE USE_YN='Y' | 사용자그룹 콤보(사용중인 그룹만) — AS-IS TB_FX_GroupInfo 를 TO-BE 권한 마스터로 치환 | SCM_ADM_USER_GR_M |  | 65-71 |
| Lookup | P_NICKNAME='BIZ_TYPE' → SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='BIZ_TYPE_BPMS' (VALID_YN 조건 없음 — AS-IS 동일) | 사업유형 콤보. 이 분기만 VALID_YN 필터가 없음(원본 답습) | SCM_ADM_LOOKUP_MASTER_DETAIL |  | 73-80 |
| Lookup | P_NICKNAME='ITEM_TYPE_CODE' → VALID_YN='Y' AND LOOKUP_TYPE='ITEM_TYPE_CODE' / P_NICKNAME='INCOTERMS' → VALID_YN='Y' AND LOOKUP_TYPE='INCOTERMS' | 품목유형·인코텀즈 콤보(유효 코드만) | SCM_ADM_LOOKUP_MASTER_DETAIL |  | 82-100 |
| 정렬 | BIZ_TYPE/ITEM_TYPE_CODE/INCOTERMS 3분기 ORDER BY DISPLAY_SEQ | Lookup 콤보는 관리자가 지정한 표시순서로 정렬 | SCM_ADM_LOOKUP_MASTER_DETAIL |  | 80, 90, 100 |
| 커서 | ELSE → 0행 빈커서(WHERE 1=0) 오픈 + O_RESULT_CURSOR('0'/'SUCCESS') / EXCEPTION → RAISE_APPLICATION_ERROR(-20001) | 미지원 닉네임도 커서는 항상 오픈(TO-BE 추가 — AS-IS는 결과셋 자체가 없었음), 오류는 -20001 전파 | DUAL | [SYS0013_GET_QUERY_LIST_COMMON] SQLCODE=.. / PARAMS={P_NICKNAME} | 102-110, 130-136 |

#### SYS0013_GET_COLUMNS (PROC, 5건)
_역할: 특정 DQ_ID의 유효 컬럼 정의 목록(SEQNO 순) 조회._  
_쉬운 설명: 선택한 동적 쿼리가 화면 그리드에 어떤 컬럼을 어떤 순서로 보여줄지 정의를 가져온다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 검증 | WHERE A.VALID_YN='Y' AND A.DQ_ID=P_DQ_ID (단일 등호 — 콤마 다중검색은 AS-IS부터 주석 보류) | 유효한 컬럼만, 쿼리ID 정확 일치. 주석의 String_Split 다중검색 로직은 AS-IS에서도 비활성이었고 그대로 보존 | SCM_ADM_DQ_COLUMN |  | 59-60, 62-72 |
| NVL·기본값 | NVL(A.ATTRIBUTE1,'0') AS SEQNO | 표시순서 미지정 컬럼은 0으로 간주 |  |  | 57 |
| 정렬 | ORDER BY TO_NUMBER(NVL(A.ATTRIBUTE1,'0')), A.LAST_UPDATE_DATE | 숫자화한 SEQNO → 최종수정일 순 (ATTRIBUTE1에 비숫자 유입 시 ORA-01722 위험 내포, AS-IS CAST(INT)와 동일 계약) |  |  | 61 |
| 커서 | 이중 OUT 커서 O_RC1 + O_RESULT_CURSOR('0'/'SUCCESS') | NSCM 표준 Dual OUT 커서 | DUAL |  | 47, 75-76 |
| 커서 | EXCEPTION → ROLLBACK + JSON_OBJECT 로그 + RAISE_APPLICATION_ERROR(-20001) + RAISE | 오류 -20001 전파 표준 블록 |  | [SYS0013_GET_COLUMNS] SQLCODE=.. / PARAMS={P_DQ_ID} | 85-118 |

#### SYS0013_GET_DYNAMIC_QUERYS (PROC, 4건)
_역할: 전달받은 SQL 문자열을 그대로 동적 실행해 결과셋 반환(필터 없음)._  
_쉬운 설명: 관리자 전용 '쿼리 그대로 실행' 기능 — 입력 SQL을 가공 없이 실행한다(인젝션 정규화 없음, EXECUTE_QUERY와의 차이점)._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 커서 | OPEN O_RC1 FOR P_SQL_TEXT — 동적 커서 오픈(EXECUTE IMMEDIATE 미사용) | SQL 문자열 자체를 커서로 실행. SELECT 이외 문장은 여기서 오류로 전파 | (동적 — P_SQL_TEXT 의존) |  | 28 |
| 검증 | 입력 SQL 무검증(FN_GET_NORMAL_STRING2 미적용) | AS-IS DMF0027_GET_DM_DYNAMIC_QUERYS 와 동일하게 인젝션 필터가 없음 — 관리자 화면 전제 |  |  | 28 |
| 커서 | O_RESULT_CURSOR('0'/'SUCCESS') 오픈 | 성공 결과 커서 | DUAL |  | 30-31 |
| 커서 | EXCEPTION → 로그(P_SQL_TEXT는 SUBSTR 1..500만 기록) + RAISE_APPLICATION_ERROR(-20001) — AS-IS의 '99^ERR' 결과셋 계약을 예외 전파로 변경 | 오류 시 SQL 앞 500자만 로그로 남기고 -20001로 던짐(FE 에러 처리 방식이 AS-IS와 다름) |  | [SYS0013_GET_DYNAMIC_QUERYS] SQLCODE=.. / PARAMS={P_SQL_TEXT(500자)} | 34-58 |

#### SYS0013_GET_HISTORY (PROC, 5건)
_역할: SCM_ADM_DQ_EXECUTE_H 실행 이력 조회(2026-06-15 신규 — AS-IS에 GET SP 미존재)._  
_쉬운 설명: 동적 쿼리를 누가 언제 어떤 SQL로 실행했는지 이력 목록. AS-IS에는 없던 신규 조회 SP._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 검증 | WHERE (P_DQ_ID IS NULL OR P_DQ_ID='' OR DQ_ID=P_DQ_ID) | DQ_ID 미지정 시 전체 이력. 단 Oracle에서 ''=NULL 이므로 P_DQ_ID='' 분기는 도달 불가(무해한 잉여 조건) | SCM_MGR.SCM_ADM_DQ_EXECUTE_H |  | 25 |
| 정렬 | ORDER BY HISTORY_SEQ DESC | 최신 실행 이력부터 |  |  | 26 |
| 편집제약 | P_USER_ID/P_MNU_ID 파라미터는 수신만 하고 본문에서 미사용 | 권한 필터 미구현 상태(시그니처만 확보) — 이력이 사용자 구분 없이 전량 노출됨을 정직 기록 |  |  | 4-5 |
| 커서 | O_RESULT_CURSOR가 RESULT_CODE(숫자 0)/RESULT_MESSAGE 컬럼 — 다른 SYS0013 GET들의 CODE('0')/MSG/EVENT 스키마와 상이 | 결과 커서 컬럼명이 표준과 다름(FE 매핑 시 주의) | DUAL |  | 28-31 |
| 커서 | EXCEPTION 블록·로그 호출 없음 | 표준 예외/로그 블록이 없는 유일한 GET — 오류 시 원 예외가 그대로 전파 |  |  | 15-32 |

#### SYS0013_GET_PARAMETERS (PROC, 5건)
_역할: 특정 DQ_ID의 파라미터 정의 목록(SEQNO 순) 조회._  
_쉬운 설명: 선택한 동적 쿼리가 실행 전 사용자에게 물어볼 입력값(파라미터) 정의를 가져온다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 검증 | WHERE DQ_ID=P_DQ_ID (VALID_YN 필터 없음 — AS-IS 동일: COLUMNS는 'Y'만, PARAMETERS는 전체) | 쿼리ID 정확 일치. 컬럼 조회와 달리 무효 파라미터도 반환(원본 계약 보존) | SCM_ADM_DQ_PARAMETER |  | 41 |
| NVL·기본값 | NVL(ATTRIBUTE1,'0') AS SEQNO | 순번 미지정은 0 |  |  | 39 |
| 정렬 | ORDER BY TO_NUMBER(NVL(ATTRIBUTE1,'0')), LAST_UPDATE_DATE | 지정순번 → 수정일 순 |  |  | 42 |
| 커서 | 이중 OUT 커서 O_RC1 + O_RESULT_CURSOR('0'/'SUCCESS') | 표준 Dual OUT 커서 | DUAL |  | 28, 44-45 |
| 커서 | EXCEPTION → RAISE_APPLICATION_ERROR(-20001) + RAISE | 오류 -20001 전파 표준 블록 |  | [SYS0013_GET_PARAMETERS] SQLCODE=.. / PARAMS={P_DQ_ID} | 47-71 |

#### SYS0013_GET_ROLE_DATA (PROC, 3건)
_역할: 사용중(USE_YN='Y') 사용자그룹 전체를 CODE/NAME 으로 반환._  
_쉬운 설명: 권한그룹 지정 팝업용 그룹 목록(입력 파라미터 없음)._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Lookup | SELECT USER_GR_ID AS CODE, USER_GR_NM AS NAME FROM SCM_ADM_USER_GR_M WHERE USE_YN='Y' | 사용중 그룹만 — AS-IS TB_FX_GroupInfo(UseYN)를 TO-BE 권한 마스터로 치환 | SCM_ADM_USER_GR_M |  | 24-29 |
| 커서 | 이중 OUT 커서 + O_RESULT_CURSOR('0'/'SUCCESS') | 표준 Dual OUT 커서 | DUAL |  | 24, 31-32 |
| 커서 | EXCEPTION → JSON_OBJECT('NO_PARAM' VALUE 'N/A') 로그 + RAISE_APPLICATION_ERROR(-20001) | 무파라미터 SP의 표준 예외 블록 |  | [SYS0013_GET_ROLE_DATA] SQLCODE=.. | 34-56 |

#### SYS0013_EXECUTE_QUERY (PROC, 4건)
_역할: SQL 문자열을 FN_GET_NORMAL_STRING2 로 인젝션 정규화한 뒤 동적 실행._  
_쉬운 설명: 일반 사용자용 동적 쿼리 실행 — 위험 구문을 걸러내는 정규화 함수를 반드시 거친 뒤 실행한다(2019 인젝션 방비 이력 승계)._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 검증 | V_S_QUERY := FN_GET_NORMAL_STRING2(P_SQL_TEXT) — 실행 전 인젝션 정규화 의무 | AS-IS DMF0027_..._LIST2 의 쿼리 인젝션 방비(2019/04) 로직 보존 | (FN_GET_NORMAL_STRING2) |  | 32 |
| 편집제약 | V_S_QUERY VARCHAR2(32767 CHAR) — AS-IS NVARCHAR(MAX) 대비 32K 길이 상한 | 32,767자 초과 SQL은 처리 불가(원본 무제한 대비 축소된 격차) |  |  | 23 |
| 커서 | OPEN O_RC1 FOR V_S_QUERY + O_RESULT_CURSOR('0'/'SUCCESS') | 정규화된 SQL을 커서로 실행 | (동적 — P_SQL_TEXT 의존), DUAL |  | 34-37 |
| 커서 | EXCEPTION → SUBSTR(P_SQL_TEXT,1,500) 로그 + RAISE_APPLICATION_ERROR(-20001) — AS-IS '99^ERR' 결과셋 계약을 예외 전파로 변경 | 오류를 결과행이 아닌 예외로 던짐 |  | [SYS0013_EXECUTE_QUERY] SQLCODE=.. / PARAMS={P_SQL_TEXT(500자)} | 39-63 |

#### SYS0013_EXECUTE_HIST (PROC, 4건)
_역할: 쿼리 실행 이력 1건을 SCM_ADM_DQ_EXECUTE_H 에 INSERT(경량 신규판 — PR_DM_ADM_DQ_EXECUTE_HIST 병존)._  
_쉬운 설명: 실행 버튼을 누를 때마다 '언제 어떤 SQL' 이력을 남기는 기록기. DQ_TEXT는 대용량 CLOB 수용._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| PK·중복 | HISTORY_SEQ = SEQ1_SCM_ADM_DQ_EXECUTE_H.NEXTVAL | 이력 PK는 시퀀스 채번(중복 불가) | SCM_ADM_DQ_EXECUTE_H |  | 9-11 |
| NVL·기본값 | NVL(P_DQ_ID,'-'), NVL(P_DQ_TEXT,'-'), NVL(P_CREATED_BY,'system'), NVL(P_LAST_UPDATED_BY,'system'), SYSDATE | NULL 입력을 '-'/'system' placeholder 로 치환해 NOT NULL 위반 방지 |  |  | 11-12 |
| 커서 | OPEN O_RC1 FOR SELECT 'success' AS CODE FROM DUAL (단일 커서 — Dual 커서 아님) | 저장계 경량 SP는 success 1행 단일 커서 반환 | DUAL |  | 14 |
| 편집제약 | COMMIT/EXCEPTION 블록 없음 — 트랜잭션 확정과 오류 처리를 호출측(BE)에 위임 | BE 트랜잭션 경계에서 커밋되는 설계(같은 계열 PR_DM_ADM_DQ_EXECUTE_HIST 는 내부 COMMIT — 정책 이원화 정직 기록) |  |  | 8-15 |

#### SYS0013_SAVE_QUERY (PROC, 8건)
_역할: JSON 배열(P_DATA)의 CRUD_TYPE(I/M/D)별로 SCM_ADM_DQ_LIST 를 다건 저장(2026-06-18 Multiple Row 개정)._  
_쉬운 설명: 쿼리 목록 그리드에서 여러 행을 한 번에 저장 — 각 행의 I(신규)/M(수정)/D(삭제) 플래그대로 처리하고 이력을 남긴다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Bulk구분자 | JSON_TABLE(P_DATA,'$[*]' COLUMNS ... NULL ON EMPTY NULL ON ERROR) FOR LOOP | JSON 배열을 행 단위로 풀어 처리(구분자 문자열 대신 JSON bulk — '^' 미사용) |  |  | 34-62 |
| 편집제약 | ACTIVE_FLAG=JT CRUD_TYPE: 'I' INSERT / 'M' UPDATE / 'D' DELETE 3분기(그 외 값 무시) | 행별 CRUD 플래그 라우팅 — I/M/D 외 플래그는 이력만 남고 본테이블 무변경 | SCM_ADM_DQ_LIST |  | 81-109 |
| PK·중복 | 'I' 채번: SELECT NVL(MAX(TO_NUMBER(DQ_ID)),0)+1 — 시퀀스 미사용 MAX+1 | 신규 DQ_ID는 현재 최대값+1. 동시 저장 시 중복 채번 가능성 있는 방식(PR_DM_ADM_DQ_CREATE 는 시퀀스 사용 — 채번 이원화 정직 기록) | SCM_ADM_DQ_LIST |  | 82 |
| PK·중복 | 'I' 분기는 기존행 DELETE 없이 단순 INSERT (SAVE_COLUMNS/PARAMETERS 의 delete-then-insert 와 다름) | 채번 신규라 upsert 불필요 — 단 DQ_ID 수동 충돌 시 PK 위반 전파 | SCM_ADM_DQ_LIST |  | 81-87 |
| NVL·기본값 | NVL(V_DIVISION_ID,'-'), NVL(V_DQ_NAME,'-'), NVL(V_DESCRIPTION,'-'), NVL(V_DQ_TEXT,'-'), NVL(V_VALID_YN,'Y'), NVL(V_ADMIN_ONLY_YN,'Y'), NVL(...,'system') | 누락 필드는 '-'/'Y'/'system' 기본값 — NOT NULL 방어 + 신규쿼리 기본 '유효/관리자전용' |  |  | 77-93 |
| 일자·캘린더 | CREATION_DATE/LAST_UPDATE_DATE = SYSDATE (모든 I/M/HIST) | 저장 시각은 DB 서버 시간 |  |  | 79, 87, 93 |
| PK·중복 | 행마다 본처리 전 SCM_ADM_DQ_LIST_H 이력 INSERT(SEQ1_SCM_ADM_DQ_LIST_H.NEXTVAL) | 변경 전 스냅샷이 아닌 '요청값' 이력 — 모든 저장 요청이 감사 추적됨 | SCM_ADM_DQ_LIST_H |  | 75-79 |
| 커서 | COMMIT 후 OPEN O_RC1 FOR 'success' + V_NEW_ID AS SEQNO (M/D 는 '#' 연결 문자열, I 는 신규 ID) | 저장 성공 시 처리된 ID 들을 '#' 구분 문자열로 반환(내부 COMMIT 있음) | DUAL |  | 96-114 |

#### SYS0013_SAVE_COLUMNS (PROC, 7건)
_역할: JSON 배열의 CRUD_TYPE 별로 SCM_ADM_DQ_COLUMN 을 다건 저장(I=delete-then-insert upsert)._  
_쉬운 설명: 쿼리 컬럼 정의 그리드 일괄 저장 — 신규는 같은 키를 먼저 지우고 넣는 방식이라 재등록에도 안전._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Bulk구분자 | JSON_TABLE(P_DATA,'$[*]') FOR LOOP — COLUMN_NAME 파싱폭 VARCHAR2(30 CHAR)(로컬변수는 200) | JSON bulk 처리. 단 컬럼명 JSON 파싱폭이 30자로 좁아 30자 초과 컬럼명은 NULL ON ERROR 로 NULL 화되는 함정 정직 기록 |  |  | 29-54, 46 |
| PK·중복 | 'I' → DELETE(DQ_ID+COLUMN_NAME) 후 INSERT — PK 기준 upsert | 같은 컬럼 재등록 시 중복 오류 대신 대체 | SCM_ADM_DQ_COLUMN |  | 72-78 |
| 편집제약 | 'M' UPDATE / 'D' DELETE WHERE DQ_ID=V_DQ_ID AND COLUMN_NAME=V_COLUMN_NAME | 수정·삭제는 복합 PK 정확 일치 행만 | SCM_ADM_DQ_COLUMN |  | 79-87 |
| NVL·기본값 | NVL(V_DQ_ID,0), NVL(V_COLUMN_NAME,'-'), NVL(V_VALUE_YN,'N'), NVL(V_VALUE_TYPE,'STR'), NVL(V_VALID_YN,'Y'), NVL(...,'system'); ATTRIBUTE1 은 NVL 없이 원값 | 누락값 기본치 — 값컬럼 아님(N)/문자타입(STR)/유효(Y). 순번(ATTRIBUTE1)만은 NULL 허용 그대로 |  |  | 68-83 |
| PK·중복 | 행마다 SCM_ADM_DQ_COLUMN_H 이력 INSERT(SEQ1_SCM_ADM_DQ_COLUMN_H.NEXTVAL) | 요청값 전건 이력화 | SCM_ADM_DQ_COLUMN_H |  | 66-70 |
| 편집제약 | COMMIT 문 없음(SAVE_QUERY 와 달리) — 호출측 트랜잭션 위임 | 같은 화면의 SAVE 4종 중 QUERY 만 내부 COMMIT — 트랜잭션 정책 불일치 정직 기록 |  |  | 88-90 |
| 커서 | OPEN O_RC1 FOR SELECT 'success' AS CODE FROM DUAL / EXCEPTION 블록 없음(오류 원 예외 전파) | 성공 단일 커서, 실패는 예외 그대로 | DUAL |  | 90 |

#### SYS0013_SAVE_PARAMETERS (PROC, 7건)
_역할: JSON 배열의 CRUD_TYPE 별로 SCM_ADM_DQ_PARAMETER 를 다건 저장(I=delete-then-insert upsert)._  
_쉬운 설명: 쿼리 파라미터 정의 그리드 일괄 저장 — 파라미터 타입/연산자/대표여부까지 한 번에._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Bulk구분자 | JSON_TABLE(P_DATA,'$[*]' COLUMNS ...) FOR LOOP — OPERATION_ID/REP_YN 은 NULL ON EMPTY 미지정 | JSON bulk 처리(행 단위 루프) |  |  | 31-59 |
| PK·중복 | 'I' → DELETE(DQ_ID+PARAMETER_ID) 후 INSERT | 동일 파라미터 재등록 시 대체(upsert) | SCM_ADM_DQ_PARAMETER |  | 77-83 |
| 편집제약 | 'M' UPDATE / 'D' DELETE WHERE DQ_ID=V_DQ_ID AND PARAMETER_ID=V_PARAMETER_ID | 복합 PK 정확 일치 행만 수정·삭제 | SCM_ADM_DQ_PARAMETER |  | 84-92 |
| NVL·기본값 | NVL(V_DQ_ID,0), NVL(V_PARAMETER_ID,'-'), NVL(V_PARAMETER_TYPE,'TEXT'), NVL(V_OPERATION_ID,'-'), NVL(V_VALID_YN,'Y'), NVL(V_REP_YN,'N'), NVL(...,'system'); ATTRIBUTE1 원값 | 기본 파라미터타입 TEXT, 연산자 '-', 대표여부 N — NOT NULL 방어(PR_ 계열의 ' ' 공백과 달리 '-' 사용) |  |  | 73-87 |
| PK·중복 | 행마다 SCM_ADM_DQ_PARAMETER_H 이력 INSERT(SEQ1_SCM_ADM_DQ_PARAMETER_H.NEXTVAL) | 요청값 전건 이력화 | SCM_ADM_DQ_PARAMETER_H |  | 71-75 |
| 편집제약 | COMMIT 문 없음 — 호출측 트랜잭션 위임 | BE 경계 커밋 설계 |  |  | 93-95 |
| 커서 | OPEN O_RC1 FOR 'success' / EXCEPTION 블록 없음 | 성공 단일 커서, 실패는 예외 그대로 | DUAL |  | 95 |

#### SYS0013_SAVE_USER_GROUP (PROC, 4건)
_역할: 쿼리-사용자그룹 매핑 1건을 MERGE(upsert) 저장 + 이력 INSERT._  
_쉬운 설명: 이 쿼리를 어떤 권한그룹에 공개할지 1건 저장 — 이미 있으면 갱신, 없으면 추가._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| PK·중복 | MERGE INTO SCM_ADM_DQ_USER_GROUP ON (DQ_ID, GROUP_ID) MATCHED→UPDATE / NOT MATCHED→INSERT | 복합키 기준 upsert — PK 중복 오류 원천 차단(TO-BE 34객체 중 유일한 MERGE) | SCM_ADM_DQ_USER_GROUP |  | 15-25 |
| NVL·기본값 | NVL(P_DQ_ID,'-'), NVL(P_GROUP_ID,'-'), NVL(P_VALID_YN,'Y'), NVL(...,'system') | NULL 입력 placeholder 치환('-' 키가 실데이터로 들어갈 수 있음 주의) |  |  | 12-25 |
| PK·중복 | 본처리 전 SCM_ADM_DQ_USER_GROUP_H 이력 INSERT(SEQ1_SCM_ADM_DQ_USER_GROUP_H.NEXTVAL) | 매핑 변경 요청 전건 이력화 | SCM_ADM_DQ_USER_GROUP_H |  | 10-13 |
| 커서 | OPEN O_RC1 FOR 'success' / COMMIT·EXCEPTION 없음 | 성공 단일 커서, 커밋은 호출측 | DUAL |  | 27 |

#### SYS0013_DELETE_USER_GROUP (PROC, 4건)
_역할: DQ_ID의 그룹 매핑 전부를 이력 보존(VALID_YN='N' 기록) 후 일괄 DELETE._  
_쉬운 설명: 쿼리의 권한그룹 지정을 전부 해제 — 지우기 전에 '삭제됨(N)' 이력을 남긴다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| PK·중복 | INSERT-SELECT: 삭제 대상 전행을 SCM_ADM_DQ_USER_GROUP_H 에 VALID_YN='N' 으로 복사(SEQ NEXTVAL) | 삭제 전 스냅샷 이력 — 삭제 표식 N 부여 | SCM_ADM_DQ_USER_GROUP_H, SCM_ADM_DQ_USER_GROUP |  | 8-12 |
| 편집제약 | DELETE FROM SCM_ADM_DQ_USER_GROUP WHERE DQ_ID=P_DQ_ID (GROUP_ID 조건 없음 — 전체 매핑 삭제) | 해당 쿼리의 매핑 전량 삭제(부분 삭제 불가) | SCM_ADM_DQ_USER_GROUP |  | 14 |
| NVL·기본값 | 이력의 LAST_UPDATED_BY = NVL(P_LAST_UPDATED_BY,'system'), 시각 SYSDATE | 삭제 수행자 기록(미지정 시 system) |  |  | 11 |
| 커서 | OPEN O_RC1 FOR 'success' / COMMIT·EXCEPTION 없음 | 성공 단일 커서, 커밋은 호출측 | DUAL |  | 16 |

#### PR_DM_ADM_DQ_CREATE (PROC, 7건)
_역할: SCM_ADM_DQ_LIST 단건 I/M/D — AS-IS 동명 SP의 1:1 Oracle 변환본(#22 C-트랙, 2026-06-26)._  
_쉬운 설명: 동적 쿼리 1건 등록/수정/삭제. 처리 전 이력 SP 를 먼저 호출하고, 신규는 시퀀스로 ID를 딴다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 편집제약 | P_ACTIVE_FLAG 'I'/'M'/'D' 3분기(그 외 무시 — HIST 만 남음) | 행 상태 플래그 라우팅(AS-IS IF 구조 1:1) | SCM_ADM_DQ_LIST |  | 44-61 |
| PK·중복 | 'I' 채번: V_N_HISTORY_SEQ := SEQ1_SCM_ADM_DQ_LIST.NEXTVAL 이 DQ_ID 로 INSERT (AS-IS NEXT VALUE FOR 등가) | 신규 DQ_ID 시퀀스 채번 — SYS0013_SAVE_QUERY 의 MAX+1 방식과 이원화 | SCM_ADM_DQ_LIST |  | 44-47 |
| 편집제약 | 'M' UPDATE / 'D' DELETE WHERE DQ_ID=P_DQ_ID | PK 일치 단건 수정·삭제(M 은 CREATED_BY 불변 — AS-IS 주석 보존) | SCM_ADM_DQ_LIST |  | 50-61 |
| PK·중복 | 본처리 전 PR_DM_ADM_DQ_CREATE_HIST 호출(9 args) — I/M/D 공통 이력 | CREATE 계열 중 유일하게 이력을 '먼저' 남김(COLUMN/PARAMETER 는 뒤에) — AS-IS 순서 보존 | SCM_ADM_DQ_LIST_H |  | 40-41 |
| 일자·캘린더 | CREATION_DATE/LAST_UPDATE_DATE = SYSDATE (AS-IS sysdatetime()) | 저장 시각 DB 서버 기준 |  |  | 47, 54 |
| 커서 | 내부 COMMIT 후 성공 시 OPEN O_RESULT FOR 'success'+V_N_HISTORY_SEQ AS SEQNO / 에러 시 '[SQLCODE]SQLERRM' 1행 커서(비재발생) | AS-IS 의 bare SELECT 결과셋 계약을 OUT REF 커서로 이식 — 에러도 예외가 아닌 '결과행'으로 반환(FE 는 CODE 문자열 검사 필요) | DUAL | [SQLCODE]SQLERRM (커서 CODE 컬럼) | 63-81 |
| 커서 | EXCEPTION 내 ROLLBACK + PR_SCM_SYS_LOG_BATCH ERROR 로그, RAISE 없음(V_HAS_ERROR 플래그) | 오류를 삼키고 로그+에러커서로 종결(AS-IS TRY/CATCH 비재발생 동일) |  |  | 65-76 |

#### PR_DM_ADM_DQ_CREATE_COLUMN (PROC, 6건)
_역할: SCM_ADM_DQ_COLUMN 단건 I/M/D(I=PK delete 후 insert) — AS-IS 동명 SP 1:1 변환(#23)._  
_쉬운 설명: 쿼리 컬럼 정의 1건 저장 — 신규는 같은 (쿼리ID, 컬럼명)을 먼저 지우고 넣어 재등록 안전._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| PK·중복 | 'I' → DELETE(DQ_ID+COLUMN_NAME) 후 INSERT(ATTRIBUTE1=P_SEQNO) | 복합 PK upsert(AS-IS 'INSERT전 PK값 DELETE' 1:1) | SCM_ADM_DQ_COLUMN |  | 37-41 |
| 편집제약 | 'M' UPDATE(ATTRIBUTE1=P_SEQNO 포함, CREATED_BY 불변) / 'D' DELETE — WHERE DQ_ID+COLUMN_NAME | 순번(SEQNO)은 ATTRIBUTE1 예비컬럼에 저장 | SCM_ADM_DQ_COLUMN |  | 44-54 |
| PK·중복 | I/M/D 처리 '후' PR_DM_ADM_DQ_CREATE_COLUMN_HIST(7 args) 호출 — SEQNO 는 이력에 미전달 | 이력엔 순번이 안 남음(HIST 시그니처가 7개 — AS-IS 동일 격차) | SCM_ADM_DQ_COLUMN_H |  | 56-57 |
| 일자·캘린더 | CREATION_DATE/LAST_UPDATE_DATE = SYSDATE | 저장 시각 DB 서버 기준 |  |  | 40, 47 |
| 커서 | 내부 COMMIT / 성공 'success' 1컬럼 커서(SEQNO 없음 — CREATE 와 달리) / 에러 '[SQLCODE]SQLERRM' 커서 비재발생 | 결과 커서가 CODE 1컬럼뿐 — AS-IS SELECT 'success' 1:1 | DUAL | [SQLCODE]SQLERRM (커서 CODE 컬럼) | 59-76 |
| 커서 | EXCEPTION → ROLLBACK + ERROR 로그(SQLERRM 변수 경유 — SQL문 직접사용 불가 lesson) | 오류 삼킴+로그 표준(비재발생) |  |  | 61-72 |

#### PR_DM_ADM_DQ_CREATE_COLUMN_HIST (PROC, 4건)
_역할: SCM_ADM_DQ_COLUMN_H 이력 1건 INSERT(OUT 커서 없음 — 내부 호출 전용)._  
_쉬운 설명: 컬럼 정의가 바뀔 때마다 남는 이력 기록기 — 부모 SP가 내부적으로 부른다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| PK·중복 | V_HISTORY_SEQ := SEQ1_SCM_ADM_DQ_COLUMN_H.NEXTVAL 로 INSERT | 이력 PK 시퀀스 채번 | SCM_MGR.SCM_ADM_DQ_COLUMN_H |  | 63-90 |
| 편집제약 | UTL_CALL_STACK.SUBPROGRAM 으로 V_PROGRAM_NAME 동적 결정 + AS-IS 결과셋('success')을 DBMS_OUTPUT 으로 대체(OUT 커서 주석처리) | 패키지 이관 대비 프로그램명 자동 기록. 결과셋 계약이 사라짐(호출측이 결과를 안 보므로 무해 — 정직 기록) |  |  | 44-48, 98-100 |
| 편집제약 | 내부 COMMIT(종료 직전 1회) + N_LOG_COUNT=SQL%ROWCOUNT 로그 | 이력 1건 즉시 확정 — 부모 트랜잭션과 분리됨 |  |  | 93-96 |
| 커서 | EXCEPTION → ROLLBACK + JSON_OBJECT 7파라미터 로그 + RAISE_APPLICATION_ERROR(-20001) — AS-IS(에러표시 후 계속)와 달리 부모로 예외 전파 | 이력 실패가 부모 CREATE_COLUMN 의 CATCH 로 올라가 전체 롤백을 유발(AS-IS 대비 엄격해진 계약) |  | [PR_DM_ADM_DQ_CREATE_COLUMN_HIST] SQLCODE=.. / PARAMS=.. | 109-143 |

#### PR_DM_ADM_DQ_CREATE_HIST (PROC, 4건)
_역할: SCM_ADM_DQ_LIST_H 이력 1건 INSERT(내부 호출 전용, 오류 비전파)._  
_쉬운 설명: 쿼리 본문이 바뀔 때마다 남는 이력 기록기 — 실패해도 부모 저장을 막지 않는다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| PK·중복 | SELECT SEQ1_SCM_ADM_DQ_LIST_H.NEXTVAL INTO N_HISTORY_SEQ FROM DUAL 후 INSERT | 이력 PK 시퀀스 채번 | SCM_ADM_DQ_LIST_H, DUAL |  | 61-94 |
| 편집제약 | 내부 COMMIT + PR_SCM_SYS_LOG_BATCH_CALL_TRAN(자율 트랜잭션 로그) 사용 | 부모 트랜잭션과 충돌 없는 로그 경로(AS-IS CALL_TRAN 1:1) |  |  | 44, 96, 105 |
| 커서 | EXCEPTION → LOCAL_TRANSACTION_ID 있을 때만 ROLLBACK + DBMS_OUTPUT + ERROR 로그, '-- RAISE;' 주석 = 오류 비전파 | 이력 실패를 삼킴(AS-IS CATCH 비재발생과 동일) — 4개 HIST 중 COLUMN/PARAMETER_HIST 는 전파, CREATE/USER_GROUP 계열은 비전파·조건전파로 상이함 정직 기록 |  |  | 107-145 |
| NVL·기본값 | 파라미터 무가공 INSERT(NVL 없음) — NULL 이면 이력 테이블 NOT NULL 제약에 따라 실패 가능 | 이 SP 는 기본값 치환이 없음(SYS0013_SAVE_QUERY 의 이력 INSERT 는 NVL 처리 — 신구 병존 차이) | SCM_ADM_DQ_LIST_H |  | 80-94 |

#### PR_DM_ADM_DQ_CREATE_PARAMETER (PROC, 7건)
_역할: SCM_ADM_DQ_PARAMETER 단건 I/M/D(I=PK delete 후 insert) — AS-IS 동명 SP 1:1 변환(#24)._  
_쉬운 설명: 쿼리 파라미터 정의 1건 저장. MSSQL 의 '' 입력이 Oracle 에선 NULL 이 되는 문제를 공백(' ')으로 메꾼 NOT NULL 방어가 핵심._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| NVL·기본값 | V_OPERATION_ID := NVL(P_OPERATION_ID,' ') / V_REP_YN := NVL(P_REP_YN,' ') — NOT NULL 컬럼 ''→NULL 변환 대응, INSERT/UPDATE/HIST 3곳 일관 사용 | AS-IS 가 빈문자('')를 넣던 NOT NULL 컬럼 2개를 공백 1자로 치환(lesson_empty_string_notnull) — 데이터 값이 AS-IS('')와 미세하게 다름(' ') 정직 기록 | SCM_ADM_DQ_PARAMETER |  | 32-33, 43-44, 50-51, 61 |
| PK·중복 | 'I' → DELETE(DQ_ID+PARAMETER_ID) 후 INSERT(ATTRIBUTE1=P_SEQNO) | 복합 PK upsert | SCM_ADM_DQ_PARAMETER |  | 41-45 |
| 편집제약 | 'M' UPDATE / 'D' DELETE — WHERE DQ_ID+PARAMETER_ID | 복합 PK 일치 행만 수정·삭제 | SCM_ADM_DQ_PARAMETER |  | 48-58 |
| PK·중복 | I/M/D 후 PR_DM_ADM_DQ_CREATE_PARAMETER_HIST(8 args, V_OPERATION_ID/V_REP_YN 보정값 전달) 호출 | 이력에도 동일 보정값이 남아 본테이블-이력 정합 유지 | SCM_ADM_DQ_PARAMETER_H |  | 60-61 |
| 일자·캘린더 | CREATION_DATE/LAST_UPDATE_DATE = SYSDATE | 저장 시각 DB 서버 기준 |  |  | 44, 51 |
| 커서 | 내부 COMMIT / 성공 'success' 1컬럼 커서 / 에러 '[SQLCODE]SQLERRM' 커서 비재발생 | AS-IS 결과셋 계약 이식 | DUAL | [SQLCODE]SQLERRM (커서 CODE 컬럼) | 63-80 |
| 커서 | EXCEPTION → ROLLBACK + ERROR 로그(V_HAS_ERROR 플래그로 성공커서 억제) | 오류 삼킴+로그 표준 |  |  | 65-76 |

#### PR_DM_ADM_DQ_CREATE_PARAMETER_HIST (PROC, 3건)
_역할: SCM_ADM_DQ_PARAMETER_H 이력 1건 INSERT(내부 호출 전용, 오류는 -20001 전파)._  
_쉬운 설명: 파라미터 정의 변경 이력 기록기._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| PK·중복 | V_HISTORY_SEQ := SEQ1_SCM_ADM_DQ_PARAMETER_H.NEXTVAL 로 INSERT(파라미터 무가공 — NVL 없음) | 이력 PK 시퀀스 채번. 기본값 보정은 부모 SP 책임 | SCM_MGR.SCM_ADM_DQ_PARAMETER_H |  | 64-93 |
| 편집제약 | 내부 COMMIT + UTL_CALL_STACK 프로그램명 + 결과셋→DBMS_OUTPUT 대체(OUT 커서 주석) | 이력 즉시 확정, AS-IS 'success' 결과셋 계약 제거 |  |  | 44-49, 96-103 |
| 커서 | EXCEPTION → ROLLBACK + JSON 8파라미터 로그 + RAISE_APPLICATION_ERROR(-20001) 전파 | 이력 실패 시 부모 CATCH 로 전파(AS-IS 비재발생 대비 엄격화) |  | [PR_DM_ADM_DQ_CREATE_PARAMETER_HIST] SQLCODE=.. / PARAMS=.. | 112-147 |

#### PR_DM_ADM_DQ_CREATE_USER_GROUP (PROC, 6건)
_역할: 콤마 구분 GROUP_ID 다중값을 분할해 DQ_ID 매핑을 delete-then-insert 일괄 재등록 — AS-IS 동명 SP 변환(#25)._  
_쉬운 설명: 쿼리의 권한그룹을 'A,B,C' 처럼 한 번에 지정 — 기존 지정을 첫 토큰 처리 때 전부 지우고 새로 넣는다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Bulk구분자 | V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_GROUP_ID,',') / 토큰 := SCM_ARR_SPL_VAL(P_GROUP_ID,',',I) — 콤마 분할 함수(양 DB 공통 검증 함수) | AS-IS WHILE 루프를 FOR 1..토큰수 로 등가 변환(recv 불변이므로 동작 동일) | (SCM_ARR_SPL_CNT/SCM_ARR_SPL_VAL 함수) |  | 38-42 |
| 검증 | IF P_GROUP_ID IS NOT NULL AND LENGTH(P_GROUP_ID)>0 가드(AS-IS LEN(recv)>0) | 빈 문자열/NULL 입력이면 아무것도 안 함(삭제도 안 됨 — 매핑 유지) |  |  | 40 |
| 편집제약 | IF I=1 THEN DELETE FROM SCM_ADM_DQ_USER_GROUP WHERE DQ_ID=P_DQ_ID — 첫 토큰에서 전체 삭제 후 토큰별 INSERT | delete-then-insert 일괄 재등록 패턴(부분 갱신 아님) | SCM_ADM_DQ_USER_GROUP |  | 47-54 |
| PK·중복 | 토큰마다 PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST(5 args) 선호출 | 그룹 토큰별 이력. AS-IS 의 확인용 SELECT 3종(디버그 결과셋)은 제거됨 — 결과셋 개수 계약 변화 정직 기록 | SCM_ADM_DQ_USER_GROUP_H |  | 44-45 |
| 일자·캘린더 | CREATION_DATE/LAST_UPDATE_DATE = SYSDATE | 저장 시각 DB 서버 기준 |  |  | 53-54 |
| 커서 | 내부 COMMIT / 성공 'success' 커서 / EXCEPTION → ROLLBACK + 로그 + 에러커서('[SQLCODE]SQLERRM') 비재발생 | AS-IS 결과셋 계약 이식 + 오류 삼킴 | DUAL | [SQLCODE]SQLERRM (커서 CODE 컬럼) | 58-75 |

#### PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE (PROC, 4건)
_역할: DQ_ID 기준 그룹 매핑 전체 DELETE — AS-IS 의 루프는 첫 회차만 DELETE 였으므로 단건 DELETE 로 등가 단순화._  
_쉬운 설명: 쿼리의 권한그룹 지정 전체 해제(이력 없이 바로 삭제). GROUP_ID 등 나머지 파라미터는 시그니처 호환용으로만 받음._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 편집제약 | DELETE FROM SCM_MGR.SCM_ADM_DQ_USER_GROUP WHERE DQ_ID=P_DQ_ID (루프 제거 — AS-IS 도 mst_loop_cnt=1 에서만 DELETE 수행이라 등가) | 전 매핑 삭제 1문. AS-IS 확인용 SELECT(max_loop_cnt/v_GROUP_ID/delete_cnt) 결과셋 제거 | SCM_MGR.SCM_ADM_DQ_USER_GROUP |  | 57-68 |
| 편집제약 | SYS0013_DELETE_USER_GROUP 과 달리 삭제 전 이력 INSERT 없음(AS-IS 도 없음 — 원본 계약 보존) | 이력을 남기려면 신규판(SYS0013_DELETE_USER_GROUP)을 써야 함 |  |  | 57-68 |
| 커서 | OUT 커서 주석처리 — 결과는 DBMS_OUTPUT 만(성공 결과셋 계약 제거) | AS-IS 'success' SELECT 가 사라짐 — BE 직접 호출용 아님 |  |  | 9, 73-75 |
| 커서 | 내부 COMMIT / EXCEPTION → ROLLBACK + JSON 5파라미터 로그 + RAISE_APPLICATION_ERROR(-20001) 전파 | 오류는 -20001 로 전파(같은 계열 CREATE_USER_GROUP 의 '삼킴' 과 다름) |  | [PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE] SQLCODE=.. / PARAMS=.. | 84-116 |

#### PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST (PROC, 4건)
_역할: SCM_ADM_DQ_USER_GROUP_H 이력 1건 INSERT(내부 호출 전용, 오류 RAISE 전파)._  
_쉬운 설명: 그룹 매핑 변경 이력 기록기._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| PK·중복 | N_HISTORY_SEQ := SEQ1_SCM_ADM_DQ_USER_GROUP_H.NEXTVAL 로 INSERT(무가공) | 이력 PK 시퀀스 채번 | SCM_ADM_DQ_USER_GROUP_H |  | 42-66 |
| 편집제약 | 내부 COMMIT + PR_SCM_SYS_LOG_BATCH_CALL_TRAN 로그 경로 | 부모 트랜잭션과 분리 확정 |  |  | 39, 68, 116 |
| 커서 | EXCEPTION(내부블록) → LOCAL_TRANSACTION_ID 조건 ROLLBACK + 로그 + RAISE(원 예외 재전파) | 이력 실패가 부모 CREATE_USER_GROUP 의 EXCEPTION 으로 올라가 전체 롤백 유발 |  |  | 69-105 |
| 편집제약 | V_LOG_MESSAGE IS NULL 일 때만 DBMS_OUTPUT 'success' — 결과셋 계약 없음 | AS-IS SELECT 'success' 를 DBMS_OUTPUT 으로 대체 |  |  | 107-109 |

#### PR_DM_ADM_DQ_EXECUTE_HIST (PROC, 3건)
_역할: SCM_ADM_DQ_EXECUTE_H 실행이력 1건 INSERT — AS-IS 동명 SP 1:1 변환(OUT 커서 없음)._  
_쉬운 설명: 쿼리 실행 이력 기록기(원변환판). DQ_TEXT 가 VARCHAR2 라 32K 제한 — CLOB 수용 신규판(SYS0013_EXECUTE_HIST)과 병존._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| PK·중복 | V_HISTORY_SEQ := SEQ1_SCM_ADM_DQ_EXECUTE_H.NEXTVAL 로 INSERT(무가공, SYSDATE) | 이력 PK 시퀀스 채번 — 신규판과 같은 시퀀스 공유 | SCM_MGR.SCM_ADM_DQ_EXECUTE_H |  | 60-81 |
| 편집제약 | P_DQ_TEXT VARCHAR2(32K 상한) vs SYS0013_EXECUTE_HIST 의 CLOB — 수용량 격차 / 내부 COMMIT / 결과셋→DBMS_OUTPUT | 긴 SQL 이력은 신규판 사용 필요 |  |  | 5, 84-91 |
| 커서 | EXCEPTION → ROLLBACK + JSON 로그(P_DQ_TEXT SUBSTR 1..500) + RAISE_APPLICATION_ERROR(-20001) | 오류 -20001 전파 |  | [PR_DM_ADM_DQ_EXECUTE_HIST] SQLCODE=.. / PARAMS=.. | 100-131 |

#### FN_DQ_FP_PLAN (FUNC, 9건)
_역할: FP(공장) 일 생산 실적+계획을 K Cell 단위 주차 pivot 소스로 반환하는 PIPELINED 테이블 함수._  
_쉬운 설명: 동적 쿼리에서 'FP 계획' 을 조회할 때 쓰는 데이터 공급 함수 — 조회일~지난 실적, 당주부터 8주(소형 40본부는 12주) 계획을 합쳐준다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 일자·캘린더 | V_START_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')+(-7),'YYYYMMDD') — 당주 월요일 | 실적/계획의 경계를 이번 주 월요일로 자름 |  |  | 16 |
| 일자·캘린더 | V_END := 당주월요일 + (7*12-1 \| 7*8-1) — P_DIVISION_ID LIKE '%40%' 면 12주, 아니면 8주 | 소형(40본부)만 12주, 그 외 중대형 8주 계획 구간 |  |  | 19-23 |
| Division | A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID,','))) / A.PLANT_ID IN (FN_STRING_SPLIT(P_PLANT_ID,',')) | 사업부·공장 콤마 다중값 필터(실적/계획 양쪽 동일 적용) | (FN_STRING_SPLIT) |  | 62-63, 79-80 |
| 일자·캘린더 | 실적: PLAN_DATE BETWEEN 조회기준일 AND 당주월요일-1 / 계획: BETWEEN 당주월요일 AND V_END | 과거 구간은 실적 테이블, 당주 이후는 계획 테이블에서 — 겹침 없이 이어붙임 | SCM_DNM_DAILY_PRODUCT_RESULT_SN, SCM_DNM_DAILY_PRODUCT_PLAN_SN |  | 64, 81 |
| 검증 | OPERATION_ID='E2000' AND FP_PRODUCTION_TYPE IN ('C-MASS','MASS') AND CELL_OUT_QTY>0 (실적·계획 공통), 계획은 추가로 PLAN_TYPE='RELEASE' | 포장(E2000) 공정의 양산 물량만, 확정(RELEASE) 계획만 집계 |  |  | 65-67, 82-85 |
| Lookup | INNER JOIN SCM_MST_PLANT_SN/SCM_MST_LINE_SN/SCM_MST_ITEM_SN/SCM_MST_BUCKET (모두 INNER — 마스터 미등록이면 행 탈락) | 공장명/라인명/품목별칭/주차버킷을 마스터에서 붙임. 마스터 누락 데이터는 결과에서 사라짐 주의 | SCM_MST_PLANT_SN, SCM_MST_LINE_SN, SCM_MST_ITEM_SN, SCM_MST_BUCKET |  | 92-118 |
| 편집제약 | TYPE 분류: APPLIED_MODEL LIKE 'A%'→'AUTOMOTIVE' / 'E%'→'ESS' / ELSE CELL_TYPE | 적용모델 접두문자로 자동차/ESS 구분 | SCM_MST_ITEM_SN |  | 38-40 |
| 편집제약 | YYYYWW 표기 = SUBSTR(YYYYPW,3,2)\|\|'_W'\|\|SUBSTR(YYYYPW,5,2)\|\|분할주차 접미 / QTY = CELL_OUT_QTY/1000.0 (K Cell) | 주차 라벨 'YY_Wnn(_x)' 생성 + 천 단위 셀 환산 | SCM_MST_BUCKET |  | 43-47 |
| 커서 | FOR REC LOOP → PIPE ROW(FN_DQ_FP_PLAN_ROW(17필드)) PIPELINED 반환 | SELECT * FROM TABLE(FN_DQ_FP_PLAN(...)) 형태로 동적 쿼리에서 소비 |  |  | 120-142 |

#### FN_DQ_MKT_FCST_81 (FUNC, 9건)
_역할: 81본부(자동차) 주간 시장수요예측(MKT FCST/RTF/AS-In) 최신버전을 Cell 환산 집계로 반환하는 PIPELINED 함수._  
_쉬운 설명: 자동차 사업부 수요예측 데이터를 동적 쿼리에서 쓰기 위한 공급 함수 — 입력일이 속한 주의 최신 버전만 골라 셀 수량으로 환산해 준다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 일자·캘린더 | cutoff_yyyymmdd >= 입력일 주차 월요일(FN_NEXT_DAY(TO_DATE(p_cutoff_date,'YYYYMMDD'),'MON')-7) AND < 다음주 월요일, cutoff_type='MF_W', MAX(version_no) | 입력일이 속한 '그 주' 에 생성된 주간(MF_W) 버전 중 최신 1개만 사용 | DM_PLN_MKT_FCST_C |  | 104-115 |
| Division | m.division_id = p_division_id (단일값 등호 — FP_PLAN/PROD_PLAN 의 콤마 split 과 달리 다중값 미지원) | 사업부 1개만 조회 가능(81 전용 함수) | DM_PLN_MKT_FCST_C |  | 108, 152 |
| 검증 | m.measure IN ('MKT_FCST_RP','RTF_SYS_RP','AS_In_Req','AS_In_Plan') + 표시명 CASE 매핑('MKT FCST[R+P]' 등, 미매핑 '') | 4개 측정치만 조회하고 화면용 이름으로 변환 |  |  | 75-80, 153 |
| 검증 | cell_model LIKE '%'\|\|p_cell_nickname\|\|'%' | 셀 모델명 부분일치 필터(빈값이면 전체) |  |  | 156 |
| Lookup | SALES_TYPE_CODE(L46)·ITEM_TYPE_CODE(L56) — SCM_ADM_LOOKUP_MASTER_DETAIL 스칼라 서브쿼리 SEGMENT1→SEGMENT2 표시명(VALID_YN 조건 없음) | 예측유형·품목유형 코드를 이름으로 변환. 중복 코드 존재 시 단일행 서브쿼리 ORA-01427 위험 내포 | SCM_ADM_LOOKUP_MASTER_DETAIL |  | 44-48, 54-58 |
| 편집제약 | operation_group 'A'→item_id/group_code1 자체, 'P'→attribute1 및 그 품목의 group_code1, ELSE '' — cell_item_id/cell_model 분기 | 조립(A)품목은 자신, 팩(P)품목은 연결된 셀 품목으로 치환해 셀 기준 분석 가능 | SCP_MST_FINAL_ITEM |  | 60-73 |
| NVL·기본값 | CASE WHEN NVL(fi.cell_cf,'')='' THEN 1.0 ELSE TO_NUMBER(fi.cell_cf) END — ⚠ Oracle 에서 ''=NULL 이므로 이 조건은 항상 거짓: cell_cf 가 NULL 이면 TO_NUMBER(NULL)=NULL 이 되어 AS-IS(1.0 기본) 와 결과 상이 | 변환 잠재결함 정직 기록 — 환산계수 미등록 품목의 kcell 이 1.0 환산 대신 NULL 로 떨어질 수 있음(MSSQL ISNULL(x,'')='' 패턴 잔존) | SCP_MST_FINAL_ITEM |  | 86-100 |
| 정렬 | item_type 우선순위 ROW_NUMBER: P=10, H=20, Q=30, R=40, 기타 99 → rnum=1 만 채택 | 한 품목에 여러 유형이 있으면 P>H>Q>R 순으로 대표 1건 | SCM_MST_ITEM_SN |  | 125-144 |
| 커서 | 외부 GROUP BY 13키 + SUM(qty)/MAX(cell_conv) 후 PIPE ROW(16필드) PIPELINED | 주차(yyyypw)×측정치 단위로 집계해 흘려보냄 | SCM_MST_BUCKET, SCM_MST_PROJECT |  | 22-38, 157-181 |

#### FN_DQ_PROD_PLAN (FUNC, 10건)
_역할: SCP 생산계획(당주=운영/과거=이력 테이블) + 직전 3주 실적을 주차 집계로 반환하는 PIPELINED 함수._  
_쉬운 설명: 동적 쿼리용 생산계획 공급 함수 — 조회 주가 이번 주면 운영 테이블, 지난 주면 이력 테이블에서 계획을 읽고, 최근 3주 실적을 함께 준다._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 일자·캘린더 | V_CURR_WEEK_MON := TO_CHAR(FN_NEXT_DAY(SYSDATE-7,'MON'),'YYYYMMDD') — P_PLAN_START = 당주 월요일이면 SCP_ANL_PRODUCTION_PLAN, 아니면 HIST_SCP_ANL_PRODUCTION_PLAN | 운영/이력 테이블 스위칭(동일 쿼리 2벌 유지) | SCP_ANL_PRODUCTION_PLAN, HIST_SCP_ANL_PRODUCTION_PLAN |  | 50, 62, 282-364 |
| 일자·캘린더 | 실적구간: V_RE_START = 계획시작일-21일 ~ V_RE_END = 계획시작일-1일 | 계획 시작 직전 3주 실적 동봉 | SCM_DNM_PRODUCT_RESULT_V |  | 42-44, 638 |
| Division | DIVISION_ID IN (SELECT COLUMN_VALUE FROM STRING_SPLIT(P_DIVISION_ID,',')) / PLANT_ID IN (STRING_SPLIT(P_PLANT_ID,',')) — 계획·실적·CTE 전 구간 적용 | 사업부·공장 콤마 다중값 필터 | (STRING_SPLIT) |  | 100, 154, 208, 634-636 |
| 정렬 | 계획버전 선택: ROW_NUMBER() PARTITION BY (DIVISION_ID, PLAN_START, PLAN_TYPE) ORDER BY CONFIRM_FLAG='Y' 우선, PLAN_SEQ DESC → ROW_NUM=1 | 확정본이 있으면 확정본, 없으면 최신 SEQ 버전 1개만 사용 | SCP_PLAN_VERSION_V |  | 148-170 |
| 일자·캘린더 | A.YYYYMMDD <= MAX(HORIZON_END_DATE)(SCM_MST_PLAN, PLAN_NAME=계획시작일) — Plan 구간 내로 절단 | 계획 수립 지평(horizon) 밖 데이터 제외 | SCM_MST_PLAN |  | 176-192 |
| 검증 | V_OPERATION_GROUP := 'A' 고정(파라미터 무시) / A.MEASURE=V_MEASURE / QTY<>0 (실적은 ACTUAL_GOOD_QTY>0 후 <>0) | Cell 공정그룹(A)만, 지정 측정치만, 0 수량 제외 |  |  | 28, 172, 250-252, 646, 710 |
| Lookup | SCP_CELL_FINAL_OPERATION CTE: SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='SCP_PLAN_OPERATION' AND SEGMENT3='A' AND ATTRIBUTE1='Y' → 실적 OPERATION_ID IN (...) — 구 하드코딩('A3000','A9000') 대체 (PJ20257329) | Cell 완성 공정 목록을 룩업 메타에서 동적으로 — 공정 추가 시 코드 수정 불필요 | SCM_ADM_LOOKUP_MASTER_DETAIL |  | 560-574, 640 |
| 편집제약 | PLANT_NAME: OSP_YN='Y'→V.ATTRIBUTE1 우선(없으면 W그룹=PLANT_ID/PLANT_NAME/VENDOR_NAME 폴백), OSP_YN='N'→SN.DESCRIPTION 우선 — 중첩 CASE(SELECT 절과 GROUP BY 동일식 반복) | 외주(OSP) 여부에 따라 협력사명/공장설명 중 표시명을 고른다 | SCM_MST_SITE, SCM_MST_PLANT_SN, SCM_MST_VENDOR |  | 118-122, 256-262 |
| 편집제약 | ITEM_ID_PROD_INFO CTE: SCP_MST_CELL_PROD_ASSY_MAP(VALID_YN='Y') × SCP_MST_FINAL_ITEM_V, ROW_NUMBER ORDER BY TCO_CELL_YN, ITEM_ID_PROD → CP_PRIORITY=1 | 조립품목 1개당 대표 생산품목(ITEM_ID_PROD) 1건 매핑(TCO 셀 우선) | SCP_MST_CELL_PROD_ASSY_MAP, SCP_MST_FINAL_ITEM_V |  | 72-110 |
| 커서 | YYYYPW 라벨 'YY_Wnn(_x)' + SUM(QTY)/1000.0 K Cell — 계획 2벌 + 실적 1벌 총 3개 LOOP 에서 PIPE ROW(11필드) | 주차 라벨·천 단위 환산 후 파이프 반환 | SCM_MST_BUCKET |  | 134-142, 270-278, 490-498, 724-732 |

#### FN_DQ_STOCK (FUNC, 8건)
_역할: 기준일자 재고(SCM_DNM_STOCK) + 해상재고(SCM_DNM_INTRANSIT_C)를 UNION ALL 로 셀 환산해 반환하는 PIPELINED 함수._  
_쉬운 설명: 동적 쿼리용 재고 공급 함수 — 창고 재고와 배 위에 떠 있는 재고를 한 번에, 전극/조립 관련 품목만 골라 K Cell 로 환산._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| Division | A.DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_DIVISION_ID,','))) / SCM_SITE_ID·TO_SCM_SITE_ID IN (STRING_SPLIT(P_PLANT_SITE_ID,',')) | 사업부·사이트 콤마 다중값 필터(재고/해상재고 양쪽) | (STRING_SPLIT) |  | 84-85, 145-146 |
| 일자·캘린더 | 재고 A.CUTOFF_DATE=P_CUTOFF_DATE / 해상재고 A.RESULT_DATE=P_CUTOFF_DATE (스냅샷 단일일자) | 지정한 기준일 하루치 스냅샷만 | SCM_DNM_STOCK, SCM_DNM_INTRANSIT_C |  | 86, 147 |
| 검증 | QTY<>0 / DELIVERY_QTY<>0, 해상재고 RESULT_TYPE IN ('C','I'), SUBSTR(ITEM_ID,1,3) IN ('APC','ABC','AFC','AHC','AMC','ANP','ASC','AZC') | 0 수량 제외 + 전극재고/조립재공 품목(접두 3자 8종)만 |  |  | 87-89, 148-151 |
| NVL·기본값 | CELL_CONVERSION 3단 폴백: CF.CELL_CF(NVL CAST NUMBER(30,10) <>0) → FI.CELL_CF → FI.CONVERT_QTY_CELL → 1.0 | 셀 환산계수를 우선순위 3곳에서 찾고 없으면 1.0 — MKT_FCST_81 과 달리 NULL 안전(NVL(x,0)<>0 패턴) | SCP_MST_ITEM_CELL_CF, SCP_MST_FINAL_ITEM |  | 38-47, 107-116 |
| Lookup | (+) 구식 OUTER JOIN: SCM_MST_SITE, SCM_MST_OPERATION_SN(ACTIVE_FLAG='Y' MAX명), SCM_MST_ITEM_SN(NICK_NAME NOT NULL AND ACTIVE_FLAG='Y'), SCP_MST_FINAL_ITEM, SCP_MST_ITEM_CELL_CF — 전부 GROUP BY dedup 인라인뷰 | 마스터가 없어도 재고 행은 살아남는 left outer 구조(FP_PLAN 의 INNER 와 대조적) | SCM_MST_SITE, SCM_MST_OPERATION_SN, SCM_MST_ITEM_SN, SCP_MST_FINAL_ITEM, SCP_MST_ITEM_CELL_CF |  | 48-83 |
| NVL·기본값 | 해상재고 고정값: FACTORY_ID='-', OPERATION_ID/OPERATION_NAME='Intransit', WIPHOLD_YN='N' | 배 위 재고는 공장/공정 개념이 없으므로 placeholder 상수 |  |  | 101-104 |
| Bulk구분자 | UNION ALL 로 1.0 재고 + 2.0 해상재고 결합(중복 제거 없음) | 두 원천을 합산 가능 형태로 이어붙임 |  |  | 22-151 |
| 커서 | FOR REC LOOP → PIPE ROW(FN_DQ_STOCK_ROW 14필드) PIPELINED | TABLE() 소비용 파이프 반환. KCELL = 환산계수×수량/1000 |  |  | 152-159 |

#### FN_DQ_FP_PLAN_ROW (TYPE, 1건)
_역할: FN_DQ_FP_PLAN 반환 행 타입(17필드)._  
_쉬운 설명: FP 계획 조회 결과 1행의 컬럼 구조 정의._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 커서 | 필드 전수: DIVISION_ID VARCHAR2(30 CHAR), SITE_ID VARCHAR2(30), PLANT_ID VARCHAR2(30), PLANT_NAME VARCHAR2(100), SCM_PLANT VARCHAR2(100), OPERATION_ID VARCHAR2(30), FACTORY_ID VARCHAR2(30), LINE_ID VARCHAR2(30), LINE_NAME VARCHAR2(100), ITEM_ID VARCHAR2(30), NICK_NAME VARCHAR2(100), PRODUCTION_TYPE VARCHAR2(30), TYPE VARCHAR2(30), CATEGORY VARCHAR2(30), PLAN_DATE VARCHAR2(30), YYYYPW VARCHAR2(30), QTY NUMBER(30,3) | 17필드 — QTY 는 소수 3자리(K Cell). FORCE 로 의존 재생성 허용 |  |  | 1-20 |

#### FN_DQ_FP_PLAN_TAB (TYPE, 1건)
_역할: FN_DQ_FP_PLAN PIPELINED 반환 컬렉션 타입._  
_쉬운 설명: 위 행 타입의 테이블 컬렉션._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 커서 | TYPE FN_DQ_FP_PLAN_TAB FORCE AS TABLE OF FN_DQ_FP_PLAN_ROW | 행 타입 종속 — ROW 변경 시 재컴파일 필요 |  |  | 1 |

#### FN_DQ_PROD_PLAN_ROW (TYPE, 1건)
_역할: FN_DQ_PROD_PLAN 반환 행 타입(11필드)._  
_쉬운 설명: 생산계획 조회 결과 1행의 컬럼 구조 정의._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 커서 | 필드 전수: DIVISION_ID VARCHAR2(30 CHAR), OPERATION_GROUP VARCHAR2(10), SCM_SITE_ID VARCHAR2(30), PLANT_NAME VARCHAR2(30), LINE_ID VARCHAR2(30), ITEM_ID_PROD VARCHAR2(30), ITEM_ID VARCHAR2(30), NICK_NAME VARCHAR2(100), MEASURE VARCHAR2(100), YYYYPW VARCHAR2(30), QTY NUMBER(30,3) | 11필드 — PLANT_NAME 이 30자로 좁아 긴 공장 표시명(DESCRIPTION/VENDOR_NAME 폴백) 초과 시 ORA-06502 위험 내포 정직 기록. QTY 소수 3자리(K Cell) |  |  | 1-27 |

#### FN_DQ_PROD_PLAN_TAB (TYPE, 1건)
_역할: FN_DQ_PROD_PLAN PIPELINED 반환 컬렉션 타입._  
_쉬운 설명: 위 행 타입의 테이블 컬렉션._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 커서 | TYPE FN_DQ_PROD_PLAN_TAB AS TABLE OF FN_DQ_PROD_PLAN_ROW | 행 타입 종속 |  |  | 1 |

#### FN_DQ_STOCK_ROW (TYPE, 1건)
_역할: FN_DQ_STOCK 반환 행 타입(14필드)._  
_쉬운 설명: 재고 조회 결과 1행의 컬럼 구조 정의._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 커서 | 필드 전수: CUTOFF_DATE VARCHAR2(32 CHAR), DIVISION_ID VARCHAR2(120), SCM_SITE_ID VARCHAR2(120), NICK_NAME VARCHAR2(200), OPERATION_GROUP VARCHAR2(40), ITEM_ID VARCHAR2(200), FACTORY_ID VARCHAR2(240), OPERATION_ID VARCHAR2(120), OPERATION_NAME VARCHAR2(600), WIPHOLD_YN VARCHAR2(4), ITEM_UOM VARCHAR2(40), SCM_QTY NUMBER, CELL_CONVERSION NUMBER, KCELL NUMBER | 14필드 — 다른 ROW 타입 대비 폭이 넉넉(120~600자, NVARCHAR 바이트 환산 흔적). 수량 3종은 정밀도 무제한 NUMBER |  |  | 1-17 |

#### FN_DQ_STOCK_TAB (TYPE, 1건)
_역할: FN_DQ_STOCK PIPELINED 반환 컬렉션 타입._  
_쉬운 설명: 위 행 타입의 테이블 컬렉션._

| 유형 | 조건/로직 | 쉬운 설명 | 참조 | 오류/MSG | 줄 |
|---|---|---|---|---|---|
| 커서 | TYPE FN_DQ_STOCK_TAB AS TABLE OF FN_DQ_STOCK_ROW | 행 타입 종속 |  |  | 1 |

---

## 6. AS-IS MSSQL 원본 교차 대조 (16종 전수 · 격차 11건)

| AS-IS (MSSQL dbo) | TO-BE (Oracle) | 변환 차이 |
|---|---|---|
| dbo.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | SYS0013_GET_QUERY_LIST | UF_FX_String_Split → REGEXP_SUBSTR('[^,]+') CONNECT BY CTE 3건(DQ_ID/DQ_NAME/ROLE)<br>FOR XML PATH + STUFF 문자열집계 2건 → LISTAGG WITHIN GROUP 2건<br>ISNULL → NVL 2건(GROUP_ID ''/GROUP_NAME 'ALL')<br>TB_FX_GroupInfo(GroupID/GrpName/UseYN) → SCM_ADM_USER_GR_M(USER_GR_ID/USER_GR_NM/USE_YN) 권한 마스터 치환<br>N'' 리터럴 제거(LIKE N''+token → token\|\|'%')<br>TO-BE 추가 로직: P_USER_ID/P_MNU_ID 파라미터 + SCM_ADM_USER_MNU_EDIT_AUTH_V INNER JOIN 으로 EDIT_YN 신설 — AS-IS 에 없던 Division 권한 필터라 권한 뷰 미등록 Division 행이 목록에서 탈락 가능(행수 축소 위험)<br>bare 결과셋 → 이중 OUT SYS_REFCURSOR + START/END 로그 + EXCEPTION(RAISE_APPLICATION_ERROR -20001) 표준블록 추가 |
| dbo.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | SYS0013_GET_COLUMNS | ISNULL → NVL 2건(SEQNO/ORDER BY)<br>CAST(... AS INT) → TO_NUMBER<br>인라인뷰 (SELECT * WHERE VALID_YN='Y') A → 직접 WHERE A.VALID_YN='Y' (등가)<br>AS-IS 의 비활성 주석(UF_FX_String_SplitForIN 다중검색) TO-BE 에도 주석으로 1:1 보존<br>bare 결과셋 → 이중 OUT 커서 + 로그/예외 표준블록 |
| dbo.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | SYS0013_GET_PARAMETERS | ISNULL → NVL 2건(SEQNO/ORDER BY)<br>CAST(INT) → TO_NUMBER<br>N'' 리터럴/대괄호 식별자 제거<br>bare 결과셋 → 이중 OUT 커서 + EXCEPTION(-20001) — START/END 로그는 미포함(GET_COLUMNS 와 달리 간소판) |
| dbo.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST_COMMON | SYS0013_GET_QUERY_LIST_COMMON | FROM 절 없는 SELECT 상수행 → FROM DUAL (COLTYPES/COMBO/AGGREGATE/OPORATOR 4분기 그대로)<br>TB_FX_GroupInfo → SCM_ADM_USER_GR_M (ROLES 분기)<br>WITH(NOLOCK) 제거 3건<br>CATCH 의 SELECT '99^ERR' AS CODE 에러 결과셋 → RAISE_APPLICATION_ERROR(-20001) 예외 전파로 에러 계약 변경<br>TO-BE 추가: ELSE 분기 빈커서(WHERE 1=0) — AS-IS 는 미매칭 시 결과셋 없음<br>OPORATOR 오탈자 닉네임 계약 보존 |
| dbo.DMF0027_GET_DM_DYNAMIC_QUERYS | SYS0013_GET_DYNAMIC_QUERYS | EXEC SP_EXECUTESQL @v_sql_text → OPEN O_RC1 FOR P_SQL_TEXT 동적 커서(EXECUTE IMMEDIATE 미사용)<br>CATCH '99^ERR' 결과셋 → RAISE_APPLICATION_ERROR(-20001) 예외 전파(에러 계약 변경)<br>인젝션 필터는 AS-IS/TO-BE 모두 없음(원본 계약 보존 — LIST2/EXECUTE_QUERY 와 구분)<br>NVARCHAR(MAX) → VARCHAR2 파라미터(32K 상한 격차)<br>예외 로그에 SQL 앞 500자만 기록(TO-BE 추가) |
| dbo.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | SYS0013_EXECUTE_QUERY | 이름 변경(LIST2 → EXECUTE_QUERY) — 본문 로직(FN_GET_NORMAL_STRING2 정규화 후 동적 실행) 1:1 대응으로 확정<br>dbo.FN_GET_NORMAL_STRING2 인젝션 정규화 호출 보존(2019 방비 이력 승계)<br>SP_EXECUTESQL → OPEN O_RC1 FOR V_S_QUERY<br>CATCH '99^ERR' 결과셋 → RAISE_APPLICATION_ERROR(-20001) 예외 전파<br>@s_query NVARCHAR(MAX) → V_S_QUERY VARCHAR2(32767 CHAR) 길이 상한 격차 |
| dbo.PR_DM_ADM_DQ_CREATE | PR_DM_ADM_DQ_CREATE | NEXT VALUE FOR SEQ1_SCM_ADM_DQ_LIST → SEQ1_SCM_ADM_DQ_LIST.NEXTVAL<br>sysdatetime() → SYSDATE<br>TRY/CATCH → EXCEPTION(ROLLBACK+로그+에러커서, 비재발생 = AS-IS 동일)<br>bare SELECT 결과셋('success'+SEQNO / '[err_no]err_msg') → OUT SYS_REFCURSOR O_RESULT 로 이식(lesson_returnresult_incompatible_mybatis)<br>cast(@p_DQ_TEXT as NVARCHAR(MAX)) → P_DQ_TEXT 직접(VARCHAR2)<br>SET XACT_ABORT/ISOLATION LEVEL/NOCOUNT → Oracle 기본 트랜잭션 의미론으로 대체(명시문 없음)<br>참고: 동일 기능의 JSON bulk 재설계판 SYS0013_SAVE_QUERY 가 병존(채번 방식 시퀀스 vs MAX+1 이원화) |
| dbo.PR_DM_ADM_DQ_CREATE_COLUMN | PR_DM_ADM_DQ_CREATE_COLUMN | sysdatetime() → SYSDATE<br>TRY/CATCH → EXCEPTION(비재발생 + 에러커서) — 결과셋 → OUT REF 커서<br>I=PK DELETE 후 INSERT / M / D / HIST 후호출(7 args) 순서 구조 1:1<br>AS-IS SELECT 'success'(무별칭) → SELECT 'success' AS CODE (컬럼 별칭 부여)<br>참고: JSON bulk 재설계판 SYS0013_SAVE_COLUMNS 병존 |
| dbo.PR_DM_ADM_DQ_CREATE_COLUMN_HIST | PR_DM_ADM_DQ_CREATE_COLUMN_HIST | NEXT VALUE FOR → NEXTVAL, sysdatetime → SYSDATE<br>AS-IS 'success'/에러 결과셋 → DBMS_OUTPUT 대체(OUT 커서 주석처리) — 결과셋 계약 제거<br>AS-IS CATCH(에러표시 후 계속) → RAISE_APPLICATION_ERROR(-20001) 전파로 엄격화(부모 트랜잭션 롤백 유발 가능)<br>UTL_CALL_STACK 프로그램명 자동 기록 + JSON_OBJECT 파라미터 로그(TO-BE 추가)<br>PR_SCM_SYS_LOG_BATCH_CALL_TRAN(시작/종료) → SCM_MGR.PR_SCM_SYS_LOG_BATCH 로 로그 경로 변경 |
| dbo.PR_DM_ADM_DQ_CREATE_HIST | PR_DM_ADM_DQ_CREATE_HIST | NEXT VALUE FOR → SELECT SEQ.NEXTVAL INTO FROM DUAL<br>sysdatetime → SYSDATE, 결과셋 'success' → DBMS_OUTPUT('success')<br>CATCH 비재발생 → EXCEPTION 에서 '-- RAISE;' 주석 = 동일하게 오류 삼킴(4개 HIST 중 유일하게 비전파 유지)<br>LOCAL_TRANSACTION_ID 조건부 ROLLBACK(TO-BE 방어 추가)<br>PR_SCM_SYS_LOG_BATCH_CALL_TRAN 로그 경로 보존 |
| dbo.PR_DM_ADM_DQ_CREATE_PARAMETER | PR_DM_ADM_DQ_CREATE_PARAMETER | ★ OPERATION_ID/REP_YN NOT NULL 인데 AS-IS 가 '' 전달 → Oracle ''=NULL 위반이라 NVL(x,' ') 공백 보정 신설(INSERT/UPDATE/HIST 일관) — 저장값이 AS-IS('')와 물리적으로 다름(' ')<br>sysdatetime → SYSDATE, TRY/CATCH → EXCEPTION 비재발생+에러커서<br>결과셋 → OUT REF 커서(CODE 1컬럼)<br>I=PK DELETE 후 INSERT / M / D / HIST(8 args) 후호출 구조 1:1<br>참고: JSON bulk 재설계판 SYS0013_SAVE_PARAMETERS 병존(그쪽 기본값은 ' ' 아닌 '-'/'N' — 값 정책 이원화) |
| dbo.PR_DM_ADM_DQ_CREATE_PARAMETER_HIST | PR_DM_ADM_DQ_CREATE_PARAMETER_HIST | NEXT VALUE FOR → NEXTVAL, sysdatetime → SYSDATE<br>결과셋 → DBMS_OUTPUT 대체(OUT 커서 주석)<br>CATCH 비재발생 → RAISE_APPLICATION_ERROR(-20001) 전파로 엄격화<br>UTL_CALL_STACK + JSON_OBJECT 8파라미터 로그 추가 |
| dbo.PR_DM_ADM_DQ_CREATE_USER_GROUP | PR_DM_ADM_DQ_CREATE_USER_GROUP | SCM_ARR_SPL_CNT/SCM_ARR_SPL_VAL 콤마 분할 함수 호출 보존(양 DB 동명 함수)<br>WHILE(LEN(recv)>0 AND mst<max) → IS NOT NULL AND LENGTH>0 가드 + FOR 1..max (recv 불변이므로 등가 변환)<br>AS-IS 확인용 디버그 SELECT 3종(@max_loop_cnt×2/@v_GROUP_ID/@delete_cnt) 결과셋 제거 — 결과셋 개수 계약 변화(DML 영향 없음)<br>첫 토큰 DELETE + 토큰별 HIST/INSERT 구조 1:1<br>sysdatetime → SYSDATE, TRY/CATCH → EXCEPTION 비재발생+에러커서, 결과셋 → OUT REF 커서 |
| dbo.PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE | PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE | AS-IS WHILE 루프는 mst_loop_cnt=1 에서만 DELETE 수행 → TO-BE 는 루프 제거 후 단건 DELETE(등가 — 주석으로 근거 명기)<br>SCM_ARR_SPL_CNT/VAL 호출과 확인용 SELECT(max_loop_cnt/v_GROUP_ID/delete_cnt) 제거<br>결과셋 'success' → DBMS_OUTPUT(OUT 커서 주석) — 결과셋 계약 제거<br>CATCH 비재발생 → RAISE_APPLICATION_ERROR(-20001) 전파로 엄격화<br>GROUP_ID/VALID_YN/CREATED_BY/LAST_UPDATED_BY 파라미터는 시그니처만 유지하고 미사용(AS-IS 도 DELETE 에 미사용) |
| dbo.PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST | PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST | NEXT VALUE FOR → NEXTVAL, sysdatetime → SYSDATE<br>결과셋 'success' → DBMS_OUTPUT('success') (V_LOG_MESSAGE IS NULL 조건 로직 1:1)<br>CATCH 비재발생 → 내부 BEGIN/EXCEPTION 블록에서 RAISE 전파(AS-IS 대비 엄격화 — CREATE_HIST 와 달리 전파함)<br>LOCAL_TRANSACTION_ID 조건부 ROLLBACK 추가, PR_SCM_SYS_LOG_BATCH_CALL_TRAN 경로 보존 |
| dbo.PR_DM_ADM_DQ_EXECUTE_HIST | PR_DM_ADM_DQ_EXECUTE_HIST | NEXT VALUE FOR → NEXTVAL, sysdatetime → SYSDATE<br>결과셋 'success' → DBMS_OUTPUT(OUT 커서 주석)<br>CATCH 비재발생 → RAISE_APPLICATION_ERROR(-20001) 전파(로그에 DQ_TEXT 앞 500자만)<br>UTL_CALL_STACK 프로그램명 + JSON_OBJECT 로그 추가<br>참고: 화면(BE) 실호출용으로는 CLOB 수용 + OUT 커서 반환의 SYS0013_EXECUTE_HIST 신규판이 병존 |

### 6-B. 격차 (은폐 금지 — 전건)
1. AS-IS '99^ERR' 에러 결과행 계약(DMF0027_GET_DM_DYNAMIC_QUERYS / _LIST_COMMON / _LIST2) → TO-BE 는 RAISE_APPLICATION_ERROR(-20001) 예외 전파로 전면 변경 — FE/BE 에러 처리 경로가 결과행 파싱에서 예외 핸들링으로 바뀜.
2. SYS0013_GET_HISTORY / SYS0013_SAVE_QUERY / SYS0013_SAVE_COLUMNS / SYS0013_SAVE_PARAMETERS / SYS0013_SAVE_USER_GROUP / SYS0013_DELETE_USER_GROUP / SYS0013_EXECUTE_HIST 7종은 AS-IS 대응 SP 없는 TO-BE 신규(이력 GET 신설 + 단건 SP 의 JSON bulk 재설계) — PR_DM_ADM_DQ_* 원변환본과 기능 중복 병존.
3. FN_DQ_FP_PLAN / FN_DQ_MKT_FCST_81 / FN_DQ_PROD_PLAN / FN_DQ_STOCK 4함수와 TYPE 6종의 AS-IS MSSQL 원본(TVF)이 폴더 B(16종 SP)에 미포함 — 원본 대조 불가. FN_DQ_STOCK 헤더의 'SELECT * FROM dbo.FN_DQ_STOCK(...)' 예제와 WITH(NOLOCK) 주석 잔존으로 MSSQL TVF 기원만 확인됨(전·후 diff 는 원본 미제공으로 정직하게 생략).
4. FN_DQ_MKT_FCST_81 변환 잠재결함: CASE WHEN NVL(fi.cell_cf,'')='' THEN 1.0 — Oracle 에서 ''=NULL 이라 조건 도달 불가, cell_cf NULL 품목의 환산계수가 1.0 대신 NULL(qty·kcell NULL 전파) 가능. AS-IS ISNULL(x,'')='' 는 TRUE 였음(결과 상이 위험).
5. SYS0013_GET_QUERY_LIST 의 SCM_ADM_USER_MNU_EDIT_AUTH_V INNER JOIN 은 AS-IS 에 없던 필터 — 권한 뷰에 UNIT_TP_CD='D' 행이 없는 사용자/Division 은 AS-IS 에서 보이던 쿼리가 TO-BE 에서 안 보일 수 있음.
6. 채번 이원화: PR_DM_ADM_DQ_CREATE 는 SEQ1_SCM_ADM_DQ_LIST 시퀀스, SYS0013_SAVE_QUERY 는 MAX(TO_NUMBER(DQ_ID))+1 — 두 경로 혼용 시 시퀀스 값과 MAX 값의 충돌(중복 채번/PK 위반) 가능.
7. 트랜잭션 정책 불일치: PR_DM_ADM_DQ_* 와 SYS0013_SAVE_QUERY 는 내부 COMMIT, SYS0013_SAVE_COLUMNS/PARAMETERS/USER_GROUP/DELETE_USER_GROUP/EXECUTE_HIST 는 COMMIT 없음(호출측 위임).
8. HIST 4종의 오류 전파 정책 상이: CREATE_HIST 비전파(-- RAISE 주석), COLUMN_HIST/PARAMETER_HIST RAISE_APPLICATION_ERROR 전파, USER_GROUP_HIST RAISE 전파 — AS-IS 는 4종 모두 비전파(CATCH 후 계속)였음.
9. PR_DM_ADM_DQ_CREATE_PARAMETER 의 NOT NULL 보정값(' ' 공백)과 SYS0013_SAVE_PARAMETERS 의 기본값('-'/'N') 이 상이 — 같은 컬럼(OPERATION_ID/REP_YN)에 경로별 다른 placeholder 저장.
10. SYS0013_GET_HISTORY 의 P_USER_ID/P_MNU_ID 는 미사용(권한 필터 미구현), P_DQ_ID='' 분기는 Oracle ''=NULL 로 도달 불가.
11. 동적 SQL 길이 상한: AS-IS NVARCHAR(MAX)(≈2GB) → SYS0013_EXECUTE_QUERY V_S_QUERY VARCHAR2(32767 CHAR) — 32K 초과 쿼리 실행 불가 격차.

---

## 7. 참고 실측 (사내 Oracle)

- **메뉴 경로**: Admin ▸ Admin_Menu ▸ SYS0013 (MNU_DESC: Dynamic Query List, MNU_URL: dynamic-query)
- **API_M 9건**: API_SYS0013_EXECUTE_QUERY→PKG_SYS0013.P_SYS0013_EXECUTE_QUERY · API_SYS0013_GET_COLUMNS→PKG_SYS0013.P_SYS0013_GET_COLUMNS · API_SYS0013_GET_HISTORY→SYS0013_GET_HISTORY · API_SYS0013_GET_PARAMETERS→PKG_SYS0013.P_SYS0013_GET_PARAMETERS · API_SYS0013_GET_QUERY_LIST→PKG_SYS0013.P_SYS0013_GET_QUERY_LIST · API_SYS0013_SAVE_COLUMNS→PKG_SYS0013.P_SYS0013_SAVE_COLUMNS · API_SYS0013_SAVE_PARAMETERS→PKG_SYS0013.P_SYS0013_SAVE_PARAMETERS · API_SYS0013_SAVE_QUERY→PKG_SYS0013.P_SYS0013_SAVE_QUERY_LIST · API_SYS0013_SAVE_USER_GROUP→SYS0013_SAVE_USER_GROUP
- **PROC_M**: 49행 (SP 13종 positional)
- **SHEET_COLUMNS**: 28행 — 시트 ['columns', 'history', 'main', 'parameters']
- **버튼 권한**: MNU_BTN_MPG 15행 (SEARCH/INSERT/DELETE/SAVE/EXECUTE) × USER_GR_MNU_BTN_MPG 44행 (그룹 ['ADMIN', 'DM ADMIN', 'DM Viewer', 'GUEST', 'SCM PI Admin'])
- **DQ 실데이터**: 등록 27건(VALID_Y 27) · 컬럼 636행/27쿼리 · 파라미터 50행/21쿼리 · 사용자그룹 매핑 157행
- **Lookup 전량**: BIZ_TYPE_BPMS(12행), INCOTERMS(16행), ITEM_TYPE_CODE(4행), SALES_TYPE_CODE(14행), SCP_PLAN_OPERATION(15행) — 위치: {"BIZ_TYPE_BPMS": "SYS0013_GET_QUERY_LIST_COMMON.sql L79 (FN_DQ_* 함수에는 없음 — 프로시저 콤보 분기)", "INCOTERMS": "SYS0013_GET_QUERY_LIST_COMMON.sql L99 (FN_DQ_* 함수에는 없음)", "ITEM_TYPE_CODE": "SYS0013_GET_QUERY_LIST_COMMON.sql L89 + FN_DQ_MKT_FCST_81.sql L56 (스칼라 서브쿼리 item_type 표시명)", "SALES_TYPE_CODE": "FN_DQ_MKT_FCST_81.sql L46 (스칼라 서브쿼리 fcst_type 표시명)", "SCP_PLAN_OPERATION": "FN_DQ_PROD_PLAN.sql L568 (CTE SCP_CELL_FINAL_OPERATION — SEGMENT3='A' AND ATTRIBUTE1='Y', Cell 완성공정 동적화 PJ20257329)"}
- **Division 분기**: SP/메타에 DIVISION 필터 없음 — 이 화면의 권한 축은 **SCM_ADM_DQ_USER_GROUP**(쿼리×사용자그룹 157행). AS-IS .cs 유일 Division 분기 = Where VALUE 콤보(DIVISION_ID/SCM_SITE_ID 컬럼일 때 콤보 원천 분기, L1077 부근)

---
_생성: gen_md_sys0013.py · 원천 JSON 7종(scratchpad sys0013/json) · anti-simplification 카운트 대사 통과_