import {
  AllowMerging,
  CellRange,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useUIStore, useSessionStore } from '@shared/stores';

import { EXCHANGE_RATE_COLUMNS, MENU_ID, MSG, SHEETS } from '../../forecast-price.constants';

import styles from './ExchangeRateModal.module.scss';

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

interface ExchangeRow {
  DIVISION_ID?: string;
  YYYYMMDD?: string;
  YYYYMM?: string;
  CURRENCY?: string;
  UNIT_CURRENCY?: string;
  EXCHANGE_PRICE?: number | string;
  EDIT_YN?: string;
}

interface PivotRow {
  DIVISION_ID: string;
  CURRENCY: string;
  UNIT_CURRENCY: string;
  // 사용자×메뉴×Division 편집권한 (SP SCM_ADM_USER_MNU_EDIT_AUTH_V JOIN — DMF0042 모달 동일 계보)
  EDIT_YN: string;
  // ⭐ wrapper 표준 행 편집 플래그 (foundation GridUtils.isEditableCell — 'N' = 행 잠금).
  //   EDIT_YN 을 그대로 매핑해 wrapper 가 노란색(wj-cell-editable)+편집 허용을 자체 판정.
  EDIT_FLAG: string;
  // 'I' = Insert 신규 행 / '' = 기존 행 (AS-IS ActionTextBox FlagI/FlagM 대응 — CRUD_TYPE.INSERT)
  CRUD_TYPE: string;
  [yyyymmKey: string]: string | number;
}

// 서버 오류 본문에서 사람이 읽을 메시지를 뽑는다 (2026-08-13 신설).
//   배경: foundation responseErrorInterceptor 는 403/500 을 reject 하지 않고 error.response 를
//   그대로 돌려준다 (axios-interceptors.ts L53~55). 그래서 500 이 나도 catch 로 가지 않고 정상
//   응답처럼 res 에 담겨 오는데, 기존 코드는 proc 결과 커서만 보고 없으면 고정 문구로 뭉갰다.
//   즉 서버가 준 원인 문장을 화면이 손에 쥐고도 버려서, 원인 확인에 매번 DevTools 가 필요했다.
const serverErrorText = (status: number, body: unknown): string => {
  const bag = (body ?? {}) as Record<string, unknown>;
  const nested = (bag.error ?? {}) as Record<string, unknown>;
  for (const v of [bag.message, bag.error, bag.detail, bag.exception, nested.message]) {
    if (typeof v === 'string' && v.trim()) return `[${status}] ${v.trim()}`;
  }
  return `[${status}]`;
};

// DMF0020 ExchangeRateModal (hook #108 No. 코너 정본) 구조/머지/코너 로직 1:1 —
//   데이터 계약만 DMF0082 로 교체: SP = DMF0082_POPUP_GET_FUTUREPRICE_INFO
//   (4 IN + 2 OUT cursor — AS-IS DMF0082_ForecastPrice.cs L3166. P1-7 DB 배선 SQL 등록 예정)
//   long format → grid wide format / 동적 col binding = `M_yyyymm` (2-row header: YYYY / MM)
//   좌측 fixed cols Restricted merge (Division / Currency)
// ⭐ ADMIN 편집/저장 (2026-07-24 — AS-IS DMF0000_ExchangeRatePopup Edit/Insert/Save 1:1):
//   게이트 = hasButton('EDIT') [ADMIN·DM ADMIN 만 매핑] × divisionId='40' × 행 EDIT_YN × 당월 이후.
//   저장 = PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA '^' bulk 8키 → 성공 시 SP 내부에서
//   Sales Price 재계산(PKG_DMF0020 CONVERSION) 후속 실행 → MSG00689 안내 + 재조회.
//   Delete 기능 없음 (AS-IS 동일 — 사용자 확정 2026-07-24). 메타 배선 SQL =
//   _artifacts/_apply_corporate/DMF0082_exchange_modal_save_wiring_20260724.sql (사내 적용 완료)
export const ExchangeRateModal = ({ open, modalClose, defaultDivision, defaultPeriod }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  // CRUD 완료 알림 = 별도 팝업 대신 하단 중앙 토스트 (2026-08-13 사용자 지시).
  //   진행 중 표시는 토스트가 아니라 아래 스피너 오버레이가 담당한다 — 공통 ToastMessage 는
  //   스토어 고정 duration 으로 자동 닫히므로 오래 걸리는 작업 내내 붙잡아 둘 수 없고,
  //   그걸 바꾸면 다른 화면의 토스트 동작까지 함께 바뀐다.
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType<PivotRow>>(undefined);
  const [divisionId, setDivisionId] = useState(defaultDivision);
  const sesUserId = useSessionStore.getState().session.userId ?? '';

  // ⭐ ADMIN 편집 게이트 (AS-IS DefineProperty L120~141 1:1, 2026-07-24) —
  //   ① 그룹: futurePriceInfo 시트 EDIT/INSERT/SAVE 버튼이 ADMIN·DM ADMIN 그룹에만 매핑
  //     (BPS I/F 'IF' 버튼 선례. 서버측은 CustomAuthorizationManager 가 시트단위 SAVE 권한 강제)
  //   ② Division: AS-IS "40사업부만 수정이 가능하다" — divisionId='40' 에서만 편집 개방
  //   셀 단위는 추가로 행 EDIT_YN('Y') × 당월 이후(ym >= curYm — AS-IS EditButton L271~280) 게이트.
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const canEdit = hasButton('EDIT') && divisionId === '40';

  // 당월 기준 잠금 경계 (AS-IS this_YYYYMM = DateTime.Today "yyyyMM")
  const curYm = useMemo(() => {
    const d = new Date();
    return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}`;
  }, []);

  // Insert 신규 행 (AS-IS InsertRow L490~529 — DIVISION 고정 + Currency/Unit 콤보 편집)
  const [insertedRows, setInsertedRows] = useState<PivotRow[]>([]);
  // 편집 추적 — row 객체 → (ym → 값). 저장 성공/재조회/모달 재오픈 시 clear (DMF0042 모달 계보)
  const editsRef = useRef<Map<PivotRow, Map<string, number>>>(new Map());
  const [editCount, setEditCount] = useState(0);
  const clearEdits = () => {
    editsRef.current.clear();
    setEditCount(0);
    setInsertedRows([]);
  };

  // Currency 콤보 (AS-IS dtCurrency = Data.Common(CURRENCY_LIST) — 공유 CMBO 'CurrencyList')는
  //   여기서 직접 만들지 않는다. DataGrid wrapper 가 컬럼 메타(cellCboDataTp)를 보고 조회+부착까지
  //   전담한다 — 아래 gridStaticColumns 주석 참조.

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

  useEffect(() => {
    if (open) {
      setDivisionId(defaultDivision);
      setPeriodFrom(defaultPeriod.start);
      setPeriodTo(defaultPeriod.end);
      editsRef.current.clear();
      setEditCount(0);
      setInsertedRows([]);
    }
  }, [open, defaultDivision, defaultPeriod.start, defaultPeriod.end]);

  // sheet 'futurePriceInfo' — SP DMF0082_POPUP_GET_FUTUREPRICE_INFO (4 IN + 2 OUT, divisionId 인자 없음
  //   — sesUserId/mnuId BE 자동). filters useMemo 안정화 (refetch loop 방지)
  const startYyyymmdd = periodFrom.length === 6 ? `${periodFrom}01` : periodFrom;
  const endYyyymmdd = periodTo.length === 6 ? `${periodTo}31` : periodTo;
  const filters = useMemo(() => ({ startYyyymmdd, endYyyymmdd }), [startYyyymmdd, endYyyymmdd]);
  // ⭐ 자동조회 (2026-07-07 사용자 요구 — Batch Price Input 제외 전 modal 자동조회):
  //   enabled=open → modal open 시 react-query 가 filters(기간)로 자동 fetch. Find 버튼은 재조회용 유지.
  //   (setFilter();refetch() 직접 발사 대신 enabled 구동 → stale-closure NULL 재조회 함정 회피.)
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.FUTURE_PRICE_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.FUTURE_PRICE_INFO,
    tabId: MENU_ID,
    filters,
    enabled: open,
  });

  // ⭐ BPS I/F (AS-IS DMF0000_ExchangeRatePopup.btnBPS_Click — ADMIN/DM ADMIN 만, hasButton('IF') 게이트).
  //   PR_SCM_MST_EXCHANGE_RATE_UI(batchYn='N') 래퍼 호출 → BPS 환율 인터페이스 갱신 → 성공/실패 알림 → 재조회.
  //   (공유 배치 proc PR_SCM_MST_EXCHANGE_RATE 는 미변경 — OUT 커서 보유 래퍼 신설로 배치 파손 회피.)
  const setProgress = useUIStore.getState().setProgress;
  const [ifRunning, setIfRunning] = useState(false);
  const handleBpsIf = async () => {
    if (ifRunning) return;
    setIfRunning(true);
    setProgress(50); // ⭐ BPS I/F 는 장기(~수십초) 배치 — 전역 로딩바 표시 (0<v<100 = 표시)
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/futurePriceInfo/IF/call-proc`,
        { batchYn: 'N' }
      );
      // 결과 = res.data.result.o_result_cursor[0] (PROC_RESULT 커서, saveExcelUpload 패턴 1:1).
      //   구버전은 res.data.result[0](배열형)으로 오파싱해 성공(CODE='0')을 실패로 처리하는 버그.
      const inner = (
        res.data?.result as { o_result_cursor?: { CODE?: string; RESULT_MSG?: string }[] }
      )?.o_result_cursor?.[0];
      const ok = res.status < 400 && !!inner && String(inner.CODE) === '0';
      // 실패 사유 우선순위: proc 결과 메시지 > 서버 오류 본문 > 고정 문구.
      const failure =
        inner?.RESULT_MSG ||
        (res.status >= 400 ? serverErrorText(res.status, res.data) : '') ||
        t('MSG00455', '_환율 정보 반영에 실패했습니다.');
      // 완료는 별도 팝업(Alert) 대신 하단 중앙 토스트로 표기 후 사라진다 (2026-08-13 사용자 지시).
      //   실패는 사용자가 원인을 읽고 확인해야 하므로 팝업을 유지한다.
      if (ok) {
        setToast({
          message: t('MSG00454', '_환율 정보가 정상적으로 반영되었습니다.'),
          type: 'success',
        });
        void refetch();
      } else {
        await setAlert({ type: 'alert', content: failure });
      }
    } catch {
      await setAlert({ type: 'alert', content: t('MSG00455', '_환율 정보 반영에 실패했습니다.') });
    } finally {
      setProgress(100); // 완료 — 로딩바 리셋(0)
      setIfRunning(false);
    }
  };

  // ⭐ 성능(2026-07-08, 메인 그리드 동일 사유) — allRows/filteredRows 참조 안정화(useMemo).
  //   CustomDialog 는 open=false 라도 content 를 mount 하므로, 렌더 본문 계산이면 "메인 화면"의 매
  //   리렌더마다 KRW 필터 루프가 재실행되고 pivotRows(useMemo deps=filteredRows)까지 매번 재계산 →
  //   숨겨진 모달 grid 가 itemsSource 재바인딩을 반복(메인 조회 표시 지연에 가산). 데이터 변경 시에만 재계산.
  const filteredRows = useMemo<ExchangeRow[]>(() => {
    const allRows: ExchangeRow[] = data?.o_rc1 ?? [];
    // ⭐ Currency KRW 만 조회 (2026-07-07 사용자 요구) + Division 필터(고정 division).
    return allRows.filter(r => {
      if (String(r.CURRENCY ?? '').toUpperCase() !== 'KRW') return false;
      if (divisionId && divisionId !== 'ALL' && String(r.DIVISION_ID ?? '') !== divisionId)
        return false;
      return true;
    });
  }, [data, divisionId]);

  // ===== long → wide pivot (사용자 요구 2026-06-03: AS-IS 2단 헤더 YYYY/MM) =====
  const { pivotRows, ymKeys } = useMemo(() => {
    const groupMap = new Map<string, PivotRow>();
    const ymSet = new Set<string>();
    for (const r of filteredRows) {
      const div = String(r.DIVISION_ID ?? '');
      const cur = String(r.CURRENCY ?? '');
      const uc = String(r.UNIT_CURRENCY ?? '');
      const ym = String(r.YYYYMM ?? '');
      if (!div || !cur || !uc || !ym) continue;
      ymSet.add(ym);
      const key = `${div}|${cur}|${uc}`;
      if (!groupMap.has(key)) {
        const editYn = String(r.EDIT_YN ?? 'N');
        groupMap.set(key, {
          DIVISION_ID: div,
          CURRENCY: cur,
          UNIT_CURRENCY: uc,
          EDIT_YN: editYn,
          EDIT_FLAG: editYn, // wrapper isEditableCell 표준 키 ('N' = 행 잠금)
          CRUD_TYPE: '',
        });
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
  }, [filteredRows]);

  // 조회 행 + Insert 신규 행 (AS-IS siMain.Insert() 행 추가 — 저장 성공/재조회 시 초기화)
  const displayRows = useMemo(() => [...pivotRows, ...insertedRows], [pivotRows, insertedRows]);

  const fixedBindings = useMemo(() => EXCHANGE_RATE_COLUMNS.map(c => c.key), []);

  // ⭐ 성능(2026-07-08) — grid 컬럼 prop 참조 안정화. JSX inline .map 은 매 렌더 새 배열 →
  //   DataGrid(memo) 무력화 → (open=false mount 포함) 부모 리렌더마다 columnGroups 전체 재적용.
  // ⭐ Currency/Unit = Insert 행에서만 편집 (AS-IS InsertRow 콤보 L502~503) — 표준 'IM'
  //   (MANDATORY_INSERT_ONLY: CRUD_TYPE='I' 행만 wrapper 가 노란색+편집 개방). Division 은 항상 조회 전용.
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
          inputTpCd:
            canEdit && c.key !== 'DIVISION_ID'
              ? CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY
              : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
          // Currency/Unit 콤보 = wrapper 정식 경로로 위임 (2026-08-13, 형제 business-plan
          //   ExchangeRateModal 과 동일 결론). DataGrid 는 cellCtrlObjTpCd=COMBO + cellCboDataTp 를
          //   보고 콤보를 직접 조회해 new DataMap(rows,'CODE','NAME') 을 컬럼에 붙인다.
          //   주의: 그 매핑 코드는 조건에 안 맞는 컬럼의 dataMap 을 항상 undefined 로 덮으므로
          //   (DataGrid.tsx L494~497), 화면에서 col.dataMap 을 손으로 붙이면 컬럼 재적용 때마다
          //   지워져 "드롭다운은 열리는데 선택이 안 먹는" 상태가 된다. 부착 주체를 하나로 둔다.
          cellCtrlObjTpCd: c.key === 'DIVISION_ID' ? undefined : CELL_CONTROL_TYPE.COMBO,
          cellCboDataTp: c.key === 'DIVISION_ID' ? undefined : 'CurrencyList',
          // 금지: uppercase 를 켜지 않는다 — wrapper setHandleUppercase 가 cellEditEnded 에서
          //   setCellData(r, c, v, coerce=true) 를 호출하는데, dataMap 이 붙은 컬럼에서 coerce 는
          //   display→key 로 되돌리는 경로라 방금 고른 값을 덮어쓴다.
          //   AS-IS SaveData Trim().ToUpper() 파리티는 cellEditEnded 에서 행 객체에 직접 적용.
          uppercase: false,
        })
      ),
    [canEdit]
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
        // ⭐ 편집/노란색 = wrapper 표준 판정 (isEditableCell = 컬럼 _inputEditType × 행 EDIT_FLAG).
        //   당월 이후만 OPTIONAL (AS-IS EditButton L271~280 — Division~당월전 Lock), 과거월/비편집 = S.
        //   수동 wj-cell-editable 토글 금지 — wrapper formatEditableColumns 가 매 formatItem 재판정해
        //   덮어씀 (2026-07-24 노란색 누락 원인).
        _inputEditType:
          canEdit && ym >= curYm ? CELL_INPUT_EDIT_TYPE.OPTIONAL : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        allowSorting: false,
        visible: true,
      });
    }
    return [...byYear.entries()].map(([y, cols]) => ({
      header: y, // 1단 = 년도 (AS-IS '2026' — 같은 년도 월들을 수평 span)
      align: 'center',
      columns: cols,
    }));
  }, [ymKeys, canEdit, curYm]);

  // ⭐ #70 — DataGrid `initialized` prop deprecated(wrapper 미호출) → useEffect + gridRef 로 이동.
  //   2단 column header(YYYY/MM) + 좌측 fixed 머지 + 동적 YYYY horizontal 머지 + Division/Currency cell 머지.
  //
  // 주의: 그리드가 준비될 때까지 재시도한다 (2026-08-13 — "기존 행을 수정했는데 저장 시 변경된
  //   데이터가 없다고 뜬다" 의 원인). FlexGrid 는 조회 데이터가 도착한 뒤에 생성되는데 이 effect 는
  //   그 전에 실행되고 끝난다. 예전처럼 `if (!g) return` 으로 포기하면 deps 가 다시 바뀌지 않는 한
  //   cellEditEnded 가 영영 안 붙고, 그 상태에서 셀을 고치면 editsRef 가 비어 있어 Save 가
  //   "수정한 내용이 없습니다" 로 막힌다. 셀이 빨간색으로 바뀌고 행에 M 이 붙는 것은 공통 wrapper
  //   EditTracker 가 하는 일이라, 화면상으로는 수정이 반영된 것처럼 보여 더 헷갈린다.
  //   (Insert 를 누르면 displayRows 가 바뀌어 그제서야 붙던 간헐 증상의 정체 — 형제 business-plan
  //   ExchangeRateModal 이 2026-08-07 에 같은 사유로 재시도 방식으로 전환했다.)
  useEffect(() => {
    let raf = 0;
    let cleanup: (() => void) | undefined;

    const setup = (): boolean => {
      const g = gridRef.current;
      // ⭐ CustomDialog 는 open=false 라도 content 를 mount 한다. 숨겨진(host display:none) 상태의
      //   Wijmo grid 는 panel 을 지연 초기화하므로 columnHeaders 가 null 일 수 있다 → guard 필수.
      if (!g || !g.columnHeaders) return false;

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
        // 노란색(wj-cell-editable)은 wrapper formatEditableColumns 가 컬럼 _inputEditType ×
        // 행 EDIT_FLAG/CRUD_TYPE 로 자체 판정 — 수동 토글 금지 (재판정에 덮어써 누락되는 사고).
      };
      g.formatItem.addHandler(formatHandler);

      // Insert 행 Currency/Unit = CURRENCY_LIST 콤보 (AS-IS InsertRow SetCellTypeCombo L502~503).
      //   dataMap 부착은 wrapper 가 컬럼 메타로 전담(gridStaticColumns 주석) — 화면에서 수동
      //   스왑/원복하지 않는다. 편집 허용/차단은 wrapper defaultEditHandler(isEditableCell)가
      //   컬럼 inputTpCd(IM = Insert 행 전용) × 행 CRUD_TYPE 으로 판정한다.

      // 변경 수집 (AS-IS 빨간색 변경 셀만 저장 L391~417 대응) + Currency/Unit dataMap 원복·대문자 정규화
      const cellEditEndedHandler = (s: FlexGridType<PivotRow>, e: { row: number; col: number }) => {
        const binding = s.columns[e.col]?.binding ?? '';
        const item = s.rows[e.row]?.dataItem as PivotRow | undefined;
        if (!item) return;
        if (binding === 'CURRENCY' || binding === 'UNIT_CURRENCY') {
          // 금지: 여기서 col.dataMap 을 원복하지 않는다 — 상시 부착이 드롭다운 동작의 전제.
          //   값은 행 객체에 직접 쓴다 (setCellData 의 coerce 경로를 타지 않기 위함).
          item[binding] = String(item[binding] ?? '')
            .trim()
            .toUpperCase(); // AS-IS SaveData Trim().ToUpper() L386~387
          return;
        }
        if (!/^M_\d{6}$/.test(binding)) return;
        const raw = String(item[binding] ?? '').replace(/,/g, '');
        const value = raw === '' ? 0 : Number(raw); // AS-IS 빈값 → '0' (L401~402)
        if (!Number.isFinite(value)) return;
        const ym = binding.slice(2);
        const ymMap = editsRef.current.get(item) ?? new Map<string, number>();
        ymMap.set(ym, value);
        editsRef.current.set(item, ymMap);
        setEditCount([...editsRef.current.values()].reduce((n, m) => n + m.size, 0));
      };
      g.cellEditEnded.addHandler(cellEditEndedHandler);

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
                view[i]?.dataItem as PivotRow | undefined;
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

      cleanup = () => {
        try {
          g.formatItem?.removeHandler(formatHandler);
          g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        } catch {
          /* unmount race */
        }
      };
      return true;
    };

    // 그리드가 아직 없으면 다음 프레임에 다시 시도 — 붙을 때까지 포기하지 않는다.
    const trySetup = () => {
      if (setup()) return;
      raf = requestAnimationFrame(trySetup);
    };
    trySetup();

    return () => {
      cancelAnimationFrame(raf);
      cleanup?.();
    };
  }, [open, displayRows, ymKeys, fixedBindings, canEdit, curYm]);

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
    clearEdits(); // AS-IS FindData = 재조회 시 편집 상태 초기화 (전체 Lock 복귀 L323)
    void refetch?.();
  };

  // ⭐ Insert (AS-IS InsertButton → InsertRow L490~529) — DIVISION 고정 + Currency/Unit 콤보 행 추가
  const handleInsert = () => {
    setInsertedRows(prev => [
      ...prev,
      {
        DIVISION_ID: divisionId,
        CURRENCY: '',
        UNIT_CURRENCY: '',
        EDIT_YN: 'Y',
        EDIT_FLAG: 'Y',
        CRUD_TYPE: 'I',
      },
    ]);
  };

  // ⭐ Save (AS-IS SaveButton → SaveData L284~488 1:1) — 변경 셀만 '^' bulk 전송.
  //   SP = PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA (8 IN + O_RESULT_CURSOR — 기배포 본문 무수정).
  //   '^' bulk = apiClient.post 직접 (useProcMutation array unfold 금지 — hook #99 계보).
  //   감사 2키 = createdByBulk/lastUpdatedByBulk N-반복 (BE 가 'createdBy' 키를 세션 단일값으로
  //   덮어쓰므로 별도 키명으로 등록 — PROC_M 배선 SQL 참조. AS-IS FE L414~415 반복 append 1:1).
  const [saving, setSaving] = useState(false);
  const handleSave = async () => {
    if (saving) return;
    // (1) Insert 행 필수값 (AS-IS L339~374 — Division/Currency/Unit 순 첫 결손 필드 알림)
    for (const r of insertedRows) {
      const missing = !r.DIVISION_ID
        ? '[Division]'
        : !r.CURRENCY
          ? '[Currency]'
          : !r.UNIT_CURRENCY
            ? '[Unit]'
            : '';
      if (missing) {
        void setAlert({
          type: 'alert',
          content: t(MSG.REQUIRED, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', missing),
        });
        return;
      }
    }
    // (2) 변경 셀 수집 — 행 단위 flag: Insert 행 'I' / 기존 행 'M' (AS-IS sActionFlag)
    const entries: Array<{ row: PivotRow; ym: string; value: number }> = [];
    for (const [row, ymMap] of editsRef.current) {
      for (const [ym, value] of ymMap) entries.push({ row, ym, value });
    }
    if (entries.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }
    // (3) 신규 행 키 중복 차단 (2026-08-13) — SP 가 "중복된 데이터가 존재 합니다." 로 되던지는 건을
    //   저장 전에 잡아 **어떤 키가 걸렸는지** 알려준다. SP 는 (Division, YYYYMMDD, Currency, Unit)
    //   기준으로 판정하므로 여기서도 월 단위까지 포함해 같은 기준으로 본다.
    //
    //   주의: 대조 대상은 화면에 보이는 행(pivotRows)이 아니라 SP 원본 o_rc1 전체다.
    //   이 그리드는 CURRENCY='KRW' 행만 표시하므로(위 filteredRows — 2026-07-07 사용자 요구),
    //   예를 들어 USD/KRW 조합은 DB 에 있어도 화면에 안 보인다. "화면엔 중복이 없는데 SP 는 중복이라
    //   한다"의 정체가 이 숨은 행이다. 보이는 행만 대조하면 같은 함정을 그대로 반복한다.
    const dupKey = (div: string, ym: string, cur: string, unit: string): string =>
      [div, ym, cur.trim().toUpperCase(), unit.trim().toUpperCase()].join('|');
    const existingKeys = new Set(
      ((data?.o_rc1 ?? []) as ExchangeRow[]).map(r =>
        dupKey(
          String(r.DIVISION_ID ?? ''),
          String(r.YYYYMM ?? ''),
          String(r.CURRENCY ?? ''),
          String(r.UNIT_CURRENCY ?? '')
        )
      )
    );
    for (const en of entries) {
      if (en.row.CRUD_TYPE !== 'I') continue; // 기존 행은 UPDATE — 중복 대상 아님
      const key = dupKey(en.row.DIVISION_ID, en.ym, en.row.CURRENCY, en.row.UNIT_CURRENCY);
      if (existingKeys.has(key)) {
        void setAlert({
          type: 'alert',
          content: t(MSG.DUP_SAVE_ERROR, '_저장시 중복 오류가 발생하였습니다. {0}').replace(
            '{0}',
            ` [${en.row.DIVISION_ID} / ${en.ym} / ${en.row.CURRENCY} / ${en.row.UNIT_CURRENCY}]`
          ),
        });
        return;
      }
      existingKeys.add(key); // Insert 행끼리의 중복도 같은 루프에서 걸린다
    }
    // (4) Price 값 필수 — 전부 0/빈값이면 차단 (AS-IS L421~430 [EXCHANGE_PRICE])
    if (entries.every(en => !en.value)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED, '_{0} 값은 필수 입력 항목입니다.').replace(
          '{0}',
          '[EXCHANGE_PRICE]'
        ),
      });
      return;
    }
    setSaving(true);
    setProgress(50); // SAVE SP 후속 Sales Price 재계산(CONVERSION) 포함 — 장기 실행 가능
    try {
      const join = (sel: (en: (typeof entries)[number]) => string): string =>
        entries.map(sel).join('^');
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/futurePriceInfo/SAVE/call-proc`,
        {
          activeFlag: join(en => (en.row.CRUD_TYPE === 'I' ? 'I' : 'M')),
          divisionId: join(en => en.row.DIVISION_ID),
          yyyymmdd: join(en => `${en.ym}01`), // 사내 실측 — YYYYMMDD 전행 월 1일
          currency: join(en => en.row.CURRENCY.trim().toUpperCase()),
          unitCurrency: join(en => en.row.UNIT_CURRENCY.trim().toUpperCase()),
          exchangePrice: join(en => String(en.value)),
          createdByBulk: join(() => sesUserId),
          lastUpdatedByBulk: join(() => sesUserId),
        }
      );
      // 결과 = o_result_cursor[0] {CODE, MSG, EVENT} — CODE '0' 성공 / '-1' Validation (EVENT=사유)
      const inner = (
        res.data?.result as { o_result_cursor?: { CODE?: string; MSG?: string; EVENT?: string }[] }
      )?.o_result_cursor?.[0];
      const ok = res.status < 400 && !!inner && String(inner.CODE) === '0';
      if (!ok) {
        // 실패 사유 우선순위: SP 검증 메시지 > 서버 오류 본문(500 등) > 고정 문구.
        const reason =
          inner?.EVENT ||
          inner?.MSG ||
          (res.status >= 400 ? serverErrorText(res.status, res.data) : '');
        void setAlert({
          type: 'alert',
          content: reason || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      // 저장 완료 = 별도 팝업 대신 하단 중앙 토스트 (2026-08-13 사용자 지시).
      //   AS-IS MSG00456 "Sales Price Recalculation is complete." 문구는 그대로 승계.
      setToast({
        message: t(MSG.PRICE_RECALC_DONE, '_Sales Price Recalculation is complete.'),
        type: 'success',
      });
      clearEdits();
      void refetch?.();
    } catch {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.') });
    } finally {
      setProgress(100);
      setSaving(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      handleClose={modalClose}
      disableButtonCancel
      // 필수: Insert 행 Currency/Unit 셀 콤보 선택이 먹히게 하는 조건 (2026-07-30 이 화면 실측으로
      //   확정된 원인 — CustomDialog L44~50 주석의 근거가 이 모달이다).
      //   Wijmo 드롭다운 ListBox 는 MuiDialog-container 밖에 append 되고, MUI FocusTrap 이 포커스를
      //   컨테이너로 되돌리는 순간 Wijmo 가 포커스 상실로 finishEditing() → 에디터(_edt)를 파괴한다.
      //   그 뒤 항목을 클릭하면 finishEditing() 이 _edt null 로 조기 반환해 값이 조용히 버려지고
      //   리스트만 닫힌다. 주의: 그리드/dataMap 쪽을 고쳐도 이 prop 없이는 동작하지 않는다.
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
                    label={t('LBL00663', 'Div')}
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
                <PeriodField
                  gridSize={6}
                  start={periodFrom}
                  end={periodTo}
                  onChange={(start, end) => {
                    setPeriodFrom(start);
                    setPeriodTo(end);
                  }}
                />
              </>
            }
          />

          <div className={styles.gridWrapper}>
            <DataGrid<PivotRow>
              gridRef={gridRef}
              className={styles.grid}
              itemsSource={displayRows}
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
          </div>
          {/* 진행 스피너 — 다른 화면의 조회 로딩(MDIContainer .spinner)과 같은 회색 딤 + 원형 스피너.
              모달 안에 따로 두는 이유: 전역 표시는 앱 셸에 있어 다이얼로그 뒤에 깔려 안 보인다.
              placement='parent' = commonBgDim 배경의 백드롭을 부모(.dialogContentWrapper) 기준으로
              덮는다. 덮는 동안 그리드/버튼 클릭도 함께 막힌다 (중복 실행 방지). */}
          <ProgressIndicator shape='circular' placement='parent' open={ifRunning || saving} />
          <div className={styles.buttonWrapper}>
            {hasButton('IF') && divisionId.startsWith('40') && (
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                buttonLabel='BPS I/F'
                disabled={ifRunning}
                onClick={() => void handleBpsIf()}
              />
            )}
            {/* AS-IS DefineProperty — ADMIN/DM ADMIN × Division 40 에서만 Insert/Save 노출 */}
            {canEdit && hasButton('INSERT') && (
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                buttonLabel='Insert'
                onClick={handleInsert}
              />
            )}
            {canEdit && (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel={editCount > 0 ? `Save (${editCount})` : 'Save'}
                disabled={saving}
                onClick={() => void handleSave()}
              />
            )}
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
