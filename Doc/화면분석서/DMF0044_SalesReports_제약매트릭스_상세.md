# DMF0044 Sales Reports — 제약매트릭스 상세 (AS-IS 소스 전수 실측)

> 작성일: 2026-07-20 / 방식: 7파일 전량 Read (요약·표본 없음, anti-simplification)
> 소스에 없는 항목은 "없음"으로 정직 표기. 주석 처리(비활성) 코드는 §9 비활성 인벤토리로 분리.

## 0. 원천 (7파일 전량 Read)

| # | 파일 | 행수 | 역할 |
|---|---|---:|---|
| 1 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.cs` | 1,483 | 메인 화면 (정본, Forms.UIL) |
| 2 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_Sales_VersionPopUp.cs` | 444 | MDF Version 선택/전송 팝업 (⚠ 메인 호출부 주석 처리 — §7.1) |
| 3 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_Sales_VersionCopyPopUp.cs` | 451 | Version Copy 팝업 (#2 의 btnCopy 에서 호출) |
| 4 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_United_VersionPopup.cs` | 727 | 통합 버전 팝업 (메인 btnSPVer 에서 호출 — 현재 활성 버전 팝업) |
| 5 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_MDFVersionPopUp.cs` | 440 | Ver. Cut-Off 팝업 (⚠ 메인 소스 내 호출 없음 — §7.4) |
| 6 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_SalesReportExchangePopup.cs` | 721 | Exchange Rate 팝업 (메인 btnExchangeRate 에서 호출) |
| 7 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0044_SalesReport_TextboxPopup.cs` | 453 | Textbox(월별 코멘트) 팝업 (메인 btnTextbox — **Division 82 전용 버튼**) |

팝업 호출 배선 실측 (메인 파일 기준):
- 활성 호출: `DMF0044_United_VersionPopup` (L1150), `DMF0044_SalesReportExchangePopup` (L1441), `DMF0044_SalesReport_TextboxPopup` (L1476), `DM0002_ItembyDivisionPopupEx` (L1317), `DM0002_TitleSetForm_Popup` (L1409)
- 주석 처리(비활성) 호출: `DMF0044_Sales_VersionPopUp` (L1156~1163)
- `DMF0044_Sales_VersionCopyPopUp` 은 `DMF0044_Sales_VersionPopUp.btnCopy_Click` (파일2 L361~371) 경유로만 호출
- `DMF0044_MDFVersionPopUp` 호출부: 7파일 내 없음 (메인의 `sCUTOFF_YYYYMMDD` 주석 L58 "MDF Version 팝업에서 전달"은 비활성 #2 경유 잔재)

---

## 1. Division 축 (division 비교·분기 전수)

메인 화면의 division 값 비교는 **"82"(버튼 노출)와 "40"(편집 잠금 완화)** 2종뿐. 81계열('81%' LIKE 등) 비교는 **이 화면 FE 소스에 없음**.

| ID | 파일 | 위치 | 조건 | 동작 | 라인 |
|---|---|---|---|---|---|
| D-1 | 메인 | `InitControls` | `sDivision == "82"` | `lci_btnTextBox`(Textbox 팝업 버튼) 표시, 그 외 숨김 | 180~181 |
| D-2 | 메인 | `EditButton` (MEASURE 에 "RTF" 포함 또는 =="Business_Plan" 인 행) | `DIVISION_ID == "40"` | 40(소형): 헤더영역(0~MEASURE)만 잠금 → **기간 수량 수정 가능** / 그 외 division: 행 전체 잠금(수정 불가) | 344~351 |
| D-3 | 메인 | `EditButton` (그 외 measure 행) | `DIVISION_ID == "40"` | 40(소형): 헤더 잠금 + **현재월(iCurCol)~끝 잠금 → 과거구간만 수정 가능** / 그 외 division: 행 전체 잠금 (주석: "소형은 과거구간 수정가능, 그 외에는 과거구간 수정 불가") | 353~365 |
| D-4 | 메인 | `clbDivision_SelectedIndexChanged` | `sDivision == "82"` | Textbox 버튼 표시 토글 (D-1 과 동일 식) + `txtSPVersion=""` 리셋 | 1457~1465 |
| D-5 | 팝업3 (Copy) | `SaveData` | `p_division_id.ToUpper() == "ALL"` | MyDivision 체크리스트 값으로 확장 후 콤마 split, division 별 SP 반복 호출 | 250~254, 294 |
| D-6 | 팝업5 (MDF) | `SaveData` | `p_division_id.ToUpper() == "ALL"` | 동일 ALL 확장 + division 별 SP 반복 호출 | 303~307, 319 |

Division 관련 고정(비교는 아니나 제약): 팝업2/3/4 모두 `clbDivision.Enabled = false` (파일2 L139, 파일3 L136, 파일4 L120) — 팝업에서 division 변경 불가, 메인에서 전달된 값 고정.

**Division 축 활성: 6건** (+ 비활성 2건 — §9)

---

## 2. 권한 축 (NowGroupID / EDIT_FLAG / 편집권한 배선 전수)

실측 결과 이 화면의 권한은 **이중 게이트 하이브리드**가 맞음:
- **(게이트 1) EDIT_FLAG 행 계산**: 조회 SP `DMF0044_GET_SALES_REPORTS_DATA` 에 `p_user_group = NowGroupID` 를 전달(L465) → 서버가 행 단위 `EDIT_FLAG` 를 내려주고, FE `EditButton` 이 `EDIT_FLAG == 'Y'` 행은 헤더만 잠그고 기간을 열어줌(L320~327). 'Y' 아니면 measure×division 조합 잠금(§3/§1).
- **(게이트 2) division 편집권한 뷰**: 조회조건 Division 콤보 자체가 `MyDivision(NowGroupID, UserId)` (L153~160) — 권한 그룹에 허용된 division 만 노출되므로 접근 division 이 원천 차단됨.

| ID | 파일 | 기능 | 권한 조건 | 효과 | 라인 |
|---|---|---|---|---|---|
| A-1 | 메인 | Division 콤보 구성 | `Filter["GROUP_ID"]=NowGroupID` + `USER_ID` → `GetDMInnerTable("MyDivision")` | 권한 그룹 허용 division 만 콤보 노출 (게이트 2) | 151~164, 177 |
| A-2 | 메인 | 조회 | `p_user_group = NowGroupID` 를 조회 SP 파라미터로 전달 | 서버측 행별 EDIT_FLAG 산출 원천 | 465 |
| A-3 | 메인 | Edit(잠금 해제) | 행 `EDIT_FLAG == "Y"` (CAppSetting.StringY) | 헤더(0~MEASURE)만 잠금 → 기간 편집 허용 / 'Y' 아님 → measure·division 잠금 분기로 이동 (게이트 1) | 318~328 |
| A-4 | 팝업2 | 폼 권한체크 | `this.IsPopup = true` | BaseForm 권한 체크 패스 (주석 명기: "팝업일 경우 아래 할당하면 권한 체크 패스된다") | 145~149 |
| A-5 | 팝업3 | 폼 권한체크 | `this.IsPopup = true` | 동일 | 141~145 |
| A-6 | 팝업4 | 폼 권한체크 | `this.IsPopup = true` + `IsPopupEditCheck = false` | 권한 체크 패스 + 편집 체크도 해제 | 105~106 |
| A-7 | 팝업5 | 폼 권한체크 | `this.IsPopup = true` | 동일 | 146~150 |
| A-8 | 팝업6 | 폼 권한체크 | `this.IsPopup = true` | 동일 | 142~143 |
| A-9 | 팝업7 | 폼 권한체크 | `this.IsPopup = true` | 동일 | 111~112 |
| A-10 | 팝업2 | Division 데이터 | `MyDivision(NowGroupID, UserId)` | 권한 division 콤보 (Enabled=false 고정) | 136~139 |
| A-11 | 팝업3 | Division 데이터 | `MyDivision(NowGroupID, UserId)` | 동일 | 133~136 |
| A-12 | 팝업4 | Division 데이터 | `MyDivision(NowGroupID, UserId)` | 동일 (Enabled=false, 메인 전달값 고정) | 117~120 |
| A-13 | 팝업5 | Division 데이터 | `MyDivision(NowGroupID, UserId)` | 체크리스트 구성 | 140~142 |
| A-14 | 팝업6 | Division 데이터 | `MyDivision(NowGroupID, UserId)` | 조회용 division 목록 | 131~133 |
| A-15 | 팝업6 | 버튼 노출 | `NowGroupID` ∈ {"ADMIN","DM ADMIN"} 외 | Edit/Insert/Save 버튼 숨김 (`Set_ButtonVisibleFalse`) | 145~162 |
| A-16 | 팝업6 | Edit 실행 | `NowGroupID` ∈ {"ADMIN","DM ADMIN"} 외 | `MessageBox "You don't have the permissions to access it"` 후 차단 | 331~340 |
| A-17 | 팝업6 | Save 실행 | `NowGroupID` ∈ {"ADMIN","DM ADMIN"} 외 | `MSG00096` 후 차단 | 394~404 |
| A-18 | 팝업7 | 버튼 노출 | `NowGroupID` ∈ {"ADMIN","DM ADMIN"} 외 | Edit/Insert/Save 버튼 숨김 | 114~128 |
| A-19 | 팝업7 | Edit 실행 | `NowGroupID` ∈ {"ADMIN","DM ADMIN"} 외 | `MessageBox "You don't have the permissions..."` 후 차단 | 189~198 |
| A-20 | 팝업7 | Save 실행 | `NowGroupID` ∈ {"ADMIN","DM ADMIN"} 외 | `MSG00096` 후 차단 | 215~224 |

메인 화면에는 NowGroupID 값 자체("ADMIN" 등)를 하드코딩 비교하는 코드 **없음** — 값 비교는 팝업6/7에서만 발생. 메인의 권한은 A-1~A-3 배선(EDIT_FLAG + MyDivision)으로만 작동.

**권한 축 활성: 20건**

---

## 3. Measure/컬럼 축 (값 비교·편집 게이트 전수)

편집 게이트의 핵심. `EditButton` 은 EDIT_FLAG≠'Y' 행을 MEASURE 값으로 3분기 (주석 원문 L291~292: "계획구간에서는 LOC, RTF, 실적구간은 RTF, SalesAmt_LOC, SalesAmt_KRW 가 편집가능함").

| ID | 파일 | 비교 대상 | 조건 | 동작 | 라인 |
|---|---|---|---|---|---|
| M-1 | 메인 | MEASURE | `== "LOC"` | 헤더(0~MEASURE) 잠금 + `iCurCol-1 > iStartCol` 이면 과거구간(iStartCol~iCurCol-1) 잠금 → **계획구간(현재월~)만 편집** | 331~339 |
| M-2 | 메인 | MEASURE | `.IndexOf("RTF") >= 0 \|\| == "Business_Plan"` | Division 분기(§1 D-2): 40 은 기간 전체 편집, 그 외 행 전체 잠금 | 340~352 |
| M-3 | 메인 | MEASURE | 그 외 (else) | Division 분기(§1 D-3): 40 은 과거구간만 편집, 그 외 행 전체 잠금 | 353~365 |
| M-4 | 메인 | MEASURE (InsertRow) | 신규 2행 세트 | MEASURE 셀 잠금 + `dtMeasure.Rows[i]["CODE"]` (SP `DMF0044_GET_MEASURE`, p_Data_Type=sDataType) 값 강제 `SetValue` — 사용자 선택 불가 | 1021~1025 (원천 1054~1065) |
| M-5 | 메인 | 기간 셀 (spdMain_Changed) | `e.Column > MEASURE` 이고 action=='M' 이고 셀값 `== ""` | 빈 값을 "0" 으로 강제 치환 | 1295~1302 |
| M-6 | 메인 | DEPARTMENT_ID 값 | `!= "기타"` / `== "기타"` | 기타 아님: DEPT_ID 콤보=`DMF0044_DEPARTMENT_TEAM`, ITEM/NICK/END_CUST/CUST/PRODUCT_GROUP 초기화. 기타: DEPT_ID 콤보=`DMF0044_ETC_SALE_RESULT_TYPE_40`, END_CUST/CUST/PRODUCT_GROUP 콤보를 빈 콤보로 교체 후 초기화 | 1174~1217 |
| M-7 | 메인 | DEPT_ID(팀) 값 | `!= "MDF"` / `== "MDF"` | MDF 아님: CUST_REPORT 콤보=`DMF0005_REPORT_GROUP2`, ITEM_ID/NICK_NAME 을 "기타매출"로 강제 세팅. MDF: CUST_REPORT 빈 콤보, ITEM/NICK 초기화 | 1219~1276 (분기 1242~1275) |
| M-8 | 메인 | ITEM_ID 값 (더블클릭) | `!= "기타매출"` | Item 팝업(`DM0002_ItembyDivisionPopupEx`) 오픈 허용, "기타매출" 행은 팝업 차단 | 1307~1333 (게이트 1314) |

메인 SaveData 에서 measure 는 비교 없이 payload 로만 전달 (ETC: L601/638, Cutoff: L821~822). 팝업 6종에는 MEASURE 비교 **없음**.

**Measure/컬럼 축 활성: 8건**

---

## 4. 기간·버전 축 (계획/실적 구간 계산 + 버전 팝업 4종 버전 축 전수)

### 4.1 메인 — 계획/실적 구간 계산과 버전 게이트

| ID | 항목 | 조건/규칙 | 동작 | 라인 |
|---|---|---|---|---|
| V-1 | 구간 기준 | `sCurMonth = DateTime.Today("yyyyMM")`, `iStartCol = MEASURE+1` | 이번달부터 계획구간, 전달까지 실적구간 (주석 L291) | 287~288 |
| V-2 | 전부 계획구간 | 첫 기간컬럼 태그(`M_yyyyMM`) ≥ 현재월 **또는** `clbType == "REPORT_BP_M"` | `iCurCol = iStartCol` — **BP(사업계획)는 무조건 전 구간을 계획구간으로 취급** | 294~299 |
| V-3 | 전부 실적구간 | 마지막 기간컬럼 태그 < 현재월 | `iCurCol = GetMaxColumnIndex()` | 300~304 |
| V-4 | 혼합 구간 | 그 외 | 컬럼 태그 == 현재월인 컬럼을 순회 탐색하여 iCurCol 결정 | 305~315 |
| V-5 | 조회 버전 필수 | `txtSPVersion.Text == ""` | `MSG00283` 후 조회 중단 | 435~439 |
| V-6 | 저장 버전 필수 | `txtSPVersion.Text == ""` | `MSG00281` 후 저장 중단 | 504~507 |
| V-7 | Exchange 팝업 버전 필수 | `txtSPVersion.Text == ""` | `MSG00281` 후 팝업 차단 | 1435~1438 |
| V-8 | Textbox 팝업 버전 필수 | `txtSPVersion.Text == ""` | `MSG00281` 후 팝업 차단 | 1470~1473 |
| V-9 | Cutoff 일자 | `sCUTOFF_YYYYMMDD` public 필드 (팝업2 SetItem 이 세팅 — 단 해당 호출 경로는 현재 주석) | 저장 시 `p_cutoff_yyyymmdd` 로 전 행 전달. **활성 경로(United 팝업)는 이 값을 세팅하지 않음 → 빈 문자열 전달** | 58, 592/629/799 |
| V-10 | 버전 리셋 (Type 변경) | `clbType_SelectedIndexChanged` | `txtSPVersion = null` + 라벨 `REPORT_SP_W` → "SP Version" / 그 외 "BP Version" | 1394~1403 |
| V-11 | 버전 리셋 (Division 변경) | `clbDivision_SelectedIndexChanged` | `txtSPVersion = ""` | 1457~1462 |
| V-12 | 버전 선택 진입 | `btnSPVer_Click` | `DMF0044_United_VersionPopup.Form_Load(division, type)` → 반환 `pop.sVersions` 채택 | 1148~1154 |
| V-13 | 조회 기간 | 조회 파라미터 `p_yyyy = usrYear` (연 단위), 헤더 SP `p_start_dt = YYYY+"0101"` ~ `p_end_dt = YYYY+"1231"` | 연도 콤보는 `UP_FX_GetCommonDataList_DM(CODE='CALENDAR_YYYY')` 실측 목록, 기본값 = 올해 | 229~230, 462, 1086~1088 |

### 4.2 버전 팝업 4종 버전 축 요약

| 항목 | 팝업2 Sales_Version | 팝업3 VersionCopy | 팝업4 United_Version | 팝업5 MDFVersion |
|---|---|---|---|---|
| 버전 축 코드 (version_type) | 메인 `clbType` 값 그대로 (`sVersion_Type`) | `REPORT_SP_W`→`"SP_W"`, 그 외→`"BP_M"` 매핑 (L105) | 조회 축: lookup `MDF_TYPE_SP_POPUP`(_sType==REPORT_SP_W 시) / `MDF_TYPE_BP_POPUP` (L130~137). 값 집합 실측: 생성계열 `SP_W`/`BP_M`/`SP_M`, Copy계열 `REPORT_SP_W`/`REPORT_BP_M` (L351, 505, 520, 557) | `LoadData` 인자 그대로 `txtType.Text` (L115~128) |
| 조회 SP | `DMF0044_GET_SALES_VERSION_POPUP` (p_division_id, p_sdt, p_edt, p_version_type) L208~217 | `DMF0044_GET_COPY_VERSION_POPUP` (+p_created_by, p_version_no=txtDes) L210~218 | `DMF0044_GET_SALES_VERSION_POPUP` (+`p_Description`=txtDesc) L233~243 | `DM0021_GET_DM_MST_VERSION` (p_division_id, p_version_description, p_version_type, p_from/to_yyyymmdd, p_created_by) L262~269 |
| 기간 기본값 | 전월 −1M ~ +5M (L92~93) | 오늘 ~ +5M (L91~92) | −1M ~ +5M (L122~124) | 오늘 ~ +5M (L103~105) |
| 기본 버전 | 없음 (조회 후 수동 선택) | 없음 | 없음 | 없음 |
| "Current" 취급 | 없음 (Current 개념 소스에 없음) | 없음 | 없음 | 없음 |
| 버전 선택 규칙 | 1개만 (RowCount>1 → MSG00279, 미선택 → MSG00279) L332~357 | 1개만 (iCount>1/미선택 → MSG00279) L261~286 | 단일행 하이라이트(`giRowIndex`, CellClick) 기반; 미선택(-1)이면 무동작. 더블클릭 확정은 `clbType ∈ {REPORT_BP_M, REPORT_SP_W}` 일 때만 (L349~356) | 선택 개념 없음 (Confirm=버전 Cut-Off 실행) |
| 반환값 | `sVersions` + `sCUTOFF_YYYYMMDD`(YYYYMMDD 컬럼) L346~347 | `sVersions` (Copy 원본 지정용) L268~271 | `sVersions` 만 (CUTOFF 반환 없음) L353, 486 | 반환 없음 (`blnOK` 만, mOK L428~431) |
| 과거 잠금/기간 검증 | 없음 (전 컬럼 조회 잠금뿐) | 없음 | 없음 | 없음 (관련 로직 전부 주석 — §9) |

### 4.3 팝업4 (United) — 버전 상태(SEND_YN)·액션 게이트 전수

| ID | 버튼 | 게이트 | 동작 (SP / p_action_type) | 라인 |
|---|---|---|---|---|
| V-14 | Transfer | `SEND_YN == "N"` 만 | `DMF0044_MOBILE_REPORT_CREATE` / `"T"`. 위반 시 `MSG00318` 확인창 | 376~394 |
| V-15 | Transfer Cancel | `SEND_YN == "Y"` 만 | `MSG00195` 확인 후 `DMF0044_MOBILE_REPORT_CREATE` / `"C"`. 위반 시 `MSG00319` | 396~418 |
| V-16 | Version Delete | `SEND_YN ∈ {"N","C"}` 만 | `MSG00016` 확인 후 `DMF0044_SAVE_SALES_PLAN_VERSION_COPY` / `"D"`. 위반 시 `MSG00320` | 420~441 |
| V-17 | Version Copy | `chkResult` 미체크 시 `MSG00314`("실적 미포함 복사?") 확인 | `DMF0044_SAVE_SALES_PLAN_VERSION_COPY` / `"CP"` (+p_result_date=BasicDate) | 443~468 |
| V-18 | Version Create | 게이트 없음 (행 선택만) | `DMF0044_SAVE_SALES_PLAN_VERSION_COPY` / `"CR"` | 470~479 |
| V-19 | OK | 행 선택 시 | `sVersions` 확정 후 Close | 481~489 |
| V-20 | Type 별 버튼 노출 | 생성계열(`SP_W`/`BP_M`/`SP_M`): Create 만 노출, Transfer/Cancel/Copy/Delete/OK/Result/BasicDate 숨김. Copy계열(`REPORT_*`): 반대. MV(월)입력은 `SP_W`/`SP_M`/`REPORT_SP_W` 만 노출 | `ControlDisplay` | 503~579 |
| V-21 | 실적 포함 옵션 | `chkResult` 체크 → BasicDate 활성(오늘) + `chkUpdate` 강제 체크·비활성 / 해제 → 역방향 | 302~321 |
| V-22 | MV 옵션 | `chkMV` 체크 → MvMonth 활성(기본 전월) / 해제 → 비움 | 713~725 |
| V-23 | Copy SP 파라미터 | p_division_id, p_version_no, p_version_description, p_created_by, p_result_date(chkResult 시), p_action_type, p_mv_plan_yyyymm(chkMV 시), p_update_yn(chkUpdate Y/N) | 643~656 |

**기간·버전 축 활성: 메인 13건 + 팝업 게이트 10건(V-14~V-23) + 팝업4종 축표 비교 = 표 3개로 전수 기재**

---

## 5. FCST_TYPE 축

**값 비교·분기 없음.** 존재하는 전부:
- 컬럼 상수 선언: 메인 L112 (`DefColumns.FCST_TYPE`)
- Cutoff 저장 payload pass-through: 그리드에 FCST_TYPE 컬럼이 있으면 값 그대로 `p_fcst_type` 로 전달, 없으면 빈값 (L846~848), SP 파라미터 바인딩 L924
- 팝업 6종: FCST_TYPE 등장 0건

---

## 6. 잠금(Lock) 전수 — LockRange / LockColumn 호출 전량 (활성 30건)

### 6.1 메인 (21건)

| # | 메서드 | 호출 | 범위 | 조건 | 라인 |
|---|---|---|---|---|---|
| L-01 | EditButton | `LockRange(iRow,0,iRow,MEASURE,true)` | 행 헤더영역 | `EDIT_FLAG=='Y'` 행 | 327 |
| L-02 | EditButton | `LockRange(iRow,0,iRow,MEASURE,true)` | 행 헤더영역 | MEASURE=='LOC' | 333 |
| L-03 | EditButton | `LockRange(iRow,iStartCol,iRow,iCurCol-1,true)` | 과거(실적)구간 | MEASURE=='LOC' 이고 `iCurCol-1 > iStartCol` | 335~338 |
| L-04 | EditButton | `LockRange(iRow,0,iRow,MEASURE,true)` | 행 헤더영역 | RTF/Business_Plan + DIVISION_ID=='40' | 346 |
| L-05 | EditButton | `LockRange(iRow,0,iRow,GetMaxColumnIndex(),true)` | 행 전체 | RTF/Business_Plan + division≠40 | 350 |
| L-06 | EditButton | `LockRange(iRow,0,iRow,MEASURE,true)` | 행 헤더영역 | 기타 measure + DIVISION_ID=='40' | 358 |
| L-07 | EditButton | `LockRange(iRow,iCurCol,iRow,max,true)` | 현재월~끝 | 기타 measure + DIVISION_ID=='40' (과거만 편집) | 359 |
| L-08 | EditButton | `LockRange(iRow,0,iRow,max,true)` | 행 전체 | 기타 measure + division≠40 | 363 |
| L-09 | FindData | `LockColumn(0,max,true)` | 전 컬럼 | 조회 직후 전체 잠금 (Edit 로 해제) | 480 |
| L-10 | InsertRow | `LockRange(DEPARTMENT_NAME)` | 신규 2행 각각 | 컬럼 존재 시 | 996~997 |
| L-11 | InsertRow | `LockRange(DEPT_NAME)` | 〃 | 〃 | 998~999 |
| L-12 | InsertRow | `LockRange(CUTOFF_YYYYMMDD)` | 〃 | 〃 | 1000~1001 |
| L-13 | InsertRow | `LockRange(NICK_NAME)` | 〃 | 〃 | 1002~1003 |
| L-14 | InsertRow | `LockRange(SCM_SITE_ID)` | 〃 | 〃 | 1006~1007 |
| L-15 | InsertRow | `LockRange(PROJECT_CODE)` | 〃 | 〃 | 1008~1009 |
| L-16 | InsertRow | `LockRange(APPLICATION)` | 〃 | 〃 | 1010~1011 |
| L-17 | InsertRow | `LockRange(BIZ_TYPE_NAME)` | 〃 | 〃 | 1012~1013 |
| L-18 | InsertRow | `LockRange(BIZ_TYPE_NAME40)` | 〃 | 〃 | 1014~1015 |
| L-19 | InsertRow | `LockRange(DMS_SALES)` | 〃 | 〃 | 1016~1017 |
| L-20 | InsertRow | `LockRange(DMS_CUSTOMER)` | 〃 | 〃 | 1018~1019 |
| L-21 | InsertRow | `LockRange(MEASURE)` (+ SetValue 로 measure 강제) | 〃 | 〃 | 1021~1024 |

보조 배선: `SwitchLock()` (EditButton 진입, L280), `IsLock` 게이트 — 저장 ETC L517 / Cutoff L718, InsertRow L976.

### 6.2 팝업 6종 (9건)

| # | 파일 | 호출 | 범위 | 시점 | 라인 |
|---|---|---|---|---|---|
| L-22 | 팝업2 | `LockColumn(0,max,true)` | 전 컬럼 | 조회 직후 (조회 전용 그리드) | 223 |
| L-23 | 팝업3 | `LockColumn(0,max,true)` | 전 컬럼 | 조회 직후 | 225 |
| L-24 | 팝업4 | `LockColumn(DIVISION_ID,max,true)` | DIVISION_ID~끝 | 조회 직후 | 246 |
| L-25 | 팝업5 | `LockColumn(0,max,true)` | 전 컬럼 | 조회 직후 | 272 |
| L-26 | 팝업6 | `LockColumn(DIVISION_ID,CURRENCY_UNITCURRENCY,true)` | 키 컬럼 4개 | EditButton (SwitchLock 후 키만 재잠금) | 342~346 |
| L-27 | 팝업6 | `LockColumn(0,max,true)` | 전 컬럼 | 조회 직후 | 429 |
| L-28 | 팝업6 | `LockRange(ActiveRow,CURRENCY,ActiveRow,CURRENCY,true)` | 신규행 CURRENCY 셀 | InsertRow (기본값 "KRW" 고정) | 623~628 |
| L-29 | 팝업6 | `LockRange(ActiveRow,CURRENCY_UNITCURRENCY,ActiveRow,i-1,true)` | 현재월 이전 컬럼 | InsertRow — `usrYear < 현재연도` 일 때 컬럼 태그(D+yyyymmdd) 순회, `iLockMonth >= 현재yyyyMM` 첫 컬럼 직전까지 잠금 (**과거 구간 입력 차단**) | 631~650 |
| L-30 | 팝업7 | `LockColumn(1,max,true)` | 1~끝 (Action 열 제외) | 조회 직후 (Edit=SwitchLock 로 해제) | 266 |

**잠금 활성 합계: 30건** (메인 21 + 팝업 9). 비활성(주석) 13건은 §9.

---

## 7. 팝업 6종 제약 전수 (검증 MSG · 권한 · 잠금 · 저장 파라미터)

### 7.1 팝업2 `DMF0044_Sales_VersionPopUp` (444행) — ⚠ 메인 호출부 주석 처리 상태

| 구분 | 내용 | 라인 |
|---|---|---|
| 검증 | 전송모드에서 OK(선택) 시 `MSG00280` "전송모드에서는 저장이 불가능합니다" | 326~330 |
| 검증 | 다중 행 선택(RowCount>1) → `MSG00279` "버전은 1개만" | 337~341 |
| 검증 | 미선택 → `MSG00279` | 353~357 |
| 검증 | Transfer 다중선택(iCount>1) → `MSG00279` | 390~395 |
| 결과 | Transfer 결과: `MSG00156` / 서버 MSG passthrough / 테이블 없으면 `MSG00004` | 416~431 |
| 권한 | `IsPopup=true` 패스 + MyDivision(NowGroupID) + `clbDivision.Enabled=false` | 135~139, 148 |
| 잠금 | L-22 (전 컬럼 조회 잠금) | 223 |
| 저장 | **배선된 저장 없음** — 버튼 스위치는 Find/OK/Close 만 (L295~309). `SaveData`(L241~291) 는 `FoxDataRequest("")` 빈 SP + `MSG00151` 로 미배선 dead code → §9 | 241~291 |
| Transfer SP | `DMF0044_MOBILE_REPORT_CREATE` (p_division_id, p_version_no, p_version_type, p_created_by) | 404~414 |
| 반환 | `sVersions`(VERSION_NO) + `sCUTOFF_YYYYMMDD`(YYYYMMDD) | 344~348 |

### 7.2 팝업3 `DMF0044_Sales_VersionCopyPopUp` (451행)

| 구분 | 내용 | 라인 |
|---|---|---|
| 검증 | Save: 다중선택(iCount>1) → `MSG00279`, 미선택 → `MSG00279` | 275~286 |
| 검증 | Save 버튼: 전송모드 → `MSG00280` 차단 | 357~363 |
| 검증 | division 빈값 → 무동작 return | 288~291 |
| 검증 | Transfer 다중선택 → `MSG00279` | 395~400 |
| 결과 | `MSG00156` / success → `MSG00004`+Close / 그 외 서버 MSG passthrough (Save L314~334, Transfer L421~436) | — |
| 권한 | `IsPopup=true` + MyDivision(NowGroupID) + `clbDivision.Enabled=false` | 133~136, 141~145 |
| 잠금 | L-23 (전 컬럼 조회 잠금) | 225 |
| 저장 SP 분기 | `sVersion_Type=="SP_W"` → `DM.DMF0044_SAVE_SALES_PLAN_VERSION_COPY` / 그 외 → `DM.DMF0044_SAVE_BIZ_PLAN_VERSION_COPY` | 300~304 |
| 저장 파라미터 | p_division_id(=clbDivision.ControlValues), p_version_no(=선택 sVersions), p_version_description(=txtDes), p_created_by | 306~311 |
| Transfer SP | `DMF0044_MOBILE_REPORT_CREATE` (동 파라미터 + p_version_type) | 409~419 |

### 7.3 팝업4 `DMF0044_United_VersionPopup` (727행) — 현재 활성 버전 팝업

| 구분 | 내용 | 라인 |
|---|---|---|
| 검증/게이트 | SEND_YN 3종 게이트 + 액션코드 5종(T/C/D/CP/CR) — §4.3 V-14~V-18 전수 | 376~479 |
| 검증 | 실적 미포함 복사 확인 `MSG00314`, 삭제 확인 `MSG00016`, 취소 확인 `MSG00195`, 위반 안내 `MSG00318`/`MSG00319`/`MSG00320` | 390, 406, 413, 430, 437, 458 |
| 결과 | success → `MSG00004` + 재조회 / 그 외 서버 MSG passthrough (2개 실행기 공통) | 608~616, 663~672 |
| 권한 | `IsPopup=true` + `IsPopupEditCheck=false` + MyDivision(NowGroupID) + `clbDivision.Enabled=false` | 105~106, 117~120 |
| 잠금 | L-24 (DIVISION_ID~끝 조회 잠금) | 246 |
| 저장 파라미터 | §4.3 V-23 (8개, chkResult/chkMV/chkUpdate 연동) | 643~656 |
| 전송 SP | `DMF0044_MOBILE_REPORT_CREATE` (p_division_id, p_version_no, p_version_type, p_action_type, p_created_by) | 591~605 |
| UI 게이트 | Type 계열별 버튼 노출 매트릭스 (§4.3 V-20), 더블클릭 확정은 REPORT_BP_M/REPORT_SP_W 만 (V-19 인접, L349~356), 행 선택은 CellClick 하이라이트(giRowIndex) | 349~356, 503~579, 693~711 |
| 비고 | `SaveButton→SaveData` 는 빈 본문 (L261~264) — 저장 자체가 액션 버튼 5종으로 대체됨 | 261~264 |

### 7.4 팝업5 `DMF0044_MDFVersionPopUp` (440행) — ⚠ 7파일 내 호출부 없음

| 구분 | 내용 | 라인 |
|---|---|---|
| 검증 | division 빈값 → 무동작 return | 311~315 |
| 결과 | `MSG00143` (division 별 SP 결과 취합 보고) | 345 |
| 권한 | `IsPopup=true` + MyDivision(NowGroupID) | 140~142, 146~150 |
| 잠금 | L-25 (전 컬럼 조회 잠금). EditButton/InsertRow 잠금 로직은 전부 주석(§9) | 272 |
| 실행 SP | `sFoxData` (기본 `DM_H.PR_DM_PLN_SALES_PLAN_CUTOFF`, LoadData 로 교체 가능) — p_division_id(ALL 확장 후 개별), p_version_description | 47, 323~334 |
| 버튼 배선 | Find/Close/**Confirm(=SaveData)** 만 활성. Edit/Insert/Delete/Save/OK case 전부 주석 | 393~426 |

### 7.5 팝업6 `DMF0044_SalesReportExchangePopup` (721행)

| 구분 | 내용 | 라인 |
|---|---|---|
| 진입 게이트(메인) | Edit 모드 중 → `MSG00142` 차단, 버전 미선택 → `MSG00281` 차단 | (메인) 1428~1438 |
| 권한 | NowGroupID ∈ {ADMIN, DM ADMIN} 3중 게이트: 버튼 숨김(L148~162) / Edit 차단 MessageBox(L332~340) / Save 차단 `MSG00096`(L395~404) + `IsPopup=true`(L143) | — |
| 검증 | 신규(I) 행 필수값: DIVISION_ID/CURRENCY/UNIT_CURRENCY 빈값 → `MSG00002` [항목명] + 해당 행 포커스 이동 | 479~514 |
| 검증 | 변경 수집: **ForeColor==Red 셀만** 저장 대상. EXCHANGE_PRICE "" → "0" 치환, "0" → action 'D'(삭제) | 529~557 |
| 검증 | 유효 Price 전무(전부 0/빈) → `MSG00002` [EXCHANGE_PRICE] | 562~571 |
| 결과 | result != "success" → 오류 문자열 조립 MessageBox "Error!" / success → `MSG00004`(iCUD_R) + 재조회 | 591~609 |
| 잠금 | L-26(키 4컬럼 Edit 재잠금), L-27(조회 전체), L-28(신규 CURRENCY 셀=KRW 고정), L-29(**과거연도 조회 시 현재월 이전 기간 입력 차단**) | 346, 429, 628, 645 |
| 저장 SP | `DM.DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT` — p_active_flag, p_division_id, p_version_no(=_sVersionNo=메인 버전), p_YYYYMMDD(컬럼태그 D 제거), p_CURRENCY, p_UNIT_CURRENCY, p_EXCHANGE_PRICE, p_CREATED_BY, p_LAST_UPDATED_BY (셀 단위 `^` 누적) | 546~554, 579~589 |
| 조회 SP | `DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP` + `..._POPUP_DATA` 2단 조회 후 셀 매핑, 헤더 `DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE`(p_year) | 263~265, 426, 441 |
| InsertRow 기본값 | CURRENCY="KRW" 고정+잠금, DIVISION_ID 는 MyDivision 콤보 | 620~628 |

### 7.6 팝업7 `DMF0044_SalesReport_TextboxPopup` (453행) — Division 82 전용 버튼 경유

| 구분 | 내용 | 라인 |
|---|---|---|
| 진입 게이트(메인) | Division=='82' 일 때만 버튼 노출(§1 D-1/D-4), 버전 미선택 → `MSG00281` | (메인) 181, 1464, 1470~1473 |
| 권한 | NowGroupID ∈ {ADMIN, DM ADMIN} 3중 게이트: 버튼 숨김(L114~128) / Edit 차단 MessageBox(L189~198) / Save 차단 `MSG00096`(L215~224) + `IsPopup=true`(L112) | — |
| 검증 | 저장 결과: success → `MSG00004`(1) + 재조회 / Tables.Count≠1 → `MSG00006` / 첫 컬럼명 ERR_MSG → 서버 MSG passthrough / 그 외 → `MSG00006` | 345~363 |
| 잠금 | L-30 (조회 후 1~끝 잠금, Edit=SwitchLock 해제). Edit 시 행 0건이면 자동 Insert | 200~210, 266 |
| 기간 축 | 13개 월 컬럼 (DESCRIPTION1~13). 기준월 sMonday = DB `MONDAY`(Tables[1]) 있으면 그 값, 없으면 이번주 월요일 | 140~165, 259~263 |
| 조회 SP | `DMF0044_GET_TEXTBOX` (P_VERSION_NO) | 247~248 |
| 저장 SP | `DM.DMF0044_SAVE_TEXTBOX` — P_VERSION_NO, P_YYYYMM(=sMonday yyyyMM), P_DESCRIPTION1~13, P_CREATED_BY (마지막 행 값만 저장 — 루프가 변수를 덮어씀 L302~317) | 282~343 |
| 셀 속성 | 13개 컬럼 Multiline + MaxLength 8000, 행 높이 300 | 427~451 |

---

## 8. 메인 sDataType(Data Type) 게이트 — 저장 SP 이원화 (참고: FCST_TYPE 아님)

`usrDataType` (lookup `MDF_TYPE2`): "ALL" / "1"(Cutoff Data) / "2"(ETC Data) — L50 주석 실측.

| 조건 | 동작 | 라인 |
|---|---|---|
| Edit 시 `sDataType == "ALL"` | `MSG00321` 편집 차단 | 272~276 |
| Save 시 `sDataType == "ALL"` | `MSG00321` 저장 차단 | 510~514 |
| `sDataType == "2"` (ETC) | 2행(세트) 단위 루프(i+=2), action 빈쌍 skip, Red 셀만 수집, Department 필수(`MSG00002`), SP `DM.DMF0044_SAVE_SALES_PLAN_REPORT_C` (21 파라미터, `^` 구분) | 515~715 (SP 656) |
| `sDataType == "1"` (Cutoff) | 1행 단위 루프, **action=='M' 만** 대상, Red 셀만 수집, Department 필수, 컬럼 부재 시 빈값 방어(`GetColumnIndex>0` 3항), SP `DM.DMF0044_SAVE_SALES_PLAN_REPORT_C_CF` (25 파라미터: +p_scm_site_id, p_project_code, p_fcst_type, p_incoterms) | 716~967 (SP 904) |
| InsertRow 시 `usrDataType != "2"` | 행추가 차단 (ETC Data 만 행추가 허용) | 972~974 |
| 저장 결과 공통 | row[0]=="success" → `MSG00004`(iCount)+재조회 / Tables 있으면 서버 MSG passthrough / 그 외 `MSG00004`+viewport 유지 재조회 | 683~700, 935~952 |

---

## 9. 비활성 인벤토리 (주석 처리 코드 — 승계 판단용)

| 파일 | 내용 | 라인 |
|---|---|---|
| 메인 | EditButton EDIT_FLAG='Y' 행의 개별 컬럼 LockRange 5건 (VERSION_NO/DIVISION_ID/ITEM_NAME/EDIT_FLAG/MEASURE) — 현행은 L327 범위 잠금 1건으로 대체 | 322~326 |
| 메인 | Delete 시 action=='I' 만 허용 가드 | 258~259 |
| 메인 | ETC 저장 루프의 짝수행 개별 수집(구 로직) 대량 주석 + Cutoff 저장의 2행세트 잔재 (`p_division_id + "^" + "40"` 하드코딩 포함) | 610~612, 861~893 (877) |
| 메인 | InsertRow COMPANY_ID LockRange | 1004~1005 |
| 메인 | `YearSet` 구 로직 (−5y~+10y 로컬 생성) — [E20250107-000806] 로 DB 실측 목록으로 대체 | 1070~1084 |
| 메인 | btnSPVer 의 구 팝업 호출 (`DMF0044_Sales_VersionPopUp` + sCUTOFF_YYYYMMDD 수신) — United 로 대체되며 **CUTOFF 수신 경로 소실** | 1156~1163 |
| 메인 | ExchangeRate 팝업 blnOK 후속 처리 (FuturePrice 재조회) | 1446~1454 |
| 메인 | InsertRow 팀 콤보 구소스 (`DMF0044_ETC_SALE_RESULT_TYPE_40`) — 현행 `DMF0044_DEPARTMENT_TEAM2` | 989 |
| 팝업2 | `SaveData` 전체가 미배선 dead code: `FoxDataRequest("")` 빈 SP 명, ALL 확장(L244), `MSG00151` — 호출하는 버튼 case 없음 | 241~291 |
| 팝업2 | LoadData 의 SP_W 분기 (layoutControlItem6 노출 조건) | 121~124 |
| 팝업4 | EditButton 잠금 (Column1~Column3 LockColumn) | 202~209 |
| 팝업4 | `SingleCheck` 구 선택검증 (GetSelections + MSG00279) — 현행 giRowIndex 하이라이트로 대체 | 325~345 |
| 팝업4 | SaveData 빈 본문 (액션 버튼으로 대체) | 261~264 |
| 팝업5 | EditButton 잠금 2건 (LockColumn + 전월까지 잠금 로직) | 210~233 |
| 팝업5 | InsertRow 잠금 1건 (LockRange 과거 잠금) 포함 전체 로직 | 355~383 |
| 팝업5 | 버튼 배선: Edit/Insert/Delete/Save/OK case 주석 | 400~415, 419~421 |
| 팝업6 | `InitSpread_X` 전체 (직접 SQL `SCM_SYS_CALENDAR_M` 헤더 구성 구버전) — 미호출 dead method | 176~246 |
| 팝업6 | EditButton 의 BP/연도별 과거 잠금 로직 (LockColumn 3건: L357, 369, 383) | 347~388 |

비활성 Lock 호출 합계: **13건** (메인 6 = L322~326 5 + L1004 1 / 팝업4 1 / 팝업5 3 / 팝업6 3).

---

## 10. 축별 카운트 (최종)

| 축 | 활성 건수 | 비고 |
|---|---:|---|
| 1. Division 축 | 6 | 값 비교 = "82"(버튼 노출 2곳) + "40"(편집 완화 2곳) + ALL 확장 2곳. 81계열 비교 없음. 비활성 2건(주석 "40" 하드코딩, 팝업2 dead ALL 확장) |
| 2. 권한 축 | 20 | 이중 게이트 확인: EDIT_FLAG 행 계산(A-2/A-3) + MyDivision 편집권한 뷰(A-1). NowGroupID 값 비교(ADMIN/DM ADMIN)는 팝업6·7에서만 6곳 |
| 3. Measure/컬럼 축 | 8 | LOC / RTF·Business_Plan / 기타 3분기 + InsertRow 강제 세팅 + 빈값→0 + 부서·팀·아이템 cascade 3건 |
| 4. 기간·버전 축 | 26 | 메인 13(V-1~V-13) + United 게이트 10(V-14~V-23) + 팝업4종 버전축 비교표(§4.2). "Current" 취급·기본 버전 = 4팝업 모두 없음. 과거 잠금 = 메인 EditButton(구간계산) + 팝업6 InsertRow 만 활성 |
| 5. FCST_TYPE 축 | 0 | 비교 없음 (Cutoff 저장 pass-through 2곳뿐) |
| 6. 잠금(Lock) 전수 | 30 | 메인 21 + 팝업 9 (LockRange 22 + LockColumn 8). 비활성 13건 별도 |
| 7. 팝업 제약 (MSG 게이트) | 41 | 메인 MSG 14곳(00321×2, 00283, 00281×3, 00002×2, 00004×4, 00142, passthrough×2) + 팝업2 7곳 + 팝업3 10곳 + 팝업4 10곳 + 팝업5 1곳 + 팝업6 6곳 + 팝업7 6곳 중 팝업 합계 (메인분 제외 시 40곳; §7 각 표 전수) |
| 8. Data Type 게이트 | 6 | ALL 차단 2 + ETC/Cutoff 저장 SP 이원화 2 + InsertRow ETC 전용 1 + Cutoff 'M' 전용 수집 1 |
