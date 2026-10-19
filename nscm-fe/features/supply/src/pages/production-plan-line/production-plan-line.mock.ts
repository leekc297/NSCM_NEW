// ⚠ 임시 개발용 목데이터 — 조회 SP(main/SEARCH = PKG_SCP0013)가 300초 타임아웃 나는 동안 그리드를
//   채워 다른 UI 테스트(컬럼/버튼/팝업/선택 등)를 이어가기 위한 장치다. SP 성능 개선이 끝나면
//   이 파일과 ProductionPlanLine.tsx 의 MOCK 분기(3곳)를 제거한다.
//   프로덕션 안전장치: import.meta.env.DEV 로 게이트 → 운영 빌드에서는 플래그와 무관하게 항상 비활성.
import type { MainRow } from './production-plan-line.types';

// 목업 OFF — 실제 조회(main/SEARCH·editInfo·SAVE 등 실 SP)가 동작한다. 다시 켜려면 false → (import.meta.env.DEV && true).
export const MOCK_MAIN_ENABLED = false;

// Weekly 버킷 가시 피벗키 = 'W_' + BASIS_YYYYMM(6) + ISO_WEEK. **미래 월(2026-10/11)** 로 둔다 —
//   과거(이번 주 월요일 이전) 피벗은 isPastPivot 로 편집 잠금이라, Fix/Unfix·셀편집 테스트를 위해 미래로.
const W_KEYS = ['W_20261040', 'W_20261041', 'W_20261042', 'W_20261043', 'W_20261144', 'W_20261145'];
const M_KEYS = ['M_202610', 'M_202611']; // chkSum 체크 시 노출되는 SUM 컬럼

const pivotVals = (seed: number): Record<string, number> => {
  const o: Record<string, number> = {};
  W_KEYS.forEach((k, i) => (o[k] = (seed + i) * 10));
  M_KEYS.forEach((k, i) => (o[k] = (seed + i) * 40));
  return o;
};

const row = (
  line: string,
  item: string,
  model: string,
  measure: string,
  measureName: string,
  seed: number
): Record<string, unknown> => ({
  DIVISION_ID: '81',
  ORIGIN_DIVISION_ID: '81',
  OPERATION_GROUP: 'A',
  OPERATION_GROUP_NAME: 'Cell',
  SCM_SITE_ID: 'HQ',
  SCM_SITE_DESCRIPTION: 'HQ OC2 Mobile Prod-Cell',
  OPERATION_ID: 'OP01',
  LINE_ID: line,
  ITEM_ID: item,
  MODEL_ID: model,
  NICK_NAME: `${model}-NICK`,
  EXTRA_SPEC: '',
  CELL_TYPE_GROUP_CODE: '',
  ELECTRODE_TYPE: '',
  CELL_ID: '',
  UNIT: 'EA',
  MEASURE: measure,
  MEASURE_NAME: measureName,
  CP_KEY: `${line}|${item}|${measure}`,
  FIX_KEY: `81AHQ${item}${line}OP0181`,
  ...pivotVals(seed),
});

// o_rc1 = 그리드행. 편집 테스트용 PROD_PLAN_AMEND 1행 + 표시용 1행 × 라인 2개.
const MOCK_ROWS = [
  row('L001', 'ITEM-A', 'MODEL-A', 'PROD_PLAN_AMEND', 'Production Plan(Amend)', 1),
  row('L001', 'ITEM-A', 'MODEL-A', 'PROD_PLAN', 'Production Plan', 2),
  row('L002', 'ITEM-B', 'MODEL-B', 'PROD_PLAN_AMEND', 'Production Plan(Amend)', 3),
  row('L002', 'ITEM-B', 'MODEL-B', 'PROD_PLAN', 'Production Plan', 4),
];

export const MOCK_MAIN_DATA = {
  o_rc1: MOCK_ROWS as unknown as MainRow[],
  o_rc2: [], // fix 확정 셀 없음
  o_rc3: [], // ratio(주) 없음 → applyRatio no-op
  o_rc4: [], // ratio(월) 없음
  DATARESULT: [],
};

// editInfo(P_SCP0013_GET_PLAN_EDIT_INFO) 목 — 각 행 CP_KEY 를 IS_EDITABLE='Y' 로 둬 셀 편집을 연다.
//   실제 편집 허용은 isRowEditable 이 PROD_PLAN_AMEND 행 + (미래 피벗) 조건까지 봐서 거른다.
export const MOCK_EDIT_INFO_DATA = {
  o_rc1: MOCK_ROWS.map(r => ({
    CP_KEY: r.CP_KEY as string,
    IS_EDITABLE: 'Y',
    NEW_EDIT_MODE: 'Y',
    EDIT_START_DATE: '',
  })),
};
