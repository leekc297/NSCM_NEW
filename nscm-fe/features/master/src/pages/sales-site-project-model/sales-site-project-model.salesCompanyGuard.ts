import type {
  CellEditEndingEventArgs,
  CellRangeEventArgs,
  DataMap,
  FlexGrid,
} from '@mescius/wijmo.grid';
import { useEffect, useRef, type MutableRefObject } from 'react';

import { apiClient } from '@foundation/apis';
import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import {
  parseComboFilterBindings,
  rowParamValues,
  safeString,
  sortComboDisplayNames,
  type EditTracker,
} from '@foundation/utils';

import {
  SITE_INFO_BINDINGS,
  SITE_INFO_COMBO_ID,
  siteInfoCellValues,
} from './sales-site-project-model.siteInfo';

/**
 * Sales Company / Sales Plant 셀 콤보 가드 (상·하단 그리드 공통).
 *
 * 두 컬럼은 관리자 메타에서 재조회형 셀 콤보(PARAM10='D')로 등록돼 있다.
 *   SALES_COMPANY : combo CompanySalesSite / PARAM2 `DIVISION_ID:divisionId,SCM_SITE_ID:scmSiteId`
 *   SALES_PLANT   : combo SALES_PLANT_DM  / PARAM2 `DIVISION_ID:divisionId,SALES_COMPANY:companyId`
 * 즉 회사 후보는 그 행의 Sales Site 로, 공장 후보는 그 행의 회사 값으로 서버에서 다시 조회된다.
 * production_40 / production_81 / purchase_81 세 시트가 같은 메타라 상·하단 그리드가 같은 규칙이다.
 *
 * 왜 필요한가 (2026-09-16 사용자 리포트).
 *   ① 공용 재조회형 콤보의 DataMap 은 **전체 목록(파라미터 없는 메타 콤보) + 행별 후보의 합집합**
 *      이다(`foundation/columnMapping.ts` getRowParamDataMap). 드롭다운 후보만 `getDisplayValues`
 *      로 행 단위로 좁히고, 값의 유효성은 wijmo 가 그 합집합 색인으로 판정한다
 *      (`GridPanel.setCellData` 의 `dataMap.getKeyValue`). 그래서 **그 행의 후보에는 없지만 전체
 *      목록에는 있는 회사 코드**가 키인·붙여넣기로 그대로 들어갔고, 그 값으로 Sales Plant 재조회가
 *      나가 공장 후보까지 엉뚱한 목록으로 바뀌었다.
 *   ② 회사를 다시 골라도 Sales Plant 는 종전 값을 그대로 뒀다. 공용 정리(findStaleRowParamComboCells)
 *      는 새 후보 밖 값만 비우므로, 새 후보 안에 우연히 남아 있는 값은 그대로다.
 *
 * 처리.
 *   · 회사 셀 커밋 전(cellEditEnding / pastingCell)에 **드롭다운과 같은 함수**(`getDisplayValues(row)`)
 *     로 후보를 구해 후보 밖 값이면 편집·붙여넣기를 취소한다. 키인과 Ctrl+V 가 같은 게이트를 탄다.
 *     거부는 알리지 않는다(사용자 지정 2026-09-16) — 전체 목록 밖 값을 wijmo 가 조용히 버리는
 *     종전 동작과 같은 모양으로, 셀은 이전 값을 유지한다.
 *   · 회사 셀이 커밋되면 Sales Plant 를 **새 후보의 첫 값**으로 맞춘다(같은 값을 다시 골라도 초기화).
 *     지금 Plant 가 새 후보 안에 있어도 초기화한다(2026-09-17 사용자 확인 — 한때 "유효하면 유지"
 *     조건이 붙어 초기화가 사라진 것처럼 보였다). 예외: 같은 행의 Plant 를 회사 확정 전에 직접
 *     붙여넣거나 입력했으면(엑셀 여러 칸 붙여넣기 등) 그 값을 존중하고 초기화하지 않는다(keepPlant).
 *   · 후보가 아직 도착하지 않은 행은 통과시키고 도착 시점에 재검증한다 — 미도착을 "후보 0건"으로
 *     오인해 거부하면 조회가 늦은 회차의 정상 입력까지 막힌다(공용 drain 과 같은 판단).
 *
 * Sales Plant (2026-09-17 사용자 리포트).
 *   ③ 키인은 허용한다. 대신 편집을 끝낼 때(Enter·포커스 이동) 그 행 회사의 후보에 없는 값이면
 *      입력을 버리고 **후보의 첫 값**으로 맞춘다(예: HQ00 회사 행에 HQ01 입력 → HQ04).
 *      주의: wijmo 기본 판정은 ①과 같은 합집합이라, 여기서 안 막으면 다른 회사의 공장 코드가 들어간다.
 *   ④ 붙여넣기도 같은 합집합으로 판정돼 그 회사와 무관한 공장 코드가 들어갔다. → 붙여넣기 전에
 *      그 행 회사의 후보에 있는지 본다. 후보 밖이면 붙여넣기를 취소해 이전 값을 유지한다.
 *   ③④ 모두 후보가 아직 없으면(미조회 또는 0건 — DataMap 으로는 구분 불가) 드롭다운과 같은
 *      콤보·파라미터로 직접 조회해 판정한다(loadPlantRows).
 *
 * 금지: 판정을 여기서 자체 목록으로 만들지 말 것. 후보 원천은 컬럼 DataMap 하나이고, 드롭다운에
 *   뜨는 목록과 판정이 갈리면 "목록에 있는데 입력이 안 되는" 상태가 된다.
 */

const SCM_SITE_ID = 'SCM_SITE_ID';
const SALES_COMPANY = 'SALES_COMPANY';
const SALES_PLANT = 'SALES_PLANT';

/** 후보 미도착 행을 다시 볼 시한 — 지나면 포기한다(0건이면 공용 정리가 하위 값을 비운다). */
const PENDING_TIMEOUT_MS = 5000;

const cellText = (value: unknown): string => safeString(value).trim();

/**
 * 조회 결과 중 "첫 값" — 공용 DataGrid 의 드롭다운 정렬(sortComboDisplayNames, 숫자→영어→한글
 * 순)과 같은 기준으로 고른다.
 */
const firstByDisplayOrder = (rows: ComboResponse[]): ComboResponse | undefined => {
  const firstName = sortComboDisplayNames(rows.map(row => row.NAME))[0];
  return rows.find(row => row.NAME === firstName);
};

// 금지: division 을 상위 코드(81_HM -> 81)로 정규화하지 말 것. 예전 자동설정 경로가 그렇게 보냈는데
//   SCM_MST_SITE·SCM_MST_PLANT_SN 는 81_HD/81_HG/81_HM/81_ST/81_UC 행을 그대로 가지고 있어
//   (2026-09-18 로컬 DB 실측: SITE 기준 12/8/32/14/17건) 하위 코드 division 에서 후보가 0건이 됐다.
//   콤보 파라미터는 드롭다운과 같이 행 값을 그대로 싣는다(loadComboRows).

/** 회사 값을 커밋한 행 — 후보 도착 후 재검증(needsCheck)과 Plant 초기화를 여기서 이어받는다. */
interface PendingCompanyRow {
  previousCompany: WijmoPrimitive;
  needsCheck: boolean;
  queuedAt: number;
  /** 회사 확정 전에 같은 행의 Plant 를 직접 붙여넣거나 입력했다 — 확정 시 Plant 초기화를 건너뛴다. */
  keepPlant: boolean;
}

export const useSalesCompanyGuard = <T extends WijmoRowItem>({
  gridRef,
  editTrackerRef,
  resyncRow,
  staticColumns,
  data,
}: {
  gridRef: MutableRefObject<FlexGrid<T> | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<T> | undefined>;
  resyncRow: (row: T | undefined) => void;
  /**
   * 컬럼 메타 — 핸들러를 붙일 계기. 룰 규약(RULESET_MASTER §3.1 런타임 사고 9종)이 wijmo 이벤트
   * 등록 effect 의 dependency 로 지정한 값이다.
   *
   * 필수: dep 이 고정값(ref·안정 콜백)뿐이면 effect 가 mount 1회만 돌고, 그 시점에
   * `gridRef.current` 가 아직 없어 핸들러가 **조용히 안 붙는다**(2026-09-16 실사고 — 회사 칸
   * 입력 차단과 Plant 초기화가 동시에 죽었다).
   */
  staticColumns: RawFlexGridColumnConfig[];
  /** 조회 결과 — 같은 이유의 두 번째 계기. 같은 화면 Team 붙여넣기 effect 와 같은 규약이다. */
  data: T[];
}) => {
  // 후보 미도착 큐는 effect 밖에 둔다 — 재조회로 effect 가 다시 돌아도 진행 중인 판정이 사라지지 않는다.
  const pendingCompanyRef = useRef(new Map<T, PendingCompanyRow>());
  // Sales Site 자동설정 조회의 최신 요청 번호(행별) — 늦게 도착한 옛 응답을 버리는 stale guard.
  const siteRequestRef = useRef(new Map<T, number>());
  // Sales Plant 직접 조회 판정(붙여넣기·키인)의 최신 요청 번호(행별) — 같은 행의 새 입력이 오면 앞 판정은 버린다.
  const plantRequestRef = useRef(new Map<T, number>());

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const pendingCompany = pendingCompanyRef.current;
    const siteRequestSeq = siteRequestRef.current;
    const plantRequestSeq = plantRequestRef.current;
    // 키인으로 끝낸 Plant 편집 — cellEditEnding 에서 입력값을 버리고 담아 두면, 편집기가 정리된 뒤
    //   cellEditEnded 에서 최종 값을 넣는다. wijmo 는 cancel 된 편집에도 cellEditEnded 를 올린다.
    const typedPlantRows = new Map<T, string>();

    const dataMapOf = (binding: string): DataMap | undefined =>
      grid.getColumn(binding)?.dataMap ?? undefined;

    /** 그 행의 드롭다운 후보 표시명 — 후보 판정의 단일 원천. 미조회·0건 모두 빈 배열이다. */
    const candidateNamesOf = (binding: string, row: T): string[] => {
      const dataMap = dataMapOf(binding);
      if (!dataMap) return [];
      return (dataMap.getDisplayValues(row) as string[] | undefined) ?? [];
    };

    /** 저장 코드 -> 표시명. 콤보 색인에 없으면 코드 자신이 돌아오므로 그대로 비교에 쓴다. */
    const displayNameOf = (binding: string, code: string): string =>
      cellText(dataMapOf(binding)?.getDisplayValue(code) ?? code);

    /**
     * 표시명 -> 저장 코드.
     * 색인이 못 찾으면 표시명 자체를 코드로 본다 — SALES_PLANT_DM 처럼 CODE 와 NAME 이 같은 값
     * (PLANT_ID) 인 콤보가 있고, 여기서 빈 값으로 떨구면 Plant 초기화가 조용히 안 일어난다.
     */
    const keyOfName = (binding: string, name: string): string => {
      const key = cellText(dataMapOf(binding)?.getKeyValue(name));
      return key !== '' ? key : cellText(name);
    };

    /**
     * 입력값이 그 행의 후보인가.
     *
     * 표시명과 저장 코드를 **둘 다** 본다. 셀에서 복사하면 표시명이 실리지만, 외부에서 코드를
     * 그대로 붙여넣는 경로가 있고 그 코드가 그 행의 정상 후보일 수 있다 — 코드를 안 보면 정상
     * 입력이 거부된다. 대소문자는 구분하지 않는다(공용 콤보 검색과 같은 규약).
     */
    const isCandidate = (binding: string, names: string[], text: string): boolean => {
      const lowered = text.toLowerCase();
      return names.some(
        name =>
          cellText(name).toLowerCase() === lowered ||
          keyOfName(binding, name).toLowerCase() === lowered
      );
    };

    const rowOf = (rowIndex: number): T | undefined =>
      grid.rows[rowIndex]?.dataItem as T | undefined;

    const bindingOf = (col: number): string => grid.columns[col]?.binding ?? '';

    const isCompanyCell = (col: number): boolean => bindingOf(col) === SALES_COMPANY;

    const isPlantCell = (col: number): boolean => bindingOf(col) === SALES_PLANT;

    const queueCompany = (row: T, needsCheck: boolean): void => {
      pendingCompany.set(row, {
        previousCompany: row[SALES_COMPANY] ?? '',
        needsCheck,
        queuedAt: Date.now(),
        keepPlant: false,
      });
    };

    const applyCell = (row: T, binding: string, value: WijmoPrimitive): void => {
      editTrackerRef.current?.storeChange(row, binding, row[binding] ?? '', value);
      (row as WijmoRowItem)[binding] = value;
      resyncRow(row);
    };

    /**
     * 커밋된 회사 값을 후보 도착 시점에 확정한다.
     *   · 후보 밖이면 이전 값으로 되돌린다(미도착 상태로 통과시킨 경로의 안전망).
     *   · 유효하면 Sales Plant 를 새 후보의 첫 값으로 맞춘다.
     * 아직 판정할 수 없으면 큐에 남겨 다음 도착(updatedLayout)에서 다시 본다.
     */
    const settleCompany = (row: T): boolean => {
      const entry = pendingCompany.get(row);
      if (!entry) return false;

      const company = cellText(row[SALES_COMPANY]);
      // 회사를 비웠으면 Plant 는 건드리지 않는다 — 후보가 넓어지므로 공용 정리 판정에 맡긴다.
      if (company === '') {
        pendingCompany.delete(row);
        return false;
      }

      if (entry.needsCheck) {
        const companyNames = candidateNamesOf(SALES_COMPANY, row);
        if (companyNames.length === 0) return false; // 후보 미도착 — 다음 기회에
        if (!isCandidate(SALES_COMPANY, companyNames, displayNameOf(SALES_COMPANY, company))) {
          pendingCompany.delete(row);
          applyCell(row, SALES_COMPANY, entry.previousCompany);
          return true;
        }
        entry.needsCheck = false;
      }

      // Plant 를 직접 넣은 행은 초기화하지 않는다 — 그 값의 유효성은 Plant 쪽 판정(③④)이 맡는다.
      if (entry.keepPlant) {
        pendingCompany.delete(row);
        return false;
      }

      const plantNames = candidateNamesOf(SALES_PLANT, row);
      if (plantNames.length === 0) return false; // 새 회사의 공장 후보 미도착 — 다음 기회에
      pendingCompany.delete(row);

      // 금지: "지금 값이 새 후보에서도 유효하면 유지" 조건을 다시 넣지 말 것. 회사를 고르면 첫 값으로
      //   맞추는 것이 확정 동작이다(99b0d65a AS-IS 동일 → 663098dc 에서 조건부로 바뀌어 초기화가
      //   사라졌다는 2026-09-17 사용자 리포트로 원복).
      const currentPlant = cellText(row[SALES_PLANT]);
      const firstPlant = keyOfName(SALES_PLANT, plantNames[0]);
      if (firstPlant === '' || currentPlant === firstPlant) return false;
      applyCell(row, SALES_PLANT, firstPlant);
      return true;
    };

    /** 큐 소진 — 시한이 지난 행은 포기한다(0건 후보는 공용 정리가 하위 값을 비운다). */
    const settlePending = (): void => {
      if (pendingCompany.size === 0) return;
      const now = Date.now();
      let applied = false;

      for (const [row, entry] of [...pendingCompany]) {
        if (settleCompany(row)) applied = true;
        else if (now - entry.queuedAt > PENDING_TIMEOUT_MS) pendingCompany.delete(row);
      }
      if (applied) grid.invalidate();
    };

    /** 회사 확정 대기 중인 행이면 Plant 초기화를 건너뛰게 표시한다(Plant 를 직접 넣은 경우). */
    const keepPlantOnSettle = (row: T): void => {
      const entry = pendingCompany.get(row);
      if (entry) entry.keepPlant = true;
    };

    /** 같은 행의 Plant 직접 조회 판정 번호를 새로 발급한다 — 앞선 판정의 늦은 응답은 버려진다. */
    const nextPlantRequest = (row: T): number => {
      const requestId = (plantRequestSeq.get(row) ?? 0) + 1;
      plantRequestSeq.set(row, requestId);
      return requestId;
    };

    /**
     * 그 행의 **지금 값**으로 셀 콤보 후보를 직접 조회한다(Sales Company / Sales Plant 공용).
     *
     * 드롭다운과 같은 콤보(컬럼 메타 cellCboDataTp)를 같은 파라미터(PARAM2 → rowParamValues)로 부른다.
     * 공용 재조회(useRowParamCombos)와 SQL·바인드가 같으므로 후보 집합도 같다(공용 쪽은 mnuId·sheetName
     * 을 더 싣지만 두 콤보 SQL 은 쓰지 않는다).
     * 금지: 콤보 ID·파라미터를 화면에 적지 말 것(2026-09-18 사용자 지시) — 적어 둔 값은 메타가 바뀌면
     *   조용히 갈린다. 실제로 하드코딩 경로가 드롭다운과 다른 콤보(PlantByDivisionCompany)를 부르고
     *   division 을 상위 코드로 정규화해, 드롭다운에 없는 공장이 채워지고 81_HM 같은 하위 코드 행은
     *   후보가 0건이 됐다.
     * 공용 결과 도착을 기다리지 않는 이유: DataMap 후보는 미조회와 0건이 둘 다 빈 목록이라 "후보가
     * 없다"를 판정할 수 없고, 시한으로 포기하면 후보 밖 값이 그대로 남는다.
     *
     * 조회 중에 파라미터 원천 셀(Site·회사 등)이 바뀌면 그 응답은 다른 조건의 후보라 다시 조회한다.
     *
     * @returns 후보 목록 / `null` = 조회 실패 / `undefined` = 판정이 무의미해짐(isStale) 또는 메타 없음
     */
    const loadComboRows = async (
      binding: string,
      row: T,
      isStale: () => boolean
    ): Promise<ComboResponse[] | null | undefined> => {
      const column = staticColumns.find(item => item.colNm === binding);
      const comboId = column?.cellCboDataTp ? String(column.cellCboDataTp) : '';
      if (comboId === '') return undefined;
      const bindings = parseComboFilterBindings(column?.attribute2);
      const paramKey = (): string => JSON.stringify(rowParamValues(bindings, row));

      for (;;) {
        const requested = paramKey();
        let comboRows: ComboResponse[] | undefined;
        try {
          comboRows = await apiClient.getCombo(
            { comboId, ...rowParamValues(bindings, row) },
            'grid'
          );
        } catch {
          return isStale() ? undefined : null;
        }
        if (isStale()) return undefined;
        if (paramKey() !== requested) continue;
        return comboRows ?? [];
      }
    };

    /**
     * Sales Site 를 비우면 그 Site 로 정해지는 Sales Company / Sales Plant 도 함께 비운다
     * (2026-09-18 사용자 요구). 편집·붙여넣기·Delete 키가 모두 이 경로를 탄다 — wijmo 는 Delete 로
     * 지운 셀에도 cellEditEnded 를 올린다(_KeyboardHandler._deleteRange).
     *
     * 진행 중이던 판정은 모두 취소한다. 안 그러면 늦게 도착한 응답이 방금 비운 칸을 다시 채운다
     *   · 요청 번호를 올려 Site 자동설정·Plant 직접 조회의 응답을 버리게 한다.
     *   · 회사 확정 대기(pendingCompany)를 지운다 — 남겨 두면 후보 도착 시 Plant 가 첫 값으로 채워진다.
     * 공용 정리(findStaleRowParamComboCells)에 맡길 수 없다: Site 가 비면 회사 후보가 오히려 넓어져
     * "후보 밖" 판정이 서지 않는다.
     */
    const clearSiteDrivenCells = (row: T): void => {
      siteRequestSeq.set(row, (siteRequestSeq.get(row) ?? 0) + 1);
      nextPlantRequest(row);
      pendingCompany.delete(row);
      typedPlantRows.delete(row);

      let cleared = false;
      // Sold-To / Rep Ship-To 네 칸도 Site 로 정해지는 값이라 함께 비운다 (AS-IS D12~D15 와 같은 결과).
      for (const binding of [SALES_COMPANY, SALES_PLANT, ...SITE_INFO_BINDINGS]) {
        // 이 시트(division)에 없는 컬럼은 건드리지 않는다 — 안 보이는 값을 바꿔 행을 더럽히지 않는다.
        if (!grid.getColumn(binding)) continue;
        if (cellText(row[binding]) === '') continue;
        applyCell(row, binding, '');
        cleared = true;
      }
      if (cleared) grid.invalidate();
    };

    /**
     * Sales Site 의 사이트 정보(Sold-To / Rep Ship-To 네 칸)를 직접 조회한다 — AS-IS
     * GetScmSiteInfobyDivision(.cs L3150, SP SCM0001_GET_SITE_INFO_BY_DIVISION) 1:1. 같은 SQL 이
     * 콤보 메타(SCM_ADM_CMBO_SQL_M)에 등록돼 있어 콤보 API 로 부르고 결과의 네 컬럼을 읽는다.
     *
     * @returns 결과 행 / `null` = 조회 실패 / `undefined` = 판정이 무의미해짐(isStale)
     */
    const loadSiteInfoRows = async (
      row: T,
      site: string,
      isStale: () => boolean
    ): Promise<ComboResponse[] | null | undefined> => {
      try {
        const rows = await apiClient.getCombo(
          {
            comboId: SITE_INFO_COMBO_ID,
            divisionId: cellText(row.DIVISION_ID),
            scmSiteId: site,
          },
          'grid'
        );
        if (isStale()) return undefined;
        return rows ?? [];
      } catch {
        return isStale() ? undefined : null;
      }
    };

    /**
     * Sales Site 커밋 → ① 그 Site 의 사이트 정보로 Sold-To / Rep Ship-To 네 칸을 채우고(결과가
     * 없으면 비운다 — AS-IS D8~D15), ② 그 Site 의 회사(0 또는 1건, 상단 주석 참조)를 직접 조회해
     * Sales Company 를 채우고, 이어서 그 회사의 Sales Plant 후보 중 첫 값으로 Sales Plant 를 맞춘다.
     * Site 를 비운 경우는 clearSiteDrivenCells 가 여섯 칸을 함께 비운다.
     * ①②는 같은 요청 번호를 쓴다 — Site 가 또 바뀌면 둘 다 버려져 늦은 응답이 새 Site 값을 덮지 않는다.
     */
    const applySiteDrivenDefaults = async (row: T): Promise<void> => {
      const site = cellText(row[SCM_SITE_ID]);
      if (site === '') {
        clearSiteDrivenCells(row);
        return;
      }
      // 이 시트(division)에 있는 컬럼만 다룬다 — Purchase 시트에는 Sold-To / Ship-To 칸이 없고
      //   (AS-IS 도 siMain 에서만 파생), 회사·공장 칸이 없는 시트면 ②는 건너뛴다.
      const hasSiteInfoColumns = SITE_INFO_BINDINGS.some(binding => !!grid.getColumn(binding));
      const hasCompanyColumns = !!grid.getColumn(SALES_COMPANY) && !!grid.getColumn(SALES_PLANT);
      if (!hasSiteInfoColumns && !hasCompanyColumns) return;

      const requestId = (siteRequestSeq.get(row) ?? 0) + 1;
      siteRequestSeq.set(row, requestId);

      // 그사이 이 행에 더 최신 요청이 올라왔거나 Site 가 또 바뀌었으면 이 응답은 버린다.
      const isStale = (): boolean =>
        siteRequestSeq.get(row) !== requestId || cellText(row[SCM_SITE_ID]) !== site;

      // ①과 ②의 조회는 서로 독립이라 함께 띄운다 — 한쪽이 느려도 다른 쪽 칸은 먼저 채워지지 않고
      //   둘 다 도착한 뒤 한 번에 반영한다(셀이 따로따로 바뀌는 깜빡임 방지).
      // 회사 후보도 드롭다운과 같은 경로로 받는다 — 컬럼 메타 콤보(CompanySalesSite)를 그 행의 값
      //   (PARAM2 = DIVISION_ID·SCM_SITE_ID)으로 조회한다.
      const [siteInfoRows, companyRows] = await Promise.all([
        hasSiteInfoColumns ? loadSiteInfoRows(row, site, isStale) : Promise.resolve(undefined),
        hasCompanyColumns ? loadComboRows(SALES_COMPANY, row, isStale) : Promise.resolve(undefined),
      ]);

      let invalidated = false;

      // ① 사이트 정보 — 결과 1행의 네 칸을 넣고, 0건이면 네 칸을 비운다(AS-IS D12~D15).
      //   null(조회 실패)이면 건드리지 않는다 — 실패를 "정보 없음"으로 오인해 비우지 않는다.
      if (hasSiteInfoColumns && siteInfoRows != null) {
        const values = siteInfoCellValues(siteInfoRows);
        for (const binding of SITE_INFO_BINDINGS) {
          if (!grid.getColumn(binding)) continue;
          if (cellText(row[binding]) === values[binding]) continue;
          applyCell(row, binding, values[binding]);
          invalidated = true;
        }
      }

      // ② 회사·공장. undefined = Site 가 또 바뀜 / null = 조회 실패. 둘 다 자동설정을 건너뛴다 —
      //   사용자가 직접 채울 수 있어 화면을 막지 않는다.
      if (!hasCompanyColumns || !companyRows) {
        if (invalidated) grid.invalidate();
        return;
      }

      const resolvedCompany = cellText(firstByDisplayOrder(companyRows)?.CODE);
      if (resolvedCompany !== '' && cellText(row[SALES_COMPANY]) !== resolvedCompany) {
        applyCell(row, SALES_COMPANY, resolvedCompany);
        invalidated = true;
      }
      if (resolvedCompany === '') {
        if (invalidated) grid.invalidate();
        return;
      }

      // 공장 후보는 드롭다운·키인·붙여넣기와 같은 경로(loadPlantRows)로 받는다 — 컬럼 메타 콤보
      //   (SALES_PLANT_DM)를 그 행의 값(PARAM2 = DIVISION_ID·SALES_COMPANY)으로 조회한다.
      //   금지: 여기에 콤보 ID 를 다시 적지 말 것(2026-09-18 사용자 지시). 종전에 적어 두었던
      //   `PlantByDivisionCompany` 는 ACTIVE_FLAG='Y' 조건이 없어 드롭다운에 없는 비활성 공장이
      //   자동으로 채워졌고, division 도 상위 코드로 정규화해 81_HM 처럼 하위 코드로 등록된 공장을
      //   놓쳤다(SCM_MST_PLANT_SN 는 81_HM/81_ST 등 하위 코드 행을 그대로 가진다).
      const plantRows = await loadComboRows(
        SALES_PLANT,
        row,
        () => isStale() || cellText(row[SALES_COMPANY]) !== resolvedCompany
      );
      if (!plantRows) {
        // undefined = 그사이 Site·회사가 바뀜 / null = 조회 실패. 둘 다 자동설정을 건너뛴다.
        if (invalidated) grid.invalidate();
        return;
      }

      // 지금 값이 새 회사에서도 유효하면 건드리지 않는다 — settleCompany 와 같은 조건부 규칙.
      const currentPlant = cellText(row[SALES_PLANT]);
      const currentPlantIsValid =
        currentPlant !== '' && plantRows.some(item => cellText(item.CODE) === currentPlant);
      if (!currentPlantIsValid) {
        const resolvedPlant = cellText(firstByDisplayOrder(plantRows)?.CODE);
        if (resolvedPlant !== '' && currentPlant !== resolvedPlant) {
          applyCell(row, SALES_PLANT, resolvedPlant);
          invalidated = true;
        }
      }
      if (invalidated) grid.invalidate();
    };

    /**
     * ④ 후보 미도착 상태로 통과시킨 Sales Plant 붙여넣기를 사후 확정한다 — 후보 밖이면 이전 값으로.
     *   · 응답 시점에 셀 값이 붙여넣은 값 그대로일 때만 본다 — 그사이 사용자가 고쳤으면 관여하지 않는다.
     *   · 조회가 실패하면 판정할 수 없으므로 되돌린다 — 이 경로의 목적이 후보 밖 값을 남기지 않는 것이다.
     */
    const verifyPastedPlant = async (
      row: T,
      previousPlant: WijmoPrimitive,
      pasted: string
    ): Promise<void> => {
      const requestId = nextPlantRequest(row);
      const loweredPasted = pasted.toLowerCase();

      /** 셀이 아직 붙여넣은 값인가 — 표시명·저장 코드 어느 쪽으로 붙여넣었든 같은 값으로 본다. */
      const isStillPasted = (): boolean => {
        const current = cellText(row[SALES_PLANT]);
        return (
          current !== '' &&
          (current.toLowerCase() === loweredPasted ||
            displayNameOf(SALES_PLANT, current).toLowerCase() === loweredPasted)
        );
      };

      const plantRows = await loadComboRows(
        SALES_PLANT,
        row,
        () => plantRequestSeq.get(row) !== requestId || !isStillPasted()
      );
      if (plantRows === undefined) return;

      const currentPlant = cellText(row[SALES_PLANT]);
      const isValid =
        plantRows !== null && plantRows.some(item => cellText(item.CODE) === currentPlant);
      if (isValid) return;
      applyCell(row, SALES_PLANT, previousPlant);
      grid.invalidate();
    };

    /**
     * ③ 후보 미도착 상태에서 키인으로 끝낸 Sales Plant 편집을 확정한다. 입력은 cellEditEnding 에서
     * 이미 버려져 셀은 이전 값이다.
     *   · 입력값이 후보에 있으면 그 값(저장 코드)을 넣는다 — 후보가 늦었을 뿐 정상 입력이다.
     *   · 후보에 없으면 후보의 첫 값(드롭다운 정렬 기준)을 넣는다. 후보가 0건이면 그대로 둔다.
     *   · 응답 전에 셀이 바뀌었거나(다른 편집·붙여넣기) 조회가 실패하면 관여하지 않는다.
     */
    const resolveTypedPlant = async (row: T, typed: string): Promise<void> => {
      const requestId = nextPlantRequest(row);
      const snapshot = cellText(row[SALES_PLANT]);

      const plantRows = await loadComboRows(
        SALES_PLANT,
        row,
        () => plantRequestSeq.get(row) !== requestId || cellText(row[SALES_PLANT]) !== snapshot
      );
      if (!plantRows) return;

      const loweredTyped = typed.toLowerCase();
      const matched = plantRows.find(
        item =>
          cellText(item.CODE).toLowerCase() === loweredTyped ||
          cellText(item.NAME).toLowerCase() === loweredTyped
      );
      const nextPlant = cellText((matched ?? firstByDisplayOrder(plantRows))?.CODE);
      if (nextPlant === '' || nextPlant === snapshot) return;
      applyCell(row, SALES_PLANT, nextPlant);
      grid.invalidate();
    };

    // 키인·드롭다운 선택 커밋 직전 게이트. cancel = 편집값 폐기(셀은 이전 값 유지).
    //   stayInEditMode 는 쓰지 않는다 — 편집기가 갇혀 커서가 안 빠진다(정본 ContributeMainGrid).
    const editEndingHandler = (_sender: FlexGrid<T>, event: CellEditEndingEventArgs) => {
      const isCompany = isCompanyCell(event.col);
      if (!isCompany && !isPlantCell(event.col)) return;
      const row = rowOf(event.row);
      if (!row) return;

      const typed = cellText(grid.activeEditor?.value);
      if (typed === '') return; // 비우기는 허용 — 필수 판정은 저장 검증 몫이다

      // ③ Sales Plant — 후보 안이면 그대로 커밋. 후보 밖이거나 후보가 아직 없으면 입력을 버리고
      //   cellEditEnded(editEndedHandler)에서 최종 값(후보 첫 값 등)을 넣는다.
      //   주의: 여기서 row 에 값을 바로 쓰지 말 것 — 편집기가 아직 살아 있어 wijmo 커밋·재도색과 엉킨다.
      if (!isCompany) {
        if (event.cancel) return; // 다른 핸들러가 이미 취소한 편집
        const plantNames = candidateNamesOf(SALES_PLANT, row);
        const isKnownCandidate =
          plantNames.length > 0 && isCandidate(SALES_PLANT, plantNames, typed);
        // 받아들인 값이거나 판정을 직접 조회로 미루는 경우만 회사 확정 초기화에서 보호한다.
        //   후보 밖으로 확정된 입력은 어차피 첫 값으로 가므로 보호할 이유가 없다.
        if (isKnownCandidate || plantNames.length === 0) keepPlantOnSettle(row);
        if (isKnownCandidate) return;
        event.cancel = true;
        typedPlantRows.set(row, typed);
        return;
      }

      const companyNames = candidateNamesOf(SALES_COMPANY, row);
      // 후보 미도착이면 통과시키고 도착 시점에 재검증한다(미도착 != 후보 0건).
      queueCompany(row, companyNames.length === 0);
      if (companyNames.length === 0) return;
      if (isCandidate(SALES_COMPANY, companyNames, typed)) return;

      pendingCompany.delete(row);
      event.cancel = true;
    };

    // 붙여넣기(편집모드가 아닌 그리드 단위 Ctrl+V) — 키인과 같은 게이트를 태운다.
    const pastingHandler = (_sender: FlexGrid<T>, event: CellRangeEventArgs) => {
      const isCompany = isCompanyCell(event.col);
      if (!isCompany && !isPlantCell(event.col)) return;
      const row = rowOf(event.row);
      if (!row) return;

      const pasted = cellText(event.data);
      if (pasted === '') return;

      // Sales Plant — 그 행의 회사로 조회한 후보(드롭다운과 같은 목록) 안의 값만 받는다.
      //   주의: wijmo 기본 판정(dataMap.getKeyValue)은 전체 목록 합집합을 보므로 여기서 막지 않으면
      //   다른 회사의 공장 코드도 들어간다.
      if (!isCompany) {
        const plantNames = candidateNamesOf(SALES_PLANT, row);
        if (plantNames.length > 0) {
          // 취소된 붙여넣기는 보호하지 않는다 — 회사 확정 초기화(첫 값)가 그대로 적용되게 둔다.
          if (isCandidate(SALES_PLANT, plantNames, pasted)) keepPlantOnSettle(row);
          else event.cancel = true;
          return;
        }
        keepPlantOnSettle(row);
        // 후보 미도착(또는 0건) — 붙여넣기는 통과시키고 직접 조회로 확정한다(verifyPastedPlant).
        void verifyPastedPlant(row, row[SALES_PLANT] ?? '', pasted);
        return;
      }

      const companyNames = candidateNamesOf(SALES_COMPANY, row);
      queueCompany(row, companyNames.length === 0);
      if (companyNames.length === 0) return;
      if (isCandidate(SALES_COMPANY, companyNames, pasted)) return;

      pendingCompany.delete(row);
      event.cancel = true;
    };

    // 커밋 직후 처리 — Sales Site 는 자동설정 조회를 띄우고, Sales Company 는 1차 확정.
    //   금지: 여기서 후보가 비었다고 Plant 를 비우지 말 것. 새 회사의 공장 조회는 공용
    //   registerTouchedRow 가 이 시점에 띄우므로 후보는 **항상 한 박자 뒤**에 온다.
    const editEndedHandler = (_sender: FlexGrid<T>, event: CellRangeEventArgs) => {
      const binding = bindingOf(event.col);
      const row = rowOf(event.row);
      if (!row) return;

      if (binding === SCM_SITE_ID) {
        void applySiteDrivenDefaults(row);
        return;
      }
      if (binding === SALES_COMPANY && pendingCompany.has(row)) {
        if (settleCompany(row)) grid.invalidate();
        return;
      }
      // ③ 키인으로 끝낸 Plant 편집(cellEditEnding 에서 입력을 버린 경우만 담겨 있다).
      //   붙여넣기(pastedCell)도 이 핸들러를 타지만 typedPlantRows 에 없으므로 관여하지 않는다.
      if (binding === SALES_PLANT) {
        const typed = typedPlantRows.get(row);
        if (typed === undefined) return;
        typedPlantRows.delete(row);

        const plantNames = candidateNamesOf(SALES_PLANT, row);
        if (plantNames.length === 0) {
          void resolveTypedPlant(row, typed);
          return;
        }
        const matched = plantNames.find(name => isCandidate(SALES_PLANT, [name], typed));
        const nextPlant = keyOfName(SALES_PLANT, matched ?? plantNames[0]);
        if (nextPlant === '' || cellText(row[SALES_PLANT]) === nextPlant) return;
        nextPlantRequest(row); // 진행 중인 직접 조회 판정이 있으면 이 값을 덮지 않게 버린다
        applyCell(row, SALES_PLANT, nextPlant);
        grid.invalidate();
      }
    };

    // 재조회 결과가 도착하면 공용 DataGrid 가 콤보 dataMap 을 교체하고 invalidate 한다 —
    //   그 재배치 시점이 곧 후보 도착 시점이라 여기서 큐를 다시 본다.
    const updatedLayoutHandler = () => settlePending();

    grid.cellEditEnding.addHandler(editEndingHandler);
    grid.pastingCell.addHandler(pastingHandler);
    grid.cellEditEnded.addHandler(editEndedHandler);
    grid.pastedCell.addHandler(editEndedHandler);
    grid.updatedLayout.addHandler(updatedLayoutHandler);
    return () => {
      grid.cellEditEnding.removeHandler(editEndingHandler);
      grid.pastingCell.removeHandler(pastingHandler);
      grid.cellEditEnded.removeHandler(editEndedHandler);
      grid.pastedCell.removeHandler(editEndedHandler);
      grid.updatedLayout.removeHandler(updatedLayoutHandler);
    };
  }, [gridRef, editTrackerRef, resyncRow, staticColumns, data]);
};
