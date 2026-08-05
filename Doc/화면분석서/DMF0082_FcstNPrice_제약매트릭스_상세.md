# DMF0082 Fcst&Price MGMT — 제약매트릭스 상세 (전수 실측)

> **원천 소스 (전체 Read 후 전수 스캔, 2026-07-20)**
> - 메인: `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.cs` (9,418행)
> - 팝업: `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0082_SaveSalesFuturePrice_Popup.cs` (2,826행)
>
> 표의 라인번호는 위 두 파일 기준. **활성 코드만** 본문 표에 수록하고, 주석(비활성) 로직은 §8 "비활성 인벤토리"에 별도 수록.
> 지어내기 금지 원칙에 따라 소스에 없는 항목은 "미존재"로 명기함 (예: MSG00096).

---

## 1. Division 축

화면 자체가 **40(소형) 사업부 고정**이다: Division 콤보 데이터를 `CODE = '40'`으로 필터해 단일 값만 바인딩(342행)하고, 폼 표시 직후 40이면 Bucket을 Weekly로 강제한다(326~332행). 그러나 코드 내부에는 81/82 분기가 **활성 상태로 잔존**한다(도달 불가 또는 콤보/팝업 재사용 경로) — 아래 표에 구분 표기.

### 1.1 활성 Division 분기 전수 (메인 폼)

| # | 위치(함수) | 조건 | 동작 | 라인 |
|---|---|---|---|---|
| D-01 | InitControls | (무조건) | `dtDivision.Select("CODE = '40'")` — Division 목록을 40 단일 고정 | 342 |
| D-02 | OnShown | `sDivision == "40"` | Bucket 콤보를 Weekly로 초기화 | 326~332 |
| D-03 | EditButton | `clbDivision.ControlValues == "40"` | 필수 컬럼 9종(DIVISION/END_CUSTOMER/SCM_SITE/ITEM/DOM_EXP/FCST_TYPE/INCOTERMS/MEASURE/CELL_PROD_SITE_ID) 미존재 시 MSG00113 후 중단 | 1543~1555 |
| D-04 | fnValidation | `clbDivision.ControlValues == "40"` | 신규(I) 행의 Division/EndCustomer/SalesSite/Item 키값 취득 | 2257~2266 |
| D-05 | fnValidation | `clbDivision.ControlValues.Substring(0,2) == "40"` | 중복검사 수행(LOC면 Currency를 유사키로 포함, §3 참조) | 2284~2338 |
| D-06 | InsertRow | `clbDivision.ControlValues.Substring(0,2) == "40"` | ItemId 이미지 셀타입 + Division 값 자동세팅 + DomExp(Customs Handbook) 콤보 | 2536~2553 |
| D-07 | InsertRow | `sDivision == "40"` | 권한 콤보 세팅: EndCustomerByDivision40 / UserSiteByEndCustomer + INCOTERMS(VALID_YN=Y) + FCST_PRICE_EDIT_MEASURE + CELL_PROD_SITE_ID + CURRENCY_LIST | 2577~2632 |
| D-08 | clbCustomer_SelectedIndexChanged | `Substring(0,2)=="81" \|\| =="82"` → SiteByEndCustomer / else(=40) → SiteByEndCustomer40 | Sales Site 재조회 (81/82 경로는 잔존 활성이나 D-01로 인해 실도달은 40 경로) | 3065~3073 |
| D-09 | spdMain_CellDoubleClick | `sDivision=="40" && sMeasure=="MKT_FCST" && BackColor∈{PaleGreen, PapayaWhip}` | `DMF0003_GET_MKT_FCST_COMPARE_POPUP` 호출(기간=당주 월요일~+20일) 후 `DMF0003_SspSyncComparePopUp` 표시 | 3646~3703 |
| D-10 | spdMain_Changed(Validation) | `sDivision.Substring(0,2)=="81" \|\| =="82"` | Project Code 미입력 시 ValidationCheck(잔존) | 5774~5781 |
| D-11 | spdMain_Changed(Validation) | `sDivision == "40"` | End Customer 미입력 시 ValidationCheck(MSG00002 + 셀 클리어) | 5782~5790 |
| D-12 | spdMain_Changed(중복검사) | `clbDivision.ControlValues == "40"` | 신규 I행 8키(EndCustomer/Site/Item/DomExp/FcstType/Incoterms/Measure/CellProdSite) 중복 2건 이상 → MSG00260 + 입력 취소 | 5923~5956 |
| D-13 | spdMain_Changed(else, 키변경) | `clbDivision.ControlValues == "40"` | `sDivision="40"` 고정 후 키 취득 → I행 키 변경 시 수량 전체 클리어 + SetSaveDataRemove | 7559~7613 |
| D-14 | SetSaveData | `sDivision == "40"` | EndCustomer/ScmSiteId/ItemId 빈값이면 저장버퍼 적재 skip(return) | 7661~7678 |
| D-15 | SetSaveData | `(=="40" \|\| 81prefix \|\| =="82") && sDomExp==""` | 적재 skip | 7690~7694 |
| D-16 | SetSaveDataRemove | `sDivision == "40"` | EndCustomer/ScmSiteId/ItemId 빈값이면 제거 skip | 7793~7810 |
| D-17 | spdMain_ComboSelChange(Division 셀) | `clbDivision.ControlValues.Substring(0,2) == "40"` | UserSiteByEndCustomer로 ScmSiteId 콤보 재세팅 | 8235~8239 |
| D-18 | spdMain_ComboSelChange(Division 셀) | `sDivision.Substring(0,2)=="81"` → PlantSite unlock / else → lock | 81 잔존 분기 (40에서는 항상 lock) | 8249~8252 |
| D-19 | fnValidation(LOC Currency 유사키) | `clbDivision.ControlValues.Substring(0,2) == "40"` | LOC면 Currency 일치 여부를 bCurrency로 중복판정에 포함 | 2284~2300 |

### 1.2 division 파라미터 흐름 (활성)

| 대상 | 파라미터 | 라인 |
|---|---|---|
| `DM.DMF0082_GET_SPREAD_TITLE` | `p_division_id = clbDivision.ControlValues` | 443 |
| `DM.DMF0082_GET_MAIN_DATA` | `p_division_id = sDivision` (+ `p_user_group = NowGroupID` 1738) | 1727 |
| `DMF0000_ExchangeRatePopup.LoadData` | 세번째 인자 `clbDivision.ControlValues` | 3143 |
| `DM0002_TitleSetForm_Popup` (Column/Measure) | 네번째 인자 `clbDivision.ControlValues` | 3426, 3439 |
| `DMF0082_SaveSalesFuturePrice_Popup.LoadData` | 첫 인자 `clbDivision.ControlValues` | 3474 |
| `FCST_PRICE_EDIT_MEASURE` 룩업 (PARAM2=division) | Measure 편집콤보 | 2621, 5841, 7922, 8027, 8261, 8308 |
| `CELL_PROD_SITE_ID` 공통룩업 (division, item) | CellProdSite 콤보 | 2625, 5855, 7979, 8001 |
| `SALES_BUCKET` 룩업 (division, site, incoterms) | 행 BUCKET 값 세팅 | 5864, 8312, 8332 |
| `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | BizType 콤보 | 3086~3088, 8246 |
| `DM.DMF0082_SAVE_MAIN_DATA` | `p_division_id`(행별 ^연결) | 2147 |

### 1.3 팝업(SaveSalesFuturePrice) Division 분기 (활성)

| # | 위치 | 조건 | 동작 | 라인 |
|---|---|---|---|---|
| DP-01 | InitControls | `81prefix \|\| =="82"` → Project 라벨 활성 / else(40) → 비활성 + Project 클리어 | 조회조건 활성화 제어 | 273~323 |
| DP-02 | EditButton | `=="40"` | 필수컬럼 8종(END_CUSTOMER40/SCM_SITE/ITEM/INCOTERMS/FCST_TYPE/DOM_EXP/CURRENCY/CELL_PROD_SITE) 검사 → MSG00113 | 836~852 |
| DP-03 | EditButton | `81prefix` | 필수컬럼 8종(PROJECT/PLANT_SITE 포함) 검사 → MSG00113 (잔존) | 868~883 |
| DP-04 | EditButton | `=="82"` | 필수컬럼 7종 검사 → MSG00113 (잔존) | 884~898 |
| DP-05 | EditButton | `=="82" && NEW_FLAG=="Y"` | 키 컬럼 14종 개별 잠금 (잔존, §6) | 990~1022 |
| DP-06 | SaveData | `sDIVISION_ID=="40"` → PROJECT_CODE=END_CUSTOMER40 / `81prefix\|\|82` → PROJECT_CODE | 저장 키 결정 | 1559~1566 |
| DP-07 | SaveData 필수메시지 | `=="40"` → "[End Customer]" / `81prefix\|\|82` → "[Project Code]" | MSG00002 문구 분기 | 1604~1614 |
| DP-08 | fnValidation | `81prefix\|\|82` → DIVISION_ID/PROJECT_CODE 취득, else(40) → sDivision="40" + END_CUSTOMER40 | 중복키 소스 결정 | 2128~2142 |
| DP-09 | fnValidation 중복키 | 81prefix: 10키(+PLANT_SITE) / 82: 9키 / 40: 9키(END_CUSTOMER40) — iRow += 3 (Measure 3행 세트 단위) | MSG00043 중복 판정 | 2158~2227 (루프 2120, 2163) |
| DP-10 | 중복 MSG00043 문구 | `=="40"` → End Customer 축 / else → Project+PLANT_SITE 축 | 1644~1656 |
| DP-11 | usrButton1_Click(Project 팝업) | `SelectedValue != "40"`일 때만 Project 검색팝업 | 2253~2267 |
| DP-12 | clbDivisions_SelectedIndexChanged | 81prefix/82 → Project 활성, else → 비활성 (Division 콤보 자체는 369행 `Enabled=false`로 고정) | 2320~2359, 369 |
| DP-13 | Dsdm_Changed / SetExchangeValues | `81prefix` → PROJECT/ITEM 변경 시 PlantSite 콤보 (⚠ 이벤트 미배선, §8 참조) | 2544~2561 |

---

## 2. 권한 축

| # | 객체/기능 | 권한 조건 | 효과 | 라인 |
|---|---|---|---|---|
| A-01 | 메인 조회 SP | `p_user_group = UserInfoContext.Current["NowGroupID"]` | `DMF0082_GET_MAIN_DATA`가 그룹 권한으로 행/Tables[3] 산출 | 1738 |
| A-02 | Measure 편집권한 로드 | `dsMain.Tables.Count >= 3` → `dsMain.Tables[3]` (GET_ADMIN_GROUP_MEASURE 결과: MEASURE/EDIT_FLAG 행 구조) | `bEDIT_AUTH_SCM_FCST`(9168) / `bEDIT_AUTH_MKT_FCST`(9170) / `bEDIT_AUTH_LOC`(9172) / `bEDIT_AUTH_VMI_IN_REQ`(9174) — `EDIT_FLAG=="Y"` 판정. 구 컬럼구조(`EDIT_AUTH_*` 컬럼) 로딩은 주석화(9148~9164) | 9140~9179 |
| A-03 | DeleteButton — SCM_FCST | `bEDIT_AUTH_SCM_FCST == false` | MSG00464("수정할 수 없는 메져입니다") 후 중단 | 802~806 |
| A-04 | DeleteButton — MKT_FCST | `bEDIT_AUTH_MKT_FCST == false` | MSG00464 후 중단 | 808~812 |
| A-05 | DeleteButton — LOC | `bEDIT_AUTH_LOC == false` | MSG00464 후 중단 | 814~818 |
| A-06 | DeleteButton — VMI_In_Req | `bEDIT_AUTH_VMI_IN_REQ == false` | MSG00464 후 중단 | 820~825 |
| A-07 | SetLockRange — LOC | `!bEDIT_AUTH_LOC` → continue (해당 행 unlock 제외) | Edit 시 편집불가 유지 | 9228~9229 |
| A-08 | SetLockRange — MKT_FCST | `!bEDIT_AUTH_MKT_FCST` → continue | 〃 | 9233~9234 |
| A-09 | SetLockRange — SCM_FCST | `!bEDIT_AUTH_SCM_FCST` → continue | 〃 | 9237~9238 |
| A-10 | SetLockRange — VMI_In_Req | `!bEDIT_AUTH_VMI_IN_REQ` → continue | 〃 | 9242~9243 |
| A-11 | 조회조건/셀 콤보 (그룹권한 스코프) | `NowGroupID + UserId` 파라미터 | EndCustomerByDivision40(2579, 8230, 8277) / UserSiteByEndCustomer(2580, 8237, 8283, 8294) / CURRENCY_LIST(2629, 5628) / SiteByEndCustomer·40(3067, 3071) / UserTeamByDivisionAuth(8217) / UserPlantSiteByDivision(8243) / FCST_TYPE 룩업(8661) / FilterDataSet GROUP_ID(8739~8740) | 좌기 |
| A-12 | 팝업 폼 권한 | `this.IsPopup = true` — "팝업일 경우 권한 체크 패스" | BaseForm 권한검사 우회 | popup 393 |
| A-13 | 팝업 행 권한 | `AUTHORITY_YN != "Y"` && Action 빈값 | MEASURE+1~끝 컬럼 행 잠금 (조회행 편집 차단) | popup 1029~1033 |
| A-14 | 팝업 행 권한 예외 | `AUTHORITY_YN != "Y"` && Action=="I" && IsEditMode | W_ 컬럼 unlock + 키 컬럼 개별 재잠금(§6) + 전주 잠금(1096~1116) | popup 1034~1117 |
| A-15 | 팝업 조회 SP | `p_userinfo = NowGroupID`, `p_created_by = UserId` | `DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP` | popup 1266~1267 |

> **미존재 확인 (본 2개 소스 한정)**: "팝업 ADMIN/DM ADMIN 게이트(MSG00096)"는 본 2개 소스 어디에도 존재하지 않음(`grep MSG00096` 0건).
>
> ⭐ **2026-07-30 정정 — 게이트는 실제로 존재한다.** 위 문장의 "본 문서 범위 밖"(호출되는 다른 팝업)을 후속 작업에서 "부재"로 읽어 **환율 팝업 편집 권한을 5그룹으로 판단한 오판**이 있었다. 원문 재확인 결과:
>
> | 근거 파일 | 위치 | 내용 |
> |---|---|---|
> | `GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0000_ExchangeRatePopup.cs` | `DefineProperty()` **L112~143** | `switch(NowGroupID) { case "ADMIN": case "DM ADMIN": break; default: list.Add(Edit/Insert/Save); btnBPS.Dispose(); }` → **ADMIN·DM ADMIN 외 전 그룹은 Edit/Insert/Save + BPS I/F 버튼 숨김**. 이어서 `if (_division != "40" && list.Count == 0)` → ADMIN 계열도 **Division 40 에서만** 편집 가능. `btnButtonList.Set_ButtonVisibleFalse(list)` (list = 숨길 버튼) |
>
> 게이트 방식은 MSG00096 메시지가 아니라 **버튼 미표시**여서 `grep MSG00096` 로는 잡히지 않는다 — 메시지 검색만으로 권한 게이트 부재를 결론하면 안 된다.
> TO-BE 반영: `futurePriceInfo` 시트 `EDIT`/`IF`/`SAVE` 를 **ADMIN·DM ADMIN 2그룹**으로 정정(2026-07-30 사내 적용, `_artifacts/_apply_corporate/DMF0082_exchange_edit_auth_admin_only_20260730.sql`). **메인 화면(`FcstNPrice`)의 편집 권한 5그룹은 무변경**(사용자 확정).

---

## 3. Measure 축

| # | Measure | 위치 | 제약 | 라인 |
|---|---|---|---|---|
| M-01 | MKT_FCST/VMI_In_Req/SCM_FCST/LOC | DeleteButton | 이 4종만 Delete 로직 진입 허용 (그 외 measure는 무동작) | 799 |
| M-02 | 4종 각각 | DeleteButton | 편집권한 false 시 MSG00464 (§2 A-03~06) | 802~825 |
| M-03 | LOC | SetLockRange | `BucketType.Daily`이면 continue — **Daily 버킷에서 LOC 편집 불가** (2025-08-05) | 9230 |
| M-04 | SCM_FCST | SetLockRange | `sFcstType == "RMA"`이면 continue — **RMA 대상 SCM_FCST 편집 불가** | 9239 |
| M-05 | LOC | SetLockRange(unlock 루프) | 버킷별 편집대상 idx 전부 unlock (Monthly는 당월부터 = list_EDIT_Month 전체) | 9260~9262 |
| M-06 | MKT_FCST/SCM_FCST/VMI_In_Req | SetLockRange(unlock 루프) | Monthly 버킷이면 **M+4 리스트(list_EDIT_Month_M4)에 포함된 월만** unlock; Weekly/Daily는 편집대상 전 idx unlock | 9264~9278 |
| M-07 | 그 외 measure (default) | SetLockRange | 편집대상 아님(switch default → unlock 안함) | 9246~9247, 9280~9281 |
| M-08 | LOC | spdMain_Changed(I행 CURRENCY/MEASURE 변경) | MEASURE=="LOC" → CURRENCY 콤보 = CURRENCY_LIST / 그 외 → NO_DATA(빈 콤보) | 5626~5646 |
| M-09 | LOC vs 기타 | spdMain_Changed(MEASURE 변경) | 행 포맷 스왑: LOC → `###,###,###,##0.000` / 그 외 → `###,###,###,###`; 변경 직전 행 전체 재잠금 + SetLockRange 재적용 | 5648~5658, 5743~5756 |
| M-10 | LOC | fnValidation | Currency를 유사 키로 취급하여 중복검사(bCurrency) | 2286~2300 |
| M-11 | LOC | fnValidation / Validation / SetSaveData | `Currency==""` 이면 필수 위반: bInputCheck2 → MSG00002("Currency")(2334~2337, 2055~2059) / ValidationCheck(5827~5831) / 적재 skip(7710~7714) | 좌기 |
| M-12 | LOC | SetSaveData 필터 | LOC만 dtSave 중복판정 필터에 CURRENCY 포함(15키), 그 외 14키 | 7717~7749 |
| M-13 | LOC | spdMain_Changed 버킷결정 | LOC이면 `strBucket = "0100000"`(월요일) 강제 | 6009~6012 |
| M-14 | MKT_FCST/VMI_In_Req/SCM_FCST | spdMain_Changed(Daily 수정) | 일/주/월 합계 산출 시 소수점 절사(정수화), 0 → 빈칸 표시 | 6094~6103, 6111~6119, 6154~6163, 6171~6179 |
| M-15 | 비LOC | spdMain_Changed(Weekly 수정) | 주 입력값 반올림 0자리 후 버킷요일 분배(마지막 버킷요일에 잔량); 버킷요일 없으면 주 마지막 일자에 전량 | 6555~6634 (반올림 6557) |
| M-16 | LOC | spdMain_Changed(Weekly 수정) | **매달 1일 또는 버킷요일(월요일)에만 값 기입**, 그 외 일자는 클리어+0 적재 | 6656~6685 |
| M-17 | LOC | spdMain_Changed(Weekly 수정 후 Monthly 합) | **Monthly 표시값 = 주값 합 ÷ 값있는 주 수 (평균)**; 비LOC는 단순 합 | 6704~6741 (평균 6716~6728) |
| M-18 | 비LOC vs LOC | spdMain_Changed(Monthly 수정) | 비LOC: 반올림 0자리(7130~7133) / LOC: 입력값 그대로(7134~7137) | 7122~7138 |
| M-19 | 비LOC | spdMain_Changed(Monthly 수정) | 월수량 일별 배분: `Truncate(월합/MONTH_DAY_CNT)*WEEK_DAY_CNT` → 주차별, 주 내 버킷요일 분배, 잔량은 마지막 버킷 주차에 가산 (dtCalendarDetail 사용) | 7205~7279, 7315~7368 |
| M-20 | LOC | spdMain_Changed(Monthly 수정) | **매달 1일 또는 월요일(버킷요일) 셀에 월값 그대로 기입**, 그 외 클리어 | 7284~7313 |
| M-21 | LOC/POINT3 vs INTEGER | Draw()(조회 직후 NOTATION 스왑) | `MEASURE=="LOC" \|\| NOTATION=="POINT3"` → 기본 3자리 유지(skip); `NOTATION=="INTEGER"` → 행 전체 `###,###,###,###`; `POINT3` → `##0.000` (rNotation은 Tables[0]의 NOTATION 컬럼) | 1883~1924 (skip 1888, INTEGER 1912, POINT3 1918) |
| M-22 | MKT_FCST | InsertRow(포커스 행 없음) | 신규 행 Measure 기본값 "MKT_FCST" | 2670~2676 |
| M-23 | MKT_FCST | spdMain_CellDoubleClick | 동기수량 비교 팝업 게이트(§1 D-09) | 3646~3703 |
| M-24 | (편집 measure 목록) | FCST_PRICE_EDIT_MEASURE 룩업 | Insert/키변경/붙여넣기/콤보변경 시 Measure 콤보를 division+site+bucket으로 재조회 | 2621, 5841, 7922, 8027, 8261, 8308 |
| M-25 | KRW / USD | 팝업 EditButton | `sMeasure.ToUpper()=="KRW"` 또는 `"USD"` → MEASURE+1~끝 행 잠금 (**LOC 행만 입력, 파생행 잠금**) | popup 1122~1131 |

---

## 4. 기간·버킷 축

| # | 규칙 | 조건 | 대상 | 라인 |
|---|---|---|---|---|
| P-01 | 실적 cutoff = 금주 월요일 | `DateTime.Today.AddDays(Monday - DayOfWeek)` → `sResultYYYYMMDD` | 전 잠금/색상/편집리스트 기준 | 546~547 (SetSpreadColumn), 2679~2680 (InsertRow), 7183~7184 (Monthly 배분), 3666~3668 (비교팝업 기간) |
| P-02 | 실적 판별 컬럼 인덱스 | `D_ < 금주월요일` → iResultCol / `M_ == 당월` → iResultMonth / 당주 W_ 중복 count | Draw() 조회 직후 | 1946~1956 |
| P-03 | 과거(실적) 회색 | `iResultCol > iStartCol` | `SetBGColor(..., Color.Gainsboro)`; 당월 컬럼은 White 복원(과거만 조회 시 White 오표기 방지 가드 1964) | 1958~1968 (Draw), 1588~1598 (EditButton: SetBGColor2 + this_YYYYMM White) |
| P-04 | 당주 녹색 보더(Weekly/Monthly) | `count >= 2`(동일 주차명 복수) && 조회시작 > 금주월요일 → this_YYYYMMWW / else → `W_당월+iso_week`; 단일이면 this_YYYYMMWW | BevelBorder(Green,3) | 1971~2011 (Draw), 2687~2730 (InsertRow), 3283~3339 (버킷전환) |
| P-05 | 당일 녹색 보더(Daily) | `D_금주월요일` 컬럼 존재 시 | 〃 (전환 시 W_ 보더 Reset) | 2013~2017, 2731~2733, 3288~3293, 3337~3338 |
| P-06 | 편집 시작 — Month | `당월(this_YYYYMM) <= M_컬럼` → list_EDIT_Month | Monthly unlock 후보 | 9080~9087 |
| P-07 | 편집 시작 — M+4(FCST 3메저) | `M_컬럼 > dtWeek.Rows[0]["MONTH_NAME"]` → list_EDIT_Month_M4 (SP가 내려주는 기준월 초과분; MKT/SCM_FCST·VMI_In_Req는 Monthly에서 이 리스트만 unlock) | 〃 | 9089~9093 + 9267~9273 |
| P-08 | 편집 시작 — Week(당주) | 당주 컬럼(this_YYYYMMWW) 존재 && `idx >= 당주컬럼` → list_EDIT_Week | Weekly unlock 후보 | 9112~9115 |
| P-09 | 12월 마지막주 W01+ 보정 | else: `Period 시작월 >= 당주월` 이면 당주컬럼 이후 W_ 전부 추가 (E20251202-000637 — 12월 W01 구간 활성화; 구 로직 `당주YYYYMMWW <= W_` 비교는 주석 9100~9111) | 〃 | 9116~9125 |
| P-10 | 편집 시작 — Day(금주 월요일) | `sResultYYYYMMDD <= D_컬럼` → list_EDIT_Day | Daily unlock 후보 | 9128~9137 |
| P-11 | 당주/당월 식별자 산출 | Tables[1].ISO_WEEK → this_YYYYMMWW/this_YYYYMM(가), Tables[2].THIS_YYYYMMWW·ISO_WEEK(확정) | Draw() | 1801~1804, 1817~1821 |
| P-12 | 버킷별 컬럼 표시 | Daily: D_·W_ 표시, M_·W_는 chkSum 연동 / Weekly: D_ 숨김·W_ 표시·M_ chkSum / Monthly: D_·W_ 숨김·M_ 표시 | SetSpreadColumn | 550~580 (Sum on/off 557~572; chkSum 이벤트 9046~9052) |
| P-13 | 당월/당주 헤더 강조 | M_==당월 또는 W_==당주 → ForeColor Green + Bold | 〃 | 582~607 |
| P-14 | 버킷 전환 시 Lock 복원 | Edit 상태(`!IsLock`)면: 이벤트 해제 → **이전 버킷(sBfBucket)으로 되돌려 EditButton() 실행(unlock 컬럼 재잠금)** → 새 버킷 적용 → 표시/보더 재설정 → 다시 EditButton()으로 Edit 복귀 | cboBucketType_SelectedIndexChanged | 3248~3359 (복원 3256~3276, 재진입 3344~3349) |
| P-15 | Insert 행 존재 시 버킷 변경 차단 | 어떤 행이든 Action=="I" | MSG00227 후 return | 3361~3371 (cboBucketType_Click) |
| P-16 | 기간 역전 금지 | `sPeriod[0] > sPeriod[1]` | MSG00108 | 1691~1697 |
| P-17 | 기간 3년 초과 금지 | `Value1+3년 < Value2` | MSG00164 + Value2 = Value1+2년 보정 | 1699~1706 |
| P-18 | Version 미선택 금지 / Current만 수정 | `txtVersion==""` → MSG00283; `=="Current"` → isCurVersion=true; Insert/Edit는 isCurVersion 아닐 시 즉시 return | 1680~1684, 1775~1779, 681, 1534 |
| P-19 | 헤더 더블클릭 접기/펼치기 | M_ 헤더 → 하위 W_ 토글(D_는 접기만) / W_ 헤더 → 하위 D_ 토글 | spdMain_CellDoubleClick(ColumnHeader) | 3536~3575 |
| P-20 | Delete 시 실적구간 보호 | `D_금주월요일 컬럼index > iCol` → continue (실적 일자 미변경) + list_EDIT_Day 비면 Delete 자체 중단 | DeleteButton | 876~882, 728~731 |
| P-21 | Monthly 배분 실적 pass | `금주월요일 > D_` → continue (배분 제외) | spdMain_Changed(Monthly) | 7195~7201 |
| P-22 | 캘린더 기반 배분 | dtWeek=Tables[1], dtCalendarDetail=Tables[4] (MONTH_DAY_CNT/WEEK_DAY_CNT/BASIS_YYYYMMDD) | 조회 시 적재 | 1747~1752, 7222~7227 |
| P-23 | 기본 버킷요일 | 행 BUCKET 빈값/"0000000" → DEFAULT_BUCKET_DAY 룩업(sDefaultDay, 조회 시 1773) 요일 비트 변환(default 월요일) | spdMain_Changed | 6024~6059 |
| P-24 | 조회기간 기본값 | PR_GET_DAY_RANGE p_month=6 (13→6개월 축소) | drpPeriod 초기값 | 361, 3097~3111 |

---

## 5. FCST_TYPE 축

| # | 위치 | 조건 | 동작 | 라인 |
|---|---|---|---|---|
| F-01 | SetLockRange | `sMeasure=="SCM_FCST" && sFcstType=="RMA"` | continue — RMA 행 SCM_FCST 편집 불가 (활성 유일의 RMA 게이트) | 9237~9240 |
| F-02 | FindData(캐시) | 조회 성공 시 | `dtWarrType = GetFcstType()` — FCST_TYPE 룩업(NowGroupID 파라미터) 전역 캐시(속도개선) | 1766, 8653~8669 |
| F-03 | InsertRow | 신규 행 | FcstType 셀 콤보 = dtWarrType | 2571~2572 |
| F-04 | spdMain_Changed(Validation) | `FcstType==""` | ValidationCheck("FCST Type") — MSG00002 + 셀 클리어 | 5807~5811 |
| F-05 | SetSaveData / SetSaveDataRemove | `sFcstType==""` | 적재/제거 skip | 7685~7689, 7817~7821 |
| F-06 | 저장 SP | `p_fcst_type` ^연결 전달 | DMF0082_SAVE_MAIN_DATA | 2093, 2112, 2153 |
| F-07 | 비교팝업 SP | `p_fcst_type` 전달 | DMF0003_GET_MKT_FCST_COMPARE_POPUP | 3682 |
| F-08 | 중복/필터 키 | FCST_TYPE 포함 | fnValidation(2307), I행 중복(5937~5938), dtSave 필터(7726, 7743, 7845) | 좌기 |
| F-09 | 팝업 콤보 | `GetLookupValues("SALES_TYPE_CODE")` | dtFcstType (팝업 FcstType 소스) | popup 347 |
| F-10 | 팝업 저장 | FCST_TYPE 필수(1596, 1625~1626) + 중복키 포함(2150, 2171~2172, 2188~2189, 2218~2219) + `p_fcst_type` 전달(1713~1714, 1770) | popup 좌기 |

> 비활성 RMA 로직: 구 spdMain_Changed의 "40 && (MKT_FCST\|SCM_FCST) && FcstType != RMA → PaleGreen 동기합 하한(iWkSum_Sync) 강제" 블록은 두 곳 모두 주석(4439~4472, 6222~6256). 구 EditButton의 "RMA면 bEDIT_AUTH_SCM_FCST=false" 블록도 주석(1239~1247). 팝업의 "RTF/RTF_SYS_RP 저장 제외"도 주석(1907~1912). — §8 참조.

---

## 6. 잠금(Lock) 전수 — 활성 호출 1건 1행

### 6.1 메인 폼 (직접 Lock 호출 10 + SetLockRange 진입 3 + Insert() 속성 1)

| # | 호출 | 범위/의미 | 라인 |
|---|---|---|---|
| L-01 | `LockColumn2(xCol1+1, 마지막, true)` | EditButton — Edit 해제 시 Action 이후 전 컬럼 잠금(+SetLockFlag true 1581) | 1579 |
| L-02 | `SetLockRange(0, maxRow, !IsEditMode)` | EditButton — 전 행 편집가능 셀 unlock/lock 일괄 | 1600 |
| L-03 | `LockColumn(0, maxCol, true)` | Draw() — 조회 직후 전 컬럼 잠금(조회모드 기본) | 1812 |
| L-04 | `LockRange2(iActRow, col, iRowCount, col, false, MarkedForeColor, UnLockColor)` ×9컬럼 루프 | InsertRow — 편집키 9컬럼(Customer/ScmSite/Item/Incoterms/FcstType/DomExp/CellProdSite/Currency/Measure)만 unlock | 2744~2752 (호출 2751) |
| L-05 | `SetLockRange(iActRow, iActRow, false)` | InsertRow — 신규 행 계획구간 unlock | 2855 |
| L-06 | `LockRange2(e.Row, MEASURE+1, e.Row, maxCol, true, true)` | spdMain_Changed — MEASURE 변경 시 행 전체 선(先)잠금 | 5657 |
| L-07 | `SetLockRange(e.Row, e.Row, false)` | spdMain_Changed — 변경된 Measure 기준 재-unlock | 5658 |
| L-08 | `LockRange(ActiveRow, PlantSiteId.., false)` | ComboSelChange Division — 81 prefix면 PlantSite unlock (잔존) | 8250 |
| L-09 | `LockRange(ActiveRow, PlantSiteId.., true)` | ComboSelChange Division — 그 외(40) PlantSite 잠금 | 8252 |
| L-10 | `LockRange2(iRow, MEASURE+1, iRow, maxCol, true, true)` | SetLockRange — Insert 행 선잠금(Monthly M+3 이전 잠금 목적) | 9251~9254 |
| L-11 | `LockRange2(iRow, idx, iRow, idx, bLockFlag, true)` | SetLockRange — LOC: 편집대상 idx unlock/lock | 9261 |
| L-12 | `LockRange2(iRow, idx, iRow, idx, bLockFlag, true)` | SetLockRange — FCST 3메저 Monthly(M+4 idx만) | 9271 |
| L-13 | `LockRange2(iRow, idx, iRow, idx, bLockFlag, true)` | SetLockRange — FCST 3메저 Weekly/Daily(전 편집대상 idx) | 9276 |
| L-14 | `range3.Locked = false` (+UnLockColor) | Insert() — 빈 시트 최초 행 추가 시 Action 이후 전 컬럼 unlock | 9330~9333 |

> 보조: `SetLockFlag(sheet, false/true)` 1573/1581 (Edit 플래그), 붙여넣기 시 `BackColor != UnLockColor` 셀 skip(7900~7903, 잠금 우회 방지) — Lock 호출은 아니나 잠금 체계의 일부.

### 6.2 팝업 (활성 37 = SwitchLock 1 + LockColumn 5 + LockRange 31)

| # | 호출 | 범위/의미 | 라인 |
|---|---|---|---|
| PL-00 | `SwitchLock()` | EditButton — 시트 Lock 토글 | 901 |
| PL-01 | `LockColumn(iCol, iCol, true)` | Edit 진입, W_ 컬럼: 과거주(`금주월요일 > W_`) 잠금 | 927~931 (호출 929) |
| PL-02 | `LockColumn(iCol, iCol, true)` | Edit 진입, W_ 컬럼: `0 < W_숫자` — **항상 참 → 모든 주차 셀 잠금 (PRICE_ALL만 입력)** | 933~940 (호출 937) |
| PL-03 | `LockColumn(iCol, iCol, true)` | Edit 아님(잠금모드)일 때 W_ 잠금 | 944 |
| PL-04 | `LockColumn(iCol, iCol, true)` | W_ 아닌 계획컬럼 전부 잠금 | 949 |
| PL-05~18 | `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 | 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_ID(995)/DEPT_NAME(997)/END_CUSTOMER(999)/SCM_SITE_ID(1001)/PROJECT_CODE(1003)/PROJECT_NAME(1005)/ProjectStatus(1007)/BizType(1009)/BizTypeName(1011)/ITEM_ID(1013)/ITEM_CLASS_NAME(1015)/ITEM_NAME(1017)/NICK_NAME(1019) (잔존) | 993~1019 |
| PL-19 | `LockRange(iRow, MEASURE, iRow, MEASURE, true)` | 〃 MEASURE 잠금 | 1021 |
| PL-20 | `LockRange(iRow, DIVISION_ID, iRow, MEASURE, true)` | 그 외 행: 키 구간 일괄 잠금 | 1025 |
| PL-21 | `LockRange(iRow, MEASURE+1, iRow, maxCol, true)` | AUTHORITY_YN != Y && Action 빈값 → 계획구간 행 잠금 | 1033 |
| PL-22 | `LockRange(iRow, iCol, iRow, iCol, false)` | AUTHORITY_YN != Y && I행 && Edit → W_ 셀 unlock | 1045 |
| PL-23 | `LockRange(iRow, iCol, iRow, iCol, true)` | 〃 W_ 외 컬럼 잠금 | 1049 |
| PL-24 | `LockRange(iRow, DIVISION_ID.., true)` | 〃 DIVISION 잠금 | 1067 |
| PL-25 | `LockRange(iRow, DIVISION_ID+1, iRow, MEASURE, false)` | 〃 키 구간 unlock (I행 키 입력 허용) | 1068 |
| PL-26 | `LockRange(iRow, PROJECT_NAME.., true)` | 〃 40 아닌 경우 파생 컬럼 잠금 | 1078 |
| PL-27 | `LockRange(iRow, ProjectStatus.., true)` | 〃 | 1080 |
| PL-28 | `LockRange(iRow, BizTypeName.., true)` | 〃 | 1082 |
| PL-29 | `LockRange(iRow, ITEM_CLASS_NAME.., true)` | 〃 공통 파생 잠금 | 1086 |
| PL-30 | `LockRange(iRow, ITEM_NAME.., true)` | 〃 | 1088 |
| PL-31 | `LockRange(iRow, MEASURE.., true)` | 〃 | 1090 |
| PL-32 | `LockRange(iRow, NICK_NAME.., true)` | 〃 | 1092 |
| PL-33 | `LockRange(iRow, MEASURE, iRow, "W_"+전주컬럼, true)` | 조회 시작이 7일 이전이면 dtWeek(DMF0082_POPUP_GET_WEEKDATA) 기준 **전 주차 구간 잠금** | 1096~1116 (호출 1110) |
| PL-34 | `LockRange(iRow, MEASURE+1, iRow, maxCol, true)` | Measure=="KRW" 행 계획구간 잠금 | 1124~1127 (호출 1126) |
| PL-35 | `LockRange(iRow, MEASURE+1, iRow, maxCol, true)` | Measure=="USD" 행 계획구간 잠금 | 1128~1131 (호출 1130) |
| PL-36 | `LockColumn(0, maxCol, true)` | FindData — 조회 직후 전 컬럼 잠금 | 1310 |

---

## 7. SaveSalesFuturePrice_Popup 제약 전수

### 7.1 조회(Find) 검증

| # | 검증 | 조건 | 메시지/동작 | 라인 |
|---|---|---|---|---|
| S-01 | 재진입 차단 | `blnWork == true` | MSG00137 후 return (조회/저장 공통 세마포어) | 1160~1166 (조회), 1465~1469 (저장), 2304~2311 (Division 변경, 메시지 없이 return) |
| S-02 | 기간 역전 | `from > to` | MSG00108 | 1177~1181 |
| S-03 | 과거구간 금지 | `이번주 월요일 > 시작일` | MSG00409 "과거구간은 일괄입력이 불가합니다" | 1189~1199 |
| S-04 | 월요일 강제 | from 또는 to가 월요일 아님 | MSG00330 | 1202~1208 |
| S-05 | Division 필수 | `p_division_id == ""` | MSG00097 | 1224~1228 |
| S-06 | 월요일 스냅(입력 보정) | Form_Load: `MinDate1 = 이번주 월요일`, from/to를 각자 주의 월요일로 스냅 / 달력 Load: Value1=이번주 월요일 / 달력 변경: from·to 모두 해당 주 월요일 텍스트로 스냅 | 날짜 자체를 월요일로 정규화 | 189~202, 2776~2787, 2790~2805 |
| S-07 | 조회 SP | `DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP` (userinfo=NowGroupID) — 0건이면 종료; 마지막 행 MEASURE 빈값이면 바인딩 skip | 1246~1311 |
| S-08 | PRICE_ALL 초기값 | 첫 주차(W_ 첫 컬럼) 값을 PRICE_ALL 컬럼에 복사 + CELL_PROD_SITE 콤보(`LOOKUP_COMBO SP_CELL_PROD_SITE`) 세팅 | 1313~1331 |
| S-09 | 실적 회색/당월 White | `W_ < 금주월요일` → iResultCol → Gainsboro, 당월 M_ White | 1336~1371 (색 1366~1370) — EditButton에도 동일(1135~1139) |
| S-10 | 범위초과 Pink | COL_LIST 컬럼의 W_목록 셀 → Pink 배경 | 1392~1405 |

### 7.2 편집(Edit) 제약

| # | 제약 | 내용 | 라인 |
|---|---|---|---|
| S-11 | 필수 컬럼(Division별) | §1.3 DP-02~04 — MSG00113 | 836~898 |
| S-12 | 주차 셀 전면 잠금 | `0 < int.Parse(W_...)` 항상 참 → Edit 진입 시 **모든 W_ 셀 잠금** (과거주 잠금 927과 중첩) → 실질 입력 가능 셀 = **PRICE_ALL 1컬럼** | 933~940 (과거주 927~931) |
| S-13 | 행 키 구간 잠금 / NEW_FLAG 분기 | §6.2 PL-05~20 | 990~1026 |
| S-14 | 권한행 잠금 + I행 예외 + 전주 잠금 | §2 A-13~14, §6.2 PL-21~33 | 1029~1117 |
| S-15 | KRW/USD 행 잠금 | 파생통화 행은 직접 입력 불가(LOC 행 입력 → 환산) | 1122~1131 |

### 7.3 저장(Save) 제약

| # | 검증/규칙 | 내용 | 라인 |
|---|---|---|---|
| S-16 | 변경 없음 차단 | 전 행×계획컬럼 스캔, ForeColor Red(변경 표식) 셀 1건도 없으면 MSG00133 | 1471~1490 |
| S-17 | NEW_FLAG 승격 | `NEW_FLAG=="Y" && Action=="M"` → action을 "I"로 간주하여 검증 진입 | 1524~1532 |
| S-18 | 필수 10키 검사(I행) | DIVISION / PROJECT(=40이면 END_CUSTOMER40, 81·82면 PROJECT_CODE) / SCM_SITE / ITEM / CURRENCY / MEASURE / DOM_EXP / FCST_TYPE / INCOTERMS / CELL_PROD_SITE — 누락 시 MSG00002("[항목]") + 해당 행 포커스 | 1554~1639 |
| S-19 | 중복 검사 | fnValidation: I행 기준 3행(Measure 세트) 단위(iRow+=3)로 전행 대조 — **81: 10키**(DIVISION/PROJECT/SITE/ITEM/DOM_EXP/FCST_TYPE/INCOTERMS/CURRENCY/MEASURE/PLANT_SITE) / **82: 9키**(PLANT 제외) / **40: 9키**(PROJECT 대신 END_CUSTOMER40) — 중복 2건↑ → MSG00043(+40/기타 별 문구) | 2111~2244, 문구 1641~1658 |
| S-20 | 저장 대상 셀 | Red 셀 존재 행만, `PRICE_ALL`·비W_ 컬럼 제외, `p_yyyymmdd = W_ 제거값`, qty = PRICE_ALL 값(콤마 제거) | 1730~1747 |
| S-21 | qty 0 → D | `qty==""` → "0"; `Action != "D" && qty=="0"` → 해당 건 action "D"(stempAction) | 1748~1759 |
| S-22 | 파라미터 조립 | 16개 파라미터 `CString.AppendStringEx` ^연결 → `DM.DMF0082_SAVE_MAIN_DATA` (CommandTimeout 90분) | 1761~1783, 1980~1996 |
| S-23 | 결과 처리 | RESULT_CODE=="S" → MSG00004(건수) / "F" → ERR_MESSAGE·RESULT_MSG 표시, Tables[1].TITLE=="SSP_SYNC_T_ERR"면 `DMF0003_SspSyncPopUp`(div "40") 표시 | 1998~2046 |
| S-24 | 저장 후 | isSaveOK=true, panel1 숨김, FindData(false) 재조회 | 2063~2082 |

### 7.4 환율 4룰 (GetExchangeRate)

| # | 룰 | 계산 | 라인 |
|---|---|---|---|
| S-25 | ① 동일 통화 | `sBaseER == sTargetER` → 입력값 그대로 | 2635~2637 |
| S-26 | ② 직행 환산 | dtFuturePrice에서 `CURRENCY=Target, UNIT_CURRENCY=Base, YYYYMM, DIVISION_ID` 행 존재 → `EXCHANGE_PRICE × 값` | 2639~2645 |
| S-27 | ③ 역방향 | `CURRENCY=Base, UNIT_CURRENCY=Target` 행 존재 → `Round(1/EXCHANGE_PRICE, 5) × 값` | 2647~2654 |
| S-28 | ④ KRW 경유 | 둘 다 KRW 아님 → `(값 × KRW/Base환율) ÷ KRW/USD환율`; 미해결 시 TargetVal null→"" else "0" | 2656~2673 |

> ⚠ **배선 실측**: 환율 전파 체인(`Dsdm_Changed` → `GetExchangeRate`/`SetExchangeValues`, popup 2442~2621)은 이벤트 구독이 주석 처리되어(popup 508 `//////dsdm.Changed += ...`; Designer에도 미배선 확인) **현재 실행되지 않는 잠재(latent) 코드**다. 활성 저장 경로(7.3)는 PRICE_ALL 값을 환산 없이 그대로 `p_qty`로 전달한다(1727, 1746). 환율 4룰 자체는 본문이 활성 함수이나 호출 경로가 미배선 — TO-BE 이관 시 배선 여부 정책 확정 필요.

---

## 8. 비활성(주석) 인벤토리

메인 폼은 [PJ2025-50188] 속도개선 리팩터링으로 대규모 구 로직이 주석 보존되어 있다. 활성 로직과 혼동 금지.

| # | 파일 | 구간(라인) | 내용 |
|---|---|---|---|
| X-01 | 메인 | 706~711, 722~725 | 구 DeleteButton I행 즉시삭제 로직 (E20250929-000202 위치 이동으로 주석) |
| X-02 | 메인 | 932~1519 | **구 EditButton 전체** — 버킷별 LockColumn(1071~1197), 40 division 분기(945, 1142~1194), Tables[3] EDIT_AUTH_* 컬럼 로드(1199~1226), RMA→SCM_FCST 차단(1239~1247), 메저×버킷별 LockRange_Edit 분기(1249~1516) |
| X-03 | 메인 | 2313~2327 | fnValidation 구 CellProdSite 중복 분기 |
| X-04 | 메인 | 2411~2487 | fnValidation 구 dtSave→dtSaveFinal 수집 로직(40 분기 2420, 2443 포함) |
| X-05 | 메인 | 2754~2849 | InsertRow 구 개별 컬럼 LockRange 33건 (Division/BizType/…/CELL_MODEL_NICK_NAME) |
| X-06 | 메인 | 2857~3014 | InsertRow 구 버킷별 신규행 잠금(40 8주 잠금 2946, LOC Monthly unlock 2949~2955, 배경색 2996~3014) |
| X-07 | 메인 | 3494~3532 | 구 spdMain_CellClick (PlantSite/82 Measure 콤보) |
| X-08 | 메인 | 3835~5535 | **구 spdMain_Changed 전체** — CELL 변경(3880~3953), Validation(3956~4077), 81 PlantSite(4088~4109), I행 중복(4111~4213), 버킷 기본요일(4215~4279), Daily 수정(4289~4422), Weekly 수정(4424~4756, RMA 동기하한 4439~4472, LOC 월평균 4715~4755), Monthly 수정(4757~5329, MSG00225 실적하한 4855~4873, LOC 1일 기입 5149~5198), 주월버킷 일수정(5330~5469), 키변경 클리어(5470~5531) |
| X-09 | 메인 | 5661~5737 | 신 spdMain_Changed 내 구 Monthly Lock 세부(LOC/MKT 색·잠금) |
| X-10 | 메인 | 5973~5995 | 81 PlantSite 콤보 재세팅(불필요 제거) |
| X-11 | 메인 | 6001~6006, 6014~6019 | 구 버킷 기본값(금요일)·비트 변환 |
| X-12 | 메인 | 6207~6541 | 구 Weekly 변경 로직 일괄(RMA 동기하한 6222~6256, LOC 월요일/1일 6458~6470, LOC 월평균 6499~6539) |
| X-13 | 메인 | 6745~7110 | 구 Monthly 변경 로직 일괄(MSG00225 6835~6852, LOC 그대로 6870~6875, 1일 기입 6958~6971) |
| X-14 | 메인 | 7140~7178 | Monthly 신로직 내 구 기본요일 스위치(위로 이동) |
| X-15 | 메인 | 7401~7548 | 구 주/월버킷 일자수정 합산 로직(40 분기 7405, LOC 첫값 7455~7487) |
| X-16 | 메인 | 7596~7609 | 키변경 클리어 내 구 행 포맷 세팅 |
| X-17 | 메인 | 8051~8195 | ClipboardPasted 구 포맷 로직(KRW/USD/LOC 3자리 8089) |
| X-18 | 메인 | 8345~8369 | ComboSelChange Measure 구 item reset (AS_In_Req/BNPIn) |
| X-19 | 메인 | 8427~8485 | 구 spdMain_KeyUp (40 분기 8450) |
| X-20 | 메인 | 8496~8644 | spdMain_LeaveCell 전체 주석(KRW/USD/LOC/MKT_AMT_* 포맷 스왑) |
| X-21 | 메인 | 8782~8902, 8905~9042 | 구 LockRange_Edit 2세대(EditFlag N 잠금, Monthly M+3, Daily MKT/SCM만, Weekly 일괄) |
| X-22 | 메인 | 9100~9111 | SetEditList 구 Week 비교식(12월 W01 결함 원인) |
| X-23 | 메인 | 9148~9164 | Tables[3] 구 EDIT_AUTH_* 컬럼 방식 로드 |
| X-24 | 팝업 | 508, 510 | `Dsdm_Changed`·`cboBucketType` 이벤트 구독 주석 → **환율 전파/버킷 체인 미배선** |
| X-25 | 팝업 | 105~110, 363~366, 513~527, 659~690, 921~972, 1038~1065 | Bucket(Weekly/Monthly) 선택 UI·잠금 구 로직 일괄(주간 고정으로 대체) |
| X-26 | 팝업 | 811~829 | InsertButton/DeleteButton 무력화(주석) — 팝업은 조회·일괄입력·저장만 |
| X-27 | 팝업 | 1495~1501 | 저장 시 기간 재선택 MSG00079 (주석) |
| X-28 | 팝업 | 1785~1964 | 구 저장 파라미터 조립(Measure 3행 전개 + 환율계산 GetExchangeRate 호출 + **RTF/RTF_SYS_RP 저장 제외** 1907~1912) — 신 로직은 PRICE_ALL 직접 전달로 대체 |
| X-29 | 팝업 | 2492, 2513~2522 등 | Dsdm_Changed 내부 소주석 |

---

## 9. 축별 카운트 (활성 기준)

| 축 | 건수 | 비고 |
|---|---:|---|
| 1. Division | 메인 19 + 파라미터 흐름 10 + 팝업 13 = **42** | 40 고정 화면이나 81/82 활성 잔존 분기: 메인 6건(D-08, D-10, D-15, D-18, 5776, 8249), 팝업 8건(DP-01/03/04/05/06/07/08/13). 주석 81/82 분기는 §8 |
| 2. 권한 | **15** (A-01~A-15) | Tables[3] 4종 로드 1 + 소비 8(Delete 4, SetLockRange 4) + 그룹스코프 룩업 묶음 1 + 팝업 3 + SP 1. **MSG00096 게이트: 두 소스 미존재(실측 0건)** |
| 3. Measure | **25** (M-01~M-25) | 편집 4종 게이트, SCM_FCST×RMA, LOC×Daily 불가, LOC 1일/월요일 기입, LOC 월=평균, NOTATION(INTEGER/POINT3) 스왑, KRW/USD 행 잠금 포함 |
| 4. 기간·버킷 | **24** (P-01~P-24) | cutoff=금주 월요일, 편집시작 D/W(12월 W01 보정)/M(+FCST M+4), Gainsboro, 당주 보더, 버킷전환 Lock 복원 포함 |
| 5. FCST_TYPE | **10** (F-01~F-10) | 활성 RMA 게이트는 F-01 단 1건(9239). RMA 동기하한·RTF 제외는 전부 비활성(§8 X-08/X-12/X-28) |
| 6. Lock 전수 | 메인 **14** (직접 10 + SetLockRange 진입 3 + Insert() 1) / 팝업 **37** (SwitchLock 1 + LockColumn 5 + LockRange 31) = **51** | 1건 1행 수록. 주석 Lock(구 EditButton/InsertRow/LockRange_Edit 등)은 §8 |
| 7. 팝업 제약 | **28** (S-01~S-28) | 조회검증 10 + 편집 5 + 저장 9 + 환율 4룰 4. 환율 체인은 이벤트 미배선(잠재) 명기 |
| 8. 비활성 인벤토리 | **29 구간** (X-01~X-29) | 메인 23 + 팝업 6 |
