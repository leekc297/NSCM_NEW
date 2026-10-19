import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';

import type { SHEETS } from '../../capa-line-assign.constants';
import { ADMIN_SHEET_NAME, COLUMN, LBL, MENU_ID } from '../../capa-line-assign.constants';
import type { GridRow } from '../../capa-line-assign.types';
import { useCapaLineAssignStore } from '../../useCapaLineAssignStore';

import styles from './CapaLineAssignModals.module.scss';

interface Props {
  open: boolean;
  /** `divisionType` 파생 — SP 가 갈린다(`..._GET_CAPA_LINE_{ASSEMBLY|ELTR}`). */
  sheet: SHEETS.LINE_ASSEMBLY | SHEETS.LINE_ELTR;
  tabId: string;
  divisionId: string;
  onClose: () => void;
  onConfirm: (rows: GridRow[]) => void;
}

const isChecked = (row: GridRow): boolean => row[COLUMN.CHK] === true || row[COLUMN.CHK] === 'Y';

/**
 * P03 CAPA Line 팝업 (AS-IS `SCP0104_CAPA_Line`, 시트 `LINE` 14컬럼).
 *
 * 부모 화면이 DataTable 8개를 주입하던 AS-IS 와 달리 팝업이 자체 조회한다(design 03 §5.7).
 * 선택 다건 → 부모 Assign 그리드에 행 추가. **중복키(Division+Site+Company+Plant+Factory+Line
 * 6키) 행은 부모가 건너뛴다**(§3.5.1) — 이 컴포넌트는 선택 행을 그대로 돌려준다.
 *
 * `CHK` 외 전 셀 읽기전용(`ReadOnlySheetList`, E-8) — `isReadOnly` 대신 `CHK` 만 편집 가능하게
 * 두어야 체크가 먹는다. `CHK` 의 편집 허용은 컬럼 메타(`INPUT_TP_CD`) 정정분이 담당한다.
 *
 * 재오픈 시 검색조건을 유지한다(CommonCheckList 팝업 §"재오픈 시 검색조건 유지") — open 을
 * 초기화 트리거로 쓰지 않고 로컬 state 를 그대로 둔다.
 */
export const CapaLineModal = ({ open, sheet, tabId, divisionId, onClose, onConfirm }: Props) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const staticColumns = useCapaLineAssignStore(s => s.staticColumns);

  // 팝업 로컬 조회조건 — 콤마 다중검색(SP 가 `IN (STRING_SPLIT(...))` 으로 파싱한다).
  const [siteId, setSiteId] = useState('');
  const [plantId, setPlantId] = useState('');
  const [factoryId, setFactoryId] = useState('');
  const [lineId, setLineId] = useState('');
  type LineFilters = ProcRequest<MENU_ID, SHEETS.LINE_ASSEMBLY>;
  const [applied, setApplied] = useState<LineFilters | null>(null);

  const buildFilters = (
    site: string,
    plant: string,
    factory: string,
    line: string
  ): LineFilters => ({
    p_division_id: divisionId,
    p_site_id: site,
    p_plant_id: plant,
    p_factory_id: factory,
    p_line_id: line,
    p_program_id: MENU_ID,
    p_sheet_name: ADMIN_SHEET_NAME[sheet],
    debug_mode: 'F',
  });

  const filters = useMemo(() => {
    if (!open) return undefined;
    return applied ?? buildFilters('', '', '', '');
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, applied, divisionId, sheet]);

  const { data, isLoading, isFetching } = useTabProcQuery<
    MENU_ID,
    SHEETS.LINE_ASSEMBLY | SHEETS.LINE_ELTR
  >({
    menuId: MENU_ID,
    sheetName: sheet,
    tabId: `${tabId}-capa-line`,
    filters,
    enabled: open && !!filters,
  });

  const rows = useMemo<GridRow[]>(() => (data?.o_rc1 ?? []) as unknown as GridRow[], [data]);

  const handleSearch = () => setApplied(buildFilters(siteId, plantId, factoryId, lineId));

  const handleSubmit = () => {
    const checked = rows.filter(isChecked);
    if (checked.length === 0) return;
    onConfirm(checked);
    onClose();
  };

  const textCondition = (
    labelCode: string,
    labelEn: string,
    value: string,
    onChange: (next: string) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, { defaultValue: labelEn })}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            value={value}
            onChange={event => onChange(event.target.value)}
            onKeyDown={event => event.key === 'Enter' && handleSearch()}
          />
        )}
      />
    </Grid>
  );

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={onClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>CAPA Line</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_POPUP, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                {textCondition(LBL.SITE, 'Site', siteId, setSiteId)}
                {textCondition(LBL.PLANT, 'Plant', plantId, setPlantId)}
                {textCondition(LBL.BUILDING, 'Building', factoryId, setFactoryId)}
                {textCondition(LBL.LINE, 'Line', lineId, setLineId)}
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={isLoading || isFetching}
              placement='parent'
            />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                itemsSource={rows as unknown as WijmoRowItem[]}
                staticColumns={staticColumns[sheet]}
                sheetName={ADMIN_SHEET_NAME[sheet]}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              onClick={handleSubmit}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
