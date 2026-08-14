import { DataMap, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import { useCallback, useMemo, useRef, useState } from 'react';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type { ComboParam, RawFlexGridColumnConfig } from '@foundation/models';
import { useTabComboQueries } from '@shared/hooks';

/**
 * ⭐ DMF0005 화면 전용 그리드 셀 콤보 설정.
 *
 * 공통 DataGrid 는 컬럼 메타(cellCboDataTp)만 보고 콤보를 조회하므로 **파라미터가 필요한 콤보**는
 * 여기서 따로 조회해 편집 시점에 갈아끼운다. 대상 컬럼은 GRID_COMBO_PARAMS 에 한 줄 추가하면 된다.
 *
 * 왜 공통 `DataGrid.comboParams` 를 안 쓰나 — 그건 **그리드 단위**라 같은 그리드의 모든 콤보에
 * 같은 파라미터가 실린다. `@divisionId` 처럼 흔한 바인드명은 옆 컬럼(Sales Company 등) 콤보까지
 * 좁혀 0건으로 만들고, 0건이면 columnMapping.getDataMap 이 dataMap 을 undefined 로 반환해
 * **그 컬럼의 콤보 설정이 통째로 풀린다**. 컬럼 단위로 좁힐 수단이 없어 이 파일로 분리했다.
 *
 * 동작:
 *  · 화면 단일값(division)은 `divisionParam` 바인드명으로 그대로 싣는다.
 *  · 행마다 다른 값은 `rowParam` 으로 선언한다 — 그리드에 실린 **고유값마다 콤보를 1건씩** 조회해
 *    두고, beginningEdit 에서 그 행에 맞는 DataMap 으로 교체 · cellEditEnded 에서 원복한다.
 *  · **결과가 0건이어도 그대로 적용한다** — 그 조건에 고를 수 있는 값이 없다는 게 사실이므로
 *    드롭다운이 비는 게 맞다. 조회 전(undefined)에만 교체를 건너뛴다.
 *
 * ⚠ 추가 전 반드시 콤보 SQL 의 SELECT 절을 확인할 것. 좁힘 기준 컬럼(DIVISION_ID 등)을 **결과로도
 *   내려주는** 콤보라면 이 파일이 필요 없다 — 컬럼 메타 `attribute2 = '행컬럼:콤보컬럼'` 한 줄로
 *   columnMapping 이 행 단위로 걸러준다(FE 코드 0).
 * ⚠ 여기서 좁힌 목록은 드롭다운(편집) 후보만 바꾼다. 셀에 찍히는 라벨은 공통 DataGrid 의 전체
 *   목록을 그대로 쓰므로, 후보 밖 코드라도 라벨이 사라지지 않는다.
 * ⚠ "콤보가 풀린다"(셀이 코드 원문을 찍고 드롭다운이 빈 채 굳는) 사고는 좁힌 dataMap 이 컬럼에
 *   **남아버릴 때** 생긴다. cellEditEnded 뿐 아니라 **다음 beginningEdit 진입 시점에도** 원복한다 —
 *   Esc·포커스 이탈·행 삭제로 cellEditEnded 가 안 오는 경로가 있다.
 */

interface GridComboConfig {
  /** 화면 조회조건 division 을 실을 SQL 바인드명 (미지정 시 안 싣는다) */
  divisionParam?: string;
  /** 행 값에서 오는 파라미터 — rowBinding 컬럼의 값을 paramName 바인드로 싣는다 */
  rowParam?: { rowBinding: string; paramName: string };
}

/**
 * 컬럼 binding → 콤보 파라미터 규칙.
 *
 * SALES_PLANT (SCM_MST_PLANT_SN) — 결과가 PLANT_ID 두 컬럼(CODE/NAME)뿐이라 화면단에서 자를 근거가
 * 없다. 반드시 파라미터로 넘겨야 한다.
 *   SELECT A.PLANT_ID AS CODE, A.PLANT_ID AS NAME FROM SCM_MST_PLANT_SN A
 *   WHERE ((@divisionId IS NULL OR @divisionId='') OR A.DIVISION_ID = @divisionId)
 *     AND ((@companyId  IS NULL OR @companyId ='') OR A.COMPANY_ID  = @companyId)
 */
export const GRID_COMBO_PARAMS: Record<string, GridComboConfig> = {
  SALES_PLANT: {
    divisionParam: 'divisionId',
    rowParam: { rowBinding: 'SALES_COMPANY', paramName: 'companyId' },
  },
};

/**
 * 마스터 기준 division 코드.
 * 조회조건 division 은 `81_HM` / `81_ST` 같은 하위 코드까지 내려오지만 마스터 테이블(SCM_MST_*)은
 * 상위 코드(`81`) 기준이다. useSalesSiteProjectModelStore.fetchStaticColumns 와 같은 규칙.
 */
export const toMasterDivision = (divisionId?: string): string =>
  divisionId?.startsWith('81_') ? '81' : (divisionId ?? '');

/** BE makeComboQuery 는 raw 치환이라 문자열 값은 FE 에서 작은따옴표로 감싼다 */
const quote = (value: string): string => `'${value}'`;

const cellText = (value: unknown): string => (typeof value === 'string' ? value.trim() : '');

/**
 * 조회 결과가 없거나 아직 모르는 행 값일 때 끼워 넣는 빈 목록.
 * ⚠ 이 폴백이 없으면 `GRID_COMBO_PARAMS` 컬럼인데도 공통 DataGrid 의 **전체 목록**이 그대로 뜬다 —
 *   "파라미터로 걸러지는데 왜 전체를 띄우냐" 의 정체가 이거다. 좁힘 대상 컬럼은 전체를 보여주지 않는다.
 * 읽기 전용으로만 쓰므로 모듈 단위로 하나만 만들어 공유한다.
 */
const EMPTY_DATA_MAP = new DataMap([], 'CODE', 'NAME');

/** 콤보 조회 1건 — 어느 컬럼의 어느 행 값(rowKey)용인지 함께 들고 다닌다 */
interface ComboSlot {
  binding: string;
  /** rowParam 이 없는 컬럼과 행 값이 빈 행은 '' (파라미터 없이 조회한 기본 후보) */
  rowKey: string;
  key: string;
  param: ComboParam;
}

const buildSlots = (
  staticColumns: RawFlexGridColumnConfig[],
  data: WijmoRowItem[],
  division: string,
  /** 사용자가 방금 입력해 아직 `data` 배열엔 안 잡힌 행 값 — rowBinding 별로 모아 둔다 */
  editedRowKeys: Record<string, string[]>
): ComboSlot[] =>
  Object.entries(GRID_COMBO_PARAMS).flatMap(([binding, config]) => {
    const comboId = staticColumns.find(
      column =>
        column.colNm === binding &&
        column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO &&
        column.cellCboDataTp
    )?.cellCboDataTp;
    if (!comboId) return [];

    const baseParam: ComboParam = { comboId: String(comboId) };
    if (config.divisionParam) baseParam[config.divisionParam] = quote(division);

    const { rowParam } = config;
    if (!rowParam) {
      return [{ binding, rowKey: '', key: `${binding}|`, param: baseParam }];
    }

    // 그리드에 실린 고유값 + 사용자가 편집으로 새로 넣은 값 + 공란용 1건(미입력 행의 기본 후보).
    // ⚠ 편집값(editedRowKeys)이 반드시 필요하다 — wijmo 는 dataItem 을 제자리에서 고치므로
    //   `data` 배열 참조가 안 바뀐다. 그것만 보면 신규 입력한 회사코드로는 조회가 영영 안 나간다.
    const rowKeys = [
      '',
      ...new Set(
        [
          ...data.map(row => cellText(row[rowParam.rowBinding])),
          ...(editedRowKeys[rowParam.rowBinding] ?? []),
        ].filter(Boolean)
      ),
    ];
    return rowKeys.map(rowKey => ({
      binding,
      rowKey,
      key: `${binding}|${rowKey}`,
      param: { ...baseParam, [rowParam.paramName]: quote(rowKey) },
    }));
  });

interface UseGridCombosParams<T extends WijmoRowItem> {
  staticColumns: RawFlexGridColumnConfig[];
  data: T[];
  divisionId?: string;
}

/**
 * GRID_COMBO_PARAMS 에 선언된 컬럼의 셀 콤보를 파라미터로 좁혀 편집 시점에 적용한다.
 * 상·하단 그리드가 같은 규칙을 쓰므로 두 컴포넌트에서 그대로 호출한다.
 *
 * 반환값을 `<DataGrid {...useGridCombos(...)} />` 로 펼쳐 넣는다 — grid.beginningEdit.addHandler 로
 * 직접 붙이면 effect 가 도는 시점에 `gridRef.current` 가 아직 없을 수 있어 조용히 안 붙는다.
 * prop 으로 넘기면 wijmo react wrapper 가 컨트롤 생성 시점에 확실히 연결한다.
 */
export const useGridCombos = <T extends WijmoRowItem>({
  staticColumns,
  data,
  divisionId,
}: UseGridCombosParams<T>) => {
  const division = toMasterDivision(divisionId);

  // ⚠ wijmo 는 편집 결과를 dataItem 에 제자리로 써넣어 `data` 배열 참조가 안 바뀐다.
  //   그래서 방금 입력한 행 값은 아래 useMemo 가 못 본다 → 그 값으로는 콤보 조회가 영영 안 나간다.
  //   편집이 끝날 때 여기에 따로 모아 두어야 조회가 걸린다.
  const [editedRowKeys, setEditedRowKeys] = useState<Record<string, string[]>>({});

  const slots = useMemo(
    () => buildSlots(staticColumns, data, division, editedRowKeys),
    [staticColumns, data, division, editedRowKeys]
  );

  /** 새로 등장한 행 값을 조회 대상에 올린다 (이미 있으면 상태를 그대로 둬 재조회를 막는다) */
  const registerRowKey = useCallback((rowBinding: string, value: string) => {
    if (!value) return;
    setEditedRowKeys(prev =>
      prev[rowBinding]?.includes(value)
        ? prev
        : { ...prev, [rowBinding]: [...(prev[rowBinding] ?? []), value] }
    );
  }, []);

  // 같은 파라미터 조합이 여러 컬럼에 걸릴 수 있다 — 중복 queryKey 는 useQueries 경고를 낸다.
  const uniqueParams = useMemo(() => {
    const map = new Map<string, ComboParam>();
    slots.forEach(slot => {
      const paramKey = JSON.stringify(slot.param);
      if (!map.has(paramKey)) map.set(paramKey, slot.param);
    });
    return map;
  }, [slots]);

  const paramKeys = [...uniqueParams.keys()];
  const comboRows = useTabComboQueries({ filters: [...uniqueParams.values()] });

  // 조회 결과까지 포함한 서명 — 응답이 도착한 시점에만 DataMap 을 새로 만든다.
  // ⚠ 미응답(undefined)과 0건(null·[])을 반드시 구분한다. 둘 다 'x' 로 뭉개면 응답이 와도
  //   서명이 안 바뀌어 아래 useMemo 가 영영 재계산되지 않는다.
  const signature = paramKeys
    .map((key, i) => `${key}#${comboRows[i] === undefined ? 'x' : (comboRows[i]?.length ?? 0)}`)
    .join(',');
  const dataMaps = useMemo(() => {
    const byParamKey: Record<string, DataMap> = {};
    paramKeys.forEach((paramKey, i) => {
      const rows = comboRows[i];
      // 아직 응답 전(undefined)이면 만들지 않는다 — 로딩 중 빈 목록이 잠깐 보이는 걸 막는다.
      if (rows === undefined) return;
      // ⚠ 0건 응답은 `[]` 가 아니라 `null` 로 올 수 있다(BE selectList 가 null 을 그대로 실어보냄).
      //   `if (rows)` 로 거르면 0건일 때 교체가 통째로 안 일어나 전체 목록이 그대로 보인다.
      byParamKey[paramKey] = new DataMap(rows ?? [], 'CODE', 'NAME');
    });

    const byBinding: Record<string, Record<string, DataMap>> = {};
    slots.forEach(slot => {
      const dataMap = byParamKey[JSON.stringify(slot.param)];
      if (!dataMap) return;
      if (!byBinding[slot.binding]) byBinding[slot.binding] = {};
      byBinding[slot.binding][slot.rowKey] = dataMap;
    });
    return byBinding;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [signature]);

  const dataMapsRef = useRef(dataMaps);
  dataMapsRef.current = dataMaps;

  // 편집 중 교체해 둔 원래 dataMap (컬럼 인덱스와 함께 보관 → 편집이 끝나면 반드시 원복)
  const swappedRef = useRef<{ col: number; dataMap: DataMap | null } | null>(null);

  /**
   * 좁힌 dataMap 을 걷어내고 공통 DataGrid 가 만든 원래 목록으로 되돌린다.
   * 이게 한 번이라도 누락되면 그 컬럼은 좁힌 목록(때론 빈 목록)에 굳어 "콤보가 풀린" 상태가 된다.
   */
  const restoreDataMap = useCallback((sender: FlexGrid<T>) => {
    const swapped = swappedRef.current;
    if (!swapped) return;
    const column = sender.columns[swapped.col];
    if (column) column.dataMap = swapped.dataMap;
    swappedRef.current = null;
  }, []);

  const cellEditEnded = useCallback(
    (sender: FlexGrid<T>, args?: CellRangeEventArgs) => {
      restoreDataMap(sender);
      if (!args) return;

      // 파라미터로 쓰이는 행 값(Sales Company 등)을 방금 고쳤다면 그 값으로 콤보를 미리 조회해 둔다.
      // 그래야 바로 옆 Sales Plant 를 열었을 때 빈 목록이 아니라 좁혀진 목록이 보인다.
      const binding = sender.columns[args.col]?.binding ?? '';
      const isRowKeyBinding = Object.values(GRID_COMBO_PARAMS).some(
        ({ rowParam }) => rowParam?.rowBinding === binding
      );
      if (!isRowKeyBinding) return;

      const row = sender.rows[args.row]?.dataItem as WijmoRowItem | undefined;
      registerRowKey(binding, cellText(row?.[binding]));
    },
    [restoreDataMap, registerRowKey]
  );

  const beginningEdit = useCallback(
    (sender: FlexGrid<T>, args: CellRangeEventArgs) => {
      // cellEditEnded 가 안 온 채 다음 편집이 시작되는 경로가 있다(Esc·포커스 이탈·행 삭제 등).
      // 여기서 먼저 되돌려야 아래에서 좁힌 목록을 '원래 목록' 으로 잘못 보관하는 사고가 없다.
      restoreDataMap(sender);

      // 공통 DataGrid 의 편집 가능 판정(setEditableColumns)이 이미 막았으면 관여하지 않는다.
      if (args.cancel) return;

      const column = sender.columns[args.col];
      const binding = column?.binding ?? '';
      const config = GRID_COMBO_PARAMS[binding];
      if (!config) return;

      const row = sender.rows[args.row]?.dataItem as WijmoRowItem | undefined;
      const rowKey = config.rowParam ? cellText(row?.[config.rowParam.rowBinding]) : '';

      // 아직 조회가 안 걸린 행 값이면(붙여넣기·직접 입력 등으로 cellEditEnded 를 안 탄 경우) 여기서 올린다.
      if (config.rowParam) registerRowKey(config.rowParam.rowBinding, rowKey);

      // ⚠ 없으면 빈 목록. 조회 전이든 0건이든 **전체 목록만은 절대 보여주지 않는다** —
      //   여기서 return 해버리면 공통 DataGrid 의 전체 목록이 그대로 남는다.
      const dataMap = dataMapsRef.current[binding]?.[rowKey] ?? EMPTY_DATA_MAP;
      if (column.dataMap === dataMap) return;

      swappedRef.current = { col: args.col, dataMap: column.dataMap };
      column.dataMap = dataMap;
    },
    [restoreDataMap, registerRowKey]
  );

  return { beginningEdit, cellEditEnded };
};
