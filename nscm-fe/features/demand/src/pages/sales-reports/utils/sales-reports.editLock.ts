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

// ⭐ 정적 컬럼 편집 판정 — **UI Category Setup(`INPUT_TP_CD`) 단일 원천** (2026-08-11 전환).
//   [이전] AS-IS `.cs` InsertRow LockRange 12컬럼을 **하드코딩**해 "잠금 목록 외 전부 개방"으로 판정.
//          → 운영자가 admin 화면에서 정한 `INPUT_TP_CD` 가 화면에 **무효화**됐다
//            (실측: DMF0044 46컬럼 전부 'S'(Only Search) 인데 화면은 신규행 입력 가능).
//   [현재] 컬럼 메타의 `inputTpCd` 를 그대로 따른다. AS-IS 파리티는 **메타 값**으로 보존한다
//          (InsertRow 가 잠그던 컬럼 = 'S' 로 등재. 2026-08-11 메타 정합 적용 IM 1/IO 32/S 13).
//   규약은 공용 `GridUtils.isEditableCell`(foundation/utils/gridUtils.ts)과 **동일**하다 —
//   화면 게이트와 공용 게이트가 같은 메타·같은 규칙을 보므로 판정이 갈릴 수 없다.
//     IM / IO → EDIT_FLAG!=='N' && CRUD_TYPE==='I'   (insert 시 입력. IM=필수·IO=선택)
//     M  / O  → EDIT_FLAG!=='N'                       (전 행 입력)
//     S / 미지정 → 편집 불가
export const staticEditableByMeta = (
  inputTpCd: string | undefined,
  row: SalesReportRow | undefined
): boolean => {
  if (!row) return false;
  const editFlag = typeof row.EDIT_FLAG === 'string' ? row.EDIT_FLAG : '';
  if (editFlag === 'N') return false;
  switch (inputTpCd) {
    case 'M':
    case 'O':
      return true;
    case 'IM':
    case 'IO':
      return row.CRUD_TYPE === 'I';
    default: // 'S' 및 미지정
      return false;
  }
};

// ※ 현재월(yyyymm)은 `useSalesReportsStore.thisMonth` 가 조회 시점에 `dayjs().format('YYYYMM')` 로
//   1회 산출해 고정한다(state L36·L107·L150). 여기서 Date 기반 헬퍼를 따로 두면 산출 원천이 둘이 되어
//   경계값이 어긋날 수 있으므로 두지 않는다.
