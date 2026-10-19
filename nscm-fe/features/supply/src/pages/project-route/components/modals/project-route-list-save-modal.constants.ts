// Input All 팝업(AS-IS SCM0002_ProjectRouteListSavePopup) — 상수/컬럼 정의.
//   AS-IS 원본: GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_ProjectRouteListSavePopup.cs(1413줄, 전체 정독)
//   + .Designer.cs(레이아웃).
//   admin 등록 상태(2026-09-22 ora.py 재실측 — 이전 세션 주석의 "미등록" 서술은 stale 이었음):
//   `SCM_ADM_MNU_M`(MNU_ID='SCM0002_PROJECT_ROUTE_LIST_SAVE', MNU_TP_CD='POPUP', USE_YN='Y')
//   + `SCM_ADM_MNU_BTN_MPG_M`(SHT_NM='mainList'/MNU_BTN_CD='SEARCH'→API_ID='SCM0002_PRJ_ROUTE_LIST_GET')
//   + `SCM_ADM_USER_GR_MNU_BTN_MPG_M`(ADMIN/SCP Planner, USE_YN='Y')
//   + `SCM_ADM_API_M`(API_URL='PKG_SCM0002.P_SCM0002_GET_PROJECT_ROUTE_LIST_FORSAVE_POPUP', USE_YN='Y')
//   + `SCM_ADM_PROC_M`(8 IN/OUT 파라미터, PKG_SCM0002 2026-09-17 Oracle 변환 배포분) 전부 등록·USE_YN=Y
//   확인됨. 실제 HTTP 왕복(로컬 BE, `minyonglee1`/division 40)으로 `o_rc1` 4행 정상 수신까지
//   실증했다(코드 존재 여부만이 아니라 런타임 성공까지 확인) — Find 는 정상 동작한다.
//   Save 는 SCP0006 본 화면과 동일 SP(`submitPlantSaveRequest`, MENU_ID='SCP0006')를 그대로
//   재사용하므로(AS-IS 도 동일 SP 공유, Roslyn 실측) 별도 등록이 필요 없다 — SCP0006 본 화면
//   저장 경로가 이미 runtime-parity-gate 로 검증됐다(design/05_runtime-parity.md).
//   staticColumns 는 admin 컬럼메타 fetch 대신 이 파일에 직접 정의한다(ItemByDivisionModal 의
//   ItemModalColumnSpec 객체-리터럴 escape hatch와 같은 성격 — SP 응답이 procedures.d.ts 계약
//   대상이 아니라 WijmoRowItem 느슨한 딕셔너리이기 때문, admin 컬럼메타 대상 밖).

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import type { PlantValidationMsgIds } from '../../hooks/useProjectRouteValidation';
import { COMBO, PLANT_EDITABLE_COLUMNS } from '../../project-route.constants';

// admin 등록 MNU_ID(POPUP 타입, 위 헤더 주석 참고) — AS-IS 소스 컨테이너 클래스명을 그대로 채번.
export const MENU_ID_INPUT_ALL_POPUP = 'SCM0002_PROJECT_ROUTE_LIST_SAVE';
// SP 4번째 IN 파라미터(timeZone) — FE 세션에 아직 timezone 이 없어(TODO, UserManagement.tsx 동일
//   패턴) 다른 화면(PERIOD_DEFAULT 콤보 등)과 동일하게 고정값을 명시 전달한다.
export const DEFAULT_TIME_ZONE = 'AS054';

// i18n 라벨 코드 — 모달/팝업 SearchArea 전용 Search 라벨(메인 상단 SearchArea LBL00112 와 코드가 다르다).
export const LBL = {
  SEARCH_POPUP: 'LBL00664',
} as const;

export const DefColumns = {
  DIVISION_ID: 'DIVISION_ID',
  SCM_SITE_ID: 'SCM_SITE_ID',
  SCM_SITE_NAME: 'SCM_SITE_NAME',
  PROJECT_CODE: 'PROJECT_CODE',
  MODEL_ID: 'MODEL_ID',
  NICK_NAME: 'NICK_NAME',
  OPERATION_GROUP_ID: 'OPERATION_GROUP_ID',
  OPERATION_GROUP: 'OPERATION_GROUP',
  ITEM_ID: 'ITEM_ID',
  ITEM_NAME: 'ITEM_NAME',
  PLANT_SITE_ID: 'PLANT_SITE_ID',
  VALID_YN: 'VALID_YN',
  PRIORITY: 'PRIORITY',
  FROM_YYYYMMDD: 'FROM_YYYYMMDD',
  TO_YYYYMMDD: 'TO_YYYYMMDD',
  CREATED_BY: 'CREATED_BY',
  CREATION_DATE: 'CREATION_DATE',
  LAST_UPDATED_BY: 'LAST_UPDATED_BY',
  LAST_UPDATE_DATE: 'LAST_UPDATE_DATE',
  ORG_FROM_YYYYMMDD: 'ORG_FROM_YYYYMMDD',
  ORG_TO_YYYYMMDD: 'ORG_TO_YYYYMMDD',
} as const;

// 편집 가능 5컬럼 — AS-IS InitSpread 후 LockColumn(DIVISION_ID~ITEM_NAME, true) +
//   LockColumn(CREATED_BY~LAST_UPDATE_DATE, true) 로 나머지 전부 잠금. SCP0006 본 그리드와 동일 5개.
export const PLANT_LIST_SAVE_EDITABLE_COLUMNS = PLANT_EDITABLE_COLUMNS;

// AS-IS InitSpread(L219-243) 컬럼 순서·라벨·폭 그대로. division==='81' 일 때만 SCM_SITE_NAME/
//   PROJECT_CODE 를 노출(L260-261) — 호출부가 division 값을 받아 visible 을 조정한다(buildColumns).
export const buildProjectRouteListSaveColumns = (divisionId: string): RawFlexGridColumnConfig[] => {
  const isDivision81 = divisionId === '81';
  return [
    // AS-IS 그리드 헤더 캡션 그대로(첨부 스크린샷, 2026-09-22) — "Division" 아니라 "Div".
    { colNm: DefColumns.DIVISION_ID, colLblNm: 'Div', colWth: 60, display: true, visible: true },
    {
      colNm: DefColumns.SCM_SITE_ID,
      colLblNm: 'Sales Site Code',
      colWth: 140,
      display: true,
      visible: false,
    },
    {
      colNm: DefColumns.SCM_SITE_NAME,
      colLblNm: 'Sales Site',
      colWth: 160,
      display: true,
      visible: isDivision81,
    },
    {
      colNm: DefColumns.PROJECT_CODE,
      colLblNm: 'Project',
      colWth: 80,
      display: true,
      visible: isDivision81,
    },
    { colNm: DefColumns.MODEL_ID, colLblNm: 'Model', colWth: 100, display: true, visible: true },
    { colNm: DefColumns.NICK_NAME, colLblNm: 'Nick Name', colWth: 120, display: true, visible: true },
    {
      colNm: DefColumns.OPERATION_GROUP_ID,
      colLblNm: 'OPERATION_GROUP_ID',
      colWth: 60,
      display: true,
      visible: false,
    },
    {
      colNm: DefColumns.OPERATION_GROUP,
      colLblNm: 'Operation Group',
      colWth: 60,
      display: true,
      visible: true,
    },
    { colNm: DefColumns.ITEM_ID, colLblNm: 'Item Code', colWth: 100, display: true, visible: true },
    { colNm: DefColumns.ITEM_NAME, colLblNm: 'Item', colWth: 120, display: true, visible: true },
    {
      colNm: DefColumns.PLANT_SITE_ID,
      colLblNm: 'Plant Site*',
      colWth: 220,
      display: true,
      visible: true,
      // 편집가능 셀 노란 배경(wj-cell-editable, formatEditableColumns) 트리거 — SCP0006 본 그리드
      //   SCM_MST_SHEET_COLUMNS(Plant Assign 시트) INPUT_TP_CD 실측값 그대로(ora.py, 2026-09-22).
      inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
      // 2026-09-22 정정: 본 화면 Plant Assign 그리드(COMBO.PLANT_SITE=`_SCP` 변형, @param3 토큰)를
      //   그대로 재사용하고 있었으나, 이 팝업의 AS-IS 호출은 `Data.Common`(base, 값이 다름·토큰도
      //   @itemId) — COMBO.PLANT_SITE_POPUP 으로 교체(project-route.constants.ts COMBO 주석 참고).
      cellCboDataTp: COMBO.PLANT_SITE_POPUP,
      // 행 파라미터 콤보(PARAM10='D') — 행별 DIVISION_ID/OPERATION_GROUP_ID/ITEM_ID 를 콤보 SQL
      //   바인드(divisionId/operationGroup/itemId, PlantByDivisionOperationItem 등록 SQL 토큰
      //   그대로)로 싣는다(AS-IS SpdMain_CellClick 행별 재구성 재현). admin 메타 없이 DataGrid
      //   useRowParamCombos 를 그대로 쓸 수 있는 client-only 설정(isRowParamCombo 판정 =
      //   attribute10==='D' && attribute2 파싱 성공, packages/foundation utils/columnMapping.ts:161).
      attribute10: 'D',
      attribute2: `${DefColumns.DIVISION_ID}:divisionId,${DefColumns.OPERATION_GROUP_ID}:operationGroup,${DefColumns.ITEM_ID}:itemId`,
    },
    {
      colNm: DefColumns.VALID_YN,
      colLblNm: 'Valid*',
      colWth: 60,
      display: true,
      visible: true,
      horzAlgnCd: 'C',
      inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL, // SCM_MST_SHEET_COLUMNS 실측: VALID_YN 만 'O'
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
      cellCboDataTp: COMBO.VALID_YN,
    },
    {
      colNm: DefColumns.PRIORITY,
      colLblNm: 'Priority*',
      colWth: 60,
      display: true,
      visible: true,
      horzAlgnCd: 'R',
      inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.NUMBER,
    },
    {
      colNm: DefColumns.FROM_YYYYMMDD,
      colLblNm: 'From*', // AS-IS 헤더 캡션 그대로(첨부 스크린샷) — 전부 대문자 아님.
      colWth: 80,
      display: true,
      visible: true,
      horzAlgnCd: 'C',
      inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.DATE_TEXT,
    },
    {
      colNm: DefColumns.TO_YYYYMMDD,
      colLblNm: 'To*', // AS-IS 헤더 캡션 그대로(첨부 스크린샷) — 전부 대문자 아님.
      colWth: 80,
      display: true,
      visible: true,
      horzAlgnCd: 'C',
      inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.DATE_TEXT,
    },
    { colNm: DefColumns.CREATED_BY, colLblNm: 'Created By', colWth: 80, display: true, visible: true },
    {
      colNm: DefColumns.CREATION_DATE,
      colLblNm: 'Creation Date',
      colWth: 170,
      display: true,
      visible: true,
    },
    {
      colNm: DefColumns.LAST_UPDATED_BY,
      colLblNm: 'Last Updated By',
      colWth: 80,
      display: true,
      visible: true,
    },
    {
      colNm: DefColumns.LAST_UPDATE_DATE,
      colLblNm: 'Last Update Date',
      colWth: 170,
      display: true,
      visible: true,
    },
    // 내부 파생값(R-ORG 파생, N1~N9 검증 전용) — 화면 비노출.
    {
      colNm: DefColumns.ORG_FROM_YYYYMMDD,
      colLblNm: 'ORG_FROM_YYYYMMDD',
      colWth: 80,
      display: false,
      visible: false,
    },
    {
      colNm: DefColumns.ORG_TO_YYYYMMDD,
      colLblNm: 'ORG_TO_YYYYMMDD',
      colWth: 80,
      display: false,
      visible: false,
    },
  ];
};

// AS-IS L392-401 — checkValidN0(외주 packer, MSG00226)는 SaveData()에서 주석 처리돼 호출되지
//   않는다(호출부 `//if (!checkValidN0()) return;`). SCP0006 본 화면의 N0 dead 상태(04_impl-gap-audit
//   M2)와 동일 패턴 — 이 팝업도 N0 는 재현하지 않는다(정직 고지, 임의 활성화 금지).
//
// N1~N9 는 SCP0006 본 그리드(useProjectRouteValidation)와 규칙이 동일하나 AS-IS 문구가 다르다 —
//   팝업은 각 메시지 뒤에 "리스트 확인 후 입력하십시오"가 붙는 별도 문구다(AS-IS 소스 L883~1398).
//   TO-BE SCM_ADM_MSG_M 실측(2026-09-28, 클라우드 동기화분)으로 그 접미 문구를 가진 등록 코드
//   (MSG01223~01228/01231)에 매핑한다. N7(양의 정수)·N8(날짜순서)는 AS-IS 도 접미가 없어 본화면과
//   동일 코드(MSG01134/01135)를 공유하고, N8-날짜범위(MSG01080)·N8-format(MSG00611)도 공유한다.
export const PROJECT_ROUTE_LIST_SAVE_MSG_IDS: PlantValidationMsgIds = {
  n1EndOverlap: 'MSG01223', // 중첩되는 종료일자가 있습니다.\n리스트 확인 후 입력하십시오.(AS-IS MSG00212)
  n2StartOverlap: 'MSG01224', // 중첩되는 시작일자가 있습니다.\n리스트 확인 후 입력하십시오.(AS-IS MSG00213)
  n3PlantDup: 'MSG01225', // 동일 기간에 Plant Site가 중복되었습니다.\n리스트 확인 후...(AS-IS MSG00214)
  n4PriorityDup: 'MSG01226', // 동일 기간에 Priority가 중복되었습니다.\n리스트 확인 후...(AS-IS MSG00215)
  n5PeriodOverlap: 'MSG01227', // 중첩된 기간이 있습니다.\n리스트 확인 후 입력하십시오.(AS-IS MSG00216)
  n6PeriodContinuity: 'MSG01228', // 기간은 연속적으로 입력하여야 합니다.\n리스트 확인 후...(AS-IS MSG00217)
  n7PriorityPositive: 'MSG01134', // Priority는 양의 정수입니다.(AS-IS 팝업 N7 무접미, SCP0006 과 공유)
  n8DateOrder: 'MSG01135', // 시작일자가 종료일자보다 늦을 수 없습니다.(AS-IS 팝업 N8 무접미, SCP0006 과 공유)
  n8DateRange: 'MSG01080', // 처리가능한 날짜 범위가 아닙니다. {0}(SCP0006 과 공유)
  n8DateFormat: 'MSG00611', // SCP0006 과 공유(범용 "유효한 날짜 형식이 아닙니다" 메시지, 신규 채번 없음)
  n9PriorityOne: 'MSG01231', // 해당 기간에 Priority 1이 없습니다.\n리스트 확인 후...(AS-IS MSG00220)
};

// Save 흐름 전용 메시지(N1~N9 밖) — AS-IS SaveData()/chk_ValidDataSet() 실측.
export const MSG_NO_ROWS = 'MSG01091'; // 조회 후 추가하십시오.(AS-IS MSG00059 → TO-BE MSG01091, 그리드 0건)
// 체크된 행 0건 — TO-BE MSG01054('체크된 행이 없습니다.')로 매핑(2026-09-28 DB 실측). AS-IS 는
//   MSG00071='선택된 행이 없습니다'(TO-BE MSG01104)였으나 이 팝업은 체크박스 선택이라 기존 FE 가
//   '체크된 행이 없습니다'로 재문구화한 의도를 유지 — 동일 문구 등록 코드 MSG01054 사용(신규채번 불요).
export const MSG_NO_CHECKED_ROWS = 'MSG01054'; // 체크된 행이 없습니다.
// 2026-09-22 정정(사용자 리포트 — Save 클릭 시 "최대 10개의 탭만 허용됩니다" 오표시):
//   AS-IS 는 MessageHelper.GMessageBox("MSG00002"/"MSG00012") 로 AS-IS 자체 MSG_M 코드를 그대로
//   썼으나, TO-BE SCM_ADM_MSG_M(KO.json) 에서 그 두 번호는 이미 다른 화면 문구로 등록돼 있었다
//   (MSG00002="성공적으로 저장되었습니다."=project-route.constants.ts MSG.SAVE_RESULT 가 정본 사용 중,
//   MSG00012="최대 10개의 탭만 허용됩니다."=SidebarMenu.tsx 탭 상한). AS-IS 번호를 그대로 옮기면
//   등록된 다른 화면 문구가 그대로 새어 나온다(convert-core "AS-IS MSG 번호 ≠ TO-BE 번호" 원칙,
//   feedback_new-alert-msg-code-reuse-collision). KO.json 실측으로 같은 의미의 기존 등록 코드로 교체
//   (forecast-price.constants.ts REQUIRED='MSG00429'/SAVE_CONFIRM='MSG00001' 선례와 동일 대응).
export const MSG_REQUIRED_FIELD = 'MSG00429'; // '{0} 값은 필수 입력 항목입니다.' (행 필수값 누락, arg=필드명)
export const MSG_CONFIRM_SAVE = 'MSG00001'; // '저장 하시겠습니까?' (저장 확인 Yes/No)

// chk_ValidDataSet(L687-721) — 체크된 행의 필수값 검증 대상 + MSG_REQUIRED_FIELD 인자로 쓸 필드명.
export const REQUIRED_FIELD_CHECKS: { column: string; label: string }[] = [
  { column: DefColumns.PLANT_SITE_ID, label: 'Plant Site' },
  { column: DefColumns.VALID_YN, label: 'Valid' },
  { column: DefColumns.PRIORITY, label: 'Priority' },
  { column: DefColumns.FROM_YYYYMMDD, label: 'FROM' },
  { column: DefColumns.TO_YYYYMMDD, label: 'To' },
];
