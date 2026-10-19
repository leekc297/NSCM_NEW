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

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { EXCHANGE_RATE_COLUMNS, MENU_ID, SHEETS } from '../../sales-future-price.constants';
import { enumerateYyyymm } from '../../utils/futurePriceDate';

import styles from './ExchangeRateModal.module.scss';
import { useExchangeRateModalStore } from './exchangeRateModalStore';

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
}

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
}

interface PivotRow {
  DIVISION_ID: string;
  CURRENCY: string;
  UNIT_CURRENCY: string;
  [yyyymmKey: string]: string | number;
}

// AS-IS DMF0020_SalesFuturePricePopUp.cs L141~194 InitSpread + L324~334 PIVOT 클라이언트 측 변환
//   SP P_DMF0020_GET_FUTUREPRICE_INFO (long format) → grid wide format
//   동적 col binding = `M_yyyymm` (캡쳐 2-row header: YYYY / MM)
//   좌측 fixed cols Restricted merge (Division / Currency)
export const ExchangeRateModal = ({ open, modalClose, defaultDivision, defaultPeriod }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
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

  // ===== long → wide pivot (사용자 요구 2026-06-03: AS-IS 2단 헤더 YYYY/MM) =====
  const { pivotRows, ymKeys } = useMemo(() => {
    const groupMap = new Map<string, PivotRow>();
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
        groupMap.set(key, { DIVISION_ID: div, CURRENCY: cur, UNIT_CURRENCY: uc });
      }
      const row = groupMap.get(key)!;
      const price =
        typeof r.EXCHANGE_PRICE === 'number' ? r.EXCHANGE_PRICE : Number(r.EXCHANGE_PRICE);
      if (!Number.isNaN(price)) row[`M_${ym}`] = price;
    }
    const list = [...groupMap.values()].sort((a, b) => {
      if (a.DIVISION_ID !== b.DIVISION_ID) return a.DIVISION_ID.localeCompare(b.DIVISION_ID);
      if (a.CURRENCY !== b.CURRENCY) return a.CURRENCY.localeCompare(b.CURRENCY);
      return a.UNIT_CURRENCY.localeCompare(b.UNIT_CURRENCY);
    });
    const ymSorted = [...ymSet].sort();
    return { pivotRows: list, ymKeys: ymSorted };
  }, [filteredRows, periodYmKeys]);

  const fixedBindings = useMemo(() => EXCHANGE_RATE_COLUMNS.map(c => c.key), []);

  // ⭐ 성능(2026-07-08) — grid 컬럼 prop 참조 안정화. JSX inline .map 은 매 렌더 새 배열 →
  //   DataGrid(memo) 무력화 → (open=false mount 포함) 부모 리렌더마다 columnGroups 전체 재적용.
  const gridStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      EXCHANGE_RATE_COLUMNS.map(
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
    []
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
        isReadOnly: true,
        allowSorting: false,
        visible: true,
      });
    }
    return [...byYear.entries()].map(([y, cols]) => ({
      header: y, // 1단 = 년도 (AS-IS '2026' — 같은 년도 월들을 수평 span)
      align: 'center',
      columns: cols,
    }));
  }, [ymKeys]);

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
      // ⭐ No. 코너 헤더 라벨 (사용자 요구 2026-07-08) — rowHeader 순번 컬럼의 TopLeft 에 'No.' 표기
      //   (선례 ContributeViewGrid setCellData 패턴 1:1. 머지는 ExchangeMerge TopLeft 분기가 전담.)
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
      }
    };
    g.formatItem.addHandler(formatHandler);

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
          if (binding === 'DIVISION_ID' || binding === 'CURRENCY') {
            const view = panel.rows;
            const ri = (i: number): PivotRow | undefined =>
              (view[i] as unknown as { dataItem?: PivotRow })?.dataItem;
            if (!ri(r)) return null;
            const sameRow = (a: number, b: number): boolean => {
              const ra = ri(a);
              const rb = ri(b);
              if (!ra || !rb) return false;
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
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [open, pivotRows, ymKeys, fixedBindings]);

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
      handleClose={modalClose}
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
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
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
                isReadOnly
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
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
