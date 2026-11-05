// CAPA New Model 팝업(AS-IS SCP0049_CAPANewModelPopup, GSCM.SCP.Master.UIL/POPUP) — 상수/컬럼 정의.
//   AS-IS 원본(1559줄, 전체 정독): GSCM/06.UIL/GSCM.SCP.Master.UIL/POPUP/SCP0049_CAPANewModelPopup.cs
//   + .Designer.cs. SCP0049_CAPA(본가 화면)·SCP0201_CAPA·SCP0006_ProjectRoute 3개 AS-IS 화면이
//   공유하는 팝업이라(전역 grep 확인) features/master/src/components(공용) 아래 둔다 — 단일 화면
//   전용이 아니다.
//
// 진행 상태(2026-09-22): AS-IS MSSQL SP 6개 실측(.atlas/gscm-design/SCP0049/
//   asis-sp-inventory-capa-new-model-popup.md) 후 PKG_SCP0049 가 Oracle 에 배포되었고(VALID,
//   ora.py 재실측 2026-09-22 15:06), 그리드 조회(FindData)·저장(SaveData)·메일요청(RequestData)
//   3개 모두 admin 등록까지 완료돼 있음을 확인(SCM_ADM_API_M/SCM_ADM_MNU_BTN_MPG_M, MNU_ID='SCP0049'
//   재사용 — 별도 팝업 전용 MNU_ID 가 아니라 SCP0049 본 화면 메뉴 아래 SHT_NM 으로 구분).
//   - 조회조건 6단 cascade(Division→Group→Plant→Building→Line→Operation) 콤보는 전부 DB 기실측
//     확인(SCM_ADM_CMBO_SQL_M, ora.py) — CAPA 전용이 아니라 SCP/FP 공용 계층콤보라 다른 화면들이
//     먼저 등록해 둔 것을 그대로 재사용한다.
//   - LANE_QTY 검증도 동일하게 실등록 콤보(LaneQtyOfLineAssign_SCP)로 동작한다.
//   - P_GET_SHEET_CALENDAR_POPUP(동적 월 헤더)은 연결하지 않는다 — capaNewModelPopup.calendar.ts
//     클라 계산이 AS-IS SP1 과 동일 범위(당월~+41개월)를 이미 재현한다.

import { DataType } from '@mescius/wijmo';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type { ComboResponse, FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

// PKG_SCP0049 admin 등록 실측(2026-09-22, ora.py SCM_ADM_API_M/SCM_ADM_MNU_BTN_MPG_M) —
//   newModel(SEARCH/SAVE)·mailSend(SAVE) 모두 MNU_ID='SCP0049' 아래 SHT_NM 으로 등록돼 있다.
export const MNU_ID = 'SCP0049';
export const SHEET_NEW_MODEL = 'newModel';
export const SHEET_MAIL_SEND = 'mailSend';

// 권한판정 원본 2종의 실제 호출 경로(ora.py 실측 + DB 등록 2026-09-29, LoadAuthority cs L309-403).
//   SP #6(내 승인권한 목록)은 DB 팀 회신대로 기등록 SP PKG_SYS0011.P_SYS0011_GET_MY_AUTH_DATA 를
//   재사용 → SYS0011/myAuthorityList(call-proc, {sesUserId} 전달, o_rc 반환). 반환 컬럼은 USER_GR_ID
//   (scm_adm_user_gr_m 에서 USER_GR_ID==USER_GR_NM, 값이 AUTH_GROUP 과 동일)/APPROVAL_RESULT('APPROVED'
//   실재)/DIVISION_ID — FE 가 USER_GR_ID 를 CapaAuthListRow.GROUP_ID 로 매핑한다.
//   SP #5(FP Instance)는 라우터 SP PR_UI_FP01886_AUTHORITY_REQUEST 를 SCP0049/fpInstance 에 call-proc
//   경로로 신규 등록(.atlas/gscm-design/SCP0049/design/06_register_auth_fpinstance.sql, PROC_M 20파라미터).
//   AS-IS 는 p_sys_type='SELECT'/p_sys_flag='SELECT_MAIN'/p_user_id=로그인유저로 호출(cs L360-390) —
//   call-proc 은 세션 미주입이라 FE 가 sesUserId(→P_USER_ID)/altUserId 를 직접 전송. 데이터는 O_RC(=o_rc),
//   컬럼 DIVISION_ID/PLANT_ID/FACTORY_ID/MENU_AUTHORITY_ID/APPROVAL_FLAG 이 CapaFpInstanceRow 와 정확히 일치.
//   (call-proc2 는 CustomAuthorizationManager 화이트리스트 밖이라 403 — 최초 시도 후 call-proc 으로 확정.)
export const MY_AUTH_LIST_ENDPOINT = { mnuId: 'SYS0011', shtNm: 'myAuthorityList' } as const;
export const FP_INSTANCE_ENDPOINT = { mnuId: MNU_ID, shtNm: 'fpInstance' } as const;

// PlannerTypeLogic(cs L936-995)이 비교하는 그룹명. AS-IS는 SCP_CAPA_bool 판정에 'SCP Planner'와
//   'CAPA Planner'를 OR로 동일 취급하나, TO-BE SCM_ADM_USER_GR_M에 'CAPA Planner'가 없어(2026-09-22
//   ora.py 확인) SCP Planner로 흡수됐다고 보고 뺀다(사용자 확정 2026-09-22).
export const AUTH_GROUP = {
  SCP_PLANNER: 'SCP Planner',
  FP_PLANNER: 'FP Planner',
  PI_ADMIN: 'SCM PI Admin',
} as const;

// 조회조건 cascade 콤보(6단, DB 실측 확정 — 전부 이미 등록돼 있음, 2026-09-22 ora.py).
//   AS-IS Data_SCP.Common(...)="_SCP" / Data.Common(...)=무접미(scp-combo-sqlid-suffix-convention
//   메모리 규칙 그대로 적용) — CAPA 전용이 아니라 SCP/FP 공용 계층 콤보.
export const COMBO = {
  // BLUtils.GetDivisionWithoutEE 2단계 구조(SCP0006 COMBO.DIVISION 과 동일 원리) — 토큰 @divisionId.
  DIVISION: 'Division_SCP',
  // Data_SCP.Common(Type.ShopGroupId, division) — 토큰 @divisionId.
  SHOP_GROUP: 'ShopGroupId_SCP',
  // Data_SCP.Common(Type.PlantByGroup, division, groupId) — 토큰 @divisionId/@shopGroupId.
  PLANT_BY_GROUP: 'PlantByGroup_SCP',
  // Data_SCP.Common(Type.BuildingByShopGroupId, division, plantId, groupId) — 토큰
  //   @divisionId/@plantId/@param3(groupId, 위치 토큰 — SQL 내부에서 'F'→'A' 특수 변환).
  BUILDING_BY_SHOP_GROUP: 'BuildingByShopGroupId_SCP',
  // Data_SCP.Common(Type.LineByOperationPlantId, division, plantId, factoryId, groupId) — 토큰
  //   @divisionId/@plantId/@factoryId/@operationGroupId(=groupId).
  LINE_BY_OPERATION_PLANT: 'LineByOperationPlantId_SCP',
  // Data.Common(Type.OperationByLine, division, plantId, factoryId, lineId, groupId) — base(무접미,
  //   Common 이지만 Data_SCP 아닌 Data 클래스 사용, AS-IS 원문 그대로). 토큰
  //   @divisionId/@plantId/@factoryId/@lineId/@operationGroupId(=groupId).
  OPERATION_BY_LINE: 'OperationByLine',
  // Data_SCP.Common(Type.LaneQtyOfLineAssign, false) — 파라미터 없음(전체 로드 후 클라 필터, AS-IS
  //   dtLaneQtyOfLineAssign 과 동일 패턴). SaveData 의 E2000(Dam Mixing) LANE_QTY 존재 검증에 사용.
  LANE_QTY_OF_LINE_ASSIGN: 'LaneQtyOfLineAssign_SCP',
  // Data.Common(Type.LocationGroupByCapa, false, "") — base(무접미, 이미 등록·USE_YN='Y' 확인,
  //   2026-09-22 ora.py). EditButton(cs L333-338) 의 _OperGroupList(CAPA 관리 공정군) 원천.
  OPER_GROUP_BY_CAPA: 'LocationGroupByCapa',
  // 화면 전용 아님 — 로그인 사용자의 전체 그룹 멤버십(TB_FX_GroupInfo/TB_FX_UserGroupInfo, 승인워크플로
  //   무관 raw 멤버십). AS-IS UserInfoContext.Current["NowGroupID"](SCM PI Admin 비교, cs L616)를
  //   session.groupId 로 읽지 않고 이 콤보로 대체한다 — session.groupId "유령 필드" 사고
  //   (sales-plan.auth.ts, 2026-07-15) 와 동일 함정 회피. 이미 등록·USE_YN='Y'(2026-09-22 ora.py).
  MY_GROUPS: 'MyGroupIDALL',
} as const;

// BLUtils.GetDivisionWithoutEE 화면측 후처리(SCP0006 project-route.constants.ts EXCLUDE_EE_DIVISION
//   과 동일 규칙 — 화면이 달라 공유 유틸로 승격하지 않고 그대로 복제한다, Hard Boundary 준수).
export const excludeEeDivision = (row: ComboResponse): boolean =>
  String(row.ATTRIBUTE3 ?? '') !== 'EE';

export const DefColumns = {
  CHK: 'CHK',
  DIVISION_ID: 'DIVISION_ID',
  COMPANY_ID: 'COMPANY_ID',
  SITE_ID: 'SITE_ID',
  PLANT_ID: 'PLANT_ID',
  FACTORY_ID: 'FACTORY_ID',
  OPERATION_ID: 'OPERATION_ID',
  OPERATION_GROUP_ID: 'OPERATION_GROUP_ID',
  ITEM_ID: 'ITEM_ID',
  NICK_NAME: 'NICK_NAME',
  LANE_QTY: 'LANE_QTY',
  LINE_ID: 'LINE_ID',
  LINE_NAME: 'LINE_NAME',
  ELECTRODE_TYPE: 'ELECTRODE_TYPE',
  USER_ID_1: 'USER_ID_1',
  USER_ID_2: 'USER_ID_2',
  USER_ID_3: 'USER_ID_3',
  USER_ID_4: 'USER_ID_4',
  USER_ID_5: 'USER_ID_5',
  USER_ID_6: 'USER_ID_6',
  USER_ID_7: 'USER_ID_7',
  USER_ID_8: 'USER_ID_8',
  USER_ID_9: 'USER_ID_9',
  USER_ID_10: 'USER_ID_10',
  REQUEST_CHK: 'REQUEST_CHK',
} as const;

// 동적 PIVOT 월 컬럼 prefix(AS-IS 'M_' 접두, SP1 SELECT 'M_'+A.YYYYMM 그대로).
export const DYN_MONTH_PREFIX = 'M_';
// AS-IS SP1(@p_end_month = DATEADD(MM,41,today)) — 당월 포함 42개월(0~41개월 뒤까지) 조회.
export const CALENDAR_MONTHS_SPAN = 41;

// InitSpread(cs L484-546) 고정 컬럼 그대로 — SP 미배포라 admin 메타 대신 이 파일에 직접 정의
//   (ProjectRouteListSaveModal 의 buildProjectRouteListSaveColumns 와 동일한 escape hatch).
export const buildCapaNewModelColumns = (isGroupElectrode: boolean): RawFlexGridColumnConfig[] => [
  {
    colNm: DefColumns.CHK,
    colLblNm: 'Save',
    colWth: 50,
    display: true,
    visible: true,
    horzAlgnCd: 'C',
    cellCtrlObjTpCd: CELL_CONTROL_TYPE.CHECKBOX,
  },
  { colNm: DefColumns.DIVISION_ID, colLblNm: 'Division', colWth: 60, display: true, visible: true },
  { colNm: DefColumns.COMPANY_ID, colLblNm: 'Company', colWth: 60, display: true, visible: false },
  { colNm: DefColumns.SITE_ID, colLblNm: 'Site', colWth: 60, display: true, visible: true },
  { colNm: DefColumns.PLANT_ID, colLblNm: 'Plant', colWth: 60, display: true, visible: true },
  { colNm: DefColumns.FACTORY_ID, colLblNm: 'Building', colWth: 70, display: true, visible: true },
  { colNm: DefColumns.LINE_ID, colLblNm: 'Line', colWth: 90, display: true, visible: true },
  { colNm: DefColumns.LINE_NAME, colLblNm: 'Line Name', colWth: 90, display: true, visible: true },
  { colNm: DefColumns.OPERATION_ID, colLblNm: 'Operation', colWth: 60, display: true, visible: true },
  { colNm: DefColumns.ITEM_ID, colLblNm: 'Material', colWth: 100, display: true, visible: true },
  { colNm: DefColumns.NICK_NAME, colLblNm: 'Nick Name', colWth: 90, display: true, visible: true },
  {
    colNm: DefColumns.LANE_QTY,
    colLblNm: 'Lane',
    colWth: 60,
    display: true,
    // SetColumnVisible(cs L1519-1526) — Group='E'(Electrode) 일 때만 표시.
    visible: isGroupElectrode,
    horzAlgnCd: 'C',
    cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
    cellCboDataTp: COMBO.LANE_QTY_OF_LINE_ASSIGN,
  },
  { colNm: DefColumns.ELECTRODE_TYPE, colLblNm: 'Line Type', colWth: 90, display: true, visible: true },
  { colNm: DefColumns.USER_ID_1, colLblNm: 'USER_ID_1', colWth: 80, display: true, visible: false },
  { colNm: DefColumns.USER_ID_2, colLblNm: 'USER_ID_2', colWth: 80, display: true, visible: false },
  { colNm: DefColumns.USER_ID_3, colLblNm: 'USER_ID_3', colWth: 80, display: true, visible: false },
  { colNm: DefColumns.USER_ID_4, colLblNm: 'USER_ID_4', colWth: 80, display: true, visible: false },
  { colNm: DefColumns.USER_ID_5, colLblNm: 'USER_ID_5', colWth: 80, display: true, visible: false },
  { colNm: DefColumns.USER_ID_6, colLblNm: 'USER_ID_6', colWth: 80, display: true, visible: false },
  { colNm: DefColumns.USER_ID_7, colLblNm: 'USER_ID_7', colWth: 80, display: true, visible: false },
  { colNm: DefColumns.USER_ID_8, colLblNm: 'USER_ID_8', colWth: 80, display: true, visible: false },
  { colNm: DefColumns.USER_ID_9, colLblNm: 'USER_ID_9', colWth: 80, display: true, visible: false },
  { colNm: DefColumns.USER_ID_10, colLblNm: 'USER_ID_10', colWth: 80, display: true, visible: false },
];

// Mail Req(REQUEST_CHK) 체크박스 — AS-IS InitSpread(cs L538)는 이 컬럼을 동적 월 컬럼 "뒤"(맨 끝)에
//   둔다. DataGrid 는 [정적..., 동적...] 순서로 렌더하므로, 정적(buildCapaNewModelColumns)이 아니라
//   월 컬럼 뒤에 붙는 dynamicColumns 의 마지막 항목으로 구성해 AS-IS 컬럼 순서를 재현한다.
//   dataType=Boolean 이면 Wijmo 가 체크박스로 렌더(정적 CHK 와 동일 경로 — columnMapping getDataType).
export const REQUEST_CHK_COLUMN: FlexGridColumnConfig = {
  binding: DefColumns.REQUEST_CHK,
  header: 'Mail Req',
  dataType: DataType.Boolean,
  align: 'center',
  width: 60,
  allowSorting: false,
  allowMerging: false,
  visible: true,
};

// Save/Request 시 전송(AS-IS SaveData L1153-1168 payload 필드명 그대로, ^-delim 은
//   utils/capaNewModelPopup.saveRequest.ts 가 조립).
export const REQUIRED_FIELD_CHECKS_LABEL: Record<string, string> = {
  [DefColumns.LANE_QTY]: 'Lane Qty',
};

// AS-IS SaveData 검증 메시지(cs L1114/1128/1206/1213/1219 그대로).
export const MSG = {
  LANE_QTY_REQUIRED: 'MSG00337', // Lane QTY 값 확인이 필요합니다. Lane QTY 값이 없을 경우, FP Planner에게 등록 요청하시기 바랍니다.
  PRIORITY_RANGE: 'MSG00203', // {0}~{1} 사이의 수를 입력하세요.
  SAVE_RESULT: 'MSG00004', // {0}개의 데이터가 저장되었습니다.
  SAVE_ERROR: 'MSG00284', // 실행중 에러가 발생했습니다.
  NO_CHANGE: 'MSG00133', // 수정한 내용이 없습니다.
  MAIL_SENT: 'MSG00339', // Success to send requestion e-mail.
  NO_CHECKED_ROWS: 'MSG00021', // 체크된 행이 없습니다.
} as const;
