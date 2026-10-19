import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import { isFixedColumnVisible, isPivotColumn } from './integrationPsiEditLock';

// 고정 컬럼 빌드 — admin(SCM_MST_SHEET_COLUMNS 'Integration PSI' 24행) 등록본이 유일 원천(design 03 §1).
//   하드코딩 fallback 없음 — 미등록 시 빈 배열(store 규약). 여기선 VISIBLE=N(MEASURE_COLOR/MEASURE_ORDER_NO)
//   상시 숨김 + 편집 권한 전용 4열(SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE)만 런타임 가시성 override 로 적용한다.
//   주의(속성 단위 덮어쓰기 금지): admin VISIBLE_FLAG 은 그대로 두고(baseVisible), 조건 가시성만 AND 로 좁힌다.
export const buildFixedColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  canEdit: boolean
): RawFlexGridColumnConfig[] => {
  const base = adminCols ?? [];
  return base.map(c => ({
    ...c,
    visible: isFixedColumnVisible(c.colNm, c.visible !== false, canEdit),
  }));
};

// 고정 컬럼 바인딩 집합 — pivot(YYYYMM) 판정 기준. admin 메타 colNm 전체가 고정 컬럼.
export const fixedBindingSet = (
  adminCols: RawFlexGridColumnConfig[] | undefined
): ReadonlySet<string> => new Set((adminCols ?? []).map(c => c.colNm));

// 동적 pivot 컬럼 빌드 — GET SP(P_SCP0111_GET_INTEGRATION_PSI)가 서버측 PIVOT 으로 emit 한 YYYYMM 컬럼을
//   월(yyyy-MM) 1단 헤더로 렌더한다(design 03 §2-C — 고정 base 20열 이후는 전부 YYYYMM pivot).
//   AS-IS FpSpread 의 D_/W_/M_ 3단은 로컬 pivot 이고 TO-BE 는 서버가 월단위로 집계해 내려주므로 월 컬럼만 생성.
//   조회 결과가 비면 [] — 그리드는 고정 컬럼만 렌더.
export const buildPivotColumns = (
  rows: Record<string, unknown>[],
  fixedBindings: ReadonlySet<string>
): FlexGridColumnConfig[] => {
  if (rows.length === 0) return [];

  // 행 union 에서 YYYYMM pivot 바인딩만 추출(고정 컬럼 제외).
  const bindings = new Set<string>();
  for (const r of rows) {
    for (const k of Object.keys(r)) {
      if (isPivotColumn(k, fixedBindings)) bindings.add(k);
    }
  }
  if (bindings.size === 0) return [];

  return [...bindings]
    .sort()
    .map<FlexGridColumnConfig>(binding => ({
      binding,
      header: `${binding.slice(0, 4)}-${binding.slice(4, 6)}`,
      align: 'right',
      format: 'n0', // QTY = 정수(design 03 §4.1). 소수 measure 없음.
      width: 75, // AS-IS AddNumColumn width 75 (design 03 §2-A cs:354)
      allowMerging: false, // pivot 컬럼은 병합 대상 아님(고정 식별열만 병합)
      allowSorting: false,
      allowResizing: true,
      visible: true,
      // pivot 셀 baseline readOnly — 편집가능 셀은 그리드 beginningEdit 가 명시 해제(design 03 §3-Lock).
      _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      _dynamic: true,
    }));
};
