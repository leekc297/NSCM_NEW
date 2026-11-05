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
