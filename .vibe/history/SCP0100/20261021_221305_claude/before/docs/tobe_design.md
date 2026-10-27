# SCP0100 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 조건 | AS-IS 컨트롤 | 값 수집 | 초기값·목록 원천 | 비고 |
|---|---|---|---|---|
| Plan Date | cboPlanDate | 확인 필요 | SCP0100_GET_PLAN_DATE (Form_Load > InitControls) | 변경 시 헤더 재구성과 기간 재계산 |
| 기간 | dCalendar (DateRangePicker) | getPlanStartYYYYMMDD:215 관련(확인 필요) | SetCalendar > GetDayRange > GetPlanEndDate (CommonDataList_REPORT PLAN_END_DATE) | 변경 시 헤더 재구성 |
| Division | clbDivision (멀티) | getDivision:466 | 확인 필요 | — |
| From Site | clbFromSite (멀티) | getFromSite:306 | 확인 필요 | — |
| To Site | clbToSite (멀티) | getToSite:325 | SCP0100_GET_SITE (Shown > InitControlsAfter > RefreshToSite) | — |
| Plan-type | cboPlanType | getPlanType:344 | 확인 필요 | LayoutItem Enabled=false |
| Search Level | cboSearchLevel / rgrpSearchLevel | getSearchLevel:412 | 확인 필요 | PRODUCT_LEVEL 표시 제어, 시트 전환 |
| Bucket | cboBucketType | — | 확인 필요 | MONTHLY / WEEKLY |
| Model / Nick Name | txtItemId + btnItemId | — | 팝업(확인 필요) | — |
| Project | txtProject + btnProject | — | 팝업(확인 필요) | — |
| Cell Group | txtCellGroup | — | — | — |
| Unit Qty | cboUnitQty | — | 확인 필요 | — |
| Display / Graph | cboDisplay / cboGraphType | — | 확인 필요 | 화면 표시 전용 |
| Cell Qty / A/S | chkCellQty / chkAS | — | — | 둘 다 Visible=false (숨김 컨트롤) |

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 핸들러 | 호출 API 후보 |
|---|---|---|
| 화면 진입 | `Form_Load` | `SCP0100_GET_SHEET_CALENDAR_3SPAN`(헤더) / `SCP0100_GET_PLAN_DATE`(Plan Date) / CommonDataList_REPORT PLAN_END_DATE |
| 화면 표시 후 | `SCP0100_Global_PSI_Report_Shown` | `SCP0100_GET_SITE`(To Site) |
| Plan Date 변경 | `CboPlanDate_SelectedIndexChanged` | SCP0100_GET_SHEET_CALENDAR_3SPAN, CommonDataList_REPORT PLAN_END_DATE |
| 기간 변경 | `DCalendar_ValueChanged` | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| Search Level 라디오 변경 | `rgrpSearchLevel_SelectedIndexChanged` | SCP0100_GET_SHEET_CALENDAR_3SPAN |
| 메저 버튼 | `btnMeasure_Click` | SCP0100_GET_SHEET_CALENDAR_3SPAN (+ 메저 선택 UI는 확인 필요) |
| 컬럼 버튼 | `BtnColumn_Click` | SCP0100_GET_SHEET_CALENDAR_3SPAN (+ 컬럼 선택 UI는 확인 필요) |
| Bucket 변경 | `CboBucketType_SelectedIndexChanged` | API 없음. FE 컬럼 표시 전환(M_/W_) |
| Display 변경 | `CboDisplay_SelectedIndexChanged` | API 없음. 분할 위치 0/750/270 |
| Search Level 콤보 변경 | `CboSearchLevel_SelectedIndexChanged` | 확인 필요 (SetLayout은 PRODUCT_LEVEL1~3 표시) |
| Division / Graph / Unit Qty / Plan-type 변경 | `ClbDivision_SelectedIndexChanged`, `CboGraphType_SelectedIndexChanged`, `CboUnitQty_SelectedIndexChanged`, `CboPlanType_SelectedIndexChanged` | 확인 필요 |
| Model / Project 팝업 | `BtnItemId_Click`, `BtnProject_Click` | 팝업 화면은 확인 필요 |
| Cell Qty / A/S 체크 | `ChkCellQty_CheckedChanged`, `ChkAS_CheckedChanged` | 확인 필요 (컨트롤 숨김) |
| **조회(본문·차트 데이터)** | 확인 필요 | **미식별 — 최우선 확인 대상** |

## 3. division별 Grid 변형 요약

- REPORT는 11 (?3), SEARCH_LEVEL은 5 (?3), SEARCH_LEVEL_DETAIL은 5 (?3)입니다. 14개 division 모두 같습니다.
- 메타와 코드 모두 division 분기가 없습니다. TO-BE에서도 division별 컬럼 분기가 필요 없습니다(추출 기준).
- 실제로 바뀌는 축은 division이 아니라 다음 셋입니다.
  1. Bucket(MONTHLY/WEEKLY)
  2. Search Level(PRODUCT_LEVEL1~3)
  3. 시트 전환(_is_detail)

## 4. 권한(C/R/U/D) 관련 사실

| 항목 | 사실 |
|---|---|
| TB_FX_GroupMenuAuth | SCP0100 행 4건이 있습니다. 그룹별 C/R/U/D 값은 dbmeta CSV를 확인해야 합니다. |
| TB_FX_MenuItemInfo / TB_FX_ProgramInfo | 각 1건 |
| TB_FX_Favorite | 2건 |
| TB_FX_SearchCondition | 23건 (저장된 조회조건) |
| SCM_MST_TITLESET_USER | 526건 (사용자 타이틀셋) |
| 세션 | BaseForm.OnShown:522가 NowGroupID와 USER_ID를 사용합니다 |
| 저장/삭제 | 저장·삭제 엔드포인트가 추출되지 않았습니다. 조회 전용(R) 화면으로 보이지만 **확인 필요**입니다. |

## 5. 미확정 사항

1. 메인 데이터 조회 SP와 차트 데이터 원천
2. PLAN_END_DATE 공통코드 조회 테이블
3. 이벤트 핸들러 11종의 내부 로직
   - 엔드포인트 경로가 없는 핸들러는 13종입니다. 이 중 CboBucketType과 CboDisplay는 §2에 동작이 일부 확인되어 제외했습니다.
4. `_is_detail` 결정 조건과 VisibleSheet 전환 규칙
5. CboDisplay 값과 SplitterDistance(0/750/270)의 대응, splitContainer1 Orientation과 Size
6. SetSpreadColumn이 고정 메타 컬럼까지 숨기는지 여부(루프 시작 인덱스)
7. SetLayout 마지막 case 값
8. Model / Project 팝업 화면 ID
9. 라벨 미확인 LayoutItem: layPeriod, layMeasure, layoutBtnColumn, layUnit_qty, lciSearchLevel, layoutControlItem3, layAS, layCategoryCC, layoutControlItem4, layoutPlanDate
10. 숨김 컨트롤(chkCellQty, chkAS)과 parent 없는 usrButton1을 이관할지 여부
11. SCM_MST_SHEET_MEASURE `Global PSI New` 35행의 메저 정의와 TO-BE 메타 이관
