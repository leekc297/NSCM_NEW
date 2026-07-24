// ⭐ DMF0044 — 편집/잠금 규칙 엔진 (제약매트릭스 §3 4변수 매트릭스 + InsertRow 잠금 12컬럼 전수).
//   근거(라인 = AS-IS 신정본 DMF0044_Sales_Reports.cs 1,483행):
//   [게이트0] Data Type=='ALL' → 편집·저장 전면 차단 (EditButton L272~276 MSG00321→MSG00681)
//   [게이트1] 행 EDIT_FLAG × Measure × Division × 시점 — EditButton L270~372 매트릭스:
//     EDIT_FLAG=='Y'                          → 키영역만 잠금, 수량 전 구간 편집 (L327)
//     ≠Y & MEASURE=='LOC'                     → 계획구간(현재월~)만 편집 (L333/337 — 과거 잠금)
//     ≠Y & (MEASURE∋'RTF' | =='Business_Plan') & Div40 → 기간 전체 편집 (L346)
//     ≠Y & (〃) & 비40                        → 편집 불가 (L350)
//     ≠Y & 기타 MEASURE & Div40               → 과거구간만 편집 (L358/359 — 미래 잠금)
//     ≠Y & 기타 & 비40                        → 편집 불가 (L363)
//   [InsertRow] 메타컬럼 잠금 12 (L997~1023) + MEASURE 강제 세팅 (L1021~1025)
//   순수 함수 — Grid formatItem(3색 hook #95) + beginningEdit cancel 공유.
import { DATA_TYPE } from '../sales-reports.constants';
import type { SalesReportRow } from '../sales-reports.types';

import { isDiv40 } from './sales-reports.division';

// 편집 완화 판정 measure (매트릭스 분기 키 — L333/346)
const EDIT_ALLOWED = {
  LOC: 'LOC',
  BUSINESS_PLAN: 'Business_Plan',
} as const;

// 동적 binding — M_yyyymm 단일 축 (DMF0044 는 Y_/Q_/W_/D_ 없음 — .cs GetColumnTag Replace('M_','') L604/641/829)
export const dynKindOf = (binding: string): 'M' | null => (/^M_\d{6}$/.test(binding) ? 'M' : null);

export interface SalesReportCellState {
  editable: boolean;
  isPast: boolean; // 현재월 이전 (Gray — 컬럼 차원)
}

const LOCKED: SalesReportCellState = { editable: false, isPast: false };

// ⭐ 동적 셀(M_) 편집 가능 여부 — 4변수 매트릭스 (formatItem 배경색 + beginningEdit cancel 공유)
export const evalSalesReportCell = (params: {
  binding: string;
  row: SalesReportRow | undefined;
  divisionId: string;
  dataType: string;
  thisMonth: string; // yyyymm — iCurCol 경계 (AS-IS 현재월 산정 L306~318)
}): SalesReportCellState => {
  const { binding, row, divisionId, dataType, thisMonth } = params;
  if (dynKindOf(binding) !== 'M') return LOCKED;
  const ym = binding.slice(2);
  const isPast = ym < thisMonth;

  // 게이트0 — Data Type ALL = 전면 차단 (L272~276)
  if (dataType === DATA_TYPE.ALL) return { editable: false, isPast };
  if (!row) return { editable: false, isPast };

  // Insert 행 — 수량 전 구간 개방 (신규 입력. MEASURE 는 강제 세팅되어 있음)
  if (row.CRUD_TYPE === 'I') return { editable: true, isPast };

  const editFlag = typeof row.EDIT_FLAG === 'string' ? row.EDIT_FLAG : '';
  const measure = typeof row.MEASURE === 'string' ? row.MEASURE : '';
  const d40 = isDiv40(divisionId);

  // EDIT_FLAG=='Y' — 수량 전 구간 편집 (L327)
  if (editFlag === 'Y') return { editable: true, isPast };

  // ≠Y 분기 (L333~363)
  if (measure === EDIT_ALLOWED.LOC) {
    // LOC = 계획구간(현재월 이후)만 (L333/337)
    return { editable: !isPast, isPast };
  }
  if (measure.includes('RTF') || measure === EDIT_ALLOWED.BUSINESS_PLAN) {
    // RTF*/Business_Plan — 40 만 기간 전체, 비40 잠금 (L346/350)
    return { editable: d40, isPast };
  }
  // 기타 measure — 40 만 과거구간, 비40 잠금 (L358~363)
  return { editable: d40 && isPast, isPast };
};

// ⭐ InsertRow 메타컬럼 잠금 12 (신정본 L997~1023 전수) — true = 잠금
const INSERT_LOCKED_COLUMNS = new Set([
  'DEPARTMENT_NAME',
  'DEPT_NAME',
  'CUTOFF_YYYYMMDD',
  'NICK_NAME',
  'SCM_SITE_ID',
  'PROJECT_CODE',
  'APPLICATION',
  'BIZ_TYPE_NAME',
  'BIZ_TYPE_NAME40',
  'DMS_SALES',
  'DMS_CUSTOMER',
  'MEASURE', // 블록 삽입 시 강제 세팅 (L1021~1025) — 사용자 선택 불가
]);

// Insert 행 정적 컬럼 편집 — 잠금 12 외 개방 (콤보/텍스트는 SHEET_COLUMNS 메타·cascade 가 담당)
export const insertStaticEditable = (binding: string): boolean =>
  !INSERT_LOCKED_COLUMNS.has(binding);

// 기존행 정적 컬럼 — 전량 잠금 (AS-IS EditButton 키영역 LockRange — 예외 없음)
export const existingStaticEditable = (): boolean => false;

// 현재월 yyyymm (AS-IS iCurCol 산정 — Date 기준. 조회 시점 고정 위해 store 에서 1회 산출 권장)
export const currentYyyymm = (d: Date): string =>
  `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}`;
