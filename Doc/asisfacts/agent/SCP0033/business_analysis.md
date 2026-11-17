# SCP0033 Shipment Semi Dept Day — 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SCP0033)과 1차 분석서(analysis.md, web_components.md, tobe_design.md)
> Fact Pack에 없는 내용은 모두 **확인 필요**로 적었습니다. SP 본문, 핸들러 본문, 메타 행 내용은 이 문서의 근거에 들어 있지 않습니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID | SCP0033 | Fact Pack §1 |
| 클래스 / Form Text | `SCP0033_Shipment_semi_dept_day` | Designer.cs:310 |
| 도메인 | SCP (`06.UIL\GSCM.SCP.Forms.UIL\Master\`) | 파일 경로 |
| 관리 대상 | `SCP_MST_SHIPMENT_SEMI_DEPT_DAY` 테이블 데이터를 조회하고 저장(UPDATE/INSERT)함 | endpoints.csv objects |
| 업무 목적(업무 언어 기준) | **확인 필요.** 메뉴명과 업무 설명이 TB_FX_MenuItemInfo·TB_FX_ProgramInfo 행에 있지만, Fact Pack에는 그 내용이 없음 |  |
| 범위 | 조회(Find), 저장(Save, 저장 후 재조회), 행 추가(Insert, DIVISION_ID 콤보 설정), 편집(Edit, 시트 정보 확인) | flow.csv, grid_code.csv |
| 범위 외 / 미확인 | 삭제(Delete) 기능이 있는지는 **확인 필요**. 흐름에는 Find·Save만 있고 grid_code에는 Insert·Edit만 있음 |  |

- 그리드 컬럼 이름 `DEPARTURE_DAY`(라벨 `Departure day`)와 `OPERATION_GROUP` 등을 보면 Model(ITEM_ID)별 출발 요일을 관리하는 마스터로 볼 수 있습니다. 다만 업무 정의는 **확인 필요**입니다(컬럼명에서 해석한 것이고 문서로 확인한 사실은 아님).

## 2. 사용자 시나리오

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---|---|---|---|
| S1 | 화면을 엶 | `Form_Load` 실행(.ctor:83 배선). `CreateSpread`에서 `AddSheet`(147) → `GetSheetInfo`(148) → `ChangeSheet`(149)로 시트 `Shipment Semi Dept Day`를 만들고, `InitSpread`에서 `InitSheet`(156) → `SetSheetHeaderColumn`(161)으로 SCM_MST_SHEET_COLUMNS 메타를 읽어 컬럼을 구성함. Form_Load 본문은 **확인 필요** | 조회조건(Model / Valid / Division)과 빈 그리드가 표시됨 |
| S2 | 조회조건 입력(Model, Valid, Division) 후 조회 | FindButton → FindData_Main(258) → `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` → SP `SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`. FindData_Main 241·242·244줄에서 `GetCheckedListValue`(CODE)를 호출함 | 그리드에 조회 결과가 표시됨 |
| S3 | 행 추가 | InsertButton(204): 조건을 만족하면 새 행의 `DIVISION_ID` 셀을 Combo로 바꾸고 데이터는 `BLUtils.GetDivision(false, "")`를 씀 | 새 행에서 Division을 콤보로 선택함 |
| S4 | 셀 편집 후 저장 | SaveButton → SaveData_Main(380) → `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` → SP `SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY`, 이어서 FindData_Main → `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`로 재조회 | 테이블 반영 후 그리드가 다시 조회됨 |
| S5 | 그리드 셀 클릭, 키 입력, 스크롤 | `SpdMain_CellClick`(.ctor:84), `SpdMain_KeyPress`(.ctor:85), `SpdMain_TopChange`(InitEvent:107) | 처리 내용은 **확인 필요**(본문 미추출) |
| S6 | 편집 모드 | EditButton(219): `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` | 상세 로직은 **확인 필요** |

## 3. 업무 흐름도 (텍스트)

```
[화면 열기]
  └─ Form_Load
       ├─ CreateSpread : AddSheet → GetSheetInfo → ChangeSheet   (시트: Shipment Semi Dept Day)
       └─ InitSpread   : InitSheet → SetSheetHeaderColumn(메타 SCM_MST_SHEET_COLUMNS)
  (필드 초기화 43·44줄: biz:CommonData.CommonDataList [code=LookupCommon] → dtDepartureDay
                       biz:CommonData.YesOrNo → dtYesOrNo  ※ 진입점 미연결, 바인딩 대상 확인 필요)

[조회]
  조회조건(txtItemId / cboValidYN / clbDivision)
   → FindButton → FindData_Main(GetCheckedListValue ×3)
   → SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY
   → SP SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY
   → 그리드(spdMain / Shipment Semi Dept Day) 바인딩

[행 추가]
  InsertButton → (fps.Name=="spdMain" && siMain!=null && IsLock==false && SheetName=="Shipment Semi Dept Day")
   → DIVISION_ID 셀 Combo(BLUtils.GetDivision(false,""))

[저장]
  SaveButton → SaveData_Main
   → SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY → SP SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY
       (PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST, PR_SCM_SYS_LOG_BATCH 실행)
   → FindData_Main → SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (재조회)
```

## 4. 업무 규칙

| # | 규칙 | 상태 | 근거 |
|---|---|---|---|
| R1 | 저장이 끝나면 같은 조회 경로(FindData_Main)로 재조회함 | 사실 | flow.csv `SaveButton > SaveData_Main > FindData_Main` |
| R2 | 행 추가 시 `DIVISION_ID` 셀 Combo 설정은 4개 조건을 모두 만족할 때만 적용됨: `fps.Name == "spdMain"`, `siMain != null`, `siMain.IsLock(siMain.SheetName) == false`, `siMain.SheetName == "Shipment Semi Dept Day"` | 사실 | grid_code.csv InsertButton:204 conditions |
| R3 | 새 행 Division 콤보의 데이터는 `BLUtils.GetDivision(false, "")`(변수 dtMyDivision)임 | 사실 | grid_code.csv InsertButton:204 |
| R4 | 조회조건 Division은 체크리스트의 CODE 값으로 SP에 넘어감 | 사실(호출만 확인). 241·242·244줄의 대상 컨트롤과 파라미터 매핑은 **확인 필요** | Fact Pack §4-2 GetCheckedListValue |
| R5 | GET SP는 `STRING_SPLIT`, `FN_GET_DIVISION_DIV`를 참조하고 `SCM_MST_DIVISION`, `SCM_MST_ITEM_SN`, `SCP_MST_SHIPMENT_SEMI_DEPT_DAY`를 SELECT함 | 사실(참조 객체만) | endpoints.csv |
| R6 | SP 분기 조건(파라미터별 WHERE, Valid 필터 방식 등) | **확인 필요**(SP 본문 없음) |  |
| R7 | SAVE SP는 `SCP_MST_SHIPMENT_SEMI_DEPT_DAY`를 UPDATE와 INSERT 두 방식으로 처리함. 이력 프로시저 `PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST` 실행, `SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H` INSERT, `PR_SCM_SYS_LOG_BATCH` 실행과 `SCM_SYS_LOG_BATCH` INSERT, 배열 분해 객체 `SCM_ARR_SPL_CNT`·`SCM_ARR_SPL_VAL` 참조 | 사실(참조 객체만). UPDATE와 INSERT를 가르는 기준(키 존재 여부 등)은 **확인 필요** | endpoints.csv |
| R8 | 필수값: 그리드 메타 라벨 `Division*`, `Model*`에 '*'가 붙어 있음 | 라벨 사실. 저장 전 필수 검증 로직이 있는지는 **확인 필요** | grid_effective.csv |
| R9 | 날짜·버킷 규칙 | 해당 사실 없음. `DEPARTURE_DAY` 값 체계(LookupCommon 코드 여부)는 **확인 필요** |  |
| R10 | `S_VALID_YN` 컬럼은 모든 division에서 숨김 | 사실. 용도(저장 전 원본 Valid 값 보관 여부)는 **확인 필요** | grid_effective.csv |

## 5. 데이터 흐름 표

| 엔드포인트 | 호출 위치 | SP | 읽기(SELECT/REF) | 쓰기(INSERT/UPDATE/EXEC) |
|---|---|---|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | `<field:dtDepartureDay>`:43 (진입점 미연결) | - (Biz, 코드분기 UP_FX_GetCommonDataList) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | - |
| `biz:CommonData.YesOrNo` | `<field:dtYesOrNo>`:44 (진입점 미연결) | - (Biz) | **확인 필요** | - |
| `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | FindData_Main:258 (FindButton, SaveButton 재조회) | `SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | SCM_MST_ITEM_SN, SCP_MST_SHIPMENT_SEMI_DEPT_DAY, SCM_MST_DIVISION / REF FN_GET_DIVISION_DIV, STRING_SPLIT | - |
| `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` | SaveData_Main:380 (SaveButton) | `SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` | REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | UPDATE·INSERT SCP_MST_SHIPMENT_SEMI_DEPT_DAY, INSERT SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H, INSERT SCM_SYS_LOG_BATCH, EXEC PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST, EXEC PR_SCM_SYS_LOG_BATCH |

- 주석 처리된 호출(commented_calls): 0건
- 이 엔드포인트 이름은 화면설계서 §5 액션 명세와 단위테스트 근거 열에서도 똑같이 씁니다.

## 6. Division·권한별 변형

| 구분 | 사실 |
|---|---|
| Grid 컬럼 | 40, 81, 81_HD/HG/HM/ST/UC, 82, EE, EE_HD/HG/HM/ST/UC 모두 메타 10/0(필수 10/선택 0)이고 최종 표시는 10컬럼임. **division별 차이 없음** |
| 숨김 | `S_VALID_YN`은 모든 division에서 숨김 |
| 코드 분기 | division 변수 비교 분기 0건(분기 판단불가 0건) |
| 데이터 범위 | GET SP가 `FN_GET_DIVISION_DIV`, `SCM_MST_DIVISION`을 참조함. 사용자 소속 division으로 필터하는 방식은 **확인 필요** |
| 권한 | TB_FX_GroupMenuAuth 11행이 있음. 그룹별 C/R/U/D 값은 **확인 필요** |
| 시트 잠금 | `siMain.IsLock(siMain.SheetName) == false`일 때만 행 추가 시 Division 콤보를 설정함. 잠금을 결정하는 주체(권한 연동 여부)는 **확인 필요** |

## 7. 외부 인터페이스

- Fact Pack에 외부 시스템 인터페이스(I/F) 사실은 없습니다.
- 내부 공통 객체로 `PR_SCM_SYS_LOG_BATCH`/`SCM_SYS_LOG_BATCH`(로그)와 `PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST`(이력)를 씁니다. 외부 I/F는 아닙니다.

## 8. 미확정·확인 필요

1. 업무 명칭, 메뉴 위치, 업무 목적(TB_FX_MenuItemInfo/TB_FX_ProgramInfo 내용)
2. `Form_Load`, `SpdMain_CellClick`, `SpdMain_KeyPress`, `SpdMain_TopChange` 본문
3. `biz:CommonData.CommonDataList`(LookupCommon) 결과 dtDepartureDay와 `biz:CommonData.YesOrNo` 결과 dtYesOrNo의 바인딩 대상(그리드 DEPARTURE_DAY·VALID_YN 콤보, cboValidYN 등), 그리고 Lookup 코드값
4. FindData_Main 241·242·244줄 GetCheckedListValue 3회의 대상 컨트롤과 SP 파라미터 매핑(조회조건 UsrCheckedList는 clbDivision 1개뿐)
5. GET/SAVE SP의 파라미터, 분기 조건, 저장 키, UPDATE·INSERT 판정 기준
6. 삭제 기능이 있는지
7. 권한 11행과 조회조건 메타(TB_FX_SearchCondition 2행)의 내용. 컨트롤 3개와 개수가 다른 원인
8. 실제 SP 실행 결과와 시트를 대조하지 못함(Fact Pack §10: "매칭되는 시트가 없습니다")
