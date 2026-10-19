// CAPA New Model 팝업(AS-IS SCP0049_CAPANewModelPopup, GSCM.SCP.Master.UIL/POPUP) — 상수/컬럼 정의.
//   AS-IS 원본(1559줄, 전체 정독): GSCM/06.UIL/GSCM.SCP.Master.UIL/POPUP/SCP0049_CAPANewModelPopup.cs
//   + .Designer.cs. SCP0049_CAPA(본가 화면)·SCP0201_CAPA·SCP0006_ProjectRoute 3개 AS-IS 화면이
//   공유하는 팝업이라(전역 grep 확인) features/master/src/components(공용) 아래 둔다 — 단일 화면
//   전용이 아니다.
//
// 진행 상태(2026-09-22): AS-IS MSSQL SP 6개 실측 완료(.atlas/gscm-design/SCP0049/
//   asis-sp-inventory-capa-new-model-popup.md 참고) — TO-BE Oracle 에는 PKG_SCP0049 자체가
//   미배포(전건 확인). 이번 회차는 UI(조회조건 cascade·그리드·검증)만 완성한다:
//   - 조회조건 6단 cascade(Division→Group→Plant→Building→Line→Operation) 콤보는 전부 DB 기실측
//     확인(SCM_ADM_CMBO_SQL_M, ora.py) — **이미 등록돼 있어 실제로 동작한다**(CAPA 전용이 아니라
//     SCP/FP 공용 계층콤보라 다른 화면들이 먼저 등록해 둔 것으로 보인다).
//   - LANE_QTY 검증도 동일하게 실등록 콤보(LaneQtyOfLineAssign_SCP)로 동작한다.
//   - 그리드 조회(FindData)·저장(SaveData)·메일요청(RequestData) 3개는 SP 미배포라 플레이스홀더
//     MENU_ID(`MENU_ID_PENDING`)로 만들어 두고 등록 후 교체한다(ProjectRouteListSaveModal 선례와
//     동일 절차).

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';

// TODO(SP 미배포 대기): PKG_SCP0049 전건 미배포 확인(2026-09-22 ora.py) — admin 등록 후 실제
//   MNU_ID 로 교체. 등록 전까지 Find/Save/Request 실조회는 불가하다(UI·검증 로직만 완성).
export const MENU_ID_PENDING = 'SCP0049_CAPA_NEW_MODEL_POPUP';
export const SHEET_MAIN = 'mainList';

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
  {
    colNm: DefColumns.REQUEST_CHK,
    colLblNm: 'Mail Req',
    colWth: 60,
    display: true,
    visible: true,
    horzAlgnCd: 'C',
    cellCtrlObjTpCd: CELL_CONTROL_TYPE.CHECKBOX,
  },
];

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
