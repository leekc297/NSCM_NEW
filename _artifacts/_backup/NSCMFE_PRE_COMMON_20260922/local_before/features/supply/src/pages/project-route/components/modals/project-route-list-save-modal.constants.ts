// Input All 팝업(AS-IS SCM0002_ProjectRouteListSavePopup) — 상수/컬럼 정의.
//   AS-IS 원본: GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_ProjectRouteListSavePopup.cs(1413줄, 전체 정독)
//   + .Designer.cs(레이아웃). 이 화면은 NSCM admin 에 아직 메뉴가 전혀 등록되지 않아 실행 시
//   403(Forbidden) — BE `CustomAuthorizationManager._authorize` → `AuthService.checkMenuBtnAuth`
//   → `PKG_NSCM_UI_COM_AUTH.PR_CHECK_MNU_BTN_AUTH` 가 (MNU_ID,SHT_NM,MNU_BTN_CD) 미등록이면
//   fail-closed 로 거부(실측 확인, nscm-be GeneralController/CustomAuthorizationManager/Auth.xml).
//   등록 필요(순서대로, admin 승인 필요 — AI 임의 INSERT 금지): ① SCM_ADM_MNU_M(메뉴 자체)
//   ② SCM_ADM_USER_GR_MNU_MPG_M(그룹→메뉴 권한) ③ SCM_ADM_MNU_BTN_MPG_M(MNU_ID/SHT_NM='mainList'/
//   MNU_BTN_CD='SEARCH'→API_ID) ④ SCM_ADM_USER_GR_MNU_BTN_MPG_M(그룹→버튼 권한, 403 의 직접 원인).
//   이후에도 SCM_ADM_API_M/SCM_ADM_PROC_M 미등록이면 SCP0006 RT-1과 같은 방식으로 별도 실패한다.
//   (ItemByDivisionModal=COM0008/MaterialByDivisionModal=COM0013 선례처럼 admin 개별 채번 필요.)
//   staticColumns 는 admin 컬럼메타 fetch 대신 이 파일에 직접 정의한다(ItemByDivisionModal 의
//   ItemModalColumnSpec 객체-리터럴 escape hatch와 같은 성격).

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import type { PlantValidationMsgIds } from '../../hooks/useProjectRouteValidation';
import { COMBO, PLANT_EDITABLE_COLUMNS } from '../../project-route.constants';

// TODO(admin 등록 대기): 이 팝업 전용 TO-BE 메뉴ID 미채번(정직 고지, design gap 신규 발견).
//   등록 전까지는 GET/SAVE 실조회가 불가능하다 — UI/그리드/검증 로직은 이 회차에서 완성해 둔다.
export const MENU_ID_PENDING = 'SCM0002_PROJECT_ROUTE_LIST_SAVE';

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
    { colNm: DefColumns.DIVISION_ID, colLblNm: 'Division', colWth: 60, display: true, visible: true },
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
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
      cellCboDataTp: COMBO.PLANT_SITE,
      // 행 파라미터 콤보(PARAM10='D') — 행별 DIVISION_ID/OPERATION_GROUP_ID/ITEM_ID 를 콤보 SQL
      //   바인드(divisionId/operationGroup/param3)로 싣는다(AS-IS SpdMain_CellClick 행별 재구성 재현).
      //   admin 메타 없이 DataGrid useRowParamCombos 를 그대로 쓸 수 있는 client-only 설정
      //   (isRowParamCombo 판정 = attribute10==='D' && attribute2 파싱 성공, packages/foundation
      //   utils/columnMapping.ts:161 참조).
      attribute10: 'D',
      attribute2: `${DefColumns.DIVISION_ID}:divisionId,${DefColumns.OPERATION_GROUP_ID}:operationGroup,${DefColumns.ITEM_ID}:param3`,
    },
    {
      colNm: DefColumns.VALID_YN,
      colLblNm: 'Valid*',
      colWth: 60,
      display: true,
      visible: true,
      horzAlgnCd: 'C',
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
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.NUMBER,
    },
    {
      colNm: DefColumns.FROM_YYYYMMDD,
      colLblNm: 'FROM*',
      colWth: 80,
      display: true,
      visible: true,
      horzAlgnCd: 'C',
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.DATE_TEXT,
    },
    {
      colNm: DefColumns.TO_YYYYMMDD,
      colLblNm: 'TO*',
      colWth: 80,
      display: true,
      visible: true,
      horzAlgnCd: 'C',
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
// N1~N9 는 SCP0006 본 그리드(useProjectRouteValidation)와 규칙이 동일하나 메시지ID 세트가 다르다
//   (AS-IS 소스 L883~1398 실측 — 팝업 전용 채번, N7/N8-날짜범위만 SCP0006 과 공유).
export const PROJECT_ROUTE_LIST_SAVE_MSG_IDS: PlantValidationMsgIds = {
  n1EndOverlap: 'MSG00212',
  n2StartOverlap: 'MSG00213',
  n3PlantDup: 'MSG00214',
  n4PriorityDup: 'MSG00215',
  n5PeriodOverlap: 'MSG00216',
  n6PeriodContinuity: 'MSG00217',
  n7PriorityPositive: 'MSG00107', // SCP0006 과 공유
  n8DateOrder: 'MSG00219',
  n8DateRange: 'MSG00048', // SCP0006 과 공유
  n9PriorityOne: 'MSG00220',
};

// Save 흐름 전용 메시지(N1~N9 밖) — AS-IS SaveData()/chk_ValidDataSet() 실측.
export const MSG_NO_ROWS = 'MSG00059'; // 그리드 0건
export const MSG_NO_CHECKED_ROWS = 'MSG00071'; // 체크된 행 0건
export const MSG_REQUIRED_FIELD = 'MSG00002'; // 행 필수값 누락(arg=필드명)
export const MSG_CONFIRM_SAVE = 'MSG00012'; // 저장 확인(Yes/No)

// chk_ValidDataSet(L687-721) — 체크된 행의 필수값 검증 대상 + MSG00002 인자로 쓸 필드명(AS-IS 그대로).
export const REQUIRED_FIELD_CHECKS: { column: string; label: string }[] = [
  { column: DefColumns.PLANT_SITE_ID, label: 'Plant Site' },
  { column: DefColumns.VALID_YN, label: 'Valid' },
  { column: DefColumns.PRIORITY, label: 'Priority' },
  { column: DefColumns.FROM_YYYYMMDD, label: 'FROM' },
  { column: DefColumns.TO_YYYYMMDD, label: 'To' },
];
