=== FILE: business_analysis.md ===
# SCP0020 Tact Time — 업무분석서

> **근거 범위**: AsisFacts 정적 추출 Fact Pack(SCP0020)과 1차 분석서(analysis.md / web_components.md / tobe_design.md)에 적힌 사실만 사용했습니다. Fact Pack에서 확인되지 않는 내용은 **확인 필요**로 표시했습니다.
> **주석 처리된 호출(commented_calls)**: 0건입니다. 이 문서의 호출은 모두 현재 동작하는 호출입니다.
> **상호 참조**: §5 데이터 흐름의 엔드포인트 이름은 화면설계서 §5 액션 명세와 단위테스트 '근거' 열에서 같은 이름으로 씁니다.

---

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SCP0020 / `SCP0020_TactTime` | 파일 구성 |
| 폼 Text(원문) | `Tac Time` (원문 철자 그대로) | props.csv `this.Text` (Designer.cs:609) |
| 도메인 | SCP / Master | 경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime` |
| 관리 대상(테이블 기준) | Plant 계열 Tact Time: `SCP_MST_TACT_TIME`(+이력 `SCP_MST_TACT_TIME_H`). Packer(OSP) 계열 Tact Time: `SCP_MST_TACT_TIME_OSP`(+`_H`). 예외(Except) Tact Time: `SCP_MST_TACT_TIME_EXCEPT`(+`_H`), `SCP_MST_TACT_TIME_EXCEPT_OSP`(+`_H`) | §5 저장 SP 쓰기 테이블 |
| 화면 구성 범위 | 상단 그리드 `spdMain`(시트 `Plant` / `Packer`), 하단 그리드 `spdExcept`(시트 `Tact Time Except`) | grid_code.csv CreateSpread:374·377·384 |
| 범위 밖 | 메타에만 있는 시트 `Tact Time`(33행). 코드에서 참조하지 않으므로 미사용 가능 | Fact Pack §12 |
| 업무 목적 서술 | 테이블명과 컬럼명(TACT_TIME, YIELD, DAILY_CAPACITY, PRIORITY, LINE_ID, TACT_TIME_START_DATE/END_DATE)으로 보아 "모델·플랜트 사이트·라인별 Tact Time/Yield/우선순위 기준정보와, 기간을 지정한 예외 Tact Time을 관리"하는 화면으로 보입니다. 업무 정의 문서로 확인한 내용은 아니므로 **확인 필요**입니다. | grid_effective.csv |

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 화면 열기 | `Form_Load` → DefineProperty:199 `biz:CommonData.CommonDataList [code=LineByOperation]` 호출. InitControls:218 `biz:CommonData.YesOrNo` 결과를 cboValid에 DataBind(CODE/NAME). InitControls:220 `biz:CommonData.CommonDataList [code=LookupCommon]` 호출 | 조회조건 초기화. Valid 콤보 채움. LookupCommon 결과를 어느 컨트롤에 바인딩하는지는 **확인 필요** | flow.csv |
| S2 | 조회조건(Division*, Plant Site, Operation Group*, Line, Model, Valid) 입력 후 조회 | FindButton → Find_Data → (Plant 경로) FindData_Main: `biz:CommonData.CommonDataList [code=LineByOperation]`(1041) 호출 후 `SCP.SCP0020_GET_TACT_TIME`(1067) 호출, ChangeSheet(Plant, 1045) | 상단 `Plant` 시트에 결과 표시 | flow.csv, grid_code.csv |
| S3 | (Packer 경로) 조회 | FindButton → Find_Data → Find_Packer: `SCP.SCP0020_GET_TACT_TIME_OSP`(980), ChangeSheet(Packer, 961) | 상단 `Packer` 시트에 결과 표시. Find_Data에서 Plant와 Packer 중 무엇을 고르는지는 **확인 필요** | flow.csv |
| S4 | 상단 행 더블클릭 | `SpdMain_CellDoubleClick` → FindData_Except_Packer(`SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP`, 1321) 또는 FindData_Except(`SCP.SCP0020_GET_TACT_TIME_EXCEPT`, 1397) | 하단 `Tact Time Except` 시트에 결과 표시. 두 경로의 분기 조건은 **확인 필요** | flow.csv |
| S5 | 상단 시트 탭 전환(Plant ↔ Packer) | `SpdMain_ActiveSheetChanged` → Plant면 ChangeSheet/ChangeActiveSheet(shtMain, 2792~2793), Packer면 shtPacker(2799~2800) | 활성 시트 정보 전환 | grid_code.csv |
| S6 | Plant 시트에서 LINE_ID 셀 클릭 | `SpdMain_CellClick` → 조건을 만족하면 SetCellTypeCombo(2583)로 LINE 콤보 구성 | LINE_ID 셀이 콤보로 바뀜 | grid_code.csv |
| S7 | 행 추가(InsertButton) | Packer 시트이고 잠금이 아니면 ActiveRow의 LINE_ID에 SetCellTypeCombo(864, dtComboIns) 적용. CODE/NAME 읽음(859~860) | 새 행의 LINE_ID 셀이 콤보 | grid_code.csv, meta_reads.csv |
| S8 | 편집(EditButton) | spdMain 시트 인덱스 0 → GetSheetInfo(563). 인덱스 1 → GetSheetInfo(607) 후 행을 돌며 INPUT_STATUS 조건에 따라 LINE_ID SetCellTypeCombo(641). spdExcept → GetSheetInfo(673) | 편집 대상 시트 정보 설정 | grid_code.csv |
| S9 | 붙여넣기 | `SpdMain_ClipboardPasted` → 붙여넣은 범위의 LINE_ID 셀에 SetCellTypeCombo(2773, dtLine). CODE/NAME 읽음(2769~2770) | 붙여넣은 LINE_ID 셀이 콤보 | grid_code.csv |
| S10 | 상단 Plant 저장 | SaveButton → SaveData_Main: `SCP.SCP0020_SAVE_TACT_TIME`(1797) → ERR_MESSAGE 확인(1874) → 재조회 FindData_Main(`biz:CommonData.CommonDataList [code=LineByOperation]` 1041, `SCP.SCP0020_GET_TACT_TIME` 1067) | 저장 후 Plant 재조회 | flow.csv, meta_reads.csv |
| S11 | 상단 Packer 저장 | SaveButton → SaveData_Packer: `SCP.SCP0020_SAVE_TACT_TIME_OSP`(1560) → ERR_MESSAGE(1622) → 재조회 Find_Packer(`SCP.SCP0020_GET_TACT_TIME_OSP` 980) | 저장 후 Packer 재조회 | 동일 |
| S12 | 하단 Except(Packer 계열) 저장 | SaveButton → SaveData_Except_Packer: `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP`(2023) → ERR_MESSAGE(2094) → 재조회 `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP`(1321) | 저장 후 하단 재조회 | 동일 |
| S13 | 하단 Except(Plant 계열) 저장 | SaveButton → SaveData_Except: `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT`(2227) → ERR_MESSAGE(2297) → 재조회 `SCP.SCP0020_GET_TACT_TIME_EXCEPT`(1397) | 저장 후 하단 재조회 | 동일 |

- SaveButton이 4개 저장 메서드 중 무엇을 실행할지 정하는 조건(활성 그리드·시트 등)은 Fact Pack에 없습니다(**확인 필요**).

---

## 3. 업무 흐름도 (텍스트 단계)

```
[1] 화면 진입 (Form_Load)
     ├─ DefineProperty:199  biz:CommonData.CommonDataList [code=LineByOperation]
     ├─ InitControls:218    biz:CommonData.YesOrNo → cboValid
     └─ InitControls:220    biz:CommonData.CommonDataList [code=LookupCommon] → (바인딩 대상 확인 필요)
          ※ 필드 초기화 <field:dtValidYN>:57, <field:dtYesOrNo>:58 → biz:CommonData.YesOrNo (진입점 미연결, 실행 시점 확인 필요)
[2] 조회조건 입력
     ├─ cboDivision 변경 → ClbDivision_SelectedIndexChanged (내부 동작 확인 필요)
     └─ clbPlantSite 변경 → ClbPlantSite_SelectedIndexChanged (내부 동작 확인 필요)
[3] 조회 (FindButton → Find_Data)
     ├─ (Plant)  FindData_Main → LineByOperation(1041) → SCP.SCP0020_GET_TACT_TIME(1067) → Plant 시트
     └─ (Packer) Find_Packer   → SCP.SCP0020_GET_TACT_TIME_OSP(980)                   → Packer 시트
          ※ 분기 조건 확인 필요
[4] 상단 행 더블클릭 (SpdMain_CellDoubleClick)
     ├─ FindData_Except_Packer → SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP(1321) → Tact Time Except
     └─ FindData_Except        → SCP.SCP0020_GET_TACT_TIME_EXCEPT(1397)     → Tact Time Except
[5] 편집 (InsertButton / EditButton / 셀 클릭 / 붙여넣기 / 시트 전환)
[6] 저장 (SaveButton)
     ├─ SaveData_Main          → SCP.SCP0020_SAVE_TACT_TIME            → ERR_MESSAGE → [3] Plant 재조회
     ├─ SaveData_Packer        → SCP.SCP0020_SAVE_TACT_TIME_OSP        → ERR_MESSAGE → [3] Packer 재조회
     ├─ SaveData_Except_Packer → SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP → ERR_MESSAGE → [4] EXCEPT_OSP 재조회
     └─ SaveData_Except        → SCP.SCP0020_SAVE_TACT_TIME_EXCEPT     → ERR_MESSAGE → [4] EXCEPT 재조회
```

---

## 4. 업무 규칙 (사실 근거만)

### 4-1. SP 계열 분기
| 규칙 ID | 규칙 | 근거 | 비고 |
|---|---|---|---|
| BR-01 | Plant 시트는 일반 계열 SP(`SCP0020_GET_TACT_TIME`, `SCP0020_SAVE_TACT_TIME`), Packer 시트는 OSP 계열 SP(`SCP0020_GET_TACT_TIME_OSP`, `SCP0020_SAVE_TACT_TIME_OSP`)를 쓴다 | FindData_Main:1045 ChangeSheet(Plant) / Find_Packer:961 ChangeSheet(Packer). 메서드와 시트 대응 | 이 계열을 고르는 분기 조건 원문은 **확인 필요** |
| BR-02 | 하단 Except 조회는 `SCP0020_GET_TACT_TIME_EXCEPT_OSP`(FindData_Except_Packer)와 `SCP0020_GET_TACT_TIME_EXCEPT`(FindData_Except) 두 계열이다 | flow.csv | 분기 조건은 **확인 필요** |
| BR-03 | 하단 Except 저장은 `SCP0020_SAVE_TACT_TIME_EXCEPT_OSP`와 `SCP0020_SAVE_TACT_TIME_EXCEPT` 두 계열이다 | flow.csv | 분기 조건은 **확인 필요** |
| BR-04 | 저장이 끝나면 같은 계열 조회를 다시 실행한다(Main→FindData_Main, Packer→Find_Packer, Except_Packer→FindData_Except_Packer, Except→FindData_Except) | flow.csv | - |

### 4-2. 필수값·검증
| 규칙 ID | 규칙 | 근거 | 비고 |
|---|---|---|---|
| BR-05 | 조회조건 라벨 `Division*`, `Operation Group*`에 `*` 표기가 있다 | props.csv layoutControlItem1:399, layoutControlItem5:472 | 조회 전에 필수 검증을 하는 코드와 메시지는 **확인 필요** |
| BR-06 | 그리드 헤더 라벨에 `*`가 붙은 컬럼: Packer(Daily Capacity*, Division*, Model*, Line*, Priority*, Plant Site*, Tact Time*, Yield(%)*), Plant(Line*, Priority*, Tact Time*, Yield(%)*, 숨김 Valid*), Tact Time Except(Tact Time*, End Date*, Start Date*, Yield(%)*) | grid_effective.csv | 저장 전에 필수 검증을 하는 주체(FE 또는 SP)는 **확인 필요** |
| BR-07 | 저장 SP 4종 모두 결과의 `ERR_MESSAGE`를 읽는다(SaveData_Packer:1622, SaveData_Main:1874, SaveData_Except_Packer:2094, SaveData_Except:2297) | meta_reads.csv | 성공/실패 판정 조건과 메시지 ID는 **확인 필요** |

### 4-3. 그리드 편집 규칙
| 규칙 ID | 규칙 | 근거 |
|---|---|---|
| BR-08 | Plant 시트 LINE_ID 셀 콤보는 다음 조건을 모두 만족할 때만 구성한다: `siMain.IsLock("Plant") == false`, `siMain.IsLockCell(e.Row, e.Column) == false`, 활성 시트 `Plant`, `e.Column == LINE_ID`. 콤보 데이터는 `dtLineByOperationOfSpdAll`을 `DIVISION_ID = division AND FACTORY_ID = pFactoryID AND OP…`(원문이 잘려 있음)로 필터한 결과 또는 `Data.Common(Data.Type.LineByOperation, false, division, …)` | grid_code.csv SpdMain_CellClick:2583 |
| BR-09 | InsertButton: `fps.Name == "spdMain"`이고 시트 인덱스가 0 또는 1, `siMain.IsLock(siMain.SheetName) == false`, 시트가 Plant가 아니고 `Packer`이면 ActiveRow LINE_ID에 콤보(dtComboIns)를 적용한다 | grid_code.csv InsertButton:864 |
| BR-10 | EditButton: spdMain 시트 인덱스 1에서 행을 돌며 `GetText("0", INPUT_STATUS)`가 "M"이 아니고 "I"이면 LINE_ID 콤보(dtComboIns)를 적용한다. 조건식이 행 인덱스 대신 문자열 "0"을 행으로 넘긴다는 점은 원문 그대로이며, 의도는 **확인 필요** | grid_code.csv EditButton:641 |
| BR-11 | 붙여넣기: spdMain, 잠금 아님, 행 수 > 0, 활성 시트가 `SpdSheet.shtMain` 또는 `SpdSheet.shtP…`(원문이 잘려 있음, Packer로 추정되나 **확인 필요**)일 때, 범위 안의 LINE_ID 셀 중 `drArr != null && drArr.Length > 0`인 경우 콤보(dtLine)를 적용한다 | grid_code.csv SpdMain_ClipboardPasted:2773 |
| BR-12 | 하단 `Tact Time Except` 컬럼 표시: 상단 활성 시트가 `Plant`이면 DAILY_CAPACITY 숨김·OPERATION_NAME 표시. 그 외(Packer)이면 DAILY_CAPACITY 표시·OPERATION_NAME 숨김 | grid_code.csv InitSpread:410·411·415·416 |
| BR-13 | SetSpreadInit: `sheetName.Equals("Plant")`이면 ChangeSheet(0)/InitSheet(0)/SetSheetHeaderColumn(438). 아니면 ChangeSheet(1)/InitSheet(1)/SetSheetHeaderColumn(449). 442줄에서 `siMain.ActiveSheet.Visible = false`를 설정하며, 어느 분기에 속하는지는 **확인 필요** | grid_code.csv, props.csv |

### 4-4. 날짜·버킷 규칙
| 규칙 ID | 내용 | 근거 |
|---|---|---|
| BR-14 | 조회 SP `SCP0020_GET_TACT_TIME` / `SCP0020_GET_TACT_TIME_OSP`는 `FN_NEXT_DAY`를 참조하고 `DM_PLN_MKT_FCST`를 읽는다. OSP는 `SCM_MST_PLAN`도 읽는다. 날짜 계산식과 기간 버킷 규칙은 Fact Pack에 없음(**확인 필요**) | endpoints.csv |
| BR-15 | Except 시트에 기간 컬럼 `TACT_TIME_START_DATE`(Start Date*)와 `TACT_TIME_END_DATE`(End Date*), 원래 키 보존 컬럼 `ORG_TACT_TIME_START_DATE`, `ORG_TACT_TIME_END_DATE`가 있다. 기간 겹침 검증 등 규칙은 **확인 필요** | grid_effective.csv |

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| # | 엔드포인트 | SP | 호출 위치 | 읽기 | 쓰기 | 기타(EXEC·임시·함수) |
|---:|---|---|---|---|---|---|
| 1 | `biz:CommonData.YesOrNo` | - (Data.CallBizData) | InitControls:218, `<field:dtValidYN>`:57, `<field:dtYesOrNo>`:58 | DB 보강 정보 없음 | - | - |
| 2 | `biz:CommonData.CommonDataList` [code=LineByOperation] | (UP_FX_GetCommonDataList 코드분기) | DefineProperty:199, FindData_Main:1041 | SCM_MST_LINE_SN, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL | - | REF:STRING_SPLIT |
| 2' | `biz:CommonData.CommonDataList` [code=LookupCommon] | (UP_FX_GetCommonDataList 코드분기) | InitControls:220 | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | - | - |
| 3 | `SCP.SCP0020_GET_TACT_TIME_OSP` | `SCP0020_GET_TACT_TIME_OSP` | Find_Packer:980 | SCM_MST_PLAN, SCP_OPMZ_LOOKUP_MASTER_DETAIL, DM_PLN_MKT_FCST, SCM_MST_SITE, SCM_MST_BOM_SN_V, SCM_MST_ITEM_SN, SCM_MST_FINAL_ITEM_V, SCP_MST_FINAL_ITEM, SCP_MST_TACT_TIME_EXCEPT_OSP, SCP_MST_TACT_TIME_OSP, SCM_MST_SITE_ITEM_PRIORITY, SCM_MST_PLANT_SN | (임시) #TBLDYNAMICPIVOT_SCP0020_TMP, #TBLDYNAMICPIVOT_SCP0020_TMP1 | FN_NEXT_DAY, STRING_SPLIT, FN_GET_ITEM_OPERATION_GROUP, FN_SCM_SPLIT |
| 4 | `SCP.SCP0020_GET_TACT_TIME` | `SCP0020_GET_TACT_TIME` | FindData_Main:1067 | DM_PLN_MKT_FCST, SCM_MST_SITE, SCM_MST_MODEL_FINAL_ITEM_BOM_V, SCP_MST_FINAL_ITEM, SCP_MST_TACT_TIME_EXCEPT, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_LINE_SN, SCP_MST_TACT_TIME, SCM_MST_ITEM_SN, SCM_MST_PLANT_SN, SCP_MST_LOSS_TIME, SCM_MST_SITE_ITEM_PRIORITY, SCP_MST_TACT_TIME_BIG | (임시) #TBLDYNAMICPIVOT_SCP0020_TMP, #TBLDYNAMICPIVOT_SCP0020_TMP1 | FN_NEXT_DAY, STRING_SPLIT, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_ITEM_OPERATION_GROUP, FN_SCM_SPLIT |
| 5 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` | `SCP0020_GET_TACT_TIME_EXCEPT_OSP` | FindData_Except_Packer:1321 | SCM_MST_ITEM_SN, SCP_MST_TACT_TIME_OSP, SCP_MST_TACT_TIME_EXCEPT_OSP, SCM_MST_SITE | - | FN_GET_SCM_SITE_DESCRIPTION |
| 6 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT` | `SCP0020_GET_TACT_TIME_EXCEPT` | FindData_Except:1397 | SCP_MST_TACT_TIME, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_TACT_TIME_EXCEPT, SCM_MST_SITE, SCM_MST_ITEM_SN | - | FN_GET_SCM_SITE_DESCRIPTION, FN_GET_ITEM_NICKNAME |
| 7 | `SCP.SCP0020_SAVE_TACT_TIME_OSP` | `SCP0020_SAVE_TACT_TIME_OSP` | SaveData_Packer:1560 | SCP_MST_TACT_TIME_OSP, SCP_MST_TACT_TIME_EXCEPT_OSP | INSERT SCP_MST_TACT_TIME_OSP, INSERT SCP_MST_TACT_TIME_OSP_H, INSERT SCP_MST_TACT_TIME_EXCEPT_OSP_H, DELETE:A, UPDATE:A (별칭 A의 대상 테이블은 **확인 필요**), INSERT SCM_SYS_LOG_BATCH | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN / #TBLDYNAMICPIVOT_SCP0020_TMP, #TBLDYNAMICPIVOT_SCP0020_SAVE_TMP / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| 8 | `SCP.SCP0020_SAVE_TACT_TIME` | `SCP0020_SAVE_TACT_TIME` | SaveData_Main:1797 | SCP_MST_TACT_TIME, SCP_MST_TACT_TIME_EXCEPT | UPDATE/INSERT/DELETE SCP_MST_TACT_TIME, INSERT SCP_MST_TACT_TIME_H, DELETE SCP_MST_TACT_TIME_EXCEPT, INSERT SCP_MST_TACT_TIME_EXCEPT_H, INSERT SCM_SYS_LOG_BATCH | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, EXEC PR_SCP_MST_TACT_TIME_HIST / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| 9 | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` | `SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` | SaveData_Except_Packer:2023 | SCP_MST_TACT_TIME_EXCEPT_OSP | INSERT SCP_MST_TACT_TIME_EXCEPT_OSP, INSERT SCP_MST_TACT_TIME_EXCEPT_OSP_H, DELETE:A, UPDATE:A (**확인 필요**), INSERT SCM_SYS_LOG_BATCH | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN / #TBLDYNAMIC_SCP0020 / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| 10 | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT` | `SCP0020_SAVE_TACT_TIME_EXCEPT` | SaveData_Except:2227 | SCP_MST_TACT_TIME_EXCEPT | INSERT SCP_MST_TACT_TIME_EXCEPT, INSERT SCP_MST_TACT_TIME_EXCEPT_H, DELETE:A, UPDATE:A (**확인 필요**), INSERT SCM_SYS_LOG_BATCH | EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN / #TBLDYNAMIC_SCP0020 / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |

- 서로 다른 엔드포인트 키는 10개, SP는 8개입니다. SP 8개: `SCP0020_GET_TACT_TIME_OSP`, `SCP0020_GET_TACT_TIME`, `SCP0020_GET_TACT_TIME_EXCEPT_OSP`, `SCP0020_GET_TACT_TIME_EXCEPT`, `SCP0020_SAVE_TACT_TIME_OSP`, `SCP0020_SAVE_TACT_TIME`, `SCP0020_SAVE_TACT_TIME_EXCEPT_OSP`, `SCP0020_SAVE_TACT_TIME_EXCEPT`.
- 주목할 점: Plant 저장 SP `SCP0020_SAVE_TACT_TIME`은 본 테이블과 함께 `SCP_MST_TACT_TIME_EXCEPT`도 DELETE하고 `_EXCEPT_H`에 이력을 남깁니다. 본 행을 삭제할 때 예외 행이 연쇄 삭제되는지는 **확인 필요**입니다. OSP 저장 SP에도 `SCP_MST_TACT_TIME_EXCEPT_OSP_H` INSERT가 있습니다.

---

## 6. Division·권한별 변형

| 구분 | 사실 | 근거 |
|---|---|---|
| Division별 그리드 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)의 표시 컬럼 수가 모두 같습니다. Packer 14, Plant 23, Tact Time 23, Tact Time Except 16(메타 17 − 코드 숨김 1) | Fact Pack §10·§12 |
| Division 코드 분기 | division 변수로 화면 표시를 바꾸는 코드 분기는 0건입니다 | Fact Pack §12 |
| Division 데이터 필터 | SpdMain_CellClick:2583의 LINE 콤보 데이터는 `DIVISION_ID = division`으로 필터됩니다. 표시 변형이 아니라 데이터 필터입니다 | grid_code.csv |
| 권한 메타 | `TB_FX_GroupMenuAuth` 13행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행. C/R/U/D 값은 Fact Pack에 없습니다(**확인 필요**) | Fact Pack §8 |
| 잠금 판정 | `siMain.IsLock("Plant")`, `siMain.IsLockCell(...)`, `siMain.IsLock(siMain.SheetName)`을 씁니다. 잠금이 권한 때문인지 상태 때문인지는 **확인 필요** | grid_code.csv |

---

## 7. 외부 인터페이스

- Fact Pack에 외부 시스템 인터페이스(IF 테이블·외부 API)는 없습니다.
- 내부 공통 로그: 저장 SP 4종 모두 `SCM_SYS_LOG_BATCH`에 INSERT하고 `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`을 EXEC합니다. 외부 연계인지는 **확인 필요**입니다.

---

## 8. 미확정·확인 필요

| # | 항목 | 사유 |
|---:|---|---|
| 1 | Find_Data의 Plant/Packer 분기 조건 | 경로만 추출됨 |
| 2 | SaveButton의 저장 메서드 4종 선택 조건 | 경로만 추출됨 |
| 3 | SpdMain_CellDoubleClick의 Except_Packer/Except 분기 조건 | 경로만 추출됨 |
| 4 | InitControls:220 LookupCommon 결과를 바인딩하는 컨트롤 | 대상 미추출 |
| 5 | DefineProperty:199 LineByOperation 결과의 용도 | 미추출 |
| 6 | `<field:dtValidYN>`·`<field:dtYesOrNo>` 실행 시점 | 진입점 미연결 |
| 7 | 저장 ERR_MESSAGE 판정 조건과 메시지 ID | 컬럼 읽기만 확인 |
| 8 | 저장 SP의 DELETE:A·UPDATE:A 별칭 대상 테이블 | 별칭만 추출 |
| 9 | 조회 SP의 날짜·버킷 계산(FN_NEXT_DAY, DM_PLN_MKT_FCST 사용 방식) | SP 본문 미추출 |
| 10 | 권한 13행의 C/R/U/D 값, Delete 버튼 존재 여부 | 값 미제공 |
| 11 | 이벤트 핸들러 11개(EditModeOff/EditChange 4개, Division/PlantSite 변경 2개, TopChange 2개, Changed 3개)의 내부 동작 | 미추출 |
| 12 | 메타 시트 `Tact Time` 폐기 여부 | 코드 미참조 |
| 13 | SP 실행 결과와 시트 매칭 | Fact Pack: grid 단계 미실행 |
| 14 | `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`, `PR_SCP_MST_TACT_TIME_HIST`, `SCM_ARR_SPL_CNT/VAL`, `FN_*`의 Oracle 존재 여부 | Fact Pack 범위 밖 |
| 15 | 업무 목적 서술(§1) | 업무 정의 문서 없음 |

=== FILE: screen_design.md ===
# SCP0020 Tact Time — 화면설계서

> **근거**: Fact Pack(controls.csv, props.csv, events.csv, grid_effective.csv, grid_code.csv, flow.csv)에 있는 사실만 썼습니다. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.
> **상호 참조**: §5 액션 명세의 엔드포인트는 업무분석서 §5와 같은 이름을 씁니다. §3 컨트롤명은 단위테스트 '절차' 열에서 그대로 씁니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0020 |
| 화면 명칭 | Tact Time. 폼 Text 원문은 `Tac Time`(철자 그대로) |
| 메뉴 위치 | **확인 필요**. TB_FX_MenuItemInfo 1행이 있으나 값은 미제공 |
| AS-IS 소스 | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs`(2909줄) / `.Designer.cs`(672줄) |
| 화면 유형 | 조회조건 + 상단 마스터 그리드(시트 2개) + 하단 디테일 그리드(시트 1개), 상/하 분할 |
| 그리드 구성 방식 | META(프레임워크, `SCM_MST_SHEET_COLUMNS` PROGRAM_ID=SCP0020 111행) + 코드 표시 변경 |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv 크기)

기준 높이 = usrConditionPanel1(68) + splitContainer2(506) = 574px, 기준 폭 = 1093px.

```
SCP0020_TactTime (this, Text="Tac Time")                                   W1093 × H574
│
├─ usrConditionPanel1  [parent=this, Dock=Top, 1093×68, UsrPanelType=HidePanel]   ≈ 11.8%  ← 조회조건 영역
│   └─ usrLayoutControl2  [parent=usrConditionPanel1, Dock=Fill, 1093×68, Text="usrLayoutControl2"]
│       └─ layoutControlGroup2 (1093×73)
│           ├─ 행A (높이 25): layoutControlItem2[Plant Site → clbPlantSite](337)
│           │                 layoutControlItem1[Division* → cboDivision](262)
│           │                 layoutControlItem5[Operation Group* → cboOperationGroup](259)
│           │                 emptySpaceItem3(215)                          합계 1073
│           └─ 행B (높이 28): layoutControlItem6[Line → clbLine](262)
│                             layoutControlItem3[Model → txtItemId](294)
│                             layoutControlItem4[(Text 없음) → btnItemId](43)
│                             layoutControlItem9[Valid → cboValid](259)
│                             emptySpaceItem1(215)                          합계 1073
│
└─ splitContainer2  [parent=this, Dock=Fill, Orientation=Horizontal(상/하), 1093×506, SplitterDistance=392]  ≈ 88.2%
    ├─ Panel1 (상)  392/506 = 77.5%
    │   └─ spdMain  [Dock=Fill, 1093×392]   시트: Plant(인덱스 0) | Packer(인덱스 1)   (Designer 기본 시트 spdMain_Sheet1)
    ├─ Splitter     4/506 ≈ 0.8%
    └─ Panel2 (하)  110/506 = 21.7%
        └─ spdExcept [Dock=Fill, 1093×110]  시트: Tact Time Except            (Designer 기본 시트 spdExcept_Sheet1)

(parent 미기재) usrLayoutControl1 [Dock=Fill, 657×184] / layoutControlGroup1 (657×184)
   → controls.csv parent가 비어 있어 배치 위치를 알 수 없습니다(확인 필요). 하위 아이템이 없는 미사용 레이아웃으로 보입니다.
```

- 행A·행B는 LayoutControlItem의 높이(25/28)로만 나눴습니다. 행 안의 좌→우 순서는 Location이 추출되지 않아 **확인 필요**입니다(위 순서는 Designer 선언 순서가 아니라 행별 나열입니다).
- 행 폭 합계가 둘 다 1073으로 같아, 2행 그리드 배치와 일치합니다.

### 2-2. 영역 정의

| 영역 | 컨트롤 | 비율 | 비고 |
|---|---|---:|---|
| 조회조건 | usrConditionPanel1 > usrLayoutControl2 | 높이 11.8% | HidePanel(접기 가능 유형) |
| 버튼 | 프레임워크 공통 버튼(FindButton, SaveButton, InsertButton, EditButton) | - | 폼 Designer에 없음. 위치는 프레임워크 툴바로 추정되나 **확인 필요**. Delete 계열 유무는 **확인 필요** |
| 상단 그리드 | spdMain (Plant / Packer 탭) | 그리드 영역의 77.5% | 마스터 |
| 하단 그리드 | spdExcept (Tact Time Except) | 그리드 영역의 21.7% | 디테일(상단 더블클릭으로 조회) |
| 팝업 | btnItemId → `btnItemId_Click` | - | txtItemId.Text = sItemId(2560). 팝업 여부는 **확인 필요** |

---

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrLayoutControl1 | UsrLayoutControl | (Text 없음) | - | - | - | 미사용 가능. TO-BE 불필요(**확인 필요**) |
| usrConditionPanel1 | UsrConditionPanel | (Text 없음) | HidePanel | - | - | 조회조건 영역(SearchArea, 접기 가능) |
| usrLayoutControl2 | UsrLayoutControl | `usrLayoutControl2` | - | - | - | 조회조건 그리드 레이아웃 |
| cboDivision | UsrCombo | `Division*` | **확인 필요** | Y(라벨 `*`) | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | 단일 선택 콤보(Wijmo ComboBox) |
| clbPlantSite | UsrCheckedList | `Plant Site` | **확인 필요** | - | SelectedIndexChanged → `ClbPlantSite_SelectedIndexChanged` | 멀티 선택(Wijmo MultiSelect) |
| cboOperationGroup | UsrCombo | `Operation Group*` | **확인 필요** | Y(라벨 `*`) | - | 단일 선택 콤보 |
| clbLine | UsrCheckedList | `Line` | **확인 필요** | - | - | 멀티 선택 |
| txtItemId | UsrMultiLineEditor | `Model` | - | - | (btnItemId_Click에서 값 설정) | 멀티라인 입력 |
| btnItemId | UsrButton | (layoutControlItem4 Text 없음) | - | - | Click → `btnItemId_Click` | 입력칸 옆 아이콘 버튼 |
| cboValid | UsrComboBox | `Valid` | `biz:CommonData.YesOrNo` 바인딩(CODE/NAME). 기본 선택값은 **확인 필요** | - | - | 단일 선택 콤보 |
| spdMain | FpSpread | 시트 `Plant` / `Packer` | - | - | EditModeOff → `SpdMain_EditModeOff`, EditChange → `SpdMain_EditChange`, CellDoubleClick → `SpdMain_CellDoubleClick`, TopChange → `SpdMain_TopChange`, CellClick → `SpdMain_CellClick`, ClipboardPasted → `SpdMain_ClipboardPasted`, ActiveSheetChanged → `SpdMain_ActiveSheetChanged` | Wijmo FlexGrid + 시트 탭 2개 |
| spdMain_Sheet1 | SheetView | (Designer 기본 시트) | - | - | (dsdmMain Changed → `SpdMain_Changed`, dsdmMainPacker Changed → `SpdMain_Changed_Packer`. 데이터소스 단위) | 코드 AddSheet(Plant/Packer)와의 관계는 **확인 필요** |
| spdExcept | FpSpread | 시트 `Tact Time Except` | - | - | EditModeOff → `spdExcept_EditModeOff`, EditChange → `spdExcept_EditChange`, TopChange → `SpdExcept_TopChange` | Wijmo FlexGrid |
| spdExcept_Sheet1 | SheetView | (Designer 기본 시트) | - | - | (dsdmExcept Changed → `SpdExcept_Changed`) | 코드 AddSheet(Tact Time Except)와의 관계는 **확인 필요** |

- 컨트롤 크기(props.csv): cboOperationGroup 152×20, cboDivision 207×20, txtItemId 253×21, btnItemId 39×24, cboValid 225×20, clbLine 231×21, clbPlantSite 276×21.
- 콤보 데이터 원천: cboValid만 확인됨(`biz:CommonData.YesOrNo`). cboDivision, cboOperationGroup, clbLine, clbPlantSite의 원천은 **확인 필요**입니다. 관련 메서드로 RefreshPlantSiteByDivision:292, RefreshLineByOperation:301·302, RefreshLineByOperationOfSpd:315·316, RefreshLineByPlantPacker:327·328(GetCheckedListValue CODE)이 있습니다.

---

## 4. 그리드 명세

공통:
- 출처는 모두 META(`SCM_MST_SHEET_COLUMNS`)입니다. 코드로 표시를 바꾸는 부분만 따로 적었습니다.
- division별 표시: 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같습니다. 아래 "표시" 열은 14개 division 공통입니다.
- 타입: 메타 `CELL_CONTROL_OBJECT_TYPE_CODE` 값이 Fact Pack에 없어 **확인 필요**입니다. 코드로 콤보를 적용하는 LINE_ID만 "콤보(코드)"로 적었습니다.
- 편집 가능 여부: 메타 기준 값이 없어 **확인 필요**입니다. 코드로 콤보 편집을 여는 조건이 있는 경우만 적었습니다.
- 컬럼 순서: grid_effective.csv 행 순서(알파벳)입니다. 실제 표시 순서는 **확인 필요**입니다.
- 헤더 라벨의 `*`는 원문 그대로 옮긴 것입니다.

### 4-1. 시트 `Packer` (spdMain 인덱스 1, SpdSheet.shtPacker) — 표시 14 / 메타 18

| 컬럼 | 헤더 | 타입 | 출처 | 표시(division 공통) | 편집 |
|---|---|---|---|---|---|
| CREATED_BY | Created By | 확인 필요 | META | 기본 | 확인 필요 |
| CREATION_DATE | Creation Date | 확인 필요 | META | 기본 | 확인 필요 |
| DAILY_CAPACITY | Daily Capacity* | 확인 필요 | META | 기본 | 확인 필요 |
| DIVISION_ID | Division* | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Model* | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 기본 | 확인 필요 |
| LINE_ID | Line* | 콤보(코드) | META(+코드 SetCellTypeCombo) | 기본 | InsertButton:864(Packer, 잠금 아님), EditButton:641(INPUT_STATUS="I") 조건에서 콤보 |
| NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| OSP_YN | OSP_YN | 확인 필요 | META | 기본 | 확인 필요 |
| PRIORITY | Priority* | 확인 필요 | META | 기본 | 확인 필요 |
| SITE_DESCRIPTION | Plant Site* | 확인 필요 | META | 기본 | 확인 필요 |
| TACT_TIME | Tact Time* | 확인 필요 | META | 기본 | 확인 필요 |
| YIELD | Yield(%)* | 확인 필요 | META | 기본 | 확인 필요 |
| EXCEPT_YN | EXCEPT_YN | - | META | 숨김 | - |
| INPUT_STATUS | INPUT_STATUS | - | META | 숨김 | - |
| OPERATION_ID | OPERATION_ID | - | META | 숨김 | - |
| PLANT_SITE_ID | PLANT_SITE_ID | - | META | 숨김 | - |
| (OPERATION_NAME) | (없음) | - | CODE_ONLY_CHANGE | - | 메타 행 없음. 코드 변경 대상은 Tact Time Except이므로 파서 귀속 오류 가능성 있음(**확인 필요**) |

### 4-2. 시트 `Plant` (spdMain 인덱스 0, SpdSheet.shtMain) — 표시 23 / 메타 33

| 컬럼 | 헤더 | 타입 | 출처 | 표시 | 편집 |
|---|---|---|---|---|---|
| ACTUAL_CAPACITY | Actual Capacity | 확인 필요 | META | 기본 | 확인 필요 |
| BIG_LAST_UPDATE_DATE | Big Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |
| BIG_TACT_TIME | Big Tact Time | 확인 필요 | META | 기본 | 확인 필요 |
| BOM_MIN_DUE_DATE | Due Date | 확인 필요 | META | 기본 | 확인 필요 |
| CREATED_BY | Created By | 확인 필요 | META | 기본 | 확인 필요 |
| CREATION_DATE | Creation Date | 확인 필요 | META | 기본 | 확인 필요 |
| DAILY_CAPACITY | Daily Capacity | 확인 필요 | META | 기본 | 확인 필요 |
| DIVISION_ID | Division | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_UOM | Item UOM | 확인 필요 | META | 기본 | 확인 필요 |
| JUMBO_MIN | Jumbo / Min | 확인 필요 | META | 기본 | 확인 필요 |
| LANE_QTY | Slitting Lane | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 기본 | 확인 필요 |
| LINE_ID | Line* | 콤보(코드) | META(+코드 SetCellTypeCombo) | 기본 | SpdMain_CellClick:2583(IsLock("Plant")=false, IsLockCell=false, 활성 시트 Plant), SpdMain_ClipboardPasted:2773 조건에서 콤보 |
| MODEL_SITE | Model Site | 확인 필요 | META | 기본 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| OPERATION_NAME | Operation | 확인 필요 | META | 기본 | 확인 필요 |
| PLANT_SITE_NAME | Plant Site | 확인 필요 | META | 기본 | 확인 필요 |
| PRIORITY | Priority* | 확인 필요 | META | 기본 | 확인 필요 |
| TACT_TIME | Tact Time* | 확인 필요 | META | 기본 | 확인 필요 |
| UOM_CONVERT_VALUE | UOM Convert | 확인 필요 | META | 기본 | 확인 필요 |
| YIELD | Yield(%)* | 확인 필요 | META | 기본 | 확인 필요 |
| ACTUAL_OUTPUT | Actual Output | - | META | 숨김 | - |
| EFFECTIVE_DATA_COUNT | Effective Data Count | - | META | 숨김 | - |
| EXCEPT_YN | EXCEPT_YN | - | META | 숨김 | - |
| FROM_ACTUAL_CAPACITY | From Actual Capacity | - | META | 숨김 | - |
| INPUT_STATUS | INPUT_STATUS | - | META | 숨김 | - |
| OPERATION_GROUP_ID | OPERATION_GROUP_ID | - | META | 숨김 | - |
| OPERATION_ID | OPERATION_ID | - | META | 숨김 | - |
| PLANT_SITE_ID | PLANT_SITE_ID | - | META | 숨김 | - |
| TO_ACTUAL_CAPACITY | To Actual Capacity | - | META | 숨김 | - |
| VALID_YN | Valid* | - | META | 숨김 | - |

### 4-3. 시트 `Tact Time` — 메타 정의만 있고 코드 미참조(미사용 가능), 표시 23 / 메타 33

- 코드(CreateSpread, ChangeSheet, SetSheetHeaderColumn)는 이 시트명을 쓰지 않습니다. TO-BE 구현 대상이 아니며 폐기 후보입니다(**확인 필요**).
- 메타 정의(grid_effective.csv 원문, 출처 META, 14개 division 공통):
  - 기본 23: ACTUAL_CAPACITY(Actual Capacity), BIG_LAST_UPDATE_DATE(Big Last Update Date), BIG_TACT_TIME(Big Tact Time), BOM_MIN_DUE_DATE(Due Date), CREATED_BY(Created By), CREATION_DATE(Creation Date), DAILY_CAPACITY(Daily Capacity), DIVISION_ID(Division), ITEM_ID(Model), ITEM_UOM(Item UOM), JUMBO_MIN(Jumbo / Min), LANE_QTY(Slitting Lane), LAST_UPDATE_DATE(Last Update Date), LAST_UPDATED_BY(Last Updated By), LINE_ID(Line*), MODEL_SITE(Model Site), NICK_NAME(Nick Name), OPERATION_NAME(Operation), PLANT_SITE_NAME(Plant Site), PRIORITY(Priority*), TACT_TIME(Tact Time*), UOM_CONVERT_VALUE(UOM Convert), YIELD(Yield(%)*)
  - 숨김 10: ACTUAL_OUTPUT, EFFECTIVE_DATA_COUNT, EXCEPT_YN, FROM_ACTUAL_CAPACITY, INPUT_STATUS, OPERATION_GROUP_ID, OPERATION_ID, PLANT_SITE_ID, TO_ACTUAL_CAPACITY, VALID_YN(Valid*)
- 구성이 `Plant` 시트 33행과 같습니다.

### 4-4. 시트 `Tact Time Except` (spdExcept, SpdSheet.shtExcept) — 표시 16 / 메타 27(메타 표시 17)

| 컬럼 | 헤더 | 타입 | 출처 | 표시 | 편집 |
|---|---|---|---|---|---|
| CREATED_BY | Created By | 확인 필요 | META | 기본 | 확인 필요 |
| CREATION_DATE | Creation Date | 확인 필요 | META | 기본 | 확인 필요 |
| DAILY_CAPACITY | Daily Capacity | 확인 필요 | META+코드 | 상단 Plant 활성 시 숨김(410), 그 외 표시(415) | 확인 필요 |
| DIVISION_ID | Division | 확인 필요 | META | 기본 | 확인 필요 |
| EXCEPT_COMMENT | Comment | 확인 필요 | META | 기본 | 확인 필요 |
| ITEM_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 기본 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 기본 | 확인 필요 |
| LINE_ID | Line | 확인 필요 | META | 기본 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| OPERATION_NAME | Operation | 확인 필요 | META+코드 | 상단 Plant 활성 시 표시(411), 그 외 숨김(416) | 확인 필요 |
| PLANT_SITE_NAME | Plant Site | 확인 필요 | META | 기본 | 확인 필요 |
| TACT_TIME | Tact Time* | 확인 필요 | META | 기본 | 확인 필요 |
| TACT_TIME_END_DATE | End Date* | 확인 필요 | META | 기본 | 확인 필요 |
| TACT_TIME_START_DATE | Start Date* | 확인 필요 | META | 기본 | 확인 필요 |
| USE_YN | Product YN | 확인 필요 | META | 기본 | 확인 필요 |
| YIELD | Yield(%)* | 확인 필요 | META | 기본 | 확인 필요 |
| INPUT_STATUS | INPUT_STATUS | - | META | 숨김 | - |
| OPERATION_ID | OPERATION_ID | - | META | 숨김 | - |
| ORG_DIVISION_ID | ORG_DIVISION_ID | - | META | 숨김 | - |
| ORG_ITEM_ID | ORG_ITEM_ID | - | META | 숨김 | - |
| ORG_LINE_ID | ORG_LINE_ID | - | META | 숨김 | - |
| ORG_OPERATION_ID | ORG_OPERATION_ID | - | META | 숨김 | - |
| ORG_PLANT_SITE_ID | ORG_PLANT_SITE_ID | - | META | 숨김 | - |
| ORG_TACT_TIME_END_DATE | ORG_TACT_TIME_END_DATE | - | META | 숨김 | - |
| ORG_TACT_TIME_START_DATE | ORG_TACT_TIME_START_DATE | - | META | 숨김 | - |
| PLANT_SITE_ID | PLANT_SITE_ID | - | META | 숨김 | - |

코드 표시 변경 규칙(InitSpread, 조건 `spreadInfo.SheetName == "Tact Time Except"`):

| spdMain 활성 시트 | DAILY_CAPACITY | OPERATION_NAME | 표시 컬럼 수 |
|---|---|---|---:|
| `Plant` | 숨김(410) | 표시(411) | 16 |
| 그 외(`Packer`) | 표시(415) | 숨김(416) | 16 |

- Designer 522~525·575~578줄: 컬럼헤더 기본 스타일(HorizontalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced, VerticalAlignment General).

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A01 | 화면 Load | `Form_Load` | DefineProperty:199, InitControls:218·220 | `biz:CommonData.CommonDataList` [code=LineByOperation], `biz:CommonData.YesOrNo`, `biz:CommonData.CommonDataList` [code=LookupCommon] | cboValid 바인딩. LookupCommon과 LineByOperation 결과의 반영 대상은 **확인 필요** |
| A02 | (필드 초기화) | `<field:dtValidYN>`:57, `<field:dtYesOrNo>`:58 | 진입점 미연결 | `biz:CommonData.YesOrNo` | **확인 필요** |
| A03 | 조회(FindButton) — Plant | FindButton → Find_Data → FindData_Main | LineByOperation 재조회 → GET → ChangeSheet(Plant, 1045) | `biz:CommonData.CommonDataList` [code=LineByOperation], `SCP.SCP0020_GET_TACT_TIME` | spdMain `Plant` |
| A04 | 조회(FindButton) — Packer | FindButton → Find_Data → Find_Packer | GET → ChangeSheet(Packer, 961) | `SCP.SCP0020_GET_TACT_TIME_OSP` | spdMain `Packer` |
| A05 | 저장(SaveButton) — Plant | SaveButton → SaveData_Main | SAVE → ERR_MESSAGE(1874) → FindData_Main | `SCP.SCP0020_SAVE_TACT_TIME` → `SCP.SCP0020_GET_TACT_TIME` | spdMain `Plant` 재조회 |
| A06 | 저장(SaveButton) — Packer | SaveButton → SaveData_Packer | SAVE → ERR_MESSAGE(1622) → Find_Packer | `SCP.SCP0020_SAVE_TACT_TIME_OSP` → `SCP.SCP0020_GET_TACT_TIME_OSP` | spdMain `Packer` 재조회 |
| A07 | 저장(SaveButton) — Except(Packer 계열) | SaveButton → SaveData_Except_Packer | SAVE → ERR_MESSAGE(2094) → FindData_Except_Packer | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` → `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` | spdExcept `Tact Time Except` 재조회 |
| A08 | 저장(SaveButton) — Except(Plant 계열) | SaveButton → SaveData_Except | SAVE → ERR_MESSAGE(2297) → FindData_Except | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT` → `SCP.SCP0020_GET_TACT_TIME_EXCEPT` | spdExcept `Tact Time Except` 재조회 |
| A09 | 행 추가(InsertButton) | InsertButton | Packer 시트, 잠금 아님 → LINE_ID SetCellTypeCombo(864). CODE/NAME(859~860) | - (클라이언트) | 새 행 LINE_ID 콤보 |
| A10 | 편집(EditButton) | EditButton | 시트 인덱스 0: GetSheetInfo(563). 인덱스 1: GetSheetInfo(607), INPUT_STATUS="I"이면 LINE_ID 콤보(641). spdExcept: GetSheetInfo(673) | - | 편집 모드 |
| A11 | btnItemId 클릭 | `btnItemId_Click` | txtItemId.Text = sItemId(2560) | - (팝업 여부 **확인 필요**) | txtItemId 값 |
| A12 | cboDivision 변경 | `ClbDivision_SelectedIndexChanged` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A13 | clbPlantSite 변경 | `ClbPlantSite_SelectedIndexChanged` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A14 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | FindData_Except_Packer 또는 FindData_Except(분기 **확인 필요**) | `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` / `SCP.SCP0020_GET_TACT_TIME_EXCEPT` | spdExcept `Tact Time Except` |
| A15 | spdMain 셀 클릭 | `SpdMain_CellClick` | Plant·잠금 아님·LINE_ID → SetCellTypeCombo(2583) | - (LineByOperation 캐시 또는 Data.Common) | LINE_ID 콤보 |
| A16 | spdMain 붙여넣기 | `SpdMain_ClipboardPasted` | 범위 안 LINE_ID 셀에 SetCellTypeCombo(2773). CODE/NAME(2769~2770) | - | LINE_ID 콤보 |
| A17 | spdMain 시트 탭 전환 | `SpdMain_ActiveSheetChanged` | Plant → shtMain(2792~2793), Packer → shtPacker(2799~2800) | - | 활성 시트 정보 전환 |
| A18 | spdMain 스크롤 | `SpdMain_TopChange` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A19 | spdExcept 스크롤 | `SpdExcept_TopChange` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A20 | spdMain 편집 종료 | `SpdMain_EditModeOff` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A21 | spdMain 편집 변경 | `SpdMain_EditChange` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A22 | spdExcept 편집 종료 | `spdExcept_EditModeOff` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A23 | spdExcept 편집 변경 | `spdExcept_EditChange` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A24 | dsdmMain 변경 | `SpdMain_Changed` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A25 | dsdmMainPacker 변경 | `SpdMain_Changed_Packer` | 내부 동작 **확인 필요** | - | **확인 필요** |
| A26 | dsdmExcept 변경 | `SpdExcept_Changed` | 내부 동작 **확인 필요** | - | **확인 필요** |

- 저장 액션 A05~A08 중 무엇이 실행될지 정하는 조건은 **확인 필요**입니다.
- `SetChangedControl_Osp`(362~363줄)는 CODE/NAME을 읽지만 이벤트 배선이 없습니다. 호출하는 곳은 **확인 필요**입니다.

---

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| 조회 필수 | 라벨 `Division*`, `Operation Group*` | 검증 코드와 메시지 ID는 **확인 필요** |
| 그리드 필수 | 헤더 `*` 컬럼(§4) | 검증 주체(FE 또는 SP)는 **확인 필요** |
| 저장 결과 | 저장 SP 4종의 `ERR_MESSAGE`(1622/1874/2094/2297) | 판정 조건과 메시지 ID는 **확인 필요** |
| 잠금 | `IsLock`/`IsLockCell`이 거짓일 때만 LINE_ID 콤보 | 잠금일 때 메시지가 있는지는 **확인 필요** |

---

## 7. 권한(C/R/U/D)

| 항목 | 사실 |
|---|---|
| 권한 메타 | `TB_FX_GroupMenuAuth` 13행. C/R/U/D 값은 **확인 필요** |
| 확인된 공통 버튼 | FindButton(R), SaveButton(C/U/D — 저장 SP 안에 INSERT/UPDATE/DELETE 포함), InsertButton(C), EditButton(U) |
| Delete 버튼 | Fact Pack에 없음(**확인 필요**). 저장 SP에 DELETE가 있음 |
| 잠금 | `siMain.IsLock(...)`. 권한 연동 여부는 **확인 필요** |

---

## 8. To-Be 전환 메모 (Wijmo·Oracle)

| 영역 | AS-IS | TO-BE 고려사항 |
|---|---|---|
| 레이아웃 | SplitContainer 상/하 392:110 | 상단 FlexGrid(탭 Plant/Packer) 약 77.5%, 하단 FlexGrid 약 21.7%의 상하 분할 |
| 시트 탭 | spdMain 시트 2개 | 탭 전환 시 GET/SAVE 계열(일반/OSP)과 하단 Except 컬럼 표시(DAILY_CAPACITY↔OPERATION_NAME)를 함께 바꿔야 함 |
| 그리드 메타 | SCM_MST_SHEET_COLUMNS 기반 SetSheetHeaderColumn | TO-BE 메타(SHEET_COLUMNS)를 그대로 가져와 시트명 `Plant`/`Packer`/`Tact Time Except` 기준으로 생성. `Tact Time`은 제외 후보 |
| 셀 콤보 | SetCellTypeCombo(LINE_ID) 조건부 | Wijmo DataMap으로 셀 단위 콤보 구성. 조건(잠금·Plant/Packer·INPUT_STATUS="I")은 유지 |
| 마스터-디테일 | CellDoubleClick → Except 조회 | 행 더블클릭 이벤트에 하단 조회 연결 |
| 임시 테이블 | `#TBLDYNAMICPIVOT_SCP0020_TMP`, `_TMP1`, `_SAVE_TMP`, `#TBLDYNAMIC_SCP0020` | Oracle GTT로 전환 |
| MSSQL 함수 | `STRING_SPLIT`, `FN_SCM_SPLIT`, `SCM_ARR_SPL_CNT/VAL` | Oracle 대체 구현 필요(존재 여부 **확인 필요**) |
| 하위 PR | `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`, `PR_SCP_MST_TACT_TIME_HIST` | Oracle 쪽 존재 여부 **확인 필요** |
| 저장 결과 | `ERR_MESSAGE` | 결과 커서의 성공/실패 판정 방식을 TO-BE 공통 계약에 맞춰야 함 |

---

## 9. 미확정

| # | 항목 |
|---:|---|
| 1 | 메뉴 위치 |
| 2 | 조회조건 행 안의 좌우 순서(Location 미추출) |
| 3 | usrLayoutControl1의 배치 위치(parent 미기재) |
| 4 | spdMain_Sheet1·spdExcept_Sheet1과 코드 AddSheet 시트의 관계 |
| 5 | 콤보 4종(cboDivision, cboOperationGroup, clbLine, clbPlantSite)의 데이터 원천과 초기값 |
| 6 | btnItemId 팝업 여부 |
| 7 | 내부 동작이 미추출된 이벤트 핸들러 11개 |
| 8 | 조회·저장·더블클릭의 분기 조건 |
| 9 | 그리드 컬럼의 타입·편집 가능 여부·표시 순서 |
| 10 | Packer `OPERATION_NAME` CODE_ONLY_CHANGE 귀속 |
| 11 | SetSpreadInit:442 `ActiveSheet.Visible=false`의 분기 귀속 |
| 12 | 권한 C/R/U/D 값과 Delete 버튼 |

=== FILE: unit_test.md ===
# SCP0020 Tact Time — 단위테스트

> **근거**: Fact Pack 사실만 썼습니다. 내부 동작이 미추출된 핸들러는 기대결과를 "AS-IS와 동일(**확인 필요**)"로 적었습니다.
> 주석 처리된 호출(commented_calls)은 0건이며, 테스트 케이스로 만들지 않았습니다.
> '절차' 열의 컨트롤명은 화면설계서 §3과 같습니다. '근거' 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5와 화면설계서 §5·§4 원문입니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0020-001 | 초기화 | 메뉴 권한 보유 | 화면 SCP0020 열기 | - | cboValid에 YesOrNo 목록(CODE/NAME)이 바인딩된다 | `Form_Load` > InitControls:218 / `biz:CommonData.YesOrNo` |
| TC-SCP0020-002 | 초기화 | 동일 | 화면 열기 | - | LookupCommon 공통코드 호출이 성공한다(바인딩 대상 컨트롤은 **확인 필요**) | `Form_Load` > InitControls:220 / `biz:CommonData.CommonDataList` [code=LookupCommon] |
| TC-SCP0020-003 | 초기화 | 동일 | 화면 열기 | - | LineByOperation 공통코드 호출이 성공한다(용도 **확인 필요**) | `Form_Load` > DefineProperty:199 / `biz:CommonData.CommonDataList` [code=LineByOperation] |
| TC-SCP0020-004 | 초기화 | 동일 | 화면 열기 후 spdMain 탭과 spdExcept 시트 확인 | - | spdMain에 `Plant`·`Packer` 탭, spdExcept에 `Tact Time Except` 시트가 있다. `Tact Time` 시트는 생성되지 않는다 | CreateSpread:374·377·384 / 시트 `Plant`, `Packer`, `Tact Time Except`, `Tact Time` |
| TC-SCP0020-005 | 초기화 | 동일 | 화면 열기 | - | 필드 초기화(dtValidYN/dtYesOrNo)가 오류 없이 수행된다(실행 시점 **확인 필요**) | `<field:dtValidYN>`:57, `<field:dtYesOrNo>`:58 / `biz:CommonData.YesOrNo` |
| TC-SCP0020-006 | 조회 | 데이터가 있는 조건 | cboDivision, cboOperationGroup 선택 → (Plant 경로) 조회 | Division, Operation Group 유효값 | LineByOperation 재조회 후 `Plant` 시트에 결과가 표시된다 | FindButton > Find_Data > FindData_Main:1041·1067 / `biz:CommonData.CommonDataList` [code=LineByOperation], `SCP.SCP0020_GET_TACT_TIME`, SP `SCP0020_GET_TACT_TIME` / 시트 `Plant` |
| TC-SCP0020-007 | 조회 | 데이터가 있는 조건 | (Packer 경로) 조회 | 동일 | `Packer` 시트에 결과가 표시된다 | FindButton > Find_Data > Find_Packer:980 / `SCP.SCP0020_GET_TACT_TIME_OSP`, SP `SCP0020_GET_TACT_TIME_OSP` / 시트 `Packer` |
| TC-SCP0020-008 | 조회 | 결과가 없는 조건 | Plant 경로로 조회 | 존재하지 않는 Model을 txtItemId에 입력 | `Plant` 시트가 0건으로 표시되고 오류가 없다 | `SCP.SCP0020_GET_TACT_TIME` / 시트 `Plant` |
| TC-SCP0020-009 | 조회 | 결과가 없는 조건 | Packer 경로로 조회 | 동일 | `Packer` 시트가 0건으로 표시되고 오류가 없다 | `SCP.SCP0020_GET_TACT_TIME_OSP` / 시트 `Packer` |
| TC-SCP0020-010 | 조회 | SP 오류를 유도하는 환경 | 조회 실행 | - | 오류 메시지가 표시되고 그리드가 깨지지 않는다(메시지 형식 **확인 필요**) | `SCP.SCP0020_GET_TACT_TIME`, `SCP.SCP0020_GET_TACT_TIME_OSP` |
| TC-SCP0020-011 | 조회 | - | cboDivision을 선택하지 않고 조회 | Division 빈값 | 필수 입력 안내가 나오거나 조회되지 않는다(검증 로직 **확인 필요**, 라벨 `Division*`) | layoutControlItem1 Text `Division*` / `SCP.SCP0020_GET_TACT_TIME` |
| TC-SCP0020-012 | 조회 | - | cboOperationGroup을 선택하지 않고 조회 | Operation Group 빈값 | 필수 입력 안내가 나오거나 조회되지 않는다(**확인 필요**, 라벨 `Operation Group*`) | layoutControlItem5 Text `Operation Group*` / `SCP.SCP0020_GET_TACT_TIME` |
| TC-SCP0020-013 | 조회 | 데이터가 있음 | txtItemId에 여러 줄 Model 입력 → 조회 | Model 2건(줄바꿈) | 입력한 Model만 조회된다(파라미터 형식 **확인 필요**) | txtItemId(UsrMultiLineEditor) / `SCP.SCP0020_GET_TACT_TIME` / SP `SCP0020_GET_TACT_TIME` |
| TC-SCP0020-014 | 조회 | 데이터가 있음 | cboValid 선택 → 조회 | Valid = Y / N | 선택값에 맞는 결과가 나온다(**확인 필요**) | cboValid / `biz:CommonData.YesOrNo`, `SCP.SCP0020_GET_TACT_TIME` |
| TC-SCP0020-015 | 조회 | 데이터가 있음 | clbPlantSite·clbLine 다중 선택 → 조회 | Plant Site 2건, Line 2건 | 선택한 사이트·라인만 조회된다(**확인 필요**) | clbPlantSite, clbLine / `SCP.SCP0020_GET_TACT_TIME_OSP` |
| TC-SCP0020-016 | 이벤트 | 화면 열림 | btnItemId 클릭 | - | txtItemId.Text에 sItemId 값이 설정된다(팝업 여부 **확인 필요**) | `btnItemId_Click`:2560 |
| TC-SCP0020-017 | 이벤트 | 화면 열림 | cboDivision 값 변경 | Division A → B | AS-IS와 같이 동작한다(Plant Site 갱신 가능성 있음, 내부 동작 **확인 필요**) | `ClbDivision_SelectedIndexChanged` (InitEvent:460) |
| TC-SCP0020-018 | 이벤트 | Division 선택됨 | clbPlantSite 선택 변경 | Plant Site 체크 변경 | AS-IS와 같이 동작한다(Line 갱신 가능성 있음, 내부 동작 **확인 필요**) | `ClbPlantSite_SelectedIndexChanged` (InitEvent:461) |
| TC-SCP0020-019 | 이벤트 | `Packer` 조회 결과 있음 | spdMain `Packer` 행 더블클릭 | 대상 행 1건 | spdExcept `Tact Time Except`에 OSP 예외 데이터가 표시된다(분기 조건 **확인 필요**) | `SpdMain_CellDoubleClick` > FindData_Except_Packer:1321 / `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP`, SP `SCP0020_GET_TACT_TIME_EXCEPT_OSP` / 시트 `Tact Time Except` |
| TC-SCP0020-020 | 이벤트 | `Plant` 조회 결과 있음 | spdMain `Plant` 행 더블클릭 | 대상 행 1건 | spdExcept `Tact Time Except`에 예외 데이터가 표시된다 | `SpdMain_CellDoubleClick` > FindData_Except:1397 / `SCP.SCP0020_GET_TACT_TIME_EXCEPT`, SP `SCP0020_GET_TACT_TIME_EXCEPT` / 시트 `Tact Time Except` |
| TC-SCP0020-021 | 이벤트 | 예외 데이터가 없는 행 | spdMain 행 더블클릭 | 예외 없는 모델 행 | spdExcept가 0건으로 표시되고 오류가 없다 | `SpdMain_CellDoubleClick` / `SCP.SCP0020_GET_TACT_TIME_EXCEPT`, `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` |
| TC-SCP0020-022 | 이벤트 | `Plant` 활성, 잠금 아님 | spdMain LINE_ID 셀 클릭 | - | LINE_ID 셀이 Line 콤보로 바뀐다(division·FACTORY_ID 필터 데이터) | `SpdMain_CellClick`:2583 / 시트 `Plant` |
| TC-SCP0020-023 | 이벤트 | `Plant` 활성 | spdMain의 LINE_ID 외 셀 클릭, 또는 잠금 셀의 LINE_ID 클릭 | - | 콤보가 구성되지 않는다 | `SpdMain_CellClick`:2583 조건(IsLock("Plant")=false, IsLockCell=false, e.Column==LINE_ID) / 시트 `Plant` |
| TC-SCP0020-024 | 이벤트 | `Plant` 또는 `Packer` 활성, 잠금 아님, 행 1건 이상 | spdMain LINE_ID 열에 값 붙여넣기 | 유효한 Line 코드 2건 | 붙여넣은 LINE_ID 셀에 Line 콤보(dtLine)가 적용된다 | `SpdMain_ClipboardPasted`:2769~2773 / 시트 `Plant`, `Packer` |
| TC-SCP0020-025 | 이벤트 | 화면 열림 | spdMain 탭을 `Plant`로 전환 | - | shtMain으로 ChangeSheet/ChangeActiveSheet가 적용되고, spdExcept에서 OPERATION_NAME 표시·DAILY_CAPACITY 숨김(초기화 시점 **확인 필요**) | `SpdMain_ActiveSheetChanged`:2792~2793 / 시트 `Plant`, `Tact Time Except` |
| TC-SCP0020-026 | 이벤트 | 화면 열림 | spdMain 탭을 `Packer`로 전환 | - | shtPacker로 ChangeSheet/ChangeActiveSheet가 적용된다 | `SpdMain_ActiveSheetChanged`:2799~2800 / 시트 `Packer` |
| TC-SCP0020-027 | 이벤트 | spdMain 다건 조회 | spdMain 세로 스크롤 | - | AS-IS와 같이 동작한다(내부 동작 **확인 필요**) | `SpdMain_TopChange` (InitEvent:464) |
| TC-SCP0020-028 | 이벤트 | spdExcept 다건 조회 | spdExcept 세로 스크롤 | - | AS-IS와 같이 동작한다(**확인 필요**) | `SpdExcept_TopChange` (InitEvent:467) |
| TC-SCP0020-029 | 이벤트 | spdMain 편집 중 | spdMain 셀 편집 후 편집 모드 종료 | 임의 값 | AS-IS와 같이 동작한다(**확인 필요**) | `SpdMain_EditModeOff` (Designer:505) |
| TC-SCP0020-030 | 이벤트 | spdMain 편집 중 | spdMain 셀 값 입력 | 임의 값 | AS-IS와 같이 동작한다(**확인 필요**) | `SpdMain_EditChange` (Designer:506) |
| TC-SCP0020-031 | 이벤트 | spdExcept 편집 중 | spdExcept 셀 편집 후 종료 | 임의 값 | AS-IS와 같이 동작한다(**확인 필요**) | `spdExcept_EditModeOff` (Designer:558) |
| TC-SCP0020-032 | 이벤트 | spdExcept 편집 중 | spdExcept 셀 값 입력 | 임의 값 | AS-IS와 같이 동작한다(**확인 필요**) | `spdExcept_EditChange` (Designer:559) |
| TC-SCP0020-033 | 이벤트 | `Plant` 조회됨 | spdMain `Plant` 셀 값 변경 | 임의 값 | 변경 행 상태가 반영된다(내부 동작 **확인 필요**) | `SpdMain_Changed` (dsdmMain, InitEvent:471) / 시트 `Plant` |
| TC-SCP0020-034 | 이벤트 | `Packer` 조회됨 | spdMain `Packer` 셀 값 변경 | 임의 값 | 변경 행 상태가 반영된다(**확인 필요**) | `SpdMain_Changed_Packer` (dsdmMainPacker, InitEvent:474) / 시트 `Packer` |
| TC-SCP0020-035 | 이벤트 | `Tact Time Except` 조회됨 | spdExcept 셀 값 변경 | 임의 값 | 변경 행 상태가 반영된다(**확인 필요**) | `SpdExcept_Changed` (dsdmExcept, InitEvent:482) / 시트 `Tact Time Except` |
| TC-SCP0020-036 | 그리드 | `Plant` 조회됨 | spdMain `Plant` 헤더 확인 | - | 표시 23개(Actual Capacity … Yield(%)*), 숨김 10개(ACTUAL_OUTPUT, EFFECTIVE_DATA_COUNT, EXCEPT_YN, FROM_ACTUAL_CAPACITY, INPUT_STATUS, OPERATION_GROUP_ID, OPERATION_ID, PLANT_SITE_ID, TO_ACTUAL_CAPACITY, VALID_YN) | SetSpreadInit:438 / 시트 `Plant` / `SCP.SCP0020_GET_TACT_TIME` |
| TC-SCP0020-037 | 그리드 | `Packer` 조회됨 | spdMain `Packer` 헤더 확인 | - | 표시 14개(Created By, Creation Date, Daily Capacity*, Division*, Model*, Last Update Date, Last Updated By, Line*, Nick Name, OSP_YN, Priority*, Plant Site*, Tact Time*, Yield(%)*), 숨김 4개(EXCEPT_YN, INPUT_STATUS, OPERATION_ID, PLANT_SITE_ID) | SetSpreadInit:449 / 시트 `Packer` / `SCP.SCP0020_GET_TACT_TIME_OSP` |
| TC-SCP0020-038 | 그리드 | spdMain `Plant` 활성 | spdExcept `Tact Time Except` 헤더 확인 | - | 표시 16개. OPERATION_NAME(Operation) 표시, DAILY_CAPACITY 숨김 | InitSpread:410·411 / 시트 `Tact Time Except`, `Plant` / `SCP.SCP0020_GET_TACT_TIME_EXCEPT` |
| TC-SCP0020-039 | 그리드 | spdMain `Packer` 활성 | spdExcept `Tact Time Except` 헤더 확인 | - | 표시 16개. DAILY_CAPACITY(Daily Capacity) 표시, OPERATION_NAME 숨김 | InitSpread:415·416 / 시트 `Tact Time Except`, `Packer` / `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` |
| TC-SCP0020-040 | 그리드 | 화면 열림 | 메타 시트 `Tact Time` 노출 여부 확인 | - | `Tact Time` 탭과 그리드가 표시되지 않는다(메타 33행은 코드 미참조, 폐기 여부 **확인 필요**) | 시트 `Tact Time` (Fact Pack §12 "메타 정의만, 코드 미참조") |
| TC-SCP0020-041 | 그리드 | `Packer` 활성, 잠금 아님 | InsertButton 클릭 | - | 새 행이 추가되고 LINE_ID 셀이 콤보(dtComboIns)가 된다 | InsertButton:859~864 / 시트 `Packer` |
| TC-SCP0020-042 | 그리드 | `Packer`(인덱스 1) 조회됨 | EditButton 클릭 | INPUT_STATUS="I" 행 | 조건에 맞는 행의 LINE_ID에 콤보가 적용된다(`GetText("0", …)` 행 지정 원문의 의도 **확인 필요**) | EditButton:607·636~641 / 시트 `Packer` |
| TC-SCP0020-043 | 저장 | `Plant` 행 수정 | spdMain `Plant` 값 수정 → 저장 | TACT_TIME, YIELD, PRIORITY 변경 | 저장에 성공하고 `Plant`가 다시 조회된다. SCP_MST_TACT_TIME·_H에 반영된다 | SaveButton > SaveData_Main:1797·1874 / `SCP.SCP0020_SAVE_TACT_TIME`, SP `SCP0020_SAVE_TACT_TIME` → `SCP.SCP0020_GET_TACT_TIME` / 시트 `Plant` |
| TC-SCP0020-044 | 저장 | `Packer` 행 추가 | InsertButton → 값 입력 → 저장 | 필수(* 컬럼) 입력 | 저장에 성공하고 `Packer`가 다시 조회된다. SCP_MST_TACT_TIME_OSP·_H에 반영된다 | SaveButton > SaveData_Packer:1560·1622 / `SCP.SCP0020_SAVE_TACT_TIME_OSP`, SP `SCP0020_SAVE_TACT_TIME_OSP` → `SCP.SCP0020_GET_TACT_TIME_OSP` / 시트 `Packer` |
| TC-SCP0020-045 | 저장 | Packer 행 더블클릭으로 하단 조회됨 | spdExcept 행 추가·수정 → 저장 | Start Date*, End Date*, Tact Time*, Yield(%)* | 저장에 성공하고 하단이 다시 조회된다. SCP_MST_TACT_TIME_EXCEPT_OSP·_H에 반영된다 | SaveButton > SaveData_Except_Packer:2023·2094 / `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP`, SP `SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` → `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` / 시트 `Tact Time Except` |
| TC-SCP0020-046 | 저장 | Plant 행 더블클릭으로 하단 조회됨 | spdExcept 행 추가·수정 → 저장 | 동일 | 저장에 성공하고 하단이 다시 조회된다. SCP_MST_TACT_TIME_EXCEPT·_H에 반영된다 | SaveButton > SaveData_Except:2227·2297 / `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT`, SP `SCP0020_SAVE_TACT_TIME_EXCEPT` → `SCP.SCP0020_GET_TACT_TIME_EXCEPT` / 시트 `Tact Time Except` |
| TC-SCP0020-047 | 저장 | 저장 SP가 ERR_MESSAGE를 돌려주는 데이터 | 저장 실행 | 필수값 누락 또는 중복 키 | ERR_MESSAGE 내용이 표시되고 재조회로 덮어쓰지 않는다(판정 조건·메시지 ID **확인 필요**) | SaveData_Packer:1622, SaveData_Main:1874, SaveData_Except_Packer:2094, SaveData_Except:2297 / `SCP.SCP0020_SAVE_TACT_TIME`, `SCP.SCP0020_SAVE_TACT_TIME_OSP`, `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT`, `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` |
| TC-SCP0020-048 | 저장 | `Plant` 행 삭제 상태(삭제 방식 **확인 필요**) | 저장 | 예외 데이터가 있는 모델 행 | SCP_MST_TACT_TIME과 SCP_MST_TACT_TIME_EXCEPT의 DELETE·_H 이력이 AS-IS와 같다(**확인 필요**) | `SCP.SCP0020_SAVE_TACT_TIME`, SP `SCP0020_SAVE_TACT_TIME`(DELETE:SCP_MST_TACT_TIME, DELETE:SCP_MST_TACT_TIME_EXCEPT) / 시트 `Plant` |
| TC-SCP0020-049 | 권한 | 조회 전용 그룹 사용자(TB_FX_GroupMenuAuth) | 화면 열기 | - | 권한에 맞게 Save/Insert/Edit 버튼이 노출·제한된다(C/R/U/D 값 **확인 필요**) | TB_FX_GroupMenuAuth 13행 / `SCP.SCP0020_SAVE_TACT_TIME` |
| TC-SCP0020-050 | 권한 | spdMain 시트 잠금 상태(IsLock=true) | LINE_ID 셀 클릭, 붙여넣기, InsertButton 실행 | - | LINE_ID 콤보가 적용되지 않는다 | `SpdMain_CellClick`:2583, `SpdMain_ClipboardPasted`:2773, InsertButton:864 / 시트 `Plant`, `Packer` |
| TC-SCP0020-051 | division | division 14종 각각 로그인(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) | 각 division에서 조회 후 헤더 수 확인 | - | 모든 division에서 `Packer` 14, `Plant` 23, `Tact Time Except` 16으로 같다(division 변형 없음) | Fact Pack §12 / 시트 `Packer`, `Plant`, `Tact Time Except` / `SCP.SCP0020_GET_TACT_TIME`, `SCP.SCP0020_GET_TACT_TIME_OSP` |
| TC-SCP0020-052 | division | `Plant` 활성, 서로 다른 division 데이터 | 각 division 행의 LINE_ID 셀 클릭 | Division A 행 / Division B 행 | 콤보 목록이 해당 행의 DIVISION_ID·FACTORY_ID로 필터된 Line만 보여 준다 | `SpdMain_CellClick`:2583(DBUtils.Filter DIVISION_ID/FACTORY_ID) / `biz:CommonData.CommonDataList` [code=LineByOperation] / 시트 `Plant` |

### 커버리지 점검

| 대상 | 항목 | 커버 TC |
|---|---|---|
| 엔드포인트 | `biz:CommonData.YesOrNo` | 001, 005, 014 |
| | `biz:CommonData.CommonDataList` | 002(LookupCommon), 003·006·052(LineByOperation) |
| | `SCP.SCP0020_GET_TACT_TIME_OSP` | 007, 009, 010, 015, 037, 044, 051 |
| | `SCP.SCP0020_GET_TACT_TIME` | 006, 008, 010~014, 036, 043, 051 |
| | `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` | 019, 021, 039, 045 |
| | `SCP.SCP0020_GET_TACT_TIME_EXCEPT` | 020, 021, 038, 046 |
| | `SCP.SCP0020_SAVE_TACT_TIME_OSP` | 044, 047 |
| | `SCP.SCP0020_SAVE_TACT_TIME` | 043, 047, 048, 049 |
| | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` | 045, 047 |
| | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT` | 046, 047 |
| 이벤트 핸들러(17) | `btnItemId_Click` 016 · `SpdMain_EditModeOff` 029 · `SpdMain_EditChange` 030 · `spdExcept_EditModeOff` 031 · `spdExcept_EditChange` 032 · `Form_Load` 001~003 · `ClbDivision_SelectedIndexChanged` 017 · `ClbPlantSite_SelectedIndexChanged` 018 · `SpdMain_CellDoubleClick` 019~021 · `SpdMain_TopChange` 027 · `SpdMain_CellClick` 022·023·050·052 · `SpdExcept_TopChange` 028 · `SpdMain_Changed` 033 · `SpdMain_Changed_Packer` 034 · `SpdMain_ClipboardPasted` 024·050 · `SpdMain_ActiveSheetChanged` 025·026 · `SpdExcept_Changed` 035 | 전부 커버 |
| 시트(4) | `Packer` 037 · `Plant` 036 · `Tact Time` 040 · `Tact Time Except` 038·039 | 전부 커버 |
| 빈 결과 / 오류 | 008, 009, 021 / 010, 047 | 포함 |
