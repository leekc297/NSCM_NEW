# SCP0122 Plan Activity Mgmt — 업무분석서

> 근거는 AsisFacts 정적 추출 Fact Pack(SCP0122)과 1차 분석서(analysis.md / web_components.md / tobe_design.md)뿐입니다. Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> 주석 처리된 호출(commented_calls)은 **0건**입니다. 아래 내용은 모두 활성 호출 기준입니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID | SCP0122 | Fact Pack §1 |
| 화면명(Form Text) | `SCP0122_PlanActivityMgmt` | props.csv Designer.cs:293 |
| 그리드 시트명 | `Plan Activity Mgmt` | grid_code.csv CreateSpread:185 |
| 도메인 | SCP (`06.UIL\GSCM.SCP.Forms.UIL\Master\`) | Fact Pack §1 |
| 업무 목적 | Plan Group별 Activity(`SCP_OPMZ_PLAN_GR_ACTV_M`)를 조회하고 저장(신규·수정·삭제)하는 마스터 관리 화면입니다. 저장 SP가 이 테이블에 INSERT/UPDATE/DELETE 하므로 이렇게 판단했습니다. 업무상 정의(Activity의 의미, 계획 수립에서의 용도)는 **확인 필요** | endpoints.csv |
| 범위 | 조회조건(Division / Plan Group / Process), 메인 그리드 1시트 조회·저장, 저장 이력·로그 적재 | Fact Pack §2·§3 |
| 범위 밖 / 미확정 | 엑셀 업·다운로드, 팝업, 외부 I/F는 Fact Pack에 사실이 없습니다 | — |
| 배포 상태 | 파일 5개 모두 **sln 미등록**이라 운영 빌드에 포함되는지 **확인 필요** | Fact Pack §1 |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 화면 열기 | `Form_Load`가 실행됩니다(.ctor:98 배선). 필드 초기화식 `dtProcessCdAll`(47행)이 `biz:CommonData.CommonDataList` [code=LookupCommon]을 호출합니다. 그리드 시트 `Plan Activity Mgmt`를 생성(CreateSpread:185 AddSheet)·활성화(InitSpread:198 ChangeActiveSheet)합니다 | 조회조건과 빈 그리드가 표시됩니다. Form_Load 본문 순서는 **확인 필요** | events.csv, endpoints.csv, grid_code.csv |
| S2 | (화면 열기 또는 Division 변경 시점 — **확인 필요**) Plan Group 목록 적재 | `GetPlanGroupByUserID`(155)가 `FoxUserInfoContext.Current.NowGroupID`(143)를 사용해 `SCP.SCP0121_GET_SEARCH_INFO` → SP `SCP0121_GET_SEARCH_INFO`를 호출합니다 | Plan Group 콤보 목록. 정적 파서상 진입점 미연결(unreached) | flow.csv, meta_reads.csv |
| S3 | Division 변경 | `ClbDivision_SelectedIndexChanged`(InitEvent:217)가 실행됩니다. `RefreshPlanGroupByDivision`(171)이 `GetCheckedListValue`(CODE)를 호출한다는 사실은 있지만, 이 핸들러가 그 메서드를 부르는지는 **확인 필요** | Plan Group 목록 갱신으로 추정(**확인 필요**) | events.csv, Fact Pack §4-2 |
| S4 | Plan Group 변경 | `CboPlanGroup_SelectedIndexChanged`(InitEvent:218)가 실행됩니다 | 처리 내용 **확인 필요** | events.csv |
| S5 | 조회 버튼 | FindButton → `FindData_Main`. 시트 전환(306 ChangeSheet `Plan Activity Mgmt`) 후 `GetCheckedListValue`(CODE) 3회(308·309·310)로 조건값을 만들고, 321행에서 `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` → SP `SCP0122_GET_PLAN_ACTIVITY_MGMT`를 호출합니다 | 그리드에 Activity 목록이 표시됩니다 | flow.csv, grid_code.csv, Fact Pack §4-2 |
| S6 | 행 추가 | `Insert_Row`(367)가 `GetCheckedListValue`(CODE)를 호출합니다. 어느 버튼에서 진입하는지는 **확인 필요** | 신규 행 추가. 조건값을 기본값으로 채우는지 **확인 필요** | Fact Pack §4-2 |
| S7 | 그리드 셀 콤보 선택 / 셀 클릭 | `SpdMain_ComboSelChange`(InitEvent:220), `spdMain_CellClick`(InitEvent:221) | 처리 내용 **확인 필요** | events.csv |
| S8 | 저장 버튼 | SaveButton → `Save_Data`(480)가 `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` → SP `SCP0122_SAVE_PLAN_ACTIVITY_MGMT`를 호출합니다. 이어서 `FindData_Main`(321)이 `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT`로 재조회합니다 | 변경분이 `SCP_OPMZ_PLAN_GR_ACTV_M`에 반영되고, 이력(`SCP_OPMZ_PLAN_GR_ACTV_H`)과 로그(`SCM_SYS_LOG_BATCH`)가 적재된 뒤 그리드가 재조회됩니다 | flow.csv, endpoints.csv |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 열기]
  ├─ (필드 초기화) dtProcessCdAll ── biz:CommonData.CommonDataList [LookupCommon]
  ├─ Form_Load ── 그리드 시트 'Plan Activity Mgmt' 생성/활성화 (CreateSpread:185 / InitSpread:198)
  └─ (시점 확인 필요) GetPlanGroupByUserID ── SCP.SCP0121_GET_SEARCH_INFO (NowGroupID)
        │
[조회조건 설정]
  ├─ cboDivision 변경 ── ClbDivision_SelectedIndexChanged (→ RefreshPlanGroupByDivision:171 연관 확인 필요)
  ├─ cboPlanGroup 변경 ── CboPlanGroup_SelectedIndexChanged
  └─ cboProcess 선택
        │
[조회] FindButton → FindData_Main
  ├─ ChangeSheet('Plan Activity Mgmt') :306
  ├─ GetCheckedListValue(CODE) ×3 :308~310
  └─ SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT :321 → 그리드 바인딩
        │
[그리드 편집]
  ├─ Insert_Row :367 (진입 버튼 확인 필요)
  ├─ SpdMain_ComboSelChange / spdMain_CellClick
        │
[저장] SaveButton → Save_Data
  ├─ SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT :480
  │     ├─ INSERT/UPDATE/DELETE SCP_OPMZ_PLAN_GR_ACTV_M
  │     ├─ EXEC SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST → INSERT SCP_OPMZ_PLAN_GR_ACTV_H
  │     └─ EXEC PR_SCM_SYS_LOG_BATCH → INSERT SCM_SYS_LOG_BATCH
  └─ FindData_Main → SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT :321 (재조회)
```

## 4. 업무 규칙 (사실 근거만)

| # | 규칙 | 근거 | 비고 |
|---:|---|---|---|
| R1 | 조회 시 조건 3개를 `GetCheckedListValue`(CODE)로 만들어 전달합니다 | FindData_Main:308·309·310 | 대상 컨트롤(Division/Plan Group/Process 추정)과 SP 파라미터명은 **확인 필요** |
| R2 | Plan Group 목록은 로그인 사용자의 `NowGroupID`를 기준으로 조회합니다 | GetPlanGroupByUserID:143 → `SCP0121_GET_SEARCH_INFO` | SP 안의 분기 조건은 **확인 필요** |
| R3 | Process 원천은 공통코드 LookupCommon입니다 (UP_FX_GetCommonDataList: `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL`) | endpoints.csv `<field:dtProcessCdAll>`:47 | LOOKUP 코드값과 cboProcess 바인딩 여부는 **확인 필요** |
| R4 | 그리드 컬럼은 메타(`SCM_MST_SHEET_COLUMNS`)로 생성하며, `sheetName.Equals("Plan Activity Mgmt")`일 때만 메타 빌드를 실행합니다 | SetSpreadInit:205·206·212 | `SetSheetHeaderColumnSCP(siObj, 1, false, "")` — 헤더 1행, chkAll=false |
| R5 | 메타 표시 규칙: VISIBLE_FLAG·VALID_YN='Y', USER_SELECTABLE_FLAG='N'=필수, DEFAULT_FLAG='Y'=기본 | Fact Pack §10 | 15컬럼 모두 '기본'(필수 0) |
| R6 | 저장 후에는 반드시 재조회합니다 | flow.csv SaveButton > Save_Data > FindData_Main | 저장 실패 시에도 재조회하는지는 **확인 필요** |
| R7 | 저장은 한 SP 안에서 INSERT/UPDATE/DELETE를 함께 처리합니다. 행 상태(신규/수정/삭제) 구분 방식은 **확인 필요** | endpoints.csv SAVE objects | 페이로드는 `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL`(문자열 분해 함수) 참조로 보아 구분자 문자열 가능성이 있음 — **확인 필요** |
| R8 | 저장 시 이력(`SCP_OPMZ_PLAN_GR_ACTV_H`, `SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST` 경유)과 실행 로그(`SCM_SYS_LOG_BATCH`, `PR_SCM_SYS_LOG_BATCH` 경유)를 남깁니다 | endpoints.csv | 이력 적재 조건은 **확인 필요** |
| R9 | 필수값 검증 | — | Fact Pack에 사실 없음. **확인 필요** |
| R10 | 날짜·버킷 규칙 | — | Fact Pack에 날짜/버킷 관련 사실 없음. **해당 사실 없음** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | SP | 호출 위치 | 읽기 | 쓰기 | 화면설계서 §5 대응 액션 |
|---|---|---|---|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | (Biz 공통 UP_FX_GetCommonDataList) | `<field:dtProcessCdAll>`:47 | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | — | A01 화면 초기화(필드 초기화) |
| `SCP.SCP0121_GET_SEARCH_INFO` | `SCP0121_GET_SEARCH_INFO` | GetPlanGroupByUserID:155 | SCM_MST_DIVISION, SCM_MST_LINE_SN, SCM_MST_FACTORY_SN, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_LINE_OSP, SCM_MST_SITE, SCM_MST_VENDOR, SCP_MST_CAPA_LINE, SCP_OPMZ_PLAN_GR_M, SCM_ADM_LOOKUP_MASTER, SCM_OPERATION_M_SN | 임시: #DIVISION_INFO, #LINE_MASTER, #OSP_PLANT_INFO (INSERT 후 SELECT) | A02 Plan Group 목록 적재 |
| `SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT` | `SCP0122_GET_PLAN_ACTIVITY_MGMT` | FindData_Main:321 | SCP_OPMZ_PLAN_GR_ACTV_M, SCP_OPMZ_PLAN_GR_M, SCM_ADM_LOOKUP_MASTER_DETAIL | — | A05 조회 / A09 저장 후 재조회 |
| `SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT` | `SCP0122_SAVE_PLAN_ACTIVITY_MGMT` | Save_Data:480 | (REF) SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | SCP_OPMZ_PLAN_GR_ACTV_M (INSERT/UPDATE/DELETE), SCP_OPMZ_PLAN_GR_ACTV_H (INSERT), SCM_SYS_LOG_BATCH (INSERT) / EXEC PR_SCM_SYS_LOG_BATCH, SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST | A09 저장 |

> SP 3개(`SCP0121_GET_SEARCH_INFO`, `SCP0122_GET_PLAN_ACTIVITY_MGMT`, `SCP0122_SAVE_PLAN_ACTIVITY_MGMT`)의 입력 파라미터 목록과 결과 컬럼은 Fact Pack에 없어 **확인 필요**입니다. Fact Pack §10에는 SP 실행 결과와 매칭되는 시트가 없다고 기재되어 있습니다.

## 6. division·권한별 변형

| 구분 | 사실 | 근거 |
|---|---|---|
| Grid division 차이 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 `Plan Activity Mgmt` 15컬럼 '기본'. **차이 없음** | Fact Pack §10·§12, grid_effective.csv |
| 코드 division 분기 | 코드 안의 division 변수 비교 분기 0건(판단불가 0건) | Fact Pack §12 |
| SP 안의 division 분기 | Fact Pack에 사실 없음. **확인 필요** | — |
| 사용자 그룹 | Plan Group 목록이 `NowGroupID`에 따라 달라질 수 있음 | meta_reads.csv:143 |
| 권한 메타 | TB_FX_GroupMenuAuth 3행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_SearchCondition 3행이 존재합니다. 행 내용(그룹·버튼 권한값)은 **확인 필요** | Fact Pack §8 |
| C/R/U/D | R: FindButton / C: Insert_Row + SAVE INSERT / U: SaveButton + SAVE UPDATE, EditButton(275) 메서드 존재 / D: SAVE DELETE — 삭제 버튼 진입점 **확인 필요** | flow.csv, endpoints.csv, grid_code.csv |

## 7. 외부 인터페이스

Fact Pack에 외부 시스템 I/F 사실은 없습니다. `SCM_SYS_LOG_BATCH`는 내부 실행 로그 적재로 보이며, 외부 연계인지는 **확인 필요**입니다.

## 8. 미확정·확인 필요

1. `GetPlanGroupByUserID`(`SCP.SCP0121_GET_SEARCH_INFO`)를 실제로 부르는 시점(Form_Load / Division 변경)
2. `dtProcessCdAll`(`biz:CommonData.CommonDataList` LookupCommon)의 LOOKUP 코드값과 cboProcess 바인딩 여부
3. 5개 이벤트 핸들러(`Form_Load`, `ClbDivision_SelectedIndexChanged`, `CboPlanGroup_SelectedIndexChanged`, `SpdMain_ComboSelChange`, `spdMain_CellClick`)의 본문 동작
4. `SpdMain_ClipboardPasted`(574, dtPlanGroup NAME→CODE 변환)의 이벤트 배선 여부 — events.csv에 배선 기록 없음
5. `Insert_Row`(367)와 삭제 기능의 버튼 진입점
6. FindData_Main 308~310 `GetCheckedListValue` 3회의 대상 컨트롤과 SP 파라미터 매핑
7. SP 3종의 파라미터와 결과 컬럼, 결과 컬럼과 메타 15컬럼의 일치 여부
8. 저장 페이로드 형식(SCM_ARR_SPL_CNT/VAL)과 행 상태 구분 방식
9. 필수값·중복 검증과 메시지 코드
10. 권한 메타 4종의 행 내용
11. sln 미등록 프로젝트가 운영 배포 대상인지
