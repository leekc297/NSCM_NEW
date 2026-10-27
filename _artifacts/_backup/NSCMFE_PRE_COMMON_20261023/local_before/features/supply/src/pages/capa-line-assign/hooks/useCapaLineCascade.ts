import { useMemo } from 'react';

import { useTabComboQueries } from '@shared/hooks';

import {
  ALL,
  COMBO,
  DIVISION_EXCLUDE_ATTRIBUTE3,
  DIVISION_TYPE,
  ELTR_EXCLUDED_OPERATION,
  ELTR_LINE_TYPE_OPERATION,
  EMPTY_CODE,
  MASTER_COMBO_BY_DIVISION_TYPE,
  MENU_ID,
  OPERATION_COMBO_BY_DIVISION_TYPE,
  PLAN_TYPE,
  SHOP_GROUP_BY_DIVISION_TYPE,
  type DivisionType,
} from '../capa-line-assign.constants';
import type { ComboOption, ComboRow } from '../capa-line-assign.types';
import { useCapaLineAssignStore } from '../useCapaLineAssignStore';
import type { CandidateCodes } from '../useCapaLineAssignStore';
import { sortLineCodes, sortMasterCodes } from '../utils/capaLineAssign.cascade';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const rowsOf = (rows: readonly unknown[] | undefined): ComboRow[] => (rows ?? []) as ComboRow[];

/** `'ALL'` 이거나 선택 0건이면 필터를 걸지 않는다(= 상위 단계 결과 전부). */
const pickedSet = (selected: string[]): Set<string> | null => {
  if (selected.includes(ALL)) return null;
  const picked = selected.filter(code => code && code !== ALL);
  return picked.length === 0 ? null : new Set(picked);
};

const inSet = (set: Set<string> | null, value: string): boolean => !set || set.has(value);

/** 마스터 축별 distinct — `DBUtils.GetDistinctTable(CODE, NAME)` + `DeleteEmptyName` 등가. */
const distinctByCode = (
  rows: ComboRow[],
  idKey: string,
  nameKey: string,
  accept: (row: ComboRow) => boolean
): ComboOption[] => {
  const seen = new Map<string, string>();
  for (const row of rows) {
    if (!accept(row)) continue;
    const code = str(row[idKey]);
    const name = str(row[nameKey]);
    // `CODE <> '-'` + 공백 제거(ScpCapaBL `DeleteEmptyName`) — design 02 §3.3.
    if (!code || code === EMPTY_CODE || !name) continue;
    if (!seen.has(code)) seen.set(code, name);
  }
  return [...seen.entries()].map(([value, label]) => ({ value, label }));
};

/**
 * 조회조건 cascade (design 02 §3·§5.4) — **전건 필터형**. 서버 재조회는 `divisionType` 1건뿐이다.
 *
 * `useCascadeFields` 를 쓰지 않는다: 그 훅은 "조인된 평면 콤보 1건" 전제인데 이 화면은 축별 SQL_ID 가
 * 3개(마스터 / Operation / LineType)로 나뉘고 Operation 이 상위에 종속되지 않는 비표준 그래프다.
 *
 * Site/Plant/Building/Line 4축은 **전용 콤보 SP 가 없다** — 마스터 1콤보
 * (`DummyCapaLineMaster(EE)_SCP_ALL`)를 축별 distinct 로 파생한다(AS-IS `ScpCapaBL
 * .GetDummyCapaLineMasterAll`, Roslyn `comboCalls` 미탐지분 X-E). 백본만 보고 "콤보가 없다"로
 * 판단하면 조회조건 4개가 통째로 빈다.
 */
export const useCapaLineCascade = () => {
  const sc = useCapaLineAssignStore(s => s.searchParams);
  const divisionType: DivisionType = sc.divisionType;
  const shopGroup = SHOP_GROUP_BY_DIVISION_TYPE[divisionType];

  // D01 Division — `mnuId` 필수. 미전달 시 권한군 ALL 로 열린다(design 02 §5.2 S01).
  const [divisionRows] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }],
  });
  // D02 CapaVersion — 전량 1회 조회 후 Plan Month / Version / Plan Type / PROG_STAT 4축을 클라 파생.
  const [versionRows] = useTabComboQueries({ filters: [COMBO.CAPA_VERSION] });
  // D07/D08 마스터 — `divisionType` 으로 SQL_ID 자체가 바뀐다(= queryKey 변경 = 재조회).
  const [masterRowsRaw] = useTabComboQueries({
    filters: [MASTER_COMBO_BY_DIVISION_TYPE[divisionType]],
  });
  // D04/D05 Operation, D06 Line Type — 마스터와 별개 가지(상위에 종속되지 않는다).
  const [operationRowsRaw] = useTabComboQueries({
    filters: [OPERATION_COMBO_BY_DIVISION_TYPE[divisionType]],
  });
  const [electrodeRowsRaw] = useTabComboQueries({ filters: [COMBO.ELECTRODE_TYPE] });
  // D09 Valid — `DataBind(Type.YesOrNo, true)` = ALL 선행 추가(cs:1737).
  const [validRows] = useTabComboQueries({ filters: [COMBO.VALID] });
  // 주의: `CapaProgressStatus_SCP_ALL`(CB03)·`YearFromThisYear_SCP_ALL`(CB08)은 호출하지 않는다 —
  //   전자는 곧바로 덮어써지는 죽은 로드, 후자는 바인딩 컨트롤이 Designer 에 없다(design 02 §2.3, V-27).

  // ── Division (D01) — 이관 CMBO SQL 에 없는 클라 필터 재현 ────────────────────────────
  const divisionOptions = useMemo<ComboOption[]>(
    () =>
      rowsOf(divisionRows)
        .filter(row => str(row.ATTRIBUTE3) !== DIVISION_EXCLUDE_ATTRIBUTE3)
        .map(row => ({ value: str(row.CODE), label: str(row.NAME) || str(row.CODE) }))
        .filter(option => !!option.value),
    [divisionRows]
  );

  /**
   * 권한 게이트(design 01 R-22 / 02 §4.4 A1) — 판정 시점은 **콤보 응답 도착 시 1회**다.
   * 응답 전(undefined)을 0건으로 오판하면 화면 진입마다 잠금이 번쩍인다 — 로딩과 0건을 구분한다.
   */
  const divisionLoaded = divisionRows !== undefined;
  const hasDivisionAuth = !divisionLoaded || divisionOptions.length > 0;

  // ── Version 계열 (D02) — 1회 조회의 클라 3단 파생. 추가 조회 금지(design 02 §5.2 S02·S03) ──
  const versionRowsForDivision = useMemo<ComboRow[]>(
    () => rowsOf(versionRows).filter(row => str(row.DIVISION_ID) === sc.divisionId),
    [versionRows, sc.divisionId]
  );

  const verIdOptions = useMemo<ComboOption[]>(() => {
    const seen = new Set<string>();
    const out: ComboOption[] = [];
    for (const row of versionRowsForDivision) {
      const code = str(row.CODE);
      if (!code || seen.has(code)) continue;
      seen.add(code);
      // 정렬은 콤보 SQL 의 `VER_ID DESC` 를 그대로 신뢰한다(기본 = 최신 Plan Month).
      out.push({ value: code, label: str(row.NAME) || code });
    }
    return out;
  }, [versionRowsForDivision]);

  const verSeqOptions = useMemo<ComboOption[]>(() => {
    const seen = new Set<string>();
    const out: ComboOption[] = [];
    for (const row of versionRowsForDivision) {
      if (str(row.CODE) !== sc.verId) continue;
      const seq = str(row.VER_SEQ);
      if (!seq || seen.has(seq)) continue;
      seen.add(seq);
      // ValueMember/DisplayMember 둘 다 VER_SEQ (cs:1556-1560).
      out.push({ value: seq, label: seq });
    }
    return out;
  }, [versionRowsForDivision, sc.verId]);

  /** 현재 Division+Version+VerSeq 조합의 원본 행 — Plan Type / PROG_STAT 의 단일 출처. */
  const currentVersionRow = useMemo<ComboRow | undefined>(
    () =>
      versionRowsForDivision.find(
        row => str(row.CODE) === sc.verId && str(row.VER_SEQ) === sc.verSeq
      ),
    [versionRowsForDivision, sc.verId, sc.verSeq]
  );

  // S04 Plan Type — 읽기전용 파생 표시(ScpCapaBL.cs:654-691). 매칭 행이 없으면 'RP'.
  const planType =
    str(currentVersionRow?.BIZ_PLAN_USE_YN) === 'Y' ? PLAN_TYPE.BIZ : PLAN_TYPE.ROLLING;

  /**
   * 컷오프 판정값 — `CapaVersion_SCP_ALL` 이 `PROG_STAT` 을 부가컬럼으로 실어 온다(실측 확정).
   * 별도 조회가 필요 없다. 실패 시 AS-IS 와 같이 `'0'`(Current, cs:1568-1588).
   */
  const progStat = str(currentVersionRow?.PROG_STAT) || '0';

  // ── 마스터 파생 4축 (D07/D08) ────────────────────────────────────────────────────────
  //   `GetFilteredPackCell`(ScpCapaBL.cs:35-42) — CELL 은 SHOP_GROUP_ID='A', MODULE_PACK 은 'P'.
  //   ELTR 은 EE 콤보 자체가 이미 전극 마스터라 추가 필터가 없다.
  const masterRows = useMemo<ComboRow[]>(() => {
    const rows = rowsOf(masterRowsRaw);
    if (divisionType === DIVISION_TYPE.ELTR) return rows;
    return rows.filter(row => str(row.SHOP_GROUP_ID) === shopGroup);
  }, [masterRowsRaw, divisionType, shopGroup]);

  const siteSet = useMemo(() => pickedSet(sc.siteIds), [sc.siteIds]);
  const plantSet = useMemo(() => pickedSet(sc.plantIds), [sc.plantIds]);
  const factorySet = useMemo(() => pickedSet(sc.factoryIds), [sc.factoryIds]);
  const operationSet = useMemo(() => pickedSet(sc.operationIds), [sc.operationIds]);

  const inDivision = (row: ComboRow): boolean =>
    !sc.divisionId || str(row.DIVISION_ID) === sc.divisionId;

  const siteOptions = useMemo<ComboOption[]>(
    () => sortMasterCodes(distinctByCode(masterRows, 'SITE_ID', 'SITE_NAME', inDivision)),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, sc.divisionId]
  );

  const plantOptions = useMemo<ComboOption[]>(
    () =>
      sortMasterCodes(
        distinctByCode(
          masterRows,
          'PLANT_ID',
          'PLANT_NAME',
          row => inDivision(row) && inSet(siteSet, str(row.SITE_ID))
        )
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, sc.divisionId, siteSet]
  );

  // 주의: Building 은 **Site 조건이 없다** — Plant 를 통한 간접 종속이다(`GetFilterFactory`, V-10).
  const factoryOptions = useMemo<ComboOption[]>(
    () =>
      sortMasterCodes(
        distinctByCode(
          masterRows,
          'FACTORY_ID',
          'FACTORY_NAME',
          row => inDivision(row) && inSet(plantSet, str(row.PLANT_ID))
        )
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, sc.divisionId, plantSet]
  );

  const lineOptions = useMemo<ComboOption[]>(
    () =>
      // `_A`/`_C` 접미 커스텀 정렬(SEQ1 그룹채번, `_C`→1 / `_A`→2) — 일반 정렬로 대체 불가(V-19).
      sortLineCodes(
        sortMasterCodes(
          distinctByCode(
            masterRows,
            'LINE_ID',
            'LINE_NAME',
            row =>
              inDivision(row) &&
              inSet(plantSet, str(row.PLANT_ID)) &&
              inSet(factorySet, str(row.FACTORY_ID))
          )
        )
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [masterRows, sc.divisionId, plantSet, factorySet]
  );

  // ── Operation (D04/D05) ──────────────────────────────────────────────────────────────
  //   함정 1(design 02 §3.3): Operation 은 Site/Plant/Building/Line 에 **종속되지 않는다**.
  //   AS-IS 는 `GetFilterDummyOperation` 의 하위 3인자를 공백으로 넘겨 라인 종속을 의도적으로
  //   해제했다 — 여기에 라인 필터를 더하면 AS-IS 보다 좁아지는 결함이다.
  const operationRows = useMemo<ComboRow[]>(() => {
    const rows = rowsOf(operationRowsRaw).filter(
      row => inDivision(row) && str(row.SHOP_GROUP_ID) === shopGroup
    );
    return divisionType === DIVISION_TYPE.ELTR
      ? rows.filter(row => str(row.CODE) !== ELTR_EXCLUDED_OPERATION) // Formation 제외(V-12)
      : rows;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [operationRowsRaw, sc.divisionId, shopGroup, divisionType]);

  const operationOptions = useMemo<ComboOption[]>(() => {
    const seen = new Map<string, { label: string; seq: number }>();
    for (const row of operationRows) {
      const code = str(row.CODE);
      if (!code || code === EMPTY_CODE || seen.has(code)) continue;
      seen.set(code, {
        label: str(row.NAME) || code,
        seq: Number(str(row.DISPLAY_SEQ)) || 0,
      });
    }
    return [...seen.entries()]
      .sort((a, b) => a[1].seq - b[1].seq) // `DBUtils.Sort(DISPLAY_SEQ ASC)`
      .map(([value, meta]) => ({ value, label: meta.label }));
  }, [operationRows]);

  // ── Line Type (D06) ──────────────────────────────────────────────────────────────────
  //   모드 선필터 = `GetElectrodeOperationFilter`(ScpCapaBL.cs:634-652).
  //   CODE = NAME = SEGMENT3 이므로 표시용 별도 명칭을 만들지 않는다(design 02 §2.2, V-14).
  //
  //   원천은 **두 갈래**다 — 섞으면 그리드 셀 콤보가 조회조건에 오염된다(GAP-04).
  //     · `electrodeRows`      : 모드 선필터 + 행 Division 만. 그리드 셀 `ELTR_LN_TP_CD` 후보 원천으로,
  //                              AS-IS `GetFilterDummyElectrodeType(division_type, division, operation)`
  //                              (ScpCapaBL.cs:584-609)이 **그 행의 값**만 쓰는 것과 같다.
  //     · `electrodeTypeOptions`: 위에 조회조건 Operation 선택(E08 cascade)을 더한 조회조건 전용 목록.
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
  }, [electrodeRowsRaw, divisionType, sc.divisionId]);

  const electrodeTypeOptions = useMemo<ComboOption[]>(() => {
    const seen = new Map<string, number>();
    for (const row of electrodeRows.filter(row => inSet(operationSet, str(row.OPERATION_ID)))) {
      const code = str(row.CODE);
      if (!code || code === EMPTY_CODE || seen.has(code)) continue;
      seen.set(code, Number(str(row.DISPLAY_SEQ)) || 0);
    }
    return [...seen.entries()]
      .sort((a, b) => a[1] - b[1])
      .map(([value]) => ({ value, label: value }));
  }, [electrodeRows, operationSet]);

  const validOptions = useMemo<ComboOption[]>(
    () =>
      rowsOf(validRows)
        .map(row => ({ value: str(row.CODE), label: str(row.NAME) || str(row.CODE) }))
        .filter(option => !!option.value),
    [validRows]
  );

  /** Search 시 `'ALL'` 을 펼칠 후보 코드 전체(design 02 §4.3). */
  const candidates = useMemo<CandidateCodes>(
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
    verIdOptions,
    verSeqOptions,
    planType,
    progStat,
    siteOptions,
    plantOptions,
    factoryOptions,
    lineOptions,
    operationOptions,
    electrodeTypeOptions,
    validOptions,
    candidates,
    /**
     * 그리드 셀 콤보(ID/NAME 양쪽)의 후보 원천 — design 03 §5.6 B-2.
     * 조회조건 선택이 섞이지 않은 원천이다(모드 선필터 + Division 만). 셀 후보를 더 좁히는 건
     * `buildCellComboCandidates` 가 **그 행의 값**으로만 한다.
     */
    masterRows,
    operationRows,
    electrodeRows,
  };
};
