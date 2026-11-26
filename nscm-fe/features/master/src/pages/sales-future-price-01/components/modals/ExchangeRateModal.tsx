import { toggleClass } from '@mescius/wijmo';
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
import dayjs, { type Dayjs } from 'dayjs';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  DIVISION,
  EXCHANGE_RATE_COLUMNS,
  MENU_ID,
  MSG,
  SHEETS,
} from '../../sales-future-price-01.constants';
import { enumerateYyyymm } from '../../utils/period.util';

import styles from './ExchangeRateModal.module.scss';
import { useExchangeRateModalStore } from './exchangeRateModalStore';

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
  // DMF0020_01: User Define 환율 저장 가능 여부 — 부모가 편집 가능 사업부(82) && exchange 시트 SAVE 버튼 권한으로
  //   정한다. 행마다 EDIT_YN='Y' 인지는 이 팝업이 다시 본다(사용자 결정 2026-11-10, 세 조건 모두 만족할 때만 입력).
  canSave?: boolean;
  // 저장한 뒤 팝업을 닫을 때 한 번 부른다 — 저장 프로시저가 82 판가(KRW · USD)와 매출계획 금액을 다시 계산하므로
  //   메인 그리드를 다시 조회해야 화면 값이 맞는다(사용자 결정 2026-11-10).
  onSavedClose?: () => void;
}

// DMF0020_01 82 2줄 표시의 행 구분 값(Measure 칸). 화면 라벨이 아니라 행 구분 데이터 값으로 둔다 —
//   설계서 [popup-1] B40 의 표기 그대로이며 다국어 코드 등록 대상이 아니다(LOC · KRW 같은 Measure 값과 같은 취급).
const ROW_KIND = {
  IF: 'BPS I/F',
  USER: 'User Defined', // 2026-11-25 요청으로 표기 변경(종전 'User Define')
} as const;

// 행에 숨겨 두는 칸 — 그 달 환율 행의 YYYYMMDD(저장 키)와 사용자 편집 권한(EDIT_YN). 그리드 컬럼이 아니다.
const ymdKeyOf = (ym: string): string => `__YMD_${ym}`;
const EDIT_YN_KEY = '__EDIT_YN';

// 권한 combo 미응답 시 fallback (형제 SalesPriceVersionModal 동일) — Division_id + Division name 표기.
const DIVISION_FALLBACK: Array<{ value: string; label: string }> = [
  { value: '40', label: '40 (Mobility & IT Battery)' },
  { value: '81', label: '81 (ESS Battery)' },
  { value: '82', label: '82 (Power Tool)' },
];

// Period(YYYYMM) ↔ dayjs — 메인 화면 PeriodField 와 동일하게 달력(DatePickerCalendar) 사용.
//   customParseFormat plugin 미등록 환경 → 'YYYY-MM-01' 로 변환해 파싱. 저장/비교는 계속 YYYYMM.
const ymToDayjs = (s: string): Dayjs | null =>
  s && s.length === 6 ? dayjs(`${s.slice(0, 4)}-${s.slice(4, 6)}-01`) : null;

interface ExchangeRow {
  DIVISION_ID?: string;
  YYYYMMDD?: string;
  YYYYMM?: string;
  CURRENCY?: string;
  UNIT_CURRENCY?: string;
  EXCHANGE_PRICE?: number | string;
  // DMF0020_01 (PKG_DMF0020_01.P_DMF0020_01_GET_FUTUREPRICE_INFO L421~424)
  //   IF_EXCHANGE_PRICE  : BPS I/F 값 = NVL(ATTRIBUTE1, 사용자 값이 없을 때의 EXCHANGE_PRICE)
  //   USER_EXCHANGE_PRICE: User Define 값 = ATTRIBUTE2
  //   EDIT_YN            : 사용자의 사업부 편집 권한(SCM_ADM_USER_MNU_EDIT_AUTH_V)
  IF_EXCHANGE_PRICE?: number | string | null;
  USER_EXCHANGE_PRICE?: number | string | null;
  EDIT_YN?: string;
}

interface PivotRow {
  DIVISION_ID: string;
  CURRENCY: string;
  UNIT_CURRENCY: string;
  // MEASURE: 2줄 모드 행 구분(ROW_KIND) — index signature 로 받는다.
  [yyyymmKey: string]: string | number | null;
}

// 숫자 칸 값 → number | null (빈 값 · 숫자 아님은 null).
const toNum = (v: unknown): number | null => {
  if (v === null || v === undefined || v === '') return null;
  const n = typeof v === 'number' ? v : Number(v);
  return Number.isNaN(n) ? null : n;
};

// AS-IS DMF0020_SalesFuturePricePopUp.cs L141~194 InitSpread + L324~334 PIVOT 클라이언트 측 변환
//   SP P_DMF0020_GET_FUTUREPRICE_INFO (long format) → grid wide format
//   동적 col binding = `M_yyyymm` (캡쳐 2-row header: YYYY / MM)
//   좌측 fixed cols Restricted merge (Division / Currency)
export const ExchangeRateModal = ({
  open,
  modalClose,
  defaultDivision,
  defaultPeriod,
  canSave = false,
  onSavedClose,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const gridRef = useRef<FlexGridType<PivotRow>>(undefined);
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();
  const [divisionId, setDivisionId] = useState(defaultDivision);

  // Division dropdown — 권한 기반 MyDivision combo (grid 와 동일하게 Division_id + Division name 표기).
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (myDivisions ?? []) as Array<{ CODE?: string; NAME?: string }>;
    const base =
      arr.length === 0
        ? DIVISION_FALLBACK
        : arr.map(r => {
            const code = String(r.CODE ?? '');
            const name = String(r.NAME ?? code);
            const label = code === name || name === '' ? code : `${code} (${name})`;
            return { value: code, label };
          });
    return [{ value: 'ALL', label: t('LBL00632', 'All') }, ...base];
  }, [myDivisions, t]);

  const [periodFrom, setPeriodFrom] = useState(defaultPeriod.start);
  const [periodTo, setPeriodTo] = useState(defaultPeriod.end);
  // 조회에 실제 반영되는 "확정 기간": 달력 선택(periodFrom/To)은 UI 편집값일 뿐,
  //   query key 로는 이 확정값만 사용 → 달력만 바꿨을 때 자동 재조회되지 않음. 최초 open + Search 버튼에서만 갱신.
  const queryPeriod = useExchangeRateModalStore(state => state.queryPeriod);
  const setQueryPeriod = useExchangeRateModalStore(state => state.setQueryPeriod);

  useEffect(() => {
    if (open) {
      setDivisionId(defaultDivision);
      setPeriodFrom(defaultPeriod.start);
      setPeriodTo(defaultPeriod.end);
      setQueryPeriod(defaultPeriod); // 최초 open: 확정 기간 세팅(= 자동 1회 조회)
    }
  }, [open, defaultDivision, defaultPeriod, setQueryPeriod]);

  // sheet 'exchange' — SP PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO (4 IN + 2 OUT, divisionId 인자 없음)
  //   filters useMemo 안정화 + enabled false + Find 트리거 (refetch loop 방지)
  //   query key 는 확정 기간(queryPeriod)만 참조 — 달력 편집(periodFrom/To)은 제외해야 자동 재조회 방지.
  const startYyyymmdd =
    queryPeriod.start.length === 6 ? `${queryPeriod.start}01` : queryPeriod.start;
  const endYyyymmdd = queryPeriod.end.length === 6 ? `${queryPeriod.end}31` : queryPeriod.end;
  const filters = useMemo(
    () => ({ startYyyymmdd, endYyyymmdd }) as never,
    [startYyyymmdd, endYyyymmdd]
  );
  // ⭐ 자동조회 (2026-07-07 사용자 요구 — Batch Price Input 제외 전 modal 자동조회):
  //   enabled=open → modal open 시 react-query 가 확정 기간으로 자동 fetch. Find 버튼은 재조회용 유지.
  //   (setFilter();refetch() 직접 발사 대신 enabled 구동 → stale-closure NULL 재조회 함정 회피.)
  const { data, refetch, isLoading, isFetching } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE,
    tabId: MENU_ID,
    filters,
    enabled: open,
  });

  const loading = isLoading || isFetching;

  // ⭐ 성능(2026-07-08, 메인 그리드 동일 사유) — allRows/filteredRows 참조 안정화(useMemo).
  //   CustomDialog 는 open=false 라도 content 를 mount 하므로, 렌더 본문 계산이면 "메인 화면"의 매
  //   리렌더마다 KRW 필터 루프가 재실행되고 pivotRows(useMemo deps=filteredRows)까지 매번 재계산 →
  //   숨겨진 모달 grid 가 itemsSource 재바인딩을 반복(메인 조회 표시 지연에 가산). 데이터 변경 시에만 재계산.
  const filteredRows = useMemo<ExchangeRow[]>(() => {
    const allRows = (data?.o_rc1 ?? []) as unknown as ExchangeRow[];
    // ⭐ Currency KRW 만 조회 (2026-07-07 사용자 요구) + Division 필터(고정 division).
    return allRows.filter(r => {
      if (String(r.CURRENCY ?? '').toUpperCase() !== 'KRW') return false;
      if (divisionId && divisionId !== 'ALL' && String(r.DIVISION_ID ?? '') !== divisionId)
        return false;
      return true;
    });
  }, [data, divisionId]);

  // 조회 기간 전체의 월 목록 — 헤더 기준. 데이터가 있는 월만 모으면 종료월 전에 데이터가
  //   끊겼을 때 헤더도 거기서 잘린다(사용자 보고 2026-09-01). 확정 기간(queryPeriod)을 기준으로
  //   전 월을 만들어 두고, 데이터에만 있는 월(기간 밖 YYYY00 형태 등)은 아래 pivot 에서 합집합 처리.
  const periodYmKeys = useMemo(
    () => enumerateYyyymm(queryPeriod.start, queryPeriod.end),
    [queryPeriod.start, queryPeriod.end]
  );

  // DMF0020_01: 82 는 통화쌍마다 BPS I/F · User Define 2줄로 보여 주고 User Define 만 입력한다(설계서 [popup-1]
  //   B4 · B41, 사용자 결정 2026-11-10). 82 외 사업부는 종전대로 1줄 조회 전용.
  const isTwoRow = divisionId === DIVISION.POWER;

  // ===== long → wide pivot (사용자 요구 2026-06-03: AS-IS 2단 헤더 YYYY/MM) =====
  const { pivotRows, ymKeys } = useMemo(() => {
    const groupMap = new Map<string, PivotRow>();
    // 2줄 모드의 User Define 행 (key 는 groupMap 과 같다 — 같은 통화쌍의 두 번째 줄).
    const userMap = new Map<string, PivotRow>();
    // 조회 기간의 모든 월을 먼저 담는다 = 값이 없는 월도 빈 컬럼으로 헤더에 남는다.
    const ymSet = new Set<string>(periodYmKeys);
    for (const r of filteredRows) {
      const div = String(r.DIVISION_ID ?? '');
      const cur = String(r.CURRENCY ?? '');
      const uc = String(r.UNIT_CURRENCY ?? '');
      const ym = String(r.YYYYMM ?? '');
      if (!div || !cur || !uc || !ym) continue;
      ymSet.add(ym);
      const key = `${div}|${cur}|${uc}`;
      if (!groupMap.has(key)) {
        groupMap.set(key, {
          DIVISION_ID: div,
          CURRENCY: cur,
          UNIT_CURRENCY: uc,
          // 2줄 모드 BPS I/F 줄은 입력하지 않는다 — 공용 DataGrid 편집 판정(EDIT_FLAG='N')으로 닫는다.
          ...(isTwoRow ? { MEASURE: ROW_KIND.IF, EDIT_FLAG: 'N' } : {}),
        });
        if (isTwoRow) {
          userMap.set(key, {
            DIVISION_ID: div,
            CURRENCY: cur,
            UNIT_CURRENCY: uc,
            MEASURE: ROW_KIND.USER,
          });
        }
      }
      const row = groupMap.get(key)!;
      if (!isTwoRow) {
        const price = toNum(r.EXCHANGE_PRICE);
        if (price !== null) row[`M_${ym}`] = price;
        continue;
      }
      // 2줄 모드 — BPS I/F 줄 = IF_EXCHANGE_PRICE, User Define 줄 = USER_EXCHANGE_PRICE(없으면 빈 칸).
      //   그 달의 환율 행 키(YYYYMMDD)와 편집 권한을 User Define 줄에 숨겨 둔다 — 입력 가능 판정 · 저장 키.
      const userRow = userMap.get(key);
      if (!userRow) continue;
      row[`M_${ym}`] = toNum(r.IF_EXCHANGE_PRICE);
      userRow[`M_${ym}`] = toNum(r.USER_EXCHANGE_PRICE);
      userRow[ymdKeyOf(ym)] = String(r.YYYYMMDD ?? '');
      userRow[EDIT_YN_KEY] = String(r.EDIT_YN ?? 'N');
      // User Define 줄 입력 가능 여부는 공용 DataGrid 가 행의 EDIT_FLAG 로 판정한다(색과 편집 진입 모두).
      //   저장 권한(canSave)과 사용자 사업부 편집 권한(EDIT_YN)이 둘 다 있을 때만 'Y'.
      userRow.EDIT_FLAG = canSave && userRow[EDIT_YN_KEY] === 'Y' ? 'Y' : 'N';
    }
    const ymSorted = [...ymSet].sort();
    // 2줄 모드 — 환율 행이 없는 달은 두 줄 모두 0 으로 보이고 입력할 수 없다(설계서 [popup-1] B41 · K41).
    //   입력 가능 판정은 숨김 칸(__YMD_yyyymm)이 있는지로 하므로 0 을 채워도 저장 대상이 되지 않는다.
    if (isTwoRow) {
      for (const [key, row] of groupMap) {
        const userRow = userMap.get(key);
        if (!userRow) continue;
        for (const ym of ymSorted) {
          if (userRow[ymdKeyOf(ym)]) continue;
          row[`M_${ym}`] = 0;
          userRow[`M_${ym}`] = 0;
        }
      }
    }
    const list = [...groupMap.entries()]
      .sort(([, a], [, b]) => {
        if (a.DIVISION_ID !== b.DIVISION_ID) return a.DIVISION_ID.localeCompare(b.DIVISION_ID);
        if (a.CURRENCY !== b.CURRENCY) return a.CURRENCY.localeCompare(b.CURRENCY);
        return a.UNIT_CURRENCY.localeCompare(b.UNIT_CURRENCY);
      })
      .flatMap(([key, row]) => {
        const userRow = isTwoRow ? userMap.get(key) : undefined;
        return userRow ? [row, userRow] : [row];
      });
    return { pivotRows: list, ymKeys: ymSorted };
  }, [filteredRows, periodYmKeys, isTwoRow, canSave]);

  // 조회 직후 User Define 값(행 → 칸 → 값) — 바뀐 칸 판정과 빈 값 입력 되돌리기의 기준.
  //   pivotRows 가 새로 만들어질 때(조회 · 재조회)마다 다시 잡는다.
  const originalUserValues = useMemo(() => {
    const map = new Map<PivotRow, Map<string, number | null>>();
    if (!isTwoRow) return map;
    for (const row of pivotRows) {
      if (row.MEASURE !== ROW_KIND.USER) continue;
      const cells = new Map<string, number | null>();
      for (const ym of ymKeys) cells.set(`M_${ym}`, toNum(row[`M_${ym}`]));
      map.set(row, cells);
    }
    return map;
  }, [pivotRows, ymKeys, isTwoRow]);

  const isEditMode = isTwoRow && canSave;
  // 입력 가능 칸 — User Define 줄 · 환율 행이 있는 달 · 사용자 편집 권한 Y · 저장 권한(부모 판정) 모두 만족.
  //   formatItem(노랑) · beginningEdit · 저장 수집이 모두 이 한 기준을 쓴다.
  const isUserCellEditableRef = useRef<(row: PivotRow | undefined, binding: string) => boolean>(
    () => false
  );
  isUserCellEditableRef.current = (row, binding) => {
    if (!isEditMode || !row || row.MEASURE !== ROW_KIND.USER) return false;
    if (!binding.startsWith('M_')) return false;
    if (String(row[EDIT_YN_KEY] ?? 'N') !== 'Y') return false;
    return !!row[ymdKeyOf(binding.slice(2))];
  };
  const originalUserValuesRef = useRef(originalUserValues);
  originalUserValuesRef.current = originalUserValues;

  // 바뀐 User Define 칸 목록 — 저장 대상. 빈 값은 입력 단계에서 되돌리므로 여기 오지 않는다.
  const collectChangedCells = (): Array<{ row: PivotRow; ym: string; value: number }> => {
    const changed: Array<{ row: PivotRow; ym: string; value: number }> = [];
    for (const [row, cells] of originalUserValues) {
      for (const [binding, orig] of cells) {
        if (!isUserCellEditableRef.current(row, binding)) continue;
        const cur = toNum(row[binding]);
        if (cur === null || cur === orig) continue;
        changed.push({ row, ym: binding.slice(2), value: cur });
      }
    }
    return changed;
  };

  // 이번에 연 팝업에서 저장이 한 번이라도 성공했는지 — 닫을 때 메인 재조회 여부.
  const savedRef = useRef(false);
  useEffect(() => {
    if (!open) return;
    savedRef.current = false;
    // 같은 기간으로 다시 열면 조회 캐시가 같은 데이터를 돌려줘 행 객체가 재사용된다 — 지난번에 저장하지 않고
    //   닫은 User Define 입력이 남아 Save 에 실리지 않도록 조회 값으로 되돌린다.
    for (const [row, cells] of originalUserValuesRef.current) {
      for (const [binding, orig] of cells) row[binding] = orig;
    }
    gridRef.current?.invalidate();
  }, [open]);
  const handleClose = () => {
    const saved = savedRef.current;
    savedRef.current = false;
    modalClose();
    if (saved) onSavedClose?.();
  };

  const [isSaving, setIsSaving] = useState(false);
  const handleSave = async () => {
    if (isSaving) return;
    // 편집 중인 칸이 있으면 먼저 확정한다 — 그래야 방금 입력한 값이 저장 대상에 들어간다.
    gridRef.current?.finishEditing();
    const changed = collectChangedCells();
    if (changed.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }
    const confirmed = await setAlert({
      type: 'confirm',
      content: t(MSG.CONFIRM_SAVE, '_저장하시겠습니까?'),
    });
    if (!confirmed) return;

    // PKG_DMF0020_01.P_DMF0020_01_SAVE_DM_MST_EXCHANGE_RATE_ALL — 칸마다 '^' 로 이은 8개 인자(SCM_ADM_PROC_M).
    //   프로시저는 행 단위로 쪼개 조회된 행만 UPDATE 한다(ATTRIBUTE2 = EXCHANGE_PRICE = 입력값). 수정자 칸도
    //   행마다 읽고 DM_MST_EXCHANGE_RATE.LAST_UPDATED_BY 가 NOT NULL 이라 사용자 ID 를 칸 수만큼 잇는다.
    //   activeFlag 는 프로시저가 쓰지 않는다 — 수정(U)으로 보낸다.
    const userId = sessionUserId ?? '';
    const join = (pick: (c: (typeof changed)[number]) => string): string =>
      changed.map(pick).join('^');
    const payload = {
      activeFlag: join(() => 'U'),
      divisionId: join(c => c.row.DIVISION_ID),
      yyyymmdd: join(c => String(c.row[ymdKeyOf(c.ym)] ?? '')),
      currency: join(c => c.row.CURRENCY),
      unitCurrency: join(c => c.row.UNIT_CURRENCY),
      exchangePrice: join(c => String(c.value)),
      createdBy: join(() => userId),
      lastUpdatedBy: join(() => userId),
    };
    setIsSaving(true);
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.EXCHANGE}/SAVE/call-proc`,
        payload
      );
      // 메인 저장과 같은 실패 판별 — 전역 인터셉터가 500 을 resolve 로 넘기는 경우가 있다.
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00618', '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      savedRef.current = true;
      void setToast({ message: t('MSG00606', '_저장되었습니다.'), type: 'success' });
      void refetch?.();
      // Price Batch Input 등 같은 메뉴의 다른 환율 조회 캐시도 낡았다 — 다음에 열 때 새 환율을 받게 무효화한다.
      void queryClient.invalidateQueries({ queryKey: [MENU_ID, SHEETS.EXCHANGE] });
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    } finally {
      setIsSaving(false);
    }
  };

  // DMF0020_01 82 2줄 모드는 Unit 뒤에 행 구분(Measure) 칸을 둔다(설계서 [popup-1] B40, 너비 미지정 → 90).
  const fixedColumns = useMemo(
    () =>
      isTwoRow
        ? [
            ...EXCHANGE_RATE_COLUMNS,
            {
              key: 'MEASURE',
              header: t('LBL00310', 'Measure'),
              width: 90,
              align: 'C' as const,
            },
          ]
        : EXCHANGE_RATE_COLUMNS,
    [isTwoRow, t]
  );
  const fixedBindings = useMemo(() => fixedColumns.map(c => c.key), [fixedColumns]);

  // ⭐ 성능(2026-07-08) — grid 컬럼 prop 참조 안정화. JSX inline .map 은 매 렌더 새 배열 →
  //   DataGrid(memo) 무력화 → (open=false mount 포함) 부모 리렌더마다 columnGroups 전체 재적용.
  const gridStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      fixedColumns.map(
        (c): RawFlexGridColumnConfig => ({
          colNm: c.key,
          colLblNm: c.header,
          colWth: c.width,
          horzAlgnCd: c.align,
          fixed: true,
          visible: true,
          display: true,
          inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        })
      ),
    [fixedColumns]
  );
  // ⭐ 대상 년월 2단 헤더 (AS-IS 1:1, 2026-07-08 사용자 요구) — 1단 년도('2026') / 2단 월('07').
  //   구 방식(수동 Row push + formatItem 텍스트 치환 + 헤더 수평 머지)은 wrapper columnGroups
  //   재적용에 깨지기 쉬움 → 메인 그리드와 동일한 표준 nested columnGroups(년 그룹→월 leaf)로 재구성.
  const gridDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const byYear = new Map<string, FlexGridColumnConfig[]>();
    for (const ym of ymKeys) {
      const y = ym.slice(0, 4);
      if (!byYear.has(y)) byYear.set(y, []);
      byYear.get(y)!.push({
        binding: `M_${ym}`,
        header: ym.slice(4, 6), // 2단 = 월 (AS-IS '07','08'…)
        width: 90,
        align: 'right',
        format: 'n2',
        // 2줄 입력 모드에서만 연다 — 칸 단위 허용은 beginningEdit 가 isUserCellEditable 로 다시 거른다.
        isReadOnly: !isEditMode,
        // 공용 DataGrid 는 칸의 입력 구분(_inputEditType)과 행의 EDIT_FLAG 로 노랑 표시와 편집 진입을 정하고
        //   beginningEdit 에서 cancel 값을 덮어쓴다. 입력 구분이 없으면 모든 칸이 편집 불가가 되어 User Define 을
        //   넣을 수 없었다(2026-11-10 사용자 보고: Save 는 보이는데 노랑이 아님). 2줄 입력 모드에서만 O 로 연다.
        _inputEditType: isEditMode
          ? CELL_INPUT_EDIT_TYPE.OPTIONAL
          : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        allowSorting: false,
        visible: true,
      });
    }
    return [...byYear.entries()].map(([y, cols]) => ({
      header: y, // 1단 = 년도 (AS-IS '2026' — 같은 년도 월들을 수평 span)
      align: 'center',
      columns: cols,
    }));
  }, [ymKeys, isEditMode]);

  // ⭐ #70 — DataGrid `initialized` prop deprecated(wrapper 미호출) → useEffect + gridRef 로 이동.
  //   2단 column header(YYYY/MM) + 좌측 fixed 머지 + 동적 YYYY horizontal 머지 + Division/Currency cell 머지.
  useEffect(() => {
    const g = gridRef.current;
    // ⭐ CustomDialog 는 open=false 라도 content 를 mount 한다. 숨겨진(host display:none) 상태의
    //   Wijmo grid 는 panel 을 지연 초기화하므로 columnHeaders 가 null 일 수 있다 → guard 필수.
    if (!g || !g.columnHeaders) return;

    // ⭐ 2단 헤더는 gridDynamicColumns 의 nested 그룹(년→월)이 네이티브로 구성 (수동 Row push /
    //   formatItem 텍스트 치환 / 헤더 수평 머지 제거 — wrapper columnGroups 재적용에도 안정).
    //   헤더 높이는 아래 별도 상시 정규화 효과(raf 루프)가 전담 — PriceBatchInputModal 검증 패턴.

    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center'; // 년/월/고정 헤더 중앙 정렬 (AS-IS)
      }
      // DMF0020_01 82 User Define 입력 칸 = 노랑, 조회 뒤 바꾼 칸 = 빨간 글자(메인 그리드와 같은 표시).
      //   Wijmo 는 셀 엘리먼트를 재활용하므로 모든 데이터 셀에서 켜고 끄기를 함께 한다.
      if (e.panel.cellType === CellType.Cell) {
        const binding = e.panel.columns[e.col]?.binding ?? '';
        const row = (e.panel.rows[e.row] as unknown as { dataItem?: PivotRow })?.dataItem;
        const editable = isUserCellEditableRef.current(row, binding);
        // 노랑(wj-cell-editable)은 공용 DataGrid 가 EDIT_FLAG 로 칠한다 — 여기서 같이 토글하면 핸들러 순서에
        //   따라 결과가 뒤집힌다(Business Plan 환율 팝업 주석과 같은 사유). 여기서는 입력 가능한 줄인데
        //   환율 행이 없는 달만 회색(wj-cell-non-editable)으로 덮는다 — 그 달은 입력할 수 없다.
        const blockedMonth =
          row?.EDIT_FLAG === 'Y' && binding.startsWith('M_') && !editable;
        toggleClass(e.cell, 'wj-cell-non-editable', blockedMonth);
        const orig = row ? originalUserValuesRef.current.get(row)?.get(binding) : undefined;
        const changed = editable && orig !== undefined && toNum(row?.[binding]) !== orig;
        if (changed) e.cell.style.setProperty('color', '#d32f2f', 'important');
        else e.cell.style.removeProperty('color');
      }
      // ⭐ No. 코너 헤더 라벨 (사용자 요구 2026-07-08) — rowHeader 순번 컬럼의 TopLeft 에 'No.' 표기
      //   (선례 ContributeViewGrid setCellData 패턴 1:1. 머지는 ExchangeMerge TopLeft 분기가 전담.)
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
      }
    };
    g.formatItem.addHandler(formatHandler);

    // DMF0020_01 82 User Define 입력 — 허용 칸만 편집에 들어간다(안내 없음).
    const beginningEditHandler = (
      s: FlexGridType<PivotRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as PivotRow | undefined;
      if (!isUserCellEditableRef.current(row, binding)) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    // 붙여넣기도 같은 기준으로 거른다.
    const pastingCellHandler = (
      s: FlexGridType<PivotRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as PivotRow | undefined;
      if (!isUserCellEditableRef.current(row, binding)) e.cancel = true;
    };
    g.pastingCell.addHandler(pastingCellHandler);
    // 빈 값 입력은 되돌린다 — 저장 프로시저가 빈 값을 반영하지 않아 User Define 을 비워 BPS I/F 로 돌아갈 수
    //   없으므로, 화면에서 비운 것처럼 보이지 않게 조회 값으로 되돌린다(사용자 결정 2026-11-10).
    const restoreBlank = (s: FlexGridType<PivotRow>, r: number, c: number) => {
      const binding = s.columns[c]?.binding ?? '';
      const row = s.rows[r]?.dataItem as PivotRow | undefined;
      if (!row || !isUserCellEditableRef.current(row, binding)) return;
      if (toNum(row[binding]) !== null) return;
      row[binding] = originalUserValuesRef.current.get(row)?.get(binding) ?? null;
      s.invalidate();
    };
    const cellEditEndedHandler = (s: FlexGridType<PivotRow>, e: { row: number; col: number }) =>
      restoreBlank(s, e.row, e.col);
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    g.allowMerging = AllowMerging.All;
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    class ExchangeMerge extends MergeManager {
      getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
        const col = panel.columns[c];
        if (!col) return null;
        const binding = col.binding ?? '';
        // ⭐ No. 코너(TopLeft) — rowHeader(순번+상태) × 2단 헤더 전체를 가로/세로 단일 머지
        //   (사용자 요구 2026-07-08. 라벨 'No.' 는 formatHandler 의 setCellData 가 전담.)
        if (panel.cellType === CellType.TopLeft) {
          return new CellRange(0, 0, panel.rows.length - 1, panel.columns.length - 1);
        }
        if (panel.cellType === CellType.ColumnHeader) {
          // 고정컬럼 = 2단 세로 span (년/월 그룹이 만든 2행 전체 높이 사용)
          if (fixedBindings.includes(binding)) {
            return new CellRange(0, c, panel.rows.length - 1, c);
          }
          // ⭐ 동적 1단(년도) 수평 머지 (사용자 요구 2026-07-08) — 커스텀 MergeManager 설치 시
          //   nested 그룹의 네이티브 span 이 무효화되므로 수동 머지 의무 (형제 PriceBatchInputModal
          //   BatchMergeManager 동일 패턴). binding 'M_yyyymm' 의 년도(slice 2..6)가 같은 연속
          //   구간을 r=0 에서 span. r=1(월 leaf)은 단일 셀.
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
          // 2줄 모드는 Unit 도 통화쌍 두 줄을 세로로 묶는다.
          if (
            binding === 'DIVISION_ID' ||
            binding === 'CURRENCY' ||
            (isTwoRow && binding === 'UNIT_CURRENCY')
          ) {
            const view = panel.rows;
            const ri = (i: number): PivotRow | undefined =>
              (view[i] as unknown as { dataItem?: PivotRow })?.dataItem;
            if (!ri(r)) return null;
            const sameRow = (a: number, b: number): boolean => {
              const ra = ri(a);
              const rb = ri(b);
              if (!ra || !rb) return false;
              if (binding === 'DIVISION_ID') return ra.DIVISION_ID === rb.DIVISION_ID;
              if (binding === 'CURRENCY') {
                return ra.DIVISION_ID === rb.DIVISION_ID && ra.CURRENCY === rb.CURRENCY;
              }
              return (
                ra.DIVISION_ID === rb.DIVISION_ID &&
                ra.CURRENCY === rb.CURRENCY &&
                ra.UNIT_CURRENCY === rb.UNIT_CURRENCY
              );
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
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [open, pivotRows, ymKeys, fixedBindings, isTwoRow]);

  // ⭐⭐ 헤더 총높이 48px 상시 정규화 (2단=24×2 — "2단 기준으로 줄여서", 사용자 요구 2026-07-08).
  //   1회 설정/updatedLayout 등록만으로는 부족 — CustomDialog open 애니메이션 중 wijmo 가 헤더를
  //   늦게 build 하면 이후 정적이라 updatedLayout 이 안 떠 기본높이(28×2)가 잔존 (PriceBatchInputModal
  //   에서 검증된 재발 경로). → open 동안 raf 루프가 살아있는 grid 인스턴스에 재부착 + 매 프레임
  //   정규화(guard: 이미 목표면 skip → 프레임당 속성 비교 수준 비용).
  useEffect(() => {
    if (!open) return;
    let raf = 0;
    let attached: FlexGridType<PivotRow> | null = null;
    const normalizeHeader = () => {
      const g = gridRef.current;
      if (!g) return;
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const per = Math.round(48 / headerRows.length); // 2단=24 / 1단=48
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
        content: t('MSG00108', '_시작 월이 종료 월보다 늦을 수 없습니다.'),
      });
      return;
    }
    // Search 시에만 편집 기간을 확정 기간에 반영 → query key 변경 시 자동 재조회.
    //   확정값이 동일(기간 미변경)해 key 가 안 바뀌는 경우를 위해 refetch 도 명시 발사.
    setQueryPeriod({ start: periodFrom, end: periodTo });
    refetch?.();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      handleClose={handleClose}
      disableButtonCancel
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
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
                <Grid size={6}>
                  <FormItem
                    label={t('LBL00001', 'Div')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        disabled
                        value={divisionId}
                        options={divisionOptions}
                        onChange={(_, option) => setDivisionId(String(option))}
                      />
                    )}
                  />
                </Grid>
                <Grid size={6}>
                  <FormItem
                    label={t('LBL00013', 'Period')}
                    labelAlign='right'
                    render={() => (
                      // 부모 화면 Period 와 동일하게 시작월/종료월 각각 독립 월 달력(usecase='month') 사용.
                      //   필드별로 자기 팝업이 뜨며 저장/조회 값은 계속 YYYYMM (onChange 에서 6자리 format).
                      <div className={styles.periodSplit}>
                        <div className={styles.datePickerFix}>
                          <DatePickerCalendar
                            usecase='month'
                            elevation
                            size='small'
                            value={ymToDayjs(periodFrom)}
                            onChange={
                              ((date: Dayjs | null) => {
                                setPeriodFrom(date?.format('YYYYMM') ?? '');
                              }) as never
                            }
                          />
                        </div>
                        <span className={styles.periodSep}>~</span>
                        <div className={styles.datePickerFix}>
                          <DatePickerCalendar
                            usecase='month'
                            elevation
                            size='small'
                            value={ymToDayjs(periodTo)}
                            onChange={
                              ((date: Dayjs | null) => {
                                setPeriodTo(date?.format('YYYYMM') ?? '');
                              }) as never
                            }
                          />
                        </div>
                      </div>
                    )}
                  />
                </Grid>
              </>
            }
          />

          <div className={styles.gridWrapper}>
            {/* 조회 중 · User Define 저장 중 모두 표시 — 저장 프로시저가 판가 · 매출계획 금액까지 다시 계산해 수 초 걸린다. */}
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading || isSaving}
              placement='parent'
            />
            <ResultArea
              title=''
              count={pivotRows.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<PivotRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                className={styles.grid}
                isReadOnly={!isEditMode}
                itemsSource={pivotRows}
                staticColumns={gridStaticColumns}
                dynamicColumns={gridDynamicColumns}
                autoGenerateColumns={false}
                frozenColumns={fixedBindings.length}
                allowSorting={false}
                // ⭐ Div / Currency 세로 셀 머지 (사용자 요구 2026-07-07) — ExchangeMerge(mergeManager)가 데이터셀
                //   계층 머지를 담당하나, prop 미전달 시 wrapper 가 매 렌더 g.allowMerging 을 기본(ColumnHeaders)으로
                //   되돌려 셀 머지가 꺼짐. 형제 PriceBatchInputModal 과 동일하게 All 전달로 일관 적용.
                allowMerging={AllowMerging.All}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            {/* DMF0020_01 82 User Define 저장 — 저장 권한이 있을 때만 보인다(설계서 [popup-1] B29). */}
            {isEditMode && (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel={t('LBL00111', 'Save')}
                disabled={isSaving}
                onClick={() => void handleSave()}
              />
            )}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={handleClose}
            />
          </div>
        </div>
      }
    />
  );
};
