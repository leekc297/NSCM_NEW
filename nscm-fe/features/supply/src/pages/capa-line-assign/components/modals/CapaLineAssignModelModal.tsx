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
  sheet: SHEETS.SOP_MODEL_ASSEMBLY | SHEETS.SOP_MODEL_ELTR;
  tabId: string;
  divisionId: string;
  verId: string;
  verSeq: string;
  onClose: () => void;
  onConfirm: (rows: GridRow[]) => void;
}

const isChecked = (row: GridRow): boolean => row[COLUMN.CHK] === true || row[COLUMN.CHK] === 'Y';

/**
 * P02 CAPA Line Assign Model 팝업 (AS-IS `SCP0104_CAPA_Line_Assign_Model`,
 * 시트 `SOP_MODEL_ASSEMBLY` | `SOP_MODEL_ELTR` 19컬럼).
 *
 * 선택 다건 → SOP 그리드 행 추가. 중복키는 8키(Division+Site+Company+Plant+Factory+Line+
 * Operation+ElectrodeType)로 부모가 판정한다(§3.5.1).
 *
 * 주의(§6-5, U-9 = AS-IS 원문 유지): SP 가 `@p_version`/`@p_version_seq` 를 **무시**하고 내부
 * `PROG_STAT='0'`(Current) MAX 버전을 쓴다. 조회조건이 Cutoff 버전이면 팝업 목록이 Current 기준이
 * 되는데, 이는 AS-IS 사양이므로 그대로 재현한다(파라미터는 계약대로 실어 보낸다).
 */
export const CapaLineAssignModelModal = ({
  open,
  sheet,
  tabId,
  divisionId,
  verId,
  verSeq,
  onClose,
  onConfirm,
}: Props) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const staticColumns = useCapaLineAssignStore(s => s.staticColumns);

  const [lineId, setLineId] = useState('');
  const [operationId, setOperationId] = useState('');
  type SopModelFilters = ProcRequest<MENU_ID, SHEETS.SOP_MODEL_ASSEMBLY>;
  const [applied, setApplied] = useState<SopModelFilters | null>(null);

  const buildFilters = (line: string, operation: string): SopModelFilters => ({
    p_version: verId,
    p_version_seq: verSeq,
    p_division_id: divisionId,
    p_site_id: '',
    p_plant_id: '',
    p_factory_id: '',
    p_line_id: line,
    p_operation_id: operation,
    p_electrode_type: '',
    p_valid_flag: '',
    p_program_id: MENU_ID,
    p_sheet_name: ADMIN_SHEET_NAME[sheet],
    debug_mode: 'F',
  });

  const filters = useMemo(() => {
    if (!open) return undefined;
    // AS-IS 파리티(#7): 오픈만으로는 조회하지 않는다 — Search(FindButton) 를 눌러 `applied` 가
    // 세팅될 때만 조회한다. AS-IS `SCP0104_CAPA_Line_Assign_Model` 은 Form Load 자동조회가 없고
    // 툴바 Search 로만 질의한다.
    return applied ?? undefined;
  }, [open, applied]);

  const { data, isLoading, isFetching } = useTabProcQuery<
    MENU_ID,
    SHEETS.SOP_MODEL_ASSEMBLY | SHEETS.SOP_MODEL_ELTR
  >({
    menuId: MENU_ID,
    sheetName: sheet,
    tabId: `${tabId}-capa-sop-model`,
    filters,
    enabled: open && !!filters,
  });

  const rows = useMemo<GridRow[]>(() => (data?.o_rc1 ?? []) as unknown as GridRow[], [data]);

  const handleSearch = () => setApplied(buildFilters(lineId, operationId));

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
          <h2 className='headerTitle'>CAPA Line Assign Model</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_POPUP, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                {textCondition(LBL.LINE, 'Line', lineId, setLineId)}
                {textCondition(LBL.OPERATION, 'Operation', operationId, setOperationId)}
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
