// SCP0125 저장 payload 조립 — 컬럼당 `^` 결합 CLOB 1파라미터(AS-IS `CString.AppendString`,
//   구분자 기본값 `'^'` = `GSCM/01.Framework/GSCM.Windows.Forms/Utility/CString.cs:583`).
//
// 왜 `useProcMutation` 이 아닌가: `SCM_ADM_PROC_M` 실측상 SAVE 4종의 IN 파라미터는 전건 **CLOB
//   평면 파라미터**(activeFlag·divisionId·… 17/18/15/14개)다. BE `BaseService.makeProcedure` 는
//   `params.get(COL_NM)` 를 그대로 바인딩하고 **배열을 결합하지 않으므로**, `useProcMutation` 의
//   `{data: rows[]}` 본문으로는 전 파라미터가 NULL 바인딩된다. 같은 형태(SCP 도메인 `^` 결합)인
//   `capa-line-master` 선례대로 화면이 평면 파라미터를 조립해 `apiClient.post` 로 보낸다.
//
// 필수: `sesUserId` 는 FE 가 직접 싣는다. `/call-proc` 경로는 세션을 주입하지 않는다
//   (`GeneralController.call-proc` 에 `sesUserId` put 이 없다 — 주입하는 쪽은 `call-proc2` 뿐이고,
//    `BaseService.makeProcedure` 는 `params.get(COL_NM)` 를 그대로 바인딩한다). 빼면 SP 의
//   `P_USER_ID` 가 NULL 바인딩되어 원장 감사컬럼이 NULL 로 적재된다.
//   주의: `sesUserId` 만 `DATA_TP_CD='VARCHAR'` **스칼라**다(나머지 IN 은 전건 CLOB = 행축 `^` 결합).
//   행 수만큼 `^` 로 이어 붙이면 SP 가 그 문자열 전체를 한 사용자 ID 로 받는다 — 1회만 싣는다.
//   실측: `SCM_ADM_PROC_M` 4 SAVE 전건 마지막 IN = `sesUserId`/VARCHAR · `PKG_SCP0125` spec
//   LINE 145·168·194·216 = `P_USER_ID IN VARCHAR2`.
//
// AS-IS 근거: cs:1073~1088(MKT FCST) · cs:1409~1426(STOCK) · cs:1670~1684(Elec. Demand) ·
//             cs:1932~1945(2nd OCV) · 강제값 cs:1229~1248

import dayjs from 'dayjs';

import { COL, DIVISION_CODE, NOT_APPLICABLE, TABS } from '../workbench.constants';

const DELIMITER = '^';

const str = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

/** AS-IS `due_date.Replace("-","").Substring(0,8)` — 로케일 의존 없이 `YYYYMMDD` 8자로 고정(U6). */
export const toYyyymmdd = (value: unknown): string => {
  if (value instanceof Date) return dayjs(value).format('YYYYMMDD');
  const text = str(value).trim();
  if (!text) return '';
  const digits = text.replace(/[^0-9]/g, '');
  if (digits.length >= 8) return digits.slice(0, 8);
  const parsed = dayjs(text);
  return parsed.isValid() ? parsed.format('YYYYMMDD') : digits;
};

/** 저장 대상 행 — `CRUD_TYPE` 전용 판정(자체 행상태 필드 신설 금지, convert-core §2.4). */
export const isDirtyRow = (row: Record<string, unknown>): boolean => {
  const crud = str(row.CRUD_TYPE);
  return crud === 'I' || crud === 'M' || crud === 'D';
};

/**
 * 기존행이 처음 수정된 경우 AS-IS 는 `action='I'` + `chgType='Change'` 로 승격한다
 * (최적화 테이블에 Insert 해야 하므로 — cs:1047~1051·1350·1612·1872).
 */
const promoteChange = (
  row: Record<string, unknown>
): { activeFlag: string; chgType: string } => {
  const crud = str(row.CRUD_TYPE);
  const chgType = str(row[COL.CHG_TYPE]).trim();
  if (crud === 'M' && chgType === '') return { activeFlag: 'I', chgType: 'Change' };
  return { activeFlag: crud, chgType };
};

/** 변경 없음 skip — `CHG_QTY`/`CHG_RSN` 가 `PRE_*` 와 같으면 저장 대상에서 제외(cs:1041 등). */
export const isUnchanged = (row: Record<string, unknown>): boolean =>
  str(row.CRUD_TYPE) === 'M' &&
  str(row[COL.CHG_QTY]) === str(row[COL.PRE_CHG_QTY]) &&
  str(row[COL.CHG_RSN]) === str(row[COL.PRE_CHG_RSN]);

/** STOCK 계열 강제값(03 §4.3 표) — 시트·division 조합으로 3컬럼이 셀값/`'-'` 로 갈린다. */
const stockForcedValues = (
  tab: TABS,
  row: Record<string, unknown>,
  divisionId: string
): { locationCode: string; lineId: string; beforeDegas: string } => {
  // Stock(Elec. Plant): locationCode 는 셀값, lineId·beforeDegas 는 '-' (cs:1238~1248)
  if (tab === TABS.STOCK_ELEC)
    return {
      locationCode: str(row[COL.LOCATION_CODE]),
      lineId: NOT_APPLICABLE,
      beforeDegas: NOT_APPLICABLE,
    };
  // STOCK + 81_UC: lineId·beforeDegas 는 셀값, locationCode 는 '-' (cs:1229~1234)
  if (divisionId === DIVISION_CODE.UC)
    return {
      locationCode: NOT_APPLICABLE,
      lineId: str(row[COL.LINE_ID]),
      beforeDegas: str(row[COL.BEFORE_DEGAS]),
    };
  // STOCK + 그 외: 3개 전부 '-' (cs:1242~1248)
  return {
    locationCode: NOT_APPLICABLE,
    lineId: NOT_APPLICABLE,
    beforeDegas: NOT_APPLICABLE,
  };
};

/** 저장 행 1건 → 파라미터명별 값. 파라미터명·순서는 `SCM_ADM_PROC_M` 실측(camelCase). */
const rowToParams = (
  tab: TABS,
  row: Record<string, unknown>,
  divisionId: string
): Record<string, string> => {
  const { activeFlag, chgType } = promoteChange(row);

  switch (tab) {
    case TABS.MKT_FCST:
      return {
        activeFlag,
        divisionId: str(row[COL.DIVISION_ID]),
        versionNo: str(row[COL.VERSION_NO]),
        cutoffYyyymmdd: str(row[COL.CUTOFF_YYYYMMDD]),
        // 소형(40)은 최종 저장 Project Code 를 PROJECT_CODE_40 으로 치환한다(cs:1025).
        projectCode:
          str(row[COL.DIVISION_ID]) === DIVISION_CODE.SMALL
            ? str(row[COL.PROJECT_CODE_40])
            : str(row[COL.PROJECT_CODE]),
        salesSiteId: str(row[COL.SCM_SITE_ID]),
        itemId: str(row[COL.ITEM_ID]),
        fcstType: str(row[COL.FCST_TYPE]),
        incoterms: str(row[COL.INCOTERMS]),
        plantSiteId: str(row[COL.PLANT_SITE_ID]),
        cellProdSiteId: str(row[COL.CELL_PROD_SITE_ID]),
        dueDate: toYyyymmdd(row[COL.DUE_DATE]),
        qty: str(row[COL.QTY]),
        chgQty: str(row[COL.CHG_QTY]),
        chgRsn: str(row[COL.CHG_RSN]),
        chgType,
      };

    case TABS.STOCK:
    case TABS.STOCK_ELEC: {
      const forced = stockForcedValues(tab, row, divisionId);
      return {
        activeFlag,
        divisionId: str(row[COL.DIVISION_ID]),
        stockType: str(row[COL.STOCK_TYPE]),
        cutoffYyyymmdd: str(row[COL.CUTOFF_YYYYMMDD]),
        projectCode: str(row[COL.PROJECT_CODE]),
        itemId: str(row[COL.ITEM_ID]),
        incoterms: str(row[COL.INCOTERMS]),
        fromSiteId: str(row[COL.FROM_SITE_ID]),
        scmSiteId: str(row[COL.SCM_SITE_ID]),
        locationCode: forced.locationCode,
        lineId: forced.lineId,
        beforeDegas: forced.beforeDegas,
        invDate: toYyyymmdd(row[COL.INV_DATE]),
        qty: str(row[COL.QTY]),
        chgQty: str(row[COL.CHG_QTY]),
        chgRsn: str(row[COL.CHG_RSN]),
        chgType,
      };
    }

    case TABS.ELEC_DEMAND:
      return {
        activeFlag,
        divisionId: str(row[COL.DIVISION_ID]),
        planStartYyyymmdd: str(row[COL.PLAN_START_YYYYMMDD]),
        planType: str(row[COL.PLAN_TYPE]),
        seq: str(row[COL.SEQ]),
        plantSiteId: str(row[COL.PLANT_SITE_ID]),
        lineId: str(row[COL.LINE_ID]),
        operationId: str(row[COL.OPERATION_ID]),
        itemId: str(row[COL.ITEM_ID]),
        yyyymmdd: toYyyymmdd(row[COL.YYYYMMDD]),
        qty: str(row[COL.QTY]),
        chgQty: str(row[COL.CHG_QTY]),
        chgRsn: str(row[COL.CHG_RSN]),
        chgType,
      };

    case TABS.STOCK_2ND_OCV:
      return {
        activeFlag,
        divisionId: str(row[COL.DIVISION_ID]),
        stockType: str(row[COL.STOCK_TYPE]),
        cutoffYyyymmdd: str(row[COL.CUTOFF_YYYYMMDD]),
        itemId: str(row[COL.ITEM_ID]),
        plantId: str(row[COL.PLANT_ID]),
        operationId: str(row[COL.OPERATION_ID]),
        secondOcvTime: str(row[COL.SECOND_OCV_TIME]),
        // NULL 허용 컬럼 — 공백이면 공백 그대로 보낸다(cs:1783·1818 IS NULL 분기와 등가).
        secondOcvDate: toYyyymmdd(row[COL.SECOND_OCV_DATE]),
        qty: str(row[COL.QTY]),
        chgQty: str(row[COL.CHG_QTY]),
        chgRsn: str(row[COL.CHG_RSN]),
        chgType,
      };
  }
};

/**
 * 저장 payload — 행축 파라미터는 컬럼별 `^` 결합 문자열, `sesUserId` 는 스칼라 1건.
 * 행이 0건이면 `undefined`.
 * 필수: 다행(2행 이상)일 때 행축 파라미터의 토큰 수가 모두 같아야 SP 가 행을 짝지을 수 있다.
 */
export const buildSavePayload = (
  tab: TABS,
  rows: Record<string, unknown>[],
  divisionId: string,
  sesUserId: string
): Record<string, string> | undefined => {
  if (rows.length === 0) return undefined;

  const accumulated: Record<string, string[]> = {};
  for (const row of rows) {
    const params = rowToParams(tab, row, divisionId);
    for (const [key, value] of Object.entries(params)) {
      const bucket = accumulated[key] ?? [];
      bucket.push(value);
      accumulated[key] = bucket;
    }
  }

  const payload: Record<string, string> = {};
  for (const [key, values] of Object.entries(accumulated)) payload[key] = values.join(DELIMITER);
  // 스칼라 — `^` 결합 대상이 아니다(위 헤더 주석). 감사키 빈문자열 금지라 호출부가 세션값을 보장한다.
  payload.sesUserId = sesUserId;
  return payload;
};
