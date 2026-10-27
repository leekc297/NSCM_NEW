import {
  AllowMerging,
  CellType,
  DataMap,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { apiClient } from '@foundation/apis';
import type { ComboResponse } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import {
  BOD_COLUMN,
  BOD_GRID_COMBO_ID,
  DAY_OF_WEEK_COLUMNS,
  MENU_ID,
  resolveToSiteBucket,
  SHEETS,
  TO_SITE_BUCKET,
  type ToSiteBucket,
} from '../bod.constants';
import type { BodSaveErrorRow } from '../bod.types';
import { useBodStore } from '../useBodStore';

// 저장검증 오류 행 배경 강조 — AS-IS SetBGColor(InvalidColor). 사용자 요청: 푸른계통.
const SAVE_ERROR_BG_COLOR = '#cce5ff';

// 오류코드별 강조 컬럼 (AS-IS Set_BGColor, 03_grid-columns.md §3.4 #43-46).
//   공통(99010~99040): DIVISION_ID~INCOTERMS. 99030/99040(기간중복/중첩): +TRANSPORT_MODE~TO_YYYYMMDD.
//   99010: +TRANSPORT_MODE. 99020: +PRIORITY.
const SAVE_ERROR_BASE_COLUMNS: string[] = [
  BOD_COLUMN.DIVISION_ID,
  BOD_COLUMN.CUSTOMER,
  BOD_COLUMN.FROM_SITE_CODE,
  BOD_COLUMN.FROM_CITY,
  BOD_COLUMN.TO_SITE_CODE,
  BOD_COLUMN.TO_CITY,
  BOD_COLUMN.VMI_YN,
  BOD_COLUMN.INCOTERMS,
];
const SAVE_ERROR_PERIOD_COLUMNS: string[] = [
  BOD_COLUMN.TRANSPORT_MODE,
  BOD_COLUMN.ROUTE_ID,
  BOD_COLUMN.LT_TYPE,
  ...DAY_OF_WEEK_COLUMNS,
  BOD_COLUMN.LEAD_TIME,
  BOD_COLUMN.DIS_TOTAL_LEAD_TIME,
  BOD_COLUMN.BOD_ID,
  BOD_COLUMN.BEFORE_LEAD_TIME,
  BOD_COLUMN.AFTER_LEAD_TIME,
  BOD_COLUMN.FROM_YYYYMMDD,
  BOD_COLUMN.REMARKS,
  BOD_COLUMN.TO_YYYYMMDD,
];
// 위반 행 매칭 키 — 그리드 값과 응답 값이 동일한 식별자만 사용(TRANSPORT_MODE 는 그리드=명칭·응답=코드라 제외).
const SAVE_ERROR_MATCH_KEYS: string[] = [
  BOD_COLUMN.DIVISION_ID,
  BOD_COLUMN.FROM_SITE_CODE,
  BOD_COLUMN.TO_SITE_CODE,
  BOD_COLUMN.INCOTERMS,
  BOD_COLUMN.PRIORITY,
];

// 인접 행 값이 같으면 세로로 셀을 병합하는 컬럼 — AS-IS SmartColMerge (SCP0007_BOD.cs InitSpread
// FPMerge.Restricted, L288-324 실측). FROM_COUNTRY/TO_COUNTRY/BOD_ID 도 Restricted 지만 AS-IS 에서
// bVisible=false 라 화면에 드러나지 않으므로 이식 대상에서 제외했다. TRANSPORT_MODE(L308)는 그리드
// 컬럼 순서상 INCOTERMS_SSP/SAFETY_STOCK/PRIORITY/ROUTE_CNT(전부 FPMerge.None) 뒤에 있어, 공용
// `CustomMergeManager`의 누적 키(왼쪽 컬럼 값을 전부 이어붙임)로는 그 사이 컬럼 값까지 같아야 병합돼
// AS-IS의 FarPoint 열 단위 독립 병합과 완전히 같지는 않다 — 값이 다르면 그냥 안 붙는 안전한 방향의
// 차이라 여기 포함해 두되, `__asis-mapping__.md` D00-3-001에 이 제약을 남긴다.
const MERGE_COLUMNS = new Set<string>([
  BOD_COLUMN.DIVISION_ID,
  BOD_COLUMN.CUSTOMER,
  BOD_COLUMN.FROM_SITE_CODE,
  BOD_COLUMN.FROM_CITY,
  BOD_COLUMN.TO_SITE_CODE,
  BOD_COLUMN.TO_CITY,
  BOD_COLUMN.VMI_YN,
  BOD_COLUMN.INCOTERMS,
  BOD_COLUMN.TRANSPORT_MODE,
]);

const rowMatchesSaveError = (dataItem: WijmoRowItem, err: BodSaveErrorRow): boolean =>
  SAVE_ERROR_MATCH_KEYS.every(key => String(dataItem[key] ?? '') === String(err[key] ?? ''));

const isSaveErrorColumn = (binding: string, errCode: string): boolean => {
  if (SAVE_ERROR_BASE_COLUMNS.includes(binding)) return true;
  if (errCode === '99030' || errCode === '99040') return SAVE_ERROR_PERIOD_COLUMNS.includes(binding);
  if (errCode === '99010') return binding === BOD_COLUMN.TRANSPORT_MODE;
  if (errCode === '99020') return binding === BOD_COLUMN.PRIORITY;
  return false;
};

// AS-IS SetReNumerCellType(SCP0007_BOD.cs L279-280) 이식: PRIORITY 는 min 0 / 소수 0자리, SAFETY_STOCK 은
// min 0 / 소수 1자리. 상한(PRIORITY max 99)은 numberRules 가 다루지 않는다.
const BOD_NUMBER_RULES = {
  [BOD_COLUMN.PRIORITY]: { positiveOnly: true, integerOnly: true },
  [BOD_COLUMN.SAFETY_STOCK]: { positiveOnly: true, decimalPlaces: 1 },
};

type CountryCityRow = ResponseData<MENU_ID, SHEETS.COUNTRY_CITY>;

// AS-IS Set_ValidTextColor(SCP0007_BOD.cs L958-1000) 색상 상수 — ControlColor.cs 실측값.
const ROUTE_INVALID_FG_COLOR = '#bdbdbd'; // InvalidFGColor
const ROUTE_MARKED_FG_COLOR = '#ff0000'; // MarkedForeColor
const ROUTE_DEFAULT_FG_COLOR = '#000000'; // DefaultForeColor

// ROUTE_VALID='N' 일 때 회색으로 바뀌는 구간 — AS-IS TRANSPORT_MODE~DIS_TOTAL_LEAD_TIME
// (DefColumns 선언 순서: TRANSPORT_MODE, DAYS_MON~SUN, LEAD_TIME, DIS_TOTAL_LEAD_TIME).
const ROUTE_VALID_DIMMED_COLUMNS: string[] = [
  BOD_COLUMN.TRANSPORT_MODE,
  ...DAY_OF_WEEK_COLUMNS,
  BOD_COLUMN.LEAD_TIME,
  BOD_COLUMN.DIS_TOTAL_LEAD_TIME,
];

type BodRow = ResponseData<MENU_ID, SHEETS>;

interface BodGridProps {
  gridRef: MutableRefObject<FlexGrid<BodRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: BodRow[];
  /** AS-IS dtCountryCity 캐시(GetData_Country, L604-638) — SCM_SITE_ID 로 country/city/VMI_YN/
   * SITE_TYPE 을 lookup 한다(Bod.tsx 가 division 스코프로 1회 조회). */
  countryCityRows: CountryCityRow[];
  /** ROUTE_ID 셀 더블클릭 — AS-IS spdMain_CellDoubleClick(L1027-1117), Route 선택 팝업 오픈. */
  onRouteCellDblClick: (row: BodRow, rowIndex: number) => void;
  /** 저장검증 실패 행(99030 기간중복 등) — 매칭 행 컬럼 배경 강조(AS-IS SetBGColor §3.4). */
  saveError: BodSaveErrorRow | null;
}

export const BodGrid = ({
  gridRef,
  gridFilterRef,
  data,
  countryCityRows,
  onRouteCellDblClick,
  saveError,
}: BodGridProps) => {
  const staticColumn = useBodStore(state => state.staticColumn);
  const divisionId = useBodStore(state => state.searchParams.divisionId);

  // TO_SITE 셀 콤보 3분기 원천 + FROM_SITE 콤보(OSP_YN 포함) — AS-IS SCP0007_BOD.cs L60/62-64
  // Data_SCP.CommonAll(...) 1:1. 검색조건 콤보(BodForm)와 별개로 그리드가 자체 조회한다.
  // divisionId 는 빈값('')으로 보낸다 — Oracle 은 '' 를 NULL 로 취급하므로 세 콤보의 `@divisionId
  // IS NULL` 분기가 발동해 전체가 온다(ToSiteBOD1 은 `@divisionId='ALL'` 분기가 없어 'ALL' 로 보내면
  // '-A' 접미만 27건 오는 버그가 있다 — 실측). 전체를 받은 뒤 아래 toSiteDataMap 에서 DIVISION_ID 로
  // client-side 필터한다(AS-IS Data_SCP.CommonAll(...,"") + DBUtils.Filter 와 동일 방식, cs:55-64/1130).
  const [fromSiteRows, toSiteAllRows, toSitePlantRows, toSiteDefaultRows] = useTabComboQueries({
    filters: [
      { comboId: BOD_GRID_COMBO_ID.FROM_SITE, divisionId: '' },
      { comboId: BOD_GRID_COMBO_ID.TO_SITE_ALL, divisionId: '' },
      { comboId: BOD_GRID_COMBO_ID.TO_SITE_PLANT_NON_OSP, divisionId: '' },
      { comboId: BOD_GRID_COMBO_ID.TO_SITE_DEFAULT, divisionId: '' },
    ],
  });

  // FROM_SITE 코드 → OSP_YN — AS-IS dtFromSiteOfSpd.Select("CODE=...")["OSP_YN"](cs:1136-1140).
  const ospByFromSite = useMemo(() => {
    const m = new Map<string, string>();
    for (const row of fromSiteRows ?? []) m.set(String(row.CODE), String(row.OSP_YN ?? 'N'));
    return m;
  }, [fromSiteRows]);

  // TO_SITE 행별 콤보 DataMap — getDisplayValues(rowItem) 가 그 행의 FROM_SITE 버킷
  // (resolveToSiteBucket: E/A+OSP/else) 후보만 돌려준다(CustomerModelMappingGrid 표준). 인덱스는
  // 3버킷 합집합이라 어떤 후보든 표시명(CODE→NAME) 이 보존된다. 콤보는 위에서 divisionId='' 로 전체를
  // 받았으므로, 여기서 AS-IS filterExpression(DIVISION_ID IN 선택division, cs:1130)을 client-side 로
  // 재현해 선택 division 만 남긴다(searchParams.divisionId, 'ALL'/빈값이면 전체 통과).
  const toSiteDataMap = useMemo(() => {
    const divisionCodes = divisionId
      .split(',')
      .map(c => c.trim())
      .filter(c => c !== '' && c.toUpperCase() !== 'ALL');
    const filterDiv = (rows: ComboResponse[] | undefined): ComboResponse[] =>
      (rows ?? []).filter(r => {
        if (String(r.CODE ?? '').trim() === '') return false;
        if (divisionCodes.length === 0) return true;
        const d = String(r.DIVISION_ID ?? '').trim();
        return d === '' || divisionCodes.includes(d);
      });
    const bucketRows: Record<ToSiteBucket, ComboResponse[]> = {
      [TO_SITE_BUCKET.ALL]: filterDiv(toSiteAllRows),
      [TO_SITE_BUCKET.PLANT_NON_OSP]: filterDiv(toSitePlantRows),
      [TO_SITE_BUCKET.DEFAULT]: filterDiv(toSiteDefaultRows),
    };
    const allRows = [
      ...bucketRows[TO_SITE_BUCKET.ALL],
      ...bucketRows[TO_SITE_BUCKET.PLANT_NON_OSP],
      ...bucketRows[TO_SITE_BUCKET.DEFAULT],
    ];
    if (allRows.length === 0) return null;
    const dataMap = new DataMap(allRows, 'CODE', 'NAME');
    const labels = (rows: ComboResponse[]): string[] =>
      rows.map(r => String(dataMap.getDisplayValue(r.CODE)));
    dataMap.getDisplayValues = (rowItem?: unknown): string[] => {
      const row = (rowItem ?? {}) as WijmoRowItem;
      const fromSite = String(row[BOD_COLUMN.FROM_SITE_CODE] ?? '');
      if (!fromSite) return labels(allRows);
      const bucket = resolveToSiteBucket(fromSite, ospByFromSite.get(fromSite) ?? 'N');
      return labels(bucketRows[bucket]);
    };
    return dataMap;
  }, [toSiteAllRows, toSitePlantRows, toSiteDefaultRows, divisionId, ospByFromSite]);

  // FROM_SITE 행별 콤보 DataMap — getDisplayValues(rowItem) 가 그 행의 DIVISION_ID 로 FROM 사이트를
  // 좁힌다(AS-IS DBUtils.Filter(dtFromSiteOfSpdAll, "DIVISION_ID IN(...)")). divisionId='' 로 전체를
  // 받아둔 fromSiteRows 를 재사용. DIVISION_ID 미선택 행은 전체 통과(division 먼저 고른 뒤 좁힘).
  const fromSiteDataMap = useMemo(() => {
    const rows = (fromSiteRows ?? []).filter(r => String(r.CODE ?? '').trim() !== '');
    if (rows.length === 0) return null;
    const dataMap = new DataMap(rows, 'CODE', 'NAME');
    const labels = (rs: ComboResponse[]): string[] => rs.map(r => String(dataMap.getDisplayValue(r.CODE)));
    dataMap.getDisplayValues = (rowItem?: unknown): string[] => {
      const row = (rowItem ?? {}) as WijmoRowItem;
      const div = String(row[BOD_COLUMN.DIVISION_ID] ?? '').trim();
      if (!div) return labels(rows);
      return labels(rows.filter(r => String(r.DIVISION_ID ?? '').trim() === div));
    };
    return dataMap;
  }, [fromSiteRows]);

  // 커스텀 dataMap 을 FROM/TO_SITE 컬럼에 지속 적용 — 공용 DataGrid 가 매 렌더 columnGroups 재대입으로
  // 메타 콤보 맵을 다시 씌우므로 updatedLayout 마다 재적용해야 한다(CustomerModelMappingGrid L112-132
  // 표준 처방). beginningEdit 1회 세팅은 재렌더에 초기화되어 무효였다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyOne = (binding: string, dm: DataMap | null) => {
      if (!dm) return;
      const col = g.columns.getColumn(binding);
      if (col && col.dataMap !== dm) col.dataMap = dm;
    };
    const apply = () => {
      applyOne(BOD_COLUMN.FROM_SITE_CODE, fromSiteDataMap);
      applyOne(BOD_COLUMN.TO_SITE_CODE, toSiteDataMap);
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, fromSiteDataMap, toSiteDataMap, data]);

  // 컬럼별 병합(allowMerging) 적용 — 공용 DataGrid 는 `allowMerging` prop 이 켜지면 화면에 보이는
  // 모든 컬럼에 일괄로 allowMerging=true 를 씌운다(DataGrid.tsx mappedStaticColumns). BOD 는 MERGE_
  // COLUMNS 9개만 병합 대상이라, 위 dataMap 재적용과 동일한 updatedLayout 처방으로 그 외 전 컬럼은
  // false 로 되돌린다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const apply = () => {
      for (const col of g.columns) {
        if (!col.binding) continue;
        col.allowMerging = MERGE_COLUMNS.has(col.binding);
      }
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, data]);

  // 최신 캐시를 beginningEdit/cellEditEnded 클로저에서 참조하기 위한 ref(재등록 없이 최신값 사용).
  const countryCityRowsRef = useRef<CountryCityRow[]>(countryCityRows);
  useEffect(() => {
    countryCityRowsRef.current = countryCityRows;
    // 캐시가 조회 결과보다 늦게 도착하면 To Site 타입 기반 편집 가능 표시(formatItem)를 다시 그린다.
    gridRef.current?.invalidate();
  }, [countryCityRows, gridRef]);

  // 저장오류 행 강조 — formatItem 클로저(effect deps [data])가 최신 값을 참조하도록 ref 로 보관하고,
  // 값이 바뀌면 그리드를 재그려(formatItem 재실행) 강조를 반영/해제한다.
  const saveErrorRef = useRef<BodSaveErrorRow | null>(saveError);
  saveErrorRef.current = saveError;
  useEffect(() => {
    gridRef.current?.invalidate();
  }, [saveError, gridRef]);

  /** dtCountryCity 캐시에서 SCM_SITE_ID 로 1건 lookup — AS-IS `dtCountryCity.Select("SCM_SITE_ID = ...")`. */
  const findCountryCity = (scmSiteId: string): CountryCityRow | undefined =>
    countryCityRowsRef.current.find(row => String(row.SCM_SITE_ID) === scmSiteId);

  // To Site 타입 — beginningEdit(편집 허용)과 formatItem(노란 바탕)이 같은 판정을 쓰도록 한 곳에 둔다.
  // 캐시에 없는 site 는 '' 이라 PLANT 가 아닌 것으로 취급한다.
  const getToSiteType = (dataItem: WijmoRowItem): string =>
    findCountryCity(String(dataItem[BOD_COLUMN.TO_SITE_CODE] ?? ''))?.SITE_TYPE ?? '';

  /**
   * From/To Site 확정 시 Country/City 자동 채움 + PLANT 조건부 Incoterms 잠금/기본값 +
   * Route Cnt 자동 재조회 — AS-IS SetCityCode(SCP0007_BOD.cs L1355-1467) 1:1.
   *   1) FROM_COUNTRY/FROM_CITY, TO_COUNTRY/TO_CITY/VMI_YN 을 캐시에서 채운다(④ #6).
   *   2) TO_SITE 가 PLANT 면: FROM/TO Site 앞자리(division 접두)가 같으면 INCOTERMS='EXW', 다르면
   *      'DAP'(+ 이 경우 INCOTERMS_SSP 도 동일값 동기화). PLANT 가 아니면 INCOTERMS 를 비운다.
   *      이 판정 결과로 INCOTERMS_SSP 행단위 편집 잠금 여부가 갈린다(④ #3 — isIncotermsSspLocked).
   *   3) From/To City 가 모두 있으면 SCP.SCP0007_GET_ROUTE_CNT 를 조회해 ROUTE_CNT 갱신(④ #5).
   * 확인필요(DB 접속 불가): countryCity/routeCnt 버튼 배선(05_register.sql)이 이번 세션 DB 미적용 —
   * 적용 전에는 아래 apiClient.callProc 호출이 -9997 No Permission 으로 실패한다.
   */
  const applyCityCode = async (grid: FlexGrid<BodRow>, row: number): Promise<void> => {
    const dataItem = GridUtils.getRow(grid, row) as WijmoRowItem | undefined;
    if (!dataItem) return;
    const fromSiteCode = String(dataItem[BOD_COLUMN.FROM_SITE_CODE] ?? '');
    const toSiteCode = String(dataItem[BOD_COLUMN.TO_SITE_CODE] ?? '');
    if (!fromSiteCode && !toSiteCode) return;

    const fromMatch = findCountryCity(fromSiteCode);
    dataItem[BOD_COLUMN.FROM_COUNTRY] = fromMatch?.COUNTRY ?? '';
    dataItem[BOD_COLUMN.FROM_CITY] = fromMatch?.CITY ?? '';

    const toMatch = findCountryCity(toSiteCode);
    dataItem[BOD_COLUMN.TO_COUNTRY] = toMatch?.COUNTRY ?? '';
    dataItem[BOD_COLUMN.TO_CITY] = toMatch?.CITY ?? '';
    dataItem[BOD_COLUMN.VMI_YN] = toMatch?.VMI_YN ?? '';
    const toSiteType = toMatch?.SITE_TYPE ?? '';

    if (toSiteType === 'PLANT') {
      dataItem[BOD_COLUMN.INCOTERMS] =
        fromSiteCode.split('-')[0] === toSiteCode.split('-')[0] ? 'EXW' : 'DAP';
      if (dataItem[BOD_COLUMN.INCOTERMS] === 'DAP') {
        dataItem[BOD_COLUMN.INCOTERMS_SSP] = dataItem[BOD_COLUMN.INCOTERMS];
      }
    } else {
      dataItem[BOD_COLUMN.INCOTERMS] = '';
      dataItem[BOD_COLUMN.INCOTERMS_SSP] = '';
    }

    const fromCity = String(dataItem[BOD_COLUMN.FROM_CITY] ?? '');
    const toCity = String(dataItem[BOD_COLUMN.TO_CITY] ?? '');
    if (fromCity && toCity) {
      try {
        const res = await apiClient.callProc<MENU_ID, SHEETS.ROUTE_CNT>(MENU_ID, SHEETS.ROUTE_CNT, 'SEARCH', {
          fromCity,
          toCity,
        });
        dataItem[BOD_COLUMN.ROUTE_CNT] = res.result?.o_rc1?.[0]?.ROUTE_CNT ?? dataItem[BOD_COLUMN.ROUTE_CNT];
      } catch {
        // 확인필요(DB 접속 불가) — countryCity/routeCnt 버튼 미배선 시 -9997. 재조회 실패는
        // 기존 ROUTE_CNT 값을 유지(사용자 저장 흐름을 막지 않는다).
      }
    }

    GridUtils.refreshRow(grid, row);
  };

  /**
   * 신규행(CRUD_TYPE='I') 컬럼별 잠금 — AS-IS InsertButton()의 named LockRange 4건
   * (CUSTOMER/FROM_CITY/TO_CITY/ROUTE_CNT, SCP0007_BOD.cs L414-418) +
   * ROUTE_ID~BOD_ID·ROUTE_VALID~끝 범위 잠금(L419-420) 전건 이식.
   * 범위는 `SCM_MST_SHEET_COLUMNS.SORT_ORDER_NO` 실측(2026-09-18, ora.py, PROGRAM_ID='SCP0007')
   * 으로 확정한 그리드 표시 순서를 그대로 나열한 것이다(추정 아님):
   *   ROUTE_ID(14)~BOD_ID(25) 구간 = ROUTE_ID·LT_TYPE·DAYS_MON~SUN(7)·LEAD_TIME·
   *     DIS_TOTAL_LEAD_TIME·BOD_ID
   *   ROUTE_VALID(29)~끝(37) 구간 = ROUTE_VALID·CREATED_BY·CREATION_DATE·LAST_UPDATED_BY·
   *     LAST_UPDATE_DATE·FROM_COUNTRY·TO_COUNTRY·ROUTE_CHK
   * (감사 컬럼 CREATED_BY 등은 서버 표준 처리 대상이라 편집 UI 자체가 없지만, AS-IS 와 동일하게
   * 신규행 잠금 목록에 포함해 두는 것이 1:1 이식 원칙에 부합한다.)
   *
   * DIVISION_ID 는 위 목록과 달리 항상 잠기지 않는다 — AS-IS L408-412 는 조회조건 Division 이
   * 정확히 1개(2자리 코드)만 선택돼 자동 세팅됐을 때만 잠근다(handleInsert 가 이미 이 조건으로
   * defaultRow[DIVISION_ID] 를 채운다, Bod.tsx L133-135). 자동세팅되지 않은 행(다중/미선택 Division)
   * 은 DIVISION_ID 를 직접 입력해야 하므로 편집 가능해야 한다 — 행의 DIVISION_ID 값 유무로 판정한다.
   */
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const NEW_ROW_LOCKED_COLUMNS: string[] = [
      BOD_COLUMN.CUSTOMER,
      BOD_COLUMN.FROM_CITY,
      BOD_COLUMN.TO_CITY,
      BOD_COLUMN.ROUTE_CNT,
      // ROUTE_ID~BOD_ID(SORT_ORDER_NO 14~25)
      BOD_COLUMN.ROUTE_ID,
      BOD_COLUMN.LT_TYPE,
      ...DAY_OF_WEEK_COLUMNS,
      BOD_COLUMN.LEAD_TIME,
      BOD_COLUMN.DIS_TOTAL_LEAD_TIME,
      BOD_COLUMN.BOD_ID,
      // ROUTE_VALID~끝(SORT_ORDER_NO 29~37)
      BOD_COLUMN.ROUTE_VALID,
      'CREATED_BY',
      'CREATION_DATE',
      'LAST_UPDATED_BY',
      'LAST_UPDATE_DATE',
      BOD_COLUMN.FROM_COUNTRY,
      BOD_COLUMN.TO_COUNTRY,
      BOD_COLUMN.ROUTE_CHK,
    ];

    const handler = (s: FlexGrid<BodRow>, e: CellRangeEventArgs) => {
      const col = s.columns[e.col];
      const binding = col?.binding;
      const dataItem = GridUtils.getRow(s, e.row) as WijmoRowItem | undefined;
      if (!binding || !dataItem) return;

      if (binding === BOD_COLUMN.SAFETY_STOCK) {
        // Safety Stock 편집 가능 여부 — AS-IS SpdMain_ComboSelChange(L1179-1187) 는 VMI_YN 을
        // 바꾼 **그 행만** LockRange 로 잠그고/푼다. 컬럼 레벨 isReadOnly 는 그리드 전체 행에
        // 적용되므로 쓸 수 없다 — beginningEdit 에서 편집하려는 행의 VMI_YN 을 그때그때 읽어
        // 행 단위로 취소한다(cascade-combo-filter.md §5-G 패턴, reference: SalesFuturePriceGrid.tsx).
        const vmiYn = String(dataItem[BOD_COLUMN.VMI_YN] as string | number | undefined);
        if (vmiYn !== 'Y') e.cancel = true;
        return;
      }

      if (NEW_ROW_LOCKED_COLUMNS.includes(binding) && dataItem.CRUD_TYPE === 'I') {
        e.cancel = true;
        return;
      }

      if (binding === BOD_COLUMN.DIVISION_ID && dataItem.CRUD_TYPE === 'I') {
        // 자동세팅된 행만 잠금(AS-IS L408-412) — handleInsert 가 division 단일선택일 때만
        // DIVISION_ID 를 채우므로, 값이 있으면 자동세팅된 것으로 판정한다.
        const divisionId = String(dataItem[BOD_COLUMN.DIVISION_ID] as string | number | undefined ?? '');
        if (divisionId !== '') e.cancel = true;
        return;
      }

      if (binding === BOD_COLUMN.INCOTERMS_SSP) {
        // INCOTERMS_SSP 행단위 조건부 편집잠금 — AS-IS EditButton(L438-503)+SetCityCode(L1415-1418)가
        // TO_SITE=PLANT 인 행만 편집 허용하고, 그 외에는 LockRange 로 잠근다(④ #3). TO_SITE_TYPE 은
        // dtCountryCity 캐시가 채운 TO_COUNTRY/TO_CITY 유무로 판정할 수 없어(PLANT 아닌 site 도 city
        // 는 채워진다) applyCityCode 가 세팅한 SITE_TYPE 판정 결과를 별도 필드로 남기지 않는 대신,
        // 매 편집 시도마다 캐시에서 TO_SITE_CODE 로 재조회해 판정한다(원본과 동일한 실시간 판정).
        if (getToSiteType(dataItem) !== 'PLANT') e.cancel = true;
        return;
      }

      if (binding === BOD_COLUMN.INCOTERMS) {
        // INCOTERMS 행단위 조건부 편집잠금 — AS-IS SetCityCode 가 TO_SITE=PLANT 인 행은
        // INCOTERMS 를 자동계산값(EXW/DAP)으로 세팅하고 잠그며(LockRange true), PLANT 가 아닌
        // 행만 사용자가 직접 입력하도록 연다(LockRange false). INCOTERMS_SSP 와 잠금 조건이
        // 반대다. TO-BE 는 이 잠금 분기가 없어 PLANT 행에서도 INCOTERMS 가 계속 편집 가능한
        // 상태였다(D00-3-085/087, __asis-mapping__.md).
        if (getToSiteType(dataItem) === 'PLANT') e.cancel = true;
        return;
      }
    };

    grid.beginningEdit.addHandler(handler);
    return () => grid.beginningEdit.removeHandler(handler);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data]);

  /**
   * 셀 cascade — AS-IS EditChange(SCP0007_BOD.cs L1328-1353) + SpdMain_Changed(L1277-1320) 1:1.
   *   - INCOTERMS 변경 → Incoterms(SSP) 동일값 동기화, TO_SITE 가 PLANT 가 아닐 때만(L1336-1351,
   *     PLANT 이면 SetCityCode 가 이미 EXW/DAP 로 세팅했으므로 사용자 재입력을 덮지 않는다).
   *   - FROM_SITE_CODE/TO_SITE_CODE 변경 → Country/City 자동채움 + PLANT 조건부 Incoterms +
   *     Route Cnt 재조회(applyCityCode = SetCityCode 1:1, ④ #5·#6).
   * INCOTERMS/INCOTERMS_SSP 편집 시 신규행 전용 콤보(dtIncotermsEdit) 로 후보를 좁히는 것은
   * 더 이상 이 컴포넌트가 직접 하지 않는다 — `SCM_MST_SHEET_COLUMNS.ATTRIBUTE9='incotermsEdit'`
   * 등록(2026-09-19, `.atlas/gscm-design/SCP0007/design/06_attribute9_incoterms_edit.sql`)으로
   * `columnMapping.ts`의 `insertComboId()`/`getDataMap()` 정식 경로가 DataGrid 레벨에서 자동
   * 처리한다(dev-manual 02 금지 패턴이던 컬럼 dataMap 수동 스왑 제거).
   *
   * 붙여넣기(clipboard paste)에도 동일 로직을 적용해야 한다 — AS-IS 는 SpdMain_ClipboardPasted
   * (L1191-1270)에서 SpdMain_ComboSelChange 와 완전히 동일한 cascade 를 반복 적용한다(03_grid-columns.md
   * §3.7). Wijmo 의 `cellEditEnded` 는 직접 편집에만 발생하고 붙여넣기에는 발생하지 않으므로, 아래
   * DataGrid 의 `pastedCell` prop 에도 이 핸들러를 그대로 재사용해 배선한다(같은 CellRangeEventArgs
   * 시그니처, 이벤트 이름만 다름).
   */
  const handleCellEdit = (grid: FlexGrid<BodRow>, e: CellRangeEventArgs) => {
    const col = grid.columns[e.col];
    const binding = col?.binding;
    const dataItem = GridUtils.getRow(grid, e.row) as WijmoRowItem | undefined;
    if (!binding || !dataItem) return;

    if (binding === BOD_COLUMN.INCOTERMS) {
      const toSiteCode = String(dataItem[BOD_COLUMN.TO_SITE_CODE] ?? '');
      const toSiteType = findCountryCity(toSiteCode)?.SITE_TYPE ?? '';
      if (toSiteType !== 'PLANT') {
        dataItem[BOD_COLUMN.INCOTERMS_SSP] = dataItem[BOD_COLUMN.INCOTERMS];
        GridUtils.refreshRow(grid, e.row);
      }
      return;
    }

    if (binding === BOD_COLUMN.FROM_SITE_CODE) {
      // FROM_SITE 변경 → TO_SITE 후보 재산정, 이전 선택 무효화(§5-G #3 계단식 clear, AS-IS 는
      // ComboSelChange 가 SetCellTypeCombo 로 콤보를 갈아끼우며 기존 값이 후보 밖이면 사라진다).
      dataItem[BOD_COLUMN.TO_SITE_CODE] = '';
    }
    if (binding === BOD_COLUMN.FROM_SITE_CODE || binding === BOD_COLUMN.TO_SITE_CODE) {
      void applyCityCode(grid, e.row);
    }
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    if (grid.columns[ht.col]?.binding !== BOD_COLUMN.ROUTE_ID) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;
    onRouteCellDblClick(dataItem, ht.row);
  };

  /**
   * Route 유효성 시각 표시 — AS-IS Set_ValidTextColor(SCP0007_BOD.cs L958-1000) 2규칙.
   *   1) ROUTE_VALID='N' → TRANSPORT_MODE~DIS_TOTAL_LEAD_TIME 구간 회색(InvalidFGColor).
   *   2) ROUTE_CHK(Route 팝업 원본 from/to city 와 그리드 현재 from/to city 일치 여부)!='Y'
   *      → ROUTE_ID 셀만 빨강(MarkedForeColor).
   * DataGrid 는 formatItem prop 을 노출하지 않아 gridNegativeText.ts(packages/foundation) 와
   * 동일하게 셀 DOM 에 직접 color 를 세팅한다(Wijmo 셀 DOM 재사용 — 조건 미해당 시 반드시 해제).
   */
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const handler = (s: FlexGrid<BodRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding;
      if (!binding) return;
      const dataItem = GridUtils.getRow(s, e.row) as WijmoRowItem | undefined;
      if (!dataItem) return;

      // 저장검증 오류 행 강조 — 매칭 행의 해당 컬럼 배경을 푸른색으로, 아니면 해제(셀 DOM 재사용 대비
      // 항상 재설정). AS-IS SetBGColor(InvalidColor) §3.4 #43-46.
      const err = saveErrorRef.current;
      e.cell.style.backgroundColor =
        err && rowMatchesSaveError(dataItem, err) && isSaveErrorColumn(binding, err.ERR_CODE ?? '')
          ? SAVE_ERROR_BG_COLOR
          : '';

      // Incoterms 계열 편집 가능 표시 — 공통 formatItem 은 컬럼 메타(INPUT_TP_CD)만 보고 노란 바탕
      // (wj-cell-editable)을 붙인다. 실제 편집은 beginningEdit 가 To Site 타입으로 막으므로, 막히는
      // 셀의 클래스만 여기서 걷어 바탕색과 편집 가능 여부를 맞춘다(클래스를 새로 붙이지는 않는다).
      // INCOTERMS_SSP 는 PLANT 일 때만, INCOTERMS 는 PLANT 가 아닐 때만 편집 가능하다.
      if (binding === BOD_COLUMN.INCOTERMS_SSP && getToSiteType(dataItem) !== 'PLANT') {
        e.cell.classList.remove('wj-cell-editable');
      } else if (binding === BOD_COLUMN.INCOTERMS && getToSiteType(dataItem) === 'PLANT') {
        e.cell.classList.remove('wj-cell-editable');
      }

      if (binding === BOD_COLUMN.DIVISION_ID) {
        // AS-IS Division 은 text 컬럼(cs:297)이고 combo(dtMyDivision)는 신규 활성행에만 per-cell
        // 로 붙는다(cs:387) → 기존(조회)행은 SP 가 준 코드 원문(40/81/82)이 보인다. TO-BE 는 컬럼
        // 레벨 combo(MyDivision NAME='코드 명칭')라 전 행이 NAME 으로 매핑되므로, 기존행만 코드
        // 원문으로 되돌린다(신규행 CRUD_TYPE='I' 은 combo NAME/드롭다운 그대로 유지).
        if (String(dataItem.CRUD_TYPE ?? '') !== 'I') {
          e.cell.textContent = String(dataItem[BOD_COLUMN.DIVISION_ID] ?? '');
        }
        return;
      }

      if (binding === BOD_COLUMN.ROUTE_ID) {
        const routeChk = String(dataItem[BOD_COLUMN.ROUTE_CHK] ?? '');
        e.cell.style.color = routeChk === 'Y' ? ROUTE_DEFAULT_FG_COLOR : ROUTE_MARKED_FG_COLOR;
        return;
      }

      if (ROUTE_VALID_DIMMED_COLUMNS.includes(binding)) {
        const routeValid = String(dataItem[BOD_COLUMN.ROUTE_VALID] ?? '');
        e.cell.style.color = routeValid === 'N' ? ROUTE_INVALID_FG_COLOR : ROUTE_DEFAULT_FG_COLOR;
      }
    };

    grid.formatItem.addHandler(handler);
    grid.invalidate();
    return () => grid.formatItem.removeHandler(handler);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data]);

  // ROUTE_ID/BOD_ID 는 SP 에서 Oracle NUMBER 로 와서 Wijmo 가 천단위 콤마를 붙인다(dataType=String
  // 만으로는 원시 숫자값에 그대로 포맷이 적용됨 — 실측). 표시·저장 모두 문자열이 맞으므로
  // (procedures.d.ts 도 string, 저장 SP 는 TO_NUMBER 로 읽음) 값을 문자열로 coerce 해 콤마를 없앤다.
  const gridData = useMemo(
    () =>
      data.map(row => ({
        ...row,
        ROUTE_ID: row.ROUTE_ID == null ? row.ROUTE_ID : String(row.ROUTE_ID),
        BOD_ID: row.BOD_ID == null ? row.BOD_ID : String(row.BOD_ID),
      })),
    [data]
  );

  return (
    <DataGrid<BodRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={gridData}
      staticColumns={staticColumn}
      numberRules={BOD_NUMBER_RULES}
      // AS-IS SmartColMerge(FPMerge.Restricted, MERGE_COLUMNS 참고) 이식 — Cells 로 켜면 공용
      // CustomMergeManager(packages/foundation/utils/mergeManager.ts)가 붙어 인접 행의 왼쪽부터
      // 누적된 값이 같은 구간을 세로로 병합한다. 실제 병합 대상 컬럼 선별은 위 updatedLayout
      // effect(allowMerging 재적용)가 담당.
      // All 을 써야 한다 — Cells 단독이면 CustomMergeManager._getColumnHeaderMergedRange 가
      //   grid.allowMerging 값으로 [All, AllHeaders, ColumnHeaders] 만 받아들여, 2단 헤더(Period
      //   그룹) 도입 시 그룹 없는 일반 컬럼까지 라벨이 위/아래 행에 중복 표시된다(세로 병합 불능,
      //   2026-09-29 SCP0007 Period 그룹 실사고). RowHeaders 비트는 이 매니저가 처리하지 않아 무해.
      allowMerging={AllowMerging.All}
      // 셀 메타 콤보(FROM_SITE_CODE = FromSiteByDivision1_SCP_ALL 등)의 @divisionId 해소 —
      // 미전달 시 division 필터가 빈값이라 FROM_SITE 콤보 자체가 빈다. raw 값(quoteComboParams 자동 인용).
      // INCOTERMS/INCOTERMS_SSP 의 기본 콤보 LookupCommon 은 @lookupType 이 필요하다. 미전달 시 BE 가
      // '' 로 치환해 0건이 되어, 기존행 드롭다운에 현재 값만 보인다(컬럼 메타 ATTRIBUTE1='INCOTERMS').
      // 이 그리드의 LookupCommon 컬럼은 이 두 개뿐이라 그리드 단위로 실어도 충돌하지 않는다.
      comboParams={{ divisionId, lookupType: 'INCOTERMS' }}
      cellEditEnded={handleCellEdit}
      pastedCell={handleCellEdit}
      dblClick={handleDblClick}
    />
  );
};
