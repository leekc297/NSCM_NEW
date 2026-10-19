import type {
  CellEditEndingEventArgs,
  CellRangeEventArgs,
  DataMap,
  FlexGrid,
} from '@mescius/wijmo.grid';
import { useEffect, useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { safeString, type EditTracker } from '@foundation/utils';

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
 *   · 후보가 아직 도착하지 않은 행은 통과시키고 도착 시점에 재검증한다 — 미도착을 "후보 0건"으로
 *     오인해 거부하면 조회가 늦은 회차의 정상 입력까지 막힌다(공용 drain 과 같은 판단).
 *
 * 금지: 판정을 여기서 자체 목록으로 만들지 말 것. 후보 원천은 컬럼 DataMap 하나이고, 드롭다운에
 *   뜨는 목록과 판정이 갈리면 "목록에 있는데 입력이 안 되는" 상태가 된다.
 */

const SALES_COMPANY = 'SALES_COMPANY';
const SALES_PLANT = 'SALES_PLANT';

/** 후보 미도착 행을 다시 볼 시한 — 지나면 포기한다(0건이면 공용 정리가 하위 값을 비운다). */
const PENDING_TIMEOUT_MS = 5000;

const cellText = (value: unknown): string => safeString(value).trim();

/** 회사 값을 커밋한 행 — 후보 도착 후 재검증(needsCheck)과 Plant 초기화를 여기서 이어받는다. */
interface PendingRow {
  previousCompany: WijmoPrimitive;
  needsCheck: boolean;
  queuedAt: number;
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
  const pendingRef = useRef(new Map<T, PendingRow>());

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const pending = pendingRef.current;

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

    const isCompanyCell = (col: number): boolean =>
      (grid.columns[col]?.binding ?? '') === SALES_COMPANY;

    const queue = (row: T, needsCheck: boolean): void => {
      pending.set(row, {
        previousCompany: row[SALES_COMPANY] ?? '',
        needsCheck,
        queuedAt: Date.now(),
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
    const settle = (row: T): boolean => {
      const entry = pending.get(row);
      if (!entry) return false;

      const company = cellText(row[SALES_COMPANY]);
      // 회사를 비웠으면 Plant 는 건드리지 않는다 — 후보가 넓어지므로 공용 정리 판정에 맡긴다.
      if (company === '') {
        pending.delete(row);
        return false;
      }

      if (entry.needsCheck) {
        const companyNames = candidateNamesOf(SALES_COMPANY, row);
        if (companyNames.length === 0) return false; // 후보 미도착 — 다음 기회에
        if (!isCandidate(SALES_COMPANY, companyNames, displayNameOf(SALES_COMPANY, company))) {
          pending.delete(row);
          applyCell(row, SALES_COMPANY, entry.previousCompany);
          return true;
        }
        entry.needsCheck = false;
      }

      const plantNames = candidateNamesOf(SALES_PLANT, row);
      if (plantNames.length === 0) return false; // 새 회사의 공장 후보 미도착 — 다음 기회에
      pending.delete(row);

      const firstPlant = keyOfName(SALES_PLANT, plantNames[0]);
      if (firstPlant === '' || cellText(row[SALES_PLANT]) === firstPlant) return false;
      applyCell(row, SALES_PLANT, firstPlant);
      return true;
    };

    /** 큐 소진 — 시한이 지난 행은 포기한다(0건 후보는 공용 정리가 하위 값을 비운다). */
    const settlePending = (): void => {
      if (pending.size === 0) return;
      let applied = false;
      for (const [row, entry] of [...pending]) {
        if (settle(row)) applied = true;
        else if (Date.now() - entry.queuedAt > PENDING_TIMEOUT_MS) pending.delete(row);
      }
      if (applied) grid.invalidate();
    };

    // 키인·드롭다운 선택 커밋 직전 게이트. cancel = 편집값 폐기(셀은 이전 값 유지).
    //   stayInEditMode 는 쓰지 않는다 — 편집기가 갇혀 커서가 안 빠진다(정본 ContributeMainGrid).
    const editEndingHandler = (_sender: FlexGrid<T>, event: CellEditEndingEventArgs) => {
      if (!isCompanyCell(event.col)) return;
      const row = rowOf(event.row);
      if (!row) return;

      const typed = cellText(grid.activeEditor?.value);
      if (typed === '') return; // 비우기는 허용 — 필수 판정은 저장 검증 몫이다

      const companyNames = candidateNamesOf(SALES_COMPANY, row);
      // 후보 미도착이면 통과시키고 도착 시점에 재검증한다(미도착 != 후보 0건).
      queue(row, companyNames.length === 0);
      if (companyNames.length === 0) return;
      if (isCandidate(SALES_COMPANY, companyNames, typed)) return;

      pending.delete(row);
      event.cancel = true;
    };

    // 붙여넣기(편집모드가 아닌 그리드 단위 Ctrl+V) — 키인과 같은 게이트를 태운다.
    const pastingHandler = (_sender: FlexGrid<T>, event: CellRangeEventArgs) => {
      if (!isCompanyCell(event.col)) return;
      const row = rowOf(event.row);
      if (!row) return;

      const pasted = cellText(event.data);
      if (pasted === '') return;

      const companyNames = candidateNamesOf(SALES_COMPANY, row);
      queue(row, companyNames.length === 0);
      if (companyNames.length === 0) return;
      if (isCandidate(SALES_COMPANY, companyNames, pasted)) return;

      pending.delete(row);
      event.cancel = true;
    };

    // 커밋 직후 1차 확정 — 이미 캐시된 조합이면 여기서 Plant 가 바로 바뀐다.
    //   금지: 여기서 후보가 비었다고 Plant 를 비우지 말 것. 새 회사의 공장 조회는 공용
    //   registerTouchedRow 가 이 시점에 띄우므로 후보는 **항상 한 박자 뒤**에 온다.
    const editEndedHandler = (_sender: FlexGrid<T>, event: CellRangeEventArgs) => {
      if (!isCompanyCell(event.col)) return;
      const row = rowOf(event.row);
      if (!row || !pending.has(row)) return;
      if (settle(row)) grid.invalidate();
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
