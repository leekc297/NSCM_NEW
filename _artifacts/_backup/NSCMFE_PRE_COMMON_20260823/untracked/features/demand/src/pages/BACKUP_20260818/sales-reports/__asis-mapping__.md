# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `DMF0044_SalesReports_주요이벤트_상세분석.md`, `DMF0044_SalesReports_상세동작_개발용.md`, `DMF0044_SalesReports_제약매트릭스_상세.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E00 | §0 정본(Forms.UIL) vs Plan.UIL 변형 차이 요약 |  | 분석 배경 서술(정본 vs Plan.UIL 변형 차이) — 구현 대상 조문 아님 | 해당없음 |
| E01 | §1 초기화 체인 — Form_Load (L132~L140) / InitControls (L169~L199) / CreateSpread·InitSpread (L… | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx mount useEffect + useSalesReportsStore 초기화 |  | 구현 |
| E01-1 | §1.1 생성자 (L122~L130) |  | WinForms 배관 — Wijmo/React 아키텍처에 대응 개념 없음(플랫폼 차이) (생성자/InitializeComponent) | 해당없음 |
| E01-2 | §1.2 Form_Load (L132~L140) — 호출 순서 | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx useEffect(mount) — 메타 fetch → 조회조건 초기화 순서 |  | 구현 |
| E01-3 | §1.3 InitControls (L169~L199) — 콤보 로딩 순서·기본값 (전수) | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx useTabComboQueries(조회조건 콤보 전수) |  | 구현 |
| E01-4 | §1.4 CreateSpread (L211~L218) / InitSpread (L220~L240) — 시트 구성 | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx staticColumns/dynamicColumns (admin 메타 주도, hook #113) |  | 구현 |
| E01-5 | §1.5 DefineProperty (L200~L209) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx useTabBtnPermissions(hasButton) — 버튼 노출 권한 |  | 구현 |
| E02 | §2 FindData — 조회 (`private async void FindData()`, L431~L500) | nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts setFilter + SalesReports.tsx useTabProcQuery(SHEETS.MAIN) |  | 구현 |
| E02-1 | §2.1 버튼 (10) | SalesReports.tsx:320~372 hotkeyConfig — Find/Insert/Delete/Save = `hasButton()` 조건부(L321~324, Insert 는 Data Type=ETC 게이트) / btnSPVer=SalesReportsForm.tsx:113 onOpenPopup / btnMeasure=L366 MEASURE_SELECT / btnExchangeRate=L345 EXCHANGE_RATE / btnTextbox=L333 TEXTBOX+isDiv82. 권한 원천 = `useTabBtnPermissions`(L62, hook #97 — hotkeyConfig 하드코딩 금지) | Excel 은 공용 툴바 기본 제공(화면 전용 구현 없음) | 구현 |
| E02-2 | §2.2 조회조건 컨트롤 (8) | SalesReportsForm.tsx:48 SearchArea — clbDivision L57 / clbType L70 / usrYear / usrDataType L98 / txtSPVersion L112(readonly, 팝업 주입) / btnSPVer L113 / btnMeasure·lblSPVersion(Report Type 연동 라벨). 전 항목 `FormItem`(L65~) 공용 폼 — hook #121 | | 구현 |
| E03 | §3 편집 이벤트 — EditButton (L270~L372) 잠금 규칙 전수 | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts evalSalesReportCell (4변수 매트릭스) |  | 구현 |
| E03-1 | §3.1 InsertButton → InsertRow (L251~L254, L970~L1035) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:152 handleInsert + utils/sales-reports.editLock.ts insertStaticEditable |  | 구현 |
| E03-2 | §3.2 DeleteButton (L256~L268) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:174 handleDelete |  | 구현 |
| E04 | §4 SaveData — 저장 (`private async void SaveData()`, L502~L968) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:185 handleSave + utils/sales-reports.save.ts |  | 구현 |
| E04-1 | §4.1 분기 A — `sDataType == "2"` (ETC Data, L515~L715) | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.save.ts buildEtcSaveRows → utils/sales-reports.api.ts callSaveEtc |  | 구현 |
| E04-2 | §4.2 분기 B — `sDataType == "1"` (Cutoff Data, L716~L967) | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.save.ts buildCutoffSaveRows → callSaveCutoff |  | 구현 |
| E05 | §5 버전 팝업 4종 | nscm-fe/features/demand/src/components/versionModal/VersionModal.tsx (활성 1종만 이관) |  | 구현 |
| E05-1 | §5.1 DMF0044_United_VersionPopup (727행) — **본화면에서 실제 호출되는 유일한 버전 팝업** | nscm-fe/features/demand/src/components/versionModal/VersionModal.tsx (AS-IS United 727행 1:1) |  | 구현 |
| E05-2 | §5.2 DMF0044_Sales_VersionPopUp (444행) — 구형. **현행 본화면에서는 호출 경로 없음** (btnSPVer 의 호출 코드가 주석… |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| E05-3 | §5.3 DMF0044_Sales_VersionCopyPopUp (451행) — Sales_VersionPopUp 의 Copy 버튼에서만 진입 (현행 본화면 경… |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| E05-4 | §5.4 DMF0044_MDFVersionPopUp (440행, 참고) — **본화면(정본) 어디에서도 인스턴스화되지 않음** (grep 실측: 정본 내 참조 … |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| E05-5 | §5.5 보조 기능 | 버전창 Copy/Create/Delete/Transfer = components/versionModal/VersionModal.tsx / Exchange Rate = components/modals/ExchangeRateModal.tsx (버전 필수 MSG00688·ADMIN 저장) / Text 입력 = components/modals/TextboxModal.tsx (div82 전용) / Measure Show = features/master/src/components/measureSelectModal/MeasureSelectModal.tsx / **ITEM(Model) 더블클릭 모델 선택 = SalesReportsGrid.tsx:392~401 dblclick → SalesReportsModals.tsx:93 ItemByDivisionModal**(2026-08-11 deptId 행값 전달 파리티 정정) | Exchange 팝업 종료 후 자동 재조회 없음 = AS-IS 파리티(정책④) / 공용 정본 승격(hook #132) 반영 — 인용 경로 정정 2026-08-15 | 구현 |
| E06 | §6 DMF0044_SalesReportExchangePopup — 환율 팝업 (721행) | nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx |  | 구현 |
| E07 | §7 DMF0044_SalesReport_TextboxPopup — 텍스트박스(월별 코멘트) 팝업 (453행) | nscm-fe/features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx (division 82 전용) |  | 구현 |
| E08 | §8 본화면 그리드 이벤트 배선 전수 (실측: 코드 L206~L208 + Designer.cs grep) | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx — beginningEdit/cellEditEnded/formatItem/dblclick 배선 |  | 구현 |
| E08-1 | §8.1 spdMain_Changed (L1166~L1305) — CellsUpdated 시 Auto-Sync 전수 | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx cellEditEndedHandler(수치 빈값→'0', DEPARTMENT_ID clear) + beginningEditHandler(행별 콤보 스왑) |  | 구현 |
| E08-2 | §8.2 spdMain_CellDoubleClick (L1307~L1334) | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx dblclickHandler (ITEM_ID, '기타매출' 제외) |  | 구현 |
| E09 | §9 버튼 전수 (BaseForm override + 커스텀) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:304 hotkeyConfig + :316 customButtons |  | 구현 |
| E09-1 | §9.1 BaseForm override (본화면) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:304 hotkeyConfig(search/insert/delete/save) |  | 구현 |
| E09-2 | §9.2 커스텀 버튼 (본화면) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:316 customButtons(Text/Exchange/Column/Measure) |  | 구현 |
| E10 | §10 사용 SP 인벤토리 (본화면 + 팝업, 전수) | SCM_ADM_MNU_BTN_MPG_M MNU_ID='DMF0044' 28행(8시트) — 배선 체인 게이트 섹션3 PASS 로 실증 |  | 구현 |
| E11 | §11 Validation 메시지 인벤토리 (전수) | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.validate.ts + sales-reports.constants.ts MSG (대사표 §5) |  | 구현 |
| A-1 | 메인 / Division 콤보 구성 | features/master/src/components/searchFields DivisionField (CMBO 'MyDivision' — 권한 division 만) |  | 구현 |
| A-10 | 팝업2 / Division 데이터 |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| A-11 | 팝업3 / Division 데이터 |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| A-12 | 팝업4 / Division 데이터 | components/versionModal/VersionModal.tsx — division 은 부모 전달값 고정(disabled) |  | 구현 |
| A-13 | 팝업5 / Division 데이터 |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| A-14 | 팝업6 / Division 데이터 | nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx — 조회 division = 부모 조회조건 승계 |  | 구현 |
| A-15 | 팝업6 / 버튼 노출 |  | AS-IS 는 NowGroupID∈{ADMIN,DM ADMIN} 그룹 게이트. TO-BE 환율 모달은 **행별 EDIT_YN**(ExchangeRateModal.tsx:157)으로 편집을 통제한다 — DMF0042 선례와 동일한 표준화 Δ(그룹→행 권한) | 해당없음 |
| A-16 | 팝업6 / Edit 실행 |  | AS-IS 는 NowGroupID∈{ADMIN,DM ADMIN} 그룹 게이트. TO-BE 환율 모달은 **행별 EDIT_YN**(ExchangeRateModal.tsx:157)으로 편집을 통제한다 — DMF0042 선례와 동일한 표준화 Δ(그룹→행 권한) | 해당없음 |
| A-17 | 팝업6 / Save 실행 |  | AS-IS 는 NowGroupID∈{ADMIN,DM ADMIN} 그룹 게이트. TO-BE 환율 모달은 **행별 EDIT_YN**(ExchangeRateModal.tsx:157)으로 편집을 통제한다 — DMF0042 선례와 동일한 표준화 Δ(그룹→행 권한) | 해당없음 |
| A-18 | 팝업7 / 버튼 노출 |  | 동상 — Textbox 모달은 버튼 권한(hasButton('TEXTBOX')) + division 82 게이트로 노출을 통제. AS-IS 의 ADMIN 그룹 하드코딩은 미승계(표준화 Δ) | 해당없음 |
| A-19 | 팝업7 / Edit 실행 |  | 동상 — Textbox 모달은 버튼 권한(hasButton('TEXTBOX')) + division 82 게이트로 노출을 통제. AS-IS 의 ADMIN 그룹 하드코딩은 미승계(표준화 Δ) | 해당없음 |
| A-2 | 메인 / 조회 | nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts:133 userGroup 전달 → SP EDIT_FLAG 산출 |  | 구현 |
| A-20 | 팝업7 / Save 실행 |  | 동상 — Textbox 모달은 버튼 권한(hasButton('TEXTBOX')) + division 82 게이트로 노출을 통제. AS-IS 의 ADMIN 그룹 하드코딩은 미승계(표준화 Δ) | 해당없음 |
| A-3 | 메인 / Edit(잠금 해제) | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts:59 EDIT_FLAG=='Y' 전 구간 개방 |  | 구현 |
| A-4 | 팝업2 / 폼 권한체크 |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| A-5 | 팝업3 / 폼 권한체크 |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| A-6 | 팝업4 / 폼 권한체크 |  | AS-IS `IsPopup=true` = WinForms BaseForm 권한체크 우회 배관. TO-BE 모달은 부모 화면 권한 컨텍스트를 그대로 쓰므로 우회 개념 자체가 없음(플랫폼 차이) | 해당없음 |
| A-7 | 팝업5 / 폼 권한체크 |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| A-8 | 팝업6 / 폼 권한체크 |  | AS-IS `IsPopup=true` = WinForms BaseForm 권한체크 우회 배관. TO-BE 모달은 부모 화면 권한 컨텍스트를 그대로 쓰므로 우회 개념 자체가 없음(플랫폼 차이) | 해당없음 |
| A-9 | 팝업7 / 폼 권한체크 |  | AS-IS `IsPopup=true` = WinForms BaseForm 권한체크 우회 배관. TO-BE 모달은 부모 화면 권한 컨텍스트를 그대로 쓰므로 우회 개념 자체가 없음(플랫폼 차이) | 해당없음 |
| D-1 | 메인 / `InitControls` | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:317 hasButton('TEXTBOX') && isDiv82(sc.divisionId) |  | 구현 |
| D-2 | 메인 / `EditButton` (MEASURE 에 "RTF" 포함 또는 =="Business_Plan" 인 행) | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts:66-69 RTF·Business_Plan × isDiv40 |  | 구현 |
| D-3 | 메인 / `EditButton` (그 외 measure 행) | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts:71 기타 measure — d40 && isPast |  | 구현 |
| D-4 | 메인 / `clbDivision_SelectedIndexChanged` | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:141 handleDivisionChange (버튼 토글 + 버전 리셋) |  | 구현 |
| D-5 | 팝업3 (Copy) / `SaveData` |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| D-6 | 팝업5 (MDF) / `SaveData` |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| L-01 | EditButton / `LockRange(iRow,0,iRow,MEASURE,true)` | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx beginningEditHandler — 정적(헤더)영역은 기존행 전량 잠금(existingStaticEditable) |  | 구현 |
| L-02 | EditButton / `LockRange(iRow,0,iRow,MEASURE,true)` | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx beginningEditHandler — 정적(헤더)영역은 기존행 전량 잠금(existingStaticEditable) |  | 구현 |
| L-03 | EditButton / `LockRange(iRow,iStartCol,iRow,iCurCol-1,true)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts:64 LOC 과거구간 잠금(!isPast) |  | 구현 |
| L-04 | EditButton / `LockRange(iRow,0,iRow,MEASURE,true)` | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx beginningEditHandler — 정적(헤더)영역은 기존행 전량 잠금(existingStaticEditable) |  | 구현 |
| L-05 | EditButton / `LockRange(iRow,0,iRow,GetMaxColumnIndex(),true)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts:68,71 비40 행 전체 잠금(editable=false) |  | 구현 |
| L-06 | EditButton / `LockRange(iRow,0,iRow,MEASURE,true)` | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx beginningEditHandler — 정적(헤더)영역은 기존행 전량 잠금(existingStaticEditable) |  | 구현 |
| L-07 | EditButton / `LockRange(iRow,iCurCol,iRow,max,true)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts:71 40 기타 measure — 현재월~끝 잠금(isPast 만 개방) |  | 구현 |
| L-08 | EditButton / `LockRange(iRow,0,iRow,max,true)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts:68,71 비40 행 전체 잠금(editable=false) |  | 구현 |
| L-09 | FindData / `LockColumn(0,max,true)` | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx — 조회 직후 기본 잠금(편집은 beginningEdit 게이트 통과분만) |  | 구현 |
| L-10 | InsertRow / `LockRange(DEPARTMENT_NAME)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'DEPARTMENT_NAME' |  | 구현 |
| L-11 | InsertRow / `LockRange(DEPT_NAME)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'DEPT_NAME' |  | 구현 |
| L-12 | InsertRow / `LockRange(CUTOFF_YYYYMMDD)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'CUTOFF_YYYYMMDD' |  | 구현 |
| L-13 | InsertRow / `LockRange(NICK_NAME)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'NICK_NAME' |  | 구현 |
| L-14 | InsertRow / `LockRange(SCM_SITE_ID)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'SCM_SITE_ID' |  | 구현 |
| L-15 | InsertRow / `LockRange(PROJECT_CODE)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'PROJECT_CODE' |  | 구현 |
| L-16 | InsertRow / `LockRange(APPLICATION)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'APPLICATION' |  | 구현 |
| L-17 | InsertRow / `LockRange(BIZ_TYPE_NAME)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'BIZ_TYPE_NAME' |  | 구현 |
| L-18 | InsertRow / `LockRange(BIZ_TYPE_NAME40)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'BIZ_TYPE_NAME40' |  | 구현 |
| L-19 | InsertRow / `LockRange(DMS_SALES)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'DMS_SALES' |  | 구현 |
| L-20 | InsertRow / `LockRange(DMS_CUSTOMER)` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'DMS_CUSTOMER' |  | 구현 |
| L-21 | InsertRow / `LockRange(MEASURE)` (+ SetValue 로 measure 강제) | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 'MEASURE' |  | 구현 |
| L-22 | 팝업2 / `LockColumn(0,max,true)` |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| L-23 | 팝업3 / `LockColumn(0,max,true)` |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| L-24 | 팝업4 / `LockColumn(DIVISION_ID,max,true)` | components/versionModal/VersionModal.tsx — 그리드 조회 전용(편집 없음) |  | 구현 |
| L-25 | 팝업5 / `LockColumn(0,max,true)` |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| L-26 | 팝업6 / `LockColumn(DIVISION_ID,CURRENCY_UNITCURRENCY,true)` | nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx — 키 컬럼 잠금 + 과거월 잠금(:161) + EDIT_YN 게이트(:157) |  | 구현 |
| L-27 | 팝업6 / `LockColumn(0,max,true)` | nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx — 키 컬럼 잠금 + 과거월 잠금(:161) + EDIT_YN 게이트(:157) |  | 구현 |
| L-28 | 팝업6 / `LockRange(ActiveRow,CURRENCY,ActiveRow,CURRENCY,true)` | nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx — 키 컬럼 잠금 + 과거월 잠금(:161) + EDIT_YN 게이트(:157) |  | 구현 |
| L-29 | 팝업6 / `LockRange(ActiveRow,CURRENCY_UNITCURRENCY,ActiveRow,i-1,true)` | nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx — 키 컬럼 잠금 + 과거월 잠금(:161) + EDIT_YN 게이트(:157) |  | 구현 |
| L-30 | 팝업7 / `LockColumn(1,max,true)` | nscm-fe/features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx — Action 열 외 잠금 |  | 구현 |
| M-1 | 메인 / MEASURE | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts:62-65 LOC — 계획구간(!isPast)만 |  | 구현 |
| M-2 | 메인 / MEASURE | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts:66-69 RTF 포함/Business_Plan 분기 |  | 구현 |
| M-3 | 메인 / MEASURE | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts:71 else — d40 && isPast |  | 구현 |
| M-4 | 메인 / MEASURE (InsertRow) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:152 handleInsert(2행 세트 measure 강제) + nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts:51~55 (Insert 행 = MEASURE 강제 세팅 전제) — ⚠ 2026-08-11 전환: 잠금 판정의 하드코딩 화이트리스트(구 INSERT_LOCKED_COLUMNS)는 **폐기**되고 UI Category Setup `INPUT_TP_CD` 단일 원천(staticEditableByMeta)이 대신한다 |  | 구현 |
| M-5 | 메인 / 기간 셀 (spdMain_Changed) | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx cellEditEndedHandler — 동적 셀 빈값 → '0' |  | 구현 |
| M-6 | 메인 / DEPARTMENT_ID 값 | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.gridCombos.ts resolveDeptIdRows(3분기) + DEPARTMENT_CHANGE_CLEAR (2026-08-09 이관 — CMBO DMF0044_DEPARTMENT_TEAM / _ETC_SALE_RESULT_TYPE_40 신규 등록) |  | 구현 |
| M-7 | 메인 / DEPT_ID(팀) 값 | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.gridCombos.ts ROW_COMBO_IDS.CUST_REPORT('DMF0005_REPORT_GROUP2') — beginningEdit 스왑. 'MDF' 분기의 ITEM/NICK 강제세팅은 §6 승계 금지 대상 |  | 구현 |
| M-8 | 메인 / ITEM_ID 값 (더블클릭) | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx dblclickHandler — ITEM_ID '기타매출' 제외 |  | 구현 |
| V-1 | 구간 기준 / `sCurMonth = DateTime.Today("yyyyMM")`, `iStartCol = MEASURE+1` | nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts thisMonth = dayjs().format('YYYYMM') (조회 시점 고정) |  | 구현 |
| V-10 | 버전 리셋 (Type 변경) / `clbType_SelectedIndexChanged` | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx Type 변경 → 버전 리셋 + 라벨 분기 |  | 구현 |
| V-11 | 버전 리셋 (Division 변경) / `clbDivision_SelectedIndexChanged` | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:141 handleDivisionChange — 버전 리셋 |  | 구현 |
| V-12 | 버전 선택 진입 / `btnSPVer_Click` | components/versionModal/VersionModal.tsx — btnSPVer 진입, 반환 버전 채택 |  | 구현 |
| V-13 | 조회 기간 / 조회 파라미터 `p_yyyy = usrYear` (연 단위), 헤더 SP `p_start_dt = YYYY+"0101"` ~ `p_end_dt =… | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx 연도 콤보(CMBO 'CALENDAR_YYYY', 기본 올해) + spreadTitle 시트 |  | 구현 |
| V-14 | Transfer / `SEND_YN == "N"` 만 | components/versionModal/version-modal.api.ts callTransfer — SEND_YN='N' 게이트 |  | 구현 |
| V-15 | Transfer Cancel / `SEND_YN == "Y"` 만 | components/versionModal/version-modal.api.ts callTransfer('C') — SEND_YN='Y' 게이트 |  | 구현 |
| V-16 | Version Delete / `SEND_YN ∈ {"N","C"}` 만 | components/versionModal/version-modal.api.ts callAction('D') — SEND_YN∈{N,C} 게이트 |  | 구현 |
| V-17 | Version Copy / `chkResult` 미체크 시 `MSG00314`("실적 미포함 복사?") 확인 | components/versionModal/VersionModal.tsx Copy — chkResult/BasicDate + callAction('CP') |  | 구현 |
| V-18 | Version Create / 게이트 없음 (행 선택만) | components/versionModal/VersionModal.tsx Create — callAction('CR') |  | 구현 |
| V-19 | OK / 행 선택 시 | components/versionModal/VersionModal.tsx OK — 선택 버전 확정 후 close |  | 구현 |
| V-2 | 전부 계획구간 / 첫 기간컬럼 태그(`M_yyyyMM`) ≥ 현재월 **또는** `clbType == "REPORT_BP_M"` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts isPast 판정 — BP(Business_Plan) 전 구간 개방은 D-2 경로 |  | 구현 |
| V-20 | Type 별 버튼 노출 / 생성계열(`SP_W`/`BP_M`/`SP_M`): Create 만 노출, Transfer/Cancel/Copy/Delete/OK/Re… | components/versionModal/version-modal.constants.ts — Type 별 CREATE/COPY 모드 버튼 노출 |  | 구현 |
| V-21 | 실적 포함 옵션 / `chkResult` 체크 → BasicDate 활성(오늘) + `chkUpdate` 강제 체크·비활성 / 해제 → 역방향 | components/versionModal/VersionModal.tsx chkResult ↔ BasicDate/chkUpdate 연동 |  | 구현 |
| V-22 | MV 옵션 / `chkMV` 체크 → MvMonth 활성(기본 전월) / 해제 → 비움 | components/versionModal/VersionModal.tsx chkMV ↔ MvMonth(기본 전월) 연동 |  | 구현 |
| V-23 | Copy SP 파라미터 / p_division_id, p_version_no, p_version_description, p_created_by, p_result… | components/versionModal/version-modal.api.ts callAction 파라미터 8키 |  | 구현 |
| V-3 | 전부 실적구간 / 마지막 기간컬럼 태그 < 현재월 | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts isPast = ym < thisMonth (전 구간 과거면 전량 잠금) |  | 구현 |
| V-4 | 혼합 구간 / 그 외 | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts ym<thisMonth 비교로 컬럼별 판정 — 순회 탐색 불요(선언적) |  | 구현 |
| V-5 | 조회 버전 필수 / `txtSPVersion.Text == ""` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.validate.ts:8 validateFind (MSG00283) |  | 구현 |
| V-6 | 저장 버전 필수 / `txtSPVersion.Text == ""` | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.validate.ts:13 validateVersionForAction (MSG00688 — AS-IS 00281 원문 신설) |  | 구현 |
| V-7 | Exchange 팝업 버전 필수 / `txtSPVersion.Text == ""` | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:273 handleExchangeRate → validateVersionForAction |  | 구현 |
| V-8 | Textbox 팝업 버전 필수 / `txtSPVersion.Text == ""` | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:291 handleTextbox → validateVersionForAction |  | 구현 |
| V-9 | Cutoff 일자 / `sCUTOFF_YYYYMMDD` public 필드 (팝업2 SetItem 이 세팅 — 단 해당 호출 경로는 현재 주석) |  | AS-IS CUTOFF_YYYYMMDD 공급 경로가 dead 팝업2 뿐이라 활성 경로(United)에서는 빈 문자열. 정책 확정 ① — 빈값 파리티(TO-BE 도 빈 문자열 전달) | 제외 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:E02:SEARCH | [SEARCH] §2 FindData — 조회 (`private async void FindData()`, L431~L500) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:126 handleSearch → useTabProcQuery(SHEETS.MAIN) |  | 구현 |
| CRUD:E03:EDIT | [EDIT] §3 편집 이벤트 — EditButton (L270~L372) 잠금 규칙 전수 | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts evalSalesReportCell + Grid beginningEdit |  | 구현 |
| CRUD:E04:SAVE | [SAVE] §4 SaveData — 저장 (`private async void SaveData()`, L502~L968) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:185 handleSave → callSaveEtc / callSaveCutoff |  | 구현 |
| MODAL:DMF0044_MDFVersionPopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| MODAL:DMF0044_Sales_VersionCopyPopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| MODAL:DMF0044_Sales_VersionPopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| MODAL:ExchangeRateModal | FE 실존 모달 (components/modals/ExchangeRateModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx |  | 구현 |
| MODAL:ImagePopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | AS-IS `siMain.ImagePopUp`(L203) = FarPoint 셀 이미지 리소스 — 모달 아님(추출 아티팩트) | 해당없음 |
| MODAL:MeasureSelectModal | FE 실존 모달 (components/modals/MeasureSelectModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx |  | 구현 |
| MODAL:PopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | md 본문의 일반 단어 매칭 — 실체 없음(추출 아티팩트) | 해당없음 |
| MODAL:SalesReportsModals | FE 실존 모달 (components/SalesReportsModals.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsModals.tsx (모달 컨테이너) |  | 구현 |
| MODAL:Sales_VersionPopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / 팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외 | 제외 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | WinForms 모달 표시 **메서드명** — 모달 자체가 아님(추출 아티팩트) | 해당없음 |
| MODAL:TextboxModal | FE 실존 모달 (components/modals/TextboxModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | nscm-fe/features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx |  | 구현 |

## 0. 정책 확정 (사용자 2026-07-22)
| # | 정책 | 반영 |
|---|---|---|
| ① | P_CUTOFF_YYYYMMDD = **빈값 파리티** (AS-IS United 통합 시 공급 경로 소실 — 운영 데이터도 빈값) | save.ts identityOf — 행값 그대로('') |
| ② | dead 팝업 3종(Sales_VersionPopUp/VersionCopyPopUp/MDFVersionPopUp) **이관 제외** — 호출부 주석/부재. 전용 SP(GET_VERSION_POPUP/GET_COPY_VERSION_POPUP)·MSG(00279/280/156/143) 미배선 | 승계 금지 |
| ③ | Textbox 저장 = **행별 반복 호출 교정** (AS-IS 마지막 행만 저장 결함 — SAVE_TEXTBOX 16p=1행분) | TextboxModal handleSave |
| ④ | Exchange 팝업 종료 후 재조회 **없음 파리티** (AS-IS blnOK 재조회 주석 L1446~1454) | ExchangeRateModal — onClose 무동작 |

## 1. 조회조건 (AS-IS 8 컨트롤 → Form 5 + 버튼 3)
| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| 1 | clbDivision (MyDivision) | DivisionField 카탈로그 — 변경 시 Version 초기화+Grid reset | ✅ |
| 2 | clbType (lookup MDF_TYPE) | CustomDropdown 'MDF_TYPE' (기등록) — 변경 시 Version 초기화 | ✅ |
| 3 | usrYear (CALENDAR_YYYY) | CustomDropdown 'CALENDAR_YYYY' (P4 신설) — 기본 당해년 | ✅ |
| 4 | usrDataType (MDF_TYPE2 — ALL/1/2) | CustomDropdown 'MDF_TYPE2' (P4 신설) | ✅ |
| 5 | txtSPVersion(readonly)+btnSPVer | InputField readonly + '...' 버튼 → UnitedVersionModal 주입 | ✅ |
| 6 | lblSPVersion (Type 별 라벨 전환) | FormItem label — BP_M='BP Version'/SP_W='SP Version' | ✅ |
| 7 | btnMeasure / btnExchangeRate / lci_btnTextBox(82) | SubTitle customButtons (Measure 아이콘/Exchange/Text[82]) | ✅ |
| 8 | Company (DM_COMPANY) | 캐시만·화면 바인딩 없음 (AS-IS 파리티 — 미노출) | ✅ |
| — | clbDivision 이중 구독 (Designer+코드 — InitSpread 2회) | **승계 금지** — 단일 핸들러 | ✅ |

## 2. 그리드
- 정적 46 = admin SHEET_COLUMNS 'MDF Reports' 메타 100% (hook #113 서버 직접 비교) ✅
- 동적 = M_yyyymm 12컬럼 + **연 span 2단 헤더** (GET_SPREAD_TITLE 1차 + row 키 fallback / SalesReportsMergeManager — hook #108 No. 코너) ✅
- **2행 Measure 블록**: Insert = GET_MEASURE(CODE) 강제 세팅 세트(INSERT_GROUP_ID) / Delete = 블록 전체 (AS-IS multiful=2, L970~1035) ✅
- 편집 게이트 = evalSalesReportCell **4변수 매트릭스** (제약매트릭스 §3 L270~372 6분기 전수):
  ALL 차단 / EDIT_FLAG='Y' 전개방 / LOC 계획구간 / RTF·Business_Plan×40 전체 / 기타×40 과거만 / 비40 잠금 ✅
- InsertRow 정적 잠금 12컬럼 (L997~1023 전수 — MEASURE 강제 세팅 포함) ✅
- 수치셀 빈값→'0' (spdMain_Changed L1295~1302) / cascade DEPARTMENT_ID→DEPT_ID (M-6) ✅
- ITEM_ID dblclick ≠'기타매출' → ItemByDivisionModal (M-8 L93) ✅

## 3. 저장 (Data Type 이원화 — SaveData L502~968)
- ETC(2): 2행 세트, '^' bulk **20키**(21 IN − createdBy BE주입 — cellModelInfo/cellModel=파트너 행) → `PKG.P_DMF0044_SAVE_SALES_PLAN_REPORT_C` ✅
- Cutoff(1): 1행 'M'만, **22키**(23 IN − createdBy — scmSiteId/projectCode/fcstType/incoterms) → `..._C_CF` ✅
- 게이트: Version(MSG00688) → ALL 차단(MSG00681) → Department 필수(MSG00429 {0}) → 0건(MSG00676) ✅
- 결과 passthrough + 성공 MSG00002 + 재조회·스크롤 복원 ✅

## 4. 모달 4종
| 모달 | AS-IS | 핵심 | 상태 |
|---|---|---|---|
| UnitedVersionModal | United_VersionPopup 727행 | 조회(당월-1~+5)/채택(SP_W·BP_M만, 더블클릭/OK)/액션 5종(T·C·D·CP — SEND_YN 게이트 MSG00685~687, confirm MSG00682/683/684, SP_W↔BP 분기 L300~304) | ✅ |
| ExchangeRateModal | SalesReportExchangePopup 721행 | 조회 2종+월 피벗/과거월 차단(L-29)/저장 '^' 7키·'0'→'D' | ✅ |
| TextboxModal | SalesReport_TextboxPopup 453행 (82) | GET 4커서(rc2 MONDAY)/13 코멘트/저장 행별 반복(정책③) | ✅ |
| MeasureSelectModal | DM0002_TitleSetForm_Popup | business-plan 판 복제 (titleSet 'M') | ✅ |

## 5. Validation/MSG 매핑 (hook #114 — AS-IS ID 직승계 금지, 사내 실측 3분기)
| AS-IS | 용법 | TO-BE | 분기 |
|---|---|---|---|
| MSG00283 | 조회 전 버전 | MSG00283 | 재사용(기등록) |
| MSG00281 | 저장/팝업 전 버전 | **MSG00688** (원문 1:1) | 신규 |
| MSG00321 | ALL 편집/저장 차단 | **MSG00681** | 신규 |
| MSG00002 | 필수값 {0} | MSG00429 | 재매핑(선례) |
| MSG00004 | {N}건 저장 | MSG00002(성공)/MSG00004(무변경) | 재매핑(선례) |
| MSG00006 | 저장 실패 | MSG00618 | 재매핑 |
| MSG00142 | Edit 중 환율 차단 | MSG00680 (DMF0042 선례 — 사내 00142는 '환율 잠금' 문구) | 재사용 |
| MSG00314/00016/00195 | 복사/삭제/취소 confirm | **MSG00682/683/684** | 신규 |
| MSG00318/319/320 | SEND_YN 게이트 | **MSG00685/686/687** | 신규 |
| MSG00096 | 권한 없음 | MSG00096 | 재사용 |
| MSG00279/280/156/143/151 | dead 팝업 전용 | — (정책② 제외) | 미배선 |

## 6. 승계 금지 (AS-IS dead/주석 — 제약매트릭스 §9 전수)
clbDivision 이중구독 / btnSPVer 구 팝업 호출(L1156~1163 주석 — CUTOFF 경로 소실=정책①) / 팝업2 SaveData dead(FoxDataRequest("")) / Exchange InitSpread_X(직접 SQL) / 구 YearSet(-5y~+10y) / Delete action=='I' 가드 주석 / 구 ETC 짝수행 수집·"^40" 하드코딩 잔재 / Textbox 마지막행만 저장(정책③ 교정) / Exchange blnOK 재조회 주석(정책④ 파리티).

## 7. 검증 이력
- 2026-07-22: tsc(demand+apps/web) 0 / eslint 0 errors(warnings 12 = 기존 non-null·상대경로 패턴 계열) /
  메타 P1~P4 사내 적용·실측 검증 완료 / viewRegistry DMF0044+'sales-reports'+'dmf0044' 등록.
- 잔여: 브라우저 E2E V1~V6 (플랜 §5) — Version 주입→조회→편집 매트릭스→저장 이원화→United 액션→Exchange/Textbox.

## 토큰 대사표 (hook #117 §5.6 — 2026-08-09 실측)

> AS-IS `UP_FX_GetCommonDataList` 의 `@Code + PARAM1~5` 에 대응하는 TO-BE 축.
> **AS-IS 공급 계약**: `SpreadInfo.cs:1975~1981` 이 메타 셀 콤보에 커서 `ATTRIBUTE1~5` 를 `sParam1~5` 로 넘기고,
> `DMF0044_GET_SPREAD_TITLE` L87~89 가 `ATTRIBUTE1 = @p_division_id` /
> `CASE WHEN CELL_COMBO_DATA_TYPE='DM_LOOKUP_DIV' THEN C.ATTRIBUTE1` 로 채운다(DMF0042 와 동일 계약).
> BE `makeComboQuery` 는 `@토큰` raw 치환 · 미전달은 `''` · 서버 자동 주입은 `@sesUserId`/`@sesLangCd` 뿐.
> FE 전달 지점 = `components/SalesReportsGrid.tsx` `useTabComboQueries`(메타 셀 콤보 14종 1구독).

| SQL_ID | 필요 토큰 | 서버 자동 | FE 전달 | 미전달 | 판정 | 비고 |
|---|---|---|---|---|---|---|
| APPLICATION | - | - | - | - | ✅ |  |
| COUNTRY_MST | - | - | - | - | ✅ |  |
| CUST_GROUP_DTL | - | - | - | - | ✅ |  |
| CurrencyList | - | - | - | - | ✅ |  |
| DMF0005_REPORT_GROUP1 | - | - | - | - | ✅ | APPLICATION_GR |
| DMF0005_REPORT_GROUP4 | - | - | - | - | ✅ | PRODUCT_DETAILS |
| DMF0005_REPORT_GROUP6 | - | - | - | - | ✅ | CELL_MODEL_INFO |
| DMF0044_MDF_MEASURE | - | - | - | - | ✅ |  |
| DM_COMPANY | - | - | - | - | ✅ |  |
| DmBizType | - | - | - | - | ✅ | BIZ_TYPE_NAME40 |
| END_CUST_REPORT | - | - | - | - | ✅ |  |
| FcstType | - | - | - | - | ✅ |  |
| SOLD_TO_CUST_REPORT | - | - | - | - | ✅ |  |
| **DM_LOOKUP_DIV** | param1, param2 | - | param1=division, param2=컬럼 ATTRIBUTE1 | - | ✅ | **2026-08-09 정정** — 미전달 시 `B.SEGMENT1=@param1 AND A.LOOKUP_TYPE=@param2` 가 비관대형이라 **항상 0행**이었다 |

### 행별 콤보(메타 밖 — `.cs` 런타임 바인딩분, 2026-08-09 이관)

| SQL_ID | 필요 토큰 | FE 전달 | 판정 | 비고 |
|---|---|---|---|---|
| DMF0044_DEPARTMENT_TEAM2 | divisionId | divisionId | ✅ | DEPARTMENT_ID 미입력 시 DEPT_ID 후보 (AS-IS InsertRow L990) |
| DMF0044_DEPARTMENT_TEAM | - (superset) | - | ✅ | **신규 등록**. AS-IS 는 `@Param1=UPPER_DEPT_ID` 서버 필터 → TO-BE 는 부모키 `DEPARTMENT_ID` 동반 반환 후 `resolveDeptIdRows` 클라 필터 |
| DMF0044_ETC_SALE_RESULT_TYPE_40 | - | - | ✅ | **신규 등록**. DEPARTMENT_ID='기타' 분기 (AS-IS L1195) |
| DMF0005_REPORT_GROUP2 | - | - | ✅ | CUST_REPORT (AS-IS L1244) |
| DMF0005_REPORT_GROUP3 | - | - | ✅ | PRODUCT_GROUP (AS-IS L1225 `GetLookupData`) |

> ⚠ **BIZ_TYPE(`DM_LOOKUP_DIV`, 컬럼 ATTRIBUTE1='40')** — param2='40' 이 되어 `LOOKUP_TYPE='40'` 조회가 된다.
> 2026-08-09 양 DB 실측: `LOOKUP_TYPE='40'` 은 **AS-IS·TO-BE 모두 미존재** → AS-IS 에서도 항상 0행인
> **legacy 바인딩**이다(별도 `BIZ_TYPE_NAME40 → DmBizType` 이 실사용). 파리티 유지 — 메타 수정하지 않는다.
> `ITEM_USE`(ATTRIBUTE1='DM_ITEM_USE')는 SEGMENT1='82' 7행만 존재 → division 82 에서만 채워지는 것이 파리티.

## ⭐ 2026-08-10 (2차) — 그리드 헤더 1단 전환 + Column Set 버튼 숨김 (사용자 지시)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| H-1 | 동적 컬럼 헤더 **2단(연 span+월 leaf) → 1단 평면**, 라벨 = `COLUMN_LABEL_NAME`(`2025-01`) — AS-IS `DMF0044_Sales_Reports.cs:235~236` 이 `iColumnHeaderRowCount = **1**` 을 넘긴다 | `features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx:155~200 (dynColMetas · mainDynamicColumns)` |  | 구현 |
| H-2 | `SalesReportsMergeManager` **연도 가로 머지 제거** — 상위 헤더 행이 없어 묶을 대상이 없다 | `features/demand/src/pages/sales-reports/utils/sales-reports.merge.ts:57~66 (ColumnHeader 분기)` |  | 구현 |
| H-3 | `IcGridColumnSetup`(Grid Column Set) 버튼 **숨김** | `features/demand/src/pages/sales-reports/SalesReports.tsx:344~352 (customButtons — 주석 블록으로 보존)` | 사용자 지시(2026-08-10). BTN_MPG 메타·모달(`COLUMN`)·배선은 **무변경** — 되살릴 때 주석 블록 + `IcGridColumnSetup` import 복원 | 구현 |
| H-4 | **정적 영역 헤더도 1단** — 공용 `getColumnDepth` 가 메타 클래스 라벨로 단수를 정해 2단이 되던 것을 화면에서 1단 선언 | `features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx:78~100 (mainStaticColumns — sClsLblNm/lClsLblNm='')` | 메타는 **무변경**(AS-IS 와 46행 완전 일치 실측). AS-IS 도 메타는 동일하고 `.cs:235~236` 이 `iColumnHeaderRowCount=1` 로 코드에서 1단을 강제한다 — 그 계약을 그대로 옮긴 것 | 구현 |

> ⚠ **종전 2단 구성은 오구성이었다** — `DMF0044_GET_SPREAD_TITLE` 이 동적 컬럼의
> `LARGE_CLASS_LABEL_NAME`·`SMALL_CLASS_LABEL_NAME`·`COLUMN_LABEL_NAME` 을 **모두 `2025-01` 동일값**으로 준다.
> 그래서 2단으로 묶으면 상위가 `2025`(연도)가 아니라 `2025-01` 이 되어 **1:1 그룹이 12개** 생겼다.
> 사용자 지적(2026-08-10)과 동일 진단이며, 1단 평면(`2025-01`, `2025-02` …)이 AS-IS 파리티다.
> 헤더 높이는 hook #93 대로 총 48px — 1단이므로 행 1개가 48을 그대로 갖는다(`48 / headerRows.length`).
> 2단 화면 대조군: `DMF0072_NNMasterMapping` · `DMF0074_MetalLinkPrice` 는 `SetSheetHeaderColumn(siMain, 2)`.
>
> ⭐ **SHEET_COLUMNS AS-IS↔TO-BE 전수 대조 결과**(`_gate_reports/DMF0044_SHEET_COLUMNS_DIFF_20260810.md`):
> 컬럼 집합 **46 = 46 완전 일치**, 속성 차이 **3건 = 콤보 ID 개명뿐**
> (`DM_Biz_Type→DmBizType` / `CURRENCY_LIST→CurrencyList` / `FCST_TYPE→FcstType` — 셋 다 TO-BE 등록·행 반환 확인).
> 헤더 단수는 **메타가 아니라 화면 선언**으로 맞췄다 — 메타 클래스 라벨은 원본 보존.
> ⛔ `SHEET_NAME` 무변경 · 본 작업에서 SHEET_COLUMNS **DML 0건**.

## AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 축 — 분석서가 놓친 핸들러 차단)

> 원천: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.cs` — `.cs` 에서 **기계 추출**한 UI 이벤트 핸들러 18개.
> 대사표의 E번호는 **분석 md** 기준이라 분석서가 누락한 핸들러를 못 잡는다. 이 축이 그 구멍을 막는다.
> 사문(빈 몸통) 핸들러는 **미이관이 파리티** — 상태 '제외' + 사유 기재로 통과시킨다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| HANDLER:DeleteButton | AS-IS `DMF0044_Sales_Reports.cs:256` (라이브 8행) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:174 handleDelete |  | 구현 |
| HANDLER:EditButton | AS-IS `DMF0044_Sales_Reports.cs:270` (라이브 78행) | nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts evalSalesReportCell (상시편집 + 셀 게이트) |  | 구현 |
| HANDLER:ExcelButton | AS-IS `DMF0044_Sales_Reports.cs:380` (라이브 25행) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx hotkeyConfig — 공통 Excel(hook #64 자동 제공) |  | 구현 |
| HANDLER:FindButton | AS-IS `DMF0044_Sales_Reports.cs:246` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 라이브 3행 = 사문(빈 몸통, 실제 동작은 FindData/InsertRow/SaveData 가 수행). 미이관이 파리티 | 제외 |
| HANDLER:FindData | AS-IS `DMF0044_Sales_Reports.cs:431` (라이브 52행) | nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts setFilter + SalesReports.tsx:126 handleSearch |  | 구현 |
| HANDLER:Form_Load | AS-IS `DMF0044_Sales_Reports.cs:132` (라이브 7행) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx mount useEffect |  | 구현 |
| HANDLER:InsertButton | AS-IS `DMF0044_Sales_Reports.cs:251` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 라이브 3행 = 사문(빈 몸통, 실제 동작은 FindData/InsertRow/SaveData 가 수행). 미이관이 파리티 | 제외 |
| HANDLER:InsertRow | AS-IS `DMF0044_Sales_Reports.cs:970` (라이브 48행) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:152 handleInsert (2행 세트 + 잠금 12) |  | 구현 |
| HANDLER:SaveButton | AS-IS `DMF0044_Sales_Reports.cs:374` (라이브 3행) · **사문(빈 몸통)** |  | AS-IS 라이브 3행 = 사문(빈 몸통, 실제 동작은 FindData/InsertRow/SaveData 가 수행). 미이관이 파리티 | 제외 |
| HANDLER:SaveData | AS-IS `DMF0044_Sales_Reports.cs:502` (라이브 353행) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:185 handleSave + utils/sales-reports.save.ts |  | 구현 |
| HANDLER:btnExchangeRate_Click | AS-IS `DMF0044_Sales_Reports.cs:1421` (라이브 16행) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:273 handleExchangeRate |  | 구현 |
| HANDLER:btnMeasure_Click | AS-IS `DMF0044_Sales_Reports.cs:1407` (라이브 9행) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:349 customButtons Measure → MeasureSelectModal |  | 구현 |
| HANDLER:btnSPVer_Click | AS-IS `DMF0044_Sales_Reports.cs:1148` (라이브 6행) | components/versionModal/VersionModal.tsx 진입 (SalesReportsForm 버전 버튼) |  | 구현 |
| HANDLER:btnTextbox_Click | AS-IS `DMF0044_Sales_Reports.cs:1468` (라이브 11행) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:291 handleTextbox |  | 구현 |
| HANDLER:clbDivision_SelectedIndexChanged | AS-IS `DMF0044_Sales_Reports.cs:1457` (라이브 9행) | nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx:141 handleDivisionChange |  | 구현 |
| HANDLER:clbType_SelectedIndexChanged | AS-IS `DMF0044_Sales_Reports.cs:1394` (라이브 8행) | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx Type 변경 핸들러 |  | 구현 |
| HANDLER:spdMain_CellDoubleClick | AS-IS `DMF0044_Sales_Reports.cs:1307` (라이브 17행) | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx dblclickHandler |  | 구현 |
| HANDLER:spdMain_Changed | AS-IS `DMF0044_Sales_Reports.cs:1166` (라이브 114행) | nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx cellEditEndedHandler |  | 구현 |

## §UC. UI 공통(통합테스트) 축 — COMMON:UC-01~07 (hook #133, 2026-08-15 판정)

> 단일 원천 = `_artifacts/_diagnostics/asis_mapping_gate.py::UI_COMMON_ITEMS`. 정본 화면 = DMF0042.

| ID | 요지(원천 1줄) | 구현 위치(파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지) | SalesReports.tsx handleInsert 말미 `keepRowVisibleUnderFilter` 블록별 등록 (2026-08-15 신설) |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = MSG00703 confirm | SalesReports.tsx handleSearch 선두 `hasPendingChanges()` → setAlert confirm MSG00703, 취소 시 조회 중단 (2026-08-15 신설 — 종전 hasPendingChanges 는 저장 경로에서만 쓰였다) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 | components/SalesReportsModals.tsx ColumnLayoutModal onSave 선두 `onMeasureApply()`(=resetGrid, 2026-08-15 보완 — Column 경로 누락분) + MeasureSelectModal onApply `onMeasureApply()` + SalesReports.tsx resetGrid |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 | SalesReports.tsx handleSave 성공 `setToast type:'success'`(MSG.SAVED) — 실패/SP 메시지만 Alert |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 | 공용 `packages/foundation/src/utils/gridAction.ts` excelDownload dataMap 승계(2026-08-12 공용 보완 — 전 화면 발효) ← SalesReports.tsx:448 `excelFileName='SalesReports'` 경로 소비 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 | 해당없음 — 조회조건 전수(components/SalesReportsForm.tsx) = Division·Version·CustomDropdown 뿐, **자유입력(key-in) 필드가 0개**. 콤마 다중 입력 대상 자체가 없다 | 조회조건에 key-in 필드 부재(2026-08-15 폼 전수 확인) | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns) | components/SalesReportsGrid.tsx updatedLayout `(0-a2) rebindFilterColumns` — columnGroups 재대입으로 끊긴 Column 참조만 재바인딩(동적 M_ 는 직전 sanitize 로 제외 유지). 2026-08-15 신설 |  | 구현 |
