# DMF0020 Sales Future Price — 제약매트릭스 상세

> **원천 (전체 Read 실측, 2026-07-27)**
> - `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Master\DMF0020_SalesFuturePrice\DMF0020_SalesFuturePrice.cs` — **총 3,969 행** (처음~끝 전체 읽음)
> - `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Master\DMF0020_SalesFuturePrice\DMF0020_SalesFuturePrice.Designer.cs` — **총 1,598 행** (처음~끝 전체 읽음)
> - 합계 **5,567 행** 실측. 라인번호는 위 두 파일 기준(별도 표기 없으면 `.cs`, Designer 는 `[D]` 접두).
> - 작성 규칙: hook #105 §1-C 0단계 — 축별 전수 / **1건 1행 원장** / 활성·주석(비활성) 구분 / 지어내기 금지.

---

## 요약 (축별 건수 표)

| 축 | 총 건수 | 활성 | 주석(비활성) | 비고 |
|---|---:|---:|---:|---|
| §1 Division 축 | **57** (+부표 16) | 49 | 8 | 40 / 81계열(`Substring(0,2)=="81"`) / 82 / else 4-way |
| §2 권한 축 | **28** | 24 | 4 | NowGroupID / AUTHORITY_YN / Auth 계열 조회 / 버전 읽기전용 |
| §3 Measure 축 | **30** | 27 | 3 | Measure 축 **존재** (LOC/USD/KRW/RTF/RTF_SYS_RP, 4배수 RowSpan) |
| §4 FCST_TYPE 축 | **21** | 19 | 2 | 축 **존재** (저장키·필수값·RowSpan 전파) |
| §5 기간·버킷 축 | **41** | 38 | 3 | 주(W_)/월(M_) 버킷, 과거주차 잠금, 52주 범위 |
| §6 Lock(편집잠금) 축 | **91** (A 66 / B 18 / C 7) | 76 | 15 | LockColumn2 / LockRange2 / SwitchLock / IsLock 게이트 |
| §7 가시성 축 | **62** | 50 | 12 | LAYER 종속 사고 2건 발견 (§7-D) |
| §8 필수값 축 | **34** | 32 | 2 | 조회 3 / Edit 진입 6 / 저장 10 / 중복 4 / 기타 11 |
| **합계** | **364** (+부표 16) | 315 | 49 | |

> ⭐ **축 존재 여부 정직 표기**: Division / 권한 / Measure / FCST_TYPE / 기간·버킷 / Lock / 가시성 / 필수값 — **8 축 모두 존재**. "해당 축 없음" 항목 없음.

---

## §1 Division 축 (총 57건 — 1건 1행)

**판정식 3종 (부록 A 참조)**
- `A` = `clbDivisions.ControlValues.Substring(0, 2) == "81"` — 콤보 **원시 선택값**의 앞 2자리가 "81" 이면 81계열(81/811/812… 하위코드 포함)
- `B` = `CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues)` 로 **환산한 실코드** `sDivision` 을 대상으로 동일 비교 (ALL 선택 시 체크된 코드 목록으로 치환됨)
- `C` = 그리드 셀값 `DIVISION_ID` (`sDIVISION_ID`) 를 대상으로 비교 — 행 단위 분기

| # | 위치(메서드) | 라인 | 판정식(자연어) | 40 동작 | 81계열 동작 | 82(else) 동작 | 활성/주석 |
|---:|---|---|---|---|---|---|---|
| 1 | `Form_Load` | 203–214 | 콤보 원시값 앞2자리가 "81" 인지(A) | Excel Upload/Template 버튼 `Visible=false` + layoutControlItem12/29 `Never` | 두 버튼 `Visible=true` + layoutControlItem12/29 `Always` | 40과 동일(숨김) | 활성 |
| 2 | `InitControls` | 308 | 실코드가 "82" 인가 | — | — | `btnSavePricePeriod.Enabled=true` 예정이었음 | **주석** |
| 3 | `InitControls` | 320–370 | 실코드 앞2자리 "81" **또는** "82"(B) | EndCustomer=EndCustomerByDivision(콤보원시값,팀원시값), BizType 로드, `lblProject/lblPlantSite/layoutControlItem6` **Enabled=false**, `umltProject.Text=""`, `clbPlantSite.ControlValues=""`, `checkInvalidExec.Enabled=false` | EndCustomer=EndCustomerByDivision(실코드,실팀), BizType=BizType(콤보원시값), `lblProject/lblPlantSite/layoutControlItem6` **Enabled=true** | 81과 동일 진입(단 #4에서 재분기) | 활성 |
| 4 | `InitControls` | 339–346 | (#3 내부) 실코드가 "82" 인가 | — | `checkInvalidExec.Enabled=false` | `checkInvalidExec.Enabled=true` | 활성 |
| 5 | `InitControls` | 372–374 | 실코드가 "42" 또는 "44" 인가 | — | — | `lblBizType.Enabled=false` 예정이었음 | **주석** (결과: 375행에서 무조건 `true`) |
| 6 | `InitControls` | 385–392 | 실코드 문자열에 "81" 이 **포함**(IndexOf≠-1)되는가 | 미수행 | `UserPlantSiteByEndCustomer` 조회 → `clbPlantSite` 세팅 | 미수행 | 활성 |
| 7 | `EditButton` | 870–878 | 룩업 `DM_UI_EDITABLE_DIVISION`(PARAM1="DMF0020", PARAM2=콤보원시값) 의 `EDIT_YN` 이 'N' 인가 | **'N' → MSG00448 후 편집 진입 차단** ([PJ2025-50017] 40사업부는 DMF0082에서 편집) | 룩업 결과에 따름 | 룩업 결과에 따름 | 활성 |
| 8 | `EditButton` | 881–895 | 콤보 원시값 == "40" | 필수컬럼 7종(`END_CUSTOMER40`,`SCM_SITE_ID`,`ITEM_ID`,`INCOTERMS`,`FCST_TYPE`,`DOM_EXP`,`CURRENCY`) 중 1개라도 부재 시 **MSG00113 후 return** | — | — | 활성 |
| 9 | `EditButton` | 896–910 | 콤보 원시값 == "42" 또는 "44" | — | — | 필수컬럼 7종(`DEPT_ID` 포함, `DOM_EXP` 제외) 검사 예정이었음 | **주석** |
| 10 | `EditButton` | 911–926 | 콤보 원시값 앞2자리 == "81"(A) | — | 필수컬럼 **8종**(`SCM_SITE_ID`,`PROJECT_CODE`,`ITEM_ID`,`INCOTERMS`,`FCST_TYPE`,`DOM_EXP`,`CURRENCY`,**`PLANT_SITE_ID`**) 부재 시 MSG00113 return | — | 활성 |
| 11 | `EditButton` | 927–941 | 콤보 원시값 == "82" | — | — | 필수컬럼 **7종**(81에서 `PLANT_SITE_ID` 제외) 부재 시 MSG00113 return | 활성 |
| 12 | `EditButton` | 1031–1063 | 콤보 원시값=="82" **AND** 행의 `NEW_FLAG`=='Y' | (else 경로 #13) | (else 경로 #13) | 마스터 컬럼 14종을 **개별 존재확인 후 셀 단위 잠금** (`DIVISION_ID`,`DEPT_ID`,`DEPT_NAME_KO`,`END_CUSTOMER`,`SCM_SITE_ID`,`PROJECT_CODE`,`PROJECT_NAME`,`PROJECT_STATUS`,`BIZ_TYPE`,`BIZ_TYPE_NAME`,`ITEM_ID`,`ITEM_CLASS_NAME`,`ITEM_NAME`,`NICK_NAME`) + `MEASURE` | 활성 |
| 13 | `EditButton` | 1064–1067 | (#12 else) | `DIVISION_ID`~`MEASURE` **연속범위 일괄 잠금** | 동일 | 82 & NEW_FLAG≠'Y' 시 동일 | 활성 |
| 14 | `EditButton` | 1112–1124 | `clbDivisions.SelectedValue` == "40" | (본문 전체 주석 → **실질 무동작**) | `PROJECT_NAME`/`PROJECT_STATUS`/`BIZ_TYPE_NAME` 존재 시 각각 잠금 | 81과 동일 | 활성(단 40 분기 본문은 주석) |
| 15 | `SaveData` 1차검증 | 1597–1598 | 행값 `sDIVISION_ID`=="82" AND `NEW_FLAG`=='Y'(C) | — | — | `CurrentDataRow = GetCellIndexBySpanRowCells(i)` 로 RowSpan 첫 행 보정 | 활성 ⚠ **잠재결함**: 이 시점 `sDIVISION_ID` 는 아직 `""` (1601–1602 에서 대입) → 조건 항상 false |
| 16 | `SaveData` 1차검증 | 1606–1613 | 행값 `sDIVISION_ID`(C) | `sPROJECT_CODE = END_CUSTOMER40` 텍스트 | `sPROJECT_CODE = PROJECT_CODE` 텍스트 | 81과 동일 | 활성 |
| 17 | `SaveData` 1차검증 | 1637 | 행값 앞2자리=="81" AND `p_plant_site_id`=="" | 검사 안 함 | **Plant Site 미입력이면 저장 차단** ([C20210330-000045]) | 검사 안 함 | 활성 |
| 18 | `SaveData` 1차검증 | 1649–1659 | 필수 누락 메시지 조립 시 행값 분기 | 누락 라벨 `[End Customer]` | 누락 라벨 `[Project Code]` | `[Project Code]` | 활성 |
| 19 | `SaveData` 1차검증 | 1674–1676 | 행값 앞2자리=="81" AND plant 공백 | — | 누락 라벨 `[Plant Site]` 추가 | — | 활성 |
| 20 | `SaveData` 중복오류 | 1691–1701 | 행값 == "40" | 메시지 키셋 `[Division],[End Customer],[Sales Site],[Model],[INCOTERMS],[FcstType],[Customs Handbook],[Currency]` | 메시지 키셋에 `[Project Code],[PLANT_SITE_ID]` 사용 | 81과 동일 문자열(82도 PLANT_SITE_ID 표기됨 — 실제 82 키셋과 불일치) | 활성 |
| 21 | `SaveData` 2차저장 | 1742–1746 | action=='I' **또는** (행값=="82" AND `NEW_FLAG`=='Y' AND action=='M') | — | — | RowSpan 첫 행으로 `CurrentDataRow` 보정 | 활성 |
| 22 | `SaveData` 2차저장 | 1758–1770 | 행값(C) 3-way | `sPROJECT_CODE = END_CUSTOMER40` (plant 미수집) | `sPROJECT_CODE = PROJECT_CODE` **+ `p_plant_site_id = PLANT_SITE_ID`** | `sPROJECT_CODE = PROJECT_CODE` (plant 미수집 → `""` 전송) | 활성 |
| 23 | `SaveData` Price누락 | 1881–1888 | 변수 `sDivision`(마지막 처리행) == "40" | 메시지 인자 `"END CUSTOMER"` | 메시지 인자 `"PROJECT_CODE"` | `"PROJECT_CODE"` | 활성 |
| 24 | `InsertRow` | 2007–2015 | `clbDivisions.SelectedValue` == "40" | SalesSite=`UserSiteByEndCustomer`(비Auth), EndCustomer=`EndCustomerByDivision40`, **`DOM_EXP` 셀에 CustomsHandbook 콤보 부착** | — | — | 활성 |
| 25 | `InsertRow` | 2016–2020 | == "42" 또는 "44" | — | — | 비Auth SalesSite + `Data.Type.EndCustomer` 예정이었음 | **주석** |
| 26 | `InsertRow` | 2021–2025 | (#24 else) | — | SalesSite=`UserSiteByEndCustomerAuth`, EndCustomer=`UserEndCustomerByDivisionDeptAuth` | 81과 동일 | 활성 |
| 27 | `InsertRow` | 2078–2082 | `clbDivisions.SelectedValue` == "40" | `END_CUSTOMER40` 셀에 콤보 부착 (ProjectStatus 잠금은 주석) | — | — | 활성 |
| 28 | `InsertRow` | 2083–2095 | (#27 else) | — | `END_CUSTOMER` 콤보 + `PROJECT_CODE` 이미지셀 + `PROJECT_NAME`/`PROJECT_STATUS`/`BIZ_TYPE_NAME` 잠금 | 81과 동일 | 활성 |
| 29 | `fnValidation` | 2231–2235 | 콤보 원시값 앞2자리=="81" 또는 =="82" | — | 비교 기준값 = 셀 `DIVISION_ID` + 셀 `PROJECT_CODE` | 81과 동일 | 활성 |
| 30 | `fnValidation` | 2241–2245 | (#29 else) | **`sDivision = "40"` 하드코딩** + 기준값 `END_CUSTOMER40` | — | — | 활성 ⚠ 40 이외 코드(42/44 등)도 "40" 으로 강제 |
| 31 | `fnValidation` | 2261–2264 | 콤보 원시값 앞2자리 == "81" | — | `sPlantSiteId` 추가 수집 | — | 활성 |
| 32 | `fnValidation` | 2269–2285 | 콤보 원시값 앞2자리 == "81" | — | **중복키 10개**: DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, **PLANT_SITE_ID** | — | 활성 |
| 33 | `fnValidation` | 2286–2301 | 콤보 원시값 == "82" | — | — | **중복키 9개** (81에서 PLANT_SITE_ID 제외) | 활성 |
| 34 | `fnValidation` | 2302–2315 | == "42" 또는 "44" | — | — | 중복키 7개(PROJECT/DOM_EXP 제외) 예정이었음 | **주석** |
| 35 | `fnValidation` | 2316–2331 | (else) | **중복키 9개** (PROJECT_CODE 자리에 `END_CUSTOMER40`) | — | — | 활성 |
| 36 | `usrButton1_Click` | 2425–2439 | `clbDivisions.SelectedValue` != "40" | **Project 팝업 호출 안 함**(무동작) | `SCM0002_ProjectbyDivisionPopupEx` 팝업 호출 → `umltProject.Text` 갱신 | 81과 동일 | 활성 |
| 37 | `clbDivisions_SelectedIndexChanged` | 2489 | 실코드 == "82" | — | — | `btnSavePricePeriod.Enabled` 토글 예정이었음 | **주석** |
| 38 | `clbDivisions_SelectedIndexChanged` | 2491–2507 | 실코드 앞2자리=="81" 또는 =="82"(B) | (#41 else) | EndCustomer 재조회 + BizType **2회 조회**(2499 구방식 + 2500 신방식) + `lblProject.Enabled=true`, `layoutControlItem6.Enabled=true` | 81과 동일 | 활성 ⚠ 2499·2500 이중 조회 |
| 39 | `clbDivisions_SelectedIndexChanged` | 2508–2516 | (#38 내부) 실코드에 "81" 포함 | — | `UserPlantSiteByEndCustomer` → `clbPlantSite` | 미수행 | 활성 |
| 40 | `clbDivisions_SelectedIndexChanged` | 2519–2524 | (#38 내부) 실코드 == "82" | — | — | `checkInvalidExec.Enabled=true`, `lblPlantSite.Enabled=false`, `clbPlantSite.ControlValues=""` | 활성 |
| 41 | `clbDivisions_SelectedIndexChanged` | 2525–2529 | (#40 else) | — | `checkInvalidExec.Enabled=false`, `lblPlantSite.Enabled=true` | — | 활성 |
| 42 | `clbDivisions_SelectedIndexChanged` | 2531–2552 | (#38 else) | EndCustomer(EndCustomerByDivision), BizType 재조회, `lblProject/lblPlantSite/layoutControlItem6` **false**, `checkInvalidExec.Enabled=false`, `clbPlantSite` 클리어 | — | — | 활성 |
| 43 | `clbDivisions_SelectedIndexChanged` | 2553–2555 | == "42" 또는 "44" | — | — | `lblBizType.Enabled=false` 예정 | **주석** (2556 에서 무조건 true) |
| 44 | `clbDivisions_SelectedIndexChanged` | 2579–2590 | 콤보 원시값 앞2자리 == "81"(A) | Excel Upload/Template **숨김** + layout Never | **표시** + layout Always | 숨김 | 활성 |
| 45 | `spdMain_ComboSelChange` | 2660–2663 | 셀 `DIVISION_ID` 값 앞2자리 != "81"(C) | `PLANT_SITE_ID` 셀 **잠금** | `PLANT_SITE_ID` 셀 **해제** | 잠금 | 활성 |
| 46 | `spdMain_ComboSelChange` (DEPT_ID 변경) | 2688–2694 | 셀 `DIVISION_ID` 앞2자리=="81" 또는 =="82" | — | `UserEndCustomerByDivisionDeptAuth` → `END_CUSTOMER` 콤보 | 81과 동일 | 활성 |
| 47 | `spdMain_ComboSelChange` (DEPT_ID 변경) | 2695–2701 | (#46 else) | `Data.Type.EndCustomerByDivision40` → `END_CUSTOMER40` 콤보 | — | — | 활성 |
| 48 | `Dsdm_Changed` | 3080–3088 | **콤보 원시값** 앞2자리=="81" AND 변경열==`PROJECT_CODE` | 미수행 | `Data.Type.SalesPlant`(division, project, item) 재조회 → `PLANT_SITE_ID` 콤보 | 미수행 | 활성 ⚠ 3076 주석대로 셀값이 아닌 **화면 콤보값** 사용 |
| 49 | `Dsdm_Changed` | 3089–3097 | 콤보 원시값 앞2자리=="81" AND 변경열==`ITEM_ID` | 미수행 | 동일 재조회 | 미수행 | 활성 |
| 50 | `spdMain_CellDoubleClick` | 3236–3245 | 셀 `DIVISION_ID` == "40"(C) | `sEndCustomer = END_CUSTOMER40`, `sProject=""` | `sProject = PROJECT_CODE`, `sEndCustomer = END_CUSTOMER` | 81과 동일 | 활성 |
| 51 | `btnBatch_Click` | 3460–3464 | 콤보 원시값 대문자 == "ALL" | ALL 이면 체크된 실코드 목록으로 치환 후 `,`→`^` 변환 | 동일 | 동일 | 활성 |
| 52 | `clbTeam_SelectedIndexChanged` | 3661–3666 | `clbDivisions.SelectedValue` 앞2자리=="81" 또는 =="82" | — | EndCustomer 조회에 **실코드+실팀코드** 전달 | 81과 동일 | 활성 |
| 53 | `clbTeam_SelectedIndexChanged` | 3667–3672 | (#52 else) | EndCustomer 조회에 **실코드 + 팀 원시값**(`clbTeam.ControlValues`) 전달 | — | — | 활성 |
| 54 | `Raw_CellClick` | 3707–3716 | 클릭열==`PLANT_SITE_ID` **또는** 콤보 원시값 앞2자리=="81" | (열이 PLANT_SITE_ID 인 경우만) | `Data.Type.PlantSiteByItem` 조회 → `PLANT_SITE_ID` 콤보 재부착 | (열 조건 시) | 활성 |
| 55 | `Raw_CellClick` | 3727–3730 | 셀값 division == "82" AND 클릭열==`INCOTERMS` | — | — | `SetRowSpanFucTwo(첫행 ~ 첫행+3)` **4행 병합** | 활성 |
| 56 | `Raw_CellClick` | 3731–3734 | 셀값 division == "82" AND 클릭열==`FCST_TYPE` | — | — | 동일 4행 병합 | 활성 |
| 57 | `Raw_CellClick` | 3735–3738 | 셀값 division == "82" AND 클릭열==`DOM_EXP` | — | — | 동일 4행 병합 | 활성 |
| 57-a | `Raw_CellClick` | 3742–3747 | 셀값 division == "82" AND 클릭열==`CURRENCY` | — | — | 4행 병합 예정이었음 ([E20250113-000150] 로 폐기) | **주석** |

> 표 행수: 본문 57행(#1~#57, #57-a 포함하여 실제 58 표기이나 **#57-a 는 #57 계열 주석 1건**으로 카운트) → **총 57건 (활성 49 / 주석 8)**.
> 주석 8건 = #2, #5, #9, #25, #34, #37, #43, #57-a.

### §1 부표 — Division **값 전달만** 하는 위치 (분기 없음, 16건)

| # | 위치 | 라인 | 전달 형태 |
|---:|---|---|---|
| 1 | `SetChangeControl` | 241 / 248 / 256 / 263 / 272 / 279 | `Filter["DIVISION_ID"] = sDivision` (6 케이스) |
| 2 | `InitControls` | 306 | `sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues)` — 판정값 산출 |
| 3 | `InitControls` | 329 / 352 / 357 / 381 / 390 | `SetChangeControl(..., clbDivisions.ControlValues, ...)` 원시값 전달 |
| 4 | `FindData` | 1312 / 1353 | `p_division_id` = 실코드 → SP `DM.DMF0020_GET_SCM_MST_FUTURE_PRICE` |
| 5 | `SaveData` | 1839 | `nvc["p_DIVISION_ID"]` = 행값 |
| 6 | `SaveData` | 1936–1942 | `DMF0020_SalesPriceRangePopUp.LoadData(ds.Tables[2], sDivisionId)` |
| 7 | `btnSavePricePeriod_Click` | 2379–2384 | 팝업 `LoadData(clbDivisions.ControlValues, ...)` |
| 8 | `usrButton1_Click` | 2428 | Project 팝업에 실코드 전달 |
| 9 | `btnModelType_Click` | 2446 | Item 팝업에 실코드 전달 |
| 10 | `clbDivisions_SelectedIndexChanged` | 2480 | 실코드 산출 |
| 11 | `Dsdm_Changed` | 3085 / 3094 | `Data.Common(SalesPlant, ..., sDivision, ...)` |
| 12 | `GetSpdTitle` | 3558 | `p_division_id = clbDivisions.SelectedValue` → **컬럼 세트 자체가 Division 종속** |
| 13 | `clbTeam_SelectedIndexChanged` | 3657 | 실코드 산출 |
| 14 | `Raw_CellClick` | 3713 | `Data.Common(PlantSiteByItem, ..., sDivision, ...)` |
| 15 | `btnOwner_Click` | 3774 | Owner 팝업에 실코드 전달 |
| 16 | `btnColumn_Click` / `btnSPVer_Click` / `btnTemplate_Click` | 3794 / 3898 / 3930 | TitleSet 팝업 / 버전 팝업 / 템플릿 팝업에 Division 전달 |

---

## §2 권한 축 (총 28건 — 1건 1행)

| # | 위치 | 라인 | 조건 / 판정식 | 동작 | 활성/주석 |
|---:|---|---|---|---|---|
| 1 | `SetChangeControl` | 229–230 | 무조건 | 모든 콤보 조회 Filter 에 `GROUP_ID = UserInfoContext.Current["NowGroupID"]`, `USER_ID = UserId` 주입 → **콤보 목록 자체가 권한 필터링** | 활성 |
| 2 | `InitControls` | 310 | 무조건 | `Data.Common(UpperDeptId, false, NowGroupID, UserId)` → `dtDepartment` (단 화면 바인딩 없음) | 활성 |
| 3 | `DefineProperty` | 454–467 | `switch(NowGroupID)` : "ADMIN" / "DM ADMIN" | `layoutControlItem5.Visibility = Always` (Batch Job 영역) | 활성 |
| 4 | `DefineProperty` | 465 | default (그 외 모든 그룹) | `layoutControlItem5.Visibility = Never` | 활성 |
| 5 | `DefineProperty` | 458–459 | ADMIN 분기 | `btnCutOff.Enabled=true; btnCutOff.Visible=true` 예정이었음 | **주석** |
| 6 | `DefineProperty` | 463–464 | default 분기 | `btnCutOff.Enabled=false; Visible=false` 예정이었음 | **주석** |
| 7 | `InsertButton` | 839 | `!isCurVersion` | **행 추가 차단**(무메시지 return) — Current 버전 조회 시에만 입력 가능 | 활성 |
| 8 | `EditButton` | 864 | `!isCurVersion` | **편집 진입 차단**(무메시지 return) | 활성 |
| 9 | `EditButton` | 870–878 | 룩업 `DM_UI_EDITABLE_DIVISION.EDIT_YN == 'N'` | MSG00448 후 편집 차단 — **Division 단위 편집권한** | 활성 |
| 10 | `EditButton` | 1070–1074 | 행 `AUTHORITY_YN != 'Y'` **AND** Action 컬럼 공백 | 해당 행의 `MEASURE+1 ~ MaxColumn`(전 기간 값) **잠금** = 권한 없는 행 값 수정 불가 | 활성 |
| 11 | `EditButton` | 1075–1158 | 행 `AUTHORITY_YN != 'Y'` **AND** Action=='I' **AND** `IsEditMode==true` | 신규 입력 행에 한해 기간 컬럼/마스터 컬럼 선택 해제 (세부는 §6-A #27~#42) | 활성 |
| 12 | `FindData` | 1365 | 무조건 | SP 파라미터 `p_created_by = UserId` | 활성 |
| 13 | `FindData` | 1366 | 무조건 | SP 파라미터 `p_userinfo = NowGroupID` → **조회 결과의 `AUTHORITY_YN` 산출 근거** | 활성 |
| 14 | `FindData` | 1370 | — | `p_user_dept_id = UserInfoContext.Current["Dept_ID"]` (JV Planner 과제) 전달 예정이었음 | **주석** |
| 15 | `InsertRow` | 2003 | 무조건 | Team 콤보 = `Data.UserTeamByDivisionAuth(NowGroupID, UserId, sDivision)` — **Auth 계열** | 활성 |
| 16 | `InsertRow` | 2009–2010 | Division=="40" | SalesSite = `UserSiteByEndCustomer`(**비Auth**), EndCustomer = `EndCustomerByDivision40`(**비Auth**) | 활성 |
| 17 | `InsertRow` | 2023–2024 | Division≠"40" | SalesSite = `UserSiteByEndCustomerAuth`, EndCustomer = `UserEndCustomerByDivisionDeptAuth` — **Auth 계열** | 활성 |
| 18 | `spdMain_ComboSelChange` | 2618 | DIVISION_ID 셀 변경 | Team 콤보 = `Data.UserTeamByDivision`(**비Auth**) ⚠ InsertRow(#15) 와 불일치 | 활성 |
| 19 | `spdMain_ComboSelChange` | 2619 | 동일 위치 | `UserTeamByDivisionAuth` 사용 예정이었음 | **주석** |
| 20 | `spdMain_ComboSelChange` | 2630 | DIVISION_ID 변경 & END_CUSTOMER 열 존재 | `UserEndCustomerByDivisionDeptAuth` | 활성 |
| 21 | `spdMain_ComboSelChange` | 2640 | DIVISION_ID 변경 & END_CUSTOMER40 열 존재 | `Data.Type.EndCustomerByDivision40`(비Auth) | 활성 |
| 22 | `spdMain_ComboSelChange` | 2648 | DIVISION_ID 변경 | SalesSite = `UserSiteByEndCustomerAuth` | 활성 |
| 23 | `spdMain_ComboSelChange` | 2690 / 2702 | DEPT_ID 변경(81·82) | `UserEndCustomerByDivisionDeptAuth` + `UserSiteByEndCustomerAuth` | 활성 |
| 24 | `spdMain_ComboSelChange` | 2697 | DEPT_ID 변경(40) | `EndCustomerByDivision40`(비Auth) | 활성 |
| 25 | `spdMain_ComboSelChange` | 2722 | END_CUSTOMER 변경 | `UserSiteByEndCustomerAuth` ⚠ 이때 `sDivision` 은 초기값 `CAppSetting.StringALL` 로 전달됨 | 활성 |
| 26 | `spdMain_ComboSelChange` | 2755 | END_CUSTOMER40 변경 | `UserSiteByEndCustomer`(**비Auth**) | 활성 |
| 27 | `btnSPVer_Click` | 3908–3915 | 선택 버전 개수 > 2 | **MSG00255("읽기전용") 후 return** — 버전 텍스트 미반영 | 활성 |
| 28 | Designer | [D]298 / [D]1270–1272 | 무조건(설계 시점) | `btnBatch.Visible=false`, `layoutControlItem5.ContentVisible=false`, `layoutControlItem5.Enabled=false` → **ADMIN 이어도 실제 노출 안 됨**(§7-D 참조) | 활성 |

> 참고(주석 이력): `.cs` 44행 `2021-11-19 kdw2819 [과제] 자동차 사업부 JV Planner 권한 체크 추가` — 현재 소스에 활성 구현 없음(#14 만 주석 잔존).

---

## §3 Measure 축 (총 30건 — 1건 1행)

> **Measure 축 존재.** 1 논리 데이터 = `dtMeasureCount.Rows.Count` 개 물리행(RowSpan). 소스 주석·코드상 실제 값은 **LOC / USD / KRW / RTF / RTF_SYS_RP** 계열이며, 저장 루프가 `i += 4`(1566, 2223)로 고정 4배수 순회 → **현행 Measure 4종** 전제.
> 저장 대상 엔터티 = SP `DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL` (파라미터 17종, §3 #26).

| # | 위치 | 라인 | 조건 | 동작 | 활성/주석 |
|---:|---|---|---|---|---|
| 1 | 필드 선언 | 81 | — | `DataTable dtMeasureCount` — Measure 목록/개수 원천 | 활성 |
| 2 | `InitControls` | 399 | Form Load | `dtMeasureCount = GetMeasureCountInfo()` | 활성 |
| 3 | `GetMeasureCountInfo` | 507–520 | — | SP `DM.DMF0020_GET_MEASURE_COUNTINFO` → Measure 고정 리스트 | 활성 |
| 4 | `InsertRow` | 1997 | 행 추가 | `siMain.Insert2(dtMeasureCount.Rows.Count)` — **Measure 수만큼 행 생성** | 활성 |
| 5 | `InsertRow` | 2073–2074 | 각 i | `MEASURE` 셀 = `dtMeasureCount.Rows[i]["LOOKUP_CODE"]` | 활성 |
| 6 | `InsertRow` | 2108–2111 | `LOOKUP_CODE.ToUpper() != "LOC"` | 해당 행 `MEASURE ~ MaxColumn` **전체 잠금** → **입력 가능 Measure 는 LOC 뿐** | 활성 |
| 7 | `InsertRow` | 2180 | 행 추가 후 | `CUIControl.SetRowSpanFuc(..., dtMeasureCount.Rows.Count - 1, 1, MEASURE-1, ...)` — 마스터 컬럼 RowSpan | 활성 |
| 8 | `SaveData` 1차검증 | 1566 | 루프 | `for (i=0; i<=MaxRow; i += 4)` — "RTF 추가로 3배수→**4배수**" 주석 | 활성 |
| 9 | `fnValidation` | 2223 | 루프 | `for (iRow=0; ...; iRow += 4)` — 동일 4배수 | 활성 |
| 10 | `SaveData` 2차저장 | 1791 | 각 행 | `sMEASURE = GetText(i, MEASURE)` — **CurrentDataRow 아닌 원래 행** 값 사용 | 활성 |
| 11 | `SaveData` 2차저장 | 1795 | `sMEASURE == "RTF"` 또는 `== "RTF_SYS_RP"` | **해당 행 저장 제외**(continue) | 활성 |
| 12 | `SaveData` 2차저장 | 1830–1836 | `action != "D"` AND `sMEASURE == "LOC"` AND 값=="0" | 전송 action 을 **'D'(삭제)** 로 치환 — LOC 0 입력 = 삭제 의미 | 활성 |
| 13 | `EditButton` | 1173–1176 | `sMeasure == "KRW"/"USD"/"RTF"` (완전일치) | 값 컬럼 전체 잠금 예정이었음 | **주석** |
| 14 | `EditButton` | 1179–1182 | `sMeasure.ToUpper()` 에 "KRW"/"USD"/"RTF" **포함**(IndexOf>-1) | 해당 행 `MEASURE+1 ~ Max` **잠금** — "메저값이 계속 변경되므로 IndexOf 처리" | 활성 |
| 15 | `EditButton` | 1184–1197 | `sMeasure.ToUpper() == "LOC"` AND 시트 편집모드 | `CURRENCY` 셀 **잠금 해제** + `MergePolicy=None` ([E20250113-000150] Currency 수정 허용) | 활성 |
| 16 | `EditButton` | 1199–1208 | KRW / USD 개별 분기 | 각각 값 컬럼 잠금 예정이었음 | **주석** |
| 17 | `EditButton` | 1062 | 82 & NEW_FLAG='Y' | `MEASURE` 셀 잠금 | 활성 |
| 18 | `EditButton` | 1131 | AUTHORITY_YN≠'Y' & 'I' 행 | `MEASURE` 셀 잠금 | 활성 |
| 19 | `InsertRow` | 2104 | 각 i | `MEASURE` 셀 잠금 | 활성 |
| 20 | `GetCellIndexBySpanRowCells` | 2929–2935 | — | `Math.DivRem(iActiveRow, dtMeasureCount.Rows.Count)` → **RowSpan 그룹 첫 행** 반환 | 활성 |
| 21 | `GetCellNumbersByRow` | 2944–2971 | — | 같은 Measure 그룹에 속한 행 번호 배열 반환 (Delete·색상판정에 사용) | 활성 |
| 22 | `DeleteButton` | 851–858 | Action=='I' 인 행만 | `GetCellNumbersByRow` 로 **Measure 그룹 전체 행을 역순 삭제** | 활성 |
| 23 | `SaveData` 2차저장 | 1803–1806 | 색상 판정 | `GetCellNumbersByRow(i)` 의 **마지막 행** ForeColor 가 Red 가 아니면 skip → 변경분만 저장 | 활성 |
| 24 | `Dsdm_Changed` | 3025–3044 | 값 셀 변경 | `for (i = Count-1; i > 0; i--)` 로 **상위 Measure 행에 환산값 전파**, `sTargetER == "RTF_SYS_RP"` 는 continue(3033) | 활성 |
| 25 | `spdMain_ComboSelChange` | 2851–2870 | CURRENCY 변경(기존행) | 동일 전파 루프 + `RTF_SYS_RP` continue(2859) | 활성 |
| 26 | `SetExchangeValues` | 3129–3143 | 월 SUM 입력의 주차 배분 | 동일 전파 루프 — ⚠ **`RTF_SYS_RP` 제외 로직 없음** (#24·#25 와 불일치) | 활성 |
| 27 | `GetExchangeRate` | 3168–3209 | Measure(=대상통화) vs Currency(=기준통화) | 4단계 환산: 동일→원값 / 직접환율 / 역수환율 / KRW 경유 USD 환산 / 실패 시 `""` 또는 `"0"` | 활성 |
| 28 | `SetTextCellsToRowSpanRange` | 2913–2921 | 팝업 선택값 반영 | Measure 개수만큼 동일 값 전파, 단 `FCST_TYPE` 은 `SetValue` 만(§4 #19) | 활성 |
| 29 | `spdMain_CellDoubleClick` | 3308 | Item 팝업 확정 | `SetTextCellsToRowSpanRange(popItem.currency, e.Row, CURRENCY, dtMeasureCount.Rows.Count)` | 활성 |
| 30 | `SaveData` | 1838–1855 | 저장 payload | **저장 대상 17 파라미터**: `p_active_flag, p_DIVISION_ID, p_PROJECT_CODE, p_SCM_SITE_ID, p_PLANT_SITE_ID, p_ITEM_ID, p_YYYYMMDD, p_CURRENCY, p_MEASURE, p_DOM_EXP, p_FCST_TYPE, p_INCOTERMS, p_PRICE, p_CREATED_BY, p_CREATION_DATE, p_LAST_UPDATED_BY, p_ROWNUM` (`^` 구분 누적) | 활성 |

---

## §4 FCST_TYPE 축 (총 21건 — 1건 1행)

> **축 존재.** 단 **조회조건(검색 영역)에는 FCST_TYPE 없음** — 그리드 컬럼 + 저장키 + 필수값으로만 작동.

| # | 위치 | 라인 | 조건 | 동작 | 활성/주석 |
|---:|---|---|---|---|---|
| 1 | `DefColumns` | 153 | — | `public static string FcstType = "FCST_TYPE";` | 활성 |
| 2 | `EditButton` (40) | 887 | 컬럼 부재 | MSG00113 → 편집 차단 | 활성 |
| 3 | `EditButton` (42/44) | 903 | — | 동일 검사 예정이었음 | **주석** |
| 4 | `EditButton` (81) | 917 | 컬럼 부재 | MSG00113 → 편집 차단 | 활성 |
| 5 | `EditButton` (82) | 933 | 컬럼 부재 | MSG00113 → 편집 차단 | 활성 |
| 6 | `SaveData` 1차 | 1591 | — | `string sFcstType = "";` 초기화 | 활성 |
| 7 | `SaveData` 1차 | 1627–1628 | 컬럼 존재 | `sFcstType = GetValue(CurrentDataRow, FCST_TYPE)` — **RowSpan 첫 행** 값 사용 | 활성 |
| 8 | `SaveData` 1차 | 1642 | `sFcstType == ""` | 저장 차단(MSG00002) | 활성 |
| 9 | `SaveData` 1차 | 1670–1671 | 누락 메시지 | 라벨 `[FCST Type]` | 활성 |
| 10 | `SaveData` 2차 | 1755 | — | 변수 재선언 | 활성 |
| 11 | `SaveData` 2차 | 1777–1778 | 컬럼 존재 | `sFcstType = GetValue(CurrentDataRow, FCST_TYPE)` | 활성 |
| 12 | `SaveData` 2차 | 1849 | 전송 | `nvc["p_FCST_TYPE"]` 누적 | 활성 |
| 13 | `fnValidation` | 2252–2253 | 컬럼 존재 | 기준값 수집 | 활성 |
| 14 | `fnValidation` (81) | 2276 | 중복키 | 10키 중 1 | 활성 |
| 15 | `fnValidation` (82) | 2293 | 중복키 | 9키 중 1 | 활성 |
| 16 | `fnValidation` (42/44) | 2307 | — | 중복키 포함 예정이었음 | **주석** |
| 17 | `fnValidation` (40) | 2323 | 중복키 | 9키 중 1 | 활성 |
| 18 | `spdMain_ComboSelChange` | 2765–2768 | 변경열==`FCST_TYPE` **AND** 값이 공백 | 직전 클릭행(`sTempRow`) 의 FCST_TYPE 값을 **자동 복사** ([C20200612-000174] ESS 자동완성) | 활성 |
| 19 | `SetTextCellsToRowSpanRange` | 2918–2920 | `sColName != "FCST_TYPE"` | FCST_TYPE 은 `SetValue` 만 수행하고 `SetText2` **미수행** — "FcstType 는 Code 만 적용" | 활성 |
| 20 | `Raw_CellClick` | 3731–3734 | division=="82" AND 클릭열==`FCST_TYPE` | `SetRowSpanFucTwo` 로 4행 병합 | 활성 |
| 21 | 조회조건 영역 | [D]1103–1127 | — | LayoutControlGroup3 의 24 아이템에 **FCST_TYPE 관련 컨트롤 없음** = 검색조건 축 부재 | 활성(부재 확인) |

---

## §5 기간·버킷 축 (총 41건 — 1건 1행)

| # | 위치 | 라인 | 규칙 / 조건 | 동작 | 활성/주석 |
|---:|---|---|---|---|---|
| 1 | `InitControls` | 295 | Form Load | `drpDateTime.InitValue = GetDayRange()` — **기본 조회기간을 서버에서 산정** | 활성 |
| 2 | `GetDayRange` | 417–431 | — | SP `DM.PR_GET_DAY_RANGE` (`p_created_by`=UserId, **`p_month` = 6**) → `Tables[1].Rows[0][0]` 문자열 | 활성 |
| 3 | 필드 | 68–69 | — | `string sStartDate/sEndDate` 클래스 필드 — **어디서도 실사용 없음**(각 메서드가 동명 지역변수로 섀도잉) | 활성(사용처 없음) |
| 4 | `InitControls` | 296–297 | — | 지역 `sStartDate/sEndDate` 산출 후 미사용 | 활성(사용처 없음) |
| 5 | `DefineProperty` | 439–440 | Form Load | `dtStartPeriod/dtEndPeriod` 에 현재 기간 보관(변경 감지용) | 활성 |
| 6 | `GetWeekData` | 490–505 | Form Load | SP `DM.DMF0020_GET_WEEKDATA` (`p_yyyymmdd` = **오늘**) → `dtWeek` = "전주까지 수정 불가" 판정 원천 | 활성 |
| 7 | `GetFuturePriceInfo` | 522–539 | Form Load / 조회 후 / 환율팝업 확정 후 | SP `DM.DMF0020_GET_FUTUREPRICE_INFO` (`yyyyMM + "01"` ~ `yyyyMM + "01"`) → 환산 환율 테이블 | 활성 |
| 8 | `InitSpread` | 577–580 | 기간이 직전과 **동일** AND `isChangeHeader==false` | `RemoveRowAll()` 만 수행 (헤더 유지) | 활성 |
| 9 | `InitSpread` | 581–594 | 그 외 | 기간 갱신 + `GetSpdTitle()` 재조회 + 헤더 Span 재구성 + `SetSpreadColumn()` | 활성 |
| 10 | `BucketType` struct | 118–123 | — | `Weekly = "WEEKLY"`, `Monthly = "MONTHLY"` / `Daily` 는 **주석** | 주석 1(Daily) |
| 11 | `InitControls` | 408–410 | Form Load | `GetBucketType()`(SP `DM.DMF0003_GET_BUCKET_TYPE_CODE`) 후 **`Rows.RemoveAt(0)`** → 선두 항목(ALL 등) 제거 후 콤보 바인딩 | 활성 |
| 12 | `cboBucketType_SelectedIndexChanged` | 558–572 | 버킷 변경 | `SetSpreadColumn()` 후, 편집모드였다면 `EditButton()` **2회 호출**로 편집모드 유지 | 활성 |
| 13 | `SetSpreadColumn` | 686–703 | `cboBucketType == WEEKLY` | 태그가 `W_` 로 시작하는 컬럼만 `Visible=true`, 나머지 `false` + `BackColor=White` | 활성 |
| 14 | `SetSpreadColumn` | 689–693 | `D_` 컬럼 숨김 | 일(Daily) 컬럼 처리 예정이었음 | **주석** |
| 15 | `SetSpreadColumn` | 704–716 | 그 외(MONTHLY) | `W_` 숨김 + White, `M_` 만 `Visible=true` | 활성 |
| 16 | `SetSpreadColumn(DataTable)` | 736–744 | `BASIS_START_DATE2` 가 `M_` 로 시작 | 컬럼 헤더 텍스트를 **"SUM"** 으로 생성 (그 외는 `MMDD`) | 활성 |
| 17 | `SetSpreadHeaderSpan` | 630–633 | 컬럼명에 `B_` 포함 | 해당 컬럼 **숨김**(백업/기준 컬럼) | 활성 |
| 18 | `EditButton` | 964–965 | 편집 진입 | **기준일 = 이번 주 월요일** = `DateTime.Today.AddDays(Monday - Today.DayOfWeek)` | 활성 |
| 19 | `EditButton` | 972–993 | Weekly & `W_` 컬럼 & `기준월요일 > 컬럼태그일자` | 해당 **과거 주차 컬럼 잠금** (미잠금 상태일 때만) / 잠금 상태면 전 `W_` 잠금 / `W_` 아닌 컬럼은 전부 잠금 | 활성 |
| 20 | `EditButton` | 994–1014 | Monthly & `M_` 컬럼 & `기준년월 > 컬럼태그년월` | 해당 **과거 월 컬럼 잠금** / 그 외 동일 규칙 | 활성 |
| 21 | `EditButton` | 1016–1024 | — | `iResultCol` = 마지막 과거 주차 컬럼, `iResultMonth` = **당월** `M_` 컬럼 인덱스 산출 | 활성 |
| 22 | `EditButton` | 1137–1157 | `drpDateTime.Value1 < DateTime.Now.AddDays(-7)` | `dtWeek` 순회하여 첫 주차와 다른 주차가 나오는 시점의 `W_{일자}` 컬럼까지 **일괄 잠금** | 활성 |
| 23 | `EditButton` | 1212–1216 | 행 존재 AND `iResultCol > iStartCol` | 과거 구간 배경 **Gainsboro**, 당월 SUM 컬럼은 **White** 복원 | 활성 |
| 24 | `FindData` | 1284–1288 | `txtVersion.Text.Trim() == ""` | **MSG00283** → 조회 차단 | 활성 |
| 25 | `FindData` | 1296–1298 | — | `sStartDate/sEndDate = Value1/Value2.ToString("yyyyMMdd")` | 활성 |
| 26 | `FindData` | 1300–1309 | `int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])` | **MSG00108** → 조회 차단 (기간 역전 방지) ⚠ `blnWork=true` 상태로 return → 이후 동작 잠김 가능 | 활성 |
| 27 | `FindData` | 1362–1363 | SP 호출 | `p_from_yyyymmdd` / `p_to_yyyymmdd` | 활성 |
| 28 | `FindData` | 1351 | SP 호출 | `CommandTimeout = 10 * 60`(600초) | 활성 |
| 29 | `FindData` | 1421–1446 | 조회 직후 | 기준월요일 기준 과거주차 **Gainsboro**, 당월 **White** ([C20200320-000374]) | 활성 |
| 30 | `FindData` | 1450–1453 | `txtVersion.Text.Trim() == "Current"` | `isCurVersion = true` → **Current 일 때만 Insert/Edit 허용** | 활성 |
| 31 | `SaveData` | 1816–1817 | 컬럼 태그가 `M_` 로 시작 | **월 컬럼은 저장 대상에서 제외**(continue) → 저장은 **주(W_) 단위만** | 활성 |
| 32 | `SaveData` | 1819 | — | `p_YYYYMMDD` = 컬럼태그에서 `"W_"` 제거한 일자 | 활성 |
| 33 | `SaveData` | 1903 | SP 호출 | `CommandTimeout = 90 * 60`(5400초) | 활성 |
| 34 | `InsertRow` | 2114–2148 | 주차가 이전월에 걸친 경우 비활성 처리 | `iResultCol` 까지 잠금하는 대체 로직 블록 전체 | **주석** |
| 35 | `InsertRow` | 2150–2171 | 원래 `drpDateTime.Value1 < Now.AddDays(-7)` 조건이 **주석 처리(2151)** | 조건 없이 **항상** `dtWeek` 기준 전주까지 잠금 수행 — "월에 걸쳐진 주차는 체크 못하므로 제거" | 활성(조건만 주석) |
| 36 | `spdMain_ComboSelChange` | 2887–2899 | 월 SUM(`M_`) 컬럼에 입력 | 같은 `yyyyMM` 을 갖는 후속 컬럼들에 `SetExchangeValues` 로 값 배분 | 활성 |
| 37 | `Dsdm_Changed` | 3061–3073 | 월 SUM(`M_`) 컬럼에 입력 | 동일 배분 로직 | 활성 |
| 38 | `spdMain_CellDoubleClick` (헤더) | 3317–3332 | 클릭 헤더 태그가 `M_` | 다음 `M_` 만날 때까지 `W_` 컬럼 **가시성 토글**, `D_` 는 보이면 숨김 | 활성 |
| 39 | `spdMain_CellDoubleClick` (헤더) | 3333–3343 | 클릭 헤더 태그가 `W_` | 다음 `W_` 만날 때까지 `D_` 컬럼 가시성 토글 | 활성 |
| 40 | `GetThisWeekMonday` | 3496–3514 | — | 임의 일자로부터 역방향으로 월요일 탐색 — **호출처 없음(dead code, 파일 내 유일 출현)** | 활성(미사용) |
| 41 | `cboBucketType_Click` / `usrDiscard_CheckedChanged` / `btnExchangeRate_Click` / `btnSPVer_Click` / Designer | 3817–3827 / 3829–3834 / 2409 / 3900–3902 / [D]469–472, [D]481–484 | 각각 | (a) 'I' 행 존재 시 버킷 변경 **MSG00227** 후 return / (b) Search over range 체크 시 **From = 이번주 월요일 −7일, To = From + 357일(=52주)** / (c) 환율 팝업 = `Value1(yyyyMM)` ~ `+1년` / (d) 버전 팝업 = `MultiTimeZone` 기준 **−3개월 ~ +3개월** / (e) DatePicker `MinDate 1999-01-01`, `MaxDate 2099-12-31`, 초기 `Value1=2013-07-12`, `Value2=1999-01-01` | 활성 |

---

## §6 Lock(편집잠금) 축 (총 91건 = A 66 + B 18 + C 7)

### §6-A Lock/Unlock **설정** 호출 전수 (66건 — 활성 54 / 주석 12)

| # | 위치 | 라인 | 대상 범위 | 조건 | 잠금/해제 | 활성/주석 |
|---:|---|---|---|---|---|---|
| 1 | `EditButton` | 960 | 시트 전체 | 편집 버튼 클릭 | **SwitchLock (토글)** | 활성 |
| 2 | `EditButton` | 962 | `0 ~ MEASURE` 열 | — | 잠금 예정이었음 | **주석** |
| 3 | `EditButton` | 980 | `W_` 컬럼 1개 | Weekly & 미잠금상태 & 기준월요일 > 컬럼일자 | 잠금 | 활성 |
| 4 | `EditButton` | 986 | `W_` 컬럼 1개 | Weekly & 잠금상태 | 잠금 | 활성 |
| 5 | `EditButton` | 991 | `W_` 아닌 컬럼 | Weekly | 잠금 | 활성 |
| 6 | `EditButton` | 1002 | `M_` 컬럼 1개 | Monthly & 미잠금상태 & 기준년월 > 컬럼년월 | 잠금 | 활성 |
| 7 | `EditButton` | 1007 | `M_` 컬럼 1개 | Monthly & 잠금상태 | 잠금 | 활성 |
| 8 | `EditButton` | 1012 | `M_` 아닌 컬럼 | Monthly | 잠금 | 활성 |
| 9 | `EditButton` | 1034 | `DIVISION_ID` 셀 | 82 & NEW_FLAG='Y' & 열 존재 | 잠금 | 활성 |
| 10 | `EditButton` | 1036 | `DEPT_ID` 셀 | 동일 | 잠금 | 활성 |
| 11 | `EditButton` | 1038 | `DEPT_NAME_KO` 셀 | 동일 | 잠금 | 활성 |
| 12 | `EditButton` | 1040 | `END_CUSTOMER` 셀 | 동일 | 잠금 | 활성 |
| 13 | `EditButton` | 1042 | `SCM_SITE_ID` 셀 | 동일 | 잠금 | 활성 |
| 14 | `EditButton` | 1044 | `PROJECT_CODE` 셀 | 동일 | 잠금 | 활성 |
| 15 | `EditButton` | 1046 | `PROJECT_NAME` 셀 | 동일 | 잠금 | 활성 |
| 16 | `EditButton` | 1048 | `PROJECT_STATUS` 셀 | 동일 | 잠금 | 활성 |
| 17 | `EditButton` | 1050 | `BIZ_TYPE` 셀 | 동일 | 잠금 | 활성 |
| 18 | `EditButton` | 1052 | `BIZ_TYPE_NAME` 셀 | 동일 | 잠금 | 활성 |
| 19 | `EditButton` | 1054 | `ITEM_ID` 셀 | 동일 | 잠금 | 활성 |
| 20 | `EditButton` | 1056 | `ITEM_CLASS_NAME` 셀 | 동일 | 잠금 | 활성 |
| 21 | `EditButton` | 1058 | `ITEM_NAME` 셀 | 동일 | 잠금 | 활성 |
| 22 | `EditButton` | 1060 | `NICK_NAME` 셀 | 동일 | 잠금 | 활성 |
| 23 | `EditButton` | 1062 | `MEASURE` 셀 | 82 & NEW_FLAG='Y' (열 존재 확인 없음) | 잠금 | 활성 |
| 24 | `EditButton` | 1066 | `DIVISION_ID ~ MEASURE` 연속 | 위 조건 **아님**(일반 행) | 잠금 | 활성 |
| 25 | `EditButton` | 1074 | `MEASURE+1 ~ MaxColumn` | `AUTHORITY_YN≠'Y'` & Action 공백 | 잠금 | 활성 |
| 26 | `EditButton` | 1084 | `W_` 과거 컬럼 | — | 잠금 예정이었음 | **주석** |
| 27 | `EditButton` | 1086 | `W_` 컬럼 셀 1개 | AUTH≠Y & Action='I' & IsEditMode & Weekly | **해제** | 활성 |
| 28 | `EditButton` | 1090 | `W_` 아닌 컬럼 셀 | 동일 & Weekly | 잠금 | 활성 |
| 29 | `EditButton` | 1098 | `M_` 과거 컬럼 | — | 잠금 예정이었음 | **주석** |
| 30 | `EditButton` | 1100 | 값 컬럼 셀 1개 | 동일 & Monthly | **해제**(무조건) | 활성 |
| 31 | `EditButton` | 1104 | `M_` 아닌 컬럼 | — | 잠금 예정이었음 | **주석** |
| 32 | `EditButton` | 1108 | `DIVISION_ID` 셀 | 동일 | 잠금 | 활성 |
| 33 | `EditButton` | 1109 | `DIVISION_ID+1 ~ MEASURE` | 동일 | **해제** | 활성 |
| 34 | `EditButton` | 1114 | `PROJECT_STATUS` 셀 (40) | — | 잠금 예정이었음 | **주석** |
| 35 | `EditButton` | 1119 | `PROJECT_NAME` 셀 | 동일 & Division≠40 & 열 존재 | 잠금 | 활성 |
| 36 | `EditButton` | 1121 | `PROJECT_STATUS` 셀 | 동일 | 잠금 | 활성 |
| 37 | `EditButton` | 1123 | `BIZ_TYPE_NAME` 셀 | 동일 | 잠금 | 활성 |
| 38 | `EditButton` | 1127 | `ITEM_CLASS_NAME` 셀 | 동일(Division 무관) | 잠금 | 활성 |
| 39 | `EditButton` | 1129 | `ITEM_NAME` 셀 | 동일 | 잠금 | 활성 |
| 40 | `EditButton` | 1131 | `MEASURE` 셀 | 동일 | 잠금 | 활성 |
| 41 | `EditButton` | 1133 | `NICK_NAME` 셀 | 동일 | 잠금 | 활성 |
| 42 | `EditButton` | 1151 | `MEASURE ~ W_{전주}` | 동일 & `Value1 < Now-7` | 잠금 | 활성 |
| 43 | `EditButton` | 1175 | `MEASURE+1 ~ Max` | Measure 완전일치 KRW/USD/RTF | 잠금 예정이었음 | **주석** |
| 44 | `EditButton` | 1181 | `MEASURE+1 ~ Max` | Measure 에 KRW/USD/RTF **포함** | 잠금 | 활성 |
| 45 | `EditButton` | 1192 | `CURRENCY` 셀 | Measure=="LOC" & 편집모드 & 열 존재 | **해제** (+ MergePolicy None) | 활성 |
| 46 | `EditButton` | 1202 | `MEASURE+1 ~ Max` | Measure=="KRW" | 잠금 예정이었음 | **주석** |
| 47 | `EditButton` | 1206 | `MEASURE+1 ~ Max` | Measure=="USD" | 잠금 예정이었음 | **주석** |
| 48 | `FindData` | 1406 | `0 ~ MaxColumn` **전 컬럼** | 조회 결과 바인딩 직후 | 잠금 (조회 결과는 기본 읽기전용) | 활성 |
| 49 | `InsertRow` | 2052 | `DIVISION_ID` 셀 | 신규행 각 Measure 행 | 잠금 | 활성 |
| 50 | `InsertRow` | 2068 | `DEPT_ID` 셀 | — | 해제 예정이었음 | **주석** |
| 51 | `InsertRow` | 2076 | `DIVISION_ID+1 ~ MEASURE` | 신규행 | **해제** | 활성 |
| 52 | `InsertRow` | 2081 | `PROJECT_STATUS` 셀 (40) | — | 잠금 예정이었음 | **주석** |
| 53 | `InsertRow` | 2090 | `PROJECT_NAME` 셀 | Division≠40 & 열 존재 | 잠금 | 활성 |
| 54 | `InsertRow` | 2092 | `PROJECT_STATUS` 셀 | 동일 | 잠금 | 활성 |
| 55 | `InsertRow` | 2094 | `BIZ_TYPE_NAME` 셀 | 동일 | 잠금 | 활성 |
| 56 | `InsertRow` | 2098 | `ITEM_ID` 셀 | — | 잠금 예정이었음 | **주석** |
| 57 | `InsertRow` | 2100 | `ITEM_CLASS_NAME` 셀 | 열 존재 | 잠금 | 활성 |
| 58 | `InsertRow` | 2102 | `ITEM_NAME` 셀 | 열 존재 | 잠금 | 활성 |
| 59 | `InsertRow` | 2104 | `MEASURE` 셀 | 열 존재 | 잠금 | 활성 |
| 60 | `InsertRow` | 2106 | `NICK_NAME` 셀 | 열 존재 | 잠금 | 활성 |
| 61 | `InsertRow` | 2110 | `MEASURE ~ MaxColumn` | Measure LOOKUP_CODE ≠ "LOC" | 잠금 (**LOC 행만 값 입력 가능**) | 활성 |
| 62 | `InsertRow` | 2142 | `MEASURE ~ iResultCol` | — | 과거구간 잠금 예정이었음 | **주석** |
| 63 | `InsertRow` | 2165 | `MEASURE ~ W_{전주}` | LOC 행 & (조건문 2151 주석 → **무조건**) | 잠금 | 활성 |
| 64 | `InsertRow` | 2175 | `PRICE_EXIST` 셀 | 신규행 각 Measure 행 | 잠금 | 활성 |
| 65 | `spdMain_ComboSelChange` | 2661 | `PLANT_SITE_ID` 셀 | 셀 Division 앞2자리 ≠ "81" | 잠금 | 활성 |
| 66 | `spdMain_ComboSelChange` | 2663 | `PLANT_SITE_ID` 셀 | 셀 Division 앞2자리 == "81" | **해제** | 활성 |

### §6-B Lock **상태 게이트**(IsLock / IsLockCell / 잠금색 판정) 전수 (18건 — 활성 15 / 주석 3)

| # | 위치 | 라인 | 판정 | 게이트 동작 | 활성/주석 |
|---:|---|---|---|---|---|
| 1 | `cboBucketType_SelectedIndexChanged` | 564 | `!IsLock` (편집중) | `EditButton()` 2회 호출로 편집모드 재적용 | 활성 |
| 2 | `EditButton` | 976 | `!IsLock` | Weekly 과거주차 컬럼만 선택 잠금 | 활성 |
| 3 | `EditButton` | 998 | `!IsLock` | Monthly 과거월 컬럼만 선택 잠금 | 활성 |
| 4 | `EditButton` | 1188 | `!IsLock` | LOC 행 CURRENCY 해제 허용 | 활성 |
| 5 | `SaveData` | 1558 | `IsLock == false` | **편집모드일 때만 저장 로직 진입** | 활성 |
| 6 | `InsertRow` | 1985 | `IsLock == false` | 편집모드일 때만 행 추가 | 활성 |
| 7 | `btnSavePricePeriod_Click` | 2364 | `IsEditMode()==false` | return 예정이었음 | **주석** |
| 8 | `btnSavePricePeriod_Click` | 2366–2371 | `!IsLock`(=편집중) | **MSG00408 후 return** — 편집모드에서는 일괄입력 불가 | 활성 |
| 9 | `btnExchangeRate_Click` | 2399 | `IsEditMode()==false` | return 예정이었음 | **주석** |
| 10 | `btnExchangeRate_Click` | 2401–2406 | `!IsLock` | **MSG00142 후 return** | 활성 |
| 11 | `spdMain_ComboSelChange` | 2605 | `IsLock == false` | 편집중일 때만 콤보 cascade 수행 | 활성 |
| 12 | `Dsdm_Changed` | 2976 | `!IsEditMode()` | return 예정이었음 | **주석** |
| 13 | `Dsdm_Changed` | 2980–2981 | `IsLock == true` | **즉시 return** (읽기전용 시 값변경 이벤트 무시) | 활성 |
| 14 | `Dsdm_Changed` | 2992–2993 | `e.Column < 0 \|\| e.Row < 0` | return (음수 인덱스 방어 — 주석에 InitSpread 오류 사유 명시) | 활성 |
| 15 | `Dsdm_Changed` | 2994–2995 | `IsLockCell(e.Row, e.Column)` | **잠긴 셀이면 환산 전파 안 함** | 활성 |
| 16 | `SetExchangeValues` | 3113 | `GetBGColor == Color.Empty` 또는 `== ControlColor.UnLockColor` | **잠금 배경색이 아닐 때만** 값 배분 수행 | 활성 |
| 17 | `spdMain_CellDoubleClick` | 3218–3221 | `IsLock` (읽기전용) | 빈 블록 → 아무 동작 없음(팝업 미호출) | 활성 |
| 18 | `spdMain_CellDoubleClick` / `Raw_CellClick` | 3224 / 3704 | `IsLock` 또는 Action≠'I' → return / `!IsLock` 일 때만 진행 | 신규행에서만 Project·Item 팝업 / 편집중일 때만 콤보 재바인딩 | 활성 |

### §6-C 편집 **진입 차단** 게이트 (7건 — 전부 활성)

| # | 위치 | 라인 | 조건 | 차단 메시지 |
|---:|---|---|---|---|
| 1 | `InsertButton` | 839 | `!isCurVersion` | (무메시지) return |
| 2 | `EditButton` | 864 | `!isCurVersion` | (무메시지) return |
| 3 | `EditButton` | 866 | `this.fps == null` | 전체 편집 로직 skip |
| 4 | `EditButton` | 870–878 | `DM_UI_EDITABLE_DIVISION.EDIT_YN == 'N'` | **MSG00448** |
| 5 | `EditButton` | 881–941 | Division별 필수컬럼 부재 (40:7 / 81:8 / 82:7) | **MSG00113** |
| 6 | `EditButton` | 945–955 | `PRICE_EXIST` 컬럼 부재 | **MSG00412** (`[PRICE_EXIST] 은 필수 입력사항입니다`) |
| 7 | `DeleteButton` | 848–849 | Action ≠ 'I' | return (**신규행만 삭제 가능**) |

---

## §7 가시성 축 (총 62건)

### §7-A Division 종속 가시성 (18건 — 활성 14 / 주석 4)

| # | 위치 | 라인 | 조건 | 대상 / 동작 | 활성/주석 |
|---:|---|---|---|---|---|
| 1 | `Form_Load` | 205 | 81 | `btnExcelUpload.Visible = btnTemplate.Visible = true` | 활성 |
| 2 | `Form_Load` | 206 | 81 | `layoutControlItem12.Visibility = Always` | 활성 |
| 3 | `Form_Load` | 207 | 81 | `layoutControlItem29.Visibility = Always` | 활성 |
| 4 | `Form_Load` | 211 | 非81 | 두 버튼 `Visible=false` | 활성 |
| 5 | `Form_Load` | 212 | 非81 | `layoutControlItem12.Visibility = Never` | 활성 |
| 6 | `Form_Load` | 213 | 非81 | `layoutControlItem29.Visibility = Never` | 활성 |
| 7 | `InitControls` | 332 | 81/82 | `lblProject.Enabled = true` (→ `umltProject` 활성) | 활성 |
| 8 | `InitControls` | 333 | 81/82 | `lblPlantSite.Enabled = true` (→ `clbPlantSite` 활성) | 활성 |
| 9 | `InitControls` | 334 | 81/82 | `lblBizType.Enabled = true` 예정 | **주석** |
| 10 | `InitControls` | 335 | 81/82 | `layoutControlItem6.Enabled = true` (Project 검색버튼) | 활성 |
| 11 | `InitControls` | 360–363 | 40 | `lblProject`/`lblPlantSite`/`layoutControlItem6` **Enabled=false** | 활성 |
| 12 | `InitControls` | 362 | 40 | `lblBizType.Enabled = false` 예정 | **주석** |
| 13 | `InitControls` | 373 | 42/44 | `lblBizType.Enabled = false` 예정 | **주석** |
| 14 | `InitControls` | 375 | 무조건 | `lblBizType.Enabled = true` | 활성 |
| 15 | `clbDivisions_SelectedIndexChanged` | 2504–2506 | 81/82 | `lblProject.Enabled=true`, `layoutControlItem6.Enabled=true` (⚠ `lblPlantSite` 는 여기서 미설정, #16·#17 에서 결정) | 활성 |
| 16 | `clbDivisions_SelectedIndexChanged` | 2522 | 82 | `lblPlantSite.Enabled = false` | 활성 |
| 17 | `clbDivisions_SelectedIndexChanged` | 2528 | 81 | `lblPlantSite.Enabled = true` | 활성 |
| 18 | `clbDivisions_SelectedIndexChanged` | 2544–2547 / 2581–2589 | 40 / 81 | 40 → Project·PlantSite·검색버튼 비활성 / 81 → Excel 버튼·layout 12·29 표시, 그 외 숨김 | 활성 |

### §7-B 권한/상태 종속 가시성 (8건 — 활성 5 / 주석 3)

| # | 위치 | 라인 | 조건 | 대상 / 동작 | 활성/주석 |
|---:|---|---|---|---|---|
| 1 | `InitControls` | 308 | 82 | `btnSavePricePeriod.Enabled` 토글 예정 | **주석** |
| 2 | `clbDivisions_SelectedIndexChanged` | 2489 | 82 | 동일 토글 예정 | **주석** |
| 3 | `DefineProperty` | 460 | NowGroupID ∈ {ADMIN, DM ADMIN} | `layoutControlItem5.Visibility = Always` | 활성 |
| 4 | `DefineProperty` | 465 | 그 외 | `layoutControlItem5.Visibility = Never` | 활성 |
| 5 | `DefineProperty` | 458–459 / 463–464 | 각 분기 | `btnCutOff.Enabled/Visible` 설정 예정 | **주석**(2행 세트) |
| 6 | `InitControls` | 341 / 345 / 369 | 82 / 81 / 40 | `checkInvalidExec.Enabled` = true / false / false | 활성 |
| 7 | `clbDivisions_SelectedIndexChanged` | 2521 / 2527 / 2549 | 82 / 81 / 40 | 동일 토글 | 활성 |
| 8 | `SaveData` / `DMF0020_SalesFuturePrice_Resize` | 1932 / 3532–3536 | 저장 완료 / Resize | `panel1.Visible = false` / `panel1.Visible==true` 일 때만 중앙 재배치 | 활성 |

### §7-C 컬럼(그리드) 가시성 (10건 — 활성 8 / 주석 2)

| # | 위치 | 라인 | 조건 | 동작 | 활성/주석 |
|---:|---|---|---|---|---|
| 1 | `SetSpreadHeaderSpan` | 630–633 | 컬럼명에 `B_` 포함(IndexOf>0) | `VisibleColumns(iCellCnt, false)` | 활성 |
| 2 | `SetSpreadColumn` | 691 | `D_` 컬럼 | 숨김 예정 | **주석** |
| 3 | `SetSpreadColumn` | 696 | Weekly & `W_` | `Visible = true` | 활성 |
| 4 | `SetSpreadColumn` | 700–701 | Weekly & 그 외 | `Visible=false` + `BackColor=White` | 활성 |
| 5 | `SetSpreadColumn` | 708–709 | Monthly & `W_` | `Visible=false` + White | 활성 |
| 6 | `SetSpreadColumn` | 714 | Monthly & `M_` | `Visible = true` | 활성 |
| 7 | `FindData` | 1497 | — | `VisibleAlternatingRow()` 예정 | **주석** |
| 8 | `spdMain_CellDoubleClick` | 3322 | `M_` 헤더 더블클릭 | 구간 내 `W_` 컬럼 **가시성 반전** | 활성 |
| 9 | `spdMain_CellDoubleClick` | 3325–3326 | `M_` 헤더 더블클릭 | 구간 내 `D_` 컬럼이 보이면 숨김 | 활성 |
| 10 | `spdMain_CellDoubleClick` | 3338 | `W_` 헤더 더블클릭 | 구간 내 `D_` 컬럼 가시성 반전 | 활성 |

### §7-D **LAYER 종속(부모 숨김에 따른 실효 가시성)** — ⚠ 사고 2건 + 설계 상수 (26건)

| # | 위치 | 라인 | 부모(LAYER) 설정 | 자식 코드 설정 | **실효 가시성** |
|---:|---|---|---|---|---|
| 1 | ⚠ `checkInvalidExec` | [D]1362–1368 | `layoutControlItem10.Visibility = **Never**` (Designer 고정) | `.cs` 341/345/369/2521/2527/2549 에서 `Enabled` 를 6곳에서 토글 | **항상 비표시.** 82 사업부 "Price 미등록 제외" 체크박스는 화면에 **나타나지 않음** → `sInvalidExec` 는 사실상 항상 `"N"`(1303행) |
| 2 | ⚠ `btnBatch` | [D]298 / [D]1270–1272 | `btnBatch.Visible=false`, `layoutControlItem5.ContentVisible=false`, `layoutControlItem5.Enabled=false` | `.cs` 460 에서 ADMIN 일 때 `layoutControlItem5.Visibility = Always` | **항상 비표시.** ADMIN 이어도 `ContentVisible=false` + `btnBatch.Visible=false` 가 우선 → `btnBatch_Click`(3458) 은 도달 불가 |
| 3 | `layoutControlItem12` (btnExcelUpload) | [D]1411–1423 | Designer 기본 표시 | `.cs` 206/212/2582/2588 Always/Never | Division 81 일 때만 표시 (정상 동작) |
| 4 | `layoutControlItem29` (btnTemplate) | [D]1425–1433 | Designer 기본 표시 | `.cs` 207/213/2583/2589 | Division 81 일 때만 표시 (정상) |
| 5 | `layoutControlItem6` (Project 검색버튼) | [D]1219–1229 | `TextVisible=false` | `.cs` 335/363/2506/2547 `Enabled` | 표시되나 40 에서는 비활성 |
| 6 | `usrConditionPanel2` | [D]215 / `.cs` 442 | `UsrPanelType = HidePanel` (접기 가능 패널) | `.cs` 442 `Height = 105` | 사용자가 패널 접으면 **하위 24 컨트롤 전체 비표시** |
| 7 | `layoutControlGroup3` | [D]1131 | `TextVisible = false` | — | 그룹 캡션 숨김 |
| 8–19 | 라벨 숨김 12건 | [D]1193, 1229, 1266, 1280, 1306, 1333, 1358, 1367, 1382, 1409, 1423, 1433 | `TextVisible = false` | — | 각 LayoutControlItem 의 텍스트(라벨) 비표시 (버튼·체크박스 전용 아이템) |
| 20 | `panel1` (진행률) | [D]1443 | `Visible = false` | `.cs` 1932 저장 후 false | 기본 비표시 |
| 21 | `usrLayoutControl1` / `layoutControlGroup1` | [D]135–149 | 폼에 `Controls.Add` **되지 않음**([D]1480–1482 는 panel1/spdMain/usrConditionPanel2 만 추가) | — | **미사용 컨트롤** (화면에 존재하지 않음) |
| 22 | `spdMain_Sheet1` | [D]169–205 | `Reset()` 후 기본 시트 | `.cs` 543 `AddSheet(spdMain, "Sales Price", ...)` 로 대체 | 실제 사용 시트는 "Sales Price" 1개 |
| 23–26 | 조회조건 아이템 위치 고정 | [D]1136–1431 | `MaxSize`/`MinSize` = 동일값으로 **크기 고정** (`Period` 263×24, `layoutControlItem4` 44×30, `lblBucket` 136×25, `layoutControlItem11` 140×29 등 4건) | — | 리사이즈 시에도 폭 고정 |

---

## §8 필수값 축 (총 34건)

### §8-A 조회(FindData) 진입 필수 (4건 — 전부 활성)

| # | 라인 | 조건 | 메시지 | 결과 |
|---:|---|---|---|---|
| 1 | 1277–1281 | `blnWork == true` (직전 작업 진행 중) | **MSG00137** | 조회 차단 |
| 2 | 1284–1288 | `txtVersion.Text.Trim() == ""` | **MSG00283** ("Version을 선택하고 조회하세요") | 조회 차단 |
| 3 | 1305–1309 | 기간 From > To | **MSG00108** | 조회 차단 |
| 4 | 1325–1329 | `p_division_id == ""` | **MSG00097** | 조회 차단 |

### §8-B 편집(Edit) 진입 필수 — **축별(Division별) 상이** (6건)

| # | 라인 | 축 | 필수 컬럼 세트 | 메시지 | 활성/주석 |
|---:|---|---|---|---|---|
| 1 | 881–895 | **Division 40** | `END_CUSTOMER40`, `SCM_SITE_ID`, `ITEM_ID`, `INCOTERMS`, `FCST_TYPE`, `DOM_EXP`, `CURRENCY` (**7종**) | MSG00113 | 활성 |
| 2 | 896–910 | Division 42/44 | `DEPT_ID`, `END_CUSTOMER40`, `SCM_SITE_ID`, `ITEM_ID`, `INCOTERMS`, `FCST_TYPE`, `CURRENCY` (7종) | MSG00113 | **주석** |
| 3 | 911–926 | **Division 81계열** | `SCM_SITE_ID`, `PROJECT_CODE`, `ITEM_ID`, `INCOTERMS`, `FCST_TYPE`, `DOM_EXP`, `CURRENCY`, **`PLANT_SITE_ID`** (**8종**) | MSG00113 | 활성 |
| 4 | 927–941 | **Division 82** | `SCM_SITE_ID`, `PROJECT_CODE`, `ITEM_ID`, `INCOTERMS`, `FCST_TYPE`, `DOM_EXP`, `CURRENCY` (**7종**) | MSG00113 | 활성 |
| 5 | 944–956 | **전 Division 공통** | `PRICE_EXIST` (**1종**) | MSG00412 | 활성 ([E20240903-000738]) |
| 6 | 870–878 | **전 Division 공통** | 룩업 `DM_UI_EDITABLE_DIVISION.EDIT_YN` ≠ 'N' | MSG00448 | 활성 ([PJ2025-50017]) |

### §8-C 저장(SaveData) 필수값 — action=='I' 행 대상, 4배수 첫 행 기준 (10건 — 전부 활성)

> 검증 루프: 1566–1706. 위반 시 **MSG00002** (`[{0}] 은 필수 입력사항입니다`) + `SetActiveCell(i, 2)` 로 포커스 이동 후 return.
> ⚠ 메시지 조립은 `else if` 체인(1647–1676)이므로 **누락 항목이 여러 개여도 첫 1건만 표기**됨.

| # | 라인(검증/메시지) | 필드 | 값 소스 | 누락 라벨 | Division 조건 |
|---:|---|---|---|---|---|
| 1 | 1634 / 1647–1648 | `sDIVISION_ID` | 셀 `DIVISION_ID` (1601–1602) | `[Division]` | 전체 |
| 2 | 1635 / 1649–1659 | `sPROJECT_CODE` | 40 → `END_CUSTOMER40` / 81·82 → `PROJECT_CODE` (1606–1613) | 40:`[End Customer]` / 81·82:`[Project Code]` | 전체 |
| 3 | 1636 / 1660–1661 | `sSCM_SITE_ID` | 셀 `SCM_SITE_ID` | `[Sales Site]]` (⚠ 대괄호 오타 원문 그대로) | 전체 |
| 4 | 1637 / 1674–1676 | `p_plant_site_id` | 셀 `PLANT_SITE_ID` | `[Plant Site]` | **81계열만** ([C20210330-000045]) |
| 5 | 1638 / 1662–1663 | `sITEM_ID` | 셀 `ITEM_ID` (Text) | `[Model]` | 전체 |
| 6 | 1639 / 1664–1665 | `sCURRENCY` | 셀 `CURRENCY` (Text) | `[Currency]` | 전체 |
| 7 | 1640 / 1666–1667 | `sMEASURE` | 셀 `MEASURE` | `[Measure]` | 전체 |
| 8 | 1641 / 1668–1669 | `sDomExp` | `CurrentDataRow` 의 `DOM_EXP` | `[Customs Handbook]` | 전체 |
| 9 | 1642 / 1670–1671 | `sFcstType` | `CurrentDataRow` 의 `FCST_TYPE` | `[FCST Type]` | 전체 |
| 10 | 1643 / 1672–1673 | `sINCOTERMS` | `CurrentDataRow` 의 `INCOTERMS` | `[Incoterms]` | 전체 |

### §8-D 중복(Unique) 검증 — `fnValidation` (4건)

| # | 라인 | 축 | 중복 판정 키 | 메시지 | 활성/주석 |
|---:|---|---|---|---|---|
| 1 | 2269–2285 | **81계열** | DIVISION_ID + PROJECT_CODE + SCM_SITE_ID + ITEM_ID + DOM_EXP + FCST_TYPE + INCOTERMS + CURRENCY + MEASURE + **PLANT_SITE_ID** (**10키**) | MSG00043 | 활성 |
| 2 | 2286–2301 | **82** | 위 10키에서 PLANT_SITE_ID 제외 (**9키**) | MSG00043 | 활성 |
| 3 | 2302–2315 | 42/44 | DIVISION_ID + SCM_SITE_ID + ITEM_ID + FCST_TYPE + INCOTERMS + CURRENCY + MEASURE (7키) | MSG00043 | **주석** |
| 4 | 2316–2331 | **40(else)** | PROJECT_CODE 자리에 **`END_CUSTOMER40`** 을 사용한 **9키** | MSG00043 | 활성 |

### §8-E 저장 이후·기타 필수/제약 (10건 — 전부 활성)

| # | 위치 | 라인 | 조건 | 메시지 / 동작 |
|---:|---|---|---|---|
| 1 | `SaveData` | 1549–1553 | `blnWork == true` | MSG00137 → 저장 차단 |
| 2 | `SaveData` | 1871–1892 | `nvc["p_PRICE"]` 자체가 **null/empty** (=변경된 가격 셀 0건) | **MSG00414**(SalesSite, ProjectName라벨, ProjectCode, ItemId 4인자) 후 return — 40:"END CUSTOMER" / 그 외:"PROJECT_CODE" |
| 3 | `SaveData` | 1824–1825 | 셀 값이 `""` | `sPRICE = "0"` 으로 보정 후 전송 |
| 4 | `SaveData` | 1914–1926 | SP 결과 `Tables[0][0][0] != "success"` | 전 컬럼 연결한 에러 문자열 MessageBox → return |
| 5 | `SaveData` | 1928–1929 | `Tables[3][0][0] != ""` | 부분 오류 MessageBox (저장은 계속) |
| 6 | `SaveData` | 1931–1933 | 정상 완료 | **MSG00004** (`{iCUD_Total}` 건 저장) |
| 7 | `SaveData` | 1938–1946 | `Tables[2].Rows.Count > 0` | **Range Rate 초과 팝업** `DMF0020_SalesPriceRangePopUp` ([PJ20200138]) |
| 8 | `cboBucketType_Click` | 3817–3827 | 그리드에 Action=='I' 행 존재 | **MSG00227** → 버킷 변경 차단 |
| 9 | `spdMain_CellClick` | 3686–3691 | 클릭열==`CURRENCY` AND Action ≠ 'I' | **MSG00447** (기간 확인 안내 — 차단은 아님) |
| 10 | `btnExcelUpload_Click` | 3943–3946 | 업로드 폼 종료 후 | **MSG00265** Yes 시 `FindData(true)` 재조회 |

> §8 총계: A 4 + B 6 + C 10 + D 4 + E 10 = **34건** (주석 2건 = B#2, D#3).

---

## 부록 A. 판정식·상수 정의

### A-1. Division 판정식 3종

| 기호 | 코드 표현 | 의미 | 사용처(대표) |
|---|---|---|---|
| **A** | `clbDivisions.ControlValues.Substring(0, 2) == "81"` | 콤보의 **원시 선택값** 문자열 앞 2자리 비교. `ControlValues` 는 UsrCombo 의 현재 값(단일 선택, `DropDownStyle=DropDownList` [D]730)이며 초기값은 `"ALL"`([D]444). 앞 2자리만 비교하므로 `81`, `811`, `812` 등 **81 하위 코드 전부** 포함 | 203, 911, 2231, 2261, 2269, 2579, 3080, 3089, 3707 |
| **B** | `CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues)` 결과 `sDivision` 에 대해 `Substring(0,2)=="81"` / `=="82"` | 콤보 원시값(`ALL` 포함)을 `dtDivision`(SP `MyDivision` 결과) 과 대조하여 **실제 코드 목록**으로 환산한 뒤 비교 | 306→320, 385, 2480→2491, 2508, 3657 |
| **C** | 그리드 셀 `DIVISION_ID` 값에 대해 `=="40"` / `Substring(0,2)=="81"` / `=="82"` | **행 단위** 분기. 조회 결과 각 행이 서로 다른 Division 일 수 있으므로 저장/검증은 C 를 사용 | 1606, 1758, 2614, 2685, 3229, 3709 |

> ⚠ **A/B/C 혼용 주의**: 같은 기능이라도 위치에 따라 판정 소스가 다름. 예) `fnValidation`(2231) 은 **A**, `SaveData`(1758) 는 **C** → ALL 로 조회한 뒤 여러 Division 행을 동시에 저장하면 중복검증(A 기준)과 저장(C 기준)의 키셋이 어긋날 수 있음.
> ⚠ `Substring(0, 2)` 는 값 길이가 2 미만이면 예외. `ControlValues` 초기값 `"ALL"`(3자) 은 `"AL"` 로 평가되어 어느 분기에도 걸리지 않고 else(=40 취급) 로 흐름.

### A-2. Division 코드별 화면 사양 요약

| 항목 | 40 (소형) | 81계열 | 82 (ESS) | 42/44 |
|---|---|---|---|---|
| 대표키 컬럼 | `END_CUSTOMER40` | `PROJECT_CODE` + `PLANT_SITE_ID` | `PROJECT_CODE` | (주석, 미사용) |
| Edit 필수컬럼 | 7종 | 8종 | 7종 | 7종(주석) |
| 중복키 개수 | 9 | 10 | 9 | 7(주석) |
| Project 조회조건 | 비활성 | 활성 | 활성 | — |
| Plant Site 조회조건 | 비활성 | 활성 | **비활성**(2522) | — |
| Price 미등록 제외 체크 | 비활성 | 비활성 | 활성(단 §7-D#1 로 **비표시**) | — |
| Excel Upload/Template | 숨김 | **표시** | 숨김 | — |
| Project 검색 팝업(usrButton1) | 미호출 | 호출 | 호출 | — |
| 편집모드 사용 | **룩업으로 차단**(MSG00448) | 사용 | 사용 | — |
| 마스터 자동완성 RowSpan(4행) | 미적용 | 미적용 | INCOTERMS/FCST_TYPE/DOM_EXP 적용 | — |
| Customs Handbook 콤보 | 신규행에 부착(2012–2013) | 미부착 | 미부착 | — |

### A-3. 컬럼 태그 접두어 규약

| 접두 | 의미 | 처리 |
|---|---|---|
| `W_yyyyMMdd` | 주(Week) 버킷 컬럼, 값은 해당 주 월요일 일자 | Weekly 에서만 표시(696). **저장 대상은 W_ 컬럼만**(1816–1819) |
| `M_yyyyMM` | 월(Month) SUM 컬럼 | Monthly 에서만 표시(714). 입력 시 하위 주차로 배분(3061–3073), 저장 제외 |
| `D_` | 일(Day) 컬럼 | 표시 로직 대부분 주석(691). 헤더 더블클릭 토글에만 잔존(3323, 3337) |
| `B_` | 기준/백업 컬럼 | 헤더 구성 시 무조건 숨김(630–632) |

### A-4. 상수·구조체

| 상수 | 값 | 라인 |
|---|---|---|
| `SpdSheet.shtMain` | `"Sales Price"` | 115 |
| `BucketType.Weekly` / `.Monthly` | `"WEEKLY"` / `"MONTHLY"` | 121–122 |
| `BucketType.Daily` | `"DAILY"` (주석) | 120 |
| `sBinding` | `"GSCM.DM.Master.WSL/FoxDataService.svc"` | 76 |
| `sScmBinding` | `"GSCM.SCM.Master.WSL/FoxDataService.svc"` | 74 |
| `sPlanBinding` | (주석) | 75 |
| Measure 배수 | `dtMeasureCount.Rows.Count` (저장 루프는 **4 고정**) | 1566, 2223 |
| 조회 타임아웃 | 600초 | 1351 |
| 저장 타임아웃 | 5400초 | 1903 |
| Search over range 기간 | From = 이번주 월요일 −7일, To = From +357일 | 3832–3833 |
| 기본 조회기간 | SP `PR_GET_DAY_RANGE` (`p_month = 6`) | 425–426 |

### A-5. 사용 SP 인벤토리 (본 화면 직접 호출분)

| SP | 용도 | 라인 |
|---|---|---|
| `DM.PR_GET_DAY_RANGE` | 기본 조회기간 산정 | 423 |
| `DM.DMF0020_GET_WEEKDATA` | 전주 기준 주차 데이터(잠금 판정) | 498 |
| `DM.DMF0020_GET_MEASURE_COUNTINFO` | Measure 고정 리스트 | 514 |
| `DM.DMF0020_GET_FUTUREPRICE_INFO` | 환율(EXCHANGE_PRICE) 테이블 | 531 |
| `DM.DMF0020_GET_SPREAD_TITLE` | 그리드 컬럼 타이틀(Division 종속) | 3554 |
| `DM.DMF0020_GET_SPREAD_TITLE_DATE` | (미사용 `InitSpread_X` 내) 주차 헤더 | 786 |
| `DM.DMF0020_GET_SCM_MST_FUTURE_PRICE` | 메인 조회 | 1349 |
| `DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL` | 저장 | 1902 |
| `DM.DMF0003_GET_BUCKET_TYPE_CODE` | 버킷 콤보 | 3810 |
| `DM.UP_FX_GetCommonDataList_DM` | 공통 룩업(`DM_CUSTOMS_HANDBOOK` / `INCOTERMS` / `DM_UI_EDITABLE_DIVISION`) | 3883, 3957 |
| `DM.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW` | Batch Job (**§7-D#2 로 도달 불가**) | 3474 |
| `SCM.SCM0001_GET_*` (DIVISION / SITE_BY_DIVISION / SITE_INFO / TEAM / CUSTOMER / LOOKUP_VALUES / PLANT_SITE / BIZ_TYPE) | 보조 조회 — 대부분 **호출처 없는 잔존 메서드** | 3354–3653 |

### A-6. 메시지 ID 인벤토리 (활성 호출 기준)

| MSG ID | 호출 라인 | 상황 |
|---|---|---|
| MSG00002 | 1679 | 저장 필수값 누락 |
| MSG00004 | 1933 | 저장 완료 |
| MSG00043 | 1703 | 저장 중복 |
| MSG00097 | 1327 | Division 미선택 |
| MSG00108 | 1307 | 조회기간 역전 |
| MSG00113 | 892 / 923 / 938 | Edit 필수컬럼 부재 |
| MSG00137 | 1279 / 1551 | 연속 작업 중 |
| MSG00142 | 2404 | 편집모드에서 환율 팝업 불가 |
| MSG00143 | 3493 | Batch Job 결과 (도달 불가) |
| MSG00227 | 3823 | 신규행 존재 시 버킷 변경 불가 |
| MSG00255 | 3913 | 버전 3개 이상 선택 = 읽기전용 |
| MSG00265 | 3943 | Excel 업로드 후 재조회 확인 |
| MSG00283 | 1286 | Version 미선택 |
| MSG00408 | 2369 | 편집모드에서 Price 일괄입력 불가 |
| MSG00412 | 952 | `PRICE_EXIST` 컬럼 부재 |
| MSG00414 | 1890 | 가격 미입력 저장 시도 |
| MSG00447 | 3690 | Currency 변경 기간 안내 |
| MSG00448 | 876 | Division 편집 금지(DMF0082 로 유도) |
| MSG00135 (주석) | 2368 | — |
| MSG00447 (주석) | 2784 | — |

---

## 부록 B. 실측 중 발견된 잠재결함 (참고, 6건)

| # | 위치 | 라인 | 내용 |
|---:|---|---|---|
| 1 | `SaveData` | 1597–1598 | `sDIVISION_ID == "82"` 비교 시점에 변수가 아직 `""` (대입은 1601–1602) → **82 NewFlag RowSpan 보정이 1차 검증 루프에서 동작하지 않음** |
| 2 | `SetExchangeValues` | 3129–3143 | `Dsdm_Changed`(3033)·`ComboSelChange`(2859) 에 있는 `RTF_SYS_RP` 제외가 **누락** → 월 SUM 배분 시 RTF 행에도 환산값이 기록될 수 있음 |
| 3 | `FindData` | 1305–1309 | 기간 역전 return 시 `blnWork = true` 인 채로 종료(1291 에서 설정, `finally` 1530–1535 가 복구하므로 실제 잠김은 없음 — 단 `prg.Show()` 이전이라 진행바 영향은 없음). 반면 1325–1329 의 Division 미선택 return 도 동일 경로 |
| 4 | `fnValidation` | 2241–2245 | else 분기에서 `sDivision = "40"` **하드코딩** → 42/44 등 타 코드가 40 으로 비교됨 |
| 5 | `spdMain_ComboSelChange` | 2719–2725 | `END_CUSTOMER` 변경 분기에서 `sDivision` 이 초기값 `CAppSetting.StringALL` 인 채로 `UserSiteByEndCustomerAuth` 호출 (셀 DIVISION_ID 재취득 없음) |
| 6 | `clbDivisions_SelectedIndexChanged` | 2499–2500 | `GetBizTypebyDivision`(구방식)과 `SetChangeControl("BizType", ...)`(신방식)이 **연속 2회 호출** → 불필요한 왕복 1회 |

---

*작성: 2026-07-27 / 원천 실측 라인 수 5,567행 (`.cs` 3,969 + `.Designer.cs` 1,598) / hook #105 §1-C 0단계 준수*
