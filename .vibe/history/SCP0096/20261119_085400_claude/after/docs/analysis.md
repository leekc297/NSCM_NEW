# SCP0096 — Shipment Working Day OSP: AS-IS 분석

> 근거: AsisFacts 정적 추출(Fact Pack). 묶음에 없는 사항은 **확인 필요**로 적었습니다.

## 1. 화면 개요
| 항목 | 값 |
|---|---|
| 화면 ID | SCP0096 |
| 도메인 | SCP (`06.UIL\GSCM.SCP.Forms.UIL\Master\`) |
| 클래스 | `SCP0096_Shipment_Working_Day_OSP` |
| 화면 제목(Form Text) | `Shipment Working Day OSP` (Designer.cs:663) |
| 프로젝트 | `SCP0096_Shipment_Working_Day_OSP.csproj` |

### 1-1. 파일 구성
| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `...\SCP0096_Shipment_Working_Day_OSP\Properties\AssemblyInfo.cs` | 37 |
| current | `...\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs` | 852 |
| current | `...\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs` | 724 |
| shared | 묶음에 따로 집계되지 않음(프레임워크 `SpreadInfo`, `CString`, `FPExtensions`, `Data.Common`만 호출 대상으로 확인됨) | — |
| legacy | 본문 표에 없음. CSV에 legacy 행 없음 | — |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| `Form_Load` (this.Load) | Form_Load > InitControls > GetBucketType | 394 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | DM0003_GET_BUCKET_TYPE_CODE |
| `Form_Load` (this.Load) | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| FindButton | FindButton > FindData_Main | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| SaveButton | SaveButton > SaveData_Main | 608 | `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` | MATCH | SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP |
| SaveButton | SaveButton > SaveData_Main > FindData_Main | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| SaveButton | SaveButton > SaveData_Main > FindData_Main > InitSpread > GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| (진입점 미연결) | `<field:dtDayWeek>` | 49 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | — |
| (진입점 미연결) | `<field:dtValidYN>` | 51 | `biz:CommonData.YesOrNo` | BIZ_MATCH | — |

- 저장한 뒤에는 `FindData_Main`으로 다시 조회합니다(SaveButton > SaveData_Main > FindData_Main).
- `dtValidYN`은 진입점 미연결로 분류됐습니다. 하지만 `InitSpreadDateColumn:203`의 `AddComboColumn` 인자 `dt`에 `dtValidYN`이 쓰입니다(grid_code.csv raw). 그러므로 실제로는 Grid 콤보 데이터로 쓰입니다.
- `dtDayWeek`(LookupCommon)를 소비하는 컨트롤은 **확인 필요**입니다. `cboDayWeek`일 가능성이 있지만, 바인딩 코드가 묶음에 없습니다.
- 주석 처리됨: 줄 456의 `SCP.SCP0019_GET_WORKING_TIME`(commented:MATCH). 현행 기능이 아니므로 흐름 집계에서 뺐습니다.

## 3. 엔드포인트 전체 표
| 엔드포인트 | 상태 | 호출 수 | SP | 참조 객체(EXEC 전이 포함) |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 1 | (UP_FX_GetCommonDataList 코드 분기) | SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 1 | — | — |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SELECT:SCM_SYS_CALENDAR_M |
| `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | 1 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | INSERT:#TBLDYNAMICPIVOT_SCP0096, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, REF:STRING_SPLIT, DYNAMIC SQL |
| `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` | MATCH | 1 | SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | MERGE:SCP_MST_SHIPMENT_WORKING_DAY_OSP, MERGE:SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |

## 4. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 배선 위치 |
|---|---|---|---|
| this | Load | `Form_Load` | .ctor:103 |
| spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:249 |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:250 |
| cboDivision | SelectedIndexChanged | `CboDivision_SelectedIndexChanged` | InitEvent:251 |
| clbPlantSite | SelectedIndexChanged | `ClbPlantSite_SelectedIndexChanged` | InitEvent:252 |
| cboDayWeek | SelectedIndexChanged | `CboDayWeek_SelectedIndexChanged` | InitEvent:253 |
| btnInput | Click | `BtnInput_Click` | InitEvent:254 |
| this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | InitEvent:255 |

추출된 핸들러 동작:
- `CboDayWeek_SelectedIndexChanged`: `GetCheckedListValue` 호출(672). 분기에 따라 `cboInputValue.Enabled = false`(675) 또는 `true`(679). 분기 조건은 **확인 필요**입니다.
- `BtnInput_Click`: `GetCheckedListValue` 호출(695, 696). 그 뒤 Grid에 값을 넣는 로직은 **확인 필요**입니다.
- `chkSum_CheckedChanged`: `SetSpreadColumn` 호출(330, 335)로 합계 컬럼(M_/W_)의 표시 여부를 바꿉니다.
- `SpdMain_CellDoubleClick`, `SpdMain_TopChange`, `CboDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged`: 내부 동작이 묶음에 없습니다. **확인 필요**.
- 배선 없는 메서드: `cboBucketType_SelectedIndexChanged`(311/316에서 SetSpreadColumn 호출)는 존재하지만, 이벤트 배선 표에 없고 `cboBucketType` 컨트롤도 controls.csv에 없습니다. 사용 여부는 **확인 필요**입니다. `SetChangedControl`(417, 425)의 호출자도 **확인 필요**입니다.

## 5. Grid 구성 방식
**구성 방식: `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

| 단계 | 위치 | 내용 |
|---|---|---|
| 시트 생성 | CreateSpread:142 | `AddSheet(spdMain, "Shipment Working Day OSP", "Shipment Working Day OSP", 3, 1, 35)`. 인자 3/1/35의 의미는 **확인 필요** |
| 메타 컬럼 | InitSpread:156 | `SetSheetHeaderColumn(siMain, 3)`: SCM_MST_SHEET_COLUMNS 메타 6개 컬럼 |
| 날짜 헤더 조회 | InitSpread:151 > GetSpdTitle:831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과(COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE/SMALL_CLASS_LABEL_NAME) |
| DB 루프 컬럼 | InitSpreadDateColumn:196/203 | 컬럼명에 `B_`가 있으면(`IndexOf("B_") > 0`) `AddTextColumn`(폭 0, 숨김). 없으면 `AddComboColumn`(폭 50, 표시, 데이터 `dtValidYN`=YesOrNo, 가운데 정렬) |
| 표시 변경 | InitSpreadDateColumn:208 | DAY_CODE가 SAT이면 ForeColor Blue, SUN이면 Red |
| 헤더 3단 Span | InitSpreadDateColumn:215~244 | 0행 Large class 라벨, 1행 Small class 라벨, 1~2행 `"SUM"` 헤더 Span |
| 표시 토글 | SetSpreadColumn:350/355 | 태그가 `D_`·`W_`로 시작하면 Visible=true. `M_`·`W_`로 시작하면 Visible=`chkSum.Checked` |
| 날짜 컬럼 삽입 위치 | InitSpread:159 | `spdInfo.GetColumnIndex(DefColumns.MEASURE)` 기준(정확한 산식 **확인 필요**) |

### 5-1. Division별 차이
- 메타 규칙상 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 **6/0**(필수+기본 6, 선택 0)입니다. 최종 표시도 6으로 같습니다.
- 코드 분기에 division 비교가 없습니다(판단 불가 0건). **division별 Grid 차이는 없습니다.**
- 날짜·합계 컬럼 수는 조회 기간과 SCP0009 결과에 따라 런타임에 정해지므로 정적으로 셀 수 없습니다.

## 6. 확인 필요 항목
1. `dtDayWeek`(LookupCommon)의 lookup 코드값과 바인딩 컨트롤
2. `GetBucketType`(DM0003) 결과를 쓰는 컨트롤. 화면에 BucketType 컨트롤이 없음
3. `cboBucketType_SelectedIndexChanged`, `SetChangedControl`의 호출 경로
4. `W_` 태그가 350·355 두 조건에 모두 해당될 때 최종 Visible 값(두 문장의 실행 순서)
5. `SaveData_Main` 파라미터 두 블록(570~573 / 578~581)의 분기 조건
6. `B_` 판정이 `IndexOf("B_") > 0`(위치 0 제외)인 의도
7. `usrButton1`(부모 없음, Text 없음)의 용도
8. SCM_MST_SHEET_COLUMNS 메타 6행의 정렬 순서(SORT_ORDER_NO), 폭, 정렬 원문
9. 주석 처리됨: `SCP.SCP0019_GET_WORKING_TIME`(456). 현행 아님
