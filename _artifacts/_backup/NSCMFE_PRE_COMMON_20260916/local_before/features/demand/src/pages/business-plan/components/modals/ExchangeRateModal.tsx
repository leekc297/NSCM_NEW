import {
  AllowMerging,
  CellRange,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE, CRUD_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { EXCHANGE_CATE, MENU_ID, MSG, SHEETS } from '../../business-plan.constants';
import { callSaveExchangeRate } from '../../utils/business-plan.api';
import { enumerateYyyymm } from '../../utils/business-plan.exchangePeriod';

import styles from './ExchangeRateModal.module.scss';
import { useExchangeRateModalStore } from './exchangeRateModalStore';

// ⭐ 조회 파라미터는 yyyymm(6) 계약 유지 — 화면 입력만 부모와 동일한 달력(PeriodField, yyyymmdd 8)
//   으로 통일하고 여기서 왕복 변환한다. from=1일 / to=말일로 펼친다.
const toYmd = (yyyymm: string, edge: 'start' | 'end'): string => {
  if (!/^\d{6}$/.test(yyyymm)) return '';
  const d = dayjs(`${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}-01`);
  return (edge === 'start' ? d : d.endOf('month')).format('YYYYMMDD');
};
const toYm = (yyyymmdd: string): string => (/^\d{8}$/.test(yyyymmdd) ? yyyymmdd.slice(0, 6) : '');

// 셀 값 → 숫자 (빈값/비숫자 = 0). 지운 셀과 0 은 같은 것으로 본다.
const toNum = (v: string | number | undefined | null): number => {
  if (v == null || v === '') return 0;
  const n = typeof v === 'number' ? v : Number(v.replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};

interface Props {
  open: boolean;
  // saved=true 시 부모가 메인 재조회 (AS-IS blnOK → GetFuturePriceInfo + FindData L3001~3003)
  modalClose: (saved: boolean) => void;
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
}

interface ExchangeRow {
  DIVISION_ID?: string;
  YYYYMMDD?: string; // 'D'||yyyymmdd (SP L54 실측 — 'D' prefix)
  CURRENCY?: string;
  UNIT_CURRENCY?: string;
  EXCHANGE_PRICE?: number | string;
  EDIT_YN?: string;
}

interface PivotRow {
  DIVISION_ID: string;
  CURRENCY: string;
  UNIT_CURRENCY: string;
  // ⭐ 2026-08-06 EDIT_YN → EDIT_FLAG 개명. 공통 DataGrid 의 GridUtils.isEditableCell 이 행 편집권을
  //   **EDIT_FLAG** 로 읽는다. 화면이 EDIT_YN 이라는 자기 이름을 쓰면 wrapper 는 그 값을 못 보고
  //   전부 편집 불가로 판정해, 화면 자체 formatItem 과 노란색 토글을 서로 뒤집는 경합이 생긴다.
  //   (원천은 조회 SP 의 EDIT_YN 컬럼 — 여기서 이름만 맞춰 준다.)
  EDIT_FLAG: string;
  // 'I' = Insert 신규 행 / '' = 조회 행 (AS-IS sActionFlag FlagI/FlagM 대응).
  //   ⚠ optional(`?`) 로 두면 타입이 `string | undefined` 가 되어 아래 인덱스 시그니처에 undefined 를
  //     포함시켜야 하는데, 그러면 PivotRow 가 DataGrid 의 WijmoRowItem 제약을 못 만족한다. 필수 + '' 기본.
  CRUD_TYPE: string;
  [yyyymmKey: string]: string | number;
}

// 고정 3컬럼 (AS-IS DMF0042_ExchangeRatePopup grid 좌측 키 — 정렬코드 단일문자 C, hook #96)
const EXCHANGE_COLUMNS = [
  { key: 'DIVISION_ID', header: 'Division', width: 90, align: 'C' as const },
  { key: 'CURRENCY', header: 'Currency', width: 90, align: 'C' as const },
  { key: 'UNIT_CURRENCY', header: 'Unit Currency', width: 100, align: 'C' as const },
];

// ⭐ DMF0042 Exchange Rate 모달 — forecast-price ExchangeRateModal(hook #108 No. 코너 정본) 구조 1:1 복제
//   + 데이터 계약 교체 (플랜 §E): 조회 = futurePriceData(DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA,
//   P_CATE='BP') / 저장 = exchangeRate SAVE(DMF0042_SAVE_DM_BP_EXCHANGE_RATE '^' bulk 6키 + 감사 BE주입).
//   AS-IS DMF0042_ExchangeRatePopup(677줄) — 환율 편집(EDIT_YN='Y' 행 × 월 셀) + 저장 + blnOK 재조회.
export const ExchangeRateModal = ({ open, modalClose, defaultDivision, defaultPeriod }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType<PivotRow>>(undefined);
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();
  // 확정 조회조건(Division/기간) — useTabProcQuery filters 참조 안정화 원천
  const applied = useExchangeRateModalStore(state => state.applied);
  const setApplied = useExchangeRateModalStore(state => state.setApplied);
  const divisionId = applied.divisionId;
  const [savedAny, setSavedAny] = useState(false);

  // 환율 저장 권한 — 설계서 [권한] 시트 '환율 저장' 행: 모달을 열 수 있는 그룹(EXCHANGE_RATE)과
  //   저장할 수 있는 그룹이 다르다. DM Viewer / SCP Planner 는 조회만 하고 저장 버튼이 없다.
  //   별도 버튼 코드가 없는 '모달 내 SAVE' 라 메인 SAVE 권한과 같은 그룹 집합을 쓴다.
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const canSave = hasButton('SAVE');

  // Division dropdown — 권한 기반 MyDivision combo (미응답 시 빈 목록 — 하드코딩 fallback 금지)
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (myDivisions ?? []) as Array<{ CODE?: string; NAME?: string }>;
    return arr.map(r => {
      const code = String(r.CODE ?? '');
      const name = String(r.NAME ?? code);
      const label = code === name || name === '' ? code : `${code} (${name})`;
      return { value: code, label };
    });
  }, [myDivisions]);

  const periodFrom = applied.periodFrom;
  const periodTo = applied.periodTo;

  // 표시 행 = 조회행(pivot) + Insert 신규행 + 삭제표식('D') 행. 단일 상태로 들고 Insert(선택 위치 splice)/
  //   Delete(기존행은 CRUD_TYPE='D' 표식으로 화면에 남기고, 미저장 Insert 행은 즉시 제거)를 직접 반영한다.
  //   조회·재조회·재오픈으로 pivotRows 가 새로 생기면 아래 재동기화 effect 가 이 상태를 pivotRows 로 되돌린다.
  const [rows, setRows] = useState<PivotRow[]>([]);

  // 삭제 대상은 별도 상태 없이 rows 안에서 CRUD_TYPE='D' 표식으로 들고 있다가 Save 시 active_flag='D' 로
  //   전송한다(SP DELETE 지원 — P_DMF0042_SAVE_DM_BP_EXCHANGE_RATE). 표식/편집/Insert 초기화는 openSeq
  //   증가 → pivotRows 재생성 → 아래 재동기화 effect 가 rows 를 새 pivotRows 로 되돌리며 일괄 수행한다.

  // ⭐ 모달 오픈 회차 — pivot 재생성 트리거 (2026-08-07 "닫았다 열어도 M 표식/편집값이 남는다").
  //   그리드는 행 객체를 **직접 변형**한다. react-query 는 재오픈 시 같은 data 객체를 캐시에서
  //   돌려주므로 pivot useMemo 가 재실행되지 않고, 그러면 **이전에 오염된 행 객체가 그대로 재사용**돼
  //   편집값과 CRUD_TYPE='M' 이 살아 돌아온다. 회차를 dep 에 넣어 매 오픈마다 새 객체로 다시 만든다.
  const [openSeq, setOpenSeq] = useState(0);

  // Currency 콤보는 DataGrid wrapper 가 컬럼 메타(cellCboDataTp='CurrencyList')를 보고 직접
  //   조회·부착한다 — 화면에서 별도 fetch/부착하지 않는다 (gridStaticColumns 주석 참조).

  useEffect(() => {
    if (open) {
      setApplied({
        divisionId: defaultDivision,
        periodFrom: defaultPeriod.start,
        periodTo: defaultPeriod.end,
      });
      setSavedAny(false);
      setOpenSeq(n => n + 1); // 오염된 행 객체 폐기 → pivot 재생성 → 재동기화 effect 가 rows 초기화
    }
  }, [open, defaultDivision, defaultPeriod, setApplied]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const startYyyymmdd = periodFrom.length === 6 ? `${periodFrom}01` : periodFrom;
  const endYyyymmdd = periodTo.length === 6 ? `${periodTo}31` : periodTo;
  const filters = useMemo(
    () => ({
      divisionId: divisionId || 'ALL',
      fromYyyymmdd: startYyyymmdd,
      toYyyymmdd: endYyyymmdd,
      cate: EXCHANGE_CATE, // 'BP' (AS-IS LoadData L2994)
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [divisionId, startYyyymmdd, endYyyymmdd, sesUserId]
  );
  // ⭐ 자동조회 — enabled=open (모달 자동조회 표준. Find 버튼은 재조회용)
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<
    MENU_ID,
    SHEETS.FUTURE_PRICE_DATA
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.FUTURE_PRICE_DATA,
    tabId: MENU_ID,
    filters,
    enabled: open,
  });
  const loading = isLoading || isFetching;

  const allRows = useMemo<ExchangeRow[]>(
    () => (data as { data?: ExchangeRow[] } | undefined)?.data ?? [],
    [data]
  );

  // 조회 기간 전체의 월 목록 — 헤더 기준 (AS-IS InitSpread 의 SPREAD_TITLE SP 대응. util 주석 참조).
  //   데이터가 있는 월만 모으면 종료월 전에 환율이 끊겼을 때 헤더도 거기서 잘린다(사용자 보고 2026-09-01).
  const periodYmKeys = useMemo(() => enumerateYyyymm(periodFrom, periodTo), [periodFrom, periodTo]);

  // ===== long → wide pivot (2단 헤더 YYYY/MM — 정본 구조 1:1) =====
  const { pivotRows, ymKeys, origins } = useMemo(() => {
    const groupMap = new Map<string, PivotRow>();
    // 조회 기간의 모든 월을 먼저 담는다 = 값이 없는 월도 빈 컬럼으로 헤더에 남는다.
    //   빈 컬럼은 origins 에 키가 없어 원본 0 으로 판정되므로 collectEdits 가 변경분으로 오인하지 않는다.
    const ymSet = new Set<string>(periodYmKeys);
    // ⭐ 행 → (ym → 서버 원본값). 편집을 원래 값으로 되돌렸는지 판정하는 유일한 기준.
    //   키가 **없으면 원래 빈 셀** — 이 구분이 중요하다(빈 셀에 입력했다 지우면 0 이 아니라 '없음').
    const origins = new Map<PivotRow, Map<string, number>>();
    for (const r of allRows) {
      const div = String(r.DIVISION_ID ?? '');
      const cur = String(r.CURRENCY ?? '');
      const uc = String(r.UNIT_CURRENCY ?? '');
      // YYYYMMDD = 'D'||yyyymmdd (SP 실측) — prefix 제거 후 yyyymm 추출
      const raw = String(r.YYYYMMDD ?? '').replace(/^D/, '');
      const ym = raw.slice(0, 6);
      if (!div || !cur || !uc || !/^\d{6}$/.test(ym)) continue;
      ymSet.add(ym);
      const key = `${div}|${cur}|${uc}`;
      if (!groupMap.has(key)) {
        groupMap.set(key, {
          DIVISION_ID: div,
          CURRENCY: cur,
          UNIT_CURRENCY: uc,
          EDIT_FLAG: String(r.EDIT_YN ?? 'N'), // SP 는 EDIT_YN, wrapper 는 EDIT_FLAG 를 읽는다
          CRUD_TYPE: '', // 조회 행 (Insert 행만 'I')
        });
      }
      const row = groupMap.get(key)!;
      const price =
        typeof r.EXCHANGE_PRICE === 'number' ? r.EXCHANGE_PRICE : Number(r.EXCHANGE_PRICE);
      if (!Number.isNaN(price)) {
        row[`M_${ym}`] = price;
        // ⭐ 서버 원본 스냅샷 — 편집 되돌림 판정 기준 (아래 origins 주석 참조).
        let om = origins.get(row);
        if (!om) {
          om = new Map<string, number>();
          origins.set(row, om);
        }
        om.set(ym, price);
      }
    }
    const list = [...groupMap.values()].sort((a, b) => {
      if (a.DIVISION_ID !== b.DIVISION_ID) return a.DIVISION_ID.localeCompare(b.DIVISION_ID);
      if (a.CURRENCY !== b.CURRENCY) return a.CURRENCY.localeCompare(b.CURRENCY);
      return a.UNIT_CURRENCY.localeCompare(b.UNIT_CURRENCY);
    });
    return { pivotRows: list, ymKeys: [...ymSet].sort(), origins };
    // openSeq — 재오픈 시 오염된 행 객체를 버리고 새로 만든다 (선언부 주석 참조).
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [allRows, openSeq, periodYmKeys]);

  // ⭐ 원본 스냅샷 ref — 핸들러/저장이 effect dep 밖에서 참조한다.
  const originsRef = useRef<Map<PivotRow, Map<string, number>>>(new Map());
  originsRef.current = origins;

  /**
   * ⭐⭐ 변경분 = **그리드 현재 상태 ↔ 서버 원본** 직접 대조 (2026-08-07 재설계).
   *
   * 이전엔 편집 이벤트에서 모아 둔 editsRef 를 저장이 그대로 신뢰했는데, 이벤트 배선이 한 군데라도
   * 어긋나면(핸들러 미등록/다른 경로로 값 변경/클로저 stale) editsRef 가 비어 저장이 "수정한 내용이
   * 없습니다" 로 끝났다. 화면에는 분명히 고친 값이 보이는데도.
   *
   * 그래서 **저장 시점에 이 함수로 직접 계산**한다. 이벤트가 한 번도 안 불렸어도 결과가 옳다.
   * editsRef/카운트는 버튼 라벨용 캐시일 뿐 저장의 근거가 아니다.
   *
   * 월 목록은 그리드 컬럼에서 그때그때 뽑는다(클로저 스냅샷 금지). 행 M 표식도 여기서 확정한다.
   */
  const collectEdits = (
    g: FlexGridType<PivotRow> | null | undefined
  ): Array<{ row: PivotRow; ym: string; value: number }> => {
    const out: Array<{ row: PivotRow; ym: string; value: number }> = [];
    if (!g) return out;
    const yms: string[] = [];
    for (let c = 0; c < g.columns.length; c++) {
      const b = g.columns[c]?.binding ?? '';
      if (/^M_\d{6}$/.test(b)) yms.push(b.slice(2));
    }
    for (let i = 0; i < g.rows.length; i++) {
      const item = g.rows[i]?.dataItem as PivotRow | undefined;
      if (!item) continue;
      // 삭제 표식('D') 행은 편집 수집·M 재판정 대상에서 제외한다 — 표식이 유지되고, 이 행의 셀 값
      //   변화는 저장 payload 에 M 으로 새어 나가지 않는다(삭제분은 handleSave 가 origins 로 조립).
      if (item.CRUD_TYPE === CRUD_TYPE.DELETE) continue;
      const om = originsRef.current.get(item);
      let changed = false;
      for (const ym of yms) {
        const cur = toNum(item[`M_${ym}`]);
        // origins 에 키가 없으면 원래 빈 셀 = 0 이 원본.
        //   Insert 행은 origins 자체가 없어 입력한 값이 전부 변경분이 된다(의도).
        if (cur !== (om?.get(ym) ?? 0)) {
          out.push({ row: item, ym, value: cur });
          changed = true;
        }
      }
      if (item.CRUD_TYPE !== 'I') item.CRUD_TYPE = changed ? 'M' : '';
    }
    return out;
  };

  // pivotRows 재생성(조회·재조회·재오픈 openSeq) 시 표시행 재동기화 — 미저장 Insert/삭제표식('D') 폐기.
  useEffect(() => {
    setRows(pivotRows);
  }, [pivotRows]);

  // 그리드 표시 행 = rows 상태 그대로 (조회행 + Insert 신규행, Delete 반영된 최종 목록).
  const displayRows = rows;

  const fixedBindings = useMemo(() => EXCHANGE_COLUMNS.map(c => c.key), []);

  const gridStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      EXCHANGE_COLUMNS.map(
        (c): RawFlexGridColumnConfig => ({
          colNm: c.key,
          colLblNm: c.header,
          colWth: c.width,
          horzAlgnCd: c.align,
          fixed: true,
          visible: true,
          display: true,
          // ⭐ Currency/Unit Currency = Insert 행에서만 편집 (INSERT_ONLY — wrapper 의
          //   isEditableCell 이 CRUD_TYPE='I' 행만 개방). Division 은 조회조건 값 고정이라 조회 전용.
          //   ⚠ MANDATORY(IM) 가 아니라 OPTIONAL(IO) 을 쓴다 — IM 은 헤더에 필수 빨간점(is-required)을
          //     그리는데, 그 표식은 행과 무관하게 컬럼 전체에 붙어 조회 행까지 편집 가능해 보인다.
          //     필수 검증은 handleSave 의 Insert 행 검사가 담당하므로 표식만 뺀다 (2026-08-06).
          // Currency 는 KRW 고정·수정 불가 (SEARCH_ONLY — Division 과 동일. 2026-09-02 사용자 요구).
          //   Insert 행에서 편집 가능한 것은 Unit Currency 뿐이다. 표시용 콤보 dataMap 은 유지(아래)라
          //   기존 조회행의 통화 코드→명 표시는 그대로다.
          inputTpCd:
            c.key === 'DIVISION_ID' || c.key === 'CURRENCY'
              ? CELL_INPUT_EDIT_TYPE.SEARCH_ONLY
              : CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY,
          // ⭐⭐ Currency/Unit 콤보 = **wrapper 정식 경로**로 위임 (2026-08-06 — 수동 부착 3회 실패 후 전환).
          //   DataGrid(L404~431) 는 cellCtrlObjTpCd=COMBO + cellCboDataTp 를 보고 ① 콤보를 직접 조회하고
          //   ② new DataMap(rows,'CODE','NAME') 을 만들어 컬럼에 붙인다.
          //   ⚠ 그 매핑 코드는 **조건에 안 맞는 컬럼의 dataMap 을 항상 undefined 로 덮는다**(L427~431).
          //     그래서 화면에서 col.dataMap 을 손으로 붙이면 컬럼 재적용 때마다 지워지고, updatedLayout
          //     재부착과 순서 경합이 나 "드롭다운은 열리는데 선택이 안 먹는" 상태가 된다.
          //     wrapper 에 맡기면 부착 주체가 하나라 그 경합이 사라진다.
          cellCtrlObjTpCd: c.key === 'DIVISION_ID' ? undefined : CELL_CONTROL_TYPE.COMBO,
          cellCboDataTp: c.key === 'DIVISION_ID' ? undefined : 'CurrencyList',
          // ⚠ uppercase 는 켜지 않는다 — wrapper 의 setHandleUppercase 가 cellEditEnded 에서
          //   `setCellData(r, c, v, coerce=true)` 를 호출하는데, dataMap 이 붙은 컬럼에서 coerce 는
          //   값을 display→key 로 되돌리는 경로라 방금 고른 값을 덮어쓸 수 있다.
          uppercase: false,
        })
      ),
    []
  );
  // ⭐ 대상 년월 2단 헤더 — nested columnGroups(년 그룹→월 leaf). 환율 셀 = 편집 가능 (EDIT_YN 행 게이트).
  const gridDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const byYear = new Map<string, FlexGridColumnConfig[]>();
    for (const ym of ymKeys) {
      const y = ym.slice(0, 4);
      if (!byYear.has(y)) byYear.set(y, []);
      byYear.get(y)!.push({
        binding: `M_${ym}`,
        header: ym.slice(4, 6),
        width: 90,
        align: 'right',
        format: 'n2',
        allowSorting: false,
        visible: true,
        // ⭐ 편집권을 wrapper 단일 판정으로 넘긴다 (2026-08-06) — OPTIONAL 이면 isEditableCell 이
        //   `EDIT_FLAG !== 'N'` 으로 계산해 노란색·편집 개방을 한 곳에서 처리한다.
        //   구: 이 값이 없어 wrapper 는 '편집 불가'로 보고 노란색을 지우고, 화면 formatItem 은
        //   칠하는 경합이 생겨 핸들러 등록 순서에 따라 결과가 뒤집혔다(조회 직후 안 칠해짐 →
        //   Insert 로 effect 재실행되면 전부 칠해짐).
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
      });
    }
    return [...byYear.entries()].map(([y, cols]) => ({
      header: y,
      align: 'center',
      columns: cols,
    }));
  }, [ymKeys]);

  // ⭐ 헤더 머지/코너/편집 핸들러 — useEffect + gridRef (initialized prop deprecated)
  //
  // ⚠⚠ **그리드 준비될 때까지 재시도**한다 (2026-08-07 — "기존 행을 고쳐도 저장이 안 먹힘" 원인).
  //   FlexGrid 는 조회 데이터가 도착한 **뒤에** 생성되는데, 이 effect 는 그 전에 실행되고 끝난다.
  //   예전처럼 `if (!g) return;` 으로 포기하면 deps(displayRows)가 다시 바뀌지 않는 한 핸들러가
  //   **영영 안 붙는다**. 그 상태에서 기존 행을 고치면 아무 일도 안 일어나고, Insert 를 눌러
  //   displayRows 가 바뀐 뒤에야 붙어서 "신규행 추가하면 이전 수정이 그제서야 카운트되는" 증상이 됐다.
  //   같은 파일의 헤더 높이 정규화 effect 가 rAF 루프를 쓰는 것과 동일한 사유.
  useEffect(() => {
    let raf = 0;
    let cleanup: (() => void) | undefined;

    const setup = (): boolean => {
      const g = gridRef.current;
      if (!g || !g.columnHeaders) return false;

      const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
        if (e.panel.cellType === CellType.ColumnHeader) {
          e.cell.style.textAlign = 'center';
        }
        // ⭐ No. 코너 헤더 (hook #108 — setCellData 재귀 가드)
        if (e.panel.cellType === CellType.TopLeft) {
          if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
          e.cell.style.textAlign = 'center';
          return;
        }
        // ⭐ 편집 가능 셀 Yellow / 편집 게이트는 **공통 wrapper 단독 책임** (2026-08-06).
        //   화면이 formatItem 에서 wj-cell-editable 을 같이 토글하면 wrapper(dataGridUtils L219)와
        //   같은 클래스를 두고 경합해 핸들러 등록 순서로 결과가 뒤집힌다. 컬럼의 _inputEditType +
        //   행의 EDIT_FLAG/CRUD_TYPE 만 정확히 주면 wrapper 가 색과 개방을 모두 맞게 계산한다.
      };
      g.formatItem.addHandler(formatHandler);

      /**
       * ⭐ 변경분 **전체 재계산** (2026-08-07 — "값 넣었다 지웠는데 M 표식이 남는다" 최종 대응).
       *
       * 구현은 편집 이벤트마다 해당 셀만 증분 기록했는데, 그 방식은 이벤트를 한 번이라도 놓치거나
       * 값이 예상 밖 타입(null/NaN)으로 들어오면 상태가 어긋난 채 **영구히** 남는다. 실제로
       *   ① 지운 셀이 0 으로 기록돼 저장 시 DB 원본이 0 으로 덮이고
       *   ② Save(N) 카운트가 안 줄고
       *   ③ 행 M 표식이 안 사라졌다.
       *
       * 그래서 증분을 버리고 **행 객체 현재값 ↔ 서버 원본(origins) 전량 대조**로 바꾼다.
       * 어떤 경로로 값이 바뀌었든(편집/붙여넣기/Delete 키) 결과가 항상 실제 상태와 일치한다 —
       * 자기 교정. 행 7 × 월 7 수준이라 비용은 무시할 만하다.
       *
       * 행 M 표식도 여기서 확정한다. 공통 EditTracker 도 CRUD_TYPE 을 건드리지만 이 핸들러가
       * grid 초기화 이후 등록돼 마지막에 실행되므로 여기 값이 최종이다.
       */
      //   ⚠ 행 M 표식 갱신용 — 저장의 근거는 handleSave 가 직접 부르는 collectEdits 다.
      //   반환값(변경 건수)은 쓰지 않는다. Save 버튼에 건수를 표시하지 않기로 했다 (2026-08-25 사용자 요구).
      const recomputeEdits = (s: FlexGridType<PivotRow>) => {
        collectEdits(s); // 부수효과: 행 CRUD_TYPE('M'/'') 확정
        s.invalidate();
      };

      // 편집 종료 — 변경 수집 ('^' bulk 저장 대상) + Currency/Unit 대문자 정규화
      const cellEditEndedHandler = (s: FlexGridType<PivotRow>, e: { row: number; col: number }) => {
        const binding = s.columns[e.col]?.binding ?? '';
        const row = s.rows[e.row]?.dataItem as PivotRow | undefined;
        if (!row) return;
        if (binding === 'CURRENCY' || binding === 'UNIT_CURRENCY') {
          // ⚠ 여기서 col.dataMap 을 원복하지 않는다 — 상시 부착이 드롭다운 동작의 전제.
          //   값은 행 객체에 직접 쓴다(setCellData 의 coerce 경로를 타지 않기 위함).
          row[binding] = String(row[binding] ?? '')
            .trim()
            .toUpperCase();
          return;
        }
        if (!/^M_\d{6}$/.test(binding)) return;
        recomputeEdits(s);
      };
      g.cellEditEnded.addHandler(cellEditEndedHandler);
      // ⭐ Delete 키/붙여넣기는 편집 세션(cellEditEnded)을 거치지 않고 셀 값을 바꾼다 — wijmo 는 이
      //   경로를 paste 이벤트로 흘린다. 여기서도 재계산해야 "지웠는데 표식이 남는" 구멍이 막힌다.
      const pastedHandler = () => recomputeEdits(g);
      g.pastedCell?.addHandler(pastedHandler);

      g.allowMerging = AllowMerging.All;
      for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
      class ExchangeMerge extends MergeManager {
        getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
          const col = panel.columns[c];
          if (!col) return null;
          const binding = col.binding ?? '';
          if (panel.cellType === CellType.TopLeft) {
            return new CellRange(0, 0, panel.rows.length - 1, panel.columns.length - 1);
          }
          if (panel.cellType === CellType.ColumnHeader) {
            if (fixedBindings.includes(binding)) {
              return new CellRange(0, c, panel.rows.length - 1, c);
            }
            // 동적 1단(년도) 수평 머지 — 커스텀 MergeManager 설치 시 네이티브 span 무효 (hook #108 ②)
            if (binding.startsWith('M_') && r === 0) {
              const yearOf = (b: string): string => (b.startsWith('M_') ? b.slice(2, 6) : '');
              const y = yearOf(binding);
              let c1 = c,
                c2 = c;
              while (c1 > 0 && yearOf(panel.columns[c1 - 1]?.binding ?? '') === y) c1--;
              while (
                c2 < panel.columns.length - 1 &&
                yearOf(panel.columns[c2 + 1]?.binding ?? '') === y
              )
                c2++;
              if (c1 === c2) return null;
              return new CellRange(0, c1, 0, c2);
            }
            return null;
          }
          if (panel.cellType === CellType.Cell) {
            if (binding === 'DIVISION_ID' || binding === 'CURRENCY') {
              const view = panel.rows;
              const ri = (i: number): PivotRow | undefined =>
                view[i]?.dataItem as PivotRow | undefined;
              if (!ri(r)) return null;
              // ⭐ Insert 행은 머지 대상 제외 — 머지된 셀은 내용을 범위 최상단에만 그려서,
              //   Currency 미입력(빈값) 신규 행이 위 행과 묶이면 콤보로 고른 값이 안 보인다.
              if (ri(r)?.CRUD_TYPE === 'I') return null;
              const sameRow = (a: number, b: number): boolean => {
                const ra = ri(a);
                const rb = ri(b);
                if (!ra || !rb) return false;
                if (ra.CRUD_TYPE === 'I' || rb.CRUD_TYPE === 'I') return false;
                if (binding === 'DIVISION_ID') return ra.DIVISION_ID === rb.DIVISION_ID;
                return ra.DIVISION_ID === rb.DIVISION_ID && ra.CURRENCY === rb.CURRENCY;
              };
              let r1 = r,
                r2 = r;
              while (r1 > 0 && sameRow(r1 - 1, r)) r1--;
              while (r2 < view.length - 1 && sameRow(r2 + 1, r)) r2++;
              if (r1 === r2) return null;
              return new CellRange(r1, c, r2, c);
            }
          }
          return null;
        }
      }
      g.mergeManager = new ExchangeMerge();
      // ⚠ 편집 중에는 invalidate 금지 — refresh() 첫 줄이 finishEditing() 이라 열려 있는 콤보 에디터가
      //   닫히고 방금 고른 값이 커밋 전에 날아간다 (2026-08-06 "콤보 선택이 안 먹음" 원인 중 하나).
      if (!g.activeEditor) g.invalidate(true);

      cleanup = () => {
        try {
          g.formatItem?.removeHandler(formatHandler);
          g.cellEditEnded?.removeHandler(cellEditEndedHandler);
          g.pastedCell?.removeHandler(pastedHandler);
        } catch {
          /* unmount race */
        }
      };
      return true;
    };

    // 그리드가 준비될 때까지 프레임마다 재시도 — 준비되면 즉시 멈춘다.
    const tick = () => {
      if (!setup()) raf = requestAnimationFrame(tick);
    };
    tick();

    return () => {
      cancelAnimationFrame(raf);
      cleanup?.();
    };
  }, [open, displayRows, ymKeys, fixedBindings]);

  // ⭐⭐ 헤더 총높이 48px 상시 정규화 (2단=24×2 — CustomDialog open 애니메이션 지연 build 재발 경로 방어)
  useEffect(() => {
    if (!open) return;
    let raf = 0;
    let attached: FlexGridType<PivotRow> | null = null;
    const normalizeHeader = () => {
      const g = gridRef.current;
      if (!g) return;
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const per = Math.round(48 / headerRows.length);
      const ok =
        Math.round(headerRows.defaultSize) === per &&
        Array.from({ length: headerRows.length }).every(
          (_, i) => Math.round(headerRows[i]?.height ?? 0) === per
        );
      if (ok) return;
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };
    const loop = () => {
      const g = gridRef.current;
      if (g && g !== attached) {
        try {
          attached?.updatedLayout.removeHandler(normalizeHeader);
        } catch {
          /* destroyed instance */
        }
        g.updatedLayout.addHandler(normalizeHeader);
        attached = g;
      }
      try {
        normalizeHeader();
      } catch {
        /* unmount race */
      }
      raf = requestAnimationFrame(loop);
    };
    loop();
    return () => {
      cancelAnimationFrame(raf);
      try {
        attached?.updatedLayout.removeHandler(normalizeHeader);
      } catch {
        /* unmount race */
      }
    };
  }, [open]);

  const handleFind = () => {
    if (periodFrom > periodTo) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_INVERTED, '_시작 월이 종료 월보다 늦을 수 없습니다.'),
      });
      return;
    }
    setOpenSeq(n => n + 1); // 편집·삭제표식 폐기 → pivot 재생성 → 재동기화 effect 가 rows 초기화
    void refetch?.();
  };

  // ⭐ Insert — Division/Currency(KRW) 고정, Unit 만 편집. 선택행 위치에 삽입해 선택행을 아래로 민다
  //   (= 선택행 상단 추가. 2026-09-02 사용자 요구). 선택이 없으면 맨 끝에 붙인다.
  const handleInsert = () => {
    const newRow: PivotRow = {
      DIVISION_ID: divisionId,
      // Currency = KRW 고정 (컬럼도 SEARCH_ONLY 라 수정 불가). 'CurrencyList' 콤보의 코드라 표시 정상.
      CURRENCY: 'KRW',
      UNIT_CURRENCY: '',
      EDIT_FLAG: 'Y',
      CRUD_TYPE: 'I',
    };
    const sel = gridRef.current?.selection?.row ?? -1;
    setRows(prev => {
      const idx = sel >= 0 && sel <= prev.length ? sel : prev.length;
      const copy = [...prev];
      copy.splice(idx, 0, newRow);
      return copy;
    });
  };

  // ⭐ Delete — 선택행 처리 (2026-09-02 사용자 요구). 기존(DB) 행은 화면에서 지우지 않고 상태 컬럼에
  //   'D'(빨강) 표식만 남기고, 실제 삭제는 Save 시 active_flag='D' 로 전송한다(SP DELETE 지원). 미저장
  //   Insert 행은 DB 에 없으니 즉시 제거한다(표식 불필요). 선택이 없으면 안내.
  const handleDelete = () => {
    const sel = gridRef.current?.selection?.row ?? -1;
    const target = sel >= 0 ? rows[sel] : undefined;
    if (!target) {
      // 사용자 지정 문구(리터럴) — 별도 등록 MSG 없음.
      void setAlert({ type: 'alert', content: '삭제할 행을 선택해 주세요.' });
      return;
    }
    if (target.CRUD_TYPE === CRUD_TYPE.INSERT) {
      setRows(prev => prev.filter(r => r !== target));
      return;
    }
    // 기존 행: CRUD_TYPE='D' 표식만 (행 객체 직접 변형 → 상태 컬럼 dataset.status='D'). 새 배열로
    //   재렌더 + invalidate 로 상태 표시를 즉시 갱신한다.
    target.CRUD_TYPE = CRUD_TYPE.DELETE;
    setRows(prev => [...prev]);
    gridRef.current?.invalidate();
  };

  // ⭐ 저장 — '^' bulk 6키 (DMF0042_SAVE_DM_BP_EXCHANGE_RATE — activeFlag='I'/'M'/'D', yyyymmdd=월 1일)
  const handleSave = async () => {
    // Insert 신규행 = rows 중 CRUD_TYPE='I' (모델이 단일 rows 상태로 통합됨).
    const insertedRows = rows.filter(r => r.CRUD_TYPE === CRUD_TYPE.INSERT);
    // (1) Insert 행 필수값 — Currency(KRW 고정) / Unit 미선택 차단 (AS-IS SaveData 첫 결손 필드 알림 1:1)
    for (const r of insertedRows) {
      const missing = !r.CURRENCY ? '[Currency]' : !r.UNIT_CURRENCY ? '[Unit Currency]' : '';
      if (missing) {
        void setAlert({
          type: 'alert',
          content: t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', missing),
        });
        return;
      }
    }
    // (2) 키 중복 차단 — 남아 있는 조회 행/다른 Insert 행과 Division|Currency|Unit 이 겹치면 막는다.
    //   삭제 표식('D') 행은 곧 삭제되므로 대상에서 제외한다(삭제 후 같은 키 재삽입 허용).
    const existingRows = rows.filter(
      r => r.CRUD_TYPE !== CRUD_TYPE.INSERT && r.CRUD_TYPE !== CRUD_TYPE.DELETE
    );
    const seen = new Set(
      existingRows.map(r => `${r.DIVISION_ID}|${r.CURRENCY}|${r.UNIT_CURRENCY}`)
    );
    for (const r of insertedRows) {
      const key = `${r.DIVISION_ID}|${r.CURRENCY}|${r.UNIT_CURRENCY}`;
      if (seen.has(key)) {
        // 사용자 지정 문구(리터럴) — 별도 등록 MSG 없음 (2026-09-02 사용자 요구).
        void setAlert({ type: 'alert', content: '중복된 데이터가 있습니다' });
        return;
      }
      seen.add(key);
    }
    // (3) 저장 엔트리 = 편집분 + 삭제분. 편집분은 그리드에서 직접 계산(editsRef 신뢰 금지 — 이벤트
    //   미발화여도 화면에 보이는 변경이 대상). 삭제분은 CRUD_TYPE='D' 표식 행마다 서버 원본(origins)의
    //   모든 월에 대해 'D' 로 조립한다(SP DELETE 는 keyset + YYYYMMDD 매칭).
    type SaveEntry = { row: PivotRow; ym: string; value: number; flag: 'I' | 'M' | 'D' };
    const editEntries: SaveEntry[] = collectEdits(gridRef.current).map(e => ({
      ...e,
      // Insert 행 'I' / 기존 행 'M' (AS-IS sActionFlag).
      flag: e.row.CRUD_TYPE === CRUD_TYPE.INSERT ? 'I' : 'M',
    }));
    const deleteEntries: SaveEntry[] = [];
    for (const dr of rows.filter(r => r.CRUD_TYPE === CRUD_TYPE.DELETE)) {
      const om = originsRef.current.get(dr);
      if (om)
        for (const [ym, price] of om) deleteEntries.push({ row: dr, ym, value: price, flag: 'D' });
    }
    const entries = [...editEntries, ...deleteEntries];
    if (entries.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }
    const join = (sel: (e: SaveEntry) => string): string => entries.map(sel).join('^');
    const res = await callSaveExchangeRate({
      activeFlag: join(e => e.flag),
      divisionId: join(e => e.row.DIVISION_ID),
      yyyymmdd: join(e => `${e.ym}01`),
      currency: join(e => e.row.CURRENCY),
      unitCurrency: join(e => e.row.UNIT_CURRENCY),
      exchangePrice: join(e => String(e.value)),
      createdBy: join(() => sesUserId),
      lastUpdatedBy: join(() => sesUserId),
    });
    if (!res.ok) {
      void setAlert({
        type: 'alert',
        content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
      });
      return;
    }
    void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
    // ⭐ 저장 후에도 행 객체를 새로 만든다 (2026-08-07). refetch 가 **같은 data 객체**를 돌려주면
    //   pivot useMemo 가 재실행되지 않아 CRUD_TYPE='M' 이 붙은 옛 행이 그대로 남는다 —
    //   "저장했는데 수정 표식이 안 사라진다" 경로. openSeq 를 올려 강제로 재생성한다.
    setOpenSeq(n => n + 1);
    setSavedAny(true);
    void refetch?.();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      handleClose={() => modalClose(savedAny)}
      disableButtonCancel
      // ⭐⭐ Insert 행 Currency/Unit 셀 콤보 선택이 먹히게 하는 필수 조건
      //   (forecast-price ExchangeRateModal 2026-07-30 실측 확정 — 여기 누락이 "드롭다운은 열리는데
      //    값이 선택 안 됨"의 진짜 원인이었다. 2026-08-06).
      //   Wijmo 드롭다운 ListBox 는 `MuiDialog-container` **밖에** append 되고, MUI FocusTrap 이
      //   포커스를 컨테이너로 되돌리는 순간 Wijmo 가 포커스 상실로 finishEditing() → 에디터를 파괴한다.
      //   그 뒤 항목을 클릭하면 finishEditing() 이 `_edt` null 로 조기 반환해 값이 버려지고 리스트만 닫힌다.
      //   ⚠ 그리드/dataMap 쪽을 아무리 고쳐도 이 prop 없이는 절대 동작하지 않는다.
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00661', 'Exchange Rate')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleFind}
            conditions={
              <>
                {/* size 4 — 값이 division 1건 고정이라 6칸(약 600px)은 과하다. 가장 긴 표기
                    '40 (40 Mobility & IT Battery)' 가 잘리지 않는 선까지만 줄인다 (2026-09-02). */}
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00663', 'Div')}
                    labelAlign='right'
                    render={() => (
                      // ⭐ 화면 division 고정 — 비활성 (2026-08-06 사용자 지시. Ver. Cutoff 모달과 동일 규약).
                      //   Insert 행의 DIVISION_ID 도 이 값을 그대로 쓰므로 모달 안에서 바뀌면 안 된다.
                      <CustomDropdown
                        value={divisionId}
                        options={divisionOptions}
                        onChange={(_, option) => setApplied({ divisionId: String(option) })}
                        disabled
                      />
                    )}
                  />
                </Grid>
                {/* ⭐ Period — 부모 화면(BusinessPlanForm)과 동일한 카탈로그 PeriodField 로 통일
                    (2026-08-06 사용자 지시. 구: YYYYMM 수기 InputField 2개 — 달력 없음/포맷 오입력 가능).
                    조회 파라미터는 yyyymm(6) 계약 그대로 — toYmd/toYm 왕복 변환. */}
                <PeriodField
                  gridSize={6}
                  start={toYmd(periodFrom, 'start')}
                  end={toYmd(periodTo, 'end')}
                  onChange={(start, end) => {
                    setApplied({ periodFrom: toYm(start), periodTo: toYm(end) });
                  }}
                />
              </>
            }
          />

          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea
              title=''
              count={displayRows.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<PivotRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                className={styles.grid}
                itemsSource={displayRows}
                staticColumns={gridStaticColumns}
                dynamicColumns={gridDynamicColumns}
                autoGenerateColumns={false}
                frozenColumns={fixedBindings.length}
                allowSorting={false}
                allowMerging={AllowMerging.All}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            {canSave && (
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                buttonLabel='Insert'
                onClick={handleInsert}
              />
            )}
            {canSave && (
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                buttonLabel='Delete'
                onClick={handleDelete}
              />
            )}
            {canSave && (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel='Save'
                onClick={() => void handleSave()}
              />
            )}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={() => modalClose(savedAny)}
            />
          </div>
        </div>
      }
    />
  );
};
