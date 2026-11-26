// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요).

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE } from '@foundation/constants';

import { MENU_ID, MSG } from '../precede-safety-stock-day.constants';

const str = (v: unknown): string => {
  if (v == null) return '';
  if (typeof v === 'string' || typeof v === 'number' || typeof v === 'boolean') return String(v);
  return '';
};

// EE(Electrode) division 을 조회용 실 사업부로 매핑 — 공용 품목 팝업
//   MaterialByDivisionModal.mapElectrodeDivision(features/master/.../MaterialByDivisionModal.tsx)과
//   동일 규칙을 재현한다. 공용 컴포넌트는 이 화면 작업 범위 밖(core.md CORE-05 Hard Boundary)이라
//   수정·export 하지 않고 여기 복제한다. 자재(SCP_MST_FINAL_ITEM)는 EE 가 아니라 실 battery
//   division 으로 태깅돼 있어 'EE'/'EE_UC' 를 그대로 SP 에 넘기면 0행이 되고, 그러면 전 품목이
//   '무효'로 오판되므로 반드시 팝업과 동일 매핑을 거쳐야 한다.
const mapElectrodeDivision = (divisionId: string): string => {
  if (divisionId === 'EE') return '81,82,40';
  if (divisionId === 'EE_UC') return '81_UC';
  return divisionId;
};

/**
 * Division 유효 품목 ID 집합 — AS-IS dtItemAll(GetSearchInfo Table[5]) 등가물.
 *
 * TO-BE 에서 사용자가 ITEM_ID 를 채우는 유일 원천은 품목 팝업(COM0013
 * `PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION`, scpModuleType=SCP0127)이다. 저장검증도 같은
 * 목록을 기준으로 삼으면 "팝업에 있으면 유효, 없으면 무효" 가 되어 자기정합적이다 — 이 집합 밖
 * ITEM_ID 는 사용자가 셀에 직접 키인/붙여넣기한 오타(무효 모델)뿐이다. itemId 를 비워 조회해
 * 해당 Division 전 품목을 받아 Set 으로 만든다.
 */
export const fetchValidItemIds = async (divisionId: string): Promise<Set<string>> => {
  if (!divisionId) return new Set();
  const res = await apiClient.callProc('COM0013', 'materialByDivision', BUTTON_TYPE.SEARCH, {
    divisionId: mapElectrodeDivision(divisionId),
    operationGroup: '',
    itemId: '',
    scpModuleType: MENU_ID,
  });
  const rows = res.result?.o_rc1 ?? [];
  return new Set(rows.map(row => str(row.ITEM_ID)).filter(Boolean));
};

/**
 * #6 MSG00458 — 품목 미존재. AS-IS `SaveData`(.cs:730~735) `DBUtils.Filter(dtItemAll,"ITEM_ID=…")
 * .Rows.Count<=0` → `GMessageBox("MSG00458",{item_id})` 재현. ITEM_ID 가 Division 유효 품목 집합
 * (validByDivision)에 없으면 첫 위반행을 돌려준다(AS-IS 순차 가드처럼 첫 위반에서 멈춤).
 *   - 삭제행(CRUD_TYPE='D')은 제외 — 이미 존재하던 행을 지우는 중이라 존재검증이 불필요하다.
 *   - 공백 ITEM_ID 는 필수검증(#1, precedeSafetyStockDaySaveValidation)이 선처리하므로 건너뛴다.
 *   - 셀값이 콤마결합(팝업 다중선택)일 수 있어 토큰별로 검증한다.
 *
 * @returns 첫 무효행 { msgId, message, itemId }(호출부가 MSG00458 {0}=itemId 치환) 또는 통과 시 null.
 */
export const findInvalidItemIdRow = (
  rows: WijmoRowItem[],
  validByDivision: Map<string, Set<string>>
): { msgId: string; message: string; itemId: string } | null => {
  for (const row of rows) {
    if (str(row.CRUD_TYPE) === 'D') continue;
    const raw = str(row.ITEM_ID).trim();
    if (raw === '') continue;
    const validItems = validByDivision.get(str(row.DIVISION_ID)) ?? new Set<string>();
    const tokens = raw
      .split(',')
      .map(token => token.trim())
      .filter(Boolean);
    const invalid = tokens.find(token => !validItems.has(token));
    if (invalid !== undefined) {
      return { msgId: MSG.ITEM_NOT_FOUND, message: '_유효하지 않은 모델입니다.', itemId: invalid };
    }
  }
  return null;
};
