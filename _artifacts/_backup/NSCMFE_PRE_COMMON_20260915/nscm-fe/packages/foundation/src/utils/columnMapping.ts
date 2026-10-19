import type { Control } from '@mescius/wijmo';
import { DataType } from '@mescius/wijmo';
import { LinearGauge } from '@mescius/wijmo.gauge';
import { DataMap } from '@mescius/wijmo.grid';
import { InputDate, InputDateTime } from '@mescius/wijmo.input';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type {
  ComboResponse,
  FlexGridColumnConfig,
  RawFlexGridColumnConfig,
} from '@foundation/models';

// 신규행 판정은 mergeManager 의 공용 가드를 그대로 쓴다 - 같은 CRUD_TYPE='I' 기준이다.
import { isInsertRow } from './mergeManager';
import { safeString } from './string';

const alignMap = {
  L: 'left',
  R: 'right',
  C: 'center',
};

enum COLUMN_DEPTH {
  ONE_DEPTH = 1,
  TWO_DEPTH = 2,
  THREE_DEPTH = 3,
}

enum HEIGHT_BY_COLUMN_DEPTH {
  ONE_DEPTH = 48,
  TWO_DEPTH = 24,
  THREE_DEPTH = 16,
}

const getDataType = (ctrlType: CELL_CONTROL_TYPE): DataType | undefined => {
  switch (ctrlType) {
    case CELL_CONTROL_TYPE.NUMBER:
    case CELL_CONTROL_TYPE.NUMBER_TEXT:
      return DataType.Number;
    case CELL_CONTROL_TYPE.CHECKBOX:
      // TODO: 체크박스 디자인 조절 필요
      // 'Y'/'N' 원본값과 boolean 커밋값의 동치 판정은 EditTracker.isSameValue 에서 처리(값 매핑 해결).
      return DataType.Boolean;
    default:
      return undefined;
  }
};

const getFormat = (
  ctrlType: CELL_CONTROL_TYPE | undefined,
  scale: number | undefined
): string | undefined => {
  if (ctrlType === CELL_CONTROL_TYPE.NUMBER && scale) return `n${scale}`;
  if (ctrlType === CELL_CONTROL_TYPE.NUMBER_TEXT) return 'd0';

  // 🔽 날짜 관련 컨트롤 타입 포맷 추가
  const dateTypes = [
    CELL_CONTROL_TYPE.DATE,
    CELL_CONTROL_TYPE.DATE_MONTH,
    CELL_CONTROL_TYPE.DATE_TIME,
    CELL_CONTROL_TYPE.DATE_TEXT,
  ];
  if (dateTypes.includes(ctrlType!)) {
    return 'yyyy.MM.dd'; // ⭐ 원하는 출력 형식
  }

  return undefined;
};

const getEditor = (ctrlType: CELL_CONTROL_TYPE): Control | undefined => {
  switch (ctrlType) {
    // TODO: 테스트 필요, 투머치면 빼기
    case CELL_CONTROL_TYPE.PERCENT:
      return new LinearGauge(document.createElement('div'), {
        min: 0,
        max: 100,
      });
    // TODO: 날짜 버튼 디자인 조절 필요
    // DATE_TIME만 시분초 입력이 필요하다 — 나머지 날짜 타입에 InputDateTime을 쓰면 시분초
    // 목록(00:00~23:45)까지 같이 떠서 날짜만 있는 컬럼(SOP_DATE 등)에서도 시간을 고르게 된다.
    case CELL_CONTROL_TYPE.DATE_TIME:
      return new InputDateTime(document.createElement('div'), {
        format: 'yyyy-MM-dd HH:mm:ss',
        isReadOnly: false,
      });
    case CELL_CONTROL_TYPE.DATE:
    case CELL_CONTROL_TYPE.DATE_MONTH:
    case CELL_CONTROL_TYPE.DATE_TEXT:
      return new InputDate(document.createElement('div'), {
        format: 'yyyy-MM-dd',
        isReadOnly: false,
      });
    default:
      break;
  }

  return undefined;
};

/**
 * 셀 콤보 행 단위 필터 조건 (컬럼 메타 ATTRIBUTE2) 을 파싱한다.
 * 문법: `'행컬럼:콤보컬럼'`, 조건이 여럿이면 콤마로 잇는다.
 *   예) `'DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER'`
 * 형식에 안 맞으면 조건 전체를 버린다(= 필터 없음). 오타가 조용히 잘못 좁히는 것보다 안전하다.
 */
export const parseComboFilterBindings = (bindingString?: string): Record<string, string> => {
  if (!bindingString?.trim()) return {};

  const entries = bindingString.split(',').map(token => token.trim());
  if (entries.length === 0) return {};

  const result: Record<string, string> = {};

  for (const entry of entries) {
    if (!entry) return {};

    const bindingAndKey = entry.split(':');
    if (bindingAndKey.length !== 2) return {};

    const bindingOfRow = bindingAndKey[0].trim();
    const keyOfDataMap = bindingAndKey[1].trim();
    if (!bindingOfRow || !keyOfDataMap) return {};

    result[bindingOfRow] = keyOfDataMap;
  }

  return result;
};

/**
 * 신규행 전용 콤보 ID — 컬럼 메타 PARAM9(ATTRIBUTE9).
 *
 * 값이 있으면 신규행(CRUD_TYPE='I')에서만 cellCboDataTp 대신 이 콤보를 본다. 조회로 내려온
 * 행은 종전대로 cellCboDataTp 다. 방식(필터/재조회)은 양쪽 다 PARAM10 을 따르고 PARAM2 도
 * 공유한다 - 두 콤보가 같은 바인드명/결과 컬럼명을 쓴다는 뜻이다(2026-08-31 사용자 확정).
 *
 * 비면 '' 를 돌려준다 - 호출부는 그때 종전 경로와 완전히 같게 동작해야 한다.
 */
export const insertComboId = (column: RawFlexGridColumnConfig): string =>
  (column.attribute9 ?? '').trim();

/**
 * 행 파라미터 콤보 판정 — 컬럼 메타 PARAM10(ATTRIBUTE10) 이 'D' 인 콤보 컬럼.
 *
 * D 면 PARAM2 오른쪽이 "콤보 결과 컬럼명" 이 아니라 "콤보 SQL 바인드명" 으로 해석된다.
 * 같은 슬롯에 두 문법이 겹치므로 판정이 곧 해석 스위치다.
 *
 * D 로 등록됐어도 PARAM2 가 비었거나 형식이 틀리면 false 를 돌려 F 경로로 떨어뜨린다 —
 * 실을 파라미터가 없으면 재조회 자체가 성립하지 않는다. parseComboFilterBindings 가
 * "형식이 틀리면 조건 전체 폐기" 인 것과 같은 성격이다.
 */
export const isRowParamCombo = (column: RawFlexGridColumnConfig): boolean =>
  column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO &&
  !!column.cellCboDataTp &&
  (column.attribute10 ?? '').trim().toUpperCase() === 'D' &&
  Object.keys(parseComboFilterBindings(column.attribute2)).length > 0;

/** 행 파라미터 값 정규화 — 조회 파라미터와 조합 키가 같은 규칙을 쓰도록 한 곳에 둔다. */
export const rowParamValue = (rowItem: WijmoRowItem | undefined, binding: string): string =>
  safeString(rowItem?.[binding]).trim();

/**
 * 행 파라미터 콤보의 SQL 바인드 값 — PARAM2 의 `행컬럼:바인드명` 을 바인드명 기준으로 접는다.
 *
 * 한 바인드명에 행 컬럼을 여러 개 걸 수 있다. 같은 뜻의 값이 division 에 따라 다른 컬럼으로
 * 내려오는 경우가 있어서다 — End Customer 는 비40 이 END_CUSTOMER, 40 이 END_CUSTOMER40 이다.
 * 그때 PARAM2 를 `END_CUSTOMER:endCustomer,END_CUSTOMER40:endCustomer` 로 적으면 된다.
 *
 * 선언 순서대로 보다가 처음 채워진 값을 쓴다. 필수: 뒤 컬럼이 무조건 이기게 두면 그 컬럼이 빈
 * 행에서 바인드가 공란으로 나가 콤보가 통째로 비어 버린다(비40 행의 END_CUSTOMER40 이 그 경우다).
 * 전부 공란이면 '' 를 남긴다 — 키를 빼면 BE 가 어차피 '' 로 치환하는데 캐시 키만 갈라진다.
 *
 * Map 으로 접는 이유는 바인드명이 'constructor' 같은 Object 프로토타입 키일 때 plain object
 * 인덱싱이 값이 아니라 프로토타입 체인을 집기 때문이다.
 */
export const rowParamValues = (
  bindings: Record<string, string>,
  rowItem: WijmoRowItem | undefined
): Record<string, string> => {
  const values = new Map<string, string>();
  for (const [binding, bindName] of Object.entries(bindings)) {
    if (values.get(bindName)) continue;
    values.set(bindName, rowParamValue(rowItem, binding));
  }
  return Object.fromEntries(values);
};

// 구분자: 데이터에 나타나지 않는 제어문자(Unit Separator, \x1F). '|' 같은 문자를 쓰면
// ('A','BC') 와 ('AB','C') 가 같은 키로 뭉개진다.
const ROW_PARAM_KEY_SEPARATOR = '\x1F';

/**
 * 행 파라미터 조합 키 — PARAM2 선언 순서대로 행 값을 이어 붙인다.
 *
 * 조회 대상을 모을 때와 결과를 찾을 때가 반드시 이 함수를 함께 써야 한다. 규칙이 갈리면
 * 조회는 나갔는데 후보를 못 찾아 드롭다운이 영영 비는 상태가 된다.
 */
export const rowParamKey = (
  bindings: Record<string, string>,
  rowItem: WijmoRowItem | undefined
): string =>
  Object.keys(bindings)
    .map(binding => rowParamValue(rowItem, binding))
    .join(ROW_PARAM_KEY_SEPARATOR);

/** 행의 상위 셀이 아직 안 채워진 상태 (null / undefined / 공백문자열). */
const isBlankRowValue = (value: WijmoPrimitive): boolean =>
  value === null || value === undefined || (typeof value === 'string' && value.trim() === '');

/**
 * 행 컨텍스트로 콤보 후보를 좁힌다 — 드롭다운 후보와 값 유효성 판정의 **단일 기준**.
 * 표시(getDataMap)와 상위 변경 시 하위 값 정리(comboCascade)가 같은 함수를 써야 "드롭다운에 뜨는
 * 값 = 셀에 남을 수 있는 값" 불변식이 유지된다.
 */
export const filterComboRowsByRowItem = (
  comboRows: ComboResponse[],
  bindingString: string | undefined,
  rowItem: WijmoRowItem
): ComboResponse[] => {
  const filters = Object.entries(parseComboFilterBindings(bindingString));
  if (filters.length <= 0) return comboRows;

  return comboRows.filter(comboRow =>
    filters.every(([bindingOfRow, keyOfDataMap]) => {
      // 행의 상위 값이 비어 있으면 그 조건만 건너뛴다 — 아직 안 고른 상위 컬럼(End Customer 등)이
      // 후보를 0건으로 만들면 하위 콤보를 영영 못 여는 교착이 된다. 상위를 고르면 그때부터 좁혀진다.
      // 주의: 좁힘은 조건 단위다. Division 처럼 값이 항상 차 있는 조건은 그대로 엄격히 걸린다.
      if (isBlankRowValue(rowItem[bindingOfRow])) return true;
      return rowItem[bindingOfRow] === comboRow[keyOfDataMap];
    })
  );
};

/**
 * 화면이 코드로 든 cascade 표 1건 — 행 컬럼(rowKey) 값으로 콤보 응답 컬럼(comboKey)을 맞춘다.
 * 두 이름은 다를 수 있다 (행 END_CUSTOMER40 <-> 콤보 END_CUSTOMER 등).
 */
export interface ComboCascadeRule {
  rowKey: string;
  comboKey: string;
  /**
   * 콤보 쪽 값이 비어 있어도 통과시키지 않는다.
   * 상위를 고른 뒤에는 그 상위의 것만 보여야 하는 단계에서 켠다 (End Customer -> Sales Site).
   */
  strict?: boolean;
}

/**
 * 행 컨텍스트로 콤보 후보를 좁힌다 — 화면이 코드로 든 cascade 표를 적용하는 경로.
 *
 * 위 filterComboRowsByRowItem(컬럼 메타 attribute2 주도)과 규칙이 다르다. 여기에는 콤보 쪽 관대
 * 통과가 있다 — 콤보 행에 그 컬럼이 없거나 비어 있으면 통과시킨다(strict 면 통과시키지 않는다).
 * 필수: 이 관대 통과가 없으면 그 키를 안 내려주는 콤보(서버에서 이미 걸러 컬럼 자체가 없는 경우
 * 포함)에서 후보가 통째로 0건이 되어 드롭다운이 빈 채로 굳는다.
 * 행 쪽은 값이 비었거나 'ALL' 이면 그 조건을 건너뛴다.
 *
 * 돌려주기 전에 DIVISION_ID|CODE 로 중복을 제거한다. 콤보 SQL 이 부가 컬럼별로 같은 CODE 를 여러
 * 행 내려주면 드롭다운에 같은 항목이 반복되기 때문이다. division 을 키에 남겨 두는 것은 division
 * 컨텍스트가 다른 동명 코드까지 합치지 않기 위해서다.
 *
 * 새 화면은 이 함수보다 컬럼 메타 attribute2 를 먼저 검토할 것 — 콤보가 좁힘 기준 컬럼을 결과로도
 * 내려주고 표시 콤보와 편집 후보 콤보가 같다면 메타 한 줄로 끝나고 화면 코드가 필요 없다.
 */
export const filterComboRowsByCascade = <T extends Record<string, unknown>>(
  comboRows: T[],
  row: Record<string, unknown>,
  rules: readonly ComboCascadeRule[]
): T[] => {
  const filtered = comboRows.filter(comboRow =>
    rules.every(({ rowKey, comboKey, strict }) => {
      const rowValue = safeString(row[rowKey]).trim();
      if (rowValue === '' || rowValue === 'ALL') return true;
      const comboValue = safeString(comboRow[comboKey]).trim();
      return strict ? rowValue === comboValue : comboValue === '' || rowValue === comboValue;
    })
  );

  return [
    ...new Map(
      filtered.map(comboRow => [
        `${safeString(comboRow.DIVISION_ID)}|${safeString(comboRow.CODE)}`,
        comboRow,
      ])
    ).values(),
  ];
};

/** 상위 콤보를 바꾼 뒤 후보 밖으로 밀려난 하위 셀. 되돌릴 원본을 함께 돌려준다(EditTracker 기록용). */
export interface StaleComboCell {
  binding: string;
  previousValue: WijmoPrimitive;
}

/**
 * 상위 콤보 변경으로 더 이상 고를 수 없게 된 하위 셀을 찾는다.
 *
 * 불변식: 셀 값은 언제나 그 시점 드롭다운 후보 안에 있다. 후보 판정은 표시(getDataMap)와 똑같이
 * `filterComboRowsByRowItem` 을 쓴다 — 규칙이 갈리면 "드롭다운엔 없는데 셀엔 남아 있는" 값이 생긴다.
 *
 * 판정은 앞서 비운 결과를 반영해 이어간다 — 곧 사라질 값에 매달아 판정하면 안 된다.
 * 다만 상위를 비우면 그 조건이 풀려 후보가 넓어지므로, 비움이 또 다른 비움을 부르지는 않는다
 * (Team 변경 -> End Customer 이탈까지. 그때 Sales Site 는 End Customer 조건에서 풀려 유효하면 남는다).
 *
 * 값을 직접 지우지는 않는다. 호출부(DataGrid)가 EditTracker 기록과 함께 반영한다.
 */
export const findStaleComboCells = (
  columns: RawFlexGridColumnConfig[],
  /** 콤보 SQL_ID(cellCboDataTp) -> 조회된 rows. 미조회 컬럼은 키가 없거나 undefined. */
  comboRowsByComboId: Record<string, ComboResponse[] | undefined>,
  /** 편집이 끝난 행 (이미 새 값이 반영된 상태) */
  row: WijmoRowItem,
  /** 방금 바뀐 셀의 binding */
  changedBinding: string
): StaleComboCell[] => {
  // 콤보 + 필터 조건을 모두 갖춘 컬럼만 대상. 조건 없는 콤보는 상위와 무관하다.
  const dependents = columns
    .map(column => ({
      column,
      filterKeys: Object.keys(parseComboFilterBindings(column.attribute2)),
    }))
    .filter(
      ({ column, filterKeys }) =>
        column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO &&
        !!column.cellCboDataTp &&
        filterKeys.length > 0 &&
        // 행 파라미터 콤보는 PARAM2 오른쪽이 콤보 결과 컬럼이 아니라 SQL 바인드명이라
        //   이 판정(콤보 결과와 행 값 비교)이 성립하지 않는다. 재조회 결과로 판정하는
        //   경로는 아직 없으므로 대상에서 뺀다 — 종전 동작과 같다.
        !isRowParamCombo(column)
    );

  const stale: StaleComboCell[] = [];
  // 비운 값을 반영한 사본으로 뒤 컬럼 판정을 이어간다 (원본 row 는 호출부가 반영할 때까지 그대로).
  let context: WijmoRowItem = row;

  for (const { column, filterKeys } of dependents) {
    const binding = column.colNm;
    // 자기 자신은 대상이 아니다 (방금 고른 값을 스스로 지우면 안 된다).
    if (binding === changedBinding || !filterKeys.includes(changedBinding)) continue;

    const previousValue = context[binding];
    if (isBlankRowValue(previousValue)) continue;

    // 아직 콤보가 안 실린 컬럼은 판정 불가 — 미도착을 "후보 0건" 으로 오인해 지우면
    // 조회 직후 멀쩡한 값이 통째로 날아간다.
    const comboRows = comboRowsByComboId[column.cellCboDataTp as string];
    if (!comboRows) continue;

    const candidates = filterComboRowsByRowItem(comboRows, column.attribute2, context);
    if (candidates.some(candidate => candidate.CODE === previousValue)) continue;

    stale.push({ binding, previousValue });
    context = { ...context, [binding]: '' };
  }

  return stale;
};

/** findStaleRowParamComboCells 결과 — 지금 비울 셀과, 아직 판정 못 한(재조회 미도착) 하위 binding. */
export interface RowParamStaleResult {
  /** 새 후보에 없어 비울 하위 셀. */
  stale: StaleComboCell[];
  /** 재조회 결과가 아직 안 실려 판정을 미룬 하위 binding — 호출부는 다음 도착까지 대기한다. */
  awaiting: string[];
}

/**
 * 재조회형(PARAM10='D') 상위 콤보를 바꾼 뒤, 새 후보 밖으로 밀려난 하위 셀을 찾는다.
 *
 * findStaleComboCells 의 재조회형 대응판이다. 그쪽은 콤보 결과 컬럼과 행 값을 클라에서 비교하는
 * 필터형만 판정하고 행 파라미터 콤보는 제외한다 — 재조회형은 좁힘 기준이 콤보 결과 컬럼이 아니라
 * SQL 바인드라 그 비교가 성립하지 않기 때문이다. 여기서는 그 대신 실제 재조회 결과(rowParamRows)를
 * 후보로 삼는다.
 *
 * 후보 선정은 드롭다운(getRowParamDataMap.pickRowParamCandidates)과 **완전히 같은 규칙**이어야
 * "드롭다운에 뜨는 값 = 셀에 남을 수 있는 값" 불변식이 유지된다 — 조합 키는 rowParamKey, 버킷은
 * 신규행+PARAM9 후보가 있으면 insert 버킷, 아니면 기본 버킷.
 *
 * 재조회는 비동기다. 부모를 바꾼 직후엔 새 조합의 후보가 아직 안 왔을 수 있다(그 조합 키가 버킷에
 * 없음 = undefined). 그때는 비우지 않고 awaiting 으로 돌려, 호출부가 후보 도착 후 다시 부르게 한다.
 * 미도착을 "후보 0건"으로 오인해 비우면 방금 고른 값이 조회 사이에 날아간다.
 *
 * 값을 직접 지우지는 않는다. 호출부(DataGrid)가 EditTracker 기록과 함께 반영한다.
 */
export const findStaleRowParamComboCells = (
  columns: RawFlexGridColumnConfig[],
  /** 콤보 binding -> 행조합 키 -> 후보 (useRowParamCombos.rowParamRows). */
  rowParamByBinding: Record<string, Record<string, ComboResponse[]> | undefined>,
  /** PARAM9 신규행 버킷 (useRowParamCombos.insertRowParamRows). */
  insertRowParamByBinding: Record<string, Record<string, ComboResponse[]> | undefined>,
  /** 부모 셀을 바꾼 행 (이미 새 값이 반영된 상태). */
  row: WijmoRowItem,
  /** 방금 바뀐 셀의 binding. */
  changedBinding: string
): RowParamStaleResult => {
  const stale: StaleComboCell[] = [];
  const awaiting: string[] = [];

  for (const column of columns) {
    if (!isRowParamCombo(column)) continue;
    const binding = column.colNm;
    // 방금 바뀐 셀에 종속된 하위만 대상 — 자기 자신은 비우지 않는다.
    const bindings = parseComboFilterBindings(column.attribute2);
    if (binding === changedBinding || !(changedBinding in bindings)) continue;

    const previousValue = row[binding];
    if (isBlankRowValue(previousValue)) continue;

    // 드롭다운과 같은 버킷 선정: 신규행이고 PARAM9 후보가 실렸으면 insert 버킷, 아니면 기본 버킷.
    const insertBucket = insertRowParamByBinding[binding];
    const useInsert = isInsertRow(row) && !!insertBucket && Object.keys(insertBucket).length > 0;
    const bucket = useInsert ? insertBucket : rowParamByBinding[binding];

    const candidates = bucket?.[rowParamKey(bindings, row)];
    if (candidates === undefined) {
      awaiting.push(binding); // 재조회 결과 미도착 — 판정 보류
      continue;
    }
    if (candidates.some(candidate => candidate.CODE === previousValue)) continue;

    stale.push({ binding, previousValue });
  }

  return { stale, awaiting };
};

/**
 * 표시 목록 중복 제거 — CODE(TRIM) 기준 first-wins.
 *
 * 콤보 SQL 은 화면 표시용 CODE/NAME 외에 좁힘용 부가 컬럼(DIVISION_ID·TEAM_ID·END_CUSTOMER …)을
 * 같이 준다. 그래서 같은 CODE 가 부가 컬럼 값마다 여러 행으로 오고, 그리드에 그 부가 컬럼이 없으면
 * 행별로 더 좁힐 수도 없어 드롭다운에 같은 항목이 여러 번 뜬다
 * (NnMasterMapping SCM_SITE_ID = 콤보에 TEAM_ID 가 있는데 그리드엔 그 컬럼이 없다).
 *
 * NAME 이 아니라 CODE 로 합친다 — 서로 다른 CODE 가 같은 라벨을 쓰는 경우까지 합치면 고를 수 있는
 * 항목 자체가 사라진다.
 */
const dedupeComboRowsByCode = (comboRows: ComboResponse[]): ComboResponse[] => {
  const seen = new Map<string, ComboResponse>();
  for (const comboRow of comboRows) {
    const key = String(comboRow?.CODE ?? '').trim();
    if (!seen.has(key)) seen.set(key, comboRow);
  }
  return seen.size === comboRows.length ? comboRows : [...seen.values()];
};

/**
 * 표시 목록 정렬 갈래 — 숫자(0) / 영어(1) / 한글(2) / 그 외(3).
 * 첫 글자만 본다. '3공장' 은 숫자, 'Site 1' 은 영어, '가산' 은 한글이다.
 */
const displayNameGroup = (name: string): number => {
  const first = name.trim().charAt(0);
  if (/[0-9]/.test(first)) return 0;
  if (/[A-Za-z]/.test(first)) return 1;
  if (/[가-힣ㄱ-ㅎㅏ-ㅣ]/.test(first)) return 2;
  return 3;
};

/**
 * 표시 목록 정렬 — 숫자 -> 영어 -> 한글 -> 그 외, 같은 갈래 안에서는 사전순.
 *
 * 주의: 콤보 SQL 의 ORDER BY 를 덮어쓴다. 등록 순서 그대로 보여야 하는 콤보가 생기면 컬럼 메타
 * dataSortMthdCd(현재 미사용)를 조건으로 걸어 화면별로 가른다.
 * 순서만 바꿀 뿐 후보 집합은 그대로라, findStaleComboCells 의 값 유효성 판정과 어긋나지 않는다.
 */
const sortComboDisplayNames = (names: string[]): string[] =>
  [...names].sort((a, b) => {
    const groupGap = displayNameGroup(a) - displayNameGroup(b);
    if (groupGap !== 0) return groupGap;
    // numeric: 자릿수가 아니라 값으로 비교한다 ('3공장' < '10공장').
    // sensitivity base: 대소문자로는 순서를 가르지 않는다(같으면 원래 순서 유지).
    return a.localeCompare(b, 'ko', { numeric: true, sensitivity: 'base' });
  });

/**
 * 필터 방식(PARAM10 이 'D' 가 아님) 콤보의 DataMap.
 *
 * PARAM9 가 있으면 신규행만 그 콤보를 본다. 색인(CODE<->NAME)에는 두 콤보를 다 넣는다 -
 * 색인은 셀이 아니라 컬럼 단위라, 한쪽만 넣으면 다른 쪽 코드가 라벨 대신 코드 원문으로 뜨고
 * 고른 라벨을 코드로 되돌리지 못해 빈 값으로 커밋된다(getRowParamDataMap 과 같은 사정).
 * 기본 콤보를 앞에 둬 같은 CODE 의 표시명이 기본 기준으로 고정되게 한다.
 */
const getDataMap = (
  dataMap: ComboResponse[] | undefined,
  insertDataMap: ComboResponse[] | undefined,
  bindingString?: string
) => {
  const baseRows = dataMap ?? [];
  const insertRows = insertDataMap ?? [];
  const allRows = insertRows.length > 0 ? [...baseRows, ...insertRows] : baseRows;
  if (allRows.length === 0) return undefined;

  const wjDataMap = new DataMap(allRows, 'CODE', 'NAME');
  const hasRowFilter = Object.keys(parseComboFilterBindings(bindingString)).length > 0;

  // 손대는 것은 표시 목록뿐이다. 원본 행(collectionView.items)은 그대로 둬야 행별 좁힘 기준과
  //   부가 컬럼으로 CODE 를 되찾는 경로(sales-site resolveComboCodeByDivision)가 산다.
  // 필수 순서: 좁힘 -> 중복 제거 -> 정렬. 중복 제거를 좁힘보다 앞에 두면 부가 컬럼별 행이 사라져
  //   cascade 가 깨진다 (CustomDropdown dedupeOptions 와 같은 사정).
  wjDataMap.getDisplayValues = (rowItem?: WijmoRowItem) => {
    // rowItem 없이 부르는 경로(컬럼 필터 등)는 행을 모르므로 종전대로 기본 콤보 전량을 준다.
    //   PARAM9 후보가 그 목록으로 새면 안 된다 - 드롭다운은 항상 rowItem 과 함께 온다.
    const source = insertRows.length > 0 && isInsertRow(rowItem) ? insertRows : baseRows;
    return sortComboDisplayNames(
      dedupeComboRowsByCode(
        hasRowFilter && rowItem ? filterComboRowsByRowItem(source, bindingString, rowItem) : source
      ).map(item => item.NAME)
    );
  };

  return wjDataMap;
};

/**
 * 행 파라미터 콤보(PARAM10='D')의 DataMap.
 *
 * 전체 목록(파라미터 없는 메타 콤보)과 행별 조회 결과를 하나로 합친다.
 *   · 셀 라벨은 전체 목록이 담당한다 - 후보 밖 코드라도 이름이 안 깨진다.
 *   · 드롭다운 후보는 그 행 조합의 조회 결과만이다. 조회 전이든 0건이든 빈 목록이고,
 *     전체 목록이 후보로 새는 경로는 없다.
 *   · 라벨을 코드로 되돌리는 getKeyValue 도 이 합집합에서 찾는다 - 후보 행이 합집합에
 *     없으면 사용자가 고른 값이 빈 값으로 커밋된다.
 *
 * 합집합에서 전체 목록을 앞에 둔다. DataMap 내부 색인은 같은 CODE 중 첫 항목만 담으므로
 * 표시명이 메타 기준으로 고정된다.
 *
 * 금지: 편집 시점에 column.dataMap 을 갈아끼우지 말 것. dataMap 은 셀이 아니라 컬럼
 * 속성이라 그 컬럼 전 행이 좁혀진 맵을 탄다(2026-08-21 DMF0049 실사고).
 */
const getRowParamDataMap = (column: RawFlexGridColumnConfig): DataMap | undefined => {
  const bindings = parseComboFilterBindings(column.attribute2);
  const metaRows = column.dataMap ?? [];
  // 후보는 Map 스냅샷으로 고정한다. column.rowParamRows 를 살아 있는 참조로 들고 있으면
  //   DataMap 색인(아래 allRows 복사본)과 시점이 갈린다 - 생성 뒤 주입된 후보는 색인에 없어
  //   드롭다운에 이름 대신 코드 원문이 뜨고, 라벨을 코드로 되돌리지 못해 고른 값이 빈 값으로
  //   커밋된다. 두 축을 반드시 같은 스냅샷에서 뽑을 것.
  // 겸해서 plain object 인덱싱 위험도 사라진다 - 바인딩이 하나뿐인 컬럼은 조합 키에 구분자가
  //   없어 행 값이 그대로 키가 되는데, 그 값이 'constructor' 면 프로토타입 체인이 걸려 후보
  //   자리에 함수가 온다.
  const rowsByKey = new Map(Object.entries(column.rowParamRows ?? {}));
  // PARAM9 가 있으면 신규행은 이쪽 버킷에서만 후보를 뽑는다. 색인에는 양쪽을 다 넣는다.
  const insertRowsByKey = new Map(Object.entries(column.insertRowParamRows ?? {}));
  const allRows = [
    ...metaRows,
    ...[...rowsByKey.values()].flat(),
    ...[...insertRowsByKey.values()].flat(),
  ];
  if (allRows.length === 0) return undefined;

  const wjDataMap = new DataMap(allRows, 'CODE', 'NAME');

  // 신규행은 PARAM9 버킷에서만 후보를 뽑는다. 아직 안 실렸으면 기본 버킷이다.
  const pickRowParamCandidates = (rowItem: WijmoRowItem): ComboResponse[] => {
    const bucket = isInsertRow(rowItem) && insertRowsByKey.size > 0 ? insertRowsByKey : rowsByKey;
    return bucket.get(rowParamKey(bindings, rowItem)) ?? [];
  };

  wjDataMap.getDisplayValues = (rowItem?: WijmoRowItem) =>
    sortComboDisplayNames(
      dedupeComboRowsByCode(
        // rowItem 없이 부르는 경로(컬럼 필터 등)는 좁힐 근거가 없으므로 전량을 준다 -
        //   F 경로(getDataMap)와 같은 규칙이다. 드롭다운은 항상 rowItem 과 함께 오므로
        //   "후보에 전체 목록이 새면 안 된다" 규칙과 충돌하지 않는다.
        rowItem ? pickRowParamCandidates(rowItem) : allRows
      ).map(item => wjDataMap.getDisplayValue(item.CODE))
    );

  return wjDataMap;
};

/**
 * 콤보 컬럼의 DataMap 을 만든다 — 행 파라미터(PARAM10='D')면 getRowParamDataMap, 아니면 getDataMap.
 *
 * toLeafColumn 이 컬럼 config 에 dataMap 을 굽는 것과 같은 판정이다. 공용 DataGrid 는 columnGroups
 * 재대입(= Wijmo 전 컬럼 재생성 → 다단 헤더 흔들림)을 피하려고 구조는 columnGroups 로 한 번만 넘기고,
 * 콤보 데이터가 도착하면 이 함수로 만든 DataMap 을 `col.dataMap =` 로만 갈아끼운다. 그래서 같은 판정을
 * 컴포넌트에서도 쓸 수 있게 밖으로 뺀다.
 */
export const buildLeafColumnDataMap = (column: RawFlexGridColumnConfig): DataMap | undefined =>
  isRowParamCombo(column)
    ? getRowParamDataMap(column)
    : getDataMap(column.dataMap, column.insertDataMap, column.attribute2);

// ⭐ 라벨 끝 필수표시(`*`) 정규화 — AS-IS 잔재로 관리자 컬럼 메타의 라벨(colLblNm)에 `*` 가 그대로
//   박혀 있는 화면(DMF0082 등)이 있다. 디자인 표준은 헤더 라벨 앞 빨간점(`is-required`, _grid.scss)이라
//   `*` 로 등록된 화면만 표기가 달랐다. 라벨에서 `*` 를 떼고 `_requiredMark` 로 옮겨
//   inputTpCd=M/IM 로 등록된 화면(SalesSite 등)과 같은 빨간점으로 그린다.
//   ⚠️ `_inputEditType` 은 건드리지 않는다 — 편집가능 판정(gridUtils.isEditableCell)·팝업 아이콘의
//     입력이라, 라벨의 `*` 만 보고 승격하면 읽기전용 컬럼이 편집 가능해진다.
const REQUIRED_MARK_SUFFIX = /[*＊]\s*$/;

/** 라벨 끝이 필수표시(`*`)인가. */
export const hasRequiredMark = (label?: string): boolean => REQUIRED_MARK_SUFFIX.test(label ?? '');

/** 라벨 끝 필수표시(`*`)를 떼어낸 표시용 라벨. */
export const stripRequiredMark = (label?: string): string =>
  (label ?? '').replace(REQUIRED_MARK_SUFFIX, '').trimEnd();

/** 정규화된 raw 컬럼 — 라벨은 `*` 제거본, 원래 `*` 여부는 `_requiredMark` 로 보존. */
interface NormalizedRawColumn extends RawFlexGridColumnConfig {
  _requiredMark?: boolean;
}

// 그룹 라벨(sCls/lCls)까지 같은 규칙으로 벗겨야 한다 — getColumnDepth·그룹 매칭이 세 라벨의
// 문자열 동일성으로 단수/그룹을 판정하므로, 일부만 벗기면 그룹이 쪼개진다.
// undefined 는 undefined 로 유지 (THREE_DEPTH 의 `lClsLblNm ?? colLblNm` fallback 보존).
const normalizeRequiredMark = (column: RawFlexGridColumnConfig): NormalizedRawColumn => ({
  ...column,
  colLblNm: stripRequiredMark(column.colLblNm),
  sClsLblNm: column.sClsLblNm === undefined ? undefined : stripRequiredMark(column.sClsLblNm),
  lClsLblNm: column.lClsLblNm === undefined ? undefined : stripRequiredMark(column.lClsLblNm),
  _requiredMark: hasRequiredMark(column.colLblNm),
});

const getColumnDepth = (rawColumns: RawFlexGridColumnConfig[]) => {
  if (
    rawColumns.every(
      rawCol =>
        ((!rawCol.sClsLblNm || rawCol.sClsLblNm.trim() === '') &&
          (!rawCol.lClsLblNm || rawCol.lClsLblNm.trim() === '')) ||
        (rawCol.colLblNm === rawCol.sClsLblNm && rawCol.sClsLblNm === rawCol.lClsLblNm)
    )
  )
    return COLUMN_DEPTH.ONE_DEPTH;
  else if (
    rawColumns.every(
      rawCol =>
        !rawCol.lClsLblNm || rawCol.lClsLblNm.trim() === '' || rawCol.sClsLblNm === rawCol.lClsLblNm
    )
  )
    return COLUMN_DEPTH.TWO_DEPTH;

  return COLUMN_DEPTH.THREE_DEPTH;
};

const toLeafColumn = (column: NormalizedRawColumn): FlexGridColumnConfig => ({
  binding: column.colNm,
  header: column.colLblNm,
  align: alignMap[column.horzAlgnCd ?? 'L'],
  allowDragging: true,
  allowMerging: column.allowMerging ?? true,
  allowResizing: true,
  allowSorting: false,
  // TODO: 숫자 외의 다른 format 필요 시 추가 - 강민재
  format: getFormat(column.cellCtrlObjTpCd, column.scale),
  width: column.colWth,
  visible: column.visible,
  _inputEditType: column.inputTpCd,
  _requiredMark: column._requiredMark,
  _ctrlType: column.cellCtrlObjTpCd,
  _ctrlData: column.cellCboDataTp,
  _fixed: column.fixed,
  _uppercase: column.uppercase,
  _display: column.display,
  _personalizable: column.personalizable,
  _sClsLblNm: column.sClsLblNm,
  _lClsLblNm: column.lClsLblNm,
  dataMap: buildLeafColumnDataMap(column),
  isRequired: false, // TODO: 논의 필요..? -강민재
  editor: column.cellCtrlObjTpCd ? getEditor(column.cellCtrlObjTpCd) : undefined,
  dataType: column.cellCtrlObjTpCd ? getDataType(column.cellCtrlObjTpCd) : undefined,
  multiLine: column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.MULTILINE_TEXT,
  wordWrap: column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.MULTILINE_TEXT,
});

// 숫자 표시형식 판정 — 표준 숫자 서식(n3 / n0 / c2 / p1 / f2 …) 과 자리표시자 패턴('#,##0.###') 만.
//   'd' 는 숫자(정수)와 날짜(short date) 양쪽 의미라 제외하고, 날짜 패턴(yyyy-MM-dd 등)도 대상 밖이다.
const isNumericFormat = (format?: string): boolean => {
  if (!format) return false;
  return /^[ncpf]\d*$/i.test(format) || /^[#0][#0,.]*$/.test(format);
};

// Delete 키로 숫자 셀이 안 지워지던 문제 — Wijmo Column.isRequired 기본값 null 은
//   "String 이 아닌 컬럼(숫자/날짜/불리언)은 필수" 로 해석된다(Column.getIsRequired).
//   그리고 Delete 키 처리(_KeyboardHandler._deleteRange)는 `!col.getIsRequired(row)` 인 셀만 비운다
//   → isRequired 미지정 숫자 컬럼은 편집 가능해도 Delete 가 통째로 무시된다.
//   정적 컬럼은 toLeafColumn 이 isRequired:false 를 내려주지만, 화면이 직접 만드는 동적(주차/월)
//   컬럼은 미지정이라 동적 그리드 전 화면에서 Delete 가 먹지 않았다. leaf 에만 기본값을 채운다.
//   명시 지정(isRequired: true)은 그대로 둔다. 그룹 헤더는 binding 이 없어 대상 아님.
// 함께 `_dynamic` 을 표식한다 — 정적 컬럼과 구분이 필요한 공통 동작(헤더 클릭 정렬 제외)의 판정 기준.
//   컬럼의 allowSorting 은 F3 아이콘 토글용, 헤더 라벨은 관리자 메타(변경 가능)라 둘 다 쓸 수 없다.
// 숫자 컬럼인데 셀이 비어 있으면 입력값이 문자열로 저장되던 문제 — 숫자 format 이면 dataType 도 채운다.
//   Wijmo 는 Column.dataType 미지정 시 첫 행(items[0]) 값 하나로만 타입을 추론하고
//   (FlexGrid._updateColumnTypes), 그래도 못 정하면 GridPanel.setCellData 가 `dataType ||
//   getType(현재값)` 으로 대체한다. 편집하는 셀이 비어 있으면 getType(null)=Object 라 입력 문자열이
//   변환 없이 그대로 들어가, 같은 컬럼에 number 와 string 이 섞이고 서식(n3)도 안 먹는다.
//   동적(주차/월) 컬럼은 빈 셀이 흔해 이 경로를 상시로 탄다.
//   주의: dataType=Number 면 숫자로 못 바꾸는 입력은 Wijmo 가 커밋을 거부한다(쓰레기 문자열 차단).
//   명시 지정(dataType 직접 전달)은 그대로 둔다.
export const normalizeDynamicColumns = (columns: FlexGridColumnConfig[]): FlexGridColumnConfig[] =>
  columns.map(column =>
    column.columns
      ? { ...column, columns: normalizeDynamicColumns(column.columns) }
      : {
          ...column,
          isRequired: column.isRequired ?? false,
          ...(column.dataType == null && isNumericFormat(column.format)
            ? { dataType: DataType.Number }
            : {}),
          _dynamic: true,
        }
  );

export const mapRawColumnsToWijmoColumns = (
  sourceColumns: RawFlexGridColumnConfig[]
): Array<FlexGridColumnConfig> => {
  // 이후 depth 판정·그룹 매칭은 모두 정규화된 라벨 기준 (원본 `*` 라벨과 섞이면 그룹이 쪼개진다).
  const rawColumns = sourceColumns.map(normalizeRequiredMark);
  const columnDepth = getColumnDepth(rawColumns);

  const mappedResult: Array<FlexGridColumnConfig> = [];

  switch (columnDepth) {
    case COLUMN_DEPTH.ONE_DEPTH:
      rawColumns.forEach(rawColumn =>
        mappedResult.push({ ...toLeafColumn(rawColumn), height: HEIGHT_BY_COLUMN_DEPTH.ONE_DEPTH })
      );
      break;
    case COLUMN_DEPTH.TWO_DEPTH: {
      const smallGroups = [
        ...new Set(
          rawColumns.map(rawColumn =>
            rawColumn.sClsLblNm ? rawColumn.sClsLblNm : rawColumn.colLblNm
          )
        ).values(),
      ];
      smallGroups.forEach(smallGroupLabel =>
        mappedResult.push({
          header: smallGroupLabel,
          align: 'center',
          columns: [],
          height: HEIGHT_BY_COLUMN_DEPTH.TWO_DEPTH,
        })
      );

      rawColumns.forEach(rawColumn =>
        mappedResult
          .find(smallGroup =>
            rawColumn.sClsLblNm && rawColumn.sClsLblNm !== ''
              ? smallGroup.header === rawColumn.sClsLblNm
              : smallGroup.header === rawColumn.colLblNm
          )
          ?.columns?.push({ ...toLeafColumn(rawColumn), height: HEIGHT_BY_COLUMN_DEPTH.TWO_DEPTH })
      );

      break;
    }
    case COLUMN_DEPTH.THREE_DEPTH: {
      const largeGroups = [
        ...new Set(rawColumns.map(rawColumn => rawColumn.lClsLblNm ?? rawColumn.colLblNm)).values(),
      ];
      largeGroups.forEach(largeGroupLabel =>
        mappedResult.push({
          header: largeGroupLabel,
          align: 'center',
          columns: [],
          height: HEIGHT_BY_COLUMN_DEPTH.THREE_DEPTH,
        })
      );

      rawColumns.forEach(rawColumn => {
        const largeGroupLabel = rawColumn.lClsLblNm ?? rawColumn.colLblNm;
        const smallGroupLabel = rawColumn.sClsLblNm ?? rawColumn.colLblNm;

        const targetLargeGroup = mappedResult.find(
          largeGroup => largeGroup.header === largeGroupLabel
        );
        if (!targetLargeGroup?.columns) return;

        let targetSmallGroup = targetLargeGroup.columns.find(
          smallGroup => smallGroup.header === smallGroupLabel
        );
        if (!targetSmallGroup) {
          targetSmallGroup = { header: smallGroupLabel, align: 'center', columns: [] };
          targetLargeGroup.columns.push({
            ...targetSmallGroup,
            height: HEIGHT_BY_COLUMN_DEPTH.THREE_DEPTH,
          });
        }

        targetSmallGroup.columns?.push({
          ...toLeafColumn(rawColumn),
          height: HEIGHT_BY_COLUMN_DEPTH.THREE_DEPTH,
        });
      });

      break;
    }
    default:
      break;
  }

  return mappedResult;
};
