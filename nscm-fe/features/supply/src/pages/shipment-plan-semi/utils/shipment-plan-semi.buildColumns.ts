import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import { DIVISION_EE_ONLY_COLUMNS } from '../shipment-plan-semi.columns';
import type { MainColumnMeta } from '../shipment-plan-semi.types';

// admin(SCM_MST_SHEET_COLUMNS)의 VISIBLE_FLAG는 division 무관 고정값이므로(shipment-plan-fg gap-audit
//   NEW1 선례), R-A(EE 계열 3건) 조건부 컬럼만 런타임 visible로 admin 메타 위에 덮어쓴다.
const DIVISION_CONDITIONAL_KEYS = new Set<string>(DIVISION_EE_ONLY_COLUMNS);

// constants(MainColumnMeta) -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 그걸 authoritative 로 쓰고(design 03 §1 — 27행 등록
//   확인), 없으면(fetch 실패/지연) 이 constants 를 fallback 으로 쓴다(shipment-plan-fg 동일 패턴).
export const buildColumns = (
  meta: MainColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  const divisionOverlay = new Map(
    meta.filter(c => DIVISION_CONDITIONAL_KEYS.has(c.key)).map(c => [c.key, c.visible !== false] as const)
  );
  const withDivisionOverlay = (col: RawFlexGridColumnConfig): RawFlexGridColumnConfig => {
    const visible = divisionOverlay.get(col.colNm);
    if (visible === undefined) return col;
    return { ...col, visible, display: visible };
  };

  if (adminCols && adminCols.length > 0) return adminCols.map(withDivisionOverlay);
  return meta.map<RawFlexGridColumnConfig>(c =>
    withDivisionOverlay({
      colNm: c.key,
      colLblNm: c.header,
      horzAlgnCd: c.align ?? 'L',
      colWth: c.width ?? 100,
      visible: c.visible !== false,
      display: c.visible !== false,
      fixed: c.frozen,
      // 정보컬럼(design 03 §0) 전건 INPUT_TP_CD='S' 읽기전용 — 편집가능 여부는 동적 pivot 컬럼(D_/W_/M_)만 대상.
      inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
    })
  );
};
