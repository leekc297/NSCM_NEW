import {
  AllowMerging,
  CellRange,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import { DivisionField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { BUTTON_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import { type EditTracker, GridAction } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem } from '@shared/lges';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS } from '../../sales-reports.constants';
import { callSaveExchangeRate } from '../../utils/sales-reports.api';
import { toCellStr } from '../../utils/sales-reports.gridCombos';

import styles from './ExchangeRateModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  /** 부모 조회조건 Division — 확정값·모달에서 비활성 (사용자 지시 2026-08-10, DMF0042/DMF0020 동일 정책) */
  divisionId: string;
  /** 부모 조회조건 Year — AS-IS LoadData(sYear) L91~101 `usrYear.ControlValues = sYear` 1:1 */
  year: string;
  /** 부모 Version — AS-IS LoadData(sVersionNo) `_sVersionNo` (조회·저장 필수키) */
  versionNo: string;
}

/** grid 1행 = 통화쌍(Division×Currency×Unit) × 동적 월 컬럼 `D{BASIS_START_DATE}` 피벗.
 *  AS-IS InitSpread L248~301 의 정적 4컬럼 + 동적 월 컬럼 구조 1:1.
 *
 *  ⭐ 커서 실측 (2026-08-10, HTTP `/DMF0044/exchangeRate/{BTN}/call-proc`, div 40 / year 2026):
 *   - SEARCH(골격) 7행 — `{CURRENCY, UNIT_CURRENCY, DIVISION_ID, CURRENCY_UNITCURRENCY:'KRW/AUD', EDIT_YN:'Y'}`
 *     → 월 값 미포함(통화쌍 5컬럼만). `CURRENCY_UNITCURRENCY` 반환됨.
 *   - SEARCH_DATA(값) 84행 — `{…, EXCHANGE_PRICE: 920(number), YYYYMMDD:'D20260101', EDIT_YN:'Y'}`
 *   - TITLE 12행 — `{BASIS_START_DATE:'20260101', CALENDAR_MONTH:'01', CALENDAR_YYYY:'2026'}` (D prefix 없음)
 *   - 행 배열 키 = `data` (응답 최상위 `result`/`data`/`DATARESULT` 중)
 */
interface ExchangeRatePivotRow {
  DIVISION_ID: string;
  CURRENCY: string;
  UNIT_CURRENCY: string;
  /** AS-IS DefColumns.CURRENCY_UNITCURRENCY — 메타 VISIBLE='N' (숨김 키 컬럼). 실측 예 'KRW/AUD' */
  CURRENCY_UNITCURRENCY: string;
  /** 서버가 주는 행 단위 편집권 (실측: 골격·값 커서 모두 반환). 'N' 이면 월 셀 편집 차단 */
  EDIT_YN: string;
  /** 'I'(Insert) / 'M'(EditTracker 마킹) / ''(조회행) */
  CRUD_TYPE: string;
  [dynamicMonthBinding: string]: string | number;
}

/** 동적 월 컬럼 1개 — AS-IS `AddNumColumn(CALENDAR_MONTH, "D"+BASIS_START_DATE, …)` L279 */
interface MonthColumn {
  binding: string; // 'D' + BASIS_START_DATE (AS-IS 컬럼 Tag 규약)
  yyyymmdd: string; // BASIS_START_DATE 원문 — 저장 P_YYYYMMDD 로 그대로 전달
  yyyy: string; // CALENDAR_YYYY — 1단(상단) 헤더 span 키
  mm: string; // CALENDAR_MONTH — 2단(하단) 헤더 라벨
}

const MONTH_BINDING = /^D\d{8}$/;
const stripD = (v: unknown): string => toCellStr(v).replace(/^D/i, '').trim();

// ⭐ AS-IS DMF0044_SalesReportExchangePopup (721행) 1:1 재구현 — Sales Reports 환율 팝업.
//   레이아웃 : 조회조건 1행(Div/Year) + 액션 바 + 2단 헤더 grid.
//              액션 바 = 우측 고정 순서 Insert → Excel(아이콘) → Save → Close
//              (사용자 확정 2026-08-10 — AS-IS OK 버튼은 미사용, Save 가 저장+닫기 겸용).
//   조회     : 2-step (AS-IS FindData L413~465) — ①골격 SEARCH ②값 SEARCH_DATA 로 월 셀을 채운다.
//              헤더는 TITLE(연도별 월) 이 결정한다 (AS-IS InitSpread L260~295).
//   편집     : ⭐ 사용자 확정(2026-08-10) — AS-IS Edit 버튼(L327~390 SwitchLock)은 승계하지 않는다.
//              권한이 있으면 진입 즉시 편집모드이며, AS-IS EditButton 이 만들던 결과 상태
//              (정적 컬럼 DIVISION_ID~CURRENCY_UNITCURRENCY 잠금 → 월 컬럼만 개방)를 초기값으로 둔다.
//              권한이 없으면 전체 잠금(조회 전용) + Insert/Save 버튼 숨김.
//   저장     : 변경 셀만 '^' bulk (L518~557) + price ''→'0' / '0'→action 'D' / 그 외 action ''.
//   권한     : AS-IS NowGroupID∈{ADMIN,DM ADMIN} 게이트(L148~162 / L392~407)를 TO-BE 는 버튼권한
//              메타로 이관 — `useTabBtnPermissions` 의 exchangeRate SAVE 보유 여부로 판정 (hook #125 §4.1).
export const ExchangeRateModal = ({ open, modalClose, divisionId, year, versionNo }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType<ExchangeRatePivotRow>>(undefined);
  const editTrackerRef = useRef<EditTracker<ExchangeRatePivotRow> | undefined>(undefined);
  const sesUserId = useSessionStore.getState().session.userId ?? '';

  // 조회조건 입력값 (AS-IS clbDivision / usrYear) — 조회 확정은 Search(=AS-IS Find) 에서만.
  const [inputDivisionId, setInputDivisionId] = useState(divisionId);
  const [inputYear, setInputYear] = useState(year);
  // 확정 조회조건 — useTabProcQuery filters 참조 안정화 원천 (stale closure·인라인 filters 사고 방지)
  const [applied, setApplied] = useState({ divisionId, year });

  // 신규 행 (AS-IS InsertRow L614~653 — CRUD_TYPE='I')
  const [insertedRows, setInsertedRows] = useState<ExchangeRatePivotRow[]>([]);
  const [saving, setSaving] = useState(false);

  // ⭐ 권한 = MAIN UI 와 동일 메커니즘 (hook #125 §4.1 / #128). 그룹명 하드코딩·session.groupId 금지.
  //   AS-IS 의 "ADMIN·DM ADMIN 만 Edit/Insert/Save" 는 버튼권한 메타로 이관돼 있다
  //   (DMF0044_P3_user_gr_btn_20260722.sql L21 — DM Viewer 는 exchangeRate SAVE 미보유).
  //   ⚠ `/admin/menu/{id}/auth` 는 SHT_NM 을 잃은 MNU_BTN_CD 합집합이라 'SAVE' 코드가 titleSet
  //     시트분과 섞인다(memory feedback_button_auth_sheet_scope_gap). 서버 @AuthCheck 가 최종 방어.
  //
  // ⭐ 사용자 확정 (2026-08-10): **Edit 버튼 미사용 — 권한이 있으면 모달 진입 즉시 편집모드**.
  //   AS-IS EditButton(L327~390)의 SwitchLock 토글은 승계하지 않고, 그 결과 상태
  //   (정적 컬럼 잠금 + 월 컬럼만 개방)를 초기 상태로 고정한다. 권한 없으면 전체 잠금(조회 전용).
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID, enabled: open });
  // ⭐ 편집 권한은 **환율 시트 전용 코드**로 판정한다 (REQ:CHAT-20260820-13, 사용자 확정 = AS-IS 파리티).
  //   `/admin/menu/{id}/auth` 는 BTN 코드 문자열 목록만 주고 **시트를 구분하지 않는다**(메뉴 단위 합집합).
  //   DMF0044 는 `titleSet/SAVE` 가 DM Viewer 에도 부여돼 있어 `hasButton('SAVE')` 로 판정하면
  //   **DM Viewer 에게 환율 편집·저장이 열린다** — AS-IS(`DMF0044_SalesReportExchangePopup.cs:148~162`)는
  //   ADMIN/DM ADMIN 만 통과시키고 나머지 그룹은 Edit/Insert/Save 버튼을 숨긴다.
  //   ⇒ 권한 판정 전용 코드 `EXRATE_SAVE`(exchangeRate 시트, ADMIN·DM ADMIN 만 부여)로 스코프를 좁힌다.
  //     저장 호출 라우팅은 기존 `SAVE`(API_ID 보유)가 그대로 담당한다.
  const canEdit = hasButton('EXRATE_SAVE');

  // 열 때마다 AS-IS Form_Load 초기 상태로 복원 (부모 Year/Division 승계 + 신규행 없음).
  //   ⭐ 자동조회 (사용자 지시 2026-08-10): 여기서 applied 를 즉시 세팅하고 아래 3 쿼리가
  //   `enabled: open && versionNo !== ''` 이므로 open 즉시 SEARCH/SEARCH_DATA/TITLE 이 자동 실행된다
  //   (AS-IS Form_Load L87 FindData() 1:1). 조회조건 변경 후 재조회는 기존대로 Search 버튼으로 확정.
  useEffect(() => {
    if (!open) return;
    setInputDivisionId(divisionId);
    setInputYear(year);
    setApplied({ divisionId, year });
    setInsertedRows([]);
    setSaving(false);
  }, [open, divisionId, year]);

  // Year 콤보 — AS-IS YearSet L104~119 (현재년 -5 ~ +10)
  const yearOptions = useMemo(() => {
    const from = new Date().getFullYear() - 5;
    const to = new Date().getFullYear() + 10;
    const list: Array<{ label: string; value: string }> = [];
    for (let y = from; y <= to; y++) list.push({ label: String(y), value: String(y) });
    return list;
  }, []);

  // ⭐ 조회 3종 — 모두 동일 filters (AS-IS FindData nvc 4키 + TO-BE userId/mnuId)
  const filters = useMemo(
    () => ({
      divisionId: applied.divisionId,
      year: applied.year,
      sesUserId,
      versionNo,
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [applied, versionNo, sesUserId]
  );
  // ① 골격 (AS-IS L426 DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP)
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.EXCHANGE_RATE>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE_RATE,
    tabId: MENU_ID,
    filters,
    enabled: open && versionNo !== '',
    queryOptions: { staleTime: 0 },
  });
  // ② 값 (AS-IS L441 …_POPUP_DATA)
  const { data: detailData, refetch: refetchDetail } = useTabProcQuery<
    MENU_ID,
    SHEETS.EXCHANGE_RATE
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE_RATE,
    procedureAction: 'SEARCH_DATA' as BUTTON_TYPE,
    tabId: `${MENU_ID}-exchange-rate-data`,
    filters,
    enabled: open && versionNo !== '',
    queryOptions: { staleTime: 0 },
  });
  // ③ 월 헤더 (AS-IS InitSpread L263 DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE — p_year)
  const { data: titleData } = useTabProcQuery<MENU_ID, SHEETS.EXCHANGE_RATE>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE_RATE,
    procedureAction: 'TITLE' as BUTTON_TYPE,
    tabId: `${MENU_ID}-exchange-rate-title`,
    filters,
    enabled: open && versionNo !== '',
    queryOptions: { staleTime: 0 },
  });

  // 동적 월 컬럼 — TITLE 커서(CALENDAR_YYYY / CALENDAR_MONTH / BASIS_START_DATE) 가 단일 원천.
  //   AS-IS 는 컬럼 Tag 를 "D"+BASIS_START_DATE 로 잡고 저장 시 그 값을 그대로 P_YYYYMMDD 로 보낸다
  //   (L536). TO-BE 도 동일 규약을 유지해 월 1일 가정(yyyymm+'01') 을 만들지 않는다.
  const monthColumns = useMemo<MonthColumn[]>(() => {
    const rows = (titleData as { data?: Array<Record<string, unknown>> } | undefined)?.data ?? [];
    const map = new Map<string, MonthColumn>();
    for (const r of rows) {
      const yyyymmdd = stripD(r.BASIS_START_DATE);
      if (!/^\d{8}$/.test(yyyymmdd)) continue;
      const yyyy = toCellStr(r.CALENDAR_YYYY).trim() || yyyymmdd.slice(0, 4);
      const mm = (toCellStr(r.CALENDAR_MONTH).trim() || yyyymmdd.slice(4, 6)).padStart(2, '0');
      map.set(yyyymmdd, { binding: `D${yyyymmdd}`, yyyymmdd, yyyy, mm });
    }
    return [...map.values()].sort((a, b) => a.yyyymmdd.localeCompare(b.yyyymmdd));
  }, [titleData]);

  const monthYearOf = useMemo(() => {
    const m = new Map<string, string>();
    for (const c of monthColumns) m.set(c.binding, c.yyyy);
    return m;
  }, [monthColumns]);

  // 2-step 조회 결과 병합 — AS-IS FindData L443~458 (골격 행 매칭 후 해당 월 셀에 SetText)
  const fetchedRows = useMemo<ExchangeRatePivotRow[]>(() => {
    const baseRows = (data as { data?: Array<Record<string, unknown>> } | undefined)?.data ?? [];
    const detailRows =
      (detailData as { data?: Array<Record<string, unknown>> } | undefined)?.data ?? [];
    const keyOf = (r: Record<string, unknown>) =>
      [r.DIVISION_ID, r.CURRENCY, r.UNIT_CURRENCY].map(v => toCellStr(v).trim()).join('|');

    const map = new Map<string, ExchangeRatePivotRow>();
    for (const r of baseRows) {
      const key = keyOf(r);
      if (map.has(key)) continue;
      map.set(key, {
        DIVISION_ID: toCellStr(r.DIVISION_ID).trim(),
        CURRENCY: toCellStr(r.CURRENCY).trim(),
        UNIT_CURRENCY: toCellStr(r.UNIT_CURRENCY).trim(),
        CURRENCY_UNITCURRENCY: toCellStr(r.CURRENCY_UNITCURRENCY).trim(),
        // 실측(2026-08-10) 골격 커서가 EDIT_YN 을 반환한다 — 서버 판정 = 행 단위 편집권 정본
        EDIT_YN: toCellStr(r.EDIT_YN).trim(),
        CRUD_TYPE: '',
      });
    }
    const known = new Set(monthColumns.map(c => c.binding));
    for (const d of detailRows) {
      // AS-IS L451 — 골격에 없는 통화쌍은 무시 (rows.Length > 0 가드)
      const row = map.get(keyOf(d));
      if (!row) continue;
      // 실측(2026-08-10): 값 커서 YYYYMMDD 는 'D20260101'(D 포함), TITLE BASIS_START_DATE 는
      //   '20260101'(D 없음). stripD 로 정규화 후 'D' 재부착 → 양쪽 binding 이 항상 일치(이중 D 없음).
      const binding = `D${stripD(d.YYYYMMDD)}`;
      // AS-IS L456 GetColumnIndex(-1) 무시와 동일 — 헤더에 없는 월은 버린다
      if (!known.has(binding)) continue;
      // AS-IS L450 은 문자열 그대로 SetText 하므로 빈 값이면 셀도 빈 칸이다 — 0 으로 채우지 않는다.
      const raw = toCellStr(d.EXCHANGE_PRICE).replace(/,/g, '').trim();
      if (raw === '') continue;
      const price = Number(raw);
      if (Number.isFinite(price)) row[binding] = price;
    }
    return [...map.values()];
  }, [data, detailData, monthColumns]);

  const rows = useMemo<ExchangeRatePivotRow[]>(
    () => [...insertedRows, ...fetchedRows],
    [insertedRows, fetchedRows]
  );

  // 재조회 = 신규행/편집 초기화 (AS-IS FindData L416 InitSpread + L429 LockColumn 전체).
  //   ⚠ 잠금 복원분은 승계하지 않는다 — 사용자 확정(2026-08-10) 권한 기반 상시 편집모드.
  useEffect(() => {
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
  }, [fetchedRows]);

  // ⭐ 정적 컬럼 = admin 동적 메타 (hook #113 / ui-category-setup-column-meta — 하드코딩 금지).
  //   SCM_MST_SHEET_COLUMNS PROGRAM_ID='DMF0044' / SHEET_NAME='exchangeRate' 4행:
  //   DIVISION_ID(FPComboBox 'Division', IM) / CURRENCY(S) / UNIT_CURRENCY(FPComboBox 'CurrencyList', IM)
  //   / CURRENCY_UNITCURRENCY(S, VISIBLE='N' — AS-IS L256 표시 false 1:1)
  const { data: metaColumns } = useQuery<RawFlexGridColumnConfig[]>({
    queryKey: ['dmf0044-exchange-rate-column', MENU_ID, SHEETS.EXCHANGE_RATE, applied.divisionId],
    queryFn: async () => {
      const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
        sheetNm: SHEETS.EXCHANGE_RATE,
        divisionId: applied.divisionId,
      });
      return res.data.result ?? [];
    },
    enabled: open,
  });
  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(() => metaColumns ?? [], [metaColumns]);
  const fixedBindings = useMemo(() => staticColumns.map(c => c.colNm), [staticColumns]);

  // 동적 월 컬럼 = nested columnGroups (1단 CALENDAR_YYYY → 2단 CALENDAR_MONTH).
  //   AS-IS AddNumColumn(w120, Right, 소수 2, 천단위 O) + ColumnHeaderSpan(연도) L279~294 1:1.
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const byYear = new Map<string, FlexGridColumnConfig[]>();
    for (const c of monthColumns) {
      if (!byYear.has(c.yyyy)) byYear.set(c.yyyy, []);
      byYear.get(c.yyyy)!.push({
        binding: c.binding,
        header: c.mm,
        width: 120,
        align: 'right',
        format: 'n2',
        allowSorting: false,
        visible: true,
      });
    }
    return [...byYear.entries()].map(([y, cols]) => ({
      header: y,
      align: 'center',
      columns: cols,
    }));
  }, [monthColumns]);

  // ⛔ AS-IS InsertRow L627 `SetCellTypeCombo(DIVISION_ID, dtDivision)`(신규행에 MyDivision 셀 콤보
  //   부착) 은 **미승계** — 사용자 확정(2026-08-10): 신규행 DIVISION_ID 는 조회조건 Division 을
  //   자동 세팅하고 셀 자체를 편집 불가로 둔다. 조회조건 Division 이 이미 비활성(부모 확정값)이라
  //   신규행이 다른 division 을 가질 수 없다. → 셀 콤보 dataMap 스왑/원복 로직도 제거했다.

  // AS-IS InsertRow L631~650 — 조회연도 < 현재년일 때 "현재월 이전" 월 컬럼을 신규행에서 잠근다.
  //   ⚠ 실측: 조회연도 < 현재년이면 모든 월이 현재 yyyymm 미만이라 break 에 도달하지 못해
  //     AS-IS 에서도 실제 잠금은 발생하지 않는다(무동작). 로직을 그대로 옮겨 동작을 일치시킨다.
  const insertLockedBindings = useMemo<Set<string>>(() => {
    const locked = new Set<string>();
    const selectedYear = Number(applied.year);
    const now = new Date();
    if (!Number.isFinite(selectedYear) || selectedYear >= now.getFullYear()) return locked;
    const nowYm = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}`;
    const firstFuture = monthColumns.findIndex(c => c.yyyymmdd.slice(0, 6) >= nowYm);
    if (firstFuture <= 0) return locked; // AS-IS break 미도달 = 잠금 없음
    for (let i = 0; i < firstFuture; i++) locked.add(monthColumns[i].binding);
    return locked;
  }, [applied.year, monthColumns]);

  // 월 셀 편집 가부 — AS-IS EditButton L342~346 이 만들던 "정적 컬럼 잠금 + 월 컬럼만 개방" 상태를
  //   권한(canEdit) 기반 상시 편집모드로 고정한다 (사용자 확정 2026-08-10 — Edit 버튼 미사용).
  //   ※ AS-IS 의 "과거월 잠금" 블록(L347~388)은 전체가 주석 처리돼 있어 미구현이 파리티다.
  //   ⭐ 추가 게이트: 서버가 주는 행 단위 `EDIT_YN`(실측 2026-08-10 — 골격/값 커서 모두 반환).
  //     'N' 이면 편집 차단. 권한 판정 정본은 서버라는 원칙(#128) + 형제 DMF0042 모달 동일 규약.
  const isMonthCellEditable = (row: ExchangeRatePivotRow | undefined, binding: string): boolean => {
    if (!canEdit || !row) return false;
    if (row.EDIT_YN === 'N') return false;
    if (row.CRUD_TYPE === 'I' && insertLockedBindings.has(binding)) return false;
    return true;
  };
  const isMonthCellEditableRef = useRef(isMonthCellEditable);
  isMonthCellEditableRef.current = isMonthCellEditable;

  // ⭐ 헤더 머지 + No. 코너 + 편집 게이트 + 셀 컬러링 (initialized prop deprecated → useEffect)
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders) return;

    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center'; // 연/월/고정 헤더 중앙 정렬 (AS-IS FPHAlign.Center)
        return;
      }
      // hook #108 — No. 코너 라벨 (setCellData 재귀 방지 가드)
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
        return;
      }
      // hook #95 3색 — 편집가능 Yellow / 편집가능하나 잠금 Gray / 그 외 클래스 없음(White+zebra).
      //   정적 컬럼은 공용 DataGrid(formatEditableColumns)가 메타 inputTpCd 로 이미 처리한다.
      if (e.panel.cellType === CellType.Cell) {
        const binding = e.panel.columns[e.col]?.binding ?? '';
        const rowItem = (e.panel.rows[e.row] as unknown as { dataItem?: ExchangeRatePivotRow })
          ?.dataItem;
        // ⭐ DIVISION_ID — 메타 inputTpCd='IM' 이라 공용 formatEditableColumns 가 신규행에 Yellow 를
        //   칠하지만, 화면 정책상 편집 불가이므로 Gray(잠금)로 덮어쓴다 (사용자 확정 2026-08-10).
        //   조회행은 원래 비편집이라 클래스를 붙이지 않는다 — hook #95 §1-3(전체 회색칠 금지).
        if (binding === 'DIVISION_ID') {
          const isInsertRow = rowItem?.CRUD_TYPE === 'I';
          e.cell.classList.toggle('wj-cell-editable', false);
          e.cell.classList.toggle('wj-cell-non-editable', isInsertRow);
          return;
        }
        if (!MONTH_BINDING.test(binding)) return;
        const item = rowItem;
        const editable = isMonthCellEditableRef.current(item, binding);
        const lockedButEditable =
          canEdit && item?.CRUD_TYPE === 'I' && insertLockedBindings.has(binding);
        e.cell.classList.toggle('wj-cell-editable', editable);
        e.cell.classList.toggle('wj-cell-non-editable', lockedButEditable);
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 게이트 — 월 컬럼 + DIVISION_ID 만 화면이 판정한다. 그 외 정적 컬럼(CURRENCY 'S' /
    //   UNIT_CURRENCY 'IM' / CURRENCY_UNITCURRENCY 'S')은 공용 메타 게이트(inputTpCd)에 위임하므로
    //   e.cancel 을 건드리지 않는다 (= AS-IS 정적 컬럼 잠금 L346 파리티).
    const beginningEditHandler = (
      s: FlexGridType<ExchangeRatePivotRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const column = s.columns[e.col];
      const binding = column?.binding ?? '';
      const item = s.rows[e.row]?.dataItem as ExchangeRatePivotRow | undefined;
      // ⭐ DIVISION_ID 는 신규행 여부와 무관하게 편집 불가 (사용자 확정 2026-08-10).
      //   메타 inputTpCd='IM' 이 신규행에 열어주는 것을 화면단에서 닫는다 — 신규행 값은
      //   handleInsert 가 조회조건 Division 으로 자동 세팅한다.
      if (binding === 'DIVISION_ID') {
        e.cancel = true;
        return;
      }
      if (!MONTH_BINDING.test(binding)) return;
      e.cancel = !isMonthCellEditableRef.current(item, binding);
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    g.allowMerging = AllowMerging.All;
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;

    // hook #108 — 커스텀 MergeManager 설치 시 nested 그룹의 네이티브 수평 span 이 무효화되므로
    //   동적 1단(연도) 머지를 직접 구현한다.
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
          if (MONTH_BINDING.test(binding) && r === 0) {
            const y = monthYearOf.get(binding);
            if (!y) return null;
            let c1 = c;
            let c2 = c;
            while (c1 > 0 && monthYearOf.get(panel.columns[c1 - 1]?.binding ?? '') === y) c1--;
            while (
              c2 < panel.columns.length - 1 &&
              monthYearOf.get(panel.columns[c2 + 1]?.binding ?? '') === y
            )
              c2++;
            if (c1 === c2) return null;
            return new CellRange(0, c1, 0, c2);
          }
          return null;
        }
        // AS-IS FPMerge.Restricted — DIVISION_ID(상위) / CURRENCY(Division+Currency) 계층 세로 머지.
        //   UNIT_CURRENCY 는 FPMerge.None (L255) 이라 머지하지 않는다.
        if (panel.cellType === CellType.Cell) {
          if (binding === 'DIVISION_ID' || binding === 'CURRENCY') {
            const view = panel.rows;
            const ri = (i: number): ExchangeRatePivotRow | undefined =>
              (view[i] as unknown as { dataItem?: ExchangeRatePivotRow })?.dataItem;
            if (!ri(r)) return null;
            const sameRow = (a: number, b: number): boolean => {
              const ra = ri(a);
              const rb = ri(b);
              if (!ra || !rb) return false;
              // 신규행은 머지 대상에서 제외 (키가 비어 있어 서로 붙어버리는 것 방지)
              if (ra.CRUD_TYPE === 'I' || rb.CRUD_TYPE === 'I') return false;
              if (binding === 'DIVISION_ID') return ra.DIVISION_ID === rb.DIVISION_ID;
              return ra.DIVISION_ID === rb.DIVISION_ID && ra.CURRENCY === rb.CURRENCY;
            };
            let r1 = r;
            let r2 = r;
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
      } catch {
        /* unmount race */
      }
    };
  }, [open, rows, monthColumns, monthYearOf, fixedBindings, canEdit, insertLockedBindings]);

  // ⭐⭐ hook #93 — 헤더 총높이 48px 상시 정규화 (2단=24×2 / 1단=48).
  //   정적 컬럼은 mapRawColumnsToWijmoColumns 가 1단 기준 height 48 을 부여하므로, 그대로 두면
  //   Wijmo "row 높이 = max(height)" 규칙에 걸려 48×2=96 이 된다. CustomDialog open 애니메이션 중
  //   헤더가 늦게 build 되면 updatedLayout 이 더는 뜨지 않는 재발 경로가 있어 raf 상시 루프로 방어
  //   (DMF0020 PriceBatchInputModal 에서 검증된 v2 패턴).
  useEffect(() => {
    if (!open) return;
    let raf = 0;
    let attached: FlexGridType<ExchangeRatePivotRow> | null = null;
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

  // Find — AS-IS FindButton L307~311 → FindData (재조회 + 전 컬럼 잠금).
  //   ⚠ Division/Year 변경만으로는 재조회하지 않는다 (AS-IS 도 Find 버튼에서만 조회).
  const handleSearch = () => {
    const next = { divisionId: inputDivisionId, year: inputYear };
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    if (applied.divisionId === next.divisionId && applied.year === next.year) {
      void Promise.all([refetch?.(), refetchDetail?.()]);
      return;
    }
    setApplied(next);
  };

  // hook #125 §4.2 — 상위 조회조건 변경 = Grid 초기화 + CRUD reset (재조회는 Search 버튼)
  const handleConditionChange = (nextDivisionId: string, nextYear: string) => {
    setInputDivisionId(nextDivisionId);
    setInputYear(nextYear);
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
  };

  // Insert — AS-IS InsertRow L614~653 (CURRENCY='KRW' 고정 + 잠금).
  //   AS-IS 의 `IsLock == false`(=Edit 진입) 가드는 권한 게이트로 대체 (Edit 버튼 미사용).
  const handleInsert = () => {
    if (!canEdit) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_권한이 없습니다.') });
      return;
    }
    setInsertedRows(prev => [
      {
        // ⭐ 조회조건 Division 자동 세팅 + 셀 편집 불가 (사용자 확정 2026-08-10).
        //   조회조건 Division 은 부모 확정값(비활성)이라 신규행이 타 division 을 가질 수 없다.
        DIVISION_ID: applied.divisionId,
        CURRENCY: 'KRW', // AS-IS L623 defaultData + L628 LockRange(CURRENCY) — 메타 inputTpCd='S'
        UNIT_CURRENCY: '',
        CURRENCY_UNITCURRENCY: '',
        EDIT_YN: 'Y', // 신규행은 서버 판정 대상이 아니므로 편집 허용 (권한 게이트 canEdit 이 상위)
        CRUD_TYPE: 'I',
      },
      ...prev,
    ]);
  };

  // Save — AS-IS SaveButton L392~407 (권한) → SaveData L467~612
  const handleSave = async () => {
    if (saving) return;
    // AS-IS SaveButton — 비ADMIN 은 MSG00096 후 중단
    if (!canEdit) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_권한이 없습니다.') });
      return;
    }

    // ① 필수값 검증 — action='I' 행만 (AS-IS L479~514). 첫 결측 1건만 통지(AS-IS if/else if).
    for (let i = 0; i < insertedRows.length; i++) {
      const row = insertedRows[i];
      const missing =
        row.DIVISION_ID.trim() === ''
          ? '[Division]'
          : row.CURRENCY.trim() === ''
            ? '[Currency]'
            : row.UNIT_CURRENCY.trim() === ''
              ? '[Unit]'
              : '';
      if (missing === '') continue;
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', missing),
      });
      // AS-IS L510 SetActiveCell(i, 2) — 해당 행 Currency 셀로 포커스
      const g = gridRef.current;
      const col = g?.columns.findIndex(c => c.binding === 'CURRENCY') ?? -1;
      if (g && col >= 0) g.select(new CellRange(i, col), true);
      return;
    }

    // ② 변경된 셀만 전송 (AS-IS L531~534 — ForeColor==Red 셀만. TO-BE 등가 = EditTracker 변경 셀)
    const changes = editTrackerRef.current?.getOriginalValues();
    const payloadRows: Array<Record<string, string>> = [];
    changes?.forEach((changed, row) => {
      const rowAction = row.CRUD_TYPE === 'I' ? 'I' : 'M';
      for (const binding of Object.keys(changed)) {
        if (!MONTH_BINDING.test(binding)) continue;
        let price = toCellStr(row[binding]).replace(/,/g, '').trim();
        let action = rowAction;
        // AS-IS L539~544 — ''→'0'(action 유지) / '0'→action 'D' / 그 외 action ''
        //   ⚠ AS-IS 는 루프 변수 action 을 덮어써 같은 행의 뒤 셀이 앞 셀 결과를 이어받는 결함이
        //     있다. TO-BE 는 셀마다 행 action 에서 새로 파생한다(문서화된 교정).
        if (price === '') price = '0';
        else if (price === '0') action = 'D';
        else action = '';
        payloadRows.push({
          activeFlag: action,
          divisionId: row.DIVISION_ID,
          versionNo,
          yyyymmdd: binding.slice(1), // 'D' 제거 = BASIS_START_DATE (AS-IS L536)
          currency: row.CURRENCY.trim().toUpperCase(),
          unitCurrency: row.UNIT_CURRENCY.trim().toUpperCase(),
          exchangePrice: price,
          // ⚠ 감사 2키 = FE 필수 전달 (BE 자동주입은 sesUserId 키뿐 — 미전달 시 CREATED_BY
          //   NOT NULL ORA-01400. AS-IS L553~554 행별 '^' 전달 1:1)
          createdBy: sesUserId,
          lastUpdatedBy: sesUserId,
        });
      }
    });

    if (payloadRows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }
    // ③ Price 전량 0 차단 — AS-IS L562~571 (join 후 '0' 과 '^' 를 지워 빈 문자열이면 오류)
    const joinedPrice = payloadRows.map(r => r.exchangePrice).join('^');
    if (joinedPrice.replace(/0/g, '').replace(/\^/g, '') === '') {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace(
          '{0}',
          '[EXCHANGE_PRICE]'
        ),
      });
      return;
    }

    setSaving(true);
    try {
      const keys = Object.keys(payloadRows[0]);
      const payload: Record<string, string> = {};
      for (const k of keys) payload[k] = payloadRows.map(r => r[k]).join('^');
      const res = await callSaveExchangeRate(payload);
      if (!res.ok) {
        void setAlert({
          type: 'alert',
          content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      // AS-IS L607 MessageHelper.GMessageBox("MSG00004", 건수) → 사내 MSG00002(저장 성공) 재매핑.
      //   주의: 사내 MSG00002 는 {0} 치환자가 없어 AS-IS 의 "N개" 건수 표기는 재현하지 않는다.
      //   성공은 Toast (AGENTS.md 저장 피드백 규칙) — 저장 직후 팝업이 닫히므로 Alert 이면
      //   확인 버튼 때문에 닫힘이 한 박자 늦는다.
      void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
      // ⭐ 사용자 확정 (2026-08-10): Save = 저장 + 닫기 겸용 (OK 버튼 미사용).
      //   저장 성공 시에만 닫는다. 닫기 전 신규행/EditTracker reset 은 유지하고,
      //   AS-IS L609 의 저장 후 FindData 재조회는 어차피 닫히므로 발사하지 않는다(불필요 재조회 방지).
      setInsertedRows([]);
      editTrackerRef.current?.clearChanges();
      modalClose();
    } finally {
      setSaving(false);
    }
  };

  // Excel — AS-IS ExcelButton (BaseForm 공통). TO-BE 공용 GridAction.excelDownload.
  const handleExcel = () => {
    const g = gridRef.current;
    if (!g) return;
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t('LBL00667', 'No data to save.') });
      return;
    }
    void GridAction.excelDownload(g as never, t('LBL00661', 'Exchange Rate'));
  };

  // ⭐ OK 버튼 미사용 — 사용자 확정(2026-08-10): Save 가 저장+닫기 겸용.
  //   AS-IS mOK() L709~712 은 blnOK=true 후 Close 였고, 부모(DMF0044_Sales_Reports.cs L1368~1376)의
  //   blnOK 재조회 블록이 전체 주석 처리돼 있어 OK 의 실제 효과는 Close 와 동일했다(승계 불필요).

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00661', 'Exchange Rate')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.contentWrapper}>
          {/* 조회조건 1행 — Div / Year (AS-IS usrConditionPanel1. hook #94 — 36px 표준 컴포넌트) */}
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
            conditions={
              <>
                {/* 표준 카탈로그 DivisionField = AS-IS clbDivision(Data.Type.MyDivision).
                    ⭐ 비활성 확정 (사용자 지시 2026-08-10) — 부모 화면 division 이 확정값
                    (형제 모달 DMF0042/DMF0020 동일 정책). AS-IS 재선택 가능 동작은 승계하지 않는다. */}
                <DivisionField
                  value={inputDivisionId}
                  gridSize={3}
                  disabled
                  onChange={v => handleConditionChange(v, inputYear)}
                />
                <Grid size={3}>
                  {/* ⚠ hook #121 §4 — 같은 행의 카탈로그 필드(DivisionField)가 commonStyles.formItem 을
                      쓰지 않으므로 라벨 폭 정합을 위해 동일 형태로 맞춘다 (VersionModal 정본 동일). */}
                  <FormItem
                    label={t('LBL00086', 'Year')}
                    labelAlign='right'
                    required
                    render={() => (
                      <CustomDropdown
                        value={inputYear}
                        options={yearOptions}
                        onChange={(_, option) =>
                          handleConditionChange(inputDivisionId, String(option ?? ''))
                        }
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />

          {/* 액션 바 — AS-IS btnButtonList (Find 는 SearchArea 가 담당).
              Insert/Save 는 AS-IS DefineProperty L148~162 와 동일하게 권한 없으면 숨긴다.
              ⭐ 사용자 확정(2026-08-10): Edit 버튼 미사용(권한 기반 상시 편집모드) /
                 OK 버튼 미사용(Save 가 저장+닫기 겸용) /
                 우측 Insert → Excel → Save → Close 고정 순서. */}
          <div className={styles.actionBar}>
            <div className={styles.actionBarSpacer} />

            {/* ⭐ 우측 고정 순서 = Insert → Excel(아이콘) → Save → Close (사용자 지시 2026-08-10).
                Insert/Save 는 권한 보유 시에만 노출, Excel/Close 는 항상 노출. */}
            {canEdit ? (
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                buttonLabel={t('LBL00121', 'Insert')}
                onClick={handleInsert}
              />
            ) : null}
            {/* Excel = 아이콘 버튼 (hook #120 스타일 — 텍스트 금지). 아이콘 = @shared/lges-icons
                FileExceldownloadIcon (형제 PriceBatchInputModal L1103 동일).
                Tooltip = LBL00670 'Excel' (public/locales KO/EN 실값 검증 완료). */}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              title={t('LBL00670', 'Excel')}
              iconComponent={<FileExceldownloadIcon />}
              onClick={handleExcel}
            />
            {/* Save = 저장 + (성공 시) 닫기 겸용 — OK 버튼 대체 (사용자 확정 2026-08-10) */}
            {canEdit ? (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel={t('LBL00626', 'Save')}
                disabled={saving}
                onClick={() => void handleSave()}
              />
            ) : null}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
          </div>

          <div className={styles.gridWrapper}>
            <DataGrid<ExchangeRatePivotRow>
              gridRef={gridRef}
              editTrackerRef={editTrackerRef}
              className={styles.grid}
              itemsSource={rows}
              staticColumns={staticColumns}
              dynamicColumns={dynamicColumns}
              autoGenerateColumns={false}
              frozenColumns={fixedBindings.length}
              allowSorting={false}
              allowMerging={AllowMerging.All}
            />
          </div>
        </div>
      }
    />
  );
};
