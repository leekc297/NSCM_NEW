import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from './contribute-view.constants';
import styles from './ContributeView.module.scss';
import type { SalesViewRow, ViewSearchCondition } from './types';
import { useContributeViewStore } from './useContributeViewStore';

interface VersionOption {
  CODE: string;
  NAME?: string;
  NAME2?: string;
}

// AS-IS DMF0043_Contribute_View — 기여율 조회 (메인 조회만, 저장 없음)
export const ContributeView = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<SalesViewRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const filters = useContributeViewStore(s => s.filters);
  const searchCondition = useContributeViewStore(s => s.searchCondition);
  const setSearchCondition = useContributeViewStore(s => s.setSearchCondition);
  const setFilter = useContributeViewStore(s => s.setFilter);
  const openSearchArea = useContributeViewStore(s => s.openSearchArea);
  const setOpenSearchArea = useContributeViewStore(s => s.setOpenSearchArea);

  const { data: yearData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    filters: {},
    enabled: true,
  });

  const { data: mainData, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN] && !!searchCondition.verSeq,
  });

  const [yearOptions, setYearOptions] = useState<VersionOption[]>([]);

  useEffect(() => {
    const rows = (yearData?.o_rc1 ?? []) as VersionOption[];
    setYearOptions(rows);
    if (rows.length > 0 && !searchCondition.verSeq) {
      const first = rows[0];
      setSearchCondition({
        verSeq: String(first.CODE ?? ''),
        yyyy: String(first.NAME2 ?? first.NAME ?? '').substring(0, 4),
      });
    }
  }, [yearData]);

  const handleSearch = () => {
    if (!searchCondition.verSeq) {
      window.alert('버전을 선택해주세요');
      return;
    }
    setFilter();
    refetch?.();
  };

  // 자동 조회 — Year 자동 선택 직후
  useEffect(() => {
    if (searchCondition.verSeq && !filters[SHEETS.MAIN]) {
      setFilter();
    }
  }, [searchCondition.verSeq]);

  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: () => undefined,
    save: () => undefined,
    delete: () => undefined,
    manual: false,
    upload: false,
  };

  const rows = (mainData?.p_cursor_main ?? []) as SalesViewRow[];

  const setCond = (k: keyof ViewSearchCondition, v: string) =>
    setSearchCondition({ [k]: v } as Partial<ViewSearchCondition>);

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <div className={styles.searchBar}>
          <div className={styles.searchRow}>
            <label>
              Year
              <select
                value={searchCondition.verSeq}
                onChange={e => {
                  const opt = yearOptions.find(o => String(o.CODE) === e.target.value);
                  setSearchCondition({
                    verSeq: e.target.value,
                    yyyy: String(opt?.NAME2 ?? opt?.NAME ?? '').substring(0, 4),
                  });
                }}
              >
                <option value=''>선택</option>
                {yearOptions.map(o => (
                  <option key={String(o.CODE)} value={String(o.CODE)}>
                    {String(o.NAME2 ?? o.NAME ?? o.CODE)}
                  </option>
                ))}
              </select>
            </label>
            <label>
              Type
              <input value={searchCondition.productGroup} onChange={e => setCond('productGroup', e.target.value)} />
            </label>
            <label>
              Biz
              <input value={searchCondition.bizType} onChange={e => setCond('bizType', e.target.value)} />
            </label>
            <label>
              <input
                type='checkbox'
                checked={searchCondition.millionYn === 'Y'}
                onChange={e => setSearchCondition({ millionYn: e.target.checked ? 'Y' : 'N' })}
              />
              백만 단위
            </label>
          </div>
          <div className={styles.actionRow}>
            <button type='button' className={styles.searchButton} onClick={handleSearch}>🔍 조회 (F5)</button>
            <button type='button' className={styles.resetButton} onClick={() => useContributeViewStore.getState().reset()}>초기화</button>
            <span className={styles.hint}>Year 선택 후 자동 조회됩니다</span>
          </div>
        </div>
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ContributeView'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchCondition}
      />
      <div className={styles.gridContainer}>
        <FlexGrid<SalesViewRow>
          initialized={(g: FlexGridType<SalesViewRow>) => {
            if (gridRef && 'current' in gridRef) {
              (gridRef as { current: FlexGridType<SalesViewRow> | null }).current = g;
            }
          }}
          itemsSource={rows}
          autoGenerateColumns={false}
          style={{ height: '100%' }}
        >
          <FlexGridColumn binding='YYYYMM' header='YYYYMM' width={90} />
          <FlexGridColumn binding='DEPARTMENT_NAME' header='부서' width={120} />
          <FlexGridColumn binding='DEPT_NAME' header='팀' width={120} />
          <FlexGridColumn binding='END_CUST_REPORT' header='End Cust' width={120} />
          <FlexGridColumn binding='SOLDTO_CUST_REPORT' header='Sold-To' width={120} />
          <FlexGridColumn binding='SHIPTO_CODE' header='Ship-To' width={100} />
          <FlexGridColumn binding='PRODUCT_GROUP' header='제품군' width={100} />
          <FlexGridColumn binding='DM_BIZ_TYPE' header='Biz Type' width={100} />
          <FlexGridColumn binding='AMT' header='Amount' width={120} format='n0' />
        </FlexGrid>
      </div>
    </div>
  );
};
