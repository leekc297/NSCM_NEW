import { useEffect, useMemo, useRef } from 'react';

import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';

import {
  ALL,
  COMBO,
  GRID_SHEETS,
  MENU_ID,
  SHEETS,
  type GridSheet,
} from '../opt-capa.constants';
import type {
  ComboOption,
  ExcludedSheetRow,
  LineRow,
  LineTypeRow,
  NoWorkTypeRow,
  OperationRow,
  PlantRow,
} from '../opt-capa.types';
import {
  buildLineOptions,
  buildPlantOptions,
  resolvePlantCodes,
  str,
} from '../utils/optCapa.candidates';
import { buildVisibleSheets, resolveActiveSheet } from '../utils/optCapa.sheetVisibility';

/** `init` 조회 payload — IN 0개 SP 지만 훅이 `enabled` 판정에 참조를 쓰므로 모듈 상수로 고정한다. */
const EMPTY_FILTER = {} as ProcRequest<MENU_ID, SHEETS.INIT>;

interface Args {
  tabId: string;
  divisionId: string;
  plantIds: string[];
  activeSheet: GridSheet;
}

/**
 * 조회조건 콤보 · 셀콤보 후보 · 탭 집합을 한 곳에서 파생한다(design 02 §7 / 01 R13·R14).
 *
 * 이 화면은 조회조건 콤보 5종 중 **4종이 `SCM_ADM_CMBO_SQL_M` 이 아니라 화면 전용 SP 1건의
 * 다중 결과셋**으로 공급된다(design 02 §0.1). 그래서 `useCascadeFields` 를 쓰지 않는다 —
 * 조인 평면 콤보가 아니라 SP 결과셋 클라 필터형이고, cascade 5단이 **전건 필터형**이라
 * 서버 재조회가 0회다. 단계마다 파라미터 실은 콤보를 새로 등록하면 AS-IS 와 호출 횟수·후보
 * 범위가 둘 다 달라진다(design 02 §3.2 / convert-core §2.6).
 */
export const useOptCapaSheets = ({ tabId, divisionId, plantIds, activeSheet }: Args) => {
  // ── Division (CMBO 축) ──────────────────────────────────────────────────────────────
  //   `Division_SCP` 가 정본이다. `MyDivision`/`Division_SCP_NoEE`/`AllDivision_SCP` 는
  //   EE 계열 제외 또는 권한필터 소실이라 재사용 금지(design 02 §2.1 / SCP0006 실사고).
  const [divisionRowsRaw] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }],
  });
  // Plan Group — Owner(`@sesUserId`) 필터 추가 금지. AS-IS 가 `p_user_id=''` 고정이다(hook #128).
  const [planGroupRowsRaw] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLAN_GROUP, mnuId: MENU_ID }],
  });

  const divisionOptions = useMemo<ComboOption[]>(
    () =>
      ((divisionRowsRaw ?? []) as Record<string, unknown>[]).map(row => ({
        value: str(row.CODE),
        label: str(row.NAME) || str(row.CODE),
      })),
    [divisionRowsRaw]
  );

  /**
   * 권한 Division 0건 게이트(R01) — AS-IS `dtMyDivision.Rows.Count == 0` 대응.
   * 콤보 응답이 도착하기 전(`undefined`)에는 판정하지 않는다 — 진입 직후 오탐을 막는다.
   */
  const hasDivisionAuth = divisionRowsRaw === undefined || divisionOptions.length > 0;

  /**
   * Plan Group — `DIVISION_ID` 클라 필터(F-01) + ALL 선행 + **NAME 오름차순 FE 정렬**.
   * CMBO 본문에 `ORDER BY OPMZ_PLAN_GR_NAME` 이 누락돼 있는데(2025-10-20 AS-IS 사양 변경분),
   * 공유 콤보라 SQL 을 고치면 타 화면 표시순서가 바뀐다 → FE 정렬로 해결한다(design 02 §2.2 / U-4).
   */
  const planGroupOptions = useMemo<ComboOption[]>(() => {
    const rows = ((planGroupRowsRaw ?? []) as Record<string, unknown>[]).filter(
      row => str(row.DIVISION_ID) === divisionId
    );
    const options = rows
      .map(row => ({ value: str(row.CODE), label: str(row.NAME) || str(row.CODE) }))
      .sort((a, b) => a.label.localeCompare(b.label));
    return [{ value: ALL, label: ALL }, ...options];
  }, [planGroupRowsRaw, divisionId]);

  // ── `init` SP 1회 조회 (SP 축 — 조회조건 마스터 6커서) ────────────────────────────────
  //   AS-IS 는 Form 생성 시점(static 필드 initializer cs:84)에 무조건 1회 호출한다. "진입 자동조회
  //   금지" 원칙(nscm-patterns §4)의 예외다 — 조회조건 마스터이므로 게이트를 걸면 콤보가 빈다.
  const { data: initData } = useTabProcQuery<MENU_ID, SHEETS.INIT>({
    menuId: MENU_ID,
    sheetName: SHEETS.INIT,
    tabId,
    filters: EMPTY_FILTER,
    enabled: true,
  });

  // 응답 키는 `SCM_ADM_PROC_M.COL_NM` 실측 **소문자** `o_rc1`~`o_rc6` 다 — 대문자로 읽으면
  //   undefined 다(메모리 `proc-m-cursor-colnm-is-fe-response-key`).
  const plantAll = useMemo<PlantRow[]>(
    () => ((initData?.o_rc1 ?? []) as unknown as PlantRow[]),
    [initData]
  );
  const lineAll = useMemo<LineRow[]>(
    () => ((initData?.o_rc2 ?? []) as unknown as LineRow[]),
    [initData]
  );
  const operationAll = useMemo<OperationRow[]>(
    () => ((initData?.o_rc3 ?? []) as unknown as OperationRow[]),
    [initData]
  );
  const exclusionRows = useMemo<ExcludedSheetRow[]>(
    () => ((initData?.o_rc4 ?? []) as unknown as ExcludedSheetRow[]),
    [initData]
  );
  const lineTypeAll = useMemo<LineTypeRow[]>(
    () => ((initData?.o_rc5 ?? []) as unknown as LineTypeRow[]),
    [initData]
  );
  /**
   * `o_rc6` = `NO_WORK_TYPE` lookup 10건. 워킹트리 `.cs` 는 이 커서를 소비하지 않지만(design 03
   * §6-Q3) 현행 AS-IS 화면은 `Type` 을 콤보로 보여 주므로 No Work 시트 `NO_WORK_TYPE` 셀 콤보
   * 후보로 쓴다(`OptCapaGrid` `candidatesFor`).
   */
  const noWorkTypeAll = useMemo<NoWorkTypeRow[]>(
    () => ((initData?.o_rc6 ?? []) as unknown as NoWorkTypeRow[]),
    [initData]
  );

  // ── 탭 집합 (Division 축) ────────────────────────────────────────────────────────────
  //   탭 순서는 AS-IS 처럼 Division 이동 이력에 따라 달라진다(`nextTabOrder`) — 직전에 확정한 순서를
  //   ref 로 들고, `init` 응답이 온 뒤에만 확정한다(응답 전의 빈 제외목록으로 순서를 굳히지 않는다).
  const committedOrderRef = useRef<readonly GridSheet[]>(GRID_SHEETS);
  const visibleSheets = useMemo(
    () => buildVisibleSheets(exclusionRows, divisionId, committedOrderRef.current),
    [exclusionRows, divisionId]
  );
  const isInitLoaded = initData !== undefined;
  useEffect(() => {
    if (isInitLoaded) committedOrderRef.current = visibleSheets;
  }, [isInitLoaded, visibleSheets]);
  const effectiveSheet = useMemo(
    () => resolveActiveSheet(visibleSheets, activeSheet),
    [visibleSheets, activeSheet]
  );

  // ── Plant / Line 후보 (클라 필터 — 활성 시트가 의존성에 **반드시** 포함된다) ──────────
  //   `82` × {Daily Capa, No Work} 에서 OSP(SEQ=2)를 거르는 규칙이 활성 시트에 종속되기 때문이다
  //   (design 02 §7.3 재현 계약 ②). 빠지면 OSP Plant/Operation 이 후보에 남는다.
  const plantOptions = useMemo(
    () => buildPlantOptions(plantAll, divisionId, activeSheet),
    [plantAll, divisionId, activeSheet]
  );

  /** 선택 Plant CODE — `ALL`(빈 배열 포함)이면 현재 후보 전체를 펼친다(AS-IS `GetCheckedListValue`). */
  const selectedPlantCodes = useMemo(
    () => resolvePlantCodes(plantIds, plantOptions),
    [plantIds, plantOptions]
  );

  const lineOptions = useMemo(
    () => buildLineOptions(lineAll, divisionId, selectedPlantCodes),
    [lineAll, divisionId, selectedPlantCodes]
  );

  return {
    divisionOptions,
    planGroupOptions,
    plantOptions,
    lineOptions,
    selectedPlantCodes,
    hasDivisionAuth,
    plantAll,
    lineAll,
    operationAll,
    lineTypeAll,
    noWorkTypeAll,
    exclusionRows,
    visibleSheets,
    effectiveSheet,
  };
};
