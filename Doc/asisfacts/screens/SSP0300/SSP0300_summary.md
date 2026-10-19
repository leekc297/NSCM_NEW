# SSP0300 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0300_OrderDetailPopup.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.UIL.csproj | 209 |
| only | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0300_OrderDetailPopup.Designer.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.UIL.csproj | 127 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0300_OrderDetailPopup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 209 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0300_OrderDetailPopup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 127 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 178 | SSP.SSP0300_GET_ORDER_DETAIL | MATCH | SP SSP0300_GET_ORDER_DETAIL |
| button:FindButton | FindButton > FindData | 178 | SSP.SSP0300_GET_ORDER_DETAIL | MATCH | SP SSP0300_GET_ORDER_DETAIL |
| event:this.Load | Form_Load > FindData | 178 | SSP.SSP0300_GET_ORDER_DETAIL | MATCH | SP SSP0300_GET_ORDER_DETAIL |
| event:this.Load | Form_Load > FindData | 178 | SSP.SSP0300_GET_ORDER_DETAIL | MATCH | SP SSP0300_GET_ORDER_DETAIL |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SSP.SSP0300_GET_ORDER_DETAIL | MATCH | 2 | SP SSP0300_GET_ORDER_DETAIL | EXEC:SSP0300_GET_ORDER_DETAIL, SELECT:SSP_ANL_SHIP_ERP_SO, SELECT:SSP_ANL_SHIP_ERP_DO |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:81 |
| this | Load | Form_Load | .ctor:81 |

## 6. 컨트롤 (6개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 1 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: OrderDetail

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 135 | 하드코딩 | AddTextColumn | PO NO. | SO_NO | if(strElectrode_yn == "Y") |
| InitSpread |  | 136 | 하드코딩 | AddTextColumn | PO Item No. | SO_ITEM_NO | if(strElectrode_yn == "Y") |
| InitSpread |  | 137 | 하드코딩 | AddNumColumn | PO Item Qty | SO_ITEM_QTY | if(strElectrode_yn == "Y") |
| InitSpread |  | 141 | 하드코딩 | AddTextColumn | SO NO. | SO_NO | else!(strElectrode_yn == "Y") |
| InitSpread |  | 142 | 하드코딩 | AddTextColumn | SO Item No. | SO_ITEM_NO | else!(strElectrode_yn == "Y") |
| InitSpread |  | 143 | 하드코딩 | AddNumColumn | SO Item Qty | SO_ITEM_QTY | else!(strElectrode_yn == "Y") |
| InitSpread |  | 147 | 하드코딩 | AddTextColumn | DO NO. | DO_NO |  |
| InitSpread |  | 148 | 하드코딩 | AddTextColumn | DO Item No. | DO_ITEM_NO |  |
| InitSpread |  | 149 | 하드코딩 | AddNumColumn | DO Item Qty. | DO_ITEM_QTY |  |
| InitSpread |  | 150 | 하드코딩 | AddTextColumn | Confirm ID | CONFIRM_ID |  |
| InitializeComponent |  | 75 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 76 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 77 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 78 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 135 | 하드코딩 | AddTextColumn | PO NO. | SO_NO | if(strElectrode_yn == "Y") |
| InitSpread |  | 136 | 하드코딩 | AddTextColumn | PO Item No. | SO_ITEM_NO | if(strElectrode_yn == "Y") |
| InitSpread |  | 137 | 하드코딩 | AddNumColumn | PO Item Qty | SO_ITEM_QTY | if(strElectrode_yn == "Y") |
| InitSpread |  | 141 | 하드코딩 | AddTextColumn | SO NO. | SO_NO | else!(strElectrode_yn == "Y") |
| InitSpread |  | 142 | 하드코딩 | AddTextColumn | SO Item No. | SO_ITEM_NO | else!(strElectrode_yn == "Y") |
| InitSpread |  | 143 | 하드코딩 | AddNumColumn | SO Item Qty | SO_ITEM_QTY | else!(strElectrode_yn == "Y") |
| InitSpread |  | 147 | 하드코딩 | AddTextColumn | DO NO. | DO_NO |  |
| InitSpread |  | 148 | 하드코딩 | AddTextColumn | DO Item No. | DO_ITEM_NO |  |
| InitSpread |  | 149 | 하드코딩 | AddNumColumn | DO Item Qty. | DO_ITEM_QTY |  |
| InitSpread |  | 150 | 하드코딩 | AddTextColumn | Confirm ID | CONFIRM_ID |  |
| InitializeComponent |  | 75 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 76 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 77 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 78 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| OrderDetail | 코드 하드코딩 전용(메타 없음) | 7 (?3) | 7 (?3) | 7 (?3) | 7 (?3) | 7 (?3) | 7 (?3) | 7 (?3) | 7 (?3) | 7 (?3) | 7 (?3) | 7 (?3) | 7 (?3) | 7 (?3) | 7 (?3) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 168 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 168건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
