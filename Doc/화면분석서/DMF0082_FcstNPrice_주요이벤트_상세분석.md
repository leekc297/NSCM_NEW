# DMF0082 Fcst&Price MGMT — 주요 이벤트 상세분석

| 항목 | 내용 |
|---|---|
| 원천 소스 | `C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.cs` |
| 총 행수 | 9,419행 (전수 Read 완료) |
| 분석일 | 2026-07-20 |
| 분석 기준 | **[PJ2025-50188] 고도화 후 활성 신로직 기준.** 구 로직(약 3,900행)은 `//` 주석으로 보존되어 있으며, 각 이벤트 하단 "구 로직(비활성)" 절에 라인 범위만 분리 기재. |
| 화면 성격 | 소형사업부(Division 40) 전용 Fcst&Price 관리. Bucket(Daily/Weekly/Monthly) 3단 계층 grid(FarPoint Spread), Measure = MKT_FCST / SCM_FCST / VMI_In_Req / LOC(Price) 4종. |

주요 전역 상태 (L68~L300):
- `dtSave` / `dtSaveFinal` (L74~75, 스키마 정의 L631~666): 일(D_) 단위 저장 버퍼. 컬럼 = Action, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY(decimal).
- `bEDIT_AUTH_SCM_FCST / MKT_FCST / LOC / VMI_IN_REQ` (L119~122): Measure별 편집권한 4종. FindData 결과 `dsMain.Tables[3]`에서 세팅 (L9143~9178).
- `list_EDIT_Week / Month / Day / Month_M4` (L128~131): 버킷별 편집가능 컬럼 인덱스 리스트. `SetEditList()`(L9059~9180)가 조회 시 1회 산출.
- `dtWeek` (L100): 기준일 테이블 = 조회 SP `Tables[1]` (MONTH_NAME = M+3 기준월, ISO_WEEK).
- `dtCalendarDetail` (L101): 월간 배분 캘린더 = 조회 SP `Tables[4]` (BASIS_YYYYMMDD, FIRST_WEEK_FLAG, END_MONTH_FLAG, MONTH_DAY_CNT, WEEK_DAY_CNT).
- `sDefaultDay` (L298): 룩업 `DEFAULT_BUCKET_DAY` 결과 (L1773). 행 BUCKET 이 비었을 때의 기본 배분 요일.
- `sResultYYYYMMDD`: 금주 월요일 yyyyMMdd (L546~547). 실적/계획 경계.
- 이벤트 배선: `dsdm.Changed += spdMain_Changed` (L411~412), `base.BaseForm_KeyUp` 제거 후 자체 KeyUp 사용 (L415).

---

## 1. spdMain_Changed (dsdm.Changed 핸들러, L5537~L7626) — 셀 값 변경·배분 엔진

FarPoint `DefaultSheetDataModel.Changed` 이벤트. 셀 하나가 바뀔 때마다 (A) Insert 행 키/Measure 변경 처리, (B) 수량 변경 4분기 배분을 수행한다.

### 공통 진입부 (L5539~L5618)
1. `CanModelChange == false` 면 즉시 리턴 (L5539). `e.Column <= 1` (Action/COLMERGE 영역)도 리턴 (L5541~5542).
2. **재진입 방지**: `dsdm.Changed -= spdMain_Changed` 로 핸들러 자체를 떼고 try 진입, `finally` 에서 재부착 (L5546~5547, L7621~7625). 내부의 `SetText` 가 이벤트를 재귀 유발하지 않게 하는 속도개선 장치.
3. `e.Type == CellsUpdated` 분기만 처리 (L5551~5553).
4. 행 컨텍스트 일괄 캡처 (L5582~5610): sAction(L5582), DIVISION_ID / PROJECT_CODE / END_CUSTOMER / SCM_SITE_ID / ITEM_ID / DOM_EXP / FCST_TYPE / INCOTERMS / MEASURE / MEASURE_GROUP / PLANT_SITE_ID / CELL_PROD_SITE_ID / CURRENCY 를 각 컬럼 존재 확인 후 GetValue. AS_FROM_SITE 도 별도 캡처 (L5613~5618).

### (A) Insert 행 처리 — `sAction == "I"` 일 때만 (L5620~L5960)
5. **CURRENCY 콤보 swap** (L5622~5646): 변경 컬럼이 `CURRENCY` 또는 `MEASURE` 이면,
   - 행의 MEASURE 가 `LOC` → `Data.Common(CURRENCY_LIST, NowGroupID, UserId)` 로 통화 콤보 바인딩 (L5626~5636).
   - LOC 아님 → `GetLookupValues("NO_DATA", ...)` 빈 콤보로 교체하여 통화 입력 봉쇄 (L5637~5646).
   - 둘 다 `e.Row` 기준 (구 로직의 `ActiveRowIndex` 버그를 KJIYOON 이 수정, 주석 L5630~5632).
6. **MEASURE 변경 시 행 재잠금 + 포맷 전환** (L5648~5758):
   - 6-1. 해당 행을 Measure 다음 컬럼~끝까지 일괄 Lock (`LockRange2(..., true, true)`, L5657) 후 `SetLockRange(e.Row, e.Row, false)` 로 새 Measure 기준 Unlock 재계산 (L5658). → §3 의 잠금 게이트가 행 단위로 재적용됨.
   - 6-2. 행 숫자 포맷: 새 Measure 가 `LOC` → `###,###,###,##0.000` (소수 3자리), 그 외 → `###,###,###,###` (정수) 로 `SetRowFormat` (L5743~5756).
7. **필수 11종 ValidationCheck** (L5762~5832): 변경 컬럼이 수량 컬럼(버킷과 정합: Daily×D_ / Weekly×W_ / Monthly×M_ / Weekly·Monthly×D_, L5763~5767)일 때 순서대로 검사. 하나라도 비면 `ValidationCheck(e, 항목명)` 호출 후 return:
   1) Division ID (L5769) → 2) Project Code — Division 81*/82 한정 (L5774~5781) → 3) End Customer — Division 40 한정 (L5782~5790) → 4) Sales Site ID (L5791) → 5) Item ID (L5796) → 6) Customs Handbook(D:Domestic, E:Export) = DOM_EXP (L5802) → 7) FCST Type (L5807) → 8) Incoterms (L5812) → 9) Measure (L5817) → 10) Cell Prod Site ID (L5822) → 11) Currency — MEASURE=LOC 한정 (L5827).
   - **롤백 메커니즘** `ValidationCheck()` (L7628~7636): `bPasteContinue` 가 true 일 때만 `MSG00002`("{0} 값은 필수 입력 입니다") 1회 발화 → `CanModelChange=false` 상태에서 `SetText(e.Row, e.Column, "")` 로 방금 입력값 롤백 → `bPasteContinue=false` (붙여넣기 다중셀 시 메시지 연발 방지; `spdMain_EditChange` L8375~8381 에서 수량영역 편집 시작 시 다시 true).
8. **키 컬럼 변경 cascade** (L5833~5875): 변경 컬럼이 Division / ScmSiteId / Project / ItemId / Incoterms 이면,
   - 8-1. Division·SalesSite 가 채워져 있으면 Measure 콤보 재조회: `GetLookupValues("FCST_PRICE_EDIT_MEASURE","DMF0082", div, site, bucket)` (L5839~5846).
   - 8-2. ItemId 변경 → `Data.Common(CELL_PROD_SITE_ID, div, item)` 으로 CELL_PROD_SITE_ID 콤보 재바인딩 (L5850~5860).
   - 8-3. ScmSiteId 또는 Incoterms 변경 → `GetLookupValues("SALES_BUCKET", div, site, incoterms)` 조회, 결과 있으면 행의 BUCKET 컬럼에 요일비트 세팅, 없으면 "" (L5862~5874). ← 이후 배분 요일의 원천.
9. **Insert 행 간 중복 체크 MSG00260** (L5878~5957): 변경 컬럼이 MEASURE 포함 이전(키 영역)일 때만 (L5880). 전 행 루프에서 Action="I" 행에 대해 8-키 (END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CELL_PROD_SITE_ID) 완전일치 카운트 (L5897~5946; 어느 한쪽이라도 8키 중 빈 값이면 skip L5925~5931). `iDouble >= 2` 이면 방금 입력값 롤백(`SetText ""`) + `MSG00260` 발화 후 return (L5948~5955).

### (B) 수량 변경 — 버킷 요일비트 산출 (L5998~L6060)
10. 행의 `BUCKET` 컬럼 값(7자리 요일비트, 일~토 순: index 0=SUN … 6=SAT)을 읽음 (L5999).
11. MEASURE=LOC 이면 무조건 `"0100000"`(월요일) 강제 (L6009~6012).
12. 비트가 "" 또는 "0000000" 이면 `sDefaultDay` 룩업값(MON~SUN)에 따라 단일 요일 비트 생성, 미매칭 default = 월요일 (L6024~6055).
13. `dBucket[0..6]` Dictionary 로 변환 (L6056~6059). `getDayOfWeek(iCol)` (L3240~3246) 이 D_ 컬럼 태그의 요일 index 를 반환하여 대조.

### (B)-1 Daily 버킷에서 D_ 셀 수정 (L6072~L6205)
14. **Weekly Sum 재계산**: e.Column 에서 좌측으로 역주사하여 소속 주의 W_ 컬럼 위치 확보 (L6075~6083). 그 다음 컬럼부터 우측 주사:
    - D_ 셀 값 누적 `iWeeklySum` (L6087~6092). MEASURE 가 MKT_FCST/VMI_In_Req/SCM_FCST 이면 각 일자 셀 자체를 `Math.Truncate` 정수 절삭해 다시 SetText — "0"/"0.000" 은 "" 처리 (L6094~6103).
    - M_ 또는 W_ 를 만나면 W_ 셀(iStartCol-1)에 합계 기록: FCST 3종은 `iWeeklySum_NUM`(정수 절삭값), 그 외(LOC)는 소수 유지 (L6106~6132). break.
15. **Monthly Sum 재계산**: 좌측 역주사로 M_ 위치 확보 (L6136~6143) → W_ 값 누적, FCST 3종은 W_ 셀도 절삭 재기록 (L6145~6163) → M_ 셀에 합계 기록 (정수/소수 동일 규칙, L6166~6191). break.
16. **저장 버퍼 적재**: `sYYYYMMDD = sColName.Replace("D_","")`, 수정된 셀 값 iQty 로 `SetSaveData(...)` 1건 (L6194~6204).

### (B)-2 Weekly 버킷에서 W_ 셀 수정 (L6544~L6742) — [붙여넣기 속도개선2 신로직]
17. `iWeeklySum` 확정: LOC 아님 → `Math.Round(값, 0)` 정수 반올림, LOC → 원값 (L6549~6563).
18. `iStartCol = e.Column + 1` 부터 그 주의 D_ 컬럼 주사 (L6573~6689):
    - **비-LOC 경로**:
      - 18-1. D_ 컬럼마다 먼저 기존 값을 "" 초기화 + `SetSaveData(..., 0)` (L6638~6644). 요일비트 해당일(`dBucket[getDayOfWeek(iCol)]`)이면 `arrTargetDayIdx` 에 인덱스 수집 (L6646~6650).
      - 18-2. 비-D 컬럼(=주 경계) 도달 시 (L6578):
        - 버킷일이 1개 이상이면 (L6581): `iWeekBucketCnt = 개수`; 첫 루프에서 `iDailyQty = Truncate(iWeeklySum / iWeekBucketCnt)` (L6591~6595); 각 버킷일에 iDailyQty 기록하되 **마지막 버킷 요일에는 잔량 전액**(`iDailyQty = iWeeklyQty`, L6597~6600), 그 외는 `iWeeklyQty -= iDailyQty` 로 잔량 갱신 (L6601~6604); 셀 SetText("0"→"") + `SetSaveData` (L6606~6615).
        - **버킷일이 0개인 주** (L6618~6634): 그 주 마지막 일자(iCol-1)에 주간 수량 전액을 넣고 `SetSaveData`.
    - **LOC 경로** (L6656~6685): 각 D_ 컬럼에서, 일자가 매달 1일(`Substring(8,2)=="01"`)이거나 버킷 요일(월요일)이면 `iWeeklySum` 그대로 기록+`SetSaveData`, 아니면 "" 로 초기화+`SetSaveData 0`. (가격은 배분하지 않고 기준일에 복제)
    - 18-3. 비-D 컬럼 도달 시 break (L6688).
19. **Monthly Sum 재계산** (L6691~6741): 소속 월의 M_ 좌측 역주사 후 W_ 값 누적. LOC 는 값 있는 주차수로 나눈 **평균** (L6716~6729), 그 외는 합계 (L6730~6738) 를 M_ 셀에 기록.

### (B)-3 Monthly 버킷에서 M_ 셀 수정 (L7112~L7398) — [월수량 일별 나누기 신로직]
주석 사양 (L7113~7115): step1 `Weekly Sum = Truncate(MonthlySum/월일수) × 해당주차 일수` → step2 `일자별 = Truncate(WeeklySum/버킷요일수)`, 각 주 마지막 버킷요일에 잔량 가산 → step3 마지막 주에 버킷요일이 없으면 그 전 주 버킷요일들에 잔량 분배.
20. `iMonthlySum` 확정: 비-LOC → `Math.Round(값,0)`, LOC → 원값 (L7122~7138). `iStartCol = e.Column + 2` (M_ 바로 다음 W_ 를 건너뛰고 D_ 부터, L7119).
21. 컬럼 주사 (L7193~7371):
    - 21-1. D_ 이고 금주 월요일(`sResultDate`) 이전(실적구간)이면 continue — 어떤 작업도 하지 않음 (L7195~7202).
    - **비-LOC 경로**:
      - 21-2. W_ 컬럼 도달 시 직전 주 배분 (L7207~7263): `arrTargetDayIdx` 가 있으면 첫 루프에서 `dtCalendarDetail.Select("BASIS_YYYYMMDD='해당일'")` 로 `MONTH_DAY_CNT`(월 전체 일수)·`WEEK_DAY_CNT`(그 주가 해당 월에 걸친 일수) 조회 → `iWeeklyQty = Truncate(iMonthlySum / MONTH_DAY_CNT) × WEEK_DAY_CNT` (L7222~7227), `iDailyQty = Truncate(iWeeklyQty / iWeekBucketCnt)` (L7227). 마지막 버킷요일 = 주 잔량 전액 (L7230~7234), 그 외 `iWeeklyQty -= iDailyQty` (L7235~7238). 셀 기록 + `SetSaveData` (L7240~7249). 배분 누계 `iWeeklyQtySum += iDailyQty`, **월 잔량** `iRemnant = iMonthlySum − iWeeklyQtySum` 갱신 (L7252~7253).
      - 21-3. 주 경계에서 변수 초기화 + `arrBfTargetDayIdx = arrTargetDayIdx.Clone()` (전주 백업, L7256~7262).
      - 21-4. D_ 컬럼이면 값 "" 초기화 + `SetSaveData 0`, 버킷요일이면 `arrTargetDayIdx` 수집 (L7265~7279).
    - **LOC 경로** (L7284~7313): D_ 가 매달 1일 또는 버킷요일(월)이면 `iMonthlySum` 전액 기록+SetSaveData, 아니면 "" +SetSaveData 0.
    - 21-5. 다음 M_ 또는 마지막 컬럼 도달 시 (L7315~7370): 비-LOC 이고 `iRemnant > 0` 이면 **월 잔량 재분배** — 직전 주에 버킷이 있으면 `arrTargetDayIdx`(clone), 없으면 전전주 `arrBfTargetDayIdx` 사용 (L7320~7327); `Truncate(iRemnant/버킷수)` 씩, 마지막 요일엔 잔량 전액 (L7337~7347); **기존 셀 값이 있으면 가산** (`iDailyQty += 기존값`, L7349~7352) 후 SetText + `SetSaveData(newQty)` (L7354~7365). break.
22. **Weekly Sum 전면 재계산** (L7373~7397): 월 내 D_ 값을 다시 합산하여 각 W_ 셀 갱신.
    ※ M+4 규칙 자체는 이 배분 로직이 아니라 §3 EditButton→SetLockRange 의 `list_EDIT_Month_M4` 잠금으로 강제된다 (M+3 이전 M_ 셀은 아예 편집 불가라 이 분기에 진입 불가).

### (B)-4 키 변경(수량 아님) — else 분기 (L7550~L7616)
23. 변경 컬럼이 D_/W_/M_/COLMERGE/Action 이 아니고 (L7552~7553) 행이 Insert("I") 이면 (L7555):
    - 23-1. 행 컨텍스트 재캡처 (L7557~7581).
    - 23-2. Measure 이후 전 컬럼 주사: D_/W_/M_ 셀에 값이 있으면 전부 "" 초기화 (L7586~7612). (키가 바뀌면 기존 배분 수량은 무의미)
    - 23-3. `SetSaveDataRemove(...)` 로 dtSave 버퍼에서 그 키의 행 전부 제거 (L7613). → §2 참조.

### 구 로직(비활성)
- 구 spdMain_Changed 전체: L3835~L5535 (주석). 활성판과의 차이 — Validation 이 Insert 외 행에도 적용, Weekly 배분이 나머지(iRemnant)를 마지막 일자에만 가산하는 몫/나머지 방식, Monthly 배분에 `MSG00225`(실적 수량보다 작은 숫자 불가, L6847 부근 주석판 L4867) 게이트 존재, dtCalendarDetail 기반 신배분의 과도기 주석 다수.
- 활성 함수 내부의 일괄 주석 블록: Weekly 이전 로직 L6207~6541, Monthly 이전 로직 L6745~7110, 주/월버킷에서 D_ 직접수정 로직 L7401~7548 (활성판에서는 D_ 직접 수정 분기가 **삭제**되어 주/월 버킷에서 D_ 셀을 고칠 일이 없음 — D_ 는 잠겨 있음).

---

## 2. SetSaveData / SetSaveDataRemove (저장 버퍼, L7638~L7781 / L7783~L7862)

모든 배분 결과는 일(D_) 단위로 이 함수를 거쳐 `dtSave` 에 upsert 된다.

### SetSaveData 단계 (L7638~7781)
1. **조용히 제외되는 조건(무경고 return) 전수** — 아래 중 하나라도 걸리면 버퍼에 쌓이지 않음(메시지 주석처리됨):
   | # | 조건 | 라인 |
   |---|---|---|
   | 1 | sDivision == "" | L7655 |
   | 2 | Div 40 && sEndCustomer == "" | L7663 |
   | 3 | Div 40 && sScmSiteId == "" | L7668 |
   | 4 | Div 40 && sItemId == "" | L7673 |
   | 5 | sIncoterms == "" | L7680 |
   | 6 | sFcstType == "" | L7685 |
   | 7 | (Div 40/81*/82) && sDomExp == "" | L7690 |
   | 8 | sMeasure == "" | L7695 |
   | 9 | sCellProdSiteID == "" | L7705 |
   | 10 | sMeasure=="LOC" && sCurrency == "" | L7710 |
   - 유일한 **비조용** 케이스: `sYYYYMMDD.Length != 8` → `MessageBox.Show("YYYYMMDD형식이 맞지 않습니다.")` 후 return (L7700~7704).
2. 필터 조립 (L7715~7749): Action + 12개 컬럼 등가 필터. **MEASURE=LOC 이면 CURRENCY 까지 키에 포함** (L7717~7733), 그 외는 CURRENCY 제외 (L7734~7749).
   - 주의(원소스 특성): `PROJECT_CODE` 자리에 `sEndCustomer` 가 들어감 (필터 L7721/L7738, 신규행 L7758). Div 40 화면에서 Project=EndCustomer 로 취급하는 화면 고유 규약.
3. `dtSave.Select(sFilter)` (L7751): 0건 → NewRow 로 15컬럼 추가 + AcceptChanges (L7753~7775). 1건 이상 → 첫 행의 QTY 만 갱신 (**upsert**, L7776~7780).

### SetSaveDataRemove 단계 (L7783~7862)
4. SetSaveData 와 동일한 조용한 제외 조건(단 DomExp 는 Division 무관 L7822, YYYYMMDD/CURRENCY 검사 없음) 통과 후, Action+11키(YYYYMMDD·CURRENCY 제외) 필터로 `dtSave` 에서 일치 행 전부 Remove (L7838~7860). 호출처: DeleteButton 의 D-취소/I-삭제/M→D 전환 (L783, L791, L830), spdMain_Changed 키변경 분기 (L7613).

---

## 3. EditButton (F2, L1531~L1610) + SetEditList (L9059~L9180) + SetLockRange (L9186~L9285)

주석 사양 (L1521~1530): step1 전체 Lock → step2 EditFlag & Measure 권한 & Measure & Bucket 에 따른 Unlock. Unlock 조건 = 실적 아님(Month: 당월 이후 / Week: 당주 이후 / Day: 금주 월요일 이후) ∧ 버킷 정합 컬럼 ∧ 행 EditFlag=Y ∧ Measure 권한 Y ∧ (LOC 제외 Measure 는 Monthly 버킷일 때 당월+4개월부터).

### EditButton 단계
1. `isCurVersion` 아니면 즉시 return (L1533~1534) — Current 버전 조회 시에만 편집.
2. 필수 컬럼 존재 확인 (Div 40): DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CELL_PROD_SITE_ID 중 하나라도 grid 에 없으면 `MSG00113`(필수 입력 컬럼이 없습니다) (L1542~1555).
3. 조회 선행 확인: `dtWeek` 가 null/0건이면 `MSG00259`(조회 후 수정모드로 가능합니다) (L1557~1563).
4. 편집모드 토글 (L1567~1583): Action 컬럼 visible 이 false → true 로 켜고 `SetLockFlag(false)`, `IsEditMode=true`. 반대면 Action 숨기고 `LockColumn2(전체, true)` + `SetLockFlag(true)`, `IsEditMode=false`.
5. 배경색 (L1588~1598): 실적 구간(iStartCol~iResultCol) Gainsboro, 당월(this_YYYYMM) 컬럼은 White 로 되돌림.
6. `SetLockRange(0, GetMaxRowIndex(), !IsEditMode)` 전 행 일괄 적용 (L1600). SuspendLayout/finally-ResumeLayout 로 감쌈 (L1538, L1603~1607).

### 잠금 게이트 5종 적용 순서 (SetLockRange, L9186~9285) — 행 단위 continue 게이트
7. (게이트 0) 버킷별 편집 대상 인덱스 선택: Monthly→`list_EDIT_Month`, Weekly→`list_EDIT_Week`, Daily→`list_EDIT_Day` (L9196~9207).
8. 행 루프에서 sEditFlag/sMeasure/sFcstType/sAction 캡처 (L9215~9220) 후:
   - **게이트 1 — EDIT_FLAG**: `sEditFlag != "Y" && sAction != "I"` → skip (L9223). (Insert 행은 EditFlag 무관 통과)
   - **게이트 2 — Measure 권한 4종** (`dsMain.Tables[3]` 유래): LOC→`bEDIT_AUTH_LOC` (L9229), MKT_FCST→`bEDIT_AUTH_MKT_FCST` (L9234), SCM_FCST→`bEDIT_AUTH_SCM_FCST` (L9238), VMI_In_Req→`bEDIT_AUTH_VMI_IN_REQ` (L9243). false 면 skip.
   - **게이트 3 — SCM_FCST × RMA**: SCM_FCST 이면서 `sFcstType == "RMA"` → skip (L9239).
   - **게이트 4 — LOC × Daily**: LOC 이면서 Daily 버킷 → skip (L9230, 2025-08-05 kjiyoon).
   - (Insert 행 사전 조치) `sAction=="I"` 이면 Measure 이후 전 컬럼을 먼저 Lock (L9251~9254) — Monthly 시 M+3 이전 잠금 유지 목적.
   - **게이트 5 — 버킷별 list_EDIT_\* 인덱스 Unlock** (L9256~9283): 대상 인덱스만 `LockRange2(..., bLockFlag, true)`. 단 MKT_FCST/SCM_FCST/VMI_In_Req 가 **Monthly** 버킷이면 `list_EDIT_Month_M4.Contains(idx)` 인 컬럼만 Unlock (L9267~9273) — **M+4 규칙**. LOC 는 list 전체 Unlock (L9260~9262).

### list_EDIT_* / M+4 산출 (SetEditList, L9059~L9180) — FindData 시 1회 실행 (호출 L1763)
9. Month: `this_YYYYMM` (당월) ≤ 컬럼월 → `list_EDIT_Month` (L9080~9087). 그중 컬럼월 > `dtWeek.Rows[0]["MONTH_NAME"]`(= M+3 기준월) → `list_EDIT_Month_M4` (L9090~9093). 즉 M4 리스트 = M+4월부터.
10. Week: 당주(this_YYYYMMWW) 컬럼이 존재하면 그 인덱스 이후의 W_ 전부 (L9112~9115); 없더라도 조회 시작월 ≥ 당주월이면 동일 규칙 (L9116~9125) — [E20251202-000637] 12월 마지막주 W01+ 활성화 수정. (구 W_ 태그 숫자비교 로직은 L9100~9111 주석 보존)
11. Day: `sResultYYYYMMDD`(금주 월요일) ≤ 일자 → `list_EDIT_Day` (L9128~9137).
12. Measure 권한 4종 산출 (L9140~9179): `dsMain.Tables[3]` 를 복사해 LINQ 로 `MEASURE == 'SCM_FCST'|'MKT_FCST'|'LOC'|'VMI_In_Req'` 행의 `EDIT_FLAG=='Y'` 여부를 각각 세팅 (L9168~9174). — [E20250729-000433] 테이블 구조 변경 반영 (구 단일행 EDIT_AUTH_* 컬럼 방식은 L9148~9164 주석).

### 구 로직(비활성)
- 구 EditButton 전체: L932~L1519 (주석). 컬럼별 LockColumn 루프 + Measure×Bucket 3×4 조합의 LockRange_Edit 대량 호출 구조.
- 구 LockRange_Edit 2벌: L8782~8902, L8905~9042 (주석).

---

## 4. SaveData (F7, SaveButton L1612~L1615 → SaveData L2025~L2217, fnValidation L2220~L2490)

1. 진입 게이트: `siMain.IsLock == false` (편집모드) && 시트가 FcstNPrice 일 때만 (L2027~2029). SP = `DM.DMF0082_SAVE_MAIN_DATA` (L2031).
2. **fnValidation 호출** (L2052): `bool bInputCheck = fnValidation(out bInputCheck);` — out 파라미터로 수량입력여부를 받되, **직후 반환값(bValidation=중복검사 결과)이 같은 변수에 덮어써짐**. 실질적으로 caller 의 `bInputCheck` = 중복검사 결과.
3. **fnValidation 내부** (L2220~2490):
   - 3-1. `dtSaveFinal.Clear()` + `bInputCheck2=false` (L2222~2223).
   - 3-2. Insert 행 수 카운트 (L2231~2238).
   - 3-3. Insert 행마다 (L2248~2358): 키 8종 + Currency 캡처 (L2254~2280) → 전 행과 대조. **LOC 는 Currency 를 유사-키로 취급**해 같이 비교 (`bCurrency`, L2286~2300). Division/Customer/Site/Item/DomExp/FcstType/Incoterms/Measure 일치 && bCurrency && CellProdSite 일치 → `iValidation++` (L2302~2332). 도중 `sMeasure=="LOC" && sCurrency==""` 이면 `bInputCheck2=true` (L2334~2337). `iValidation > 1` 이면 즉시 break (L2340~2343).
   - 3-4. 수량 입력 여부: Insert 행별 D_ 컬럼 값 개수 `bInputCnt[]` (L2347~2357) → 하나라도 0 이면 out `bInputCheck=false` (L2361~2366).
   - 3-5. 반환 분기 (L2368~2376): 중복(iValidation>1) → `bValidation=false` 반환. 수량미입력(!bInputCheck) → bValidation(true) 그대로 반환하되 **dtSaveFinal 을 만들지 않고** 반환.
   - 3-6. 정상 경로 (L2377~2409): 화면의 Action 비어있지 않은 전 행에 대해 9-키 필터(`DIVISION_ID~CELL_PROD_SITE_ID`, L2385~2393)로 `dtSave.Select` → 일치 버퍼 행을 `dtSaveFinal.ImportRow` (L2395~2403). **그리드에 이미 없는 유령 키의 버퍼 행 배제 장치.** 마지막에 `DefaultView.ToTable(true)` 중복 제거 (L2407~2409). (구 행별 이중루프 방식은 L2411~2487 주석)
4. **메시지 실발화 위치**:
   - `MSG00002`("Currency 값은 필수 입력") — `bInputCheck2` true 시 (L2055~2059).
   - `MSG00043`(중복) — fnValidation 반환 false 시 (L2062~2066).
   - L2068~2073 의 `MSG00449` 분기는 직전 분기와 **조건이 동일(`!bInputCheck`)하여 도달 불가(사문)**. `MSG00449`("추가된 행에 입력된 수량 또는 가격이 없습니다…")의 **실발화 위치는 L2211~2214** — dtSaveFinal 0건(iCount==0)일 때. (수량 미입력 시 3-5 에서 dtSaveFinal 이 비므로 이 경로로 발화)
5. **'^' 구분 16개 파라미터 조립** (L2076~2123): dtSaveFinal 행을 순회하며 QTY 빈값은 "0" 치환 (L2078~2082), 첫 행은 대입·이후 행은 `"^"` 연결. **조립·전송 순서 전수** (SP 파라미터 명, L2146~2161):
   1) p_active_flag(Action) → 2) p_division_id → 3) p_project_code → 4) p_end_customer → 5) p_scm_site_id → 6) p_item_id → 7) p_dom_exp → 8) p_fcst_type → 9) p_incoterms → 10) p_measure → 11) p_plant_site_id → 12) p_cell_prod_site_id → 13) p_yyyymmdd → 14) p_currency → 15) p_qty → 16) p_created_by(UserId 를 행 수만큼 '^' 반복).
6. 저장 확인 `MSG00012`(저장 하시겠습니까?) — Yes 아니면 return (L2129~2134). CommandTimeout 10분 (L2163).
7. **성공/실패 분기** (L2167~2198):
   - 성공: `RESULT_CODE=='S'` → `MSG00004`(건수 = RESULT_CNT) → **`GetViewportTopRow` 저장 → `FindData()` 재조회 → `SetViewportTopRow` 복원** (스크롤 위치 유지, L2172~2175) → `IsChange=false`.
   - 실패: `RESULT_CODE=='F'` → `ERR_MESSAGE`(SQL 예외) / `RESULT_MSG`(SP Validation 실패) 를 각각 MessageBox 로 표출 (L2184~2193), `IsEditMode=true` 복원 (L2195).
8. finally: `dtSaveFinal.Clear()` (L2205~2209). ※ `dtSave` 는 재조회(FindData→Draw L1935)에서 Clear.

---

## 5. FindData (F5, FindButton L671~L676 → FindData L1662~L1790, Draw L1793~L2022)

1. `CanModelChange=false` 로 Changed 이벤트 봉쇄 후 진입 (L1664).
2. 사전 검증: Division 미선택 `MSG00097` (L1672~1677) / Version 공백 `MSG00283` (L1680~1684) / 기간 역전 `MSG00108` (L1693~1697) / 기간 3년 초과 `MSG00164` + Value2 를 +2년으로 보정 (L1699~1706).
3. `InitSpread()` 로 헤더 재구성 (L1710): `DMF0082_GET_SPREAD_TITLE` (p_start/end_yyyymmdd, p_created_by, p_division_id — L431~447) → 3단 헤더 span(L449~541) → 버킷별 컬럼 표시(L543~609) → Footer Sum(L611~629).
4. **본 조회 SP `DM.DMF0082_GET_MAIN_DATA` — IN 파라미터 12개 실명 순서** (L1727~1738, CommandTimeout 30분 L1725):
   1) p_division_id → 2) p_team_id → 3) p_customer → 4) p_biz_type → 5) p_from_yyyymmdd → 6) p_to_yyyymmdd → 7) p_scm_site_id → 8) p_item_id → 9) p_version_type → 10) p_qty_yn(cboQty 체크 Y/N) → 11) p_created_by → 12) p_user_group(NowGroupID).
5. **5테이블 소비**:
   - `Tables[0]` 본문 → `Draw()` 에서 `siMain.Query` 바인딩 (L1806~1815) + NOTATION 포맷.
   - `Tables[1]` → `dtWeek` (L1747~1748): ISO_WEEK 로 `this_YYYYMMWW`/`this_YYYYMM` 산출 (L1800~1804), MONTH_NAME = M+3 기준월(SetEditList M4 산출·L9090).
   - `Tables[2]` → 당주 정보: `THIS_YYYYMMWW`, `ISO_WEEK` (L1817~1821).
   - `Tables[3]` → Measure 권한 4종 (SetEditList L9143~9178).
   - `Tables[4]` → `dtCalendarDetail` 배분 캘린더 (L1751~1752).
6. `Draw()` (L1759 호출):
   - 6-1. 바인딩 + SmartColMerge + 전 컬럼 Lock (L1808~1814).
   - 6-2. **NOTATION 포맷** (L1853~1924): Tables[0] 의 `NOTATION` 컬럼으로 행 단위 CellType 지정 — LOC 또는 POINT3 은 기본(소수3) 유지 continue (L1888~1891); INTEGER → `###,###,###,###`, POINT3 → `##0.000` 을 행 전체(iStartCol~끝)에 일괄 적용 (L1893~1923). (조회속도 개선: 행×컬럼 2중루프 제거)
   - 6-3. `SetSpreadColumn` + `dtSave/dtSaveFinal.Clear()` (L1934~1936).
   - 6-4. `iResultCol`(마지막 실적 D_)/`iResultMonth`(당월 M_)/당주 W_ 중복수 count 산출 (L1946~1956).
   - 6-5. **실적 회색**: iStartCol~iResultCol 을 Gainsboro, 당월 M_ 은 White (과거만 조회 시 오표기 방지 조건 포함, L1958~1967).
   - 6-6. **당주 녹색 보더**: Weekly/Monthly — 당주 W_ 컬럼에 Green BevelBorder; 동일 주차가 2회 이상 나타나면 [E20250313-001251] 규칙(조회 시작일 > 당주 월요일이면 this_YYYYMMWW, 아니면 sResult_YYYYMMWW)으로 위치 결정 (L1970~2012). Daily — `D_금주월요일` 컬럼에 보더 (L2013~2017).
7. 후처리: `SetEditList()` (L1763), `dtCustomsHandbook`/`dtWarrType` 선조회 (L1765~1766), `sDefaultDay` 룩업 (L1773), `txtVersion=="Current"` 이면 `isCurVersion=true` (L1776~1779). finally 에서 progress close + ResumeLayout (L1785~1789), `CanModelChange=true` (L1770).

---

## 6. InsertRow / DeleteButton

### 6-A. InsertRow (InsertButton L678~L684 → InsertRow L2492~L3034, 커스텀 Insert() L9292~L9417)
1. 게이트: `isCurVersion` (L681) + 편집모드(IsLock false) + Main 시트 (L2494~2496).
2. **시드 행 결정** (L2503~2518): 현재 선택 블럭(range)의 첫 행을 `iFocusRow` 로 기억. 새 행이 위/아래 어디에 생기는지에 따라 +1 보정.
3. `this.Insert()` 커스텀 행 추가 (L2520, 본체 L9292~9417): ActiveRow 위치에 행 추가, Action 셀 'I' + `BGInserted` 색, (조회 0건 최초 추가 시 전 컬럼 Unlock L9315~9335).
4. **콤보 세팅** (L2523~2632): Incoterms = `GetLookupValues("INCOTERMS","ALL","Y")` — VALID_YN 유효코드만 ([E20250919-001699], L2528~2533, L2616~2618); ItemId 셀 = 팝업 이미지 CellType (L2538~2542); Division 값 = 조회조건 (L2543~2547); DomExp = dtCustomsHandbook (L2552); FcstType = dtWarrType (L2572); Customer/SalesSite = 권한 콤보 (L2579~2597); Measure = `FCST_PRICE_EDIT_MEASURE` 룩업 (L2621~2622); CELL_PROD_SITE_ID = `Data.Common(CELL_PROD_SITE_ID, div, item)` (L2625~2626); CURRENCY = `CURRENCY_LIST` (L2629~2630).
5. **시드 복사** (L2636~2669): 포커스 행이 있으면 Division, Customer(END_CUSTOMER), ScmSiteId, ItemId, Incoterms, FcstType, DomExp, CELL_PROD_SITE_ID, CURRENCY, Measure **10개 값**을 새 행에 복사. 없으면 Measure="MKT_FCST" 만 기본 세팅 (L2670~2676).
6. 당주 녹색 보더 재적용 (L2686~2734).
7. **키 9컬럼 unlock** (L2740~2752): `sEditColList` = Customer, ScmSiteId, ItemId, Incoterms, FcstType, DomExp, CELL_PROD_SITE_ID, CURRENCY, MEASURE — 9개 컬럼만 `LockRange2(..., false, MarkedForeColor, UnLockColor)`. (구 30여 컬럼 개별 Lock 루프는 L2754~2849 주석)
8. 수량 영역 잠금: `SetLockRange(iActRow, iActRow, false)` (L2855) — §3 게이트 재사용 (Insert 행은 전체 Lock 후 버킷·M4 규칙대로만 Unlock). 구 로직 L2857~3014 주석.

### 6-B. DeleteButton (L686~L930) — D·I·DB행 3분기
1. 선행: ActiveRow null 이면 return (L690); 다중 블럭 삭제 방지 위해 선택을 단일 셀로 축소 (L692~703); `list_EDIT_Day` 비어있으면(조회 전) return (L728~731).
2. 행 컨텍스트 캡처 (L752~779).
3. **분기 1 — sAction=="D"** (삭제 취소, L781~785): `SetSaveDataRemove` 로 버퍼의 D 행 제거 + `siMain.Delete()` 로 D 마크 해제.
4. **분기 2 — sAction=="I"** (L788~795): 버퍼에서 해당 키 제거 후 `siMain.DeleteRow()` 로 화면 행 즉시 삭제. ([E20250929-000202] — DataTable 을 먼저 지우고 행을 지우도록 순서 교정; 구 위치의 코드는 L706~711, L722~725 주석)
5. **분기 3 — DB 기존 행** (L797~922):
   - 5-1. Measure 화이트리스트: MKT_FCST / VMI_In_Req / SCM_FCST / LOC 만 진행 (L799).
   - 5-2. Measure 권한 4종 검사 — 권한 없으면 `MSG00464`(수정할 수 없는 메져입니다) 후 return (L802~825, [E20250729-000433] 버그 보완).
   - 5-3. sAction=="M" 이었다면 기존 M 버퍼 행 먼저 제거 (L827~831).
   - 5-4. `siMain.Delete()` 로 Action 에 빨간 'D' 표시, sAction="D" (L833~834).
   - 5-5. **주 단위 0화 수집 루프** (L836~920): 컬럼 주사하며 —
     - W_ 도달 시: 직전 주에서 모아둔 `alDelDayList` 가 있고 일별 값이 하나도 없었으면(`!isDayValExists`) 그 주 모든 일자를 0 으로 SetValue + `SetSaveData(...,"D",...,0)` (50주차 이후처럼 W 합만 있는 주 대응, L847~875). 이번 주 W 합 존재 여부로 `isWeekSumExists` 갱신, 리스트 초기화.
     - D_ 도달 시: 실적구간(`D_금주월요일` 이전)은 continue (L879~882); 주합이 있으면 alDelDayList 에 수집, 값이 있는 일자는 즉시 0 SetValue + SetSaveData (L887~899); 마지막 컬럼이면 잔여 리스트 동일 처리 (L901~918).
     - 설계 의도 주석 (L713~720): MKT_FCST/VMI_In_Req 는 DB 에서 0 UPDATE, LOC 는 DELETE(KRW/USD 동반), 실적구간 불가침, LOC 삭제 시 52주 SCM_FCST/MKT_FCST 존재 Validation 은 `DMF0082_SAVE_MAIN_DATA` SP 내에서 수행. (전 구간 0 전송 시 파라미터 폭증 방지가 이 수집 로직의 목적, L846)
6. 마무리: `siMain.SpreadObject.Refresh()` — 필터 적용 상태 갱신 (L927~929).

---

## 7. spdMain_ClipboardPasted / spdMain_KeyUp (붙여넣기 계열)

### 7-A. spdMain_KeyUp (활성 신로직 L8384~L8425)
1. `DefineProperty` 에서 `base.BaseForm_KeyUp` 를 떼어 (L415) 본 핸들러가 단독 처리.
2. `range = spdMain.Sheets[0].GetSelection(0)` — **붙여넣기 대상 블럭을 전역 `range` 에 캡처** (L8398). ClipboardPasted 의 1행→다행 판정 원천.
3. V 키(Ctrl 유무 불문): `ClipboardPaste(AsStringSkipHidden)` (숨김열 건너뛰기) + `bPasteContinue=true` (Validation 메시지 1회 발화 재무장, L8404~8411).
4. C 키: `Clipboard.Clear()` 후 `ClipboardCopy(AsStringSkipHidden)` (L8413~8418). WaitCursor 처리 (L8402, L8423).
- 구 KeyUp (ItemId 컬럼 특수처리 + CellDoubleClick 강제 호출 포함): L8427~8485 주석.

### 7-B. spdMain_ClipboardPasted (L7864~L8199)
1. 사양 주석 (L7870~7881): `e.CellRange` = **복사한** 원본 크기 기준. 1행 복사→다행 붙여넣기 시 이벤트는 1행만 알므로, KeyUp 의 `range` 로 보정 — `iAddRow = range.RowCount - 1` (L7880), `bOneRowCopy_MultiRowPaste` 플래그 (L7881).
2. `range` null 또는 헤더(-1)면 전체 skip (L7884).
3. 행 루프 (L7886, e.CellRange.Row ~ +RowCount+iAddRow):
   - 3-1. **Action 이 'M'/'I' 인 행만** 대상 — 아니면 continue (L7889~7895).
   - 3-2. 컬럼 루프에서 **셀 배경이 UnLockColor(노랑)가 아니면 continue** — 편집가능 셀만 붙여넣기 유효 (L7900~7903).
4. **콤보 재바인딩 4열** (영향 컬럼 동기화):
   - ScmSiteId 열 (L7905~7930): 1행→다행이면 시드행 값으로 SetValue 복제 후, `FCST_PRICE_EDIT_MEASURE` 로 Measure 콤보 + `GetIncotermsType(div, site)` 로 Incoterms 콤보 재바인딩.
   - ItemId 열 (L7956~7985): 시드 복제 후 `Data.Common(CELL_PROD_SITE_ID, div, item)` 으로 CELL_PROD_SITE_ID 콤보 재바인딩.
   - CELL_PROD_SITE_ID 열 (L7986~8014): 콤보 재바인딩 후 **SetCellTypeCombo 뒤에 값 재대입** (콤보 교체로 값이 날아가는 것 방지, L8007~8013).
   - Measure 열 (L8015~8040): 콤보 재바인딩 + 값 재대입 (L8033~8039).
5. **1행→다행 일반 키컬럼 복제** (L8041~8050): `iCol < Measure 인덱스` 인 나머지 키 컬럼은 시드행 값을 그대로 SetValue.
6. 수량 셀의 합산/배분은 여기서 하지 않음 — SetText 가 유발하는 `spdMain_Changed` (§1) 가 담당. 구 포맷 재지정 로직은 L8061~8195 주석.

---

## 8. 헤더/셀 더블클릭 (spdMain_CellDoubleClick, L3534~L3833)

### 8-A. 헤더 더블클릭 — 드릴다운 (L3536~L3575)
1. `e.ColumnHeader` 이고 태그가 `M_` 이면 (L3538): 해당 월 구간(다음 M_ 전까지)의 **W_ 컬럼 visible 토글**, D_ 는 보이는 상태였다면 숨김 (L3540~3558). → 월→주 드릴.
2. 태그가 `W_` 이면 (L3560): 해당 주 구간(다음 W_ 전까지)의 **D_ 컬럼 visible 토글** (L3562~3573). → 주→일 드릴.

### 8-B. 셀 더블클릭 — SSP 비교 팝업 (L3576~L3705)
3. 수량 셀(버킷과 정합 D_/W_/M_ 또는 주·월버킷의 D_, L3584~3588)에서 태그 길이 ≥10 이면 `sYyyymmdd = 태그.Substring(2,8)` (L3605~3612), 행 컨텍스트(ScmSiteId, Team, Customer, Measure, Project, ItemId, DomExp, FcstType, Incoterms) 캡처 (L3616~3643).
4. **팝업 발동 조건** (L3646~3649): `sDivision=="40" && sMeasure=="MKT_FCST"` && 셀 배경색이 `Color.PaleGreen`(SSP 동기화 셀) **또는** `Color.PapayaWhip`.
5. SP `DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP` 호출 (L3656~3695): 파라미터 = p_division_id, p_scm_site_id, p_project_code(← **Customer 값**, L3678), p_item_id, p_dom_exp, p_fcst_type, p_incoterms, p_yyyymmdd. (기간은 당주 월요일~+20일 산출 코드가 있으나 파라미터로는 미전송, L3665~3668.)
6. 결과 Tables[0] 을 `DMF0003_SspSyncComparePopUp.LoadData(dt, "40")` 로 표시 (L3697~3700).

### 8-C. Insert 행 키 셀 더블클릭 — 검색 팝업 (L3708~L3831)
7. 게이트: 시트 Lock 이거나 행 Action != 'I' 이면 return (L3708~3711) — 팝업류는 Insert 행 전용.
8. Project 셀 → `SCM0002_ProjectbyDivisionPopupEx` (L3713~3772): 선택 시 Project/ProjectName/ProjectStatus/BizType/ProjectOwner 5컬럼 세팅.
9. ItemId 셀 → `DM0002_ItembyDivisionPopupEx` (L3773~3824): sMdmActive_Sw="Y" + 행 Measure 전달 ([E20231019-001234] 모델 사용중지 정보, L3789~3798); 선택 시 ItemId/ItemName/ItemType/NickName 세팅.
10. Incoterms 셀 → `GetLookupValues("INCOTERMS","ALL","Y")` 유효코드 콤보 재바인딩 (L3826~3831, [E20250919-001699]).

---

## 부록 — 그 외 활성 이벤트·함수 라인맵 (참조용)

| 구분 | 위치 |
|---|---|
| ExcelButton (SimpleXcel Export) | L1618~1654 |
| cboBucketType_SelectedIndexChanged (버킷 전환 시 Edit 해제→컬럼 전환→Edit 복원) | L3248~3359 |
| cboBucketType_Click (Insert 행 존재 시 MSG00227 버킷 전환 차단) | L3361~3371 |
| btnExchangeRate_Click (환율 팝업 DMF0000_ExchangeRatePopup, 편집모드 시 MSG00142) | L3113~3154 |
| btnSavePricePeriod_Click (Price 일괄입력 DMF0082_SaveSalesFuturePrice_Popup, 편집모드 시 MSG00408) | L3455~3489 |
| btnVersion_Click (SCM0002_VersionByWaterfallPopup, "MF_SP_SF") | L3397~3417 |
| btnColumn / btnMeasure (DM0002_TitleSetForm_Popup "DMF0082") | L3424~3448 |
| chkSum_CheckedChanged (Sum On/Off → SetSpreadColumn) | L9046~9053 |
| spdMain_ComboSelChange (Division/Team/Customer/ScmSiteId/Incoterms cascade + SALES_BUCKET) | L8201~8373 |
| spdMain_EditChange (bPasteContinue 재무장) | L8375~8381 |
| spdMain_TopChange (SmartColMerge 재적용) | L8488~8493 |
| spdMain_LeaveCell (본체 전부 주석 — 포맷은 spdMain_Changed 로 이관) | L8495~8645 |
| GetFcstType / GetIncotermsType / GetCustomsHandbook / GetLookupValues | L8653~8729 |
| SetChangeControl (조회조건 8 룩업) | L8737~8778 |

### 구 로직(비활성) 주석 블록 총괄
| 블록 | 라인 범위 |
|---|---|
| 구 EditButton | L932~1519 |
| 구 InsertRow 컬럼별 Lock 루프 | L2754~2849, L2857~3014 |
| 구 spdMain_CellClick | L3494~3532 |
| 구 spdMain_Changed 전체 | L3835~5535 |
| 활성 spdMain_Changed 내 구 Weekly/Monthly/D_직접수정 | L6207~6541, L6745~7110, L7401~7548 |
| 구 spdMain_ClipboardPasted 포맷 재지정 | L8061~8195 |
| 구 spdMain_KeyUp | L8427~8485 |
| 구 spdMain_LeaveCell 본체 | L8501~8644 |
| 구 LockRange_Edit 2벌 | L8782~8902, L8905~9042 |
