import type { ComboResponse } from '@foundation/models';

import type { CustomComboOption } from './demand-group-master.columns';

// AS-IS 화면 전용 클라 필터 재현 — 콤보는 서버 SP/CMBO_SQL 을 그대로 이관한 것이라
//   C# 소스가 SP 호출 뒤 건 후처리 필터(DBUtils.Filter)는 CMBO_SQL 에 없다(convert-core §2.6).

/**
 * Division 콤보 옵션 — Division_SCP 결과에 AS-IS 2종 클라 필터 재현.
 *   1) ATTRIBUTE3 <> 'EE' (전극/EE 사업부 제외 — BLUtils.GetDivisionWithoutEE cs L109/116)
 *   2) CODE 에 '81' 포함만 노출 (InitControls cs L166-191) + CODE Asc 정렬
 */
export const buildDivisionOptions = (rows: ComboResponse[] | undefined): CustomComboOption[] =>
  (rows ?? [])
    .filter(row => {
      const attr3 = (row as Record<string, unknown>).ATTRIBUTE3;
      return attr3 !== 'EE' && String(row.CODE ?? '').includes('81');
    })
    .sort((a, b) => String(a.CODE ?? '').localeCompare(String(b.CODE ?? '')))
    .map(row => ({ label: row.NAME, value: row.CODE }));

/**
 * Operation Group 콤보 옵션 — LookupCommon(OPERATION_GROUP) 에서 'E'(Electrode) 제외.
 *   AS-IS 위치기반 RemoveAt(2) 대신 코드 기준(CODE<>'E') 재현(순서 변경에 안전, design 02 §2.2).
 *   최종 {P:Pack, A:Cell}.
 */
export const buildOperationGroupOptions = (
  rows: ComboResponse[] | undefined
): CustomComboOption[] =>
  (rows ?? []).filter(row => row.CODE !== 'E').map(row => ({ label: row.NAME, value: row.CODE }));

/**
 * GROUP_ID 셀 콤보 후보 — GroupMaster_SCP_ALL(division/opGroup WHERE 없음)에
 *   AS-IS 클라 좁힘(DIVISION_ID + OPERATION_GROUP) 재현(cs L286 DBUtils.Filter).
 */
export const filterGroupMasterByContext = (
  rows: ComboResponse[] | undefined,
  divisionId: string,
  operationGroup: string
): ComboResponse[] =>
  (rows ?? []).filter(row => {
    const rec = row as Record<string, string | undefined>;
    const divOk = !divisionId || (rec.DIVISION_ID ?? '') === divisionId;
    const opOk = !operationGroup || (rec.OPERATION_GROUP ?? '') === operationGroup;
    return divOk && opOk;
  });
