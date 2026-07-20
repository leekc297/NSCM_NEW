# DMF0042 Business Plan — 주요 이벤트 상세분석

| 항목 | 값 |
|---|---|
| 원천 파일 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0042_BizPlan\DMF0042_BizPlan.cs` |
| 물리 행수 | 3,564행 (L1~L3564 전체 Read 실측) |
| 분석일 | 2026-07-20 |
| 클래스 | `GSCM.DM.Plan.UIL.DMF0042_BizPlan : BaseForm` (FarPoint Spread `spdMain`, 시트명 `SpdSheet.shtMain = "Biz Plan"` L96) |
| 분석 원칙 | 전수·실측. 소스에 없는 내용은 기술하지 않음. 주석 처리(비활성) 코드는 "비활성" 명기 |

**공통 전제 (전 이벤트 공유)**
- Measure 행 그룹: 1 논리행 = `dtMeasure.Rows.Count` 개 물리행(측정치별 1행). 그룹 도우미 = `GetCellNumbersByRow` (L3107~L3134), `GetCellIndexBySpanRowCells` (L3136~L3142).
- 데이터 컬럼 태그 규약: `M_yyyyMMdd`(월), `Q_...`(분기 SUM), `Y_yyyy...`(연 SUM). 배치 순서는 `Y_ → Q_ → M_ M_ M_ → Q_ → ...` (헤더 스팬 생성 L408~L488).
- dirty 마킹 = 셀 ForeColor **Red**: 판독 `GetCellColor` (L3342~L3351), 마킹 `SetCellColor` (L3353~L3360, `ForeColor = Color.Red` 고정).
- 40 컷오프 편집창 상태 필드: `valid_YN / start_YYYYQQ / end_YYYYQQ / start_YYYYMM / end_YYYYMM / start_YYYY / end_YYYY` (L77~L83) — FindData 의 `Tables[1]` 에서만 채워짐 (L831~L840).
- `sDefaultDay` (L206): `string.Empty` 로 선언된 후 **본 파일 내 어디서도 재할당 없음** (grep 실측: 비교만 L2304, L2736). 따라서 Yearly 분할의 "특정 요일 배분" 분기는 **런타임 사실상 미동작(dead)**.

---

## 1. spdMain_Changed — 셀 값 변경 (핸들러 `spdMain_Changed`, L1863~L2786)

이벤트 배선: `DefineProperty` (L369~L370)에서 시트 데이터모델 `DefaultSheetDataModel dsdm` 의 `Changed` 이벤트에 `spdMain_Changed` 를 연결 — 즉 과업에서 말하는 "Dsdm_Changed" 와 동일 핸들러이다. 전체 구조는 **Business_Plan(정수 Int64 연산, L1920~L2351) / 그 외 measure=LOC 등(double 연산, L2352~L2783)** 2벌 × **Monthly/Quarterly/Yearly** 3버킷 = 6분기.

### 1.1 진입 가드 (L1865~L1874)
1. `CanModelChange == false` 면 즉시 return (L1865). — FindData 시작(L747), ValidationCheck(L2793), spdMain_TopChange(L2801) 가 일시적으로 false 로 내림.
2. 이벤트가 2번 들어오는 현상이 있어(주석 L1867) 2번째 호출(`e.Column = -1`)을 차단: `e.Column < 0` return (L1868), `e.Row < 0` return (L1869).
3. **빈값 처리**: 변경 셀 값이 `""` 이면 `"0"` 으로 강제 세팅 (L1871~L1874). — 이 SetValue 가 재차 Changed 를 유발할 수 있으나 색 가드(1.3)로 걸러짐.
4. `switch (e.Type)` — `CellsUpdated` 케이스만 처리 (L1876~L1878, case 는 이 1개뿐이고 L2784 break, L2785 switch 종료).

### 1.2 로컬 변수 준비 (L1879~L1903)
5. `sBucketType = cboBucketType.ControlValues`, `sColName = siMain.GetColumnTag(e.Column)`, `iStartCol = 0` (L1879~L1881).
6. L1883~L1897 에 `sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sMeasure, sPlantSiteId, sEndCustomer40, sScmSiteId40, sItem40, sAction` 선언 — **본 핸들러 내에서 전혀 사용되지 않는 잔존 변수** (선언만 존재).
7. `(e.Row == -1) || (e.Column == -1)` 재확인 return (L1899~L1900) — L1868~L1869 에서 이미 차단되므로 **도달 불가(dead)**.
8. `strValue` = 변경 셀 값을 `'.'` 로 split (소수점 검사용, L1902). `strCheckMeasure` = 해당 행 `MEASURE` 컬럼 값 (L1903).

### 1.3 Red(dirty) 색 가드 + 소수점 처리 MSG00289 (L1906~L1918)
9. 대상 판정: `MEASURE 컬럼보다 오른쪽 컬럼` 이거나 `UNIT_ENERGY` 컬럼일 때만 (L1906, [PJ20200138] 주석).
10. `GetCellColor` 로 변경 셀 ForeColor 조회 → **Red 가 아니면 return** (L1909~L1911). 즉 사용자 편집으로 이미 Red 마킹된 셀만 이후 분할/합계 로직 진행 (프로그램적 재기입 루프 차단 역할 겸함).
11. 소수점 검사: `strValue.Length > 1`(소수점 존재) && `strValue[1] != "000"` && `strCheckMeasure == "Business_Plan"` 이면 → 셀 값을 `정수부 + ".000"` 으로 치환하고 `MessageHelper.GMessageBox("MSG00289")` (L1913~L1917). — 소수점 제거는 **Business_Plan measure 에만** 적용. LOC 는 소수 허용.

### 1.4 Business_Plan 벌 (Int64 정수 연산, L1920~L2351)
합계 변수 `long iQuarterlySum / iYearlySum` (L1922~L1923).

#### 1.4-A Monthly 버킷 + `M_` 컬럼 입력 (L1925~L1981) — 상위 Q_/Y_ 합계 갱신
1. **Quarterly Sum** (L1927~L1953):
   1. `e.Column` 에서 왼쪽으로 역주사하여 가장 가까운 `Q_` 컬럼을 찾고 `iStartCol = (그 컬럼)+1` (L1928~L1935).
   2. `iStartCol` 부터 우측으로: 태그가 `M_` 이고 셀 비어있지 않으면 `iQuarterlySum += Convert.ToInt64(값)` (L1939~L1942). (L1943~L1944 의 else 분기는 이 벌에서 `strCheckMeasure=="Business_Plan"` 이 항상 참이므로 **도달 불가 dead**.)
   3. 태그가 `Y_`/`Q_` 를 만나거나 마지막 컬럼이면 `iStartCol-1`(= 해당 분기의 Q_ 컬럼)에 합계 SetText 후 break (L1947~L1952).
2. **Yearly Sum** (L1955~L1980):
   1. 왼쪽 역주사로 가장 가까운 `Y_` 컬럼 → `iStartCol = +1` (L1956~L1963).
   2. `Q_` 셀들을 Int64 합산 (L1967~L1970; L1971~L1972 else 는 동일 사유 dead).
   3. 다음 `Y_` 또는 마지막 컬럼에서 `iStartCol-1`(Y_ 컬럼)에 SetText 후 break (L1975~L1979).
   - 참고: Monthly 분기에서는 갱신된 Q_/Y_ 셀에 대한 `SetCellColor`(Red) 호출이 **없다** (분할 분기와 달리 합계 셀은 색 마킹 없음).

#### 1.4-B Quarterly 버킷 + `Q_` 컬럼 입력 (L1982~L2145) — 하위 월 균등분할 + Y_ 재합계
1. `iStartCol = e.Column + 1`; 입력 셀이 비었으면 `iQuarterlySum = 0`, 아니면 `Convert.ToInt64(값)` (L1984~L1992).
2. 분할 준비 (L1994~L2037): `long dDaycnt`(분할 대상 월 수), `long dDailyQty`(몫), `long dRemnant`(나머지), `bool bWeekAll=false`.
   1. `iStartCol` 부터 우측으로 `M_` 컬럼 개수를 `dDaycnt` 로 카운트 (L2003~L2009).
   2. `Y_`/`Q_`/마지막 컬럼 도달 시: `dDaycnt == 0` 이면(해당 분기에 월 bucket 없음) `bWeekAll = true; dDaycnt = 1` (L2013~L2023, "Bucket 이 없으면 무조건 특정일에 넣기 위해 DayCnt를 1로" 주석).
   3. **몫/나머지 계산식** (Business_Plan → split, L2025~L2029): `dDailyQty = iQuarterlySum / dDaycnt` (Int64 정수 나눗셈 = 몫), `dRemnant = iQuarterlySum % dDaycnt` (나머지). (L2030~L2034 else = copy 분기, 이 벌에서는 dead.)
3. **월 분배** — `!bWeekAll` (L2042~L2094):
   1. `iStartCol` 부터 `M_` 컬럼마다 `iCheck++`.
   2. `dDaycnt == iCheck`(= **마지막 월**)이면: `dRemnant > 0` 일 때 `dDailyQty += dRemnant`(나머지를 마지막 달에 가산) 후 SetText + `SetCellColor`(Red) (L2050~L2060).
   3. 그 외 월은 `dDailyQty` 그대로 SetText + Red (L2061~L2066). — 즉 규칙: **몫 균등, 나머지는 분기 마지막 달에 몰아줌**.
   4. L2068~L2087 의 `else if (태그 M_ && 다음 셀 값 "")` 분기는 첫 if(L2046)와 조건 앞부분이 동일해 **도달 불가 dead** (빈값 클리어용 잔존 코드).
   5. 태그가 `M` 으로 시작하지 않으면 break (L2089~L2092) — 분기 경계 종료.
4. **월 분배** — `bWeekAll`(월 bucket 없음, L2095~L2114): 해당 구간의 비어있지 않은 `M_` 셀을 전부 `""` 로 클리어 + Red (L2100~L2113, "일자별 입력은 전부 삭제" 주석). Quarterly 분기에는 Yearly 와 달리 `sDefaultDay` 요일 배분 로직이 **없음**. `iSetCol`(L2097) 선언만 있고 미사용.
5. **Yearly Sum 재계산** (L2116~L2144): 좌측 역주사로 `Y_` 탐색(L2117~L2124) → `Q_` 셀 Int64 합산(L2128~L2132; L2133~L2134 else dead) → `Y_`/마지막 컬럼 도달 시 `iStartCol-1`(Y_ 컬럼)에 SetText + `SetCellColor(e.Row, iCol …)`(주의: Red 마킹 좌표가 Y_ 컬럼(iStartCol-1)이 아니라 루프 종료 컬럼 iCol) (L2138~L2143).

#### 1.4-C Yearly 버킷 + `Y_` 컬럼 입력 (L2146~L2350) — 월 분할 + Q_ 재합계
1. `iStartCol = e.Column + 1`; 입력값 `iYearlySum = Convert.ToInt64(Convert.ToDecimal(값))` 또는 0 (L2149~L2159).
2. 변수: `long dDaycnt`, `decimal dDailyQty`, `decimal dRemnant`, `bool bMonthAll=false` (L2161~L2165). `dMonthCnt`(L2164) 선언만 있고 미사용.
3. **이번주 월요일 기준일**: `dateTime = Today.AddDays(Monday − Today.DayOfWeek)` → `sResultDate = "yyyyMMdd"` (L2167~L2168).
4. 분할 준비 (L2170~L2205): `iStartCol` 부터 `M_` 개수 = `dDaycnt` (L2172~L2178); 다음 `Y_`/마지막 컬럼 도달 시 `dDaycnt==0 → bMonthAll=true; dDaycnt=1` (L2180~L2188); Business_Plan → `dDailyQty = iYearlySum / dDaycnt`(long 정수 나눗셈 후 decimal 대입), `dRemnant = iYearlySum % dDaycnt` (L2191~L2196). (copy else L2197~L2201 dead.)
5. **월 분배** — `!bMonthAll` (L2209~L2259): `M_` 컬럼마다 `iCheck++`; `dDaycnt < iCheck` continue (L2216~L2217); 마지막 월(`dDaycnt == iCheck`)에 나머지 가산 후 SetText+Red, 그 외 월은 몫 SetText+Red (L2219~L2234). — Quarterly 와 동일한 "**몫 균등 + 나머지는 마지막 달**" 규칙. (L2236~L2257 else-if 는 1.4-B-3-4 와 같은 사유로 dead.)
6. **월 분배** — `bMonthAll`(월 bucket 없음, L2260~L2326) 2단계:
   1. 클리어 패스 (L2264~L2285): `M_` 컬럼 중 태그 말미 8자리 날짜가 `sResultDate`(이번주 월요일) **이전이면 continue = 보호**(값 유지, L2269~L2272); 그 외 비어있지 않은 셀은 `""` 클리어 + Red (L2273~L2278); `Y_`/마지막 컬럼에서 break.
   2. 요일 배분 패스 (L2288~L2325): `M_` 컬럼 중 이번주 월요일 이전은 continue 보호 (L2295~L2298); 태그 날짜를 `DateTime.ParseExact(yyyyMMdd)` 후 영문 3자 요일 대문자(`"ddd"`, en-US) 산출 (L2299~L2302); `sDefaultDay == sDayofWeek` 인 컬럼에만 `dDailyQty`(마지막 매칭 시 `+dRemnant`) SetText + Red (L2304~L2318). — **단, `sDefaultDay` 는 빈 문자열로 고정(재할당 없음)이므로 이 배분은 실제로 실행되지 않고, 결과적으로 bMonthAll 케이스는 "클리어만" 수행됨** (설계 의도 잔존 코드).
7. **Quarterly Sum 재계산** (L2328~L2349): `iQuarterlySum=0; iQuarterCol=iStartCol`; `iStartCol+1` 부터 `M_` 비공백 셀 Int64 합산 (L2333~L2337; else L2338~L2339 dead); `Q_` 또는 마지막 컬럼 도달마다 `iQuarterCol` 위치에 합계 SetText(콤마 제거) + `SetCellColor(e.Row, iCol …)` 후 `iQuarterCol = iCol`, 합계 리셋 (L2342~L2348). — 연 전체의 각 분기 Q_ 를 순차 갱신. Y_ 자체 재기입은 없음(입력 셀이 Y_).

### 1.5 비-Business_Plan 벌 (LOC 등, double 연산, L2352~L2783)
합계 변수 `double dQuarterlySum / dYearlySum` (L2354~L2355). 구조는 1.4 와 대칭이며 **의미 차이 = "split 이 아니라 copy"** (주석 L2456, L2562 등 "Measure = Business_Plan 인 경우 split. 나머지(LOC)는 copy").

#### 1.5-A Monthly + `M_` (L2357~L2413)
1. Quarterly 갱신 (L2359~L2385): 역주사로 `Q_` 탐색 후, `M_` 비공백 셀 루프에서 LOC 는 합산이 아니라 `dQuarterlySum = Convert.ToInt32(siMain.GetValue(e.Row, e.Column))` — **편집 셀 값 자체를 Int32 캐스팅해 복사** (L2375~L2376; BP 합산 분기 L2373~L2374 는 이 벌에서 dead). `Y_`/`Q_`/마지막 도달 시 Q_ 컬럼(iStartCol-1)에 SetText (L2379~L2384). 소수 LOC 값이 Int32 로 절사되는 잠재 결함 지점.
2. Yearly 갱신 (L2387~L2412): LOC 는 `dYearlySum = 0` (L2403~L2404) → **Y_ 셀은 "0" 으로 기입** (L2407~L2411).

#### 1.5-B Quarterly + `Q_` (L2414~L2577)
1. 입력값 `dQuarterlySum` = double (L2417~L2424). 월 수 카운트/`bWeekAll` 판정은 1.4-B 와 동일 (L2426~L2455).
2. LOC: `dDailyQty = Convert.ToDouble(dQuarterlySum); dRemnant = 0` (L2462~L2466) — **모든 하위 월에 동일 값 복사** (분할 아님). (BP split 분기 L2457~L2461 은 이 벌에서 dead.)
3. `!bWeekAll` 분배 (L2474~L2525): 전 월에 `dDailyQty` SetText + Red (마지막 월 remnant 가산 코드는 존재하나 dRemnant=0 이므로 무영향, L2482~L2498). L2500~L2519 else-if dead (1.4-B 와 동일 유형).
4. `bWeekAll` (L2527~L2546): 비공백 `M_` 전부 클리어 + Red.
5. Yearly 재계산 (L2548~L2576): LOC 는 `dYearlySum = 0` (L2565~L2566) → **Y_ 에 "0" 기입** + SetCellColor(iCol 좌표) (L2570~L2575).

#### 1.5-C Yearly + `Y_` (L2578~L2782)
1. 입력값 `dYearlySum` = double (L2584~L2591). 변수 `double dDailyQty/dRemnant`, `bMonthAll`, 이번주 월요일 `sResultDate` (L2593~L2600, Monday 연산 L2599 는 Int32 캐스팅으로 1.4-C 의 Int64 판과 형만 다름).
2. LOC: `dDailyQty = dYearlySum; dRemnant = 0` (L2629~L2633) — 전 월 복사. (BP split L2623~L2628 dead.)
3. `!bMonthAll` 분배 (L2641~L2691): 1.4-C-5 와 동일 구조 (dead else-if L2668~L2689 포함).
4. `bMonthAll` (L2692~L2758): 이번주 월요일 이전 `M_` 보호(continue, L2701~L2704 / L2727~L2730) 후 클리어 패스(L2697~L2717) + `sDefaultDay` 요일 배분 패스(L2720~L2757, **동일하게 런타임 dead**).
5. Quarterly 재계산 (L2760~L2781): LOC 는 `dQuarterlySum = 0` (L2770~L2771) → **각 Q_ 에 "0" 기입** (L2774~L2780).

### 1.6 Red(dirty) 마킹 정리
- 편집 셀 자체의 Red 는 이 핸들러가 아니라 프레임워크/선행 로직이 부여한 것을 **전제조건으로 검사** (L1909~L1911).
- 핸들러가 파생 기입하는 셀(분할 월, 재합계 Q_/Y_ 일부)은 `SetCellColor`(L3353~L3360)로 Red 마킹 → SaveData 의 수집 조건(§3.4)과 연결됨. 단, **Monthly 입력 시의 Q_/Y_ 합계 셀(L1950, L1977 / L2382, L2409)은 Red 마킹 없이 SetText 만** 수행.

### 1.7 관련 보조 이벤트
- `spdMain_EditChange` (L3038~L3045): DIVISION_ID 이하 키영역이면 return, 아니면 `bPasteContinue = true` 세팅.
- `ValidationCheck` (L2788~L2797): `bPasteContinue` 일 때 MSG00002 표시 후 셀 클리어(CanModelChange 토글로 재진입 차단) — **본 파일 내 호출부 없음(미사용 메서드)**.
- `spdMain_TopChange` (L2799~L2804): 스크롤 시 `SmartColMerge` 재수행 (CanModelChange 토글).
- `spdMain_KeyUp` (L2806~L2823): 본문 전체 주석 — **비활성**.

---

## 2. EditButton — F2 편집 잠금 재계산 (핸들러 `EditButton` override, L563~L697)

1. `sDivision` 산출 (L565). `this.fps != null` 가드 (L567).
2. 필수 컬럼 체크(MinColumnChk → MSG00113) 블록은 **주석 처리 = 비활성** (L569~L574).
3. `siMain = GetSheetInfo(...)` 재취득 (L576) → **`siMain.SwitchLock()`** (L577): 시트 전체 잠금 상태 토글(편집 모드 진입/해제). 이후 로직은 "풀린 상태에서 다시 잠글 곳"을 선별 잠금.
4. **버킷별 데이터 컬럼 잠금 루프** (L580~L638, `MEASURE` 컬럼부터 최대 컬럼까지):
   - Monthly (L582~L597): 태그가 `M_` 로 시작하지 않으면(`Q_`, `Y_`) `LockColumn(iCol, iCol, true)` (L584~L585). `M_` 인 경우: `sDivision == "40" && valid_YN == "Y"` 이면 컷오프 창 검사 — `int.Parse(start_YYYYMM) > 태그월` 또는 `int.Parse(end_YYYYMM) < 태그월` 이면 LockColumn (L588~L595). (40 이 아니거나 valid_YN != "Y" 면 M_ 는 열림.)
   - Quarterly (L598~L617): `Q_` 아니면 LockColumn (L600~L601). `Q_` 인 경우: `sDivision=="40" && valid_YN=="Y" && start_YYYYQQ != "" && end_YYYYQQ != ""` 일 때만 창 밖(`start_YYYYQQ > 태그` 또는 `end_YYYYQQ < 태그`, 태그는 `Q_`·`_` 제거 후 숫자화) LockColumn (L604~L611); **그 조건이 아니면 무조건 LockColumn** (L612~L615) — 즉 Quarterly 직접 입력은 40 + 유효 컷오프 창일 때만 허용.
   - Yearly (L618~L637): `Y_` 아니면 LockColumn (L620~L621); `Y_` 는 40 + `valid_YN=="Y"` + `start_YYYY/end_YYYY` 비공백일 때 창 밖 잠금 (L624~L631), 아니면 무조건 잠금 (L632~L635). Quarterly 와 동일하게 40 전용.
   - 컷오프 창 원천: FindData 결과 `Tables[1]` 의 `VALID_YN / START_* / END_*` (L831~L840).
5. **행 루프** (L640~L695, 0~최대행):
   1. L642~L644 의 구버전 코드는 주석 = 비활성.
   2. `sEdit = EDIT_FLAG 값`, `sMeasure = MEASURE 값` (L646~L647).
   3. **키영역 잠금**: `LockRange(iRow, 0, iRow, MEASURE컬럼, true)` (L649) — 키/속성 컬럼은 편집 모드에서도 잠금.
   4. L651~L667: "Business Plan 인 경우 Incoterms/FCST_TYPE 컬럼을 열어준다" 블록(40 + EDIT_FLAG=Y + Incoterms·FcstType 빈값 조건의 unlock/lock) — **전체 주석 처리 = 비활성**. 현행 코드에는 40+Business_Plan 행의 Incoterms/FcstType unlock 이 존재하지 않음.
   5. **편집 대상 행 선별 해제** (L670~L685): `sEdit == "Y"(CAppSetting.StringY)` && `sMeasure ∈ {Business_Plan, LOC}` 인 행만 — MEASURE+1 부터 전 컬럼에 대해 `iValue = 태그.Substring(2,4)` (연도 4자리) 를 취해 `DateTime.Now.Year > iValue` 이면 `LockRange(그 셀, true)` (L675~L680). 즉 **과거 연도 셀만 잠그고 당해 연도 이후는 4단계 컬럼 잠금 결과를 따름**.
   6. 그 외 행(EDIT_FLAG≠Y 또는 다른 measure)은 데이터 영역 전체(`MEASURE+1`~max) `LockRange(true)` (L686~L689).
   7. **Edit 모드 해제 시**(SwitchLock 으로 잠금 복귀, `!IsEditMode`): 키영역 재잠금 `LockRange(iRow, 0, iRow, MEASURE, true)` (L692~L694, "Edit 모드를 풀었을 경우, 2021.07.29" 주석).
6. LockRange/LockColumn 호출 전수(활성 코드): LockColumn = L585, L593, L601, L609, L614, L621, L629, L634 (8개소). LockRange = L649, L680, L688, L694 (4개소).
7. 파생 이벤트: `cboBucketType_SelectedIndexChanged` (L1612~L1626)는 편집 모드 중 버킷 변경 시 `SetSpreadColumn()` 후 **`EditButton()` 을 2회 호출**(L1621~L1622, 토글 복원 목적 주석 L1620)하여 편집 모드를 유지한 채 잠금 재계산.

---

## 3. SaveData — F7 저장 payload 조립 (핸들러 `SaveData`, L862~L1209; 진입 `SaveButton` L699~L702)

### 3.1 진입 가드 (L864~L873)
1. `siMain != null && siMain.IsLock(...) == false` — **편집 모드일 때만** 진행 (L864). 시트명 `"Biz Plan"` 확인 (L866).
2. `MinColumnChk() == false` → `MSG00113` 후 return (L869~L873). MinColumnChk (L3387~L3448) 는 **컬럼 존재 검사**(Column Show 로 숨겨진 필수 컬럼 감지):
   - div `81*` (L3391~L3410): DIVISION_ID, PROJECT_CODE, INCOTERMS, SCM_SITE_ID81, PLANT_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, FCST_TYPE, CURRENCY, MEASURE 중 하나라도 인덱스 -1 이면 false. (BIZ_TYPE_NAME81 검사는 주석 = 비활성.)
   - div `82` (L3411~L3427): DIVISION_ID, DEPT_ID, UNIT_ENERGY, CURRENCY, MEASURE. (PROJECT_CODE82/SCM_SITE_ID82/ITEM_ID/END_CUSTOMER 검사는 주석 = 비활성.)
   - 그 외=40 (L3428~L3446): DIVISION_ID, END_CUSTOMER40, SCM_SITE_ID40, ITEM_ID40, MEASURE, INCOTERMS, FCST_TYPE, CURRENCY, CELL_PROD_SITE. (PROJECT_NAME, DOM_EXP 주석 = 비활성.)

### 3.2 payload 변수 (L875~L905)
'^' 연결 문자열 21종 + 카운터: `pAction, pDivision, pProjectCode, pProjectName, pScm_Site_Id, pItem_Id, pFcst_Type, pIncoterms, pCurrency, pMeasure, pPlant_Site_Id, pYyyyMM, pInput, pUserID, pCell_Prod_Site, p_DEPT_ID, p_END_CUSTOMER, p_BIZ_TYPE, p_ITEM_USE, p_UNIT_ENERGY` + `iCount`, `iLOCRow`. (`pDom_Exp`, `p_CELL_PER_*` 등은 주석 = 비활성.)

### 3.3 행 그룹 루프 (L907~L1144)
1. `i` 를 `dtMeasure.Rows.Count` 스텝으로 증가 — 그룹 첫 행 = **Business_Plan 행**, 그룹 내에서 `MEASURE == "LOC"` 인 행을 탐색해 `iLOCRow` 확정 (L907~L917). 루프 상한이 `GetMaxRowIndex() - 1` 임(마지막 인덱스 미포함 형태, L907 원문 그대로).
2. `action`(첫 행), `action2`(LOC 행) = Action 컬럼 텍스트 (L919~L920); `sMeasure` = 첫 행 measure (L922).
3. skip 조건: 두 action 모두 I/M 이 아니면 continue (L924~L925); measure 가 `Business_Plan`/`LOC`/`MKT_FCST` 가 아니면 continue (L927~L928).

### 3.4 변경(Red) 셀 수집 — 컬럼 루프 (L933~L1142)
1. `MEASURE+1` 부터 전 컬럼: 태그에 `Q_`/`Y_` 포함 시 continue — **M_ 월 컬럼만 수집** (L935~L936).
2. BP 행·LOC 행 값이 **둘 다** 빈 컬럼은 continue (L938~L939).
3. 색 검사: BP 셀 색 `vColor`, LOC 셀 색 `vColor2` — 둘 다 Red 가 아니고 `strYYMM != ""` 이면 continue (L941~L945). 주석 L932: "값이 있는 첫번째 년월은 수정여부에 관계없이 수정한 것으로 본다 (PKUPDATE 용도)" — 즉 **첫 유효 년월 1건은 무조건 수집**되고, 이후는 Red(dirty) 컬럼만 수집.
4. **Business_Plan 행 수집** (`i != iLOCRow` 가드, L948~L1067):
   1. `pAction += "^" + (action=="" ? action2 : action)` (L950); `pDivision`(DIVISION_ID), `pMeasure`(i 행), `pCurrency`, `pPlant_Site_Id` 를 `ParameterString` 으로 append (L951~L956).
   2. **div 분기 필수값 검증 + 매핑**:
      - `DIVISION_ID == "40"` (L958~L987): 셀 값 빈칸 검사 — `END_CUSTOMER40`(L961, L963 에서 **동일 검사 중복 2회**), `SCM_SITE_ID40`, `ITEM_ID40`, `CURRENCY`, `FCST_TYPE`, `INCOTERMS`, `CELL_PROD_SITE` 중 하나라도 "" → `MSG00310` return (L973~L975). (PROJECT_NAME L962, DOM_EXP L970 검사 주석 = 비활성.) 매핑: `pProjectCode←END_CUSTOMER40`, `pFcst_Type←FCST_TYPE`, `pIncoterms←INCOTERMS`, `pScm_Site_Id←SCM_SITE_ID40`, `pItem_Id←ITEM_ID40`, `p_DEPT_ID←DEPT_ID40`, `p_END_CUSTOMER←END_CUSTOMER40`, `p_BIZ_TYPE←BIZ_TYPE_NAME40` (L977~L986).
      - `DIVISION_ID` 앞 2자리 `"81"` (L988~L1020): 빈칸 검사 대상 — `PROJECT_CODE, DEPT_ID, SCM_SITE_ID81, PLANT_SITE_ID, ITEM_ID, END_CUSTOMER, FCST_TYPE, INCOTERMS, CURRENCY` → `MSG00310` (L991~L1006). 매핑: `pProjectCode←PROJECT_CODE`, `p_DEPT_ID←DEPT_ID`, `pScm_Site_Id←SCM_SITE_ID81`, `pItem_Id←ITEM_ID`, `p_END_CUSTOMER←END_CUSTOMER`, `pFcst_Type`, `pIncoterms`, `p_BIZ_TYPE←BIZ_TYPE_NAME81` (L1008~L1019).
      - 그 외(=82, L1021~L1044): 빈칸 검사 대상 — `DEPT_ID, CURRENCY, UNIT_ENERGY` 3개만 → `MSG00310` (L1024~L1030). 매핑: `pProjectCode←PROJECT_CODE82`, `pFcst_Type`, `pScm_Site_Id←SCM_SITE_ID82`, `pItem_Id←ITEM_ID`, `p_DEPT_ID←DEPT_ID`, `p_END_CUSTOMER←END_CUSTOMER`, `p_BIZ_TYPE←BIZ_TYPE_NAME82` (L1033~L1043). (INCOTERMS82 append 는 주석 = 비활성 L1036.)
   3. 컬럼 존재 시 append: `pProjectName←PROJECT_NAME`, `p_ITEM_USE←ITEM_USE`, `p_UNIT_ENERGY←UNIT_ENERGY`, `pCell_Prod_Site←CELL_PROD_SITE` (L1046~L1061).
   4. `pYyyyMM += "^" + 태그.Replace("M_","")`; **빈값→"0"**: `strQty = (BP 셀 값=="" ? "0" : 값)` → `pInput` append; `pUserID += "^" + UserId` (L1063~L1066).
5. **LOC 행 수집** (같은 컬럼에서 항상 1건 추가 — **BP+LOC 2행 1조 원칙**, L1069~L1141):
   1. `pAction`/`pDivision`/`pCurrency` 는 i 행 기준, **`pMeasure` 만 iLOCRow 행 기준** (L1070~L1073).
   2. div 분기 매핑 반복 (검증 없음): 40 (L1075~L1087), 81* (L1088~L1101, 여기서는 `pPlant_Site_Id←PLANT_SITE_ID` 도 append L1093), 82 (L1102~L1118).
   3. `pProjectName` 무조건 append (L1120); `p_ITEM_USE`, `p_UNIT_ENERGY`, `pPlant_Site_Id`, `pCell_Prod_Site` append (L1128~L1131).
   4. `pYyyyMM` append; `strQty = LOC 셀 값 또는 "0"` → `pInput`; `pUserID` (L1133~L1136).
   5. `strYYMM = 태그.Replace("M_","")` 갱신(첫 유효 년월 마커, L1139); `iCount++` (L1141).
6. 그룹 종료 시 `iLOCRow = 0` 리셋 (L1143).

### 3.5 사후 검증 (L1146~L1156)
1. `iCount == 0` → `MSG00275` (저장 대상 없음) return (L1146~L1150).
2. `fnValidation() == false` → `MSG00043`("저장시 중복 오류…") return (L1152~L1156). 단 `fnValidation` (L3201~L3340)의 실제 구현: 신규(I) 행에 대해 **중복 키 비교 로직은 전부 주석 처리(비활성**, L3257~L3267, L3283~L3292, L3305~L3314)되어 있고, 현행 활성 코드는 div 별 **컬럼 인덱스 -1 존재 검사만** 수행(81*: L3268~L3279 / 82: L3293~L3301 / 40: L3315~L3324, `iValidation > 1` 시 false L3327~L3337). 즉 실질적 중복검사는 미동작.

### 3.6 SP 호출 — '^' 21 param 조립 순서 (L1158~L1195)
`FoxDataRequest("DM.DMF0042_SAVE_DM_PLN_BP_FCST")` (L1162). 각 파라미터는 선두 '^' 제거(`Remove(0,1)`) 후 세팅. **등록 순서 전수 (21개)**:
1. `p_active_flag` ← pAction (L1163)
2. `p_DIVISION_ID` (L1164)
3. `p_PROJECT_CODE` (L1165)
4. `p_PROJECT_NAME` (L1166)
5. `p_SCM_SITE_ID` (L1167)
6. `p_PLANT_SITE_ID` (L1168)
7. `p_ITEM_ID` (L1169)
8. `p_FCST_TYPE` (L1171) — (`p_DOM_EXP` L1170 은 주석 = 비활성)
9. `p_INCOTERMS` (L1172)
10. `p_MEASURE` (L1173)
11. `p_YYYYMM` (L1174)
12. `p_QTY` ← pInput (L1175)
13. `p_CURRENCY` (L1176)
14. `p_DEPT_ID` (L1179)
15. `p_END_CUSTOMER` (L1180)
16. `p_BIZ_TYPE` (L1181) — (`p_CELL_PER_PACK/CELL_PER_MODULE/MODULE_PER_PACK` L1182~L1184 주석 = 비활성)
17. `p_ITEM_USE` (L1187)
18. `p_UNIT_ENERGY` (L1188)
19. `p_CELL_PROD_SITE` (L1189)
20. `p_CREATED_BY` ← pUserID (L1191)
21. `p_LAST_UPDATED_BY` ← pUserID (L1192)

`ParameterString` (L3144~L3176) 규칙: 컬럼 존재 시 값 append — 단 `INCOTERMS`/`FCST_TYPE` 은 빈값을 공백 1칸 `" "` 으로 (L3148~L3152), `CELL_PER_PACK/CELL_PER_MODULE/MODULE_PER_PACK/UNIT_ENERGY` 는 빈값을 `"0"` 으로 (L3154~L3159); 컬럼 부재 시 `"^"` 만(UNIT_ENERGY 류는 `"^0"`) append (L3163~L3172).

### 3.7 결과 처리 (L1194~L1207)
1. `sRet = Tables[0].Rows[0][0]` (L1194).
2. `sRet != "success"` → `MessageBox.Show(sRet, "Error!")` return (L1197~L1201) — [E20240731-000845] "코드로 던지도록 수정" 이력.
3. 성공 → `MSG00004`(건수 `iCount` 바인딩) (L1204) → **`FindData()` 재조회** (L1206).

---

## 4. FindData — F5 조회 (핸들러 `FindData`, L745~L860; 진입 `FindButton` L539~L542)

1. `CanModelChange = false` (L747) — spdMain_Changed 차단. (본 메서드 내에서 true 복원 코드는 **없음** — 복원은 L350 DefineProperty/기타 경로.) ProgressForm 생성 (L749).
2. **검증**:
   1. `sDivision == ""` → `MSG00097` return (L756~L760).
   2. `drpPeriod` 값 `':'` split (L762); `from > to` → `MSG00108` return (L764~L768).
   3. `Value1 + 6년 < Value2` → `MSG00276` + `Value2 = Value1.AddYears(6)` 로 클램프 후 return (L770~L775).
3. **기준일(sNowDate) 산출** (L777~L782): `GetThisWeekMonday`(L3086~L3105, 오늘부터 하루씩 감소하며 월요일 탐색) 로 이번주 월요일; 조회 시작일이 이번주 월요일 이상이면 `sNowDate = sPeriod[0]`, 종료일이 이번주 월요일 이하면 `sNowDate = (Value2 + 1일).yyyyMMdd`.
4. `InitSpread()` (L784): `GetSpdTitle`(L2947~L2962, SP `DM.DMF0042_GET_SPREAD_TITLE`, 파라미터 순서 `p_start_yyyymmdd → p_end_yyyymmdd → p_created_by → p_division_id`) 로 타이틀 재조회 → `CreateSheetHeaderColumnDtDiv` 헤더 재구성 (L389) → 40 이면 CELL_PROD_SITE 콤보 재바인딩 (L392~L397) → `SetSpreadHeaderSpan` + `SetSpreadColumn` (L400~L404).
5. `prg.Show()` (L786); `FoxAsyncProxy` 준비 (L788~L789); `SearchStartTime()` (L792).
6. **SP 호출** `DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA`, `CommandTimeout = 30*60`초 (L800~L802). **파라미터 실명 순서 전수 — 16개** (L804~L819; 과업 지시문의 "17개"와 달리 실측 16개):
   1. `p_division_id` (L804)
   2. `p_dept_id` ← clbTeam (L805)
   3. `p_end_customer` ← clbCustomer (L806)
   4. `p_scm_site_id` ← clbSalesSite (L807)
   5. `p_project_code` ← txtProject (L808)
   6. `p_item_id` ← txtItemId (L809)
   7. `p_item_type` ← clbItemType (L810)
   8. `p_from_yyyymmdd` ← sPeriod[0] (L811)
   9. `p_now_yyyymmdd` ← sNowDate (L812)
   10. `p_to_yyyymmdd` ← sPeriod[1] (L813)
   11. `p_created_by` ← UserId (L814)
   12. `p_plant_site_id` ← clbPlantSite (L815)
   13. `p_biztype` ← clbBizType (L816)
   14. `p_userinfo` ← NowGroupID (L817)
   15. `p_owner` ← txtOwner.Trim() (L818)
   16. `p_qty_yn` ← cboQty.Checked ? "Y" : "N" (L819)
7. **Tables[0] 소비**: `siMain.Query(ds.Tables[0].DataSet)` 로 그리드 바인딩 (L828) → 직후 `siMain.LockColumn(0, GetMaxColumnIndex(), true)` 전 컬럼 잠금(조회 직후 = 읽기전용) (L829).
8. **Tables[1] 소비** (L831~L840): 행이 있으면 `VALID_YN → valid_YN`, `START_YYYYQQ/END_YYYYQQ`, `START_YYYYMM/END_YYYYMM`, `START_YYYY/END_YYYY` 를 멤버에 보관 — EditButton(§2-4)·InsertRow(§5-8) 의 40 컷오프 편집창 판정에 사용.
9. `siMain.SmartColMerge()` 머지 (L842) → `SearchEndTime()` (L845) → `SuspendLayout()` (L847).
10. 예외 시 `MessageHelper.GMessageBoxForException(ex)` (L849~L852); finally 에서 `prg.Close()` + `ResumeLayout()` (L853~L858).

---

## 5. InsertRow — F8 행 삽입 (핸들러 `InsertRow`, L1211~L1480; 진입 `InsertButton` L544~L547)

1. 가드: `siMain != null && IsLock == false`(편집 모드) (L1213), 시트명 확인 (L1215).
2. **measure 조 단위 삽입 위치**: `GetCellNumbersByRow(ActiveRowIndex)` 로 현재 measure 그룹의 물리행 배열을 얻고 그 첫 행에 ActiveCell 이동 (L1217~L1218) → `siMain.Insert(dtMeasure.Rows.Count)` 로 **measure 수만큼 행 일괄 삽입** (L1220).
3. div 준비 (L1222~L1233): `dtBizType81 = GetLookupData("DM_BIZ_TYPE_81")` (L1224); div 40 은 추가 조회 없음(블록 주석 = 비활성 L1228~L1230), 그 외는 `dtCustomer = Data.UserEndCustomerByDivisionDeptAuth(...)` (L1232~L1233).
4. **팝업 이미지 셀타입** (`cellTypeImage`, L1236~L1243): `PROJECT_CODE`, `PROJECT_CODE82`, `ITEM_ID`, `ITEM_ID40` 존재 시 활성 행에 세팅. `CURRENCY` 는 `SetCellTypeCombo(insCell.Row.Index, …, dtCurrencyList)` (L1244~L1245).
5. **콤보 데이터 준비** (L1248~L1252): `dtSalesSiteAuth` = 40 이면 `UserSiteByEndCustomerAuth`, 아니면 `UserSiteByEndCustomer`; `dtTeamAuth = UserTeamByDivisionAuth`.
6. **콤보 세팅 전수** (L1254~L1278): `DEPT_ID40`(40 일 때, dtTeamAuth) / `DEPT_ID`(비40, dtTeamAuth) / `END_CUSTOMER`(dtCustomer) / `END_CUSTOMER40`(dtCustomer) / `SCM_SITE_ID40`·`SCM_SITE_ID81`·`SCM_SITE_ID82`(dtSalesSiteAuth) / `CURRENCY`(dtCurrencyList, L1244 와 중복 2회 세팅) / `BIZ_TYPE_NAME81`(dtBizType81) / `CELL_PROD_SITE`(40 일 때, `GetCellProdSite("DM_CELL_PROD_SITE","Y")` L1274~L1278, [C20220513-000327]·[E20240731-000845]).
7. **measure 행별 잠금 루프** (L1281~L1473, `i = 0 ~ dtMeasure.Rows.Count-1`, `iRowNo = ActiveRowIndex + i`):
   1. `DIVISION_ID` 에 `clbDivision.ControlValues` SetText 후 잠금 (L1285~L1286) — **기본값 세팅은 DIVISION_ID·MEASURE 2개뿐**(다른 컬럼 기본값 주입 없음).
   2. 40 이면 `PROJECT_CODE` 잠금 (L1292~L1293).
   3. **파생/표시 전용 컬럼 잠금 (존재 검사 후 LockRange) — 활성 코드 전수 40종** (L1296~L1388): `CUST_GROUP, CUST_GROUP_DTL, OWNER, APPLICATION, ROUTE, BIZ_TYPE_NAME82, BIZ_TYPE_NAME40, ITEM_CLASS_NAME, ITEM_NAME, ITEM_TYPE, NICK_NAME, PLANT_SITE_ID(단 div 앞2자리가 "81" 이 아닐 때만 L1320~L1324), VERSION_NO, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_PACK_COUNT, PRODUCT_GROUP_NAME, SHIPTO_DESCRIPTION, CELL_TYPE, INTERNAL_YN, COUNTRY_NAME, CITY_NAME, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, VMI_YN, PRIORITY, DMS_SALES, DMS_CUSTOMER, REPORT_GROUP1~REPORT_GROUP8(8종), EDIT_FLAG, CELL_PER_CAR, MODULE_PER_CAR`. (비활성 주석: PROJECT_NAME L1294~L1295, BIZ_TYPE_NAME81 L1306~L1307, CELL_PER_PACK/CELL_PER_MODULE/MODULE_PER_PACK L1353~L1358.)
   4. **MEASURE 세팅**: `dtMeasure.Rows[i]["NAME"]` SetText + 잠금 + `SetCellColor`(Red — 신규행 마커) (L1390~L1393). `sMeasure = dtMeasure.Rows[i]["CODE"]` (L1390).
   5. 파생(읽기전용) measure 판정: `sMeasure ∈ {KRW, USD, SalesAmt_KRW, SalesAmt_USD, SalesAmt_LOC, CAR_QTY}` 이면 데이터 영역 전체(`MEASURE+1`~max) 잠금 (L1395~L1400).
   6. 그 외(입력 measure = Business_Plan/LOC 계열): **EditButton §2-4 와 동일 패턴의 버킷별 셀 잠금**을 행 단위 LockRange 로 적용 (L1404~L1461 — Monthly L1406~L1421 / Quarterly L1422~L1441 / Yearly L1442~L1461, 40+valid_YN 컷오프 창 동일) + **과거 연도 잠금**: `MEASURE+1` 이상 컬럼에서 `태그.Substring(2,4)` 연도가 당해 연도 미만이면 잠금 (L1463~L1470).
8. **`SetRowSpanFuc`**: `CUIControl.SetRowSpanFuc(siMain, ActiveRowIndex, dtMeasure.Rows.Count - 1, 1, MEASURE 컬럼 인덱스, 가로 Left, 세로 Center)` — 신규 그룹의 키영역(0~MEASURE)을 measure 수만큼 세로 병합 (L1475).
9. 참고: 신규행 삭제는 `DeleteButton` (L549~L561) — Action 이 `I` 인 행만, `GetCellNumbersByRow` 로 그룹 전체 행을 역순 삭제.

---

## 6. spdMain_ComboSelChange — div40 2단 cascade (핸들러 L1628~L1659)

콤보 편집 확정 시 호출. `sDivision = clbDivision.ControlValues` (L1630).

1. **1단: END_CUSTOMER40 변경 시** (L1631~L1639):
   1. 변경 컬럼 == `END_CUSTOMER40` && `sDivision == "40"` (L1631~L1633).
   2. 해당 행의 `END_CUSTOMER40` 셀 값(`sEndCustomer`)을 읽어 (L1635)
   3. `Data.UserSiteByEndCustomer(NowGroupID, UserId, "40", sEndCustomer)` 조회 (L1636)
   4. **같은 행의 `SCM_SITE_ID40` 셀 콤보를 그 결과로 재바인딩** (`SetCellTypeCombo`, L1637). (기존 선택값 클리어 로직은 없음 — 재바인딩만.)
2. **2단: DEPT_ID40 변경 시** (L1640~L1658):
   1. `sDivision == "40"` && 변경 컬럼 == `DEPT_ID40` (L1640), `END_CUSTOMER40` 컬럼 존재(>0) 가드 (L1642).
   2. 행의 `DEPT_ID40` 값 → `sTeam`; 빈값이면 조회조건 `clbTeam.ControlValues` 로 폴백 (L1644~L1648).
   3. `Data.Common(Data.Type.EndCustomerByDivision40, false, "40", sTeam, NowGroupID, UserId)` 조회 → **행의 `END_CUSTOMER40` 콤보 재바인딩** (L1649~L1652).
   4. 이어서 행의 **현재** `END_CUSTOMER40` 값(`sEndCustomer`)을 다시 읽어 (L1654) `UserSiteByEndCustomer` 조회 → **행의 `SCM_SITE_ID40` 콤보까지 연쇄 재바인딩** (L1655~L1656). — 즉 `DEPT_ID40 → END_CUSTOMER40 → SCM_SITE_ID40` 2단 cascade.
3. 40 외 division 및 다른 컬럼에 대한 처리는 이 핸들러에 없음. (81/82 는 InsertRow 시점 정적 콤보만 사용.)

---

## 7. 커스텀 액션 버튼 4종

### 7.1 btnSetPrice_Click — Set Price 환산 (L3178~L3199)
1. 가드: 없음(편집모드/권한/조회여부 검사 모두 없음). **확인창** `MSG00282` — `DialogResult.No` 면 return (L3180~L3181).
2. SP 호출 `DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV`, `CommandTimeout = 30*60`초; 파라미터 `s_flag = ""`, `s_division_id = clbDivision.ControlValues` 2개 (L3185~L3193).
3. 결과 `Tables[0].Rows[0][0]` 문자열을 `GMessageBox` 로 표시 (L3196).
4. 후처리: **`FindData()` 재조회** (L3198).

### 7.2 btnExchangeRate_Click — 환율 팝업 (L3048~L3068, [PJ20200138] Division 추가)
1. 가드: `!siMain.IsLock(...)`(= 편집 모드 중)이면 `MSG00142` 후 return (L3050~L3054). 권한 가드 없음.
2. `DMF0042_ExchangeRatePopup` 생성, `LoadData(drpPeriod.Value1 "yyyyMM", Value2 "yyyyMM", "BP", clbDivision.ControlValues)` (L3056~L3057) → CenterParent `ShowDialog` (L3059~L3060). (SP 호출은 팝업 내부 책임.)
3. `popup.blnOK` 이면: `dtFuturePrice = GetFuturePriceInfo()` (L3064) — SP `DM.DMF0042_GET_EXCHANGE_PRICE` (L3070~L3084, `p_start_yyyymmdd` = Value1 yyyyMM+"01", `p_end_yyyymmdd` = Value2 yyyyMM+"01") → **`FindData()` 재조회** (L3066).

### 7.3 btnCutOff_Click — Version Cut-Off (L2903~L2929)
0. 사전 권한: `DefineProperty` (L354~L367)에서 `NowGroupID` 가 `ADMIN`/`DM ADMIN` 일 때만 버튼 Enabled/Visible — 그 외 그룹은 버튼 자체 숨김.
1. 가드: `!siMain.IsLock(...)`(편집 모드 중)이면 `MessageBox.Show("Edit Mode is not allowed.")` 후 return (L2905~L2909).
2. `sVersion_Type = "BP_M"` (L2912; `"REPORT_BP_M"` 은 주석 = 비활성 L2911), `sFoxData = "DM.DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF"` (L2913).
3. `VersionCutOffPopUp` 생성 → `popup.LoadDataDiv(sVersion_Type, sFoxData, sDivisionId)` ([PJ20200138] Division 추가, L2915~L2920) → CenterParent `ShowDialog` (L2922~L2923). (SP 실행은 팝업 내부.)
4. 후처리: `popup.blnOK` 분기 존재하나 **본문 빈 블록 — 재조회 등 후처리 없음** (L2925~L2928).

### 7.4 btnReplace_Click — Current 버전 특정 컷오프로 덮어쓰기 (L3470~L3562, [C20221025-000029])
1. 가드 1(편집모드): `!siMain.IsLock(...)` 이면 `MessageBox.Show("Edit Mode is not allowed.")` return (L3472~L3476).
2. 가드 2(권한): `NowGroupID` 가 `ADMIN`/`DM ADMIN` 이 아니면 동일 메시지 후 return (L3478~L3484).
3. 가드 3(미조회): `spdMain.Sheets[0].RowCount == 0` 이면 `MessageBox.Show("데이터 조회 후 다시 시도해 주시기 바랍니다.")` return (L3494~L3498).
4. **대상 년월 범위 산출** (L3487~L3539): 현재 셀 선택영역 `cr = GetSelection(0)` (L3487~L3488).
   - 선택영역 없음(`cr == null`): `StartDate/EndDate = drpPeriod.Value1/Value2` 의 앞 7자 `-` 제거 = yyyyMM (L3503~L3507).
   - 선택영역 있음: 선택 컬럼 범위를 순회하며 태그 앞 2자가 `M_` 인 컬럼의 `Substring(2,6)`(yyyyMM)을 DataTable `YYYYMM` 에 수집 (L3510~L3523) → 수집분의 첫/끝 행이 Start/End (L3529~L3533); 수집 0건이면 `drpPeriod` 의 yyyyMMdd 로 폴백 (L3534~L3538).
5. `sVersion_Type = "BP_M"`, `sFoxData = "DM.DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF"` (L3544~L3547).
6. `ReplaceByCutOffPopUp` 생성 → `popup.LoadDataDiv(sVersion_Type, sYYYYMM_from, sYYYYMM_to, sFoxData, sDivisionId)` (L3549~L3553) → CenterParent `ShowDialog` (L3555~L3556). (SP 실행은 팝업 내부.)
7. 후처리: `popup.blnOK` 분기 **빈 블록 — 재조회 없음** (L3558~L3561).

---

## 부록. 본 문서 범위 밖의 기타 핸들러 (참고 위치만)
- `spdMain_CellDoubleClick` (L1661~L1861): 헤더 더블클릭 Y_/Q_ 하위 컬럼 토글 접기(L1663~L1702) + `ITEM_ID/ITEM_ID40` 더블클릭 `DM0002_ItembyDivisionPopupEx`(L1703~L1761, 신규 I 행만) + `PROJECT_CODE`/`PROJECT_CODE82` 더블클릭 `SCM0002_ProjectbyDivisionPopupEx`(L1762~L1860).
- 조회조건 cascade: `cboDivision_SelectedIndexChanged` (L1485~L1570), `clbTeam_SelectedIndexChanged` (L1572~L1596), `clbCustomer_SelectedIndexChanged` (L1598~L1610).
- `cboBucketType_Click` (L3026~L3036): 신규(I) 행 존재 시 `MSG00227` 로 버킷 변경 경고.
- `btnProject_Click` (L2825~L2845) / `btnItemId_Click` (L2847~L2868) / `btnOwner_Click` (L3005~L3024): 조회조건 팝업.
- `btnColumn_Click` (L2870~L2880) / `btnMeasure_Click` (L2882~L2893): `DM0002_TitleSetForm_Popup`("DMF0042") — OK 시 `InitSpread()` 재구성.
- `chkSum_CheckedChanged` (L2895~L2901): `SetSpreadColumn()` 재적용.
- `ExcelButton` override (L705~L738, [E20240906-001717]): `SimplexelService.ExportFpSpread` 고속 엑셀 내보내기.
- `btnIncotermsChg_Click` (L2990~L3003): 전체 주석 = **비활성** ([C20221024-000510] DM0002_MasterChgPopup 미사용 정리).
