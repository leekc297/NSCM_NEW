import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';

import type { CellRow, PackRow, RequestDetailRow } from '../shipment-request-pack.types';

import { parseDynamicColumnTag } from './shipment-request-pack.dynamicColumn';

// PKG_SSP0026.P_SSP0026_SAVE_SHIP_REQ_*(3종) 전건 실측 확정(ora.py ALL_SOURCE 조회,
//   SCM_ARR_SPL_VAL/SCM_ARR_SPL_CNT 구분자 C_DELIMITER, 2026-09-26) — design 03 §4.2 문서는
//   "콤마열"로 서술했으나 실제 배포된 PL/SQL 본문은 '^'를 쓴다(forecast-price.save.ts 동일 관례).
const DELIMITER = '^';

const str = (value: unknown): string => {
  if (value === null || value === undefined) return '';
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  return '';
};

/** Pack/Cell 저장 1 라인 = 변경된 pivot 셀(D_/W_/M_) 1개(§4.2 병렬 배열 원소, 행 단위 아님). */
export interface PivotCellChange {
  activeFlag: string;
  divisionId: string;
  itemId: string;
  fromSite: string;
  toSite: string;
  projectCode: string;
  incoterms: string;
  fcstType: string;
  transportMode: string;
  bodId: string;
  measure: string;
  yyyymmdd: string;
  qty: string;
  remark: string;
}

/**
 * EditTracker 가 추적한 변경 셀 중 D_/W_/M_ pivot 바인딩만 저장 라인으로 펼친다.
 * 한 행에 바뀐 날짜 칼럼이 여러 개면 그 수만큼 라인이 늘어난다(AS-IS CString.AppendString 1:1).
 */
export const collectPivotChanges = <T extends PackRow | CellRow>(
  rows: T[],
  tracker: EditTracker<T>,
  divisionId: string
): PivotCellChange[] => {
  const changes: PivotCellChange[] = [];
  const originals = tracker.getOriginalValues();
  rows.forEach(row => {
    const editItem = originals.get(row);
    if (!editItem) return;
    const record = row as unknown as Record<string, unknown>;
    Object.keys(editItem).forEach(binding => {
      const tag = parseDynamicColumnTag(binding);
      if (!tag) return;
      changes.push({
        activeFlag: row.CRUD_TYPE === CRUD_TYPE.INSERT ? CRUD_TYPE.INSERT : CRUD_TYPE.MODIFY,
        divisionId,
        itemId: str(record['MODEL_ID']),
        fromSite: str(record['FROM_SITE']),
        toSite: str(record['TO_SITE']),
        projectCode: str(record['PROJECT_CODE']),
        incoterms: str(record['INCOTERMS']),
        fcstType: str(record['FCST_TYPE']),
        transportMode: str(record['TR_MODE']),
        bodId: str(record['BOD_ID']),
        measure: str(record['MEASURE']),
        yyyymmdd: tag.yyyymmdd,
        qty: str(record[binding]),
        remark: str(record['REMARK']),
      });
    });
  });
  return changes;
};

const join = (changes: PivotCellChange[], key: keyof PivotCellChange): string =>
  changes.map(c => c[key]).join(DELIMITER);

/** P_SSP0026_SAVE_SHIP_REQ_PACK 파라미터(§4.2, ora.py args 실측 15 IN + O_RC1/O_RC2). */
export const buildSavePackPayload = (changes: PivotCellChange[], userId: string) => ({
  activeFlag: join(changes, 'activeFlag'),
  divisionId: join(changes, 'divisionId'),
  itemId: join(changes, 'itemId'),
  fromSite: join(changes, 'fromSite'),
  toSite: join(changes, 'toSite'),
  projectCode: join(changes, 'projectCode'),
  incoterms: join(changes, 'incoterms'),
  fcstType: join(changes, 'fcstType'),
  transportMode: join(changes, 'transportMode'),
  bodId: join(changes, 'bodId'),
  measure: join(changes, 'measure'),
  yyyymmdd: join(changes, 'yyyymmdd'),
  qty: join(changes, 'qty'),
  createdBy: userId,
  debugMode: 'N',
});

/** P_SSP0026_SAVE_SHIP_REQ_CELL — Pack과 동일 + p_remark(§4.2). */
export const buildSaveCellPayload = (changes: PivotCellChange[], userId: string) => ({
  ...buildSavePackPayload(changes, userId),
  remark: join(changes, 'remark'),
});

/** Request Detail(Pack) 저장 1 라인 = 변경된 행 1개(EditFlag 화이트리스트, §4.2). */
export interface RequestDetailChange {
  activeFlag: string;
  divisionId: string;
  itemId: string;
  fromSite: string;
  toSite: string;
  shiptoCode: string;
  incoterms: string;
  transportMode: string;
  fcstType: string;
  bodId: string;
  yyyymmdd: string;
  qty: string;
  remark: string;
  orderTypeDetail: string;
}

/** EditTracker 가 추적한 변경 행(신규 'I' 포함) 전건을 저장 라인으로 변환한다. */
export const collectRequestDetailChanges = (
  rows: RequestDetailRow[],
  tracker: EditTracker<RequestDetailRow>,
  divisionId: string
): RequestDetailChange[] => {
  const originals = tracker.getOriginalValues();
  return rows
    .filter(row => row.CRUD_TYPE === CRUD_TYPE.INSERT || originals.has(row))
    .map(row => {
      const record = row as unknown as Record<string, unknown>;
      return {
        activeFlag: row.CRUD_TYPE === CRUD_TYPE.INSERT ? CRUD_TYPE.INSERT : CRUD_TYPE.MODIFY,
        divisionId,
        itemId: str(record['MODEL_ID']),
        fromSite: str(record['FROM_SITE']),
        toSite: str(record['TO_SITE']),
        shiptoCode: str(record['SHIPTO_CODE']),
        incoterms: str(record['INCOTERMS']),
        transportMode: str(record['TR_MODE']),
        fcstType: str(record['FCST_TYPE']),
        bodId: str(record['BOD_ID']),
        yyyymmdd: str(record['YYYYMMDD']),
        qty: str(record['QTY']),
        remark: str(record['REMARK']),
        orderTypeDetail: str(record['ORDER_TYPE_DETAIL']),
      };
    });
};

const joinDetail = (changes: RequestDetailChange[], key: keyof RequestDetailChange): string =>
  changes.map(c => c[key]).join(DELIMITER);

/** P_SSP0026_SAVE_SHIP_REQ_DETAIL_PACK 파라미터(§4.2, ora.py args 실측 15 IN + O_RC1/O_RC2). */
export const buildSaveRequestDetailPayload = (changes: RequestDetailChange[], userId: string) => ({
  activeFlag: joinDetail(changes, 'activeFlag'),
  divisionId: joinDetail(changes, 'divisionId'),
  itemId: joinDetail(changes, 'itemId'),
  fromSite: joinDetail(changes, 'fromSite'),
  toSite: joinDetail(changes, 'toSite'),
  shiptoCode: joinDetail(changes, 'shiptoCode'),
  incoterms: joinDetail(changes, 'incoterms'),
  transportMode: joinDetail(changes, 'transportMode'),
  fcstType: joinDetail(changes, 'fcstType'),
  bodId: joinDetail(changes, 'bodId'),
  yyyymmdd: joinDetail(changes, 'yyyymmdd'),
  qty: joinDetail(changes, 'qty'),
  remark: joinDetail(changes, 'remark'),
  orderTypeDetail: joinDetail(changes, 'orderTypeDetail'),
  createdBy: userId,
  debugMode: 'N',
});

/**
 * O_RC1 1행 결과코드 계약 — PKG_SSP0026 SAVE_SHIP_REQ_PACK/_CELL/_DETAIL_PACK 3종 PL/SQL 본문
 * 실측 확정(ora.py ALL_SOURCE, 2026-09-26). design 03 §4.2 문서의 AS-IS 기반 S/N/X/Y 5분기 서술과
 * 달리, 실제 배포된 TO-BE 본문은 'N' 분기가 없고 코드별 2번째 컬럼 의미도 SP마다 다르다:
 *   - 'S' 성공 — 2번째 컬럼(MSG)은 항상 NULL.
 *   - 'X' BOD 정보 부적합 — 2번째 컬럼(REQUEST_NO)은 항상 NULL. MSG00293.
 *   - 'Y' (DETAIL_PACK 전용) 확정구간 경고 — 2번째 컬럼(CONFIRM_DAY)에 날짜 문자열. MSG00323.
 *   - 'F' 시스템 예외 — O_RC2 첫 행에 "[코드]메시지" 형식 상세.
 */
export interface SaveResultRow {
  RESULT_CODE?: string;
  [key: string]: string | number | null | undefined;
}
