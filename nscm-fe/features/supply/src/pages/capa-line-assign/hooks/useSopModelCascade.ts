import { useMemo } from 'react';

import { useTabComboQueries } from '@shared/hooks';

import {
  COMBO,
  DIVISION_EXCLUDE_ATTRIBUTE3,
  DIVISION_TYPE,
  ELTR_EXCLUDED_OPERATION,
  ELTR_LINE_TYPE_OPERATION,
  EMPTY_CODE,
  MASTER_COMBO_BY_DIVISION_TYPE,
  MENU_ID,
  OPERATION_COMBO_BY_DIVISION_TYPE,
  SHOP_GROUP_BY_DIVISION_TYPE,
  type DivisionType,
} from '../capa-line-assign.constants';
import type { ComboOption, ComboRow } from '../capa-line-assign.types';
import {
  distinctByCode,
  inSet,
  pickedSet,
  sortLineCodes,
  sortMasterCodes,
} from '../utils/capaLineAssign.cascade';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const rowsOf = (rows: readonly unknown[] | undefined): ComboRow[] => (rows ?? []) as ComboRow[];

/** P02 팝업 조회조건 6축의 현재 선택(멀티선택). `['ALL']`/빈 배열 = 전 후보. */
export interface SopModelSelection {
  divisionId: string;
  siteIds: string[];
  plantIds: string[];
  factoryIds: string[];
  lineIds: string[];
  operationIds: string[];
  electrodeTypes: string[];
}

/**
 * P02 `CAPA Line Assign Model` 팝업 전용 조회조건 cascade — **메인 조회조건 cascade의 팝업 판**.
 *
 * AS-IS `SCP0104_CAPA_Line_Assign_Model` 은 부모가 넘긴 8개 DataTable(`dtDivision`/`dtCapaLineMaster`/
 * `dtSiteAll`/…/`dtElectrodeAll`)을 `GetFilterSite/Plant/Factory/Line/Operation/ElectrodeType` +
 * `GetDistinctedCode` + `GetSortedCode` 로 걸러 `clbSite`~`clbElectrodeType` 체크리스트를 채운다
 * (..._Model.cs:548-616). 이는 메인 화면 cascade(`useCapaLineCascade`)와 **같은 필터 함수군**이다.
 *
 * 메인 훅은 store `searchParams` 에 강결합돼 있어 팝업이 그대로 쓰면 메인 조회조건을 오염시킨다
 * (팝업 선택이 메인 그리드 조회에 샌다). 그래서 로직은 같되 입력을 **인자(`sel`)로** 받는 독립 훅으로
 * 둔다. Version 계열(Plan Month/Version/Plan Type)은 팝업에 없다 — SP 가 `@p_version` 을 무시하고
 * 내부 `PROG_STAT='0'` MAX 버전을 쓰기 때문이다(design 03 §1.5 / §6-5, U-9).
 *
 * 콤보 원천은 메인과 동일한 마스터 1콤보(`DummyCapaLineMaster(EE)_SCP_ALL`) + Operation/LineType
 * 별개 가지다. 축별 종속 관계(함정 1: Operation 은 Site/Plant/Building/Line 에 종속되지 않는다)도
 * 메인과 같다(design 02 §3.3).
 */
export const useSopModelCascade = (sel: SopModelSelection, divisionType: DivisionType) => {
  const shopGroup = SHOP_GROUP_BY_DIVISION_TYPE[divisionType];

  // D01 Division — 권한군. 메인과 같은 콤보(`Division_SCP`, mnuId 필수).
  const [divisionRows] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }],
  });
  // 마스터 — `divisionType` 으로 SQL_ID 자체가 바뀐다(= 재조회).
  const [masterRowsRaw] = useTabComboQueries({
    filters: [MASTER_COMBO_BY_DIVISION_TYPE[divisionType]],
  });
  const [operationRowsRaw] = useTabComboQueries({
    filters: [OPERATION_COMBO_BY_DIVISION_TYPE[divisionType]],
  });
  const [electrodeRowsRaw] = useTabComboQueries({ filters: [COMBO.ELECTRODE_TYPE] });

  // ── Division (D01) — 이관 CMBO SQL 에 없는 클라 필터(EE 제외) 재현 ────────────────────
  const divisionOptions = useMemo<ComboOption[]>(
    () =>
      rowsOf(divisionRows)
        .filter(row => str(row.ATTRIBUTE3) !== DIVISION_EXCLUDE_ATTRIBUTE3)
        .map(row => ({ value: str(row.CODE), label: str(row.NAME) || str(row.CODE) }))
        .filter(option => !!option.value),
    [divisionRows]
  );

  const divisionLoaded = divisionRows !== undefined;
  const hasDivisionAuth = !divisionLoaded || divisionOptions.length > 0;

  // ── 마스터 파생 4축 ──────────────────────────────────────────────────────────────────
  //   `GetFilteredPackCell` — CELL=SHOP_GROUP_ID 'A', MODULE_PACK='P'. ELTR 은 EE 콤보라 추가 필터 없음.
  const masterRows = useMemo<ComboRow[]>(() => {
    const rows = rowsOf(masterRowsRaw);
    if (divisionType === DIVISION_TYPE.ELTR) return rows;
    return rows.filter(row => str(row.SHOP_GROUP_ID) === shopGroup);
  }, [masterRowsRaw, divisionType, shopGroup]);

  const siteSet = useMemo(() => pickedSet(sel.siteIds), [sel.siteIds]);
  const plantSet = useMemo(() => pickedSet(sel.plantIds), [sel.plantIds]);
  const factorySet = useMemo(() => pickedSet(sel.factoryIds), [sel.factoryIds]);
  const operationSet = useMemo(() => pickedSet(sel.operationIds), [sel.operationIds]);

  const inDivision = (row: ComboRow): boolean =>
    !sel.divisionId || str(row.DIVISION_ID) === sel.divisionId;

  // Plant/Building/Line 축 전용 shop_group 필터 — AS-IS `GetFilterPlant/Factory/Line`(`SHOP_GROUP_ID
  //   IN(_shop_group)`). CELL/PACK 은 masterRows 가 이미 shop 선필터돼 멱등, ELTR 은 EE 마스터의
  //   비-'E' 행(MI03 등)을 여기서 떨군다 — 안 걸면 ELTR Plant 가 7건 대신 8건(2026-11-18 실측,
  //   메인 useCapaLineCascade 와 동일). Site 에는 걸지 않는다(AS-IS Site = DIVISION 만).
  const inShopGroup = (row: ComboRow): boolean => str(row.SHOP_GROUP_ID) === shopGroup;

  const siteOptions = useMemo<ComboOption[]>(
    () => sortMasterCodes(distinctByCode(masterRows, 'SITE_ID', 'SITE_NAME', inDivision)),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, sel.divisionId]
  );

  const plantOptions = useMemo<ComboOption[]>(
    () =>
      sortMasterCodes(
        distinctByCode(
          masterRows,
          'PLANT_ID',
          'PLANT_NAME',
          row => inDivision(row) && inShopGroup(row) && inSet(siteSet, str(row.SITE_ID))
        )
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, sel.divisionId, siteSet, shopGroup]
  );

  // Building/Line 은 직속 부모(Plant/Building)뿐 아니라 **Site 로도 좁힌다**. AS-IS 는 Site 선택 시
  //   좁혀진 Plant 후보 CSV 를 `GetFilterFactory` 의 `_plant` 인자로 넘겨 Building 을 간접 종속시키는데,
  //   TO-BE 는 Site 변경 시 하위를 'ALL'(무필터)로 리셋하므로 plantSet 만 보면 Site 만 골라도 Building·
  //   Line 이 안 좁혀진다(메인 useCapaLineCascade 와 동일 보완, 2026-11-18). 마스터가 행마다 SITE_ID 를
  //   들고 있어 siteSet 직접 필터가 "그 Site 의 Plant 들" 슬라이스와 등가다(Site⊃Plant⊃Factory 계층).
  const factoryOptions = useMemo<ComboOption[]>(
    () =>
      sortMasterCodes(
        distinctByCode(
          masterRows,
          'FACTORY_ID',
          'FACTORY_NAME',
          row =>
            inDivision(row) &&
            inShopGroup(row) &&
            inSet(siteSet, str(row.SITE_ID)) &&
            inSet(plantSet, str(row.PLANT_ID))
        )
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, sel.divisionId, siteSet, plantSet, shopGroup]
  );

  const lineOptions = useMemo<ComboOption[]>(
    () =>
      sortLineCodes(
        sortMasterCodes(
          distinctByCode(
            masterRows,
            'LINE_ID',
            'LINE_NAME',
            row =>
              inDivision(row) &&
              inShopGroup(row) &&
              inSet(siteSet, str(row.SITE_ID)) &&
              inSet(plantSet, str(row.PLANT_ID)) &&
              inSet(factorySet, str(row.FACTORY_ID))
          )
        )
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, sel.divisionId, siteSet, plantSet, factorySet, shopGroup]
  );

  // ── Operation ────────────────────────────────────────────────────────────────────────
  //   함정 1: Operation 은 Site/Plant/Building/Line 에 종속되지 않는다(`GetFilterOperation` 하위 공백).
  const operationRows = useMemo<ComboRow[]>(() => {
    const rows = rowsOf(operationRowsRaw).filter(
      row => inDivision(row) && str(row.SHOP_GROUP_ID) === shopGroup
    );
    return divisionType === DIVISION_TYPE.ELTR
      ? rows.filter(row => str(row.CODE) !== ELTR_EXCLUDED_OPERATION) // Formation 제외(V-12)
      : rows;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [operationRowsRaw, sel.divisionId, shopGroup, divisionType]);

  const operationOptions = useMemo<ComboOption[]>(() => {
    const seen = new Map<string, { label: string; seq: number }>();
    for (const row of operationRows) {
      const code = str(row.CODE);
      if (!code || code === EMPTY_CODE || seen.has(code)) continue;
      seen.set(code, { label: str(row.NAME) || code, seq: Number(str(row.DISPLAY_SEQ)) || 0 });
    }
    return [...seen.entries()]
      .sort((a, b) => a[1].seq - b[1].seq)
      .map(([value, meta]) => ({ value, label: meta.label }));
  }, [operationRows]);

  // ── Line Type ──────────────────────────────────────────────────────────────────────
  //   모드 선필터(`GetElectrodeOperationFilter`) + 조회조건 Operation 선택(E08 cascade). CODE=NAME(V-14).
  const electrodeRows = useMemo<ComboRow[]>(() => {
    const rows = rowsOf(electrodeRowsRaw);
    const modeFiltered = rows.filter(row => {
      const operationId = str(row.OPERATION_ID);
      if (divisionType === DIVISION_TYPE.ELTR) return operationId === ELTR_LINE_TYPE_OPERATION;
      if (divisionType === DIVISION_TYPE.CELL) return operationId.charAt(0) === 'A';
      return operationId.charAt(0) === 'P';
    });
    return modeFiltered.filter(inDivision);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [electrodeRowsRaw, divisionType, sel.divisionId]);

  const electrodeTypeOptions = useMemo<ComboOption[]>(() => {
    const seen = new Map<string, number>();
    for (const row of electrodeRows.filter(row => inSet(operationSet, str(row.OPERATION_ID)))) {
      const code = str(row.CODE);
      // Line Type 은 `'-'` 를 후보에서 빼지 않는다 — AS-IS `GetFilterElectrodeType`(ScpCapaBL.cs:
      //   370-403)에 `CODE <> '-'` 가 없다(location 축의 `GetFilterDummySite` cs:414 에만 있음).
      //   `'-'` 는 유효 Line Type 이다(Operation A9000/AFFFF/P5500/P9500 의 유일값). 메인 화면
      //   useCapaLineCascade 와 동일 교정(2026-11-18). 빈 NAME 만 제외.
      if (!code || seen.has(code)) continue;
      seen.set(code, Number(str(row.DISPLAY_SEQ)) || 0);
    }
    return [...seen.entries()]
      .sort((a, b) => a[1] - b[1])
      .map(([value]) => ({ value, label: value }));
  }, [electrodeRows, operationSet]);

  /** Search 시 `'ALL'`/빈 선택을 펼칠 후보 코드 전체(getter 폴백 = 전 후보 CSV, design 02 §4.3). */
  const candidates = useMemo(
    () => ({
      siteIds: siteOptions.map(option => option.value),
      plantIds: plantOptions.map(option => option.value),
      factoryIds: factoryOptions.map(option => option.value),
      lineIds: lineOptions.map(option => option.value),
      operationIds: operationOptions.map(option => option.value),
      electrodeTypes: electrodeTypeOptions.map(option => option.value),
    }),
    [siteOptions, plantOptions, factoryOptions, lineOptions, operationOptions, electrodeTypeOptions]
  );

  return {
    divisionOptions,
    hasDivisionAuth,
    siteOptions,
    plantOptions,
    factoryOptions,
    lineOptions,
    operationOptions,
    electrodeTypeOptions,
    candidates,
  };
};
