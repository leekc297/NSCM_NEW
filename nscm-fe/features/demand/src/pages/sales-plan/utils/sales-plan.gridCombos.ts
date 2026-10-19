// DMF0021 — 셀 편집 후처리 헬퍼.
//   금지: 이 파일에서 DataMap 을 만들어 col.dataMap 에 붙이지 말 것. 셀 콤보의 후보·표시·행별
//   좁힘은 전부 컬럼 메타(cellCboDataTp / PARAM2 / PARAM9 / PARAM10)가 단일 원천이고 공용
//   DataGrid 가 그 메타대로 만든다 (foundation getDataMap / getRowParamDataMap).
//   행 상태로 후보를 더 좁혀야 하면 기존 맵의 getDisplayValues 만 덮는다 (SalesPlanGrid
//   installMeasureCandidateFilter / installCatchUpFcstTypeFilter).
import { INSERT_DEFAULT_FCST_TYPE } from '../sales-plan.constants';
import type { SalesPlanRow } from '../sales-plan.types';

// 타입 안전 string 변환 — string/number 만 (객체는 ''). no-base-to-string 회피.
export const toCellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 셀 비우기 patch 생성 — cascade 계단 clear 와 모달 취소가 같은 규칙(빈 문자열)으로 비운다.
//   null 이 아니라 '' 인 이유: 신규행 기본값(INSERT_ROW_DEFAULTS)이 전부 '' 라 미입력 상태와
//   같은 표현이어야 저장 필수값 검증(validate)이 둘을 구분 없이 걸러낸다.
export const buildClearPatch = (fields: readonly string[]): Record<string, string> =>
  Object.fromEntries(fields.map(f => [f, '']));

// ⭐ R6 — Measure 전환 시 행 재구성 (AS-IS ComboSelChange Measure 분기 L4774~5082 —
//   Catch_Up: ItemId 모달 전환+clear(L4870)/DomExp·Incoterms·FcstType 개방/Team 잠금 /
//   SalesAmt_LOC 복귀: FCST_TYPE='ETC' 고정(L2944 계보)+3종 잠금 / 공통: 기존 기간 입력 전체 초기화).
//   잠금/개방 자체는 insertStaticEditable(editLock R5)이 row.MEASURE 실시간 참조로 반영 —
//   여기서는 값 재세팅만 수행.
export const applyMeasureSwitch = (
  row: SalesPlanRow,
  nextMeasure: string,
  dynBindings: readonly string[]
): void => {
  const rec = row as Record<string, unknown>;
  if (nextMeasure === 'Catch_Up') {
    rec.FCST_TYPE = ''; // 개방 — 사용자가 ETC 제외 콤보에서 선택
    rec.DOM_EXP = '';
    rec.INCOTERMS = '';
    rec.ITEM_ID = ''; // 모달 전용 전환 + clear (L4870)
    rec.ITEM_CLASS_NAME = '';
    rec.NICK_NAME = '';
    rec.DEPT_ID = ''; // Catch_Up 전환 시 팀 초기화+잠금 (AS-IS L4950~4951 — CC-12)
  } else {
    rec.FCST_TYPE = INSERT_DEFAULT_FCST_TYPE; // ETC 고정 (SalesAmt_LOC = 기타매출 제약)
    rec.DOM_EXP = '';
    rec.INCOTERMS = '';
    rec.DEPT_ID = ''; // 복귀 시에도 초기화 후 재입력 (AS-IS L5004~5008 — CC-20)
  }
  // 기존 기간 입력 전체 초기화 (cutoff 스왑으로 무효화된 입력 제거)
  dynBindings.forEach(b => {
    if (rec[b] != null && rec[b] !== '') rec[b] = null;
  });
};
