# DMF0040 (MKT FCST Comparison) — 주요이벤트 상세분석 (E01~E22 전수)

> 작성: 2026-08-26 (hook #124 ③ EVENT 축 / #105 §1-C 0단계 선행 산출물)
> AS-IS 정본: `C:\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison\DMF0040_MktFcst_Comparison.cs` **1,875행**
>   (coverage `Doc/coverage/DM.csv` 판정 — Forms.UIL=todo / Plan.UIL=`gone`. Forms.UIL 에만 [E20241004-000997] ExcelButton 속도개선 포함.
>    Plan.UIL 레거시 판과 로직 동일·라인 -51 offset — 아래 라인 인용은 **Forms.UIL 정본** 기준)
> 팝업 정본: `C:\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0000_VersionByWaterfallPopup.cs` 368행
> 화면 성격: **읽기 전용 조회/비교 리포트** — `ReadOnlySheetList.Add(shtMain)` (L248) + Insert/Delete/Save override 전부 빈 구현 + `EditButton()` = MSG00109 차단 + 조회 후 `LockColumn(0..max, true)` (L760)
> 이벤트 분모: **핸들러 22** (analysis.md §4 v3 = 원시 소스 실측 일치) + Framework 버튼 override 6 (§B)

## A. 이벤트 핸들러 22 전수

### E01. Form_Load (L188~204, 등록 L184)
`clsCtrl 생성 → InitForm() → InitControls() → DefineProperty() → CreateSpread() → InitEvent()` 후 `miFormLoad=1`, 마지막에 `cboDivision_SelectedIndexChanged(null,null)` 수동 1회 호출 (E02 cascade 를 초기 구동).
- InitControls (L246~365): 조회조건 콤보 전부 적재 — MyDivision→cboDivision(단일selection, 행>1 이면 index 1 기본선택 L361), UserTeamByDivision→clbTeam, division 81%/82 vs 그외(40) 분기로 EndCustomerByDivision→clbCustomer, BizType→clbBizType, UserSiteByEndCustomer→clbSalesSite, UserPlantSiteByDivision→clbPlantSite. BucketType(DMF0003_GET_REPORT_BUCKET_TYPE_CODE)→cboBucketType, `GetDayRange()`(PR_GET_DAY_RANGE, p_month=6 — 당월 1일~6개월 말일)→drpPeriod.InitValue, ITEM_TYPE_CODE 룩업→clbItemType, QTY(DMF0003_GET_QTY_TYPE_CODE)→cboQTY. `chkSum.Checked=false`, `layoutControlItem10` 항상 숨김(Never — cboCellQty 슬롯), btnColumn 툴팁 "Column Show".
- DefineProperty (L367~371): 조회조건 패널 높이 105, `cboBucketType=MONTHLY` 기본.
- 콤보 적재 프레임워크: `[PJ202350699]` 속도개선 — `DataService.GetDMInnerTable(FilterDataSet)` 경유 (`SetChangeControl` L215~, GROUP_ID/USER_ID 세션 주입). TO-BE 대응 = CMBO 배선 (@sesUserId).

### E02. cboDivision_SelectedIndexChanged (L943~1042)
1. `FP_Log2("SpeedUp","DMF0040","division_id_changed", start/end)` 속도 로그 (TO-BE 해당없음 — BE QueryLog 대체)
2. `miFormLoad==1` 이면 `InitSpread()` (동적 헤더 재구성 — division 이 SPREAD_TITLE 파라미터)
3. cascade 재적재: Team → (division=="40" 분기: `lblProject.Enabled=false`·`lblPlantSite.Enabled=false`·`btnProject.Enabled=false`·`cboCellQty.Enabled=true` / 그 외(81%·82): 세 라벨·버튼 enable) → EndCustomer → SalesSite → BizType → PlantSite
4. 텍스트 4종 클리어: txtProject/txtItemId/txtVersion/txtOwner (L1032~1035)
5. `SetClbVersion()` (E08 — 실질 no-op) + `GetDefaultVersion()` (E22-b: SCM0002_GET_VERSIONBYWATERFALLPOPUP `MF_W` 조회 → 'Current' 제외 최근 2개를 txtVersion 자동 세팅 L1832~1875)
- ⭐ 40 에서 Project·Plant Site 조회조건 비활성 = **division 반응형 조회조건** (TO-BE: disabled 처리)

### E03. clbTeam_SelectedIndexChanged (L1044~1082)
division 81%/82: EndCustomer(division,team)→Customer 재적재 + SalesSite(division,'',customer) / 그 외 40: EndCustomer(division,team)+SalesSite(division,team,customer). 이후 `SetClbVersion()`.

### E04. clbCustomer_SelectedIndexChanged (L1084~1110)
81%/82: SalesSite(division,'',endCustomer) / 40: SalesSite(division,team,customer) 재적재. `SetClbVersion()`.

### E05. ClbSalesSite_SelectedIndexChanged (L1112) / E06. ClbPlantSite_SelectedIndexChanged (L1117) / E07. TxtProject_Changed (L1122) / E08-t. TxtItemId_Enter (L1127)
전부 `SetClbVersion()` 단독 호출.

### E08. SetClbVersion (L1132~1139)
로컬 변수 5개만 읽고 **아무것도 하지 않는 사문 메서드** (구 버전콤보 적재 로직 제거 잔재). TO-BE: 제외 (사유 = 사문).

### E09. cboBucketType_SelectedIndexChanged (L1141~1160)
`ONLY_WEEKLY` 진입/이탈 시에만 `InitSpread()`(헤더 재질의 — fBucket 비교) → `SetSpreadColumn()` (bucket 별 D_/W_/M_ 가시성). `IsLock` 아니면 `EditButton()` 2회 — 읽기 전용이라 **사문 분기** (EditButton 은 fps null 아니면 MSG00109 후 return — 조회 전엔 fps null).

### E10. spdMain_ComboSelChange (L1163~1172)
그리드 Division 셀 콤보 변경 시 행의 SalesSite/PlantSite 셀 콤보 재적재 — **Insert 행 전제 사문 경로** (읽기 전용: 편집 진입 불가). TO-BE: 제외 (사유 = 사문).

### E11. spdMain_CellDoubleClick (L1175~1250)
- **헤더 더블클릭 = 드릴다운 토글 (핵심 기능)**: `M_` 헤더 → 그 월 범위의 `W_` Visible 토글 + 열려있는 `D_` 접기 (다음 `M_` 까지 L1179~1199) / `W_` 헤더 → 그 주 범위 `D_` 토글 (다음 `W_` 까지 L1200~1216)
- 셀 더블클릭 (L1218~1249): `IsLock || Action != 'I'` 면 return — **읽기 전용이라 사문** (Project/Item 셀 검색 팝업 경로).

### E12. spdMain_TopChange (L1252~1256)
스크롤 시 `SmartColMerge()` 재수행 (세로 머지 유지).

### E13. spdMain_KeyUp (L1258~1276)
Measure 우측(데이터 영역)에서 Ctrl+C = `ClipboardCopy(AsStringSkipHidden)` / Ctrl+V = Paste — 읽기 전용·전열 잠금이라 **실효 = 복사만**. TO-BE: Wijmo 기본 clipboard 복사로 충족.

### E14. btnProject_Click (L1280~1302)
`DMF000_ProjectbyDivisionPopupEx` (division/team/customer/salesSite/현재값) → 선택값을 txtProject 에 (빈 반환 시 유지).

### E15. btnItemId_Click (L1305~1335)
`DM0002_ItembyDivisionPopupEx` (division, team="ALL", customer="ALL", salesSite, project, 현재값) → txtItemId.

### E16. btnColumn_Click (L1338~1348)
`DM0002_TitleSetForm_Popup("DMF0040", "Mkt Fcst Waterfall", true=컬럼모드, division)` — OK 시 `InitSpread()` 재구성. = TO-BE **Column 설정 모달 (master 공용 정본)** + 저장 후 재조회 대신 헤더 재구성.

### E17. btnMeasure_Click (L1350~1360)
`DM0002_TitleSetForm_Popup("DMF0035", "Mkt Fcst Waterfall", false=메저모드, division)` — ⭐ **PROGRAM_ID 를 'DMF0035' 로 호출** = Measure 개인화 축을 DMF0035(Demand Plan Waterfall)와 **공유** (동일 SHEET_NAME 'Mkt Fcst Waterfall'). OK 시 `InitSpread()`.
- TO-BE 반영 결정 근거: DMF0040 의 MEASURE 축 원천 = DMF0035 축 (TO-BE SHEET_MEASURE 시딩·모달 파라미터 판정에 직결)

### E18. chkSum_CheckedChanged (L1362~1368)
`SetSpreadColumn()` — bucket 별로 상위 집계 컬럼(W_/M_) 표시 토글: DAILY 시 M_·W_=chkSum / WEEKLY 시 M_=chkSum / MONTHLY·ONLY_WEEKLY 는 무영향 (L1370~1415).

### E19. btnVersion_Click (L1642~1668)
`DMF0000_VersionByWaterfallPopup.Form_Load(true=다중, "MF", division, 기간)` → 반환 sVersions 콤마 분해, **3개 이상이면 MSG00255 차단** (L1657), 이내면 txtVersion + drpPeriod.InitValue=팝업 기간.

### E20. txtVersion_KeyDown (L1670~1673)
아무 키나 눌러도 `btnVersion_Click` 호출 (직접 타이핑 불가 — 팝업 전용 입력).

### E21. btnOwner_Click (L1720~1747)
`DM0020_OwnerbyDivisionPopup` (division/team/customer/salesSite/project/item/현재값) → txtOwner.

### E22. cboQTY_SelectedIndexChanged (L1749~1754) + SetAmountCalculating (L1756~1830)
표시 스케일 전환: index 0=원본(dsOrigianlCopy 복원)/1=÷1,000/2=÷1,000,000/3=÷100,000,000. 대상 = 컬럼명 `D_2*`/`W_2*`/`M_2*` 인 수치 컬럼 전 행 (`Math.Round(…, 2)`), 0 값 skip. 원본은 최초 1회 `dsOrigianlCopy` 보관.
- ⭐ QTY 콤보 원천 = `DMF0003_GET_QTY_TYPE_CODE` (DMF0003 공유)

### E22-b. GetDefaultVersion (L1832~1875) — E02 의 하위 로직
`SCM0002_GET_VERSIONBYWATERFALLPOPUP` (기간/사용자/division/`MF_W`/'') 조회 → VERSION_NO=='Current' 제외 **상위 2개**를 콤마로 txtVersion 기본 세팅.

## B. Framework 버튼 override 6종 (BaseForm — TO-BE hotkeyConfig 축)

| 버튼 | AS-IS (라인) | 동작 | TO-BE 판정 |
|---|---|---|---|
| Find (F5) | `FindButton()` L573 | `FindData()` (§C) | SEARCH 버튼 |
| Insert (F8) | L578 | **빈 구현** (`//InsertRow()`) | 버튼 미노출 (insert:false) |
| Delete (F9) | L583 | **빈 구현** | 버튼 미노출 |
| Edit (F2) | L588~595 | `fps != null` 이면 **MSG00109(읽기전용) 후 return** | 편집 진입 없음 — 셀 전부 잠금 |
| Save (F7) | L597 | **빈 구현** | 버튼 미노출 (save:false) |
| Excel (F12) | L601~646 | `SimplexelService.ExportFpSpread` (E20241004-000997 속도개선판 — Merge None/Border All/HideZero/소수 3자리 포맷) | 공용 Excel Download (UC-05 콤보 Name) |

## C. FindData (L652~940) — 메인 조회 파이프라인

1. `checkRequiredOfSearch` (Designer Required: **Division*/Period*/Version***) → V1: division 빈값 MSG00097 (L673) → V2: 기간 역전 MSG00108 (L682) → V3: `Value1.AddYears(2) < Value2` 면 MSG00164 + **Value2 자동보정**(Value1+2년) 후 return (L688~695)
2. `InitSpread()` — GET_SPREAD_TITLE(5p: 기간/사용자/division/bucket) 재질의 → 3단 헤더 구성 (§D)
3. 메인 SP `DM.DMF0040_GET_MKT_FCST_COMPARISON` — CommandTimeout 30분, **16 파라미터**: p_division_id(단일)/p_scm_site_id/p_plant_site_id/p_team_id/p_customer/p_biz_type/p_project_code/p_item_id/p_from_yyyymmdd/p_to_yyyymmdd/p_created_by/p_version_no(콤마 최대2)/p_item_type/p_owner/**p_diff_only(cboDiff.Checked — bool 직전달)**/p_bucket
   (TO-BE PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON = 18 IN — +p_user_id/p_menu_id, O_RC1+O_RESULT_CURSOR)
4. 정렬: FE 하드코딩 제거됨 — **SP 가변 정렬** ([E20240201-001467] L706~742 주석). `dv.Sort=""` 경유 재바인딩.
5. `siMain.Query()` → `SmartColMerge()` (좌측 차원 컬럼 세로 머지) → **`LockColumn(0..max, true)` 전열 잠금** (L760)
6. **행별 실적 구간 회색** (L774~886): 행 VERSION_NO 기준 —
   - Current/'' : 기준일 = min(전주 일요일, 조회 종료일)
   - Cutoff 버전: 버전명 [5..8+5) 의 날짜 → 그 날짜의 전주 일요일 vs 조회 종료일 min
   - ONLY_WEEKLY: `W_yyyyMM{ISO주(FirstFourDayWeek,월요일)}` / 그 외: `D_yyyyMMdd` 잠금 경계, 해당 월 `M_` SUM 은 White 예외
   - Measure+1 열부터 경계열까지 `Gainsboro` 배경
7. **Measure=='Difference' 행 = 데이터 영역 글자 Blue** (L889~893)
8. SearchStartTime/SearchEndTime/UIEndTime (프레임워크 계측 — TO-BE 해당없음), `SetSearchCount(ds)` 조회 건수 표기

## D. 동적 헤더 (InitSpread → SetSpreadHeader/Span, L382~560)

- `CreateSheetHeaderColumn(3단, dtTitle)` — dtTitle = GET_SPREAD_TITLE (COLUMN_NAME/COLUMN_LABEL_NAME/SMALL_CLASS_LABEL_NAME/LARGE_CLASS_LABEL_NAME/DAY_CODE …)
- ONLY_WEEKLY: `SetSpreadHeader` 단순 3단 (chkSum 비활성·해제 L391~396) / 그 외: `SetSpreadHeaderSpan` — Large(월)>Small(주)>일 3단 + 각 그룹 끝 **SUM 스팬 5회** (expressions.md 5건 = L527/533/541/553/555), `B_` 컬럼 숨김 (L507), DAY_CODE SAT=Blue·SUN=Red (L517)
- `Freeze(Measure+1)` 좌측 고정 + `SmartColMerge`
- Footer: `ColumnFooter` "Sum" — D_/M_/W_ 컬럼 `SumIgnoreHidden` 집계 (L406~424, LightGray)

## E. 팝업 DMF0000_VersionByWaterfallPopup (368행 전량 정독 — #124 §2 모달 동등)

| 축 | 내용 |
|---|---|
| 성격 | 조회 전용 (Insert/Delete/Edit/Save override 전부 빈 구현) |
| 조회조건 | clbDivision(다중·부모값 초기), drpPeriod(부모 기간), chkDay/chkWeek/chkMonth → p_version_type=`{code}_D,{code}_W,{code}_M` 조합 (부모가 code="MF" 전달), txtDes(버전명 필터·Enter=조회) |
| SP | `DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP` 6p (start/end/created_by/division/version_type/version_no) |
| 그리드 | 8컬럼 — DIVISION_ID(숨김,60)/VERSION_NO(200)/VERSION_DESCRIPTION(300)/VERSION_TYPE(60)/VER_CRE_SEQ(숨김)/YYYYMMDD(숨김)/CREATED_BY(100)/CREATION_DATE(150) — 표시 5컬럼, 전열 잠금 |
| 선택 | 다중 셀 선택 → OK: **2개 초과 MSG00255 차단** / 더블클릭 = 즉시 선택·닫기 / 반환 = sVersions(콤마)+sPeriod(팝업 기간) |
| 사문 | GetSpdTitle(DM0000_GET_COMMON_SPREAD_TITLE — 주석 처리 미호출)·clbDivision_SelectedIndexChanged(빈) |

## F. 3-way cross-check 결과

| 축 | 분석 MD | 원시 .cs | 매트릭스 | 판정 |
|---|---:|---:|---:|---|
| 이벤트 핸들러 | 22 | 22 | — | 일치 |
| 직접 호출 SP | 13 | 13 (FoxDataRequest 실측) | 21 (팝업 내부 SP 8계열 포함) | 일치 (매트릭스 초과분 = TitleSet/Owner/Item 팝업 내부 SP — TO-BE 공용 모달 담당) |
| validation | 17 | 17 (MSG 5종: 00097/00108/00164/00109/00255) | — | 일치 |
| expressions | 5 (SUM 스팬) | 5 (L527~555) | — | 일치 |
| 팝업 호출 | 6클래스 7개소 | 6클래스 7개소 | 동일 | 일치 |

## G. TO-BE 사문/제외 후보 (대사표 '제외' 사유 원천)

| 항목 | 사유 |
|---|---|
| E08 SetClbVersion | 빈 사문 메서드 (구 로직 제거 잔재) |
| E10 spdMain_ComboSelChange / E11 셀 더블클릭 분기 / fnValidation (L1417~1464) | Insert 행 전제 — 읽기 전용 화면이라 도달 불가 |
| E09 의 EditButton 2회 호출 분기 | IsLock 전제 — 읽기 전용이라 도달 불가 |
| Insert/Delete/Save 버튼 | AS-IS 빈 구현 — 버튼 미노출 |
| cboCellQty ("Cell Qty" 체크박스) | `layoutControlItem10` 항상 숨김(Never L322) — 화면 미노출 (Enabled 조작만 잔존) |
| GetDivision/GetTeambyDivision/GetCustomerbyDivision (L1466~1640 일부) | 직접 미호출 헬퍼 (SetChangeControl 경유로 대체됨) — 단 SCM0001_GET_TEAM/CUSTOMER 는 InnerTable 프레임워크가 소비 |
| FP_Log2/Search*Time | AS-IS 프레임워크 계측 — TO-BE BE 로그 대체 |
