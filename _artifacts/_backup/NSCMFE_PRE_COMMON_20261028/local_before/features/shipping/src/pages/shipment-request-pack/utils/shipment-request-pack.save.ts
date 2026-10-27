import { CRUD_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
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

// 날짜 셀 값을 8자리 YYYYMMDD 로 정규화한다. FPDate 편집셀은 사용자가 날짜를 고르면 Date 객체를,
//   조회/직접입력이면 'YYYY-MM-DD'·'YYYY.MM.dd' 문자열을 담는다 — 두 경우 모두 8자리 숫자로 맞춘다
//   (str() 은 Date 객체를 '' 로 떨궈 저장 빈 날짜·필수오탐을 유발, 2026-10-21 실사고).
const ymd8 = (value: unknown): string => {
  if (value instanceof Date && !Number.isNaN(value.getTime())) {
    const y = value.getFullYear();
    const m = String(value.getMonth() + 1).padStart(2, '0');
    const d = String(value.getDate()).padStart(2, '0');
    return `${y}${m}${d}`;
  }
  return str(value).replace(/\D/g, '');
};

// 필수값 공란 판정 — null/undefined 또는 공백 문자열만 '없음'으로 본다. Date 객체(FPDate)·숫자(FPNumber)는
//   값이 있는 것으로 취급한다(str() 은 Date 를 '' 로 떨궈 Shipment Date 를 필수 오탐, 2026-10-21 실사고).
const isBlankValue = (value: unknown): boolean =>
  value === null || value === undefined || (typeof value === 'string' && value.trim() === '');

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

// 필수값 라벨 마크 — admin 메타 COLUMN_LABEL_NAME 끝의 '*'(전각 '＊' 포함) 가 필수 컬럼 표식이다
//   (공용 columnMapping.hasRequiredMark 동일 규약). 필수 집합을 코드로 하드코딩하지 않고 DB 메타에서 파생한다.
const REQUIRED_MARK = /[*＊]\s*$/;

/**
 * AS-IS `SaveData_Detail` 의 `DataUtil.checkRequiredOfSpread(siDetail)`(cs:1853) 이식 — 저장 대상 행의
 * 필수 셀(라벨 '*')이 하나라도 비면 저장을 막는다. 필수 컬럼은 admin 메타(SCM_MST_SHEET_COLUMNS
 * COLUMN_LABEL_NAME) 에서 파생하므로 메타 변경에 자동 추종한다(design 03 §1.3: Div/From Site/To Site/
 * Ship to/Model/FCST Type/Shipment Date/Qty/Trans Mode/Incoterms 10개가 '*' 필수).
 * 첫 결손 (행 인덱스·라벨·컬럼)을 돌려주고, 결손이 없으면 null.
 */
export const findFirstMissingRequiredDetail = (
  rows: RequestDetailRow[],
  columns: RawFlexGridColumnConfig[]
): { label: string; rowIdx: number; colNm: string } | null => {
  const required = columns.filter(c => REQUIRED_MARK.test(c.colLblNm ?? ''));
  for (let i = 0; i < rows.length; i++) {
    const record = rows[i] as unknown as Record<string, unknown>;
    for (const c of required) {
      if (isBlankValue(record[c.colNm])) {
        return { label: (c.colLblNm ?? c.colNm).replace(REQUIRED_MARK, '').trim(), rowIdx: i, colNm: c.colNm };
      }
    }
  }
  return null;
};

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
        // SAVE SP 의 V_YYYYMMDD 는 VARCHAR2(8) 라 8자리여야 한다. FPDate 가 Date 객체를 담든 구분자
        //   섞인 문자열('YYYY-MM-DD'·'YYYY.MM.dd')을 담든 ymd8 이 8자리 숫자로 정규화한다
        //   (하이픈만 제거하면 점 포맷이 10자로 남아 ORA-06502, Date 객체면 빈 날짜가 됨 — 2026-10-21 실사고).
        yyyymmdd: ymd8(record['YYYYMMDD']),
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
