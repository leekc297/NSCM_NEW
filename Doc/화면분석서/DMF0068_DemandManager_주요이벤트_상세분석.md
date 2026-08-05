# DMF0068 Demand Manager (소형 수주관리) — 주요 이벤트 상세분석

> 작성 2026-07-29. AS-IS **정본** 전수 Read + 사내 Oracle `PKG_DMF0068` 본문 전수 Read + AS-IS MSSQL 원본 SP 대조 실측 기반.
> 이 문서는 hook #105 의 "0단계 선행 산출물"이며, UI분석서/화면설계서의 EVENT 시트가 이 본문을 승계한다.

## 0. 원천 (전수 Read 실측)

| 구분 | 경로 | 행수 | Read 범위 |
|---|---|---:|---|
| 정본 화면 | `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\DMF0068_DemandManager40.cs` | 1,337 | 전체 |
| 정본 Designer | 〃 `DMF0068_DemandManager40.Designer.cs` | 371 | 전체 |
| 호출 팝업 | `GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0068_VersionPopup.cs` | 389 | 전체 |
| 팝업 Designer | 〃 `DMF0068_VersionPopup.Designer.cs` | 535 | 컨트롤 선언부 실측 |
| FoxQuery (보안패치 경유) | `GSCM\04.WSL\FoxQuery\DM\Plan\DMF0068_DemandManager40.xml` | 30 | 전체 |
| 구 평면본(참고) | `GSCM\06.UIL\GSCM.DM.Plan.UIL\DMF0068_DemandManager40.cs` | 1,234 | 델타 확인용 |
| TO-BE PKG | 사내 Oracle `SCM_MGR.PKG_DMF0068` (SPEC 78 / BODY 1,383) | 1,461 | 전체 |
| AS-IS SP 5종 | MSSQL `LGCE_SCMDEV` `sys.sql_modules` 직접 추출 | 483/350/88/68/51 | 전체 |

⚠️ **기존 분석자료(`Doc\_analysis\domain_DM\screens\DMF0068_*\`, `_analysis\_screens\27_DM_Screens\27_DM_DMF0068_*.xlsx`)는 구본(1,329줄) 기준이며 MSG 문구가 다른 사전에서 잘못 매핑돼 있다.** 예: `MSG00108` 을 "조회된 데이터가 없습니다", `MSG00113` 을 "복사할 데이터를 선택하세요", `MSG00004` 를 "저장하시겠습니까?" 로 기재. 본 문서의 실측값이 정본이다.

- 클래스: `GSCM.DM.Plan.UIL.DMF0068_DemandManager40 : BaseForm` (L32)
- 시트: 단일 시트 `"ContributeSalesList"` (`SpdSheet.shtMain`, L62)
- WCF 바인딩: `sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc"` (L89)
- 편집 허용 그룹: `viewAuth = { "DM ADMIN", "ADMIN" }` (L37)
- 사업부: **Division 40 고정** — 모든 SP 호출에 `p_division_id = "40"` 하드코딩 (L134/634/1049/1317)

### 0.1 이벤트 배선 전수

| 컨트롤 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this(Form) | Load | `Form_Load` | 생성자 L180 |
| btnSPVer | Click | `btnSPVer_Click` | Designer L173 |

> 배선은 이 2건이 전부다. 그리드(`spdMain`)에는 CellClick/CellDoubleClick/Changed 배선이 **없다** — 셀 편집 제어는 전부 `EditButton()` / `InsertRow()` 안에서 잠금·Formula 로 선처리한다. 나머지 6개 동작은 BaseForm 의 공통 버튼 override(`FindButton`/`InsertButton`/`DeleteButton`/`EditButton`/`SaveButton`/`ExcelButton`)로 들어온다.

### 0.2 2026-03-18 보안 패치 델타 (정본에만 존재)

`[E20260318-001009]` — "프로시저와 파라미터가 노출됨". `DataSql` + `sql.ExcuteProcedure("dbo.DMF0068_SAVE_ORDERLIST")` 를 **`DataNoSql("DM\Plan\DMF0068_DemandManager40")` + `ExcuteProcedure("SaveDemandManager")`** 로 교체(L1034/1057, L1092/1107). 별칭 `SaveDemandManager`/`DelDemandManager` → 실제 SP 명은 FoxQuery XML 이 보유한다.

**중요**: 저장/삭제는 `FoxDataRequest` 가 아니라 이 경로를 타므로, 자동 추출기·`Screen_POPUP_SP_Tables_Matrix.xlsx`·`UI_SP_DEV_STATUS` 계열 인벤토리에서 **SAVE/DEL 2종이 누락**돼 있다. 실사용 SP 는 아래 6종이 전부다.

| # | 호출 경로 | AS-IS SP | TO-BE PKG 멤버 |
|---:|---|---|---|
| 1 | `FoxDataRequest("DM.DMF0068_GET_ORDERLIST")` L632 | `DMF0068_GET_ORDERLIST` | `P_DMF0068_GET_ORDERLIST` |
| 2 | `FoxDataRequest("DM.DMF0068_GET_LOOKUPPROJECT")` L128 | `DMF0068_GET_LOOKUPPROJECT` | `P_DMF0068_GET_LOOKUPPROJECT` |
| 3 | `FoxDataRequest("DM.DMF0068_GET_CONT_VIEW_VERSIONPOPUP")` 팝업 L245 | `DMF0068_GET_CONT_VIEW_VERSIONPOPUP` | `P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP` |
| 4 | `DataNoSql` → `SaveDemandManager` L1057 | `DMF0068_SAVE_ORDERLIST` | `P_DMF0068_SAVE_ORDERLIST` |
| 5 | `DataNoSql` → `DelDemandManager` L1107 | `DMF0068_DEL_ORDERLIST` | `P_DMF0068_DEL_ORDERLIST` |
| 6 | 팝업 `FoxDataRequest("SCM.SCM0001_GET_LOOKUP_VALUES")` L377 | 공통 lookup (`MDF_TYPE`) | 공통 |

---

## 1. 초기화 체인 (Form_Load, L183~191)

생성자에서 `InitializeComponent()` 후 `this.Load += Form_Load`. 실행 순서:

1. `clsCtrl = new CControl(this)`
2. `InitForm()` — BaseForm 공통
3. `InitControls()` (L196~209)
4. `CreateSpread()` (L218~227)
5. `DefineProperty()` (L211~216)

### 1.1 InitControls — 기간 기본값 + 40 전용 게이트

- `drpPeriodMonth.MonthText1 = 전년 01월`, `MonthText2 = 익년 12월` (L198~199). 즉 기본 조회구간은 **36개월**(전년1월~익년12월).
- 필드 초기화 시점(L45)에 `dtDivision = Data.Common(Data.Type.MyDivision, false, NowGroupID, UserId)` 로 내 사업부 목록을 미리 적재.
- 40 게이트: `dtDivision` 에 `CODE` 가 "40" 을 포함하는 행이 하나도 없으면 **MSG00415**("40번 사업부 전용 화면입니다.") 후 `return` (L203~208).
  - ⚠️ `return` 만 하고 화면을 닫지 않는다. 이후 `CreateSpread()` 는 그대로 실행되어 **빈 그리드가 열린다**. 실제 차단은 Find/Edit 재검사에 의존.
  - ⚠️ 판정이 `Contains("40")` 이라 `"140"`, `"401"` 같은 코드도 통과하는 느슨한 비교다(AS-IS 잔존 결함).

### 1.2 CreateSpread → InitSpread(siMain) → SetSpreadMonth(siMain)

- `AddSheet(spdMain, "ContributeSalesList", "ContributeSalesList", 2, 1, 30)` — **헤더 2단**, 초기 1행, 행높이 30 (L220).
- `InitSpread(SpreadInfo)` (L246~264): `InitSheet` → `DataSource=null` → **`SetSheetHeaderColumn(spdInfo, 2)`** (SHEET_COLUMNS 메타로 컬럼 생성, 2단 헤더) → `SmartColMerge()` → 상위 헤더 병합 `ColumnHeaderSpan(0, 2, 1, 2, 20, "수주 기간")` (2번 컬럼부터 2칸 = 시작/종료).
- `SetSpreadMonth(SpreadInfo)` (L266~294) — **월 컬럼 가시성 제어의 핵심**:
  1. 컬럼 인덱스 **11~154 를 전부 `Visible = false`** (L269~272). 주석: *"마지막에 히든컬럼 3개가 있어서 개수 하드코딩함. 월컬럼 늘어나면 이 부분 바뀌어야 함(월개수 + 10)"* → **TO-BE 동적화 필수 지점**.
  2. `MonthAgeFind(From, To)` 로 월 개수 산출 (L297~327 — 최대 224 루프의 O(n) 구현).
  3. 11 ~ (11+월개수) 만 `Visible = true` 로 되돌리고, **컬럼 헤더 2단째 텍스트를 `yyyy.MM` 으로 덮어쓴다** (L281~287).
  4. 상위 헤더 병합 `ColumnHeaderSpan(0, 11, 1, 월개수+1, 20, "수주 기간 매출 상세")` (L293).

> 결론: 그리드 컬럼은 SHEET_COLUMNS 메타(`M1`~`M143`)로 **고정 생성**되고, 조회조건 기간에 따라 **표시 개수와 헤더 라벨만** 바뀐다. 데이터는 SP 가 `M1`, `M2`, … 순번 별칭으로 내려주므로 **n번째 표시 월 = Mn** 규약이다.

- `DefineProperty()` — 팝업 아이콘 셀타입(`cellTypeImage`)을 만들지만 **현재 코드에서 어떤 셀에도 배정하지 않는다**(사용처 L1295 는 주석). 잔존물.
- `SetSpreadHeaderSpan(DataTable)` (L329~410) — 3단 헤더 동적 구성 로직 전체가 **호출되지 않는 죽은 코드**(호출부 L242~243 주석). TO-BE 이관 대상 아님.

---

## 2. 버튼 동작 전수

### 2.1 Find (F5) — `FindButton()` → `FindData()` (L570~821)

**검증 순서 (선행 게이트 → 필수값 → 형식 → 대소)**

| 순서 | 조건 | MSG | 라인 |
|---:|---|---|---:|
| 1 | 내 사업부에 40 없음 | MSG00415 | 576 |
| 2 | `NowGroupID` 이 `DM ADMIN`/`ADMIN` 아님 | MSG00096 | 581 |
| 3 | Version 공란 | MSG00283 | 587 |
| 4 | Period 시작/종료 중 하나라도 공란 | MSG00002 `{0}="Period"` | 592 |
| 5 | Period 를 날짜로 파싱 실패 | MSG00049 `{0}=""` | 603 |
| 6 | 시작월 > 종료월 | MSG00108 | 609 |

> ⚠️ **조회에도 편집권한(`viewAuth`) 을 요구한다.** 즉 AS-IS 에서 `DM Viewer` 는 이 화면을 열어도 조회조차 못 한다. 그런데 사내 TO-BE 메뉴권한에는 `DM Viewer` 가 이미 부여돼 있어 **정책 충돌**이 있다(§6 참조).

**조회 본체**

1. `SuspendLayout()` → `InitSpread(siMain)` → `SetSpreadMonth(siMain)` — **조회 때마다 시트를 재생성**하고 월 가시성을 다시 계산한다.
2. `ProgressForm` 표시 + `SearchStartTime()`(성능 로그).
3. `FoxAsyncProxy.ExecuteAsync` 로 `DM.DMF0068_GET_ORDERLIST` 비동기 호출. **CommandTimeout = 10분**(L633).
   - 파라미터: `p_division_id="40"`, `p_version_no=txtVersion.Text`, `p_fromdt=MonthText1` , `p_todt=MonthText2` (둘 다 `-` 제거 → `yyyyMM`).
4. `strCnt` 는 선언 후 `"0"` 에서 절대 바뀌지 않으므로 `MSG00307` 분기(L653~656)는 **도달 불가 죽은 코드**. (원래 Tables[2].CNT 를 읽던 블록이 L641~645 로 주석 처리됨.)
5. `siMain.Query(dsMain)` → **`LockColumn(0, MaxColumnIndex, true)` 로 전 컬럼 잠금**(조회 직후는 항상 읽기전용) → `SmartColMerge()`.
6. **행별 범위 밖 월 0 처리 루프** (L689~805):
   - `j` 를 12 ~ (월개수+12) 로 순회하며 컬럼 헤더 텍스트(`yyyy.MM`)에서 `.` 를 제거해 숫자 비교.
   - 헤더월 < `OrderStart` 이거나 헤더월 > `OrderEnd` 이면 해당 셀을 **"0" 으로 덮어쓴다**.
   - ⚠️ 시작 인덱스가 `SetSpreadMonth` 의 11 이 아니라 **12** 다. 즉 **첫 번째 표시 월(M1)은 범위 밖이어도 0 처리되지 않는다** — AS-IS 잔존 결함.
   - 회색 배경 처리(L725 등)와 화면단 실적/계획/잔고 재계산(L762~804)은 **속도 문제로 전부 주석 처리**되어 있고, 실적/계획/잔고는 **SP 계산값을 그대로 표시**한다.
7. `finally`: Progress 닫기, `CanModelChange = true`, `ResumeLayout()`, **조회조건 3종을 다시 활성화**.

### 2.2 Insert (F8) — `InsertButton()` → `InsertRow()` (L1146~1302)

전제: 그리드 행 0 이면 무시(L1148), **편집모드(`IsLock()==false`)일 때만** 동작(L1149).

1. `siMain.Insert(2)` — **항상 2행 한 세트**로 삽입 (L1163). 세트 시작 위치는 `GetCellNumbersByRow(ActiveRow)` 로 짝수 정렬(L1164~1165).
2. 두 행 모두 Measure 셀에 콤보 배정.
3. **둘째 행 잠금 + 백색 처리**: `OrderStart`/`OrderEnd`/`Project` 를 `Locked=true`, `BackColor=White` (L1171~1177).
4. **Project 콤보 데이터**: `strSelectedVer != txtVersion.Text` 일 때만 `GetLookupProject()` 재호출(트래픽 절감, L1183~1187). 두 행 모두 같은 `dtLookUpPjt` 바인딩.
5. **첫 행 → 둘째 행 값 동기화**: `OrderStart`/`OrderEnd`/`Project` 를 Formula 로 연결(L1193~1200) → 첫 행을 고치면 둘째 행이 따라 바뀐다.
6. `LockRange(row, 8, row+1, ColumnCount-1, true)` — 8번 컬럼(실적) 이후 전부 잠금(L1206).
7. **Measure 고정 배정**: 버전이 `R_S` 로 시작하면 `dtMeasureS()`, 아니면 `dtMeasureB()` 를 콤보로 주지만 **값은 양쪽 모두 첫 행 `MEA_1`, 둘째 행 `SalesAmt_KRW`** (L1210~1225) 로 동일하다. 두 콤보의 내용도 현재는 완전히 같다(`MEA_1`="QTY(Cell)", `SalesAmt_KRW`="Sales Amt.(KRW)", L91~123). 즉 **R_S/R_B 분기는 현재 실질 무의미**(과거 `RTF[R+P]`/`Business_Plan` 시절 잔재).
8. Measure 셀 2개 모두 `Locked = true` (L1227~1228) — 사용자가 Measure 를 바꿀 수 없다.
9. **페어 키 부여**: `Guid.NewGuid()` 한 개를 두 행의 `KEYVALUE2` 에 동일하게 기록(L1231~1234). 이것이 이후 저장·삭제의 그룹 키다.

### 2.3 Delete (F9) — `DeleteButton()` (L425~441)

- 행 0 이면 무시. **`KEYVALUE` 가 빈 문자열이면 무시**(신규 추가 행이 아닌 빈 행 클릭 방지, L429).
- `siMain.Delete()` — **활성 행 1행만** 삭제 표시(`action='D'`). 세트 2행 동시 삭제 코드는 주석(L434~440).
- 짝을 함께 지우는 책임은 **SP 쪽**에 있다: `P_DMF0068_DEL_ORDERLIST` 가 `ATTRIBUTE2 IN (선택된 ATTRIBUTE2)` 로 지우므로 **같은 그룹 2행이 함께 삭제**된다.

### 2.4 Edit — `EditButton()` (L443~512)

| 순서 | 조건 | MSG |
|---:|---|---|
| 1 | 내 사업부에 40 없음 | MSG00415 |
| 2 | `NowGroupID` ∉ {DM ADMIN, ADMIN} | MSG00096 |
| 3 | 행 0 이면 무시 | — |

편집모드 진입 시:
1. **조회조건 3종을 편집모드 반대값으로 토글**: `txtVersion.Enabled = btnSPVer.Enabled = drpPeriodMonth.Enabled = !siMain.IsLock()` (L461) — 편집 중에는 조회조건 변경 불가.
2. `SwitchLock()` 후 **잠금 재적용**: 컬럼 2(시작) 잠금, 컬럼 5(수주 품의?) 잠금, 컬럼 8 이후 전부 잠금 (L465~467).
   - ⚠️ 실제 편집 가능한 컬럼은 결과적으로 **Project_Name / OrderEnd / OrderApproval / OrderNow** 계열로 좁혀진다(인덱스 하드코딩).
3. **짝수 행(0-base 기준 `(i+1)%2==0`) 처리** (L479~509): `OrderStart`~`OrderEnd` 범위 잠금 + 윗행 값을 Formula 로 복사. 주석: *"수정하지 않는 row 를 강제로 수정모드로 변경할 수 없어서 SP 에서 추가 처리"*.

### 2.5 Save (F7) — `SaveButton()` → `SaveData()` (L823~1144)

전제: `IsLock()==false`(편집모드)이고 시트가 main 이며 행 > 0.

**① 그리드 → DataTable 수집** (L870~989)

- 수집 대상 컬럼 8개: `PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO, MEASURE, ORDER_APPROVAL, ORDER_NOW, ATTRIBUTE1, ATTRIBUTE2`.
- action 이 `M` 또는 `I` → `dtProd`, `D` → `dtDel`(`ATTRIBUTE2` 만 채움).
- 행별 검증 (실패 시 **즉시 return, 이미 수집한 행도 저장 안 됨**):

| 조건 | MSG | 라인 |
|---|---|---:|
| `OrderStart` 또는 `OrderEnd` 공란 | MSG00002 `{0}="Period"` | 922 |
| `Project_Name` 공란 | MSG00002 `{0}="Project"` | 927 |
| Measure 공란 | MSG00002 `{0}="Measure"` | 932 |
| `OrderApproval` 또는 `OrderNow` 공란 | MSG00084 | 937 |
| 정수부가 0 이하 | MSG00084 | 942 |
| `yyyyMM` 파싱 실패 | MSG00049 | 959 |
| 시작 > 종료 | MSG00108 | 953 |

- **Measure 치환 규칙** (L905~915): `MEASURE2 != 'SalesAmt_KRW'` 이면 `strChgMeasure = 'MEA_1'`, 아니면 `MEASURE2` 그대로. 그리고 **action 이 `M` 이면 치환값(`MEA_1`/`SalesAmt_KRW`), `I` 면 그리드 `Measure` 표시값**을 저장한다.
  주석 의도: *"첫 번째 메저는 `MEA_1` 으로 저장되어야 가변적으로 사용 가능"*.
- **ATTRIBUTE1(자기 자신 키)**: `M` 이면 기존 `KEYVALUE`, `I` 면 **새 `Guid.NewGuid()`** (L973).
- **ATTRIBUTE2(그룹 키)**: 그리드 `KEYVALUE2` 그대로 (L979). 편집모드에서 새로 만든 행은 비어 있을 수 있다.

**② 신규 행 짝 검증** (L1004~1025)

`ATTRIBUTE2` 가 빈 행들을 `(PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO)` 로 그룹핑해 **개수가 2 미만인 그룹이 하나라도 있으면 MSG00113** 후 return. 즉 **"신규는 반드시 2행 쌍"** 규칙의 클라이언트 측 강제다.

**③ 저장 호출** (L1027~1079)

`DataNoSql("DM\Plan\DMF0068_DemandManager40")` + 파라미터 `@DMF0068`(DataTable), `@P_USER_ID`, `@P_DIVISION_ID="40"`, `@P_VERSION_NO` → `ExcuteProcedure("SaveDemandManager")`.

| `result_code` | 처리 | MSG |
|---|---|---|
| `S` | 성공, `bolReload = true` | MSG00004 `{0}="ADD / MODIFY : {result_cnt}"` |
| `DUPLICATE` | return | MSG00105 (중첩된 기간이 있습니다) |
| 그 외 | return | MSG00260 (신규 입력 데이터 중 중복) |

**④ 삭제 호출** (L1083~1123)

`@DMF0068`(dtDel) → `DelDemandManager`. `S` 면 MSG00004 `{0}="DELETE : {cnt}"`, 아니면 MSG00284.

**⑤ 재조회**: `bolReload` 면 `FindData()` 재호출 (L1126~1129).

> ⚠️ 저장과 삭제가 **별개 트랜잭션 2회 호출**이다(각각 SP 내부에서 COMMIT). 저장 성공 후 삭제 실패 시 부분 반영이 남는다 — AS-IS 잔존 특성.

### 2.6 Excel — `ExcelButton()` (L520~564)

`[E20241004-000997]` 속도 개선분. `SimpleExcelExportOption` 구성 후 `SimplexelService.ExportFpSpread(fps, exportOption)` 직접 호출.
- `Merge=None`, `Border=All`, `AheadZeroOption=HideZero`, `AmendZeroOption=ShowZero`, Null→Zero 변환 안 함
- `AmendDecimalFormat = "#,##0;[Red]-#,##0"` (정수 포맷 — DMF0049 의 소수 3자리와 다름)
- 파일명 `{StartupPath}\DMF0068_DemandManager40_{yyyyMMddHHmmss}.xlsx`
- `finally` 에서 `MessageService.CloseProgress()`

### 2.7 Version 팝업 — `btnSPVer_Click` (L1315~1333)

- Division 고정 `"40"`, 기간은 `Data.MultiTimeZone(TimeZone)` 기준 **−3개월 ~ +3개월**.
- `DMF0068_VersionPopup.Form_Load(true, "SP", "40", start, end)` → `ShowDialog()`.
- 반환 `sVersions` 가 공란이 아니면 `txtVersion.Text` 에 대입.

---

## 3. Version 팝업 (DMF0068_VersionPopup) 상세

- 시트: `"VersionPopup"`, 헤더 1단, 컬럼은 **코드로 직접 8개 추가**(SHEET_COLUMNS 메타 미사용, L156~175):

| # | 헤더 | 컬럼 | 폭 | 표시 |
|---:|---|---|---:|---|
| 1 | Divison | DIVISION_ID | 60 | 숨김 |
| 2 | Version | VERSION_NO | 220 | 표시 |
| 3 | Description | VERSION_DESCRIPTION | 300 | 표시 |
| 4 | Type | VERSION_TYPE | 100 | 표시 |
| 5 | Seq | VER_CRE_SEQ | 60 | 숨김 |
| 6 | Date | YYYYMMDD | 60 | 숨김 |
| 7 | Create By | CREATED_BY | 100 | 표시 |
| 8 | Create Date | CREATION_DATE | 150 | 표시(가운데) |

- 조회조건: `clbDivision`(내 사업부 체크리스트, 호출자가 "40" 지정) / `drpPeriod`(DateRange, 기본 ±3개월) / `clbType`(`MDF_TYPE` lookup 콤보) / `txtDes`(Description LIKE)
- 조회: `DM.DMF0068_GET_CONT_VIEW_VERSIONPOPUP` — `p_start_yyyymmdd`, `p_end_yyyymmdd`, `p_division_id`, `p_version_type`, `p_description`. 조회 후 전 컬럼 잠금.
- 선택: `SetItem()` — 선택 범위가 없거나 **2행 이상이면 MSG00279**("버전은 1개만 선택해 주세요") 후 return. 1행이면 `VERSION_NO` 를 `sVersions` 에 담고 닫는다.
- 더블클릭(`spdMain_CellDoubleClick`) = `SetItem()` + `Close()`. 버튼 리스트는 Find / OK / Close 3종.
- `GetSpdTitle()`(공통 스프레드 타이틀 조회)는 **호출되지 않는 죽은 코드**(L150~151 주석).

---

## 4. TO-BE PKG_DMF0068 실측 (사내 Oracle, SPEC+BODY VALID)

### 4.1 시그니처 (ALL_ARGUMENTS 순서)

| 멤버 | IN | OUT |
|---|---|---|
| `P_DMF0068_GET_ORDERLIST` | P_DIVISION_ID, P_VERSION_NO, P_FROMDT, P_TODT, **P_USER_ID, P_MENU_ID** | **O_RC1, O_RC2**, O_RESULT_CURSOR |
| `P_DMF0068_GET_LOOKUPPROJECT` | P_DIVISION_ID, P_VERSION_NO, P_USER_ID, P_MENU_ID | O_RC1, O_RESULT_CURSOR |
| `P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP` | P_START_YYYYMMDD, P_END_YYYYMMDD, P_DIVISION_ID, P_VERSION_TYPE, P_DESCRIPTION, P_USER_ID, P_MENU_ID | O_RC1, O_RESULT_CURSOR |
| `P_DMF0068_SAVE_ORDERLIST` | **P_DMF0068 `T_DMF0068_TAB`(컬렉션)**, P_USER_ID, P_DIVISION_ID, P_VERSION_NO | O_RESULT_CURSOR |
| `P_DMF0068_DEL_ORDERLIST` | **P_DMF0068 `T_DMF0068_TAB`(컬렉션)** | O_RESULT_CURSOR |
| `F_COLLECTION_TO_JSON` | P_COLLECTION | (RETURN VARCHAR2) — 예외 로그용 |

`T_DMF0068_ROW` 속성 9개: DIVISION_ID(10) / PROJECT_CODE(200) / YYYYMM_FROM(6) / YYYYMM_TO(6) / MEASURE(100) / ORDER_APPROVAL(NUMBER) / ORDER_NOW(NUMBER) / ATTRIBUTE1(100) / ATTRIBUTE2(100).

> ⛔ **BE generic call-proc 은 컬렉션 타입 IN 을 바인딩할 수 없다.** SAVE/DEL 은 `CLOB(JSON)` 래퍼 멤버를 신설해 `JSON_TABLE` 로 `T_DMF0068_TAB` 을 구성하고 **기존 멤버 본문 무수정으로 위임**해야 한다(Phase C).

### 4.2 GET_ORDERLIST 내부 흐름

1. `DM_MDF_VERSION` 에서 `ORI_CUTOFF_VERSION_NO` 조회(선택 버전의 원본 컷오프 버전).
2. 당월/전월(`V_NOW_YYYYMM`/`V_LAST_YYYYMM`) 산출 — **전월까지 실적, 당월부터 계획**.
3. `C_BUCKET` 커서로 `SCM_SYS_CALENDAR_M` 에서 `P_FROMDT`~`P_TODT` 월 목록을 뽑아 PIVOT 컬럼 문자열 2개(`V_PV_LIST`, `V_PV_COL_LIST`)를 조립.
4. GTT 5종 TRUNCATE → 적재:
   - `GT_DM68_ORD_ITEM_SINGLE_V` ← `DM_MST_ITEM_SINGLE_V`
   - `GT_DM68_ORD_CELL_PACK_COUNT` ← Cell/Pack Count 추출
   - `GT_DM68_ORD_PJTIFO` ← `SCM_MST_SITE_ITEM` (PROJECT_INFO 보유 행) + Cell 수량
   - 버전 접두사 분기: `R_S` → `GT_DM68_ORD_SRESULT_SPLAN`(Sales Plan 계열), 그 외 → `GT_DM68_ORD_BRESULT_BPLAN`(Biz Plan 계열)
5. 분기별로 `V_SQL_TEXT` 동적 SQL 조립 → `OPEN O_RC1 FOR V_SQL_TEXT`.
6. **`O_RC2` = 조립된 SQL 텍스트 1행 1컬럼**(`SQL_TEXT`). AS-IS MSSQL 의 `SELECT CONVERT(TEXT,…) FOR XML PATH` 디버그 출력을 그대로 옮긴 것으로 **화면 데이터가 아니다**. → TO-BE 는 O_RC1 만 그리드에 바인딩하고 O_RC2 는 미사용(또는 진단 로그).
7. 고정 컬럼 14개 + 월 컬럼 n개 반환:
   `PROJECT_NAME, MEASURE, ORDERSTART, ORDEREND, ORDERAPPROVAL, ORDERNOW, SRESULT, SPLAN, STOCK, STOCK2, KEYVALUE, KEYVALUE2, MEASURE2, EDIT_YN, M1…Mn`
   - `STOCK = ORDERNOW - SRESULT`, `STOCK2 = ORDERNOW - SRESULT - SPLAN` (SP 계산)
   - `MEASURE` 는 표시명(`QTY(Cell)` / `Sales Amt.(KRW)`), `MEASURE2` 는 조인용 코드
   - **`EDIT_YN`** 은 `SCM_ADM_USER_MNU_EDIT_AUTH_V` INNER JOIN 결과 — TO-BE 신규 축(AS-IS 에 없음). 이 조인이 **INNER** 라서 편집권한 뷰에 행이 없으면 조회 결과가 0행이 된다.

### 4.3 SAVE_ORDERLIST 내부 흐름

1. `CUR`(입력 컬렉션) 루프 — ① DB 기존 행과 기간 중첩(`CUR_TO >= YYYYMM_FROM AND CUR_FROM <= YYYYMM_TO`, 자기 `ATTRIBUTE1` 제외) ② 입력 컬렉션 내부 중첩. 하나라도 걸리면 `V_DUP='DUPLICATE'`.
2. `V_DUP` 이면 `O_RESULT_CURSOR` 에 `CODE='DUPLICATE'` 반환 후 RETURN (**MERGE 미실행**).
3. `MERGE INTO DM_PLN_ORDER_MGT ON (A.ATTRIBUTE1 = B.ATTRIBUTE1)`
   - MATCHED: `ATTRIBUTE3/4` 에 **변경 전 기간을 백업**하고 기간·수량·수정자 갱신
   - NOT MATCHED: INSERT — `ATTRIBUTE1 = SYS_GUID()`(자기 키), `ATTRIBUTE2 = B.ATTRIBUTE2`(그룹 키). **`VERSION_NO` 은 주석 처리되어 저장하지 않는다**(AS-IS 동일 — "버전과 무관하게 등록/수정/조회").
4. `CUR2` — `ATTRIBUTE2` 가 NULL 인 행에 대해 같은 `(DIVISION_ID, PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO)` 행의 `ATTRIBUTE2` 를 공유, 없으면 새 GUID 부여.
5. `CUR3` — `ATTRIBUTE3/4` 가 남아 있고 기간이 바뀐 행에 대해 **같은 `ATTRIBUTE2` 그룹의 짝 행 기간도 동일하게 갱신**.
6. `ATTRIBUTE3/4` NULL 초기화 → COMMIT → `CODE='0', EVENT=처리건수`.

### 4.4 DEL_ORDERLIST

`DELETE FROM DM_PLN_ORDER_MGT WHERE ATTRIBUTE2 IN (SELECT ATTRIBUTE2 FROM TABLE(P_DMF0068))` — 주석대로 **자기 자신뿐 아니라 짝 행도 함께 삭제**. COMMIT 후 `CODE='0', EVENT=삭제건수`.

---

## 5. ⛔ 실측 확인된 차단성 결함 2건 (MSSQL→Oracle 변환 결함)

두 건 모두 **AS-IS MSSQL 원본과 1:1 대조해 변환 과정에서 발생한 것으로 확정**했다. 현재 상태로 화면을 만들면 **월별 수량·실적·계획·잔고가 전부 무의미한 값**으로 나온다.

### D1. `NVL(PROJECT_INFO,'') <> ''` → 항상 FALSE (BODY L615)

```sql
-- AS-IS MSSQL (정상: '' 와 NULL 이 구별됨)
WHERE ISNULL(A.PROJECT_INFO, '') <> ''
-- TO-BE Oracle (항상 FALSE: '' 는 NULL 이므로 비교 결과가 NULL)
WHERE NVL(A.PROJECT_INFO, '') <> ''
```

**실측**: `SELECT COUNT(*) FROM SCM_MST_SITE_ITEM WHERE NVL(PROJECT_INFO,'')<>''` = **0** vs `WHERE PROJECT_INFO IS NOT NULL` = **14,981**.

**연쇄 영향**: `GT_DM68_ORD_PJTIFO` **0행** → 실적/계획 GTT 가 `PJT_IFO` 와 INNER JOIN 하므로 월별 데이터가 전혀 적재되지 않음 → `SRESULT`/`SPLAN`/`M1~Mn` 전부 0/NULL.
**정정**: `WHERE A.PROJECT_INFO IS NOT NULL`.
(동일 패턴이 `P_DMF0068_GET_LOOKUPPROJECT` 주석 블록 L295 에도 있으나 그쪽은 주석이라 무해.)

### D2. 월 PIVOT 컬럼 참조에 따옴표 누락 (BODY L400, L768/774, L924/930)

```sql
-- AS-IS MSSQL: 대괄호 식별자
SELECT 'ISNULL([' + A.BASIS_YYYYMM + '], 0) AS M' + ROW_NUMBER() ...
PIVOT ( SUM(QTY) FOR YYYYMM IN ( [202501],[202502] ))
-- TO-BE Oracle: 대괄호를 지우기만 해서 "식별자"가 "숫자 리터럴"이 됨
SELECT 'NVL(' || A.BASIS_YYYYMM || ', 0) AS M' || ROW_NUMBER() ...
PIVOT ( SUM(QTY) FOR YYYYMM IN ( 202501,202502 ))
```

**실측**: `P_DMF0068_GET_ORDERLIST('40','R_S_20260311_V002_C','202501','202512',…)` 실행 결과 `M1`=**202501**, `M2`=**202502**, … 즉 **수량 대신 해당 월의 yyyymm 상수**가 그대로 내려온다.

**정정**: PIVOT IN 리스트와 참조를 모두 인용 식별자로 생성.
```sql
-- 검증 완료(사내 실행 성공)
PIVOT (SUM(QTY) FOR YYYYMM IN ('202501' AS "202501", '202502' AS "202502"))
… NVL("202501",0) AS M1, NVL("202502",0) AS M2
```

### (참고) D3 — 저장 커서의 전역 스캔은 AS-IS parity

`CUR2`(`ATTRIBUTE2 IS NULL`), `CUR3`(`ATTRIBUTE3/4 변경분`), 마지막 `ATTRIBUTE3/4 NULL 초기화 UPDATE` 는 모두 `DIVISION_ID` / 이번 저장분 필터가 없어 **테이블 전역**을 훑는다. AS-IS MSSQL 원본도 동일하므로 **변환 결함이 아니라 원설계 특성**이다. 현재 `DM_PLN_ORDER_MGT` 는 66행(33 프로젝트 × 2 Measure)이라 실害는 없으나, 문서에 리스크로 남긴다.

---

## 6. TO-BE 메타 실측 상태 (사내 2026-07-29)

| 항목 | 상태 |
|---|---|
| `PKG_DMF0068` | SPEC 78행 / BODY 1,383행 — **VALID** |
| `T_DMF0068_ROW` / `T_DMF0068_TAB` | VALID |
| standalone SP 4종 | **INVALID** (PKG 로 대체된 변환 잔재) |
| `SCM_MST_SHEET_COLUMNS` | **159행** = 고정 16(가시 15 + 숨김 `Project` 1) + `M1~M143` |
| `SCM_MST_SHEET_MEASURE` | 0행 |
| `SCM_ADM_MNU_M` | 등록 (UPPR=`Demand_Waterfall`, MNU_URL=`dmf0068` 임시, MNU_MSG_ID=MNU00047, UNIT_TP_CD='D') |
| 메뉴 권한 | 3그룹 (ADMIN / DM ADMIN / **DM Viewer**) |
| `API_M` / `MNU_BTN_MPG_M` / 버튼권한 | **전부 0건** |
| FE | 폴더 없음 (미구현) |

### 6.1 SHEET_COLUMNS 대조 결과

| 컬럼 | 라벨 | 가시 | SP 반환 | 판정 |
|---|---|---|---|---|
| Project | Project | N | (없음) | 숨김 유지 |
| Project_Name | Project | Y | `PROJECT_NAME` | ✔ |
| OrderStart / OrderEnd | 시작 / 종료 (상위 "수주 기간") | Y | `ORDERSTART`/`ORDEREND` | ✔ |
| Measure | Measure | Y | `MEASURE` | ✔ |
| OrderApproval / OrderNow | 수주(품의) / 수주(현재) | Y | `ORDERAPPROVAL`/`ORDERNOW` | ✔ |
| **Result / Plan** | 실적 / 계획 | Y | **없음** | ⚠️ SP 는 `SRESULT`/`SPLAN` 만 반환. `Result`/`Plan` 은 SORT 7/8 로 `SResult`/`SPlan` 과 **중복 등록**된 빈 컬럼 → 가시화하면 빈 열 2개가 생긴다 |
| SResult / SPlan | 실적 / 계획 | Y | `SRESULT`/`SPLAN` | ✔ |
| Stock / Stock2 | 잔고(실적 기준) / 잔고(실적+계획 기준) | Y | `STOCK`/`STOCK2` | ✔ |
| M1~M143 | M1~M143 | Y | `M1~Mn` (n=조회 월 수) | ✔ (표시 개수는 기간에 따라 가변) |
| MEASURE2 / KEYVALUE / KEYVALUE2 | 폭 0 | Y | 동일 | 내부 키 (화면 비표시) |
| **EDIT_YN** | — | — | `EDIT_YN` | ⚠️ SP 는 반환하지만 **SHEET_COLUMNS 에 없음** (편집 가능 여부 판정용 — 메타 등록 또는 FE 내부 처리 결정 필요) |

- AS-IS 는 월 컬럼을 **144개**(인덱스 11~154) 전제로 하드코딩했는데 메타는 **143개**다. 기본 조회구간(36개월)에는 영향 없으나 최대 구간 정합은 확인 대상.

### 6.2 MSG 대조 — AS-IS ID 를 그대로 쓰면 안 되는 건이 4종

AS-IS 활성 사용은 **23건 / 13종**(+ 팝업 MSG00279 2건 1종). 사내 TO-BE `SCM_ADM_MSG_M` 과 문구를 1:1 대조한 결과:

**대사 방법**: 사내 `SCM_ADM_MSG_M` 의 한국어 메시지 **774건 전수를 덤프**해 AS-IS 문구와 **명칭(문구) 기준**으로 대조했다. AS-IS 번호가 TO-BE 에서 다른 문구로 점유돼 있어도, **같은 뜻의 기존 코드가 있으면 그 코드를 재사용**한다(신규 채번은 동일·유사 문구가 전무한 경우로 한정).

| AS-IS ID | AS-IS 문구 | 명칭 기준 TO-BE 대사 결과 | 사용할 코드 |
|---|---|---|---|
| MSG00002 | {0} 값은 필수 입력입니다 | **MSG00614** = "{0} 값은 필수 입력입니다." — 문구 일치 | **MSG00614 재사용** |
| MSG00004 | 저장 결과 {0} 건 | **MSG00672** = "{0}개의 데이터가 저장되었습니다." — 의미 일치 | **MSG00672 재사용** (저장·삭제 결과 공용) |
| MSG00049 | 유효한 날짜 형식이 아닙니다. {0} | **MSG00611** = "유효한 날짜 형식이 아닙니다. (YYYYMMDD)" | **MSG00611 재사용** |
| MSG00084 | 0보다 큰 정수를 입력하십시오 | 동일·유사 없음 (MSG00679 는 Business Plan 전용 문구) | **신규 MSG00699** |
| MSG00096 | 권한이 없습니다 | **MSG00096** 문구 일치 | **MSG00096 재사용** |
| MSG00105 | 중첩된 기간이 있습니다 | 동일·유사 없음 ("중첩/겹치" 전무) | **신규 MSG00700** |
| MSG00108 | 시작일자가 종료일자보다 늦을 수 없습니다 | **MSG00108** = "조회 기간이 잘못되었습니다 (시작일 > 종료일)." — 의미 일치 | **MSG00108 재사용** |
| MSG00113 | 필수 입력 컬럼이 없습니다 | **MSG00113** 문구 일치 | **MSG00113 재사용** |
| MSG00260 | 신규 입력 데이터 중 중복된 데이터가 있습니다 | **MSG00260** = "중복된 조합이 존재합니다." — 의미 일치 | **MSG00260 재사용** |
| MSG00279 | 버전은 1개만 선택해 주세요 | 동일·유사 없음 (MSG00255 는 "최대 2개") | **신규 MSG00701** |
| MSG00283 | 버전을 선택하세요 | **MSG00283** 문구 일치 | **MSG00283 재사용** |
| MSG00284 | 실행중 에러가 발생했습니다 | **MSG00618** = "저장 중 오류가 발생했습니다." — 의미 일치(저장 흐름 내 삭제 실패) | **MSG00618 재사용** |
| MSG00307 | (도달 불가 죽은 코드) | — | **이관 제외** |
| MSG00415 | 40번 사업부 전용 화면입니다 | 동일·유사 없음 (MSG00667 은 "권한을 가진 Division이 없습니다" — 다른 의미) | **신규 MSG00702** |

→ **재사용 9종 / 신규 채번 4종 / 제외 1종.** 신규 4종은 현재 최대 번호 MSG00698 다음인 MSG00699~MSG00702 로 채번하며 3언어(KO/EN/CN) 등록한다. (hook #114 `msg-id-asis-tobe-conversion` 적용)

### 6.3 권한 정책 충돌

AS-IS 는 **조회에도** `DM ADMIN`/`ADMIN` 을 요구한다(FindData L579). 사내 TO-BE 메뉴권한에는 `DM Viewer` 가 이미 들어가 있고, SP 는 `SCM_ADM_USER_MNU_EDIT_AUTH_V` 를 **INNER JOIN** 하므로 편집권한 뷰에 없는 사용자는 자동으로 0행이 된다.

**확정 정책(2026-07-29)**: **조회 = 메뉴권한(3그룹 유지) / 편집·저장·삭제·행추가 = `EDIT_YN='Y'` 기준**. 따라서 `DM Viewer` 는 조회 전용으로 운영한다.
→ 이 정책을 성립시키려면 SP 의 편집권한 뷰 조인을 **INNER → LEFT** 로 바꾸고 권한이 없으면 `EDIT_YN='N'` 을 내려줘야 한다(결함 D7, Phase C 정정 대상). 대상은 `P_DMF0068_GET_ORDERLIST` 의 동적 SQL 2곳과 `P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP` 1곳.

---

## 7. TO-BE 설계 반영 포인트 요약

1. **월 컬럼 동적화** — AS-IS 의 `11~154` 하드코딩을 버리고, 조회 기간에서 월 목록을 산출해 `M1..Mn` 을 표시하고 헤더를 `yyyy.MM` 으로 렌더링. 상위 헤더는 "수주 기간 매출 상세"로 병합.
2. **Measure 2행 1세트** — 세로 머지(Project/수주기간/No), 행 추가는 항상 2행, 둘째 행의 Project/기간은 첫 행과 동기화 + 잠금, Measure 값은 `MEA_1`/`SalesAmt_KRW` 고정 + 잠금, `KEYVALUE2`(그룹 GUID) 동일 부여.
3. **삭제는 1행 선택 → SP 가 짝까지 삭제** — FE 는 선택 행의 `KEYVALUE2` 만 보내면 된다.
4. **저장 payload** — 8필드(`PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO, MEASURE, ORDER_APPROVAL, ORDER_NOW, ATTRIBUTE1, ATTRIBUTE2`). `M` = 기존 KEYVALUE, `I` = 신규 GUID. Measure 치환 규칙(`MEASURE2 != 'SalesAmt_KRW'` → `MEA_1`) 유지.
5. **신규는 반드시 쌍** — `ATTRIBUTE2` 공란 그룹이 2행 미만이면 차단(MSG00113 대체 ID).
6. **조회 결과는 읽기전용** — 조회 직후 전 컬럼 잠금, 편집 진입 시에만 Project/OrderEnd/OrderApproval/OrderNow 개방(짝수 행은 기간·Project 잠금 유지).
7. **편집 중 조회조건 잠금** — Version/버전팝업/Period 비활성화.
8. **O_RC2 는 그리드에 쓰지 않는다** (동적 SQL 텍스트).
9. **D1/D2 정정 없이는 화면 의미 없음** — Phase C 선행.
10. **Excel** 은 공통 버튼 기본 동작으로 대체(정수 포맷 `#,##0`).
