# DMF0068 Demand Manager (소형 수주관리) — 제약매트릭스 상세

> 작성 2026-07-29. 1건 1행 전수. 라인번호는 별도 표기 없으면 정본 화면 `DMF0068_DemandManager40.cs`(1,337줄) 기준.
> `PKG` 표기는 사내 Oracle `SCM_MGR.PKG_DMF0068` **BODY 라인**.

## 0. 원천

| 구분 | 파일 | 행수 | Read 범위 |
|---|---|---:|---|
| 정본 화면 | `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\DMF0068_DemandManager40.cs` | 1,337 | 전체 |
| 정본 Designer | 〃 `.Designer.cs` | 371 | 전체 |
| 호출 팝업 | `GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0068_VersionPopup.cs` | 389 | 전체 |
| FoxQuery | `GSCM\04.WSL\FoxQuery\DM\Plan\DMF0068_DemandManager40.xml` | 30 | 전체 |
| TO-BE PKG | `SCM_MGR.PKG_DMF0068` SPEC 78 / BODY 1,383 | 1,461 | 전체 |
| AS-IS SP | MSSQL `LGCE_SCMDEV` 5종 | 1,040 | 전체 |

화면 구조: 단일 시트 `ContributeSalesList`(헤더 2단) / 조회조건 3 / 버튼 override 6 + 커스텀 1 / 팝업 1종.

---

## 1. Division 축 (전수 5건)

Division 은 **40 고정**이다. 다른 화면과 달리 콤보가 없고 코드에 상수로 박혀 있다.

| # | 라인 | 위치 | 식 | 효과 |
|---:|---|---|---|---|
| 1 | L45 | 필드 초기화 | `dtDivision = Data.Common(MyDivision, false, NowGroupID, UserId)` | 내 사업부 목록 사전 적재 |
| 2 | L203 | InitControls | `dtDivision.Select().Where(c => c["CODE"].ToString().Contains("40")).Any()` | false → MSG00415 + `return` (화면은 계속 열림) |
| 3 | L446 | EditButton | 동일 식 | false → MSG00415 + return (편집 진입 차단) |
| 4 | L573 | FindData | 동일 식 | false → MSG00415 + return (조회 차단) |
| 5 | L134/634/1049/1317 | GetLookupProject / FindData / SaveData / btnSPVer_Click | `p_division_id = "40"` 상수 | 모든 SP 호출이 40 고정 |

> ⚠️ 판정이 `Contains("40")` 이라 `140`/`401` 등 부분일치도 통과한다(AS-IS 잔존 결함). TO-BE 는 **정확일치(`=== '40'`)** 로 강화 권장.
> ⚠️ InitControls 의 return 은 화면을 닫지 않으므로 비40 사용자에게 **빈 그리드가 노출**된다. TO-BE 는 진입 자체를 차단하거나 안내 상태로 렌더링.

---

## 2. 권한 축 (전수 4건 + TO-BE 신규 1축)

| # | 라인 | 위치 | 식 | 효과 |
|---:|---|---|---|---|
| 1 | L37 | 필드 | `viewAuth = { "DM ADMIN", "ADMIN" }` | 허용 그룹 정의 |
| 2 | L452 | EditButton | `!viewAuth.Contains(NowGroupID)` | MSG00096 + return (편집 차단) |
| 3 | L579 | FindData | `!viewAuth.Contains(NowGroupID)` | MSG00096 + return — **조회도 차단** |
| 4 | 팝업 L116~119 | VersionPopup.InitControls | `Data.Common(MyDivision, …)` + `clbDivision.ControlValues = "40"` | 팝업 Division 은 호출자 지정값 고정 |
| 5 | PKG L762~765 / L918~921 | GET_ORDERLIST 동적 SQL | `INNER JOIN SCM_ADM_USER_MNU_EDIT_AUTH_V EDY ON EDY.USER_ID=… AND EDY.MNU_ID=… AND EDY.UNIT_ID=A.DIVISION_ID` | **TO-BE 신규 축**. 편집권한 뷰에 행이 없으면 **조회 결과 0행** |
| 6 | PKG L174~177 | GET_CONT_VIEW_VERSIONPOPUP | 동일 INNER JOIN | 버전 팝업도 동일 조건 |

**확정 정책(2026-07-29)**: **조회 = 메뉴권한(ADMIN / DM ADMIN / DM Viewer 3그룹 유지) / 편집·저장·삭제·행추가 = `EDIT_YN='Y'`**. AS-IS 의 조회 권한 게이트(#3)는 TO-BE 에서 편집 계열로만 적용한다.
→ 성립 조건: 위 #5·#6 의 편집권한 뷰 조인을 **INNER → LEFT** 로 정정(결함 D7). 그렇지 않으면 `DM Viewer` 는 조회 결과가 0행이 된다.

---

## 3. Measure 페어(2행 1세트) 축 (전수 12건)

이 화면의 핵심 제약. **모든 데이터는 `QTY(Cell)` + `Sales Amt.(KRW)` 2행이 1세트**로만 존재한다.

| # | 라인 | 위치 | 제약 | 비고 |
|---:|---|---|---|---|
| 1 | L91~107 | `dtMeasureS()` | `MEA_1`="QTY(Cell)", `SalesAmt_KRW`="Sales Amt.(KRW)" | R_S 버전용 |
| 2 | L109~123 | `dtMeasureB()` | 동일 2건 | R_B 버전용 — **내용이 S 와 완전히 같아 분기 실질 무의미** |
| 3 | L143~170 | `GetCellNumbersByRow` | `multiful = 2` 로 세트 시작 인덱스 계산 | 짝 정렬 |
| 4 | L1307~1313 | `GetCellIndexBySpanRowCells` | `iRow - (iRow % 2)` | 세트 첫 행 인덱스 |
| 5 | L1163 | InsertRow | `siMain.Insert(2)` | **항상 2행 동시 삽입** |
| 6 | L1171~1173 | InsertRow | 둘째 행 `OrderStart`/`OrderEnd`/`Project` `Locked=true` | 짝 행 직접 편집 금지 |
| 7 | L1175~1177 | InsertRow | 둘째 행 위 3셀 `BackColor=White` | 잠금 표시 |
| 8 | L1193~1200 | InsertRow | 둘째 행 3셀을 첫 행 Formula 로 연결 | 첫 행 수정 → 짝 자동 동기화 |
| 9 | L1215~1224 | InsertRow | 첫 행 `MEA_1`, 둘째 행 `SalesAmt_KRW` 고정 대입 | 버전 접두사 무관 동일 |
| 10 | L1227~1228 | InsertRow | Measure 셀 2개 `Locked=true` | Measure 변경 불가 |
| 11 | L1231~1234 | InsertRow | `Guid.NewGuid()` 1개를 두 행 `KEYVALUE2` 에 동일 기록 | **그룹 키** |
| 12 | L479~509 | EditButton | 짝수 행 기간 잠금 + 윗행 값 Formula 복사 | 편집모드 진입 시 재적용 |

**SP 측 대응**

| # | PKG 라인 | 제약 |
|---:|---|---|
| 13 | L59~63 (DEL) | `DELETE … WHERE ATTRIBUTE2 IN (SELECT ATTRIBUTE2 FROM TABLE(P_DMF0068))` — 짝 행 동시 삭제 |
| 14 | L1232~1278 (SAVE `CUR2`) | `ATTRIBUTE2` 공란 행에 같은 (프로젝트, 기간) 행의 `ATTRIBUTE2` 공유, 없으면 새 GUID |
| 15 | L1285~1297 (SAVE `CUR3`) | 기간이 바뀐 행이 있으면 **같은 `ATTRIBUTE2` 그룹의 짝 행 기간도 동일 갱신** |

**클라이언트 짝 검증**: L1004~1025 — `ATTRIBUTE2` 공란 행을 `(PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO)` 로 그룹핑해 **2건 미만 그룹이 있으면 MSG00113 후 저장 전체 중단**.

---

## 4. 월(PIVOT) 컬럼 축 (전수 8건)

| # | 라인 | 위치 | 제약 |
|---:|---|---|---|
| 1 | L198~199 | InitControls | 기본 기간 = **전년 01월 ~ 익년 12월**(36개월) |
| 2 | L269~272 | SetSpreadMonth | 컬럼 **11~154 를 일괄 숨김** — 주석에 "월 늘어나면 이 부분 바뀌어야 함(월개수+10)" 명시. **TO-BE 동적화 대상** |
| 3 | L275 / L297~327 | SetSpreadMonth / MonthAgeFind | 두 월 사이 개월 수 산출(최대 224 루프) |
| 4 | L281~287 | SetSpreadMonth | 11 ~ 11+월수 만 표시 + **헤더 2단째 텍스트를 `yyyy.MM` 로 덮어씀** |
| 5 | L293 | SetSpreadMonth | 상위 헤더 병합 "수주 기간 매출 상세" |
| 6 | L262 | InitSpread | 상위 헤더 병합 "수주 기간"(시작/종료 2칸) |
| 7 | L717~739 | FindData | 헤더월 < OrderStart 또는 > OrderEnd 인 셀을 "0" 으로 덮어씀. ⚠️ **루프가 12부터 시작**해 첫 표시 월(M1)은 0 처리에서 누락됨 |
| 8 | PKG L399~407 | `C_BUCKET` 커서 | `SCM_SYS_CALENDAR_M` 에서 `P_FROMDT~P_TODT` 월 목록 → `M1..Mn` 순번 별칭 |

**메타 정합**: `SCM_MST_SHEET_COLUMNS` 에 `M1~M143` **143개** 등록(AS-IS 하드코딩 전제는 144개). 기본 36개월에는 무영향.

---

## 5. 잠금(Lock) / 편집 가능 셀 축 (전수 9건)

| # | 라인 | 시점 | 대상 | 상태 |
|---:|---|---|---|---|
| 1 | L662 | 조회 직후 | `LockColumn(0, MaxColumnIndex, true)` | **전 컬럼 잠금** |
| 2 | L461 | 편집 진입 | `txtVersion`/`btnSPVer`/`drpPeriodMonth` `Enabled = !IsLock()` | 편집 중 조회조건 잠금 |
| 3 | L463 | 편집 진입 | `SwitchLock()` | 잠금 토글 |
| 4 | L465 | 편집 진입 | `LockColumn(2, 2, true)` | 컬럼 2 잠금 |
| 5 | L466 | 편집 진입 | `LockColumn(5, 5, true)` | 컬럼 5 잠금 |
| 6 | L467 | 편집 진입 | `LockColumn(8, ColumnCount-1, true)` | **실적 이후 전 컬럼 잠금** |
| 7 | L484~485 | 편집 진입 | 짝수 행 `OrderStart~OrderEnd` `LockRange(true)` | 짝 행 기간 잠금 |
| 8 | L1171~1173 | 행 추가 | 둘째 행 `OrderStart`/`OrderEnd`/`Project` `Locked=true` | 짝 행 잠금 |
| 9 | L1206 | 행 추가 | `LockRange(row, 8, row+1, ColumnCount-1, true)` | 신규 세트 실적 이후 잠금 |

**결과적으로 편집 가능한 것**: 첫 행의 `Project_Name`, `OrderEnd`(및 인덱스에 따라 `OrderStart`), `OrderApproval`, `OrderNow`. 짝수 행은 값이 첫 행을 따라간다.
→ TO-BE 셀 색상: 편집 가능 = Yellow, 잠금 = Gray/White (hook #95 3색 표준). 캡쳐(`Doc/_figma/CAP_SVG/DMF0068.png`)도 Project/수주기간/수주(품의)/수주(현재) 를 노란 편집셀로 표현하고 있다.

---

## 6. Validation / MSG 축 — 활성 23건 (+ 팝업 2건)

| # | 라인 | 핸들러 | 조건 | MSG(AS-IS) | 파라미터 | 조치 |
|---:|---|---|---|---|---|---|
| 1 | 206 | InitControls | 내 사업부에 40 없음 | MSG00415 | — | 통보 + return |
| 2 | 449 | EditButton | 동일 | MSG00415 | — | 통보 + return |
| 3 | 454 | EditButton | 그룹 ∉ viewAuth | MSG00096 | — | 통보 + return |
| 4 | 576 | FindData | 내 사업부에 40 없음 | MSG00415 | — | 통보 + return |
| 5 | 581 | FindData | 그룹 ∉ viewAuth | MSG00096 | — | 통보 + return |
| 6 | 587 | FindData | Version 공란 | MSG00283 | — | 통보 + return |
| 7 | 592 | FindData | Period 시작/종료 공란 | MSG00002 | `"Period"` | 통보 + return |
| 8 | 603 | FindData | Period 날짜 파싱 실패 | MSG00049 | `""` | 통보 + return |
| 9 | 609 | FindData | 시작월 > 종료월 | MSG00108 | — | 통보 + return |
| 10 | 655 | FindData | `strCnt != "0"` | MSG00307 | — | ⛔ **도달 불가 죽은 코드** (strCnt 상수 "0") — 이관 제외 |
| 11 | 922 | SaveData | 행 기간 공란 | MSG00002 | `"Period"` | 통보 + **저장 전체 중단** |
| 12 | 927 | SaveData | Project 공란 | MSG00002 | `"Project"` | 통보 + 중단 |
| 13 | 932 | SaveData | Measure 공란 | MSG00002 | `"Measure"` | 통보 + 중단 |
| 14 | 937 | SaveData | 수주(품의)/수주(현재) 공란 | MSG00084 | — | 통보 + 중단 |
| 15 | 942 | SaveData | 정수부 ≤ 0 | MSG00084 | — | 통보 + 중단 |
| 16 | 953 | SaveData | 행 시작 > 종료 | MSG00108 | — | 통보 + 중단 |
| 17 | 959 | SaveData | 행 기간 파싱 실패 | MSG00049 | `""` | 통보 + 중단 |
| 18 | 1023 | SaveData | 신규 행 짝 미충족 | MSG00113 | — | 통보 + 중단 |
| 19 | 1064 | SaveData | `result_code = 'S'` | MSG00004 | `"ADD / MODIFY : {cnt}"` | 성공 통보 + 재조회 |
| 20 | 1070 | SaveData | `result_code = 'DUPLICATE'` | MSG00105 | — | 통보 + return |
| 21 | 1076 | SaveData | 그 외 | MSG00260 | — | 통보 + return |
| 22 | 1115 | SaveData(Delete) | `result_code = 'S'` | MSG00004 | `"DELETE : {cnt}"` | 성공 통보 + 재조회 |
| 23 | 1121 | SaveData(Delete) | 그 외 | MSG00284 | — | 통보 |
| P1 | 팝업 341 | SetItem | 선택 행 2개 이상 | MSG00279 | — | 통보 + return |
| P2 | 팝업 358 | SetItem | 선택 범위 없음 | MSG00279 | — | 통보 + return |

> L1075 의 `MSG00284` 는 **주석 처리분**이라 활성 23건에서 제외. `MessageBox.Show(ex.Message)` (L1136) 는 예외 직접 표시로 MSG ID 없음.

**AS-IS ID ↔ TO-BE ID 대사 결과는 `주요이벤트_상세분석.md` §6.2 참조** (재사용 6 / 신규 채번 5 / 제외 1 / 대체검토 2). ⛔ MSG00002·MSG00004·MSG00284 는 TO-BE 에 **다른 문구로 이미 존재**하므로 번호를 그대로 쓰면 안 된다.

---

## 7. 저장 payload 축 (전수 10건)

| # | 라인 | 필드 | 규칙 |
|---:|---|---|---|
| 1 | 843~850 | 컬럼 8개 | `PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO, MEASURE, ORDER_APPROVAL, ORDER_NOW, ATTRIBUTE1, ATTRIBUTE2` |
| 2 | 872 | 수집 대상 | action `M` 또는 `I` → `dtProd` |
| 3 | 983~988 | 삭제 대상 | action `D` → `dtDel` (`ATTRIBUTE2` 만) |
| 4 | 905~912 | `strChgMeasure` | `MEASURE2 != 'SalesAmt_KRW'` → `'MEA_1'`, else `MEASURE2` |
| 5 | 914~915 | `MEASURE` | action `M` → `strChgMeasure`, `I` → 그리드 `Measure` 표시값 |
| 6 | 971 | `PROJECT_CODE` | 그리드 `Project_Name` |
| 7 | 973 | `ATTRIBUTE1` | `M` → 기존 `KEYVALUE`, `I` → **새 `Guid.NewGuid()`** |
| 8 | 979 | `ATTRIBUTE2` | 그리드 `KEYVALUE2`(그룹 GUID). 편집모드 신규는 공란 가능 |
| 9 | 974~977 | 기간·수량 | `YYYYMM_FROM/TO` = `yyyyMM` 문자열, `ORDER_APPROVAL/NOW` = 문자열 그대로 |
| 10 | 1048~1050 | 부가 파라미터 | `@P_USER_ID`, `@P_DIVISION_ID="40"`, `@P_VERSION_NO=txtVersion.Text` |

**타입 제약(TO-BE)**: `T_DMF0068_ROW` = DIVISION_ID(10) / PROJECT_CODE(200) / YYYYMM_FROM(6) / YYYYMM_TO(6) / MEASURE(100) / ORDER_APPROVAL(NUMBER) / ORDER_NOW(NUMBER) / ATTRIBUTE1(100) / ATTRIBUTE2(100).
**테이블**: `DM_PLN_ORDER_MGT.ORDER_APPROVAL/ORDER_NOW` = `NUMBER(30,10)` (수량/금액 표준 준수 ✔), `PROJECT_CODE` VARCHAR2(800), `ATTRIBUTE1~10` VARCHAR2(600). `VERSION_NO` 는 존재하지만 **SAVE 가 저장하지 않는다**(주석 처리 — AS-IS 동일).

---

## 8. SP 결과코드 축

| SP | 코드 | AS-IS 반환 | TO-BE 반환(O_RESULT_CURSOR) | FE 처리 |
|---|---|---|---|---|
| SAVE | 성공 | `result_code='S'`, `result_cnt` | `CODE='0'`, `MSG='SUCCESS'`, `EVENT=건수` | 성공 토스트 + 재조회 |
| SAVE | 기간 중첩 | `result_code='DUPLICATE'` | `CODE='DUPLICATE'`, `EVENT='DATE DUPLICATE'` | MSG00105 대체 ID |
| SAVE | 기타 실패 | `result_code='F'` | ⚠️ TO-BE 는 `RAISE_APPLICATION_ERROR(-20001)` 로 **예외 전파** | MSG00260 대체 ID (BE 오류 응답 매핑 필요) |
| DEL | 성공 | `result_code='S'`, `result_cnt` | `CODE='0'`, `EVENT=건수` | 성공 토스트 + 재조회 |
| DEL | 실패 | `result_code` ≠ S | 예외 전파 | MSG00284 대체 ID |

---

## 9. ⛔ 차단성 결함 (Phase C 선행 조치 대상)

| # | 위치 | 증상 | 원인 | 정정 | 검증 |
|---:|---|---|---|---|---|
| D1 | PKG BODY **L615** | `GT_DM68_ORD_PJTIFO` 0행 → 월/실적/계획/잔고 전부 0 | `NVL(A.PROJECT_INFO,'') <> ''` 는 Oracle 에서 **항상 FALSE** (MSSQL `ISNULL(...)<>''` 직역) | `WHERE A.PROJECT_INFO IS NOT NULL` | 실측: AS-IS 술어 0행 vs 정정 술어 **14,981행** |
| D2 | PKG BODY **L400 / L768·774 / L924·930** | `M1..Mn` 이 수량 대신 **yyyymm 상수**(202501, 202502 …) 반환 | MSSQL 대괄호 식별자 `[202501]` 를 **따옴표 없이** 옮겨 숫자 리터럴이 됨 | PIVOT IN 과 참조를 인용 식별자로 생성: `IN ('202501' AS "202501", …)` / `NVL("202501",0) AS M1` | 사내 실행으로 결함·정정 양쪽 확인 |
| D3 | PKG BODY L1046~1056, L1300~1304 | `CUR2`/`CUR3`/마지막 UPDATE 가 `DM_PLN_ORDER_MGT` **전역** 스캔 | AS-IS MSSQL 원본도 동일 → **변환 결함 아님(원설계)** | 변경 없음. 리스크로만 기록 | 현재 66행이라 실害 없음 |
| D7 | PKG BODY L174~177(팝업), L762~765·L918~921(조회 동적 SQL) | 편집권한 없는 사용자는 **조회 결과·버전 목록이 통째로 0행** | `SCM_ADM_USER_MNU_EDIT_AUTH_V` 를 **INNER JOIN** 으로 붙여 편집권한이 곧 조회 조건이 됨 | 확정 권한 정책(조회=메뉴권한)에 맞춰 **LEFT JOIN + `NVL(EDY.EDIT_YN,'N')`** 으로 정정 | PKG 본문 실측 |

> D1·D2 는 `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` 부록 C 의 알려진 함정 유형(NULL/빈문자, 동적 식별자 인용)에 정확히 해당한다. 동일 패턴이 다른 변환 PKG 에도 있는지 **횡단 점검 권장**.

---

## 10. 메타 미비 축 (TO-BE 개발 전 반드시 채울 것)

| # | 대상 | 현황 | 조치 |
|---:|---|---|---|
| 1 | `API_M` | **0건** | 시트별 등록 |
| 2 | `MNU_BTN_MPG_M` | **0건** | FE 가 쓰는 **전 시트** 등록 (main / versionPopup / lookupProject) — dayRange 사고 재발 방지 |
| 3 | 버튼 권한 | **0건** | 메뉴권한 3그룹 × 버튼 CROSS JOIN |
| 4 | `MNU_URL` | `dmf0068`(임시) | **`demand-manager`** 로 정정, ROUTE_PATH `demand/demand-waterfall/demand-manager` (99번 마지막 적용) |
| 5 | MSG | 명칭 기준 전수 대사 완료 — 재사용 9종 / 신규 4종 / 제외 1종 | 신규 **MSG00699~MSG00702** 3언어 등록 (현재 MAX = MSG00698) |
| 6 | `SHEET_COLUMNS` `Result`/`Plan` | `SResult`/`SPlan` 과 중복(SORT 7/8), SP 미반환 | **`VISIBLE_FLAG='N'`** 권장 (삭제는 실사용 대조 후) |
| 7 | `EDIT_YN` | SP 반환하나 메타 없음 | 메타 등록 또는 FE 내부 처리로 확정 |
| 8 | `SHEET_MEASURE` | 0행 | Measure 2종이 소스 하드코딩 → 등록 필요 여부 판단 |
| 9 | standalone SP 4종 | INVALID | 존치(배선은 PKG 한정). 정리는 별건 |
| 10 | SAVE/DEL 호출 경로 | 컬렉션 IN → BE 바인딩 불가 | **CLOB(JSON) 래퍼 멤버 신설** (기존 본문 무수정) |
