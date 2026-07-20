# DMF0021 Sales Plan — 제약매트릭스 상세 (AS-IS 소스 전수 실측)

| 항목 | 내용 |
|---|---|
| 원천 파일 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.cs` (5,643행 전량 Read) |
| 소스 기준 | [E20260331-000648] (2026-04-01) + [E20260512-000502] (2026-05-12) 반영 최신본 (최신 GSCM 폴더 정본) |
| 추출 방식 | 전 행 전수 스캔 — 활성 코드만 본문 표, 주석 처리분은 §8 비활성 인벤토리 분리 |
| 작성일 | 2026-07-20 |

**Division 판정 소스 4종 (혼용 주의)** — 동일 화면 안에서 4가지 소스가 섞여 쓰임:
1. `CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues)` — 조회조건 단일 체크값 (EditButton/SaveData 필수컬럼 체크)
2. `clbDivision.SelectedValue.ToString()` — 조회조건 선택값 (편집 시작점·InsertRow·ComboSelChange 기간 분기)
3. `clbDivision.ControlValues` — 원시 컨트롤 값 (⭐ E20260331 81 RTF 확장 조건 L1041·1044, fnValidation)
4. 행(row)의 `DIVISION_ID` 셀 값 — `siMain.GetValue(i, DIVISION_ID)` (행별 편집 판정 L990·1041, 저장 검증 L2225~)

---

## 1. Division 축 — division 비교 분기 전수 (활성)

표기: **40**=소형, **81계열**=`Substring(0,2)=="81"` (자동차), **82**=ESS. "—"=해당 분기 무영향.

### 1.1 조회조건 초기화 / 콤보 소스

| 위치(메서드) | 조건 | 40 | 81계열 | 82 | 라인 |
|---|---|---|---|---|---|
| InitControls | `sDivision == "40"` | BizType·EndCustomer 40전용 fetch. **Project 라벨·입력(layoutControlItem3)·PlantSite 라벨 비활성**, `txtProject=""`, `clbPlantSite=""` | else: Project·PlantSite 활성 | else 동일 | 446~486 |
| clbDivision_SelectedIndexChanged | `sDivision == "40"` | 위와 동일 세트 재적용 (Project·PlantSite 비활성 + 값 클리어) | else 활성 | else 활성 | 5162~5202 |
| clbTeam_SelectedIndexChanged | `Substring(0,2)=="81" \|\| =="82"` | else 분기: EndCustomerByDivision(division, clbTeam.ControlValues) → SalesSite | EndCustomerByDivision(division, sTeam) → UserSiteByEndCustomer | 81과 동일 분기 | 5343~5384 |
| btnProject_Click | `Substring(0,2)=="81" \|\| =="82"` | **팝업 미호출** (40은 Project 개념 없음) | SCM0002_ProjectbyDivisionPopupEx 호출 | 동일 호출 | 3531~3545 |

### 1.2 EditButton — 필수 컬럼 존재 체크 (수정 모드 진입 게이트)

| 위치(메서드) | 조건 | 40 | 81계열 | 82 | 라인 |
|---|---|---|---|---|---|
| EditButton | `!= "40" && PROJECT_CODE == -1` | 면제 (40은 프로젝트 없음) | 필수 | 필수 | 710 |
| EditButton | `== "40" && END_CUSTOMER40 == -1` | END_CUSTOMER40 필수 | — | — | 711 |
| EditButton | `!= "40" && END_CUSTOMER == -1` | — | END_CUSTOMER 필수 | 필수 | 712 |
| EditButton | `Substring(0,2)=="81" && TEXT == -1` | — | TEXT 필수 | — | 715 |
| EditButton | `== "40" && DEPT_ID == -1` | Team(부서) 필수 | — | — | 721 |
| EditButton | `== "40" && CELL_PROD_SITE_ID == -1` | CELL_PROD_SITE_ID 필수 | — | — | 722 |
| EditButton ⭐E20260512 | `Substring(0,2)=="81" && FROM_SITE_ID == -1` | — | FROM_SITE_ID 필수 | — | 723 |
| EditButton ⭐E20260512 | `Substring(0,2)=="81" && PLANT_SITE_ID == -1` | — | PLANT_SITE_ID 필수 | — | 724 |
| EditButton (실패 메시지) | `== "40" && DEPT_ID == -1` | MSG00429("Team") — 필수 입력 | else MSG00113 | else MSG00113 | 728~739 |
| EditButton (실패 메시지) | `== "40" && CELL_PROD_SITE_ID == -1` | MSG00113 | — | — | 732~735 |

- 공통 필수(무분기): DIVISION_ID·SCM_SITE_ID·ITEM_ID·DomExp·FcstType·INCOTERMS·MEASURE·CURRENCY (709, 713~714, 716~720)

### 1.3 EditButton — 편집 시작점 (당월 vs 익월)

| 위치(메서드) | 조건 | 40 | 81계열 | 82 | 라인 |
|---|---|---|---|---|---|
| EditButton (M_ 편집대상 수집) ⭐E20250520-000605 | `clbDivision.SelectedValue.Substring(0,2)=="40"` | `this_YYYYMM <= iCol` → **당월부터** list_EDIT_Month | else: `this_YYYYMM < iCol` → **익월부터** | 익월부터 | 771~803 |
| EditButton (W_ 편집대상 수집) | 공통 | `this_YYYYMMWW <= iCol` → **당주부터** (전 사업부 공통) | 동일 | 동일 | 806~819 |
| EditButton (40 Weekly CLEAR) | `Substring(0,2)=="40" && i_EditStartCol>0 && Monthly` | 당월이후~당주이전 W_ 컬럼도 list_EDIT_Week에 추가 (CLEAR 가능) | — | — | 908~921 |
| EditButton (행별 편집 허용) | `row DIVISION_ID=="40" && MEASURE=="Catch_Up"` | Catch_Up M+3 분기 진입 (§3) | — | — | 990 |
| EditButton ⭐E20260331 | `(row DIVISION_ID=="40" \|\| clbDivision.ControlValues.Substring(0,2)=="81") && ((SalesAmt_LOC&&권한) \|\| (RTF_SYS_RP&&권한))` `\|\| ((row DIVISION_ID != "40" \|\| Substring(0,2)=="81") && SalesAmt_LOC&&권한)` | RTF_SYS_RP+SalesAmt_LOC 편집 branch | **81 확장: 동일 branch 진입** (RTF_SYS_RP 편집 개방) | SalesAmt_LOC만 (2번째 절) | 1041~1045 |

### 1.4 SaveData — 필수 컬럼 / 행별 필수값 / 키 대체

| 위치(메서드) | 조건 | 40 | 81계열 | 82 | 라인 |
|---|---|---|---|---|---|
| SaveData 필수컬럼 | `!= "40" && PROJECT_CODE==-1` | 면제 | 필수 | 필수 | 2028 |
| SaveData 필수컬럼 | `== "40" && END_CUSTOMER40==-1` | 필수 | — | — | 2029 |
| SaveData 필수컬럼 | `!= "40" && END_CUSTOMER==-1` | — | 필수 | 필수 | 2030 |
| SaveData 필수컬럼 | `Substring(0,2)=="81" && TEXT==-1` | — | 필수 | — | 2033 |
| SaveData 필수컬럼 | `== "40" && DEPT_ID==-1` | 필수 | — | — | 2039 |
| SaveData 필수컬럼 | `== "40" && CELL_PROD_SITE_ID==-1` | 필수 | — | — | 2042 |
| SaveData 필수컬럼 ⭐E20260512 | `Substring(0,2)=="81" && FROM_SITE_ID==-1` | — | 필수 | — | 2043 |
| SaveData 필수컬럼 ⭐E20260512 | `Substring(0,2)=="81" && PLANT_SITE_ID==-1` | — | 필수 | — | 2044 |
| SaveData 미실패 시 MSG00113 | 상기 조합 | — | — | — | 2047 |
| SaveData 행별 필수값 | `sDivisionId==""` → "[Division]" | 공통 | 공통 | 공통 | 2225, 2236 |
| SaveData 행별 필수값 | `!="40" && sProjectCode==""` → "[Project Code]" | 면제 | 필수 | 필수 | 2225, 2238 |
| SaveData 행별 필수값 | `=="40" && sEndCustomer==""` → "[END_CUSTOMER]" | 필수 | — | — | 2226, 2250 |
| SaveData 행별 필수값 | `=="40" && sDeptId=="" && sMeasure!="Catch_Up"` → "[TEAM]" | Catch_Up 아닐 때만 Team 필수 | — | — | 2227, 2253 |
| SaveData 행별 필수값 | `Substring(0,2)=="81" && sText==""` → "[TEXT]" | — | 필수 | — | 2228, 2248 |
| SaveData 행별 필수값 | `=="40" && Catch_Up && sDomExp==""` → "[Customer Handbook]" | 필수 | — | — | 2231, 2255 |
| SaveData 행별 필수값 | `=="40" && Catch_Up && sFcstType==""` → "[FcstType]" | 필수 | — | — | 2232, 2257 |
| SaveData 행별 필수값 | `=="40" && Catch_Up && sIncoterms==""` → "[INCOTERMS]" | 필수 | — | — | 2233, 2259 |
| SaveData 행별 필수값 | `=="40" && sCellProdSiteId==""` → "[CellProdSiteID]" | 필수 | — | — | 2234, 2261 |
| SaveData (공통 무분기) | sScmSiteId/sItemId/sMeasure/sCurrency=="" → 각 라벨 | 공통 | 공통 | 공통 | 2229~2230, 2240~2246 |
| SaveData 실패 메시지 | MSG00002(sMsg) + 포커스 (i,2) 이동 | 공통 | 공통 | 공통 | 2266~2272 |
| SaveData 키 대체 | `sDivisionId != "40"`: PROJECT_CODE 사용, ""→"N" / else(40): **END_CUSTOMER40 값을 sProjectCode로 대입** | END_CUSTOMER40→ProjectCode 슬롯 | PROJECT_CODE ("N" 치환) | 동일 | 2371~2384 |
| SaveData TEXT 소스 | `sDivisionId.Substring(0,2)=="81"`: TEXT / else: TEXT4082 | TEXT4082 | TEXT | TEXT4082 | 2407~2425 |
| SaveData Catch_Up 음수 | `sDivisionId=="40" && sMeasure=="Catch_Up" && sPrice<0` → MSG00085("0") 후 중단 | 음수 저장 금지 | — | — | 2609~2621 |
| SaveData FROM_SITE_ID ⭐E20260512 | `FROM_SITE_ID 컬럼 존재 시` sCellProdSiteId ← FROM_SITE_ID 값 (**p_cell_prod_site_id 슬롯으로 전달**) | (컬럼 없음) | FROM_SITE_ID→CellProdSiteId 대입 | (컬럼 없음) | 2173~2175, 2474~2476 |

### 1.5 InsertRow — 신규 행 division 분기

| 위치(메서드) | 조건 | 40 | 81계열 | 82 | 라인 |
|---|---|---|---|---|---|
| InsertRow | `sDivision=="40" && DEPT_ID 존재` | Team 셀 = dtTeamAuth 콤보 (입력 가능) | else: DEPT_ID **잠금** | 잠금 | 2923~2931 |
| InsertRow | `sDivision != "40"` | MEASURE 편집 가능 (SalesAmt_LOC↔Catch_Up 전환 허용) | MEASURE **잠금** (SalesAmt_LOC 고정) | 잠금 | 2968~2971 |
| InsertRow 기간 잠금 (작월 조회) | `Substring(0,2)=="40"` | MEASURE+1 ~ i_EditStartCol-1 잠금 (**당월부터 열림**) | Monthly: ~i_EditStartCol 잠금 (**당월 포함 잠금 = 익월부터**) / Weekly: this_YYYYMMWW 존재 시 ~i_EditStartCol-1 잠금 | 81과 동일 | 3271~3287 |
| InsertRow 기간 잠금 (당월~미래 조회) | `Substring(0,2)=="40"` | 첫 컬럼 unlock | 첫 M_ > 당월이면 unlock, 아니면 잠금 (M+1 원칙) | 동일 | 3289~3302 |
| InsertRow ITEM_ID 콤보 | `sDivision=="82"` / `Substring(0,2)=="81"` / `=="40"` | GUBUN='40' | GUBUN='81' | GUBUN='82' | 3341~3352 |

### 1.6 spdMain_ComboSelChange — 셀 콤보 연쇄

| 위치(메서드) | 조건 | 40 | 81계열 | 82 | 라인 |
|---|---|---|---|---|---|
| DIVISION_ID 변경 → PLANT_SITE_ID | `sDivision.Substring(0,2) != "81"` | 잠금 | **unlock** (81만 PlantSite 입력) | 잠금 | 4576~4587 |
| DIVISION_ID 변경 → ITEM_ID 콤보 | 82 / 81 / 40 | GUBUN='40' | GUBUN='81' | GUBUN='82' | 4591~4603 |
| DIVISION_ID 변경 → 연쇄 클리어 | 공통 | DEPT_ID·END_CUSTOMER·SCM_SITE_ID·PROJECT_CODE·PROJECT_NAME·ITEM_ID·TEXT·ITEM_CLASS_NAME 클리어 | 동일 | 동일 | 4605~4621 |
| END_CUSTOMER 변경 → ITEM_ID | 82 / 81 / 40 | GUBUN='40' | GUBUN='81' | GUBUN='82' | 4693~4705 |
| END_CUSTOMER40 변경 → ITEM_ID | 82 / 81 / 40(+`MEASURE != "Catch_Up"` 조건) | **Catch_Up 행은 콤보 바인딩 금지** (팝업 유지) | GUBUN='81' | GUBUN='82' | 4730~4748 |
| SCM_SITE_ID 변경 → ITEM_ID | 82 / 81 / 40(+`MEASURE != "Catch_Up"`) | Catch_Up 행 바인딩 금지 | GUBUN='81' | GUBUN='82' | 4750~4770 |
| MEASURE 변경 → 편집 시작점 | `Substring(0,2)=="40" && MEASURE=="SalesAmt_LOC"` | Monthly: 당월 / else: 당주 포함 시작 | — | — | 4886~4903 |
| MEASURE 변경 → 기간 잠금 (작월 조회) | `Substring(0,2)=="40"` | ~i_EditStartCol-1 잠금 (당월 열림) | ~i_EditStartCol 잠금 (M+1) | 동일 | 5042~5051 |
| MEASURE 변경 → 기간 잠금 (당월~) | `Substring(0,2)=="40"` | i_EditStartCol unlock | 첫 M_ > 당월이면 unlock, else 잠금 | 동일 | 5052~5066 |

### 1.7 기타 이벤트

| 위치(메서드) | 조건 | 40 | 81계열 | 82 | 라인 |
|---|---|---|---|---|---|
| spdMain_CellDoubleClick | `sDivision=="40" && sMeasure=="Catch_Up" && ITEM_ID 컬럼` | DM0002_ItembyDivisionPopupEx 팝업 (sTeam/sEndCustomer 기본 "ALL", sMdmActive_Sw="Y") | — | — | 3903~3954 |
| spdMain_CellDoubleClick (PROJECT_CODE) | Action=='I' 행 한정 | — | 프로젝트 팝업 → PROJECT_NAME/Status/BizTypeName/Owner 세팅 + ITEM_ID·ITEM_CLASS_NAME 클리어 | 동일 | 3874~3901 |

> **fnValidation (4183~4315)** 내부에도 division 분기 6곳(4203, 4211, 4230, 4235, 4254, 4287) 존재하나 **호출부가 주석 처리되어 미호출(dead code)** — [PJ2024-50611] 중복체크 SP 이관 (2277~2298). §8 참조.

**Division 축 활성 비교 지점 합계: 73곳** (1.1 = 4 / 1.2 = 10 / 1.3 = 5 / 1.4 = 29 / 1.5 = 9 / 1.6 = 13 / 1.7 = 2 + 공통 무분기 항목 1)

---

## 2. 권한 축 — bEDIT_AUTH_SalesAmt_LOC / bEDIT_AUTH_RTF_SYS_RP 전수

권한 원천: 조회 SP(`DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx`) 결과 **`dsMain.Tables[2]`** 의 `EDIT_AUTH_SalesAmt_LOC` / `EDIT_AUTH_RTF_SYS_RP` 컬럼 ('Y'/'N'). [PJ2025-50017] GET_ADMIN_GROUP_MEASURE LOOKUP.

그룹별 권한 정의 (소스 주석 명세, 930~935 / 2871~2875):
- ADMIN(기타매출, RTF) / SCP PI ADMIN(기타매출, RTF) / SCP Planner(RTF) / DM Planner(기타매출) / DM ADMIN(기타매출)

| 기능 | 권한 조건 | 효과 | 라인 |
|---|---|---|---|
| EditButton — Tables[2] 소비 | `dsMain != null && dsMain.Tables.Count >= 3` → `dt = dsMain.Tables[2].Copy()` | `EDIT_AUTH_SalesAmt_LOC=='Y'` → bEDIT_AUTH_SalesAmt_LOC=true / `EDIT_AUTH_RTF_SYS_RP=='Y'` → bEDIT_AUTH_RTF_SYS_RP=true. 기본값 둘 다 false (컬럼/테이블 부재 시 편집 불가) | 939~953 |
| EditButton — 편집행 판정 1 | `MEASURE=="SalesAmt_LOC" && bEDIT_AUTH_SalesAmt_LOC && FcstType=="ETC"` ⭐E20260331 | SALES_PLAN_ADJUST_YN=="N_Y" 행 중 편집 후보 진입 | 968 |
| EditButton — 편집행 판정 2 | `MEASURE.ToUpper()=="RTF_SYS_RP" && bEDIT_AUTH_RTF_SYS_RP` | 편집 후보 진입 (Catch_Up 은 권한 무관 970) | 971 |
| EditButton — division 결합 판정 | `(40 \|\| 81) && ((SalesAmt_LOC && bAuth) \|\| (RTF_SYS_RP && bAuthRTF))` / `(비40 \|\| 81) && (SalesAmt_LOC && bAuth)` | 락 해제(LockRange false) branch 진입 | 1041~1045 |
| **InsertButton 게이트** | `dsMain.Tables[2]` 재조회 → `bEDIT_AUTH_SalesAmt_LOC == false` | **`return` — Insert(신규 행) 자체 차단** (기타매출 권한자만 Insert). RTF 권한은 Insert 와 무관 | 2877~2893 |
| 조회 SP 파라미터 (JV Planner) | `p_user_dept_id = UserInfoContext.Current["Dept_ID"]` | [과제] 자동차 JV Planner 권한 체크를 SP 측에서 수행 | 1572 |
| EditButton — 팀 권한 조회 | `Data.UserTeamByDivisionAuth(NowGroupID, UserId, division)` | dtTeamAuth 취득 (EditButton 내 후속 사용처 없음 — 취득만) | 880 |
| InsertRow — 권한 콤보 3종 | `UserTeamByDivisionAuth` / `UserSiteByEndCustomerAuth` / `UserEndCustomerByDivisionDeptAuth` | 신규 행 Team/SalesSite/EndCustomer 콤보를 **권한 범위로 제한** | 2910~2912, 2920 |
| ComboSelChange — 권한 콤보 | DIVISION_ID 변경: `UserTeamByDivisionAuth`(4546)·`UserEndCustomerByDivisionDeptAuth`(4554)·`UserSiteByEndCustomerAuth`(4572) / END_CUSTOMER 변경: `UserSiteByEndCustomerAuth`(4690) | 연쇄 콤보를 권한 범위로 재바인딩 | 4546, 4554, 4572, 4690 |

**권한 축 합계: bEDIT_AUTH_SalesAmt_LOC 소비 4곳(968, 1042, 1045, 2889) / bEDIT_AUTH_RTF_SYS_RP 소비 2곳(971, 1043) / Tables[2] 소비 2곳(944, 2882) / Insert 게이트 1곳 / Auth 계열 데이터 호출 7곳**

---

## 3. Measure 축 — MEASURE 값 비교 전수

### 3.1 SalesAmt_LOC (기타매출)

| Measure | 위치 | 제약 | 라인 |
|---|---|---|---|
| SalesAmt_LOC | EditButton | 편집 조건: 권한 + ⭐**FcstType=="ETC" 한정** (E20260331 추가 — ETC 아닌 SalesAmt_LOC 행은 편집 불가) | 968 |
| SalesAmt_LOC | EditButton | division 결합 편집 branch (§1.3) | 1042, 1045 |
| SalesAmt_LOC | InsertRow | 신규 행 MEASURE 기본값 "SalesAmt_LOC" 세팅 (dtMearsure 콤보) — 비40은 잠금 고정 | 2960~2971 |
| SalesAmt_LOC | spdMain_LeaveCell | 표시 포맷 소수 3자리 `###,###,###,##0.000` (iMeasureType=3) | 4410~4413, 4423~4425 |
| SalesAmt_LOC | ComboSelChange (40) | 40 && SalesAmt_LOC → 당월(Monthly)/당주(Weekly) 포함 편집 시작 | 4886~4903 |
| SalesAmt_LOC(전환 복귀) | ComboSelChange | Catch_Up→SalesAmt_LOC 복귀 cascade (§3.3 #17~#24) | 4980~5103 |

### 3.2 Catch_Up (40 전용)

| Measure | 위치 | 제약 | 라인 |
|---|---|---|---|
| Catch_Up | EditButton | 권한 무관 편집 후보 (SALES_PLAN_ADJUST_YN=="N_Y" 행) | 970 |
| Catch_Up | EditButton | `row DIVISION_ID=="40" && Catch_Up` → **M+3 이후만 편집** (`YYYYMM >= DateTime.Now.AddMonths(3)`), 미만이면 전 구간 잠금 | 990~1037 |
| Catch_Up | SaveData | `40 && DeptId=="" && Measure != "Catch_Up"` → Catch_Up이면 Team 빈값 허용 (Team 수정 금지 설계) | 2227, 2253 |
| Catch_Up | SaveData | 40 && Catch_Up 시 DomExp·FcstType·INCOTERMS 필수 | 2231~2233 |
| Catch_Up | SaveData | **음수 입력 불가**: `sPrice < 0` → MSG00085("0") 저장 중단 | 2609~2621 |
| Catch_Up | CellDoubleClick | 40 && Catch_Up && ITEM_ID → 모델 팝업(DM0002_ItembyDivisionPopupEx) 호출 | 3903~3954 |
| Catch_Up | ComboSelChange (END_CUSTOMER40) | Catch_Up 행은 ITEM_ID GUBUN='40' 콤보 바인딩 금지 (팝업 유지) | 4742~4745 |
| Catch_Up | ComboSelChange (SCM_SITE_ID) | 동일 바인딩 금지 | 4764~4767 |
| Catch_Up | ComboSelChange (MEASURE) | Catch_Up 전환 cascade (§3.3 #1~#16) | 4905~4979 |

### 3.3 Measure 전환 cascade 규칙 전수 (ComboSelChange MEASURE 분기, 4814~5120) — 25규칙

**Catch_Up 전환 시 (4905~4979):**
| # | 규칙 | 라인 |
|---|---|---|
| 1 | ITEM_ID 값 초기화 | 4909 |
| 2 | ITEM_ID 셀타입 = 이미지(팝업 호출형 cellTypeImage) | 4910 |
| 3 | DomExp 값 초기화 | 4915 |
| 4 | DomExp 콤보 = dtCustomsHandbook (DM_CUSTOMS_HANDBOOK) | 4916 |
| 5 | DomExp unlock (입력 개방) | 4917 |
| 6 | INCOTERMS 값 초기화 | 4933 |
| 7 | INCOTERMS 콤보 = GetIncotermsType(division, scmSite) (AS_INCOTERMS) | 4934~4935 |
| 8 | INCOTERMS unlock | 4936 |
| 9 | FcstType 값 초기화 | 4941 |
| 10 | FcstType 콤보 = dtFcstType (**ETC 제외** — GetFcstType `CODE <> 'ETC'` 필터, 5595) | 4942 |
| 11 | FcstType unlock | 4943 |
| 12 | DEPT_ID(Team) 값 초기화 | 4950 |
| 13 | DEPT_ID **잠금** (catch-up 입력 시 팀 수정 금지) | 4951 |
| 14 | 숫자컬럼: D_ 제외 & `YYYYMM >= 현재+3개월` 컬럼만 unlock | 4959~4967 |
| 15 | 숫자컬럼: M+3 미만 컬럼 잠금 | 4968~4971 |
| 16 | 편집 시작 불가(과거 구간)이면 MEASURE+1~끝 전체 잠금 | 4974~4977 |

**SalesAmt_LOC(비 Catch_Up) 복귀 시 (4980~5103):**
| # | 규칙 | 라인 |
|---|---|---|
| 17 | FcstType = "ETC" 고정 + Text 셀타입 전환 + 잠금 | 4983~4988 |
| 18 | DomExp 초기화 + 잠금 | 4990~4994 |
| 19 | INCOTERMS 초기화 + 잠금 | 4996~5000 |
| 20 | DEPT_ID 초기화 + **unlock** (ETC는 팀 입력 가능) | 5004~5008 |
| 21 | ITEM_ID 셀타입 해제(null) + 초기화 + GUBUN='40' 콤보 재바인딩 | 5010~5015 |
| 22 | NickName 초기화 | 5017~5020 |
| 23 | 숫자컬럼 전체 unlock 후 기간 분기 재잠금 (40 당월/비40 M+1/과거 전체잠금) | 5031~5071 |
| 24 | D_ 잠금 + 버킷 교차 잠금 (Monthly→W_ 잠금 / Weekly→M_ 잠금) | 5074~5099 |

**공통 후처리:**
| # | 규칙 | 라인 |
|---|---|---|
| 25 | 메저 전환 시 기존 숫자 입력값 전체 초기화(`SetValue ""`) + D_ 재잠금 | 5106~5116 |

### 3.4 RTF_SYS_RP (⭐ E20260331 81 확장)

| Measure | 위치 | 제약 | 라인 |
|---|---|---|---|
| RTF_SYS_RP | EditButton | `ToUpper()=="RTF_SYS_RP" && bEDIT_AUTH_RTF_SYS_RP` 편집 후보 | 971 |
| RTF_SYS_RP | EditButton ⭐E20260331 | 편집 branch division 조건에 81 계열 OR 추가 → **81 사업부도 RTF_SYS_RP 편집 가능** | 1041, 1043~1044 |
| RTF_SYS_RP | EditButton (Monthly) | **당월 수정 불가**: 조회 시작월 <= 당월일 때 `M_ < 현재+1개월` 컬럼 잠금 (M+1부터) | 1066~1080 |
| RTF_SYS_RP | spdMain_LeaveCell | **음수 불가** (RMA 예외): `FcstType != "RMA" && Val < 0` → 값 삭제(빈칸). RMA는 음수만 저장 가능(주석 명세) | 4393~4402 |
| RTF_SYS_RP | spdMain_LeaveCell | **정수 강제**: 포맷 `###,###,###,###` (iMeasureType=1) + 소수점 이하 절사(`Val.Substring(0, IndexOf('.'))`) | 4406~4409, 4419~4421, 4428~4435 |

### 3.5 조회전용 Measure 취급

- 편집 가능 Measure는 소스상 **SalesAmt_LOC / Catch_Up / RTF_SYS_RP 3종의 명시 비교뿐** (968~971). 그 외 Measure(RTF, MKT_FCST 등 조회전용 전량)는 명칭 비교 없이 **FindData 의 `LockColumn(0, max, true)` (1592) + EditButton 초기 전체 잠금(750) 이후 락 해제 대상에서 제외**되는 방식으로 조회전용 처리.
- 조회전용 Measure 의 정확한 종수(28종 등)는 서버 데이터(`DM.DMF0021_GET_SALES_PLAN_MEASUREINFO`, 3504~3515 + TitleSet 팝업 설정)가 결정 — **본 .cs 소스에서는 열거 불가** (추출 한계 명시).
- 표시 포맷은 Measure 명이 아닌 행의 `NOTATION` 값(INTEGER/POINT/POINT3)으로 결정 — Draw() 1703~1781.
- `SALES_PLAN_ADJUST_YN == "N_Y"` 행만 편집 후보 (963~964) — 그 외 값 행은 Measure 무관 잠금 유지.
- Dsdm_Changed: MEASURE 셀이 빈 행은 숫자 입력 즉시 취소(`SetText ""`) — 3980~3985.

**Measure 축 활성 비교 지점 합계: MEASURE 값 비교 22곳** (968, 970, 971, 990×2, 1042, 1043, 1045, 1067, 2227, 2231~2233(sMeasure=="Catch_Up" 3), 2609, 2961(세팅), 3903, 4398, 4406, 4410, 4428, 4742, 4764, 4886, 4905) **+ 전환 cascade 25규칙**

---

## 4. 기간·버킷 축

### 4.1 편집 시작점·과거 판정

| 규칙 | 조건 | 대상 | 라인 |
|---|---|---|---|
| M_ 편집 시작 — 40 당월 | `Substring(0,2)=="40"`: `GetColumnIndex(this_YYYYMM) <= iCol` | list_EDIT_Month | 771~777 |
| M_ 편집 시작 — 비40 익월 | else: `GetColumnIndex(this_YYYYMM) < iCol` | list_EDIT_Month | 789~794 |
| 조회기간이 당월 이후 | `sPeriod[0] 월 > this_YYYYMM` → 모든 M_ 편집 대상 | list_EDIT_Month | 781~785, 798~802 |
| W_ 편집 시작 — 당주 | `GetColumnIndex(this_YYYYMMWW) <= iCol` (전 사업부 공통) | list_EDIT_Week | 806~809 |
| 조회기간이 당주 이후 | `sPeriod[0] 월 > this_YYYYMMWW 월` → 모든 W_ 편집 대상 | list_EDIT_Week | 810~819 |
| Edit 시작 컬럼 보정 | 첫 컬럼이 M_ 이면 +1 (M_ 뒤 W_ 항상 존재) | i_EditStartCol | 884~889 |
| **과거~과거 조회 = 전체 편집 불가** | 마지막 컬럼 W_ < 당주 → `i_EditStartCol = 0` | 시트 전체 | 891~898 |
| 동일 (Daily 말미) | 마지막 컬럼 D_ < 당주 월요일(sResult_YYYYMMDD) → 0 | 시트 전체 | 899~905 |
| 당주 존재 시 시작 컬럼 = 당주 | `GetColumnIndex(this_YYYYMMWW) >= 0` | i_EditStartCol | 924~927 |
| 편집 루프 게이트 | `i_EditStartCol > 0` 일 때만 행별 락 해제 수행 ([E20250520-000605] `>= 0`→`> 0` 수정) | 전 행 | 956~958 |
| 행별 편집 시작 컬럼 | Monthly → `list_EDIT_Month[0]` / Weekly → `list_EDIT_Week[0]` | j | 975~984 |
| 버킷-prefix 일치 검증 | `Weekly && W_` 또는 `Monthly && M_` 일 때만 unlock, 불일치 시 잠금 | 행 | 986, 996, 1048, 1031, 1100 |
| InsertRow — Monthly 당월 포함 | `Monthly && this_YYYYMM 존재` → 시작 = 당월 컬럼 | 신규 행 | 3223~3230 |
| InsertRow — Weekly 당주 포함 | `Weekly && this_YYYYMMWW 존재` → 시작 = 당주 / 부재 시 +1 | 신규 행 | 3232~3245 |
| InsertRow — 과거 조회 차단 | 마지막 W_ < 당주 → i_EditStartCol=0 → 전 구간 잠금 | 신규 행 | 3247~3251, 3303~3307 |
| InsertRow — 비40 M+1 unlock 판정 | 첫 M_ > 당월이면 unlock, 아니면 잠금 (25.07.04 주석: 신규 등록은 ETC+SALESAMT_LOC만, 비40은 M+1) | 신규 행 | 3288~3302 |
| ComboSelChange — 시작점 재계산 | 첫 컬럼 M_→당월 포함, W_→당주 포함, 마지막 W_ < 당주 → 0 (2회 검사) | 행 | 4854~4882 |
| FindData — 기간 역전 | `sPeriod[0] > sPeriod[1]` → MSG00108 | 조회 차단 | 1489~1493 |
| FindData — 기간 상한 | `Value1.AddYears(3) < Value2` → MSG00164 + Value2 보정 (주석은 "2년"이나 코드는 3년) | 조회 차단 | 1495~1503 |
| 과거-과거 첫달 회색 버그 보정 | `조회시작월 >= this_YYYYMM` → iResultMonth+1 | Draw | 1810~1814 |

### 4.2 버킷별 제약

| 규칙 | 조건 | 대상 | 라인 |
|---|---|---|---|
| **Daily = 편집 자체 불가** | `BucketType.Daily` → MSG00361 후 return | EditButton | 1116~1120 |
| Daily 컬럼 입력 차단 | Dsdm_Changed: `D_` 컬럼이면 return | 셀 입력 | 3976~3978 |
| Daily 저장 스킵 | SaveData: `D_` 컬럼 continue | 저장 | 2545~2550 |
| 버킷 교차 잠금 (편집) | Monthly 편집 시 모든 list_EDIT_Week 잠금 / Weekly 편집 시 모든 list_EDIT_Month 잠금 (Catch_Up branch 와 SalesAmt/RTF branch 각각) | 행 | 1007~1022, 1058~1089 |
| 버킷 교차 잠금 (Insert) | Monthly→W_ 잠금 / Weekly→M_ 잠금 + D_ 잠금 | 신규 행 | 3310~3337 |
| 버킷 교차 잠금 (Measure 전환) | 동일 세트 2회 (5074~5099, 5108~5116) | 행 | 5074~5116 |
| 버킷 교차 저장 스킵 | Weekly 인데 M_ / Monthly 인데 W_ → continue (동월 이중수정 중복 방지) | 저장 | 2557~2569 |
| **편집 중 버킷 변경 금지** | `!siMain.IsLock()` → MSG00227 | cboBucketType_Click | 5512~5521 |
| RTF_SYS_RP 당월 잠금 | Monthly && 조회시작월 <= 당월 && `M_ < 현재+1개월` → 잠금 | 행 | 1066~1080 |
| Catch_Up M+3 잠금 | `YYYYMM >= Now+3개월` 만 편집 | 행 | 990~1037, 4956~4977 |
| 컬럼 표시 — Daily | D_·W_ visible / M_·W_ = chkSum 연동 | SetSpreadColumn | 3638~3644 |
| 컬럼 표시 — Weekly | D_ 숨김 / W_ 표시 / M_ = chkSum | SetSpreadColumn | 3645~3654 |
| 컬럼 표시 — Monthly | D_·W_ 숨김 / M_ 표시 | SetSpreadColumn | 3655~3661 |
| 헤더 더블클릭 접기/펼치기 | M_ 헤더: 하위 W_(Daily 시 D_) 토글 / W_ 헤더: 하위 D_ 토글 | 컬럼 헤더 | 3789~3834 |
| 저장 시 팀 변경 전파 | 40: DEPT_ID 셀이 Red(수정)이면 해당 버킷(W_/M_) 숫자컬럼 전부 Red 처리(수정 간주) | 저장 | 2515~2543 |
| 저장 대상 판정 | 셀 ForeColor == Red 만 저장 (변경 추적) | 저장 | 2552~2555 |
| 빈값 저장 치환 | sPrice=="" → "0" ([E20251125-000694]) / action != "D" && sPrice=="0" → action "D" 강등 | 저장 | 2585~2604 |
| 저장 0건 검증 | iDateCount==0 → MSG00146(행번호) | 저장 | 2695~2700 |

### 4.3 당주/전주 색·보더

| 규칙 | 조건 | 대상 | 라인 |
|---|---|---|---|
| 색상 모드(chkColor=true) — 과거 회색 | 전주(pre_YYYYMMWW)까지 `Color.Gainsboro` 배경 | EditButton | 824~829 |
| 색상 모드 — 당월 White 복원 | this_YYYYMM 컬럼 White | EditButton | 831~835 |
| 보더 모드(chkColor=false) — 당주 초록 | `BevelBorder(Raised, Green, Green, 3)` 당주 컬럼. [E20250520-000605] 조회기간 > 당주 시 sResult_YYYYMMWW 로 대체 (무한 라인 버그 조치) | EditButton | 837~864 |
| Draw — 과거 구간 회색 | Daily: `D_ < 당주월요일` / Weekly: 전주(pre_YYYYMMWW) 매칭(52주차 특례 포함 1863~1866) / Monthly: `W_ < 당주` — iResultCol 까지 Gainsboro + 당월 White | Draw | 1833~1912 |
| Draw — 보더 모드 | 비Daily: 당주(this_YYYYMMWW) 또는 sResult_YYYYMMWW 초록 보더 / Daily: `D_+당주월요일` 보더 | Draw | 1914~1932 |
| 헤더 강조 — 당월/당주 | M_: 당월이면 ForeColor Green + 굴림 9 Bold + 폭 60 / W_: iso_week+당월 매칭 또는 this_YYYYMMWW → Green Bold | SetSpreadColumn | 3663~3691 |
| 색상 모드 시 헤더 리셋 | chkColor=true → ForeColor/Font 리셋 | SetSpreadColumn | 3692~3696 |
| 버킷 전환 시 보더 재설정 | Daily: D_ 보더 + 당주 W_ 보더 해제 / 비Daily: 당주 W_ 보더 + D_ 보더 해제 | cboBucketType_SelectedIndexChanged | 3589~3619 |
| 토·일 헤더 색 | DayCode SAT → Blue / SUN → Red | SetSpreadHeaderSpan | 3745~3748 |
| 주말/합계 푸터 | M_/W_/D_ 컬럼 SumIgnoreHidden + LightGray | InitSpreadFooterSum | 627~644 |

**기간·버킷 축 규칙 합계: 42건** (4.1 = 19 / 4.2 = 15 / 4.3 = 8)

---

## 5. FCST_TYPE 축 — 비교 전수

| 위치 | 조건/제약 | 라인 |
|---|---|---|
| EditButton ⭐E20260331 | `SalesAmt_LOC 편집은 FcstType=="ETC" 한정` — 수정라인 판정에 ETC 조건 추가 (원소스 주석 처리 후 교체) | 966~969 |
| InsertRow | 신규 행 `FcstType = "ETC"` 고정 세팅 + 잠금 | 2977~2981 |
| spdMain_LeaveCell | `RTF_SYS_RP && FcstType != "RMA" && Val < 0` → 값 삭제. **RMA 만 음수 허용** (DMF0082 로직 동일화 주석, RMA는 저장 시 음수만 허용) | 4384~4385, 4393~4402 |
| ComboSelChange (Catch_Up 전환) | FcstType 초기화 + dtFcstType 콤보(**ETC 제외**) + unlock — Catch_Up 은 ETC 외 FcstType 선택 | 4939~4944 |
| ComboSelChange (SalesAmt_LOC 복귀) | `FcstType="ETC"` 고정 + Text 셀타입 + 잠금 | 4983~4988 |
| GetFcstType | `dt.Select(" CODE <> 'ETC' ")` — Catch_Up 용 콤보에서 ETC 제외 (SalesAmt_LOC=ETC 이므로) | 5579~5596 |
| SaveData | 40 && Catch_Up && sFcstType=="" → "[FcstType]" 필수 | 2232, 2257 |
| SaveData | pFcstType '^' 연결 파라미터 → `p_fcst_type` 전달 | 2660, 2680, 2724 |

**FCST_TYPE 축 활성 비교/제약 지점 합계: 8곳** (값 비교 3: 968 "ETC" / 4398 "RMA" / 5595 "<> ETC" + 고정 세팅 2: 2979, 4985 + 콤보 제약 1: 4942 + 필수 1: 2232 + 전달 1)

---

## 6. 잠금(Lock) 전수 — LockRange / LockColumn 호출 전량 (활성 1건 1행)

전체 잠금 기반: `SwitchLock()` 747 → 이하 해제/재잠금. **활성 합계: LockColumn 2건 + LockRange 106건 = 108건.**

### 6.1 LockColumn (2건)

| # | 위치 | 대상 | Lock | 라인 |
|---|---|---|---|---|
| 1 | EditButton | 컬럼 0~max 전체 | true (편집 진입 시 전체 잠금 후 선별 해제) | 750 |
| 2 | FindData | 컬럼 0~max 전체 | true (조회 직후 전체 잠금) | 1592 |

### 6.2 LockRange — EditButton (13건)

| # | 대상/조건 | Lock | 라인 |
|---|---|---|---|
| 3 | Catch_Up·M+3·IsEditMode: 행 i, j~max 해제 | false | 1005 |
| 4 | Catch_Up·Monthly: list_EDIT_Week 각 컬럼 | true | 1012 |
| 5 | Catch_Up·Weekly: list_EDIT_Month 각 컬럼 | true | 1020 |
| 6 | Catch_Up·비편집모드 | true | 1026 |
| 7 | Catch_Up·버킷-prefix 불일치 | true | 1031 |
| 8 | Catch_Up·M+3 미만 | true | 1036 |
| 9 | SalesAmt_LOC/RTF·IsEditMode: 행 i, j~max 해제 | false | 1056 |
| 10 | SalesAmt_LOC/RTF·Monthly: list_EDIT_Week 각 컬럼 | true | 1063 |
| 11 | RTF_SYS_RP·Monthly: 당월(M+1 미만) 컬럼 | true | 1075 |
| 12 | SalesAmt_LOC/RTF·Weekly: list_EDIT_Month 각 컬럼 | true | 1087 |
| 13 | SalesAmt_LOC/RTF·버킷 판별 else | true | 1092 |
| 14 | SalesAmt_LOC/RTF·비편집모드 | true | 1096 |
| 15 | SalesAmt_LOC/RTF·prefix 불일치 | true | 1100 |

### 6.3 LockRange — InsertRow (69건)

**신규 행 고정 컬럼 잠금 (59건):**

| # | 대상 컬럼 | Lock | 라인 | # | 대상 컬럼 | Lock | 라인 |
|---|---|---|---|---|---|---|---|
| 16 | DIVISION_ID | true | 2917 | 46 | CUST_GROUP | true | 3080 |
| 17 | DEPT_ID (비40) | true | 2930 | 47 | CUST_GROUP_DTL | true | 3084 |
| 18 | MEASURE (비40) | true | 2970 | 48 | APPLICATION | true | 3088 |
| 19 | FcstType | true | 2980 | 49 | ROUTE | true | 3092 |
| 20 | TEAM_INCHARGE | true | 2985 | 50 | BIZ_TYPE_NAME40 | true | 3096 |
| 21 | PROJECT_NAME | true | 2987 | 51 | GROUP_ID | true | 3100 |
| 22 | ProjectStatus | true | 2989 | 52 | INTERNAL_YN | true | 3104 |
| 23 | PROJECT_OWNER | true | 2991 | 53 | CELL_TYPE | true | 3108 |
| 24 | BizTypeName | true | 2994 | 54 | FORECAST_INFO_CELL_PACK_COUNT | true | 3112 |
| 25 | ITEM_CLASS_NAME | true | 2998 | 55 | CELL_MODEL_INFO | true | 3116 |
| 26 | ITEM_NAME | true | 3000 | 56 | CELL_MODEL | true | 3120 |
| 27 | ItemType | true | 3003 | 57 | FORECAST_INFO_ALL | true | 3124 |
| 28 | SALES_COMPANY | true | 3007 | 58 | FORECAST_INFO_SPEC | true | 3128 |
| 29 | SALES_PLANT | true | 3009 | 59 | FORECAST_INFOR_VERSION | true | 3132 |
| 30 | NickName | true | 3012 | 60 | CELL_MODEL_NICK_NAME | true | 3136 |
| 31 | KwhCell | true | 3015 | 61 | MDM_PROJECT_NAME | true | 3140 |
| 32 | KwhModule | true | 3018 | 62 | MIN_CAPACITY | true | 3144 |
| 33 | KwhPack | true | 3021 | 63 | CELL_PER_CAR | true | 3148 |
| 34 | PLANT_SITE_ID | true | 3024 | 64 | CELL_PER_MODULE | true | 3152 |
| 35 | DomExp | true | 3030 | 65 | MODULE_PER_CAR | true | 3156 |
| 36 | SALES_PLAN_ADJUST_YN | true | 3038 | 66 | ENERGE | true | 3160 |
| 37 | INCOTERMS | true | 3040 | 67 | ENERGE_WH | true | 3164 |
| 38 | OWNER | true | 3045 | 68 | CELL_QUANTITY | true | 3168 |
| 39 | COUNTRY_NAME | true | 3048 | 69 | DMS_SALES | true | 3172 |
| 40 | CITY_NAME | true | 3050 | 70 | DMS_CUSTOMER | true | 3176 |
| 41 | FORECAST_INFO_PRODUCT_GROUP | true | 3052 | 71 | ShipmentSite | true | 3064 |
| 42 | VMI_YN | true | 3054 | 72 | COMPANY_ID | true | 3076 |
| 43 | ProjectName | true | 3058 | 73 | SCP_USE_YN [E20250423-000842] | true | 3184 |
| 44 | DistributionChannel | true | 3060 | 74 | **FROM_SITE_ID** ⭐E20260512 (표시 전용) | true | 3190 |
| 45 | CellName | true | 3062 | | | | |

(고정 컬럼 잠금 2917~3190 총 59건 = #16~#74. 좌우 2단 배치로 번호는 표기 편의이며, 실제 잠금 순서는 라인 오름차순)

**신규 행 기간/버킷 잠금 (10건):**

| # | 대상/조건 | Lock | 라인 |
|---|---|---|---|
| 75 | 기간 잠금(40, 작월 조회): MEASURE+1 ~ 시작-1 | true | 3275 |
| 76 | 기간 잠금(비40 Monthly): ~시작(당월 포함, M+1) | true | 3280 |
| 77 | 기간 잠금(비40 Weekly, 당주 존재): ~시작-1 | true | 3285 |
| 78 | 당월 시작 해제(40): MEASURE+1 ~ 시작 | false | 3292 |
| 79 | 시작 해제(비40, 첫 M_ > 당월) | false | 3298 |
| 80 | 시작 잠금(비40, 첫 M_ <= 당월) | true | 3301 |
| 81 | 과거 구간: MEASURE+1 ~ max 전체 | true | 3306 |
| 82 | D_ 컬럼 개별 | true | 3315 |
| 83 | Monthly 시 W_ 컬럼 개별 | true | 3324 |
| 84 | Weekly 시 M_ 컬럼 개별 | true | 3333 |

### 6.4 LockRange — spdMain_ComboSelChange (24건)

| # | 대상/조건 | Lock | 라인 |
|---|---|---|---|
| 85 | PLANT_SITE_ID (division 비81) | true | 4584 |
| 86 | PLANT_SITE_ID (division 81) | false | 4586 |
| 87 | DomExp (Catch_Up 전환) | false | 4917 |
| 88 | INCOTERMS (Catch_Up 전환) | false | 4936 |
| 89 | FcstType (Catch_Up 전환) | false | 4943 |
| 90 | DEPT_ID (Catch_Up 전환 — 팀 수정 금지) | true | 4951 |
| 91 | 숫자컬럼 M+3 이후 (Catch_Up) | false | 4966 |
| 92 | 숫자컬럼 M+3 미만 (Catch_Up) | true | 4970 |
| 93 | 과거 구간 전체 (Catch_Up) | true | 4976 |
| 94 | FcstType (SalesAmt_LOC 복귀 — ETC 고정) | true | 4987 |
| 95 | DomExp (SalesAmt_LOC 복귀) | true | 4993 |
| 96 | INCOTERMS (SalesAmt_LOC 복귀) | true | 4999 |
| 97 | DEPT_ID (SalesAmt_LOC 복귀 — 팀 입력 개방) | false | 5007 |
| 98 | 숫자컬럼 전체 선해제: MEASURE+1 ~ max | false | 5033 |
| 99 | 기간 잠금(40): ~시작-1 | true | 5047 |
| 100 | 기간 잠금(비40): ~시작(M+1) | true | 5050 |
| 101 | 시작 해제(40) | false | 5056 |
| 102 | 시작 해제(비40, 첫 M_ > 당월) | false | 5062 |
| 103 | 시작 잠금(비40, else) | true | 5065 |
| 104 | 과거 구간 전체 | true | 5070 |
| 105 | D_ 컬럼 개별 | true | 5078 |
| 106 | Monthly 시 W_ 개별 | true | 5087 |
| 107 | Weekly 시 M_ 개별 | true | 5096 |
| 108 | 공통 후처리 D_ 재잠금 | true | 5115 |

### 6.5 Lock 상태 소비 (IsLock/IsLockCell — 8곳)

| 위치 | 용도 | 라인 |
|---|---|---|
| SaveData | `IsLock(SheetName)==true` → 편집모드 아니면 저장 skip | 1960~1961 |
| InsertRow | `IsLock(SheetName)==false` 일 때만 행 삽입 | 2895 |
| cboBucketType_SelectedIndexChanged | `!IsLock` → EditButton 재호출 (편집상태 유지 재계산) | 3621~3624 |
| CellDoubleClick | `IsLock \|\| Action != 'I'` → 팝업 차단 | 3837~3838 |
| Dsdm_Changed | `IsLock` → return / `IsLockCell(row,col)` → return | 3960~3969 |
| ComboSelChange | `IsLock == false` 일 때만 연쇄 수행 | 4532 |
| cboBucketType_Click | `!IsLock` → MSG00227 (버킷 변경 금지) | 5517 |

---

## 7. ⭐ 결재 2건 반영 상세

### 7.1 [E20260331-000648] — 자동차사업부 '기준수요' 중 'RTF수정기능' 우선 적용 (2026-04-01, JSSBAE)

**(1) blnWork(연속작업 세마포어) 제거** — "불필요한 작업으로 판단" 주석과 함께 전량 주석 처리 (12개 블록):

| 위치 | 내용 | 라인 |
|---|---|---|
| 필드 선언 | `private bool blnWork = false;` 주석 | 120~121 |
| FindData 진입 | MSG00137 가드 + `blnWork=true` 주석 | 1472~1481 |
| FindData catch/finally | `blnWork=false` 2곳 주석 | 1636~1637, 1645~1646 |
| SaveData 진입 | MSG00137 가드 + `blnWork=true` 주석 | 1947~1957 |
| SaveData 성공 후 | `blnWork=false` 주석 | 2828~2830 |
| SaveData catch/finally | `blnWork=false` 2곳 주석 | 2841~2843, 2847~2849 |
| clbDivision_SelectedIndexChanged | 진입 가드 + catch/finally 3곳 주석 | 5139~5147, 5244~5245, 5250~5251 |

→ 영향: 조회/저장/Division 변경의 재진입 차단 로직이 사라짐 (연속 클릭 시 중복 실행 허용 상태로 변경).

**(2) SalesAmt_LOC 수정라인 = ETC 한정** — 정확한 조건식 (968):

```csharp
if ((siMain.GetValue(i, MEASURE)=="SalesAmt_LOC" && bEDIT_AUTH_SalesAmt_LOC
     && siMain.GetValue(i, FcstType)=="ETC")           // ← E20260331 추가
 || (MEASURE=="Catch_Up")
 || (MEASURE.ToUpper()=="RTF_SYS_RP" && bEDIT_AUTH_RTF_SYS_RP))
```
원소스(FcstType 조건 없는 버전)는 967에 주석 보존. → 영향: FcstType 이 ETC 가 아닌 SalesAmt_LOC 행(예: 기준수요 원천 행)은 편집 후보에서 제외.

**(3) 81 사업부 RTF_SYS_RP 확장** — 정확한 조건식 (1041~1045):

```csharp
else if (((row DIVISION_ID=="40" || (clbDivision.ControlValues).Substring(0,2)=="81")   // ← 81 추가 (L1041)
          && ((MEASURE=="SalesAmt_LOC" && bEDIT_AUTH_SalesAmt_LOC)
           || (MEASURE.ToUpper()=="RTF_SYS_RP" && bEDIT_AUTH_RTF_SYS_RP)))
      || ((row DIVISION_ID != "40" || (clbDivision.ControlValues).Substring(0,2)=="81") // ← 81 추가 (L1044)
          && (MEASURE=="SalesAmt_LOC" && bEDIT_AUTH_SalesAmt_LOC)))
```
- 영향 범위: 40 전용이던 RTF_SYS_RP 편집 branch(당월 잠금 1066~1080·정수/음수 제약 4393~4435 포함)에 81 계열이 진입. RTF_SYS_RP 는 여전히 `bEDIT_AUTH_RTF_SYS_RP` 권한 필요.
- 주의(실측): 81 판정이 행 값이 아닌 **`clbDivision.ControlValues`(조회조건 원시값)** 의 `Substring(0,2)` 로 수행됨 — 행 DIVISION_ID 기반인 40 판정과 소스가 다름.

### 7.2 [E20260512-000502] — 자동차 사업부 Cell Prod Site ID / FROM_SITE_ID (2026-05-12, JSSBAE)

FROM_SITE_ID 신규 반영 지점 전수 (활성 코드 4개 기능 블록):

| # | 기능 | 정확한 조건식/동작 | 라인 |
|---|---|---|---|
| 0 | 컬럼 정의 | `DefColumns.FromSiteId = "FROM_SITE_ID"` | 248~250 |
| 1 | EditButton 필수컬럼 | `Substring(0,2)=="81" && GetColumnIndex(FromSiteId)==-1` 및 `Substring(0,2)=="81" && GetColumnIndex(PLANT_SITE_ID)==-1` → MSG00113 후 편집 진입 차단 | 723~724 |
| 2 | SaveData 필수컬럼 | 동일 2개 조건식 → MSG00113 후 저장 차단 | 2043~2044 |
| 3 | SaveData 값 매핑 | `if (GetColumnIndex(FromSiteId) != -1) sCellProdSiteId = GetValue(i, FromSiteId)` — 검증 루프(2173~2175)와 파라미터 조립 루프(2474~2476) **2곳 모두**에서 CELL_PROD_SITE_ID 대입 직후 실행되어 **FROM_SITE_ID 값이 `p_cell_prod_site_id` 파라미터(2734)로 덮어써 전달**됨 (81: FROM_SITE_ID → CELL_PROD_SITE_ID 슬롯 재사용) | 2172~2175, 2473~2476, 2734 |
| 4 | InsertRow 잠금 | FROM_SITE_ID 컬럼 LockRange true — "정보만 보여주고, 데이터를 선택할 필요없음" (표시 전용) | 3187~3192 |

---

## 8. 비활성 인벤토리 (주석 처리분 — 활성 표에서 제외한 근거)

| 구분 | 내용 | 라인 |
|---|---|---|
| SpdMain_ClipboardPasted (구버전) | END_CUSTOMER40 붙여넣기 시 SalesSite/ITEM_ID(GUBUN 82/81/40, Catch_Up 제외) 재바인딩 — 메서드 전체 주석 ("테스트가 더 필요하므로 일단 주석처리". 활성판은 5616~5640 별도 존재) | 322~360 |
| 42/44 division 분기 | `(sDivision=="40")||(=="42")||(=="44")` 계열 원조건 — 전부 "40" 단독으로 축소 후 주석 보존 (10곳: 445, 488~490, 2347옆, 3349, 4599, 4661, 4701, 4738, 4760, 5161, 5204) | 좌기 |
| EditButton 40 읽기전용 | 구 로직: 40 → MSG00109(읽기 전용) 리턴, 81/82만 편집 — [PJ2024-50611] 분기 제거로 주석 | 693~704 |
| blnWork 세마포어 | §7.1 (1) 참조 — E20260331 주석 처리 | 120~121 외 |
| SaveData 구 필수값 체크 | 원소스 변수(sDIVISION_ID 등) 기반 동일 로직 — 변수 통일 리팩터링으로 주석 ([E20250520-000605]) | 2178~2221, 2321~2335, 2362~2370 |
| fnValidation 호출 | 중복체크 화면 수행 → SP 이관으로 호출부 주석 (`if (!fnValidation())`). 메서드 본체(4183~4315)는 잔존하나 미호출 dead code | 2276~2298 |
| SaveData 구 nvc 파라미터 | `CString.AppendStringEx` 방식 파라미터 조립 — Foxml 방식 전환으로 주석 | 2625~2647, 2741~2744 |
| SaveData 구 오류 메시지 분기 | INVALID2/INVALID4/INVALID_MSG/INVALID5 분기 — [E20250520-000572] 주석 (현행: `MSGID^추가문구` split 방식 2808~2815) | 2752~2806 |
| InsertRow 구 잠금 | SCM_SITE_ID(3026~3027)·CURRENCY(3034)·END_CUSTOMER 비40(3069~3072)·MEASURE(2963)·D_/M_/W_ 루프(3193~3202)·전주 잠금(3204~3209)·구 기간 잠금(3262~3267) | 좌기 |
| ComboSelChange DEPT_ID 분기 | 팀 변경 시 EndCustomer/SalesSite/ITEM_ID 연쇄 재바인딩 전체 — "[PJ2024-50611] 팀 바꼈을때 아무 조치 안함" 주석 | 4623~4685 |
| PLANT_SITE_ID Catch_Up 처리 | "40사업부가 없음..혹시 몰라서 주석" 2곳 | 4920~4929, 5022~5029 |
| EditButton 구 색상 원본 | 전주 회색/당월 White 구 코드 | 839~847, 867~875 |
| ExcelButton 구현 2종 | [PJ20209642R] ExcelButtonWithoutCopy / 원소스 ExportExcel 호출 — 주석 (현행: SimplexelService.ExportFpSpread 1146~1190). ExportExcel 메서드(1199~1455)는 잔존 미호출 | 1130~1145 |
| Dsdm_Changed 구 SUM | "Sum 계산 오류로 주석. 20190306" | 4056~4098 |
| 저장 sPrice=="" continue | [E20251125-000694] 이전엔 빈값 skip → 현행 "0" 치환 | 2590 |
| 기타 | dtMearsure2/GetSALESPLAN_MEASUREInfo2 미사용(92, 532, 3517~3527), InitSaveDataTable/SetSaveData 미호출(4127~4181), cboKRW/USD/LOC SetAmountCalculating 주석(5443~5471) | 좌기 |

---

## 9. 축별 카운트 요약 (전수 실측)

| 축 | 활성 건수 | 비고 |
|---|---:|---|
| 1. Division 비교 분기 | **73곳** | §1.1~1.7 (fnValidation 내 6곳은 dead code 로 제외, §8 등재). 42/44 잔재는 전량 주석 |
| 2. 권한 | **16곳** | bEDIT_AUTH_SalesAmt_LOC 4 + bEDIT_AUTH_RTF_SYS_RP 2 + Tables[2] 소비 2 + Insert 게이트 1 + Auth 데이터 호출 7 (JV Planner p_user_dept_id 포함) |
| 3. Measure | **22곳 비교 + 전환 cascade 25규칙** | SalesAmt_LOC(ETC 한정)·Catch_Up(M+3/음수불가/팀금지/팝업)·RTF_SYS_RP(음수 RMA예외/정수절사/당월잠금/⭐81확장). 조회전용 measure 종수는 서버 데이터 — .cs 에서 열거 불가 명시 |
| 4. 기간·버킷 | **42건** | 편집 시작점 19 + 버킷 제약 15 + 색/보더 8 |
| 5. FCST_TYPE | **8곳** | "ETC" 비교 1 + "RMA" 비교 1 + `<> 'ETC'` 필터 1 + ETC 고정 세팅 2 + 콤보 제약 1 + 필수 1 + 파라미터 전달 1 |
| 6. Lock | **108건 + 소비 8곳** | LockColumn 2 + LockRange 106 (EditButton 13 / InsertRow 69 / ComboSelChange 24) + SwitchLock 1(747) + IsLock/IsLockCell 8 |
| 7. 결재 반영 | **E20260331: 3항목(주석 12블록 + 조건식 2곳) / E20260512: 4기능 블록(7개 지점)** | §7 상세 |
| 8. 비활성 인벤토리 | 17그룹 | §8 |
