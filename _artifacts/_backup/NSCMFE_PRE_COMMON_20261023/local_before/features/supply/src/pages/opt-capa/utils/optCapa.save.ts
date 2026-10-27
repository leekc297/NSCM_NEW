import {
  COLUMN,
  DAILY_CAPA_SAVE_DEFAULT,
  DATE_DISPLAY_COLUMNS,
  EE_DIVISION_TOKEN,
  EE_UC_DIVISION_TOKEN,
  COATING_OPERATION_ID,
  MONTH_DISPLAY_COLUMNS,
  PRE_KEY_COLUMNS,
  PRE_KEY_DELIMITER,
  SHEETS,
  VALID_YN_DEFAULT,
  type GridSheet,
} from '../opt-capa.constants';
import type { GridRow } from '../opt-capa.types';

import { str } from './optCapa.candidates';

/**
 * 저장 payload 조립 — SAVE SP 8종의 `all_arguments`/`SCM_ADM_PROC_M` 실측 계약 이식(design 03 §4.3).
 *
 * 전 SP 가 `activeFlag` 로 시작하는 **컬럼별 `'^'`-결합 CLOB** + 마지막 `sesUserId`(VARCHAR) 규약이다.
 * 키명은 `SCM_ADM_PROC_M.COL_NM` **camelCase** 그대로다
 * (메모리 `scp-proc-m-colnm-is-camelcase`: snake `p_` 접두로 보내면 NULL 바인딩).
 *
 * ## 폴딩 주체는 FE 다 — BE 가 CLOB 을 접어주지 않는다 (2026-09-26 gap-resolve iter-1)
 * iter-1~4 는 `useProcMutation`(→ `{data:[rows]}` raw 전송)으로 보내고 "BE 가 컬럼별로 결합한다" 고
 * 적어 뒀는데 **틀렸다**. BE `GeneralServiceImpl.execBtn`(nscm-be:34-49)은
 * `DATA_TP_CD='JVARCHAR'` 인 컬럼만 `MapUtils.cvtJsonToJVarchar` 로 `data` 배열을 `'^'`-join 하고,
 * `'CLOB'` 은 접지 않고 `makeProcedure` 가 `#{COL_NM, mode=IN, jdbcType=CLOB}`
 * (`BaseService.java:670`)으로 **`params.get(COL_NM)` 을 그대로 바인드**한다.
 * `SCM_ADM_PROC_M` 실측(2026-09-26): SCP0126 SAVE 8종의 IN 파라미터가 `sesUserId` 1건(VARCHAR)을
 * 뺀 **전건 `CLOB`** 이다. 그래서 `{data:[rows]}` 로 보내면 `params` 에 `divisionId` 등의 키가 없어
 * **전 파라미터가 NULL 로 바인딩**되고, SP 본문 `P_SPLIT(P_X,'^',...)`(BODY:2923-2924)이 NULL 을
 * 쪼개 루프 0회로 끝난다 → 오류 없이 0건 저장 + 성공 토스트
 * (`05_runtime-parity.md` RP-1 / 메모리 `save-proc-per-column-caret-fold-fe`).
 *
 * 그래서 {@link buildFlatSavePayload} 가 컬럼별로 `'^'`-join 한 **평면 스칼라 객체**를 만들고
 * 호출부가 `apiClient.post('/{mnuId}/{shtNm}/SAVE/call-proc')` 로 직접 보낸다 — 자매 정본은
 * SCP0005 `distributionRoute.saveRequest.ts` · SCP0006 `projectRoute.plantSaveRequest.ts` 다.
 */

/** 컬럼별 `'^'` 결합 구분자 — SP 본문 `P_SPLIT(P_X, '^', ...)`(`PKG_SCP0126` BODY:2923-2924). */
export const SAVE_CLOB_DELIMITER = '^';

/**
 * 표시 포맷 → 저장 포맷 환원. `YYYY-MM-DD`→8자리 / `YYYY-MM`→6자리(design 03 §4.2).
 *
 * `-` 제거만으로는 부족하다 — AS-IS 는 `.Replace("-","").Substring(0,8)`(cs:1348·1374·1907·2188·2189·
 * 2466·2745·2746·3001·3002) / `Substring(0,6)`(cs:3214)로 **자릿수까지 절단**한다. Wijmo 날짜 셀이
 * 시각을 붙여 내려주면 14자 문자열이 그대로 SP 로 가므로 같은 절단을 이식한다(iter-3 감사 G3-16).
 */
export const toStoredDateValue = (binding: string, value: unknown): string => {
  const text = str(value);
  if (!text) return '';
  if (DATE_DISPLAY_COLUMNS.includes(binding)) return text.replace(/-/g, '').slice(0, 8);
  if (MONTH_DISPLAY_COLUMNS.includes(binding)) return text.replace(/-/g, '').slice(0, 6);
  return text;
};

/**
 * `PRE_KEY_VALUES` 파싱 — 시트별 순서는 GET SP 본문 실측값이다(`PRE_KEY_COLUMNS`).
 * 토큰이 부족하면 빈 문자열로 채운다(신규행은 컬럼 자체가 비어 있다).
 */
export const parsePreKeys = (sheet: GridSheet, row: GridRow): Record<string, string> => {
  const columns = PRE_KEY_COLUMNS[sheet];
  const tokens = str(row.PRE_KEY_VALUES).split(PRE_KEY_DELIMITER);
  const out: Record<string, string> = {};
  columns.forEach((column, index) => {
    out[column] = tokens[index] ?? '';
  });
  return out;
};

/**
 * 저장된 행인가 — `PRE_KEY_VALUES` 첫 토큰(= `DIVISION_ID`)이 비어 있지 않으면 저장된 행이다.
 * AS-IS Daily Capa 삭제 가드가 이 판정을 쓴다(cs:777 `pre_key_values.Split('|')[0] != ""`).
 */
export const isPersistedRow = (row: GridRow): boolean =>
  str(row.PRE_KEY_VALUES).split(PRE_KEY_DELIMITER)[0] !== '';

/**
 * 현재 키(저장 포맷) — 키 변경 검사(R-22)와 중복 검사가 같은 함수를 쓴다.
 * 날짜/월은 `PRE_KEY_VALUES` 와 같은 원본 포맷으로 환원해야 대조가 성립한다.
 */
export const currentKeyOf = (sheet: GridSheet, row: GridRow): string =>
  PRE_KEY_COLUMNS[sheet]
    .map(column => toStoredDateValue(column, row[column]))
    .join(PRE_KEY_DELIMITER);

/**
 * 전극(Electrode) Capa 행인가 — AS-IS `Save_DailyCapa` cs:1569
 * `division_id == "EE" || (division_id == "EE_UC" && operation_id == "E2000")`.
 *
 * 판정축은 **행의 `DIVISION_ID`** 이며 비교는 **완전일치**다(컬럼 표시 토글의 부분문자열
 * 비교와 다른 축 — `EE_DIVISION_TOKEN` 주석 참조). AS-IS 가 조회조건 변수가 아니라 셀 값을
 * 읽기 때문에 그대로 옮긴 것이고, "한 조회 결과에 여러 division 행이 섞여 내려온다" 는 근거는
 * **오측이었다**(iter-3 감사 G3-13 ③ 정정): `GET_DAILY_CAPA` 는 출력이 `DIVISION_ID = IC.DIVISION_ID`
 * (BODY:604)이고 필터가 `IC.DIVISION_ID = P_DIVISION_ID`(BODY:705)라 **전 행의 `DIVISION_ID` 가
 * 조회조건 division 과 항상 같다**. `XA/XB` 전개는 `ORG_DIVISION_ID` 축이다.
 *
 * 이 한 분기가 저장 경로 2곳을 동시에 가른다:
 *   · 필수검증 — 참이면 `M_MIN`·`LANE`·`WIDE_YN` 필수 / 거짓이면 `CAPA` 필수(cs:1573-1596·1654)
 *   · 기본값 주입 — 참이면 `CAPA='0.0'` / 거짓이면 나머지 3컬럼(cs:1599·1662-1664)
 * 두 곳이 갈리면 "필수라고 막고 나서 그 값을 덮어쓰는" 모순이 생기므로 **같은 함수**를 쓴다.
 *
 * 조건부 경고(iter-3 감사 G3-13 ④, 현 마스터 데이터로는 도달 불가): division 이 `EE_HD`/`EE_HG`/
 * `EE_HM`/`EE_ST` 이면 `CAPA` 가 메타 `DIVISION_ID` 블록4 로 숨겨지는데 이 함수는 거짓을 반환해
 * `CAPA` 를 필수로 요구한다 = 채울 수 없는 필수 셀. 지금은
 * `LOOKUP_TYPE='OPMZ_PLAN_OPERATION'` 의 `SEGMENT1` 이 `40/81/81_HG/81_UC/82/EE/EE_UC` 7종뿐이고
 * `GET_DAILY_CAPA` BODY:704 가 `B.SEGMENT1 = P_DIVISION_ID` 를 요구해 그 4 division 은 Daily Capa
 * 가 0행이라 발현하지 않는다. **그 lookup 에 4 division 이 등록되면 즉시 발현**한다.
 */
export const isElectrodeCapaRow = (row: GridRow): boolean => {
  const division = str(row[COLUMN.DIVISION_ID]);
  if (division === EE_DIVISION_TOKEN) return true;
  return (
    division === EE_UC_DIVISION_TOKEN && str(row[COLUMN.OPERATION_ID]) === COATING_OPERATION_ID
  );
};

/** 직전 키(원본 포맷) — 신규행이면 구분자만 남은 문자열이라 `currentKeyOf` 와 결코 같지 않다. */
export const previousKeyOf = (sheet: GridSheet, row: GridRow): string => {
  const keys = parsePreKeys(sheet, row);
  return PRE_KEY_COLUMNS[sheet].map(column => keys[column]).join(PRE_KEY_DELIMITER);
};

/**
 * 시트별 SAVE 파라미터 순서 — `SCM_ADM_PROC_M.COL_NM` 실측(ora.py 2026-09-25).
 * `pre*` 는 `PRE_KEY_VALUES` 파싱값이고, `sesUserId` 는 호출부가 세션에서 채운다.
 *
 * 주의: 여기 열거한 키는 **값 컬럼 ↔ 파라미터명** 대응표다. 순서는 BE 가 PROC_M `SORT_ORD` 로
 * 재정렬하므로 객체 키 순서에 의존하지 않지만, 누락·오타는 NULL 바인딩이 되므로 전건 명시한다.
 */
const VALUE_PARAM_BY_SHEET: Record<GridSheet, readonly { param: string; column: string }[]> = {
  [SHEETS.NO_WORK]: [
    { param: 'divisionId', column: 'DIVISION_ID' },
    { param: 'plantId', column: 'PLANT_ID' },
    { param: 'lineId', column: 'LINE_ID' },
    { param: 'operationId', column: 'OPERATION_ID' },
    { param: 'lineType', column: 'LINE_TYPE' },
    { param: 'noWorkDate', column: 'NO_WORK_DATE' },
    { param: 'offTime', column: 'OFF_TIME' },
    { param: 'type', column: 'NO_WORK_TYPE' },
    { param: 'desc', column: 'DESC' },
    { param: 'validYn', column: 'VALID_YN' },
    { param: 'fix', column: 'FIX' },
  ],
  [SHEETS.DAILY_CAPA]: [
    { param: 'divisionId', column: 'DIVISION_ID' },
    { param: 'plantId', column: 'PLANT_ID' },
    { param: 'lineId', column: 'LINE_ID' },
    { param: 'operationId', column: 'OPERATION_ID' },
    { param: 'itemId', column: 'ITEM_ID' },
    { param: 'yyyymm', column: 'YYYYMM' },
    { param: 'capa', column: 'CAPA' },
    { param: 'mMin', column: 'M_MIN' },
    { param: 'lane', column: 'LANE' },
    { param: 'wideYn', column: 'WIDE_YN' },
    { param: 'prdnOperRt', column: 'PRDN_OPER_RT' },
    { param: 'validYn', column: 'VALID_YN' },
  ],
  [SHEETS.SOP_EOP]: [
    { param: 'divisionId', column: 'DIVISION_ID' },
    { param: 'plantId', column: 'PLANT_ID' },
    { param: 'lineId', column: 'LINE_ID' },
    { param: 'operationId', column: 'OPERATION_ID' },
    { param: 'lineType', column: 'LINE_TYPE' },
    { param: 'itemId', column: 'ITEM_ID' },
    { param: 'type', column: 'TYPE' },
    { param: 'date', column: 'DATE' },
    { param: 'desc', column: 'DESC' },
    { param: 'validYn', column: 'VALID_YN' },
  ],
  [SHEETS.RAMP_UP]: [
    { param: 'divisionId', column: 'DIVISION_ID' },
    { param: 'plantId', column: 'PLANT_ID' },
    { param: 'lineId', column: 'LINE_ID' },
    { param: 'operationId', column: 'OPERATION_ID' },
    { param: 'lineType', column: 'LINE_TYPE' },
    { param: 'itemId', column: 'ITEM_ID' },
    { param: 'startDate', column: 'START_DATE' },
    { param: 'endDate', column: 'END_DATE' },
    { param: 'efcy', column: 'EFCY' },
    { param: 'desc', column: 'DESC' },
    { param: 'validYn', column: 'VALID_YN' },
  ],
  [SHEETS.RAMP_UP_ITVL]: [
    { param: 'divisionId', column: 'DIVISION_ID' },
    { param: 'plantId', column: 'PLANT_ID' },
    { param: 'lineId', column: 'LINE_ID' },
    { param: 'operationId', column: 'OPERATION_ID' },
    { param: 'lineType', column: 'LINE_TYPE' },
    { param: 'itemId', column: 'ITEM_ID' },
    { param: 'startDate', column: 'START_DATE' },
    { param: 'itvl1', column: 'ITVL1' },
    { param: 'efcy1', column: 'EFCY1' },
    { param: 'itvl2', column: 'ITVL2' },
    { param: 'efcy2', column: 'EFCY2' },
    { param: 'itvl3', column: 'ITVL3' },
    { param: 'efcy3', column: 'EFCY3' },
    { param: 'itvl4', column: 'ITVL4' },
    { param: 'efcy4', column: 'EFCY4' },
    { param: 'desc', column: 'DESC' },
    { param: 'validYn', column: 'VALID_YN' },
  ],
  [SHEETS.PREP_RT]: [
    { param: 'divisionId', column: 'DIVISION_ID' },
    { param: 'plantId', column: 'PLANT_ID' },
    { param: 'lineId', column: 'LINE_ID' },
    { param: 'operationId', column: 'OPERATION_ID' },
    { param: 'fromDate', column: 'FROM_DATE' },
    { param: 'toDate', column: 'TO_DATE' },
    { param: 'prepRt', column: 'PREP_RT' },
    { param: 'validYn', column: 'VALID_YN' },
  ],
  [SHEETS.UTIL_RT]: [
    { param: 'divisionId', column: 'DIVISION_ID' },
    { param: 'plantId', column: 'PLANT_ID' },
    { param: 'lineId', column: 'LINE_ID' },
    { param: 'operationId', column: 'OPERATION_ID' },
    { param: 'fromDate', column: 'FROM_DATE' },
    { param: 'toDate', column: 'TO_DATE' },
    { param: 'utilRt', column: 'UTIL_RT' },
    { param: 'validYn', column: 'VALID_YN' },
  ],
  [SHEETS.YLD_ELEC]: [
    { param: 'divisionId', column: 'DIVISION_ID' },
    { param: 'plantId', column: 'PLANT_ID' },
    { param: 'itemId', column: 'ITEM_ID' },
    { param: 'yyyymm', column: 'YYYYMM' },
    { param: 'elecPost', column: 'ELEC_POST' },
    { param: 'assy', column: 'ASSY' },
    { param: 'validYn', column: 'VALID_YN' },
  ],
};

/** `PRE_KEY_COLUMNS` 컬럼명 → `pre*` 파라미터명 (`DIVISION_ID` → `preDivisionId`). */
const toPreParamName = (column: string): string =>
  `pre${column
    .toLowerCase()
    .split('_')
    .map(token => token.charAt(0).toUpperCase() + token.slice(1))
    .join('')}`;

/**
 * Daily Capa 전용 저장 규칙 — AS-IS `Save_DailyCapa`(cs:1558-1686) 이식. 다른 7시트에는
 * 대응 코드가 **0건**이다(cs 전수 grep: `valid_yn == "" ? "Y"` 1건 / `Split('|')[0] == ""` 1건 —
 * 둘 다 이 메서드 안). 그래서 시트 분기를 함수 바깥이 아니라 호출부에 둔다.
 *
 * 정정(iter-3 감사 G3-1): 여기에 "`MSG00002` 4건도 전부 이 메서드 안" 이라 적혀 있었는데
 * **틀렸다** — 나머지 7시트는 공용 헬퍼 `DataUtil.checkRequiredOfSpread(siMain)`(라이브 7건,
 * cs:1311·1866·2089·2390·2648·2907·3160)가 헤더 라벨 `*` 전건을 필수검증하고 Daily Capa 만
 * 그 호출이 주석처리(cs:1572)돼 로컬 상호배타 4건을 쓴다. 필수검증 시트 분기는
 * `OptCapa.handleSave` 가 담당한다(공용 훅에 `staticColumns[sheet]` 전달).
 *
 * 1. `VALID_YN` 공백 → `'Y'`(cs:1558). I/M/D 분기 **바깥**이라 삭제행도 대상이다.
 * 2. 저장 이력이 없는 행은 `'M'` 이어도 `'I'` 로 보낸다(cs:1564). `GET_DAILY_CAPA` 가
 *    `SCP_OPMZ_DDLY_CAPA` 를 **OUTER JOIN** 하므로(PKG_SCP0126 BODY:694-699) 아직 저장되지 않은
 *    라인×품목×월 조합까지 행으로 내려오고, 그 행을 편집하면 `CRUD_TYPE` 이 `'M'` 이 된다.
 *    그대로 보내면 SAVE SP 가 UPDATE 0건으로 끝나 입력이 **조용히 사라진다**.
 * 3. 기본값 강제주입(cs:1599·1662-1664) — {@link isElectrodeCapaRow} 분기.
 */
const applyDailyCapaSaveRules = (row: GridRow, payload: Record<string, string>): void => {
  if (payload.validYn === '') payload.validYn = VALID_YN_DEFAULT;
  // 삭제행은 여기서 끝 — AS-IS 도 `if (action == FlagI || action == FlagM)` 안에서만 이어간다(cs:1561).
  if (payload.activeFlag === 'D') return;
  if (!isPersistedRow(row)) payload.activeFlag = 'I';
  if (isElectrodeCapaRow(row)) {
    payload.capa = DAILY_CAPA_SAVE_DEFAULT.CAPA;
    return;
  }
  payload.mMin = DAILY_CAPA_SAVE_DEFAULT.M_MIN;
  payload.lane = DAILY_CAPA_SAVE_DEFAULT.LANE;
  payload.wideYn = DAILY_CAPA_SAVE_DEFAULT.WIDE_YN;
};

/**
 * 저장 payload 1행 — `activeFlag` + 값 파라미터 + `pre*` + `sesUserId`.
 *
 * `activeFlag` 는 EditTracker 가 세운 `CRUD_TYPE` 그대로다(`'I'`/`'M'`/`'D'`) — 자체 행상태 필드를
 * 신설하지 않는다(convert-core §2.4). `'D'` 는 **물리 DELETE** 이므로 `deleteOnlyNew` 를 쓰지
 * 않는다(design 03 R-17 / hook #138 비대상). Daily Capa 만 `'M'→'I'` 재판정이 붙는다
 * ({@link applyDailyCapaSaveRules} 2번).
 */
export const buildSaveRow = (
  sheet: GridSheet,
  row: GridRow,
  sesUserId: string
): Record<string, string> => {
  const payload: Record<string, string> = { activeFlag: str(row.CRUD_TYPE) };
  for (const { param, column } of VALUE_PARAM_BY_SHEET[sheet]) {
    payload[param] = toStoredDateValue(column, row[column]);
  }
  const preKeys = parsePreKeys(sheet, row);
  for (const column of PRE_KEY_COLUMNS[sheet]) {
    payload[toPreParamName(column)] = preKeys[column];
  }
  if (sheet === SHEETS.DAILY_CAPA) applyDailyCapaSaveRules(row, payload);
  // 감사키 빈 문자열 금지(convert-core §2.5) — 세션 사용자를 그대로 싣는다.
  payload.sesUserId = sesUserId;
  return payload;
};

/**
 * 행별 payload 배열 — {@link buildFlatSavePayload} 의 중간 산출물이다.
 * `export` 하지 않는다(소비처가 이 파일뿐 — 참조 0건 export 금지, convert-core §4.2).
 */
const buildSavePayload = (
  sheet: GridSheet,
  rows: readonly GridRow[],
  sesUserId: string
): Record<string, string>[] => rows.map(row => buildSaveRow(sheet, row, sesUserId));

/**
 * 행별 payload 를 **컬럼별 `'^'`-결합 평면 객체**로 접는다 — SP 의 CLOB 계약(파일 상단 주석).
 *
 * 행 수만큼 토큰이 있어야 SP 루프가 맞으므로 값이 빈 행도 **빈 토큰으로 자리를 채운다**
 * (`join` 이 자동으로 처리한다 — 행을 건너뛰면 컬럼 간 인덱스가 어긋나 다른 행의 값이 섞인다).
 *
 * `sesUserId` 는 `SCM_ADM_PROC_M` 에서 유일한 `VARCHAR` 스칼라라 결합 대상이 아니다
 * (실측: 8 SAVE SP 전건 `SORT_ORD` 마지막 IN = `sesUserId` / `DATA_TP_CD='VARCHAR'`).
 * `call-proc`(=`execBtn`)은 세션 userId 를 주입하지 않으므로(주입은 `call-proc2` 전용)
 * FE 가 세션값을 직접 실어야 한다(메모리 `save-proc-per-column-caret-fold-fe`).
 */
export const buildFlatSavePayload = (
  sheet: GridSheet,
  rows: readonly GridRow[],
  sesUserId: string
): Record<string, string> => {
  const perRow = buildSavePayload(sheet, rows, sesUserId);
  const flat: Record<string, string> = {};
  // 키 집합은 행마다 동일하다(`buildSaveRow` 가 시트 계약으로 만든다) — 첫 행 기준으로 순회한다.
  for (const key of Object.keys(perRow[0] ?? {})) {
    if (key === 'sesUserId') continue;
    flat[key] = perRow.map(row => row[key] ?? '').join(SAVE_CLOB_DELIMITER);
  }
  flat.sesUserId = sesUserId;
  return flat;
};
