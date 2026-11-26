import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellRange,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { Dayjs } from 'dayjs';
import { buildComboOptions } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  EXCHANGE_RATE_COLUMNS,
  MEASURE_CODE,
  MENU_ID,
  MODAL_EXCHANGE_RATE,
  MODAL_PRICE_BATCH,
  MSG,
  SCREEN_DIVISION,
  SEARCH_COMBO,
  SHEETS,
} from '../../sales-price-model-group.constants';
import { attachHeaderHeightNormalizer } from '../../utils/sales-price-model-group.grid';
import { keepMergeManager } from '../../utils/sales-price-model-group.grid';
import { enumerateYyyymm, showAlert } from '../../utils/sales-price-model-group.util';

import styles from './ExchangeRateModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
  // 메인 조회 기간(YYYYMM) — 팝업을 열 때의 기본 기간.
  defaultPeriod: { start: string; end: string };
  // User Define 저장 가능 여부 — 부모가 편집 사업부(82) && exchange 시트 SAVE 권한으로 정한다.
  //   행마다 사용자 사업부 편집 권한(EDIT_YN)은 이 팝업이 다시 본다(원천 DMF0020_01 과 같은 세 조건).
  canSave?: boolean;
  // 저장이 한 번이라도 성공한 뒤 닫을 때 한 번 부른다 — 저장 프로시저가 Model Group 판가(KRW · USD)를
  //   다시 계산하므로 메인 그리드와 환산용 환율을 다시 받아야 화면 값이 맞는다.
  onSavedClose?: () => void;
}

// 조회 결과 행 (PKG_DMF0020_01.P_DMF0020_01_GET_FUTUREPRICE_INFO).
//   IF_EXCHANGE_PRICE   : BPS I/F 값 (ATTRIBUTE1)
//   USER_EXCHANGE_PRICE : User Define 값 (ATTRIBUTE2)
//   EDIT_YN             : 사용자의 사업부 편집 권한 (SCM_ADM_USER_MNU_EDIT_AUTH_V, MNU_ID = DMF0083)
interface ExchangeRow {
  YYYYMMDD?: string;
  YYYYMM?: string;
  DIVISION_ID?: string;
  CURRENCY?: string;
  UNIT_CURRENCY?: string;
  EXCHANGE_PRICE?: number | string | null;
  IF_EXCHANGE_PRICE?: number | string | null;
  USER_EXCHANGE_PRICE?: number | string | null;
  EDIT_YN?: string;
}

interface PivotRow {
  DIVISION_ID: string;
  CURRENCY: string;
  UNIT_CURRENCY: string;
  [monthKey: string]: string | number | null;
}

// 82 2줄 표시의 행 구분 값(Measure 칸) — 원천 DMF0020_01 과 같은 표기. 화면 라벨이 아니라 행 구분 데이터 값이다.
const ROW_KIND = {
  IF: 'BPS I/F',
  USER: 'User Defined', // 2026-11-25 요청으로 표기 변경(종전 'User Define')
} as const;

const MONTH_PREFIX = 'M_';
// 행에 숨겨 두는 칸 — 그 달 환율 행의 YYYYMMDD(저장 키)와 사용자 편집 권한(EDIT_YN). 그리드 컬럼이 아니다.
const ymdKeyOf = (ym: string): string => `__YMD_${ym}`;
const EDIT_YN_KEY = '__EDIT_YN';

const yearOf = (binding: string): string =>
  binding.startsWith(MONTH_PREFIX) ? binding.slice(2, 6) : '';

// Period(YYYYMM) → 달력 값. 저장 · 비교는 계속 YYYYMM 문자열로 한다.
const monthOf = (yyyymm: string): Dayjs | null =>
  /^\d{6}$/.test(yyyymm) ? dayjs(`${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}-01`) : null;

// 숫자 칸 값 → number | null (빈 값 · 숫자 아님은 null).
const toNum = (v: unknown): number | null => {
  if (v === null || v === undefined || v === '') return null;
  const n = typeof v === 'number' ? v : Number(v);
  return Number.isNaN(n) ? null : n;
};

// 머지 — 고정 칸 머리글은 2단 세로, 연도 머리글은 같은 해끼리 가로, 값은 Div · Currency(2줄이면 Unit 도) 세로.
class ExchangeRateMergeManager extends MergeManager {
  fixedBindings: readonly string[] = [];
  twoRow = false;

  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
    const binding = panel.columns[c]?.binding ?? '';
    if (panel.cellType === CellType.ColumnHeader) {
      if (this.fixedBindings.includes(binding)) return new CellRange(0, c, panel.rows.length - 1, c);
      const year = yearOf(binding);
      if (!year || r !== 0) return null;
      let left = c;
      let right = c;
      while (left > 0 && yearOf(panel.columns[left - 1]?.binding ?? '') === year) left--;
      while (
        right < panel.columns.length - 1 &&
        yearOf(panel.columns[right + 1]?.binding ?? '') === year
      )
        right++;
      return left === right ? null : new CellRange(0, left, 0, right);
    }
    const mergeable =
      binding === 'DIVISION_ID' || binding === 'CURRENCY' || (this.twoRow && binding === 'UNIT_CURRENCY');
    if (panel.cellType === CellType.Cell && mergeable) {
      const rowAt = (i: number): PivotRow | undefined =>
        (panel.rows[i] as unknown as { dataItem?: PivotRow } | undefined)?.dataItem;
      const current = rowAt(r);
      if (!current) return null;
      const same = (i: number): boolean => {
        const other = rowAt(i);
        if (!other || other.DIVISION_ID !== current.DIVISION_ID) return false;
        if (binding === 'DIVISION_ID') return true;
        if (other.CURRENCY !== current.CURRENCY) return false;
        return binding === 'CURRENCY' || other.UNIT_CURRENCY === current.UNIT_CURRENCY;
      };
      let top = r;
      let bottom = r;
      while (top > 0 && same(top - 1)) top--;
      while (bottom < panel.rows.length - 1 && same(bottom + 1)) bottom++;
      return top === bottom ? null : new CellRange(top, c, bottom, c);
    }
    return null;
  }
}

// Exchange Rate 팝업 — Sales Price(ESS) DMF0020_01 의 환율 팝업과 같은 동작(2026-11-23 개발 서버 테스트 요청).
//   82 는 통화쌍마다 BPS I/F · User Define 2줄로 보여 주고 User Define 만 입력 · 저장한다. 82 외는 1줄 조회 전용.
//   조회 · 저장은 DMF0083 / exchange 시트(PKG_DMF0020_01 프로시저 재사용)로 한다. 종전 조회 전용 팝업(2026-11-16)은
//   main / EXCHANGE_RATE(PKG_DMF0083.P_DMF0083_GET_EXCHANGE_RATE)를 읽었는데 그 경로는 메인 환산용으로만 남는다.
//   프로시저가 사용자 편집 권한 사업부를 모두 돌려주므로 Div 는 메인 사업부로 고정해 걸러 보여 준다.
export const ExchangeRateModal = ({
  open,
  modalClose,
  divisionId,
  defaultPeriod,
  canSave = false,
  onSavedClose,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);
  const sessionUserId = useSessionStore(s => s.session.userId);
  const gridRef = useRef<FlexGrid<PivotRow> | null>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  // 달력에서 고르는 중인 기간(편집값)과 Search 로 확정한 기간(조회 키)을 나눈다 — 달력만 바꿔서는 다시 조회하지 않는다(POP-08).
  const [periodFrom, setPeriodFrom] = useState(defaultPeriod.start);
  const [periodTo, setPeriodTo] = useState(defaultPeriod.end);
  const [applied, setApplied] = useState<{ start: string; end: string } | null>(null);

  // 열 때마다 메인 조회 기간으로 되돌리고 한 번 조회한다. 닫으면 확정 기간을 비워 다음에 열 때 옛 기간으로 조회하지 않게 한다.
  const defaultRef = useRef(defaultPeriod);
  defaultRef.current = defaultPeriod;
  useEffect(() => {
    if (!open) {
      setApplied(null);
      return;
    }
    const { start, end } = defaultRef.current;
    setPeriodFrom(start);
    setPeriodTo(end);
    setApplied({ start, end });
  }, [open]);

  const [divisions] = useTabComboQueries({ filters: [SEARCH_COMBO.division] });
  const divisionOptions = buildComboOptions(divisions).filter(o => o.value === divisionId);

  // 환율 기준일은 YYYYMM01 이고 프로시저가 문자열로 비교하므로 종료일은 그 달 31 로 보낸다(원천과 같음).
  const filters = useMemo(
    () =>
      open && applied
        ? { startYyyymmdd: `${applied.start}01`, endYyyymmdd: `${applied.end}31` }
        : undefined,
    [open, applied]
  );
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.EXCHANGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE,
    tabId: MODAL_EXCHANGE_RATE,
    filters,
    enabled: !!filters,
  });

  // 82 는 2줄(BPS I/F · User Define), 그 밖의 사업부는 1줄 조회 전용(원천 DMF0020_01 과 같음).
  const isTwoRow = divisionId === SCREEN_DIVISION;
  const isEditMode = isTwoRow && canSave;

  // 긴 형식(월 · 통화쌍마다 1행) → 통화쌍 1행(2줄 모드는 2행) + 월 칸. KRW 기준 환율 · 메인 사업부만 보여 준다.
  //   월 칸은 데이터가 있는 달이 아니라 조회한 기간 전체로 세운다 — 환율이 없는 달도 칸으로 남는다.
  const { pivotRows, monthKeys } = useMemo(() => {
    const months = new Set<string>(applied ? enumerateYyyymm(applied.start, applied.end) : []);
    const groups = new Map<string, PivotRow>();
    const userRows = new Map<string, PivotRow>();
    for (const r of (data?.o_rc1 as unknown as ExchangeRow[] | undefined) ?? []) {
      const division = String(r.DIVISION_ID ?? '').trim();
      const currency = String(r.CURRENCY ?? '').trim();
      const unit = String(r.UNIT_CURRENCY ?? '').trim();
      const ym = String(r.YYYYMM ?? '').trim();
      if (currency.toUpperCase() !== MEASURE_CODE.KRW || division !== divisionId || !unit || !ym) continue;
      months.add(ym);
      const key = `${division}|${currency}|${unit}`;
      let row = groups.get(key);
      if (!row) {
        row = {
          DIVISION_ID: division,
          CURRENCY: currency,
          UNIT_CURRENCY: unit,
          // BPS I/F 줄은 입력하지 않는다 — 공용 DataGrid 편집 판정(EDIT_FLAG='N')으로 닫는다.
          ...(isTwoRow ? { MEASURE: ROW_KIND.IF, EDIT_FLAG: 'N' } : {}),
        };
        groups.set(key, row);
        if (isTwoRow) {
          userRows.set(key, { DIVISION_ID: division, CURRENCY: currency, UNIT_CURRENCY: unit, MEASURE: ROW_KIND.USER });
        }
      }
      const binding = `${MONTH_PREFIX}${ym}`;
      if (!isTwoRow) {
        row[binding] = toNum(r.EXCHANGE_PRICE);
        continue;
      }
      // 2줄 — BPS I/F 줄 = IF_EXCHANGE_PRICE, User Define 줄 = USER_EXCHANGE_PRICE(없으면 빈 칸).
      //   그 달 환율 행 키(YYYYMMDD)와 편집 권한을 User Define 줄에 숨겨 둔다 — 입력 가능 판정 · 저장 키.
      const userRow = userRows.get(key);
      if (!userRow) continue;
      row[binding] = toNum(r.IF_EXCHANGE_PRICE);
      userRow[binding] = toNum(r.USER_EXCHANGE_PRICE);
      userRow[ymdKeyOf(ym)] = String(r.YYYYMMDD ?? '');
      userRow[EDIT_YN_KEY] = String(r.EDIT_YN ?? 'N');
      // User Define 줄 입력 가능 여부는 공용 DataGrid 가 행의 EDIT_FLAG 로 판정한다(색과 편집 진입 모두).
      userRow.EDIT_FLAG = canSave && userRow[EDIT_YN_KEY] === 'Y' ? 'Y' : 'N';
    }
    const monthList = [...months].sort();
    // 2줄 — 환율 행이 없는 달은 두 줄 모두 0 으로 보이고 입력할 수 없다(원천 DMF0020_01 과 같음).
    //   입력 가능 판정은 숨김 칸(__YMD_yyyymm)이 있는지로 하므로 0 을 채워도 저장 대상이 되지 않는다.
    if (isTwoRow) {
      for (const [key, row] of groups) {
        const userRow = userRows.get(key);
        if (!userRow) continue;
        for (const ym of monthList) {
          if (userRow[ymdKeyOf(ym)]) continue;
          row[`${MONTH_PREFIX}${ym}`] = 0;
          userRow[`${MONTH_PREFIX}${ym}`] = 0;
        }
      }
    }
    const list = [...groups.entries()]
      .sort(
        ([, a], [, b]) =>
          a.DIVISION_ID.localeCompare(b.DIVISION_ID) ||
          a.CURRENCY.localeCompare(b.CURRENCY) ||
          a.UNIT_CURRENCY.localeCompare(b.UNIT_CURRENCY)
      )
      .flatMap(([key, row]) => {
        const userRow = userRows.get(key);
        return userRow ? [row, userRow] : [row];
      });
    return { pivotRows: list, monthKeys: monthList };
  }, [data, applied, divisionId, isTwoRow, canSave]);

  // 조회 직후 User Define 값(행 → 칸 → 값) — 바뀐 칸 판정과 빈 값 입력 되돌리기의 기준.
  const originalUserValues = useMemo(() => {
    const map = new Map<PivotRow, Map<string, number | null>>();
    if (!isTwoRow) return map;
    for (const row of pivotRows) {
      if (row.MEASURE !== ROW_KIND.USER) continue;
      const cells = new Map<string, number | null>();
      for (const ym of monthKeys) cells.set(`${MONTH_PREFIX}${ym}`, toNum(row[`${MONTH_PREFIX}${ym}`]));
      map.set(row, cells);
    }
    return map;
  }, [pivotRows, monthKeys, isTwoRow]);
  const originalUserValuesRef = useRef(originalUserValues);
  originalUserValuesRef.current = originalUserValues;

  // 입력 가능 칸 — User Define 줄 · 환율 행이 있는 달 · 사용자 편집 권한 Y · 저장 권한(부모 판정) 모두 만족.
  //   formatItem · beginningEdit · 붙여넣기 · 저장 수집이 모두 이 한 기준을 쓴다.
  const isUserCellEditableRef = useRef<(row: PivotRow | undefined, binding: string) => boolean>(() => false);
  isUserCellEditableRef.current = (row, binding) => {
    if (!isEditMode || !row || row.MEASURE !== ROW_KIND.USER) return false;
    if (!binding.startsWith(MONTH_PREFIX)) return false;
    if (String(row[EDIT_YN_KEY] ?? 'N') !== 'Y') return false;
    return !!row[ymdKeyOf(binding.slice(2))];
  };

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
    //   닫은 User Define 입력이 Save 에 실리지 않도록 조회 값으로 되돌린다.
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
    const confirmed = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_SAVE, '_저장하시겠습니까?') });
    if (!confirmed) return;

    // PKG_DMF0020_01.P_DMF0020_01_SAVE_DM_MST_EXCHANGE_RATE_ALL — 칸마다 '^' 로 이은 8개 인자(SCM_ADM_PROC_M).
    //   프로시저는 조회된 행만 UPDATE 하고(ATTRIBUTE2 = EXCHANGE_PRICE = 입력값) 82 판가와 Model Group 판가를 다시 계산한다.
    //   수정자 칸도 행마다 읽고 LAST_UPDATED_BY 가 NOT NULL 이라 사용자 ID 를 칸 수만큼 잇는다. activeFlag 는 쓰지 않는다(U).
    const userId = sessionUserId ?? '';
    const join = (pick: (c: (typeof changed)[number]) => string): string => changed.map(pick).join('^');
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
      // 전역 인터셉터가 500 을 resolve 로 넘기는 경우가 있다 — 상태와 결과 코드를 함께 본다(원천과 같음).
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() || t(MSG.SAVE_FAIL, '_저장 중 오류가 발생했습니다.');
        showAlert(reason);
        return;
      }
      savedRef.current = true;
      setToast({ type: 'success', message: t(MSG.SAVED, '_저장되었습니다.') });
      void refetch();
      // Price Batch Input 팝업의 환율 조회 캐시도 낡았다 — 다음에 열 때 새 환율을 받게 무효화한다.
      void queryClient.invalidateQueries({ queryKey: [MODAL_PRICE_BATCH] });
    } catch (e) {
      showAlert(e instanceof Error ? e.message : t(MSG.SAVE_FAIL, '_저장 중 오류가 발생했습니다.'));
    } finally {
      setIsSaving(false);
    }
  };

  // 2줄 모드는 Unit 뒤에 행 구분(Measure) 칸을 둔다(원천 DMF0020_01 과 같은 폭 90).
  const fixedColumns = useMemo(
    () =>
      isTwoRow
        ? [...EXCHANGE_RATE_COLUMNS, { key: 'MEASURE', header: 'Measure', labelCode: 'LBL00310', width: 90 }]
        : [...EXCHANGE_RATE_COLUMNS],
    [isTwoRow]
  );
  const fixedBindings = useMemo(() => fixedColumns.map(c => c.key), [fixedColumns]);

  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      fixedColumns.map(c => ({
        colNm: c.key,
        colLblNm: c.labelCode ? t(c.labelCode, c.header) : c.header,
        colWth: c.width,
        horzAlgnCd: 'C',
        fixed: true,
        visible: true,
        display: true,
        inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      })),
    [fixedColumns, t]
  );
  // 2단 머리글 — 1단 연도, 2단 월.
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const byYear = new Map<string, FlexGridColumnConfig[]>();
    for (const ym of monthKeys) {
      const year = ym.slice(0, 4);
      const list = byYear.get(year) ?? [];
      list.push({
        binding: `${MONTH_PREFIX}${ym}`,
        header: ym.slice(4, 6),
        width: 90,
        align: 'right',
        format: 'n2',
        // 2줄 입력 모드에서만 연다 — 칸 단위 허용은 beginningEdit 가 isUserCellEditable 로 다시 거른다.
        isReadOnly: !isEditMode,
        // 공용 DataGrid 는 칸의 입력 구분과 행의 EDIT_FLAG 로 노랑 표시와 편집 진입을 정한다.
        //   입력 구분이 없으면 모든 칸이 편집 불가가 된다(원천 DMF0020_01 2026-11-10 보고와 같은 사유).
        _inputEditType: isEditMode ? CELL_INPUT_EDIT_TYPE.OPTIONAL : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        allowSorting: false,
        visible: true,
      });
      byYear.set(year, list);
    }
    return [...byYear.entries()].map(([year, columns]) => ({ header: year, align: 'center', columns }));
  }, [monthKeys, isEditMode]);

  const mergeManager = useMemo(() => new ExchangeRateMergeManager(), []);
  mergeManager.fixedBindings = fixedBindings;
  mergeManager.twoRow = isTwoRow;

  useEffect(() => {
    const g = gridRef.current;
    // CustomDialog 는 닫혀 있어도 내용을 만들어 둔다 — 숨은 그리드는 머리글이 아직 없을 수 있다.
    if (!open || !g || !g.columnHeaders) return;
    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.ColumnHeader) e.cell.style.textAlign = 'center';
      if (e.panel.cellType !== CellType.Cell) return;
      // 노랑(wj-cell-editable)은 공용 DataGrid 가 EDIT_FLAG 로 칠한다 — 여기서는 입력 가능한 줄인데 환율 행이 없는
      //   달만 회색으로 덮고, 조회 뒤 바꾼 칸은 빨간 글자로 표시한다(메인 그리드와 같은 표시). 셀 재활용이라 켜고 끄기를 함께 한다.
      const binding = e.panel.columns[e.col]?.binding ?? '';
      const row = (e.panel.rows[e.row] as unknown as { dataItem?: PivotRow })?.dataItem;
      const editable = isUserCellEditableRef.current(row, binding);
      const blockedMonth = row?.EDIT_FLAG === 'Y' && binding.startsWith(MONTH_PREFIX) && !editable;
      toggleClass(e.cell, 'wj-cell-non-editable', blockedMonth);
      const orig = row ? originalUserValuesRef.current.get(row)?.get(binding) : undefined;
      if (editable && orig !== undefined && toNum(row?.[binding]) !== orig) {
        e.cell.style.setProperty('color', '#d32f2f', 'important');
      } else {
        e.cell.style.removeProperty('color');
      }
    };
    const blockEdit = (s: FlexGrid<PivotRow>, e: { cancel: boolean; row: number; col: number }) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as PivotRow | undefined;
      if (!isUserCellEditableRef.current(row, binding)) e.cancel = true;
    };
    // 빈 값 입력은 되돌린다 — 저장 프로시저가 빈 값을 반영하지 않아 User Define 을 비워 BPS I/F 로 돌아갈 수 없다(원천과 같음).
    const restoreBlank = (s: FlexGrid<PivotRow>, e: { row: number; col: number }) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as PivotRow | undefined;
      if (!row || !isUserCellEditableRef.current(row, binding)) return;
      if (toNum(row[binding]) !== null) return;
      row[binding] = originalUserValuesRef.current.get(row)?.get(binding) ?? null;
      s.invalidate();
    };
    g.formatItem.addHandler(formatHandler);
    g.beginningEdit.addHandler(blockEdit);
    g.pastingCell.addHandler(blockEdit);
    g.cellEditEnded.addHandler(restoreBlank);
    g.pastedCell.addHandler(restoreBlank);
    const detachHeader = attachHeaderHeightNormalizer(g as never);
    const detachMerge = keepMergeManager(g as never, mergeManager);
    g.invalidate(true);
    return () => {
      g.formatItem.removeHandler(formatHandler);
      g.beginningEdit.removeHandler(blockEdit);
      g.pastingCell.removeHandler(blockEdit);
      g.cellEditEnded.removeHandler(restoreBlank);
      g.pastedCell.removeHandler(restoreBlank);
      detachHeader();
      detachMerge();
    };
  }, [open, dynamicColumns, pivotRows, mergeManager, isTwoRow]);

  const handleSearch = () => {
    if (!periodFrom || !periodTo || periodFrom > periodTo) {
      return showAlert(t(MSG.PERIOD_INVERTED, '_조회 기간이 잘못되었습니다.'));
    }
    // 기간이 그대로면 조회 키가 안 바뀌므로 다시 조회를 직접 부른다.
    if (applied?.start === periodFrom && applied?.end === periodTo) void refetch();
    else setApplied({ start: periodFrom, end: periodTo });
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      handleClose={handleClose}
      disableButtonCancel
      // 컬럼 필터 팝업이 다이얼로그 밖에 붙어 MUI FocusTrap 과 부딪힌다 — 필터 입력이 먹지 않는 것을 막는다(POP-04).
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00661', '_Exchange Rate')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <SearchArea
            searchButtonLabel={t('LBL00664', '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={6}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t('LBL00001', '_Div')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown disabled value={divisionId} options={divisionOptions} />
                    )}
                  />
                </Grid>
                <Grid size={6}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t('LBL00013', '_Period')}
                    labelAlign='right'
                    render={() => (
                      <div className={styles.periodSplit}>
                        <div className={styles.datePickerFix}>
                          <DatePickerCalendar
                            usecase='month'
                            elevation
                            size='small'
                            value={monthOf(periodFrom)}
                            onChange={
                              ((date: Dayjs | null) =>
                                setPeriodFrom(date?.format('YYYYMM') ?? '')) as never
                            }
                          />
                        </div>
                        <span className={styles.periodSep}>~</span>
                        <div className={styles.datePickerFix}>
                          <DatePickerCalendar
                            usecase='month'
                            elevation
                            size='small'
                            value={monthOf(periodTo)}
                            onChange={
                              ((date: Dayjs | null) =>
                                setPeriodTo(date?.format('YYYYMM') ?? '')) as never
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
            <ProgressIndicator
              shape='circular'
              open={isLoading || isFetching || isSaving}
              placement='parent'
            />
            <ResultArea
              title=''
              count={pivotRows.length}
              gridRef={gridRef as never}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<PivotRow>
                className={styles.grid}
                gridRef={gridRef as never}
                gridFilterRef={gridFilterRef}
                isReadOnly={!isEditMode}
                itemsSource={pivotRows}
                staticColumns={staticColumns}
                dynamicColumns={dynamicColumns}
                autoGenerateColumns={false}
                frozenColumns={fixedBindings.length}
                allowSorting={false}
                allowMerging={AllowMerging.All}
                mergeManager={mergeManager}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            {/* User Define 저장 — 저장 권한이 있을 때만 보인다(원천 DMF0020_01 과 같음). */}
            {isEditMode && (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel={t('LBL00111', '_Save')}
                disabled={isSaving}
                onClick={() => void handleSave()}
              />
            )}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', '_Close')}
              onClick={handleClose}
            />
          </div>
        </div>
      }
    />
  );
};
