// ⭐ DMF0003 Phase 2e — contextMenu PR 유효성 + ^delim 파라미터 빌더 (AS-IS .cs L5510~5753 1:1).
//   순수 함수 — UI(MktFcstGrid) 가 선택 cellRange + row dataItem 접근자를 주입.
//   anti-simplification: 모든 검증 조건(BNPIn measure / D_ 컬럼 / 과거일 제외 / Model dup / Project 동일)을
//     AS-IS 라인 근거로 보존. 임의 단순화·생략 금지.
import { DIVISION, PR_MEASURE } from '../mkt-fcst.constants';

import { thisWeekMondayYmd } from './mkt-fcst.editLock';

export type PrContextAction = 'Request_PR' | 'View_PR' | 'Add_History' | 'View_History';

// 타입 안전 cell 값 → string (no-base-to-string 회피 — 객체는 ''). SP 컬럼은 string/number 만.
export const toCellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 선택 cell 1개의 좌표 + 컬럼 binding (D_yyyymmdd / 정적컬럼).
export interface PrCell {
  rowIdx: number;
  binding: string;
}

// row 단위 키 접근자 (grid dataItem 에서 추출 — UI 가 division 분기 후 주입).
export interface PrRowAccessor {
  // 셀 값 (D_ 컬럼 qty 또는 정적컬럼). 없으면 ''.
  getCell: (rowIdx: number, binding: string) => string;
  // row 의 MEASURE 값.
  getMeasure: (rowIdx: number) => string;
  // row 의 key 컬럼들 (division 분기 반영 — Div40 = ItemId40/ScmSiteId40).
  getItemId: (rowIdx: number) => string;
  getScmSiteId: (rowIdx: number) => string;
  getProjectCode: (rowIdx: number) => string;
  getDomExp: (rowIdx: number) => string;
  getFcstType: (rowIdx: number) => string;
  getIncoterms: (rowIdx: number) => string;
  getPlantSiteId: (rowIdx: number) => string;
}

export type PrContextResult =
  | { ok: true; action: PrContextAction; request: Record<string, string> }
  | { ok: false; msgKey: string; fallback: string; msgParams?: Record<string, string> };

// ⭐ 검증 옵션 (AS-IS L5603 가드 1:1 — 2026-07-03 격차⑤ 교정):
//   bucketType   : 조회조건 Bucket. Daily 가 아니면 비-일자 컬럼 값 검사 항상 수행,
//                  Daily 면 visible 컬럼만 검사 (숨긴 W_/M_ 잔존값 무시).
//   isColVisible : 컬럼 visible 여부 접근자 (grid 주입).
//   actionLabel  : 단일셀 검증 메시지의 버튼명 prefix (AS-IS "{버튼명}버튼은..." — 격차⑥).
export interface PrContextOptions {
  bucketType?: string;
  isColVisible?: (binding: string) => boolean;
  actionLabel?: string;
}

// D_yyyymmdd → yyyymmdd 추출.
const ymdOf = (binding: string): string => (binding.startsWith('D_') ? binding.slice(2) : '');

const isDailyCol = (binding: string): boolean => /^D_\d{8}$/.test(binding);

// ===== Request_PR — 다중 셀 (AS-IS L5550~5693) =====
//   조건: 각 D_ 셀의 measure='BNPIn' + 값≠0/'' + 과거일(이번주 월요일 이전) 제외 + 비-일자컬럼 값 금지
//         + Model 중복 불가 + Project 동일.
const buildRequestPr = (
  cells: PrCell[],
  acc: PrRowAccessor,
  opts?: PrContextOptions
): PrContextResult => {
  const monday = thisWeekMondayYmd(); // 이번주 월요일 yyyymmdd (AS-IS L5544)

  const itemIds: string[] = [];
  const scmSiteIds: string[] = [];
  const domExps: string[] = [];
  const fcstTypes: string[] = [];
  const incoterms: string[] = [];
  const plantSiteIds: string[] = [];
  const projectCodes: string[] = [];
  const yyyymmdds: string[] = [];
  const qtys: string[] = [];

  for (const cell of cells) {
    // 비-일자(D_) 컬럼인데 값이 있으면 금지 — AS-IS "일자컬럼에서만 사용가능합니다." (.cs L5620).
    //   ⭐ AS-IS L5603 가드 1:1 (격차⑤): `bucketType != Daily || 컬럼.Visible` 일 때만 검사 —
    //   Daily 에서 숨긴 컬럼의 잔존값은 무시. 값 판정은 AS-IS `!= ""` (— '0' 도 값으로 차단).
    if (!isDailyCol(cell.binding)) {
      const guard =
        (opts?.bucketType ?? '') !== 'D' || (opts?.isColVisible?.(cell.binding) ?? true);
      if (guard) {
        const v = acc.getCell(cell.rowIdx, cell.binding);
        if (v !== '') {
          return { ok: false, msgKey: 'LBL00702', fallback: '_일자컬럼에서만 사용가능합니다.' };
        }
      }
      continue;
    }
    // BNPIn measure 아니거나 값 0/'' → skip (AS-IS L5564~5570).
    const measure = acc.getMeasure(cell.rowIdx);
    const qty = acc.getCell(cell.rowIdx, cell.binding);
    if (measure !== PR_MEASURE || qty === '0' || qty === '') continue;

    // 과거(실적) 구간 — 이번주 월요일 > 컬럼일자. AS-IS "실적 구간이 포함되어 있습니다." (.cs L5594).
    const ymd = ymdOf(cell.binding);
    if (Number(monday) > Number(ymd)) {
      return { ok: false, msgKey: 'LBL00703', fallback: '_실적 구간이 포함되어 있습니다.' };
    }

    itemIds.push(acc.getItemId(cell.rowIdx));
    scmSiteIds.push(acc.getScmSiteId(cell.rowIdx));
    domExps.push(acc.getDomExp(cell.rowIdx));
    fcstTypes.push(acc.getFcstType(cell.rowIdx));
    incoterms.push(acc.getIncoterms(cell.rowIdx));
    plantSiteIds.push(acc.getPlantSiteId(cell.rowIdx));
    projectCodes.push(acc.getProjectCode(cell.rowIdx));
    yyyymmdds.push(ymd);
    qtys.push(qty);
  }

  // 요청 내용 없음 — AS-IS "Request 할 내용이 없습니다." (.cs L5638).
  if (qtys.length === 0) {
    return { ok: false, msgKey: 'LBL00704', fallback: '_Request 할 내용이 없습니다.' };
  }
  // Model 중복 불가 — AS-IS "Model 은 중복될 수 없습니다." (.cs L5644).
  if (new Set(itemIds).size !== itemIds.length) {
    return { ok: false, msgKey: 'LBL00705', fallback: '_Model 은 중복될 수 없습니다.' };
  }
  // Project 동일 — AS-IS "Project 는 동일해야 합니다." (.cs L5652).
  if (new Set(projectCodes).size > 1) {
    return { ok: false, msgKey: 'LBL00706', fallback: '_Project 는 동일해야 합니다.' };
  }

  return {
    ok: true,
    action: 'Request_PR',
    request: {
      popupType: 'Request_PR',
      divisionId: '', // UI 가 분기 division 주입 (Request 는 모달 params 로 별도 전달)
      projectCode: projectCodes[0] ?? '',
      scmSiteId: scmSiteIds.join('^'),
      itemId: itemIds.join('^'),
      domExp: domExps.join('^'),
      fcstType: fcstTypes.join('^'),
      incoterms: incoterms.join('^'),
      plantSiteId: plantSiteIds.join('^'),
      yyyymmdd: yyyymmdds.join('^'),
      planQty: qtys.join('^'),
    },
  };
};

// ===== View_PR / Add_History / View_History — 단일 셀 (AS-IS L5695~5752) =====
//   조건: 정확히 1 셀 + measure='BNPIn' + D_ 컬럼.
const buildSingleCell = (
  action: PrContextAction,
  cells: PrCell[],
  acc: PrRowAccessor,
  opts?: PrContextOptions
): PrContextResult => {
  if (cells.length !== 1) {
    // AS-IS "{버튼명}버튼은 한 개의 셀만 선택할 수 있습니다." (.cs L5699 — 격차⑥ 버튼명 prefix).
    const btn = opts?.actionLabel ?? action.replace('_', ' ');
    return {
      ok: false,
      msgKey: 'LBL00707',
      fallback: `_${btn} 버튼은 한 개의 셀만 선택할 수 있습니다.`,
      msgParams: { btn },
    };
  }
  const cell = cells[0];
  if (acc.getMeasure(cell.rowIdx) !== PR_MEASURE) {
    // AS-IS "BNP In 메저행에서만 사용가능합니다." (.cs L5706).
    return { ok: false, msgKey: 'LBL00708', fallback: '_BNP In 메저행에서만 사용가능합니다.' };
  }
  if (!isDailyCol(cell.binding)) {
    // AS-IS "일자컬럼에서만 사용가능합니다." (.cs L5713).
    return { ok: false, msgKey: 'LBL00702', fallback: '_일자컬럼에서만 사용가능합니다.' };
  }
  return {
    ok: true,
    action,
    request: {
      popupType: action,
      projectCode: acc.getProjectCode(cell.rowIdx),
      scmSiteId: acc.getScmSiteId(cell.rowIdx),
      itemId: acc.getItemId(cell.rowIdx),
      domExp: acc.getDomExp(cell.rowIdx),
      fcstType: acc.getFcstType(cell.rowIdx),
      incoterms: acc.getIncoterms(cell.rowIdx),
      plantSiteId: acc.getPlantSiteId(cell.rowIdx),
      yyyymmdd: ymdOf(cell.binding),
      planQty: acc.getCell(cell.rowIdx, cell.binding),
    },
  };
};

// 메인 dispatcher — contextMenu 항목별 분기.
export const buildPrContextRequest = (
  action: PrContextAction,
  cells: PrCell[],
  acc: PrRowAccessor,
  opts?: PrContextOptions
): PrContextResult => {
  if (cells.length === 0) {
    // AS-IS "선택된 셀이 없습니다." (.cs L5519).
    return { ok: false, msgKey: 'LBL00709', fallback: '_선택된 셀이 없습니다.' };
  }
  if (action === 'Request_PR') return buildRequestPr(cells, acc, opts);
  return buildSingleCell(action, cells, acc, opts);
};

// Div40 여부 (키 컬럼 분기) — AS-IS L5571 (sDivision=='40' → ItemId40/ScmSiteId40).
export const isDiv40 = (divisionId: string): boolean => divisionId === DIVISION.MOBILITY;
