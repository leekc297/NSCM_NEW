# DMF0021 Sales Plan — 주요 이벤트 상세분석

- **원천**: `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0021_SalesPlan\DMF0021_SalesPlan.cs` (5,643행, 전수 Read)
- **기준 소스 버전**: 2026-04-01 [E20260331-000648] "자동차사업부 RTF수정기능 우선 적용" + 2026-05-12 [E20260512-000502] "자동차 사업부 Cell Prod Site ID(From Site ID)" 반영 최신본 (헤더 이력 L59~L60)
- **표기 원칙**: 라인번호는 실측. ⭐ = [E20260331-000648] / [E20260512-000502] 신규 반영분. 주석 처리된 구소스는 "주석(미사용)"으로 구분.
- **시트/그리드**: FarPoint Spread `spdMain` 단일 시트 `"Sales Plan"` (SpdSheet.shtMain, L136). 열 구조 = 고정속성 컬럼(Division~Measure) + 날짜 PIVOT 컬럼(태그 `D_yyyymmdd` / `W_yyyymmWW` / `M_yyyymm`).
- **이벤트 발생 순서 실측 주석** (L4340~4349): EnterCell → EditModeStarting → EditModeOn → EditChange → **Dsdm_Changed** → EditModeOff → **LeaveCell**.

---

## 1. Dsdm_Changed — 셀 값 변경 (Dsdm_Changed, L3958~L4125)

데이터 모델(`DefaultSheetDataModel.Changed`, 구독 등록 L588~589)의 값 변경 이벤트. 편집모드에서 셀 값이 바뀔 때마다 실행된다.

### 1-1. 가드 3단 (순서 고정)
1. **시트 잠금 가드** (L3961~3962): `siMain.IsLock(siMain.SheetName) == true`(조회모드) → 즉시 return.
2. **음수 인덱스 가드** (L3966~3967): `e.Column < 0 || e.Row < 0` → return. 주석 명기(L3964~3965): `IsLockCell`에 -1을 넘기면 이후 `InitSpread`에서 에러가 나므로 사용 금지.
3. **셀 잠금 가드** (L3968~3969): `siMain.IsLockCell(e.Row, e.Column)` → return.

### 1-2. 이벤트 타입/컬럼 필터
4. `switch (e.Type)`에서 **`CellsUpdated`만 처리** (L3971~3973, 그 외 default 무시 L4122~4123).
5. **날짜 PIVOT 영역만 처리** (L3974): `siMain.GetColumnIndex(MEASURE) < e.Column` 일 때만. (MEASURE 이하 속성 컬럼 변경은 빈 try 블록 L4111~4118 — 실질 no-op.)
6. **`D_` 컬럼 제외** (L3977~3978): 컬럼 태그가 `D_`로 시작하면 return (Daily 셀은 직접 입력 대상 아님).

### 1-3. MEASURE 빈 행 롤백
7. (L3980~3985) 해당 행의 MEASURE 값 `sChangeMea`를 읽어 `""` 이면 → **방금 입력한 셀을 `SetText(e.Row, e.Column, "")`로 되돌리고 return**. Measure가 지정되지 않은 행에는 수치 입력 자체를 무효화.

### 1-4. Red 마킹 (저장 수집 표식)
8. (L3987~3988) `siMain.SetColor(e.Row, e.Column, e.Row, e.Column, Color.Red, false)` — 변경 셀 ForeColor를 Red로 설정. **SaveData(F7)는 이 Red 색만 보고 저장 대상을 수집**하므로(§4-4), 이 마킹이 저장 파이프라인의 유일한 표식이다.

### 1-5. 인접 W_/M_ SUM 재-set (`#region Sum 계산 수정.` L3990~4054)
9. **Weekly 인접 탐색** (L3996~4003): `e.Column`에서 좌측으로 역루프하며 태그 `W_` 컬럼을 처음 만나면 `iStartCol = 그 컬럼 + 1` 로 잡고 break.
10. (L4005~4008) `iStartCol` 컬럼 태그가 `W_`이고 그 셀 텍스트가 비어있지 않으면 → `SetText(e.Row, iStartCol, siMain.GetText(e.Row, iStartCol))` 로 **동일 값을 재-set**(값 재기록으로 표시/재계산 갱신 유발 목적).
11. **Monthly 인접 탐색** (L4011~4018): 동일하게 좌측 역루프로 태그 `M_` 컬럼을 찾아 `iStartCol = 그 컬럼 + 1`.
12. (L4021~4024) `iStartCol` 태그가 `M_`이고 텍스트 비어있지 않으면 동일 값 재-set.
13. (L4026~4045) `iStartCol`부터 우측 끝까지 루프하며 `W_`/`M_` 비어있지 않은 셀 값을 `iMonthlySum`(decimal)에 합산. **단, 합산 결과를 셀에 쓰는 코드는 주석 처리되어 있어(L4038~4044) `iMonthlySum`은 계산만 되고 미사용**.
14. (L4047~4053) `sYYYYMMDD`(태그에서 `D_` 제거)와 현재 셀 값 `iQty` 추출 — 역시 이후 사용처 없음(빈 try 블록 L4100~4107). 과거 일→주→월 역산 로직은 "Sum 계산 오류로 주석. 20190306" 리전(L4056~4098)에 통째 주석(미사용).

> **유효 효과 요약**: 이 이벤트가 실제로 남기는 것은 (a) MEASURE 빈 행 입력 롤백, (b) Red 마킹, (c) 인접 W_/M_ 첫 셀의 동일 값 재-set 뿐이다. 실시간 SUM 숫자 갱신은 그리드 하단 ColumnFooter의 `SumIgnoreHidden` 집계(InitSpreadFooterSum L627~644)가 담당한다.

---

## 2. spdMain_LeaveCell — 셀 이탈 시 포맷/음수 차단 (spdMain_LeaveCell, L4362~L4438)

(짝 이벤트: `spdMain_EnterCell` L4329~4338 — MEASURE 우측 컬럼이면 진입 시 원본값 `sOrigianlValue` 보관, 빈값이면 "0".)

### 2-1. 진입 조건 (L4382)
아래 3조건 **AND** 일 때만 본문 실행:
- `siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor` — 셀 배경이 편집모드 노란색(=편집 해제된 셀)일 때만. [PJ2025-50017] 주석 명기.
- `siMain.GetColumnIndex(this_YYYYMM) > 0` — 당월 컬럼이 그리드에 존재.
- `siMain.GetColumnIndex(this_YYYYMM) <= iColumn` — 이탈 셀이 당월 컬럼 이후(당월 포함).

이후 (L4384~4390) 해당 행의 `FCST_TYPE`(sFcstType), `MEASURE`(sMeasure), 셀 값(Val) 취득.

### 2-2. RTF_SYS_RP 음수 차단 — FcstType=RMA 예외 (L4393~4403)
- 조건식 (L4398): `sMeasure == "RTF_SYS_RP" && sFcstType != "RMA" && Val != "" && Convert.ToDecimal(Val.Replace(",", "")) < 0`
- 성립 시 `siMain.SetValue(iRow, iColumn, "")` — **음수 입력을 빈칸으로 소거하고 return**.
- 정책 주석 (L4394~4397, DMF0082와 로직 동일화): **RMA인 경우** 음수/양수 모두 입력은 되나 저장 시 SP에서 음수만 허용, **RMA가 아닌 경우** 음수는 이 자리에서 즉시 빈칸 처리되어 양수만 입력·저장 가능.

### 2-3. Measure별 문자열 포맷 (L4405~4436)
- `sMeasure == "RTF_SYS_RP"` → iMeasureType=1 (L4406~4409); `"SalesAmt_LOC"` → iMeasureType=3 (L4410~4413).
- switch (L4416~4426):
  - case 1 (정수): `SetRowFormat(iRow, iColumn, 1, "###,###,###,###")` (L4420)
  - case 3 (소수 3자리): `SetRowFormat(iRow, iColumn, 1, "###,###,###,##0.000")` (L4424)
- **RTF_SYS_RP 정수 절삭** (L4428~4435): 값에 `.` 포함 시 `Val.Substring(0, Val.IndexOf('.'))` 로 **소수점 이하를 잘라내고 SetValue** (반올림이 아닌 절삭).

---

## 3. EditButton (F2) — 편집모드 진입 (EditButton override, L687~L1123)

### 3-1. 필수 컬럼 존재 체크 (L709~742)
아래 15개 OR 조건 중 하나라도 참(=컬럼 부재)이면 편집 진입 거부. div = `CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues)`:

| # | 조건 | 라인 |
|---:|---|---|
| 1 | `DIVISION_ID == -1` | L709 |
| 2 | div≠"40" && `PROJECT_CODE == -1` (40은 프로젝트 없음) | L710 |
| 3 | div="40" && `END_CUSTOMER40 == -1` | L711 |
| 4 | div≠"40" && `END_CUSTOMER == -1` | L712 |
| 5 | `SCM_SITE_ID == -1` | L713 |
| 6 | `ITEM_ID == -1` | L714 |
| 7 | div 앞2="81" && `TEXT == -1` | L715 |
| 8 | `DOM_EXP == -1` | L716 |
| 9 | `FCST_TYPE == -1` | L717 |
| 10 | `INCOTERMS == -1` | L718 |
| 11 | `MEASURE == -1` | L719 |
| 12 | `CURRENCY == -1` | L720 |
| 13 | div="40" && `DEPT_ID == -1` | L721 |
| 14 | div="40" && `CELL_PROD_SITE_ID == -1` [PJ2025-50017] | L722 |
| 15 | ⭐ div 앞2="81" && `FROM_SITE_ID == -1` **[E20260512-000502]** | L723 |
| 16 | ⭐ div 앞2="81" && `PLANT_SITE_ID == -1` **[E20260512-000502]** | L724 |

실패 메시지 분기 (L728~741): div="40" && DEPT_ID 부재 → `MSG00429 {"Team"}` ({0} 값은 필수 입력입니다, L730); 그 외 → `MSG00113` (필수 입력 컬럼이 없습니다, L734/738) 후 return.

### 3-2. 버킷 게이트 + 전체 잠금 (L744~750, L1116~1120)
- Weekly/Monthly 만 편집 허용 (L744). **Daily → `MSG00361` 표시 후 return** (L1116~1120).
- `siMain.SwitchLock()` (L747) 후 **`siMain.LockColumn(0, GetMaxColumnIndex(), true)` 전 컬럼 잠금** (L750) — 이후 조건 충족 행/구간만 선별 해제.

### 3-3. 편집 대상 컬럼 인덱스 수집 — list_EDIT_Month / list_EDIT_Week (L761~820)
`MEASURE+1`부터 마지막 컬럼까지 1-pass 루프 ([PJ2025-50017] LockRange 속도 최적화용 인덱스 리스트):
- **40 사업부** (`clbDivision.SelectedValue` 앞2="40", L771): `M_` 태그 & `this_YYYYMM` 컬럼 존재 & `this_YYYYMM index <= iCol` → add (**당월 포함**, [E20250520-000605]에서 `<`→`<=` 변경, L773~777). 당월 컬럼이 그리드에 없고 조회시작월 > 당월이면 모든 `M_` add (L781~785).
- **비40 사업부** (L789): `this_YYYYMM index < iCol` → add (**당월 제외, 익월부터**, L791~794). 과거보정 동일 (L798~802).
- **주차 공통** (L806~818): `W_` 태그 & `this_YYYYMMWW index <= iCol` → add (**당주 포함**, L806~809). 당주가 그리드에 없고 조회시작월 > 당주월이면 모든 `W_` add (L814~818).

### 3-4. 색상/당주 표시 (L822~865)
- `chkColor.Checked == true`: 조회시작 ≤ 전주(weekDate-7)이고 `pre_YYYYMMWW` 컬럼 존재 시 MEASURE+1~pre_YYYYMMWW 구간 배경 Gainsboro(회색) (L826~829); `this_YYYYMM` 컬럼은 White (L832~835).
- `chkColor.Checked == false`: Green BevelBorder를 당주 컬럼에 표시 (L839~863). [E20250520-000605] "초록색 라인 무한대 생성" 수정: `sPeriod[0] > sResult_YYYYMMDD`(조회시작 > 당주 월요일)이면 `this_YYYYMMWW`에, 아니면 `sResult_YYYYMMWW`(=`"W_"+당주월요일YYYYMM+iso_week`) 재계산 후 그 컬럼에 표시 (L851~861).

### 3-5. 편집 시작 컬럼 i_EditStartCol 결정 (L880~927)
- (L880) `dtTeamAuth = Data.UserTeamByDivisionAuth(...)` 조회 — 이후 본 메서드 내 사용처 없음(잔존 코드).
- `i_EditStartCol = MEASURE + 1` (L884); 첫 컬럼 태그가 `M_`이면 +1 ("M_ 뒤에 W_는 항상 있음", L886~889).
- **과거~과거 구간 차단**: 마지막 컬럼이 `W_`이고 그 주차 < `this_YYYYMMWW` → `i_EditStartCol = 0` (L892~898); 마지막이 `D_`이고 < `sResult_YYYYMMDD`(당주 월요일) → 0 (L899~905).
- [E20250520-000605] 40 사업부 & Monthly 버킷 & 시작 `W_` < 당주: MEASURE+1~당주 이전의 `W_` 컬럼들을 `list_EDIT_Week`에 추가(당월 이후 과거 주차 CLEAR 입력 허용용) (L908~921).
- 당주 컬럼이 그리드에 있으면 `i_EditStartCol = index(this_YYYYMMWW)` (L924~927).

### 3-6. EDIT_AUTH 권한 취득 (L929~954)
[PJ2025-50017] 조회 SP 3번째 결과테이블 `dsMain.Tables[2]` 를 복사해:
- `EDIT_AUTH_SalesAmt_LOC == "Y"` → `bEDIT_AUTH_SalesAmt_LOC = true` (L945~948)
- `EDIT_AUTH_RTF_SYS_RP == "Y"` → `bEDIT_AUTH_RTF_SYS_RP = true` (L949~952)

권한그룹 정책 주석 (L931~935): ADMIN(기타매출·RTF) / SCP PI ADMIN(기타매출·RTF) / SCP Planner(RTF) / DM Planner(기타매출) / DM ADMIN(기타매출).

### 3-7. 행별 선별 잠금 해제 (L958~1109) — `i_EditStartCol > 0` 일 때만 (L958, [E20250520-000605] `>=`→`>`)
전 행 루프 (L960):
1. **행 게이트** (L963~964): `SALES_PLAN_ADJUST_YN == "N_Y"` 인 행만.
2. **Measure 게이트** (L966~971) — 3종 OR:
   - ⭐ `MEASURE=="SalesAmt_LOC" && bEDIT_AUTH_SalesAmt_LOC && FCST_TYPE=="ETC"` (L968) — **[E20260331-000648] FCST_TYPE=ETC 조건 신규 추가** (구소스 L967: ETC 조건 없는 판정, 주석 처리). "SalesAmt_LOC 수정라인은 ETC인 경우만" (주석 L966).
   - `MEASURE=="Catch_Up"` (L970, [PJ2024-50611]).
   - `MEASURE.ToUpper()=="RTF_SYS_RP" && bEDIT_AUTH_RTF_SYS_RP` (L971, [PJ2025-50017]).
3. **편집 시작점 j / sValue** (L973~984): Monthly → `list_EDIT_Month[0]` (40=당월, 비40=익월), Weekly → `list_EDIT_Week[0]` (당주).
4. `sValue`가 `W_` 또는 `M_`로 시작할 때만 (L986):

   **(A) Catch_Up 분기** (L988~1038, [PJ2024-50611]): 행 `DIVISION_ID=="40" && MEASURE=="Catch_Up"` (L990):
   - **M+3 게이트** (L993): `sValue`의 YYYYMM ≥ `DateTime.Now.AddMonths(3)` 일 때만 (예시 주석: 24.11.22 입력 시 25.2월부터).
   - 버킷-태그 일치(`Weekly&&W_` 또는 `Monthly&&M_`, L996) && `IsEditMode` (L998) →
     - `siMain.LockRange(i, j, i, GetMaxColumnIndex(), false)` — **행 i의 j~끝 일괄 잠금 해제** (L1005).
     - **버킷 교차 잠금** ([PJ2025-50017] "Monthly일 때 Week 입력 불가 / Weekly일 때 Month 입력 불가"): Monthly → `list_EDIT_Week` 전 원소 `LockRange(..., true)` (L1010~1013); Weekly → `list_EDIT_Month` 전 원소 lock (L1018~1021).
   - IsEditMode 아님 → `LockRange(i, j, ..., true)` (L1026); 버킷-태그 불일치 → lock (L1031); M+3 미만 → lock (L1036).

   **(B) SalesAmt_LOC / RTF_SYS_RP 분기** (L1039~1102): ⭐ **[E20260331-000648] 81 사업부 확장** — 조건식 원문 구조 (L1041~1045):
   ```
   (행DIVISION_ID=="40" || clbDivision.ControlValues.Substring(0,2)=="81")           ← ⭐ 81 추가
     && ((MEASURE=="SalesAmt_LOC" && bEDIT_AUTH_SalesAmt_LOC)
      || (MEASURE.ToUpper()=="RTF_SYS_RP" && bEDIT_AUTH_RTF_SYS_RP))
   || (행DIVISION_ID!="40" || clbDivision.ControlValues.Substring(0,2)=="81")        ← ⭐ 81 추가
     && (MEASURE=="SalesAmt_LOC" && bEDIT_AUTH_SalesAmt_LOC)
   ```
   즉 40·81은 SalesAmt_LOC + **RTF_SYS_RP** 모두, 그 외 사업부는 SalesAmt_LOC만 (81 사업부도 40과 동일하게 RTF_SYS_RP 사용, 주석 L1040).
   - 버킷-태그 일치 (L1048) && `IsEditMode` (L1050) →
     - `LockRange(i, j, i, max, false)` 일괄 해제 (L1056).
     - Monthly: `list_EDIT_Week` 전 원소 lock (L1061~1064) + **[E20250520-000605] RTF_SYS_RP 당월 잠금** (L1066~1080): 행 MEASURE가 RTF_SYS_RP 이고 조회시작월 ≤ 현재월이면, `list_EDIT_Month` 중 태그 월 < `DateTime.Now.AddMonths(1)`(익월) 인 컬럼 lock — **RTF+Monthly는 당월 수정 불가**.
     - Weekly: `list_EDIT_Month` 전 원소 lock (L1085~1088); 그 외 → lock (L1092).
   - IsEditMode 아님 → lock (L1096); 버킷-태그 불일치 → lock (L1100).
5. 마무리: `siMain.SpreadObject.ResumeLayout()` (L1121).

> **D_ 컬럼**: 3-2에서 전체 잠금 후 어느 분기에서도 D_ 를 해제하지 않으므로 편집모드에서도 상시 잠금 유지(단, 일괄 해제 L1005/L1056 범위에 D_가 포함될 수 있으나 Daily 버킷은 편집 자체가 차단됨 + SaveData에서 D_ skip §4-4).

---

## 4. SaveData (F7) — 저장 (SaveButton L1125~1128 → SaveData, L1940~L2863)

### 4-1. 진입 가드
- `siMain.IsLock(siMain.SheetName) == true`(편집모드 아님) → return (L1960~1961).
- 시트명 = "Sales Plan" 일 때만 (L1963).
- 저장 SP: `"DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL"` (L1967, [E20250520-000605] Timeout 대응으로 DM.foxml 방식 전환).

### 4-2. 필수값 1단 — 컬럼 존재 체크 → MSG00113 (L2027~2049)
EditButton §3-1과 동형의 OR 체인. 차이점: `DOM_EXP` 존재 체크는 **주석 처리**(L2034), `TEAM_ID`/`PLANT_SITE_ID(비81)` 체크도 주석 (L2040~2041). 유효 조건 목록:
DIVISION_ID(L2027) / 비40 PROJECT_CODE(L2028) / 40 END_CUSTOMER40(L2029) / 비40 END_CUSTOMER(L2030) / SCM_SITE_ID(L2031) / ITEM_ID(L2032) / 81 TEXT(L2033) / FCST_TYPE(L2035) / INCOTERMS(L2036) / MEASURE(L2037) / CURRENCY(L2038) / 40 DEPT_ID(L2039) / 40 CELL_PROD_SITE_ID(L2042) / ⭐ **81 FROM_SITE_ID(L2043) [E20260512-000502]** / ⭐ **81 PLANT_SITE_ID(L2044) [E20260512-000502]** — 총 15조건, 하나라도 부재 시 `MSG00113` 후 return (L2047~2048).

### 4-3. 필수값 2단 — 행별 값 체크 → MSG00002 (L2051~2299)
전 행 루프. `Action`(0열)이 I/M/D 아니면 skip (L2058~2059), `I` 발견 시 `blnInsert=true` (L2055~2056). 행 값 수집 (L2097~2175) 후 **⭐ [E20260512-000502] 1곳째: `FROM_SITE_ID` 컬럼이 존재하면 `sCellProdSiteId = FROM_SITE_ID 셀 값`으로 덮어씀** (L2173~2175 — CELL_PROD_SITE_ID 값 L2167~2170을 상서).

위반 판정 OR (L2225~2234) 성립 시, else-if 체인으로 **첫 해당 항목 1개만** sMsg에 담아 `MSG00002 {sMsg}` ({0} 값은 필수 입력입니다) 표시 (L2236~2266) — div 분기 포함 13종 라벨:

| 순서 | 라벨 | 조건 | 라인 |
|---:|---|---|---|
| 1 | [Division] | sDivisionId=="" | L2236 |
| 2 | [Project Code] | 비40 && sProjectCode=="" | L2238 |
| 3 | [Currency] | sCurrency=="" | L2240 |
| 4 | [Sales_Site] | sScmSiteId=="" | L2242 |
| 5 | [Model] | sItemId=="" | L2244 |
| 6 | [Measure] | sMeasure=="" | L2246 |
| 7 | [TEXT] | 81 && sText=="" | L2248 |
| 8 | [END_CUSTOMER] | 40 && sEndCustomer=="" | L2250 |
| 9 | [TEAM] | 40 && sDeptId=="" && sMeasure≠"Catch_Up" | L2253 |
| 10 | [Customer Handbook] | 40 && Catch_Up && sDomExp=="" | L2255 |
| 11 | [FcstType] | 40 && Catch_Up && sFcstType=="" | L2257 |
| 12 | [INCOTERMS] | 40 && Catch_Up && sIncoterms=="" | L2259 |
| 13 | [CellProdSiteID] | 40 && sCellProdSiteId=="" | L2261 |

표시 후 `SetActiveCell(i, 2)` 로 위반 행 포커스 이동, return (L2270~2272). (구 화면단 중복체크 `fnValidation`(L4183~4315)은 [PJ2024-50611]로 **SP 이관되어 호출 주석(미사용)** L2276~2298 — MSG00043 분기 포함.)

### 4-4. Red 셀만 수집 — '^' 연결 18 param 조립 (L2309~2706)
2차 전 행 루프 (I/M/D 행만). 행 값 재수집 시:
- `sCellProdSiteId` 초기값 `"-"` (L2351).
- 40 사업부: `sProjectCode = END_CUSTOMER40 셀 값` (40은 END_CUSTOMER를 프로젝트코드 자리에 넣음, L2371~2384).
- TEXT: 81 → `TEXT` 컬럼 / 그 외 → `TEXT4082` 컬럼 (L2407~2425).
- ⭐ **[E20260512-000502] 2곳째: `FROM_SITE_ID` 존재 시 `sCellProdSiteId = FROM_SITE_ID 값` 덮어씀** (L2474~2476). → 81 사업부 저장 시 SP `p_cell_prod_site_id` 로 FROM_SITE_ID가 전달됨.
- CURRENCY 빈값 → `MSG00002 {CURRENCY Term}` return (L2500~2506).

날짜 컬럼 루프 `j = MEASURE+1 ~ max` (L2512):
1. **[PJ2024-50611] 40 팀 변경 전파** (L2516~2543): `DEPT_ID` 셀 ForeColor가 Red면, 현재 버킷에 맞는 숫자컬럼(Weekly→`W_`/Monthly→`M_`) 전부를 `SetColor(..., Red)` — 팀 변경 시 나머지 숫자컬럼도 수정 간주.
2. **`D_` 컬럼 skip** (L2546~2549).
3. **Red 게이트** (L2552~2555): `GetCellColor(...) != Color.Red` → continue — **Dsdm_Changed 가 Red 마킹한 셀만 저장 수집**.
4. **버킷 불일치 skip** (L2557~2569): Weekly인데 `M_` → skip / Monthly인데 `W_` → skip ([PJ2024-50611] 같은 월 monthly·weekly 동시수정 중복오류 방지).
5. `sYYYYMMDD = 컬럼 태그` (L2573), `sPrice = 셀 값` (L2579).
6. **빈값→0 전환** (L2585~2591): sPrice=="" → `"0"` ([E20251125-000694] 저장 로직 개선 — 구소스는 continue로 건너뜀).
7. **0→D 전환** (L2595~2604): `stempAction = action`; action이 "D"가 아니고 `sPrice=="0"` → `stempAction = "D"` (0 저장 = 삭제 처리).
8. **Catch_Up 음수 차단** (L2606~2623): 행이 40 && Catch_Up 이고 `Convert.ToDouble(sPrice) < 0` → `MSG00085 {"0"}` ({0} 이상의 값만 입력 가능합니다) 후 **전체 return** (저장 중단).
9. **'^' 연결 누적** (L2649~2690): `iDateCount > 0` 이면 각 변수에 `"^" + 값` append, 0이면 초기 대입. **누적 변수 17종 순서 전수** (L2652~2668):
   `ptempAction → pDivisionId → pProjectCode → pScmSiteId → pPlantSiteId → pItemId → pText → pDomExp → pFcstType → pIncoterms → pMeasure → pYYYYMMDD → pPrice → pCurrency → pUserId(UserInfoContext.Current.UserId) → pDeptId → pCellProdSiteId`. `iDateCount++` (L2692).

행 마감 (L2695~2705): 수집 0건이면 `MSG00146 {i+1}` (라인 [{0}] 날짜(Daily)가 값이 없습니다) return; 있으면 `iUpdateRow = i`, `iCUD++`.

### 4-5. SP 호출 — 18 param 실명 순서 전수 (L2708~2738)
`iCUD > 0` 일 때만. `FoxDataRequest("DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL")`, `CommandTimeout = 10*60` (L2736). 파라미터 등록 순서 (L2717~2734):

| # | 파라미터 | 값 | # | 파라미터 | 값 |
|---:|---|---|---:|---|---|
| 1 | `p_active_flag` | ptempAction | 10 | `p_measure` | pMeasure |
| 2 | `p_division_id` | pDivisionId | 11 | `p_yyyymmdd` | pYYYYMMDD |
| 3 | `p_project_code` | pProjectCode | 12 | `p_qty` | pPrice |
| 4 | `p_scm_site_id` | pScmSiteId | 13 | `p_currency` | pCurrency |
| 5 | `p_plant_site_id` | pPlantSiteId | 14 | `p_created_by` | pUserId |
| 6 | `p_item_id` | pItemId | 15 | `p_last_updated_by` | pUserId |
| 7 | `p_dom_exp` | pDomExp | 16 | `p_text` | pText |
| 8 | `p_fcst_type` | pFcstType | 17 | `p_dept_id` | pDeptId |
| 9 | `p_incoterms` | pIncoterms | 18 | `p_cell_prod_site_id` | pCellProdSiteId (⭐ 81은 FROM_SITE_ID 값) |

(누적 변수는 17종이나 pUserId 가 `p_created_by`/`p_last_updated_by` 2곳에 실려 SP 파라미터는 18개.)

### 4-6. 결과 코드^메시지 분기 (L2749~2826)
- `sResultMsg = response.DataSet.Tables[0].Rows[0][0]` (L2749).
- `!= "success"` 시 ([E20250520-000572] SP 전달 데이터 기반 메시지):
  - `'^'` 포함 → `Split('^')` 하여 `[0]`=메시지코드, `[1]`=추가문구 → `MessageHelper.GMessageBox(messageCode, {addmessage})` (L2808~2815).
  - 미포함 → `MessageBox.Show(원문, "Error!")` (L2817~2822).
  - return (L2823). (구 INVALID2/INVALID4/INVALID_MSG/INVALID5·MSG00428 분기는 통째 주석(미사용) L2752~2806.)
- success → `MSG00004 {iCUD}` ({0}개의 데이터가 저장되었습니다) (L2826).

### 4-7. 재조회 + 위치 복원 (L2832~2836)
- 신규 행 존재(blnInsert) → `FindData(true)` (전체 재조회, 활성셀 유지 안함).
- 수정만 → `FindData(false, iUpdateRow, siMain.ActiveSheet.ActiveColumnIndex)` — **마지막 수집 행 + 현재 활성 컬럼으로 셀 위치 복원** (FindData 내부 L1619~1623: `SetActiveCell` + `ShowActiveCell(Center, Center)`).

---

## 5. InsertRow (F8) — 신규 행 (InsertButton L674~677 → InsertRow, L2866~L3366)

### 5-1. EDIT_AUTH_SalesAmt_LOC 게이트 (L2869~2893)
[PJ2025-50017] "Insert = 기타매출만 가능": `dsMain.Tables[2]`의 `EDIT_AUTH_SalesAmt_LOC` 가 "Y"가 아니면 **메시지 없이 조용히 return** (L2889~2892). 이어 `IsLock == false`(편집모드) && 시트="Sales Plan" 일 때만 진행 (L2895~2897).

### 5-2. 행 삽입 + 기본값/콤보 (L2899~2981)
- `SuspendLayout` (L2899) → `insCell = siMain.Insert()` (L2902).
- 권한 데이터 3종 조회 (L2910~2912, L2920): `UserTeamByDivisionAuth` / `UserSiteByEndCustomerAuth` / `UserEndCustomerByDivisionDeptAuth`.
- `DIVISION_ID`: 조회조건 선택값 SetText + **Lock** (L2914~2918).
- `DEPT_ID`: 40 → dtTeamAuth 콤보 (L2923~2926); 비40 → **Lock** (L2927~2931).
- `CELL_PROD_SITE_ID`: `Data.Common(CELL_PROD_SITE_ID, sDivision, sItemID)` 콤보 (L2942~2949).
- `END_CUSTOMER` → dtEndCustomerAuth 콤보 (L2951~2952); `SCM_SITE_ID` → dtSalesSiteAuth 콤보 (L2953~2954).
- **`MEASURE` 기본값 = "SalesAmt_LOC"** + dtMearsure(룩업 등록 메저) 콤보 (L2957~2961); 비40이면 MEASURE **Lock** (40만 Catch_Up 전환 허용) (L2968~2971).
- `PROJECT_CODE` 셀타입 = cellTypeImage (팝업 버튼형) (L2974~2975).
- **`FCST_TYPE` 기본값 = "ETC"** set + **Lock** (L2977~2981).
- `CURRENCY` → dtCurrencyList 콤보 (Lock 없음 — 선택 가능) (L3032~3036).

### 5-3. 참조성 컬럼 잠금 전수 (L2984~3192) — LockRange 55건
존재 시(`!= -1`) 개별 `LockRange(..., true)`:
`TEAM_INCHARGE`(L2985) `PROJECT_NAME`(L2987) `PROJECT_STATUS`(L2989) `PROJECT_OWNER`(L2991) `BIZ_TYPE_NAME`(L2994) `ITEM_CLASS_NAME`(L2998) `ITEM_NAME`(L3000) `ITEM_TYPE`(L3003) `SALES_COMPANY`(L3007) `SALES_PLANT`(L3009) `NICK_NAME`(L3012) `KWH_CELL`(L3015) `KWH_MODULE`(L3018) `KWH_PACK`(L3021) `PLANT_SITE_ID`(L3024) `DOM_EXP`(L3030) `SALES_PLAN_ADJUST_YN`(L3038) `INCOTERMS`(L3040) `OWNER`(L3045) `COUNTRY_NAME`(L3048) `CITY_NAME`(L3050) `FORECAST_INFO_PRODUCT_GROUP`(L3052) `VMI_YN`(L3054) `PROJECT_NAME(ProjectName 중복정의)`(L3058) `DISTRIBUTION_CHANNEL`(L3060) `CELL_NAME`(L3062) `SHIPMENT_SITE`(L3064) `COMPANY_ID`(L3076) `CUST_GROUP`(L3080) `CUST_GROUP_DTL`(L3084) `APPLICATION`(L3088) `ROUTE`(L3092) `BIZ_TYPE_NAME40`(L3096) `GROUP_ID`(L3100) `INTERNAL_YN`(L3104) `CELL_TYPE`(L3108) `FORECAST_INFO_CELL_PACK_COUNT`(L3112) `CELL_MODEL_INFO`(L3116) `CELL_MODEL`(L3120) `FORECAST_INFO_ALL`(L3124) `FORECAST_INFO_SPEC`(L3128) `FORECAST_INFOR_VERSION`(L3132) `CELL_MODEL_NICK_NAME`(L3136) `MDM_PROJECT_NAME`(L3140) `MIN_CAPACITY`(L3144) `CELL_PER_CAR`(L3148) `CELL_PER_MODULE`(L3152) `MODULE_PER_CAR`(L3156) `ENERGE`(L3160) `ENERGE_WH`(L3164) `CELL_QUANTITY`(L3168) `DMS_SALES`(L3172) `DMS_CUSTOMER`(L3176) `SCP_USE_YN`(L3184, [E20250423-000842]) **⭐ `FROM_SITE_ID`(L3190, [E20260512-000502] — "정보만 보여주고 데이터 선택 불필요")**.
(END_CUSTOMER 잠금은 [PJ2024-50611]에서 주석 해제 취소 — SCM_SITE_ID 선택 위해 편집 가능, L3069~3072.)
§5-2의 DIVISION_ID·비40 DEPT_ID·비40 MEASURE·FCST_TYPE 잠금 4건을 합하면 최대 59건의 LockRange.

### 5-4. 기간 잠금 규칙 (L3212~3337)
- `i_EditStartCol = MEASURE + 1` (L3213).
- **Monthly**: 당월(`this_YYYYMM`) 컬럼 존재 시 `i_EditStartCol = 당월 index` ([E20250520-000605] 당월 포함, L3224~3230).
- **Weekly**: 당주(`this_YYYYMMWW`) 존재 시 당주 index, 없으면 +1 (L3234~3244).
- 마지막 컬럼 주차 < 당주 → `i_EditStartCol = 0` (편집 불가, L3247~3251).
- **케이스1 — 과거 포함 조회** (`i_EditStartCol > 0 && MEASURE+1 < i_EditStartCol`, L3271~3287):
  - 40: MEASURE+1 ~ `i_EditStartCol - 1` lock (**당월부터 편집**, L3273~3276).
  - 비40 & Monthly: ~ `i_EditStartCol` lock (**당월 포함 잠금 = M+1부터 편집**, L3277~3281).
  - 비40 & Weekly: 당주 존재 시 ~ `i_EditStartCol - 1` lock (당주부터 편집, L3282~3286).
- **케이스2 — 당월/미래 시작 조회** (`MEASURE+1 == i_EditStartCol`, L3289~3302):
  - 40: 해당 컬럼 unlock(false) (L3291~3292).
  - 비40: 첫 `M_` 태그 월 > 당월이면 unlock, 아니면 lock (25.07.04 주석: 신규 등록 가능 데이터 = FCST_TYPE:ETC, MEASURE:SALESAMT_LOC 뿐 / 비40은 M+1부터, L3293~3301).
- **케이스3 — 과거 구간** (그 외): MEASURE+1 ~ 끝 전체 lock (L3303~3307).
- **D_ 상시 잠금 + 버킷 교차 잠금** (L3310~3337): MEASURE~끝 루프에서 `D_` 무조건 lock (L3314~3315); Monthly 버킷 → `W_` lock (L3319~3326); Weekly 버킷 → `M_` lock (L3327~3335) ([E20250520-000605] bucket 중복 수정 금지).

### 5-5. ITEM_ID 콤보 (L3341~3353)
사업부별 `dtITEM_ID.Select("GUBUN='xx'")`: 82 → '82' / 앞2 "81" → '81' / "40" → '40'. `ResumeLayout` (L3354).

---

## 6. spdMain_ComboSelChange — 행 내 콤보 cascade 6키 (spdMain_ComboSelChange, L4530~L5122)

가드: `siMain.IsLock(...) == false`(편집모드)에서만 (L4532). `sDivision = 행의 DIVISION_ID 값` (L4535); sTeam/sEndCustomer/sScmSite 초기값 = "ALL" (L4536~4538).

### 6-1. DIVISION_ID 변경 (L4540~4622) — 콤보 5종 재바인딩 + 하위 8컬럼 clear
1. `DEPT_ID` 콤보 = `Data.UserTeamByDivisionAuth(그룹, 사용자, sDivision)` 재바인딩 후 sTeam 재취득 (L4544~4550).
2. `END_CUSTOMER` 콤보 = `Data.UserEndCustomerByDivisionDeptAuth(..., sDivision, sTeam)` (L4552~4558).
3. `END_CUSTOMER40` 콤보 = `Data.Common(EndCustomerByDivision40, "", clbTeam.ControlValues, ...)` (L4561~4567).
4. `SCM_SITE_ID` 콤보 = `Data.UserSiteByEndCustomerAuth(..., sDivision, sEndCustomer)` (L4569~4574).
5. `PLANT_SITE_ID` 콤보 = `Data.UserPlantSiteByDivision(..., sDivision)` + **앞2≠"81" → Lock / "81" → Unlock** (L4576~4588).
6. `ITEM_ID` 콤보 = GUBUN 분기(82/81/40) (L4591~4603).
7. **하위 8컬럼 clear** (L4606~4621): `DEPT_ID`, `END_CUSTOMER`, `SCM_SITE_ID`, `PROJECT_CODE`, `PROJECT_NAME`, `ITEM_ID`, `TEXT`, `ITEM_CLASS_NAME` 모두 `SetText("")`.

### 6-2. DEPT_ID 변경 (L4623~4685)
[PJ2024-50611] "팀 바뀌었을 때 아무 조치 안함" — 본문 전체 주석(미사용). no-op.

### 6-3. END_CUSTOMER 변경 (L4686~4720) — 하위 6컬럼 처리
1. `SCM_SITE_ID` 콤보 = `Data.UserSiteByEndCustomerAuth(..., sDivision, 새 END_CUSTOMER)` (L4688~4691).
2. `ITEM_ID` 콤보 = GUBUN 분기 (L4693~4705).
3. **clear 6컬럼** (L4707~4719): `SCM_SITE_ID`, `PROJECT_CODE`, `PROJECT_NAME`, `ITEM_ID`, `TEXT`, `ITEM_CLASS_NAME`.

### 6-4. END_CUSTOMER40 변경 (L4722~4749)
1. `SCM_SITE_ID` 콤보 = `Data.UserSiteByEndCustomer(..., sDivision, 새 값)` (L4727~4728).
2. `ITEM_ID` 콤보 = GUBUN 분기 — 단 **40에서 행 MEASURE=="Catch_Up" 이면 콤보 재바인딩 금지** (팝업 선택형 유지, L4739~4746). clear 없음.

### 6-5. SCM_SITE_ID 변경 (L4750~4782) — 하위 5~6컬럼 처리
1. `ITEM_ID` 콤보 = GUBUN 분기 (40 Catch_Up 이면 미바인딩, L4752~4770).
2. **clear 5컬럼** (L4771~4781): `PROJECT_CODE`, `PROJECT_NAME`, `ITEM_ID`, `TEXT`, `ITEM_CLASS_NAME`.

### 6-6. ITEM_ID 변경 (L4783~4812) — 자동세팅 + CELL_PROD 재바인딩
1. `dtITEM_ID.Select("CODE='선택값'")` 매칭 성공 시 `ITEM_CLASS_NAME = NAME` 자동세팅 (L4785~4794).
2. 활성행의 END_CUSTOMER/SCM_SITE_ID/ITEM_ID 재취득 (L4796~4805).
3. **`CELL_PROD_SITE_ID` 콤보 재바인딩** = `Data.Common(CELL_PROD_SITE_ID, sDivision, sItemID2)` ([PJ2025-50017], L4806~4811).

### 6-7. MEASURE 변경 — Catch_Up ↔ SalesAmt_LOC 대규모 전환 (L4813~5120, [PJ2024-50611] 40사업부용)
`SuspendLayout` (L4819) 후 편집 시작 컬럼 재계산 (L4822~4903): 첫 컬럼 `M_` → 당월 index (L4855~4861); `W_` → 당주 index, 마지막 주차 < 당주면 0 (L4864~4882); **40 && SalesAmt_LOC** 이면 버킷별 당월/당주로 재보정 (L4886~4903).

**(A) → Catch_Up 선택 시** (L4905~4979) — 8규칙:
1. `ITEM_ID` 값 clear + **CellType = cellTypeImage** (더블클릭 팝업형 전환) (L4907~4911).
2. `DOM_EXP` 값 clear + `dtCustomsHandbook` 콤보 바인딩 + **Unlock** (L4913~4918).
3. `INCOTERMS` 값 clear + `GetIncotermsType(sDivision, sScmSite)` 콤보 + **Unlock** (L4931~4937).
4. `FCST_TYPE` 값 clear + `dtFcstType`(ETC 제외 목록 — GetFcstType L5595 `CODE <> 'ETC'`) 콤보 + **Unlock** (L4939~4944).
5. `DEPT_ID` 값 clear + **Lock** (catch-up 입력 시 팀 수정 금지) (L4948~4952).
6. 숫자컬럼: `i_EditStartCol > 0 && MEASURE+1 < i_EditStartCol` 이면 각 컬럼별로 **비`D_` && 태그월 ≥ now+3개월(M+3)** 만 Unlock, 그 외 Lock (L4956~4973).
7. 조건 미충족(과거구간 등) 시 숫자컬럼 전체 Lock (L4974~4977).
8. (공통 마무리로 이어짐 — 아래 C.)

**(B) → 비Catch_Up(SalesAmt_LOC) 복귀 시** (L4980~5103) — 13규칙:
1. `FCST_TYPE` = "ETC" set + **CellType을 Text로 전환**(콤보에 ETC 없음) + **Lock** (L4983~4988).
2. `DOM_EXP` 값 clear + **Lock** (L4990~4994).
3. `INCOTERMS` 값 clear + **Lock** (L4996~5000).
4. `DEPT_ID` 값 clear + **Unlock** (ETC는 팀 입력 가능) (L5004~5008).
5. `ITEM_ID` CellType = null → 값 clear → **GUBUN='40' 콤보 재바인딩** (L5010~5015).
6. `NICK_NAME` clear (L5017~5020).
7. 숫자컬럼 전체 **일단 Unlock** (MEASURE+1 ~ 끝, L5033).
8. 케이스1 (과거 포함): 40 → `i_EditStartCol-1` 까지 Lock / 비40 → `i_EditStartCol` 까지 Lock (L5043~5051).
9. 케이스2 (당월 시작): 40 → Unlock / 비40 → 첫 M_ > 당월이면 Unlock, 아니면 Lock (L5053~5066).
10. 케이스3 (과거 구간): 전체 Lock (L5067~5071).
11. `D_` 컬럼 Lock (L5074~5079).
12. Monthly 버킷 → `W_` 전부 Lock (L5082~5089).
13. Weekly 버킷 → `M_` 전부 Lock (L5090~5098).

**(C) 공통 마무리** (L5106~5118) — 3규칙:
1. MEASURE+1 ~ 끝 **모든 숫자 셀 값 `""` 초기화** (메저 변경 시 기존 입력값 전부 소거, L5111).
2. `D_` 컬럼 재Lock (L5113~5115).
3. `ResumeLayout` (L5118).

(A 8 + B 13 + C 3 = 전환 규칙 24종 전수.)

---

## 7. FindData (F5) — 조회 (FindButton L669~672 → FindData L1465~L1650, Draw L1652~L1938)

### 7-1. 사전 검증 (L1484~1532)
- 기간 역전: `sPeriod[0] > sPeriod[1]` → `MSG00108` return (L1489~1493).
- 기간 상한: `Value1 + 3년 < Value2` → `MSG00164` 표시 + `Value2 = Value1.AddYears(3)` 보정 후 return (L1496~1503).
- `sNowDate` = 당주 월요일 (`GetThisWeekMonday` L4509~4528: 오늘부터 하루씩 빼며 월요일 탐색). 조회시작 ≥ 당주월요일이면 sNowDate=시작일, 종료일 < sNowDate 이면 종료일+1 (L1505~1509).
- 조회조건 수집 (L1512~1523): division/salesSite/project/itemId/itemType/plantSite/bizType/team(dept)/endCustomer/owner.
- Division 미선택 → `MSG00097` return (L1528~1532).
- `CanModelChange = false`, ProgressForm 표시, `InitSpread(true)` (헤더 재구성, L1534~1538).

### 7-2. 조회 SP — 18 param 실명 순서 (L1544~1578)
`FoxAsyncProxy` 비동기 + `FoxDataClient` → `FoxDataRequest("DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx")`, `CommandTimeout = 30*60` (L1552~1553). 파라미터 순서 (L1555~1572):

| # | 파라미터 | 값 | # | 파라미터 | 값 |
|---:|---|---|---:|---|---|
| 1 | `p_division_id` | 체크된 Division | 10 | `p_to_yyyymmdd` | 종료일 |
| 2 | `p_dept_id` | clbTeam | 11 | `p_created_by` | UserId |
| 3 | `p_end_customer` | clbCustomer | 12 | `p_plant_site_id` | clbPlantSite |
| 4 | `p_scm_site_id` | clbSalesSite | 13 | `p_biztype` | clbBizType |
| 5 | `p_project_code` | txtProject | 14 | `p_userinfo` | NowGroupID |
| 6 | `p_item_id` | txtItemId | 15 | `p_owner` | txtOwner |
| 7 | `p_item_type` | clbItemType | 16 | `p_internal_yn` | InternalYN 체크 → "Y"/"N" |
| 8 | `p_from_yyyymmdd` | 시작일 | 17 | `p_bucket` | cboBucketType |
| 9 | `p_now_yyyymmdd` | sNowDate(당주 월요일 보정값) | 18 | `p_user_dept_id` | UserInfoContext["Dept_ID"] ([과제] JV Planner) |

### 7-3. 3테이블 소비 구조
- **Tables[0] = 본 데이터** (행 = Div~Measure 속성 + 날짜 PIVOT + NOTATION/SORT_ORDER_NO). 0행이면 return (L1580~1581). 마지막 행 MEASURE ≠ "" 이면 `Action` 컬럼 추가 → `AcceptChanges` → `siMain.Query(dt)` 바인딩 → **`LockColumn(0, max, true)` 전체 잠금**(조회모드) (L1584~1593).
- **Tables[1] = 기준일·당주** (Draw 내 소비, L1794~1803): `THIS_YYYYMM`(당월 태그) / `THIS_YYYYMMWW`(당주 태그) / `PRE_YYYYMM` / `PRE_YYYYMMWW` / `BASIS_DATE`(→weekDate) / `BASIS_YYYYMM` / `ISO_WEEK` 7값을 멤버 변수에 적재 — EditButton/InsertRow/LeaveCell/ComboSelChange 전반의 당월·당주 판정 원천.
- **Tables[2] = EDIT_AUTH 2종** ([PJ2025-50017] GET_ADMIN_GROUP_MEASURE LOOKUP): `EDIT_AUTH_SalesAmt_LOC` / `EDIT_AUTH_RTF_SYS_RP` — EditButton(L942~953)·InsertRow(L2880~2887)에서 소비.

### 7-4. 머지·Draw·후처리 (L1596~1631)
1. `siMain.SmartColMerge()` (동일값 열 병합 표시, L1596) → `SearchEndTime()` (L1601).
2. `dsMain = ds` 보관 후 **`Draw()`** 호출 (L1605~1606) — [E20231128-000738] 82사업부 메저별 숫자표기:
   - `NOTATION` 값별 행 포맷 (L1689~1783): `INTEGER` → 정수 포맷(0.000 특례 포함), `POINT` → 정수/소수 혼합 포맷, `POINT3` → 무조건 소수 3자리 포맷 계열 — 값의 선행 0/소수부 길이에 따라 `SetRowFormat` 세분 적용.
   - Tables[1] 기준일 적재 (L1794~1803) + `sResult_YYYYMMWW` 재계산 (L1805~1808) + 과거-과거 첫달 회색 버그 보정 (L1810~1814).
   - 전 행: `PROJECT_CODE` 셀타입 = cellTypeImage, `CELL_PROD_SITE_ID` 세로 중앙 정렬 (L1821~1832).
   - `chkColor` true: 버킷별(D_/W_/M_)로 과거 열 탐색 후 Gainsboro 배경 + 당월 White (L1833~1912); false: Green BevelBorder 당주(`this_YYYYMMWW` 우선, 없으면 `sResult_YYYYMMWW`; Daily는 `D_당일`) (L1914~1933).
   - `SetSpreadColumn()` (버킷별 D_/W_/M_ visible 토글 + 당월/당주 헤더 녹색 볼드, L1937 → 본체 L3629~3698).
3. 행 존재 시 `SetSpreadColumn()` 재호출 + `dtSave.Clear()` (L1608~1613) → `SmartColMerge()` (L1616).
4. **위치 복원**: `blnInsert == false` 이면 `SetActiveCell(iUpdateRow, iUpdateCol)` + `ShowActiveCell(Center, Center)` (L1619~1623) — SaveData 후 재조회 시 사용.
5. `UIEndTime()`, `CanModelChange = true` (L1629~1631). 예외 시 `GMessageBoxForException` + Visible이면 rethrow (L1633~1642), finally에서 ProgressForm Close (L1647).

---

## 8. spdMain_CellDoubleClick / ClipboardPasted (L3789~L3956 / L5616~L5640)

### 8-1. 헤더 더블클릭 드릴 (`e.ColumnHeader`, L3791~3834)
- **`M_` 헤더** (L3794~3819): 클릭 월부터 우측으로 순회하며 (a) `W_` 컬럼 → `Visible` 토글(펼침/접힘 반전) (L3798~3801); (b) Daily 버킷이면 `D_` 컬럼은 보이는 상태일 때 접기 (L3802~3809); (c) `M_` 자신은 접혀있으면 다시 표시 (L3810~3814); 다음 `M_` 태그를 만나면 break (L3816~3817) — **월 1개 구간 단위 드릴다운**.
- **`W_` 헤더** (L3820~3833): Daily 버킷일 때만 해당 주의 `D_` 컬럼 Visible 토글 (L3824~3828); 다음 `W_`에서 break (L3830~3831).

### 8-2. 데이터 셀 더블클릭 팝업 (L3835~3955)
- 가드 (L3837~3838): 시트 잠금(조회모드) **또는 행 Action ≠ "I"** → return — **신규 삽입 행에서만 팝업 동작**.
- 행 컨텍스트 수집 (L3840~3871): DIVISION_ID/PROJECT_CODE/SCM_SITE_ID/DEPT_ID/END_CUSTOMER/MEASURE.
- **PROJECT_CODE 셀** (L3874~3901): `SCM0002_ProjectbyDivisionPopupEx` 생성 → `Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSite, sProject)` → ShowDialog. 반환값 반영: `PROJECT_CODE`/`PROJECT_NAME`/`PROJECT_STATUS`/`BIZ_TYPE_NAME`/`PROJECT_OWNER` SetText (L3883~3893) + **`ITEM_ID`·`ITEM_CLASS_NAME` clear** (프로젝트 변경 후 모델 재선택 유도, L3896~3899).
- **40 + Catch_Up 의 ITEM_ID 셀** (L3902~3954, [PJ2024-50611]): sTeam/sEndCustomer 기본 "ALL", sProject="" (40은 프로젝트 없음) 후 행 값으로 재취득 (L3905~3928); `DM0002_ItembyDivisionPopupEx.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sMdmActive_Sw="Y", sMeasure_info)` ([E20231019-001234] 모델코드 사용중지 정보 제공) → ShowDialog (L3931~3937). 반환 ItemID ≠ "" 이면 해당 셀 + `ITEM_TYPE` + `NICK_NAME` SetText (L3944~3953).

### 8-3. 붙여넣기 경로
- **spdMain_KeyUp** (L5473~5489): MEASURE 우측 영역에서만 — `V` 키 → `ClipboardPaste(AsStringSkipHidden)` (숨김 열 건너뛰고 문자열 paste, L5477~5481); `C` 키 → `Clipboard.Clear()` 후 `ClipboardCopy(AsStringSkipHidden)` (L5483~5488).
- **spdMain_ClipboardPasted** (L5616~5640): paste 된 CellRange 전 행×열 순회, 열이 `ITEM_ID` 컬럼이면 행의 DIVISION_ID/SCM_SITE_ID/ITEM_ID를 읽어 **`CELL_PROD_SITE_ID` 콤보를 `Data.Common(CELL_PROD_SITE_ID, sDivision, sItemID)` 로 재바인딩** (L5631~5635) — paste 로 모델이 바뀐 행의 Cell Prod Site 후보 동기화 ([PJ2025-50017]).
- 참고: 생성자 근처의 구 `SpdMain_ClipboardPasted` (L329~360, END_CUSTOMER40 paste 시 SCM_SITE_ID/ITEM_ID 재바인딩) 는 **전체 주석(미사용)** — 등록부 L325 도 주석 ("테스트가 더 필요하므로 일단 주석처리").

---

## 부록 — 이벤트/버튼 연결 실측
| 트리거 | 핸들러 | 라인 |
|---|---|---|
| F5 (Find) | `FindButton` → `FindData(true)` | L669~672 |
| F8 (Insert) | `InsertButton` → `InsertRow()` | L674~677 |
| Delete | `DeleteButton` — Action="I" 행만 `siMain.Delete()` | L679~685 |
| F2 (Edit) | `EditButton` | L687~1123 |
| F7 (Save) | `SaveButton` → `SaveData()` | L1125~1128 |
| Excel | `ExcelButton` — SimplexelService.ExportFpSpread ([E20240906-001717]) | L1146~1190 |
| 셀 값 변경 | `Dsdm_Changed` (구독 L588~589) | L3958~4125 |
| 셀 진입/이탈 | `spdMain_EnterCell` / `spdMain_LeaveCell` | L4329~4338 / L4362~4438 |
| 행 콤보 변경 | `spdMain_ComboSelChange` | L4530~5122 |
| 더블클릭 | `spdMain_CellDoubleClick` | L3789~3956 |
| 붙여넣기 | `spdMain_KeyUp` / `spdMain_ClipboardPasted` | L5473~5489 / L5616~5640 |
| Bucket 변경 | `cboBucketType_SelectedIndexChanged` / `cboBucketType_Click` (편집모드 중 변경 금지 MSG00227) | L3576~3628 / L5512~5532 |
