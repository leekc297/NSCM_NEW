# DMF0053 (Customer FCST Waterfall) — 주요 이벤트 상세분석 (E01~E23)

> 작성: 2026-08-27 (T01 신규 생성 — hook #124 ③EVENT 영역)
> AS-IS 정본: `C:\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall\DMF0053_CustFcstWaterfall.cs` **1,822행** (Forms.UIL 판 — ExcelButton [E20241004-000997] 포함. Plan.UIL 1,790행은 구판이며 기존 `source_links.md` 가 구판 경로를 가리킴)
> Designer: 동 폴더 `.Designer.cs` 1,611행. 이벤트 배선은 Designer `+=` 14건 + InitEvent 코드 배선 4건 실측(아래 각 행에 표기).
> 분모: analysis.md v3 이벤트 핸들러 **23** — 본 문서 E01~E23 이 전수.

## 배선 실측 요약 (⭐ 사문 판정의 근거)

| 배선 위치 | 건수 | 대상 |
|---|---|---|
| Designer.cs `+=` | 14 | btnColumn(234)/btnOwner(271)/btnVersion(349)/chkSum(386)/btnProject(463)/btnItemId(535)/cboBucketType(573)/txtVersion.KeyDown(856)/cboQTY(964)/btnMeasure(1001)/spdMain 4종(1421~1424: CellDoubleClick·ComboSelChange·TopChange·KeyUp) |
| InitEvent (.cs L557~565) | 4 | cboDivision/clbTeam/clbCustomer/**cboBucketType(이중 배선 — Designer 와 중복, AS-IS 는 핸들러 2회 실행)** |
| 생성자/Form | 1 | `this.Load += Form_Load` (L178) |
| **미배선(정의만 존재 = 사문)** | **5** | `ClbSalesSite_SelectedIndexChanged` / `ClbPlantSite_SelectedIndexChanged` / `TxtProject_Changed` / `TxtItemId_Enter` / `chkColor_CheckedChanged` — Designer·InitEvent 어디에도 `+=` 없음. 그나마 앞 4종의 본문 = `SetClbVersion()` 뿐인데 **SetClbVersion 자체가 로컬 변수 대입만 하는 no-op** (L1114~1121) |

## E01~E23 전수

| E# | 핸들러 | 트리거 | AS-IS 동작 (라인) | TO-BE 판정 |
|---|---|---|---|---|
| E01 | `Form_Load` | 화면 진입 (L181) | InitForm→InitControls(콤보 전체 적재 L263~369)→DefineProperty(Bucket=Monthly L374)→CreateSpread(시트 'CUST Fcst Waterfall' L379)→InitEvent→`cboDivision_SelectedIndexChanged(null,null)` 1회 강제 | 구현 — store 초기화 + Division 자동선택 + 콤보 cascade + Bucket 기본 MONTHLY |
| E02 | `cboDivision_SelectedIndexChanged` | Division 변경 (L928) | FP_Log2 계측 → miFormLoad=1 이면 InitSpread(타이틀 재조회) → Team 재적재 → **81*(Substring(0,2)=="81")·82: Project/PlantSite/btnProject Enabled=true / 그 외(40): Enabled=false** (L951~983) → Customer/SalesSite/BizType/PlantSite 재적재 → txtProject·txtItemId·txtVersion·txtOwner 클리어 (L1020~1023) | 구현 — cascade + **40=PJT·Plant Site 비활성(81/82 활성 — DMF0040 과 반대)** + 텍스트 4칸 클리어 + Grid 초기화(§1.4) |
| E03 | `clbTeam_SelectedIndexChanged` | Team 변경 (L1030) | 81*/82: Customer(division,team)→SalesSite(division,'',customer) / 40: Customer(division,team)→SalesSite(division,team,customer) 재적재 | 구현 — EndCustomer/SalesSite cascade |
| E04 | `clbCustomer_SelectedIndexChanged` | End Customer 변경 (L1067) | 81*/82: SalesSite(division,'',customer) / 40: SalesSite(division,team,customer) 재적재 | 구현 — SalesSite cascade |
| E05 | `ClbSalesSite_SelectedIndexChanged` | — | **미배선 사문** + 본문 SetClbVersion=no-op | 제외 (사문 — 배선 실측 0) |
| E06 | `ClbPlantSite_SelectedIndexChanged` | — | 동일 사문 | 제외 (사문) |
| E07 | `TxtProject_Changed` | — | 동일 사문 | 제외 (사문) |
| E08 | `TxtItemId_Enter` | — | 동일 사문 | 제외 (사문) |
| E09 | `cboBucketType_SelectedIndexChanged` | Bucket 변경 (L1123) | fBucket/sBucket 전환: (W·M→D) 또는 (ONLY_WEEKLY 진출입) 시 InitSpread(타이틀 재조회) → SetSpreadColumn(가시성) → IsLock 시 EditButton 2회(읽기전용 화면이라 실질 no-op) | 구현 — Bucket 전환 시 타이틀 재조회 + D_/W_/M_ 가시성 전환 (EditButton 2회는 제외·사문) |
| E10 | `spdMain_ComboSelChange` | Grid Division 셀 콤보 변경 (L1148) | Division 컬럼이면 ScmSite/PlantSite 셀 콤보 재설정 | 제외 (**dead path** — 조회 후 `LockColumn(0,max,true)` 전열 잠금(L786)+Insert 미노출이라 편집 셀 자체가 없음) |
| E11 | `spdMain_CellDoubleClick`(헤더) | M_/W_ 헤더 더블클릭 (L1160~1210) | M_: 해당 월의 W_ 토글(Daily 면 열린 D_ 접기, 다음 M_ 에서 stop) / W_: 해당 주의 D_ 토글 | 구현 — 드릴다운 (DMF0040 ComparisonHeaderMergeManager 계보) |
| E12 | `spdMain_CellDoubleClick`(셀) | 데이터 셀 더블클릭 (L1211~1248) | `IsLock \|\| ACTION!='I'` 이면 return → Project/Item 팝업 | 제외 (**dead path** — 읽기 전용: 'I' 행이 존재할 수 없음. 근거 L1213) |
| E13 | `spdMain_TopChange` | 스크롤 (L1251) | SmartColMerge 재수행 | 구현 — 공용 DataGrid allowMerging (wijmo 기본 처리·별도 코드 불요) |
| E14 | `spdMain_KeyUp` | Ctrl+C/V (L1258) | Measure 우측 데이터 영역에서 클립보드 copy/paste | 부분 구현 — Copy 는 wijmo 기본. **Paste 제외** (읽기 전용 — WinForms 플랫폼 차이 + 잠금 grid) |
| E15 | `btnProject_Click` | PJT 검색 버튼 (L1277) | `SCM0002_ProjectbyDivisionPopupEx` (division,team,endCustomer,scmSite,project) → txtProject 반영 | 구현 — master 공용 `ProjectByDivisionModal` |
| E16 | `btnItemId_Click` | Model/Nickname 검색 버튼 (L1300) | `DM0002_ItembyDivisionPopupEx` (division,'ALL','ALL',scmSite,project,itemId) → txtItemId 반영 (구 SCM0002 판은 주석) | 구현 — master 공용 `ItemByDivisionModal` |
| E17 | `btnColumn_Click` | Column Setting (L1326) | `DM0002_TitleSetForm_Popup("DMF0053", 'CUST Fcst Waterfall', true, division)` → OK 시 InitSpread | 구현 — 공용 `ColumnLayoutModal` columnType='C' + UC-03 데이터 Reset |
| E18 | `btnMeasure_Click` | Measure (L1338) | 동일 팝업 bool=false (Measure 축) → OK 시 InitSpread | 구현 — master 공용 `MeasureSelectModal` + UC-03 |
| E19 | `chkSum_CheckedChanged` | Sum 체크 (L1351) | SetSpreadColumn — Daily: M_·W_=chk / Weekly: M_=chk | 구현 |
| E20 | `chkColor_CheckedChanged` | — | **미배선 사문** (본문도 SetSpreadColumn 뿐, 실적 회색 로직은 L811~903 전부 주석) | 제외 (사문 — 실적 회색 표시 자체가 AS-IS 에서 죽어 있음) |
| E21 | `btnVersion_Click` | Version 팝업 (L1657) | `SCM0002_VersionByWaterfallPopup` **Form_Load(true, "CF", division, from, to)** → txtVersion·Period 반영. ⚠ **btnVersion.Visible=false** (Designer L348) — 화면에서 버튼 자체가 숨김 | 제외 (**AS-IS 숨김 + Figma·#112 카탈로그 17행 모두 Version 조회조건 부재** → TO-BE 조회조건 미구현. `versionNo` 는 '' 고정 전달) |
| E22 | `txtVersion_KeyDown` | Version 칸 키 입력 (L1676) | btnVersion_Click 호출 (숨겨진 팝업의 유일한 진입로) | 제외 (E21 과 동일 사유) |
| E23 | `btnOwner_Click` | Owner 검색 버튼 (L1702) | `DM0020_OwnerbyDivisionPopup` (division,team,endCustomer,scmSite,project,itemId,owner) → txtOwner 반영 | 구현 — master 공용 `OwnerByDivisionModal` |
| E23+ | `cboQTY_SelectedIndexChanged` | QTY 스케일 (L1723) | SetAmountCalculating — 원본 보존 사본에 D_2*/W_2*/M_2* 값 ÷{1,1000,1000000,100000000} 소수2·0 제외 (L1731~1818) | 구현 — 표시 사본 divisor (DMF0040 계보. 4단: 1/1,000/1,000,000/100,000,000) |

> E23+ 표기: analysis.md 의 23번째 행이 `cboQTY_SelectedIndexChanged` — E 번호는 23개 전수를 유지하기 위해 E05~E08·E20 사문 5건도 행으로 보존.

## 조회 흐름 (FindData L662~924 — 대사표 A 축)

1. Division 필수 (A-01 MSG00097 L679)
2. Period 역전 (A-02 MSG00108 L688) → 3. **Period 3년 초과 (A-03 MSG00164 L694 — 알림 + `Value2=Value1.AddYears(3)` 자동 보정 후 중단)** ⚠ DMF0040 은 2년·DMF0053 은 **3년**
4. CreateDate 역전 (A-04 MSG00108 L705) → 5. CreateDate 3년 초과 (A-05 MSG00164 L711 — 동일 보정)
6. InitSpread(타이틀 재조회) → 메인 SP 21 파라미터 (versionNo=txtVersion — TO-BE '' 고정)
7. 결과: Tables[0]=데이터·Tables[1]=ISO_WEEK·**Tables[2].DATA_ORDER=정렬식 → DataView.Sort 적용 후 바인딩** (L772~784)
8. `LockColumn(0,max,true)` 전열 잠금 → SetSpreadColumn(bucket 가시성) → 건수 표기

## 이중 배선 특기

`cboBucketType.SelectedIndexChanged` 는 Designer(L573)+InitEvent(L562) **이중 배선 — AS-IS 는 핸들러 2회 실행**. TO-BE 는 1회 (파리티 대상 아님 — 결함성 중복).
