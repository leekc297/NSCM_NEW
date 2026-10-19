import { useCallback, useMemo, useRef, useState } from 'react';

import type { ComboParam, ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import {
  insertComboId,
  isRowParamCombo,
  parseComboFilterBindings,
  rowParamKey,
  rowParamValue,
  rowParamValues,
} from '@foundation/utils';
import { useTabComboQueries } from '@shared/hooks';

import { GRID_COMBO_SRC } from './gridComboSrc';

/**
 * 컬럼 메타 PARAM10='D' 인 셀 콤보의 행 단위 조회 계층.
 * 여기는 조회까지다 — 결과로 DataMap 을 만드는 쪽은 foundation 의 getRowParamDataMap 이다.
 */

/** 조회 1건 — 어느 컬럼의 어느 행 조합인지 함께 들고 다닌다. */
interface RowParamSlot {
  binding: string;
  rowKey: string;
  param: ComboParam;
  /** 신규행 전용 콤보(PARAM9) 슬롯인가. 결과를 다른 버킷에 담는다. */
  forInsert?: boolean;
}

// 바인드 값 접기는 foundation 몫이다 — 한 바인드명에 행 컬럼이 여러 개 걸릴 수 있다
//   (40 의 END_CUSTOMER40). 규칙은 rowParamValues 주석 참조.
const buildParam = (
  comboId: string,
  bindings: Record<string, string>,
  rowItem: WijmoRowItem | undefined
): ComboParam => ({ comboId, ...rowParamValues(bindings, rowItem) });

const buildSlots = (
  columns: RawFlexGridColumnConfig[],
  touchedRows: Record<string, WijmoRowItem[]>
): RowParamSlot[] =>
  columns.filter(isRowParamCombo).flatMap(column => {
    const bindings = parseComboFilterBindings(column.attribute2);
    // 지연 조회 - 그리드에 실린 행 전체가 아니라 사용자가 닿은 행만 조회한다.
    //   금지: 여기에 itemsSource 를 다시 섞지 말 것. 조합 하나당 쿼리 하나라 행이 많으면
    //   응답이 시차를 두고 줄줄이 도착하고, 그때마다 DataGrid 가 columnGroups 를 새 배열로
    //   재대입해 wijmo 가 Column 을 통째로 다시 만든다(DataGrid 주석 '컬럼 폭' 참조).
    //   병합 헤더 화면에서 헤더가 눈에 띄게 흔들린다(2026-09-01 DMF0042 실측).
    const rows = touchedRows[column.colNm] ?? [];

    // PARAM9 가 있으면 같은 조합을 두 콤보로 각각 조회한다 - 신규행과 기존 행이 서로 다른
    //   SQL 을 보기 때문이다(2026-08-31 사용자 확정). PARAM2 는 공유하므로 조합 키는 같다.
    const forCombo = (comboId: string, forInsert: boolean): RowParamSlot[] => {
      const byKey = new Map<string, ComboParam>();
      // 공란 조합 1건 — 아직 값이 없는 행의 기본 후보.
      byKey.set(rowParamKey(bindings, undefined), buildParam(comboId, bindings, undefined));
      for (const row of rows) {
        const key = rowParamKey(bindings, row);
        if (!byKey.has(key)) byKey.set(key, buildParam(comboId, bindings, row));
      }
      return [...byKey].map(([rowKey, param]) => ({
        binding: column.colNm,
        rowKey,
        param,
        forInsert,
      }));
    };

    const insertId = insertComboId(column);
    return [
      ...forCombo(String(column.cellCboDataTp), false),
      ...(insertId ? forCombo(insertId, true) : []),
    ];
  });

interface UseRowParamCombosParams {
  /** 표시 중인 컬럼 메타 (D 컬럼만 골라 쓴다) */
  columns: RawFlexGridColumnConfig[];
  /** 그리드 시트명 — 행 조합 콤보 요청에도 sheetName 으로 실어 보낸다(그리드 콤보 규약, DataGrid 가 넘김). */
  sheetName?: string;
}

/**
 * 행 값 조합마다 콤보를 조회해 `컬럼 binding -> 조합 키 -> 후보 행` 으로 돌려준다.
 *
 * 지연 조회다 - 그리드에 실린 행을 미리 훑지 않고, 사용자가 닿은 행만 조회한다. 첫 조회는
 * 공란 조합 1건뿐이고 그 뒤로는 포커스가 닿을 때마다 1건씩 늘어난다. 셀에 보이는 이름은 이
 * 경로가 아니라 파라미터 없는 메타 콤보(column.dataMap)가 담당하므로, 조회 전 행도 코드가
 * 아니라 이름으로 보인다(foundation getRowParamDataMap 참조).
 *
 * PARAM2 `행컬럼:바인드명` 을 읽어 그 행의 값을 콤보 SQL 파라미터로 싣는다. 콤보 SQL 이
 * 좁힘 기준 컬럼을 결과로 안 내려주는 경우(CODE/NAME 두 컬럼만 주는 콤보)는 클라 필터로
 * 대체할 수 없어 이 경로가 유일한 수단이다.
 *
 * 실을 수 있는 것은 행 값뿐이다 — PARAM2 는 행 컬럼만 선언한다. 행과 무관한 화면 단위
 * 파라미터(mnuId 같은)를 요구하는 콤보는 이 경로의 대상이 아니다. 적을 자리가 없어 BE 가 그
 * 자리를 '' 로 치환한다. 반대로 행 컬럼으로도 존재하는 값이면 그 컬럼을 PARAM2 에 적으면 된다 —
 * SALES_PLANT 가 divisionId 를 행의 DIVISION_ID 에서 받는 식이고, 코드 정규화는 콤보 SQL 몫이다.
 *
 * 인용하지 않는다 — apiClient.getCombo 가 quoteComboParams 로 일괄 처리하고 idempotent 하다.
 * 공란도 키를 빼지 않고 '' 로 실어 보낸다. 토큰을 빼면 BE 가 '' 로 치환해 결과는 같은데
 * 캐시 키만 갈라져 같은 조합을 두 번 조회한다.
 */
export const useRowParamCombos = ({ columns, sheetName }: UseRowParamCombosParams) => {
  // 조회 대상 조합의 유일한 원천. 호출부(DataGrid)가 셀에 포커스가 닿는 시점·편집 진입·편집
  //   종료·붙여넣기에서 registerTouchedRow 로 담는다.
  //   itemsSource 를 안 보는 이유는 두 가지다. 하나는 비용(위 buildSlots 주석), 다른 하나는
  //   itemsSource 만으로는 어차피 부족하다는 점이다 - wijmo 가 dataItem 을 제자리 수정하는 경로
  //   (편집 결과 반영)와 GridAction.addRow 의 source.splice 경로(React state 를 안 건드려 렌더가
  //   아예 안 난다)는 렌더 시점의 data 에 안 잡힌다.
  // 정리하지 않는다 — 재조회로 데이터가 갈려도 여기 담긴 조합은 남는다. 데이터 참조가 바뀔 때
  //   비우는 방식이 자연스러워 보이지만 그러면 이 장치가 itemsSource 참조 안정성에 매이고,
  //   인라인 배열을 넘기는 호출부에서 매 렌더 초기화돼 조용히 죽는다. 남는 비용은 react-query
  //   가 캐시하는 조회 몇 건이라 그 위험보다 싸다.
  const [touchedRows, setTouchedRows] = useState<Record<string, WijmoRowItem[]>>({});

  const slots = useMemo(() => buildSlots(columns, touchedRows), [columns, touchedRows]);

  // 같은 파라미터 조합이 여러 컬럼에 걸릴 수 있다 — 중복 queryKey 는 useQueries 경고를 낸다.
  const uniqueParams = useMemo(() => {
    const map = new Map<string, ComboParam>();
    for (const slot of slots) {
      const paramKey = JSON.stringify(slot.param);
      if (!map.has(paramKey)) map.set(paramKey, slot.param);
    }
    return map;
  }, [slots]);

  const paramKeys = [...uniqueParams.keys()];
  // PARAM10='D' 행 조합 조회도 그리드 콤보다 - 같은 표식을 붙인다.
  const comboRows = useTabComboQueries({
    filters: [...uniqueParams.values()],
    src: GRID_COMBO_SRC,
    sheetName,
  });

  // 응답 상태 + 슬롯 구성 서명 — 둘 중 하나라도 바뀌면 아래 useMemo 를 다시 돌린다.
  //   주의: 미응답(undefined)과 0건(null·[])을 반드시 구분한다. 둘 다 'x' 로 뭉개면 응답이
  //   와도 서명이 안 바뀌어 영영 재계산되지 않는다.
  //   주의: 슬롯 구성도 서명에 넣는다. 서로 다른 슬롯이 같은 param 으로 접히면(같은 comboId 와
  //   같은 bindings 를 쓰는 D 컬럼이 둘) paramKeys 만으로는 구성 변화가 안 드러나, 나중에 붙은
  //   컬럼이 후보를 영영 못 받는다. 실패가 조용해서 추적이 오래 걸리는 종류다.
  const responseSignature = paramKeys
    .map((key, i) => `${key}#${comboRows[i] === undefined ? 'x' : (comboRows[i]?.length ?? 0)}`)
    .join(',');
  const slotSignature = slots
    .map(slot => `${slot.binding}|${slot.rowKey}|${slot.forInsert ? 'I' : ''}`)
    .join(',');
  const signature = `${responseSignature}::${slotSignature}`;

  const slotsRef = useRef(slots);
  slotsRef.current = slots;

  const { byBinding: rowParamRows, insertByBinding: insertRowParamRows } = useMemo(() => {
    const byParamKey: Record<string, ComboResponse[]> = {};
    paramKeys.forEach((paramKey, i) => {
      const rows = comboRows[i];
      // 아직 응답 전이면 키를 만들지 않는다 — 조회 전과 0건을 구분해야 한다.
      if (rows === undefined) return;
      // 0건 응답은 [] 가 아니라 null 로 올 수 있다(BE selectList 가 null 을 그대로 싣는다).
      byParamKey[paramKey] = rows ?? [];
    });

    const byBinding: Record<string, Record<string, ComboResponse[]>> = {};
    const insertByBinding: Record<string, Record<string, ComboResponse[]>> = {};
    for (const slot of slotsRef.current) {
      const rows = byParamKey[JSON.stringify(slot.param)];
      if (!rows) continue;
      const target = slot.forInsert ? insertByBinding : byBinding;
      if (!target[slot.binding]) target[slot.binding] = {};
      target[slot.binding][slot.rowKey] = rows;
    }
    return { byBinding, insertByBinding };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [signature]);

  const columnsRef = useRef(columns);
  columnsRef.current = columns;

  /**
   * 건드린 행의 조합을 조회 대상에 올린다. 슬롯의 유일한 원천이라 호출부는 네 시점에서 모두
   * 불러야 한다 — 포커스 이동 / 편집 진입 / 편집 종료 / 붙여넣기. 특히 포커스 이동에서 부르는
   * 것이 중요하다. 편집 진입에서만 부르면 조회가 편집 시작과 동시에 나가 드롭다운 첫 열림이
   * 빈 채로 뜬다(응답이 오면 채워지지만 한 박자 늦는다).
   *
   * 건드린 컬럼이 그 D 컬럼의 파라미터 원천이거나 D 컬럼 자신이면 등록한다. 자신도 받는 이유는
   * 사용자가 여는 것이 원천 셀이 아니라 D 컬럼일 수 있어서다 — 신규행에서 회사 코드를 비운 채
   * Sales Plant 를 바로 열면 그 행의 조합('81_HM','')이 슬롯에 없어 드롭다운이 빈 채로 뜬다.
   * 공란 슬롯은 전 컬럼이 공란인 조합('','')이라 대신 매칭되지 않는다.
   *
   * 이미 있는 조합이면 prev 를 그대로 돌려 재조회와 재렌더를 막는다. 편집 진입마다 불리므로
   * 이 가드가 없으면 셀을 열 때마다 렌더가 난다.
   */
  const registerTouchedRow = useCallback((touchedBinding: string, row: WijmoRowItem) => {
    setTouchedRows(prev => {
      let next = prev;
      for (const column of columnsRef.current.filter(isRowParamCombo)) {
        const bindings = parseComboFilterBindings(column.attribute2);
        if (!(touchedBinding in bindings) && touchedBinding !== column.colNm) continue;

        const key = rowParamKey(bindings, row);
        const existing = next[column.colNm] ?? [];
        if (existing.some(seen => rowParamKey(bindings, seen) === key)) continue;

        // 행 전체가 아니라 파라미터로 쓰는 값만 스냅샷으로 뜬다 — dataItem 을 그대로 들면
        //   wijmo 가 제자리 수정한 결과에 끌려다녀 조합이 뒤늦게 바뀐다.
        const snapshot: WijmoRowItem = {};
        for (const rowBinding of Object.keys(bindings)) {
          snapshot[rowBinding] = rowParamValue(row, rowBinding);
        }
        next = { ...next, [column.colNm]: [...existing, snapshot] };
      }
      return next;
    });
  }, []);

  return { rowParamRows, insertRowParamRows, registerTouchedRow };
};
