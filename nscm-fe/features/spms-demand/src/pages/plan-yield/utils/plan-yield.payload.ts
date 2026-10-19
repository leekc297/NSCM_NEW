// ⭐ SDM2020 — 그리드 행 → 벌크 payload 순수함수 (테스트 대상).
//   SPMS 표준 lib/bulk-save 로 컬럼별 '^' 조인 (빈 값 ' ' 센티널 — SP REGEXP_SUBSTR 빈 토큰 행밀림 방지)
//   후 PROC_M COL_NM(camelCase) 로 재명명한다. 스칼라 IN 은 빌드 커서/선택 공정에서 그대로 전달.
import { buildBulkSavePayload } from '../../../lib/bulk-save';
import { toText } from '../../../lib/call-proc';
import type { PlantRow, SelectedOperationGroup, YieldRow } from '../plan-yield.types';

import type { ConfirmYieldPayload, SavePlantPayload } from './plan-yield.api';
import { isGroupRow } from './plan-yield.editLock';

type Ctx = { dpjtCode: string; dpjtBuildNo: string; sesDivisionId: string };

const PLANT_KEYS = [
  'MGMT_TYPE',
  'OPERATION_GROUP',
  'OPERATION_ID',
  'PLANT_ID',
  'CONFIRM_FLAG',
] as const;

/** 요청법인 패널 전 행 → SAVEPLANT 벌크 1건 (replace-set — 대상 filter 없이 전 행) */
export const toSavePlantPayload = (rows: PlantRow[], ctx: Ctx): SavePlantPayload | null => {
  if (rows.length === 0) return null;
  const bulk = buildBulkSavePayload(rows as unknown as Record<string, unknown>[], PLANT_KEYS)[0];
  return {
    dpjtCode: ctx.dpjtCode,
    dpjtBuildNo: ctx.dpjtBuildNo,
    mgmtType: toText(bulk.MGMT_TYPE),
    operationGroup: toText(bulk.OPERATION_GROUP),
    operationId: toText(bulk.OPERATION_ID),
    plantId: toText(bulk.PLANT_ID),
    confirmFlag: toText(bulk.CONFIRM_FLAG),
    sesDivisionId: ctx.sesDivisionId,
  };
};

// 편집값만 전송 — 템플릿 필드(LEVEL_*/UOM/BASIC_VAL 등)는 SP 가 SPMS_YIELD_TABLE 에서 키로 재조립
//   ⭐ 법인/공정은 스칼라가 아니라 행별 값이다 — 조회 단위가 구분(공정 그룹)이라 한 그리드에
//   여러 공정이 섞여 있다. 커서가 행마다 PLANT_ID/OPERATION_ID 를 내려주므로 그대로 접어 보낸다.
const YIELD_KEYS = [
  'YIELD_MGMT_KEY',
  'PLANT_ID',
  'OPERATION_ID',
  'CHECKED_FLAG',
  'YIELD_VAL',
  'ADD_INFO_1',
] as const;

/** 수율 그리드 조건행(그룹 헤더행 제외) → CONFIRM 벌크 1건. 조건행 0건이면 null */
export const toConfirmYieldPayload = (
  rows: YieldRow[],
  group: SelectedOperationGroup,
  ctx: Ctx
): ConfirmYieldPayload | null => {
  const target = rows.filter(row => !isGroupRow(row as unknown as Record<string, unknown>));
  if (target.length === 0) return null;
  const bulk = buildBulkSavePayload(target as unknown as Record<string, unknown>[], YIELD_KEYS)[0];
  return {
    dpjtCode: ctx.dpjtCode,
    dpjtBuildNo: ctx.dpjtBuildNo,
    operationGroup: group.operationGroup,
    mgmtType: group.mgmtType,
    yieldVer: toText(target[0].YIELD_VER),
    yieldMgmtKey: toText(bulk.YIELD_MGMT_KEY),
    plantId: toText(bulk.PLANT_ID),
    operationId: toText(bulk.OPERATION_ID),
    checkedFlag: toText(bulk.CHECKED_FLAG),
    yieldVal: toText(bulk.YIELD_VAL),
    addInfo1: toText(bulk.ADD_INFO_1),
    sesDivisionId: ctx.sesDivisionId,
  };
};

/**
 * 요청법인 그리드 행 → 선택 공정 그룹 (수율 그리드 조회 필터 원천).
 * 행의 어느 셀을 눌러도 그 행이 속한 구분이 조회 단위다 — 같은 구분의 다른 공정 행을 눌러도
 * 같은 값이 나와 재조회가 일어나지 않는다. 그룹 코드 없는 행은 null.
 */
export const toSelectedOperationGroup = (
  row: PlantRow | undefined
): SelectedOperationGroup | null => {
  if (!row) return null;
  const operationGroup = toText(row.OPERATION_GROUP);
  if (!operationGroup) return null;
  return {
    operationGroup,
    mgmtType: toText(row.MGMT_TYPE),
    operationGroupName: toText(row.OPERATION_GROUP_NAME) || operationGroup,
  };
};

// 양극·음극은 OPERATION_GROUP 이 같은 'E' 라 MGMT_TYPE 까지 봐야 다른 구분이 된다
export const isSameOperationGroup = (
  a: SelectedOperationGroup | null,
  b: SelectedOperationGroup | null
): boolean => a?.operationGroup === b?.operationGroup && a?.mgmtType === b?.mgmtType;
