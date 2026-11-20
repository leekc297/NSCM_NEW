/**
 * Project by Division 팝업 (공통 base) — AS-IS GSCM.SCM.Popup.UIL.SCM0002_ProjectbyDivisionPopup(base).
 *
 * SCP0009(Shipment_Plan_FG) 의 Project 필드(btnProject)가 여는 팝업(프1). 공통 COM0005(master
 * ProjectByDivisionModal)는 Ex 버전이라 별개 — 이건 base(SCM0002 고유)다. 모1(ModelPopup)과 동일 방식.
 *
 * AS-IS 계약(SCP0009):
 *  - Form_Load(true, division, project) → Division 비활성 표시, Project 입력.
 *  - 반환: ProjectCode → txtProject
 *
 * TO-BE(실측 2026-09-16):
 *  - menuId=SCM0002 / sheet=ProjectByDivPopup → PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIVISION_POPUP
 *  - 필터: division 은 'ALL' 센티널, project 는 LIKE. 그리드 컬럼은 admin 메타(9컬럼).
 */
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils, withRowNo } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';

import styles from './ProjectByDivisionPopup.module.scss';
import { useProjectByDivisionPopupStore } from './projectByDivisionPopupStore';

const PROJ_MENU = 'SCM0002';
const PROJ_SHEET = 'ProjectByDivPopup';

type ProjRow = ResponseData<typeof PROJ_MENU, typeof PROJ_SHEET, 'o_rc1'>;
type ProjFilters = ProcRequest<typeof PROJ_MENU, typeof PROJ_SHEET>;

export interface ProjectByDivisionPopupParams {
  divisionId?: string;
  projectCode?: string;
}

export interface ProjectByDivisionSelection {
  projectCode: string;
  projectName?: string;
  projectStatus?: string;
  bizType?: string;
  currency?: string;
  projectVerSeq?: string;
  projectOwner?: string;
}

interface ProjectByDivisionPopupProps {
  open: boolean;
  onClose: () => void;
  onSelect?: (selected: ProjectByDivisionSelection) => void;
  params?: ProjectByDivisionPopupParams;
}

export const ProjectByDivisionPopup = ({
  open,
  onClose,
  onSelect,
  params,
}: ProjectByDivisionPopupProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ProjRow>>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  // 그리드 컬럼은 admin 메타(SCM0002/ProjectByDivPopup)에서 가져온다.
  const initialized = useProjectByDivisionPopupStore(state => state.initialized);
  const staticColumns = useProjectByDivisionPopupStore(state => state.staticColumns);
  const fetchStaticColumns = useProjectByDivisionPopupStore(state => state.fetchStaticColumns);

  const [projectCode, setProjectCode] = useState('');
  const [searchParam, setSearchParam] = useState<ProjFilters>({} as ProjFilters);

  // Division 콤보 — AS-IS 와 동일 소스(SCM0001_GET_DIVISION). 표시용(parent 값 선택), 비활성.
  const [divisions] = useTabComboQueries({ filters: [{ comboId: 'SCM0001_GET_DIVISION' }] });

  useEffect(() => {
    if (!open) return;
    setSearchParam({
      divisionId: params?.divisionId || 'ALL',
      projectCode: params?.projectCode ?? '',
    });
    setProjectCode(params?.projectCode ?? '');
    if (!initialized) void fetchStaticColumns();
    // 열릴 때만 초기화한다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const {
    data,
    isLoading,
    isFetching,
  } = useTabProcQuery<typeof PROJ_MENU, typeof PROJ_SHEET>({
    menuId: PROJ_MENU,
    sheetName: PROJ_SHEET,
    tabId: 'ProjectByDivisionPopup',
    filters: searchParam,
    enabled: open,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo(data?.o_rc1 ?? []), [data]);

  const handleSearch = () => setSearchParam(prev => ({ ...prev, projectCode }));

  const confirm = (row: ProjRow) => {
    onSelect?.({
      projectCode: String(row.PROJECT_CODE ?? ''),
      projectName: String(row.PROJECT_NAME ?? ''),
      projectStatus: String(row.PROJECT_STATUS ?? ''),
      bizType: String(row.BIZ_TYPE ?? ''),
      currency: String(row.CURRENCY ?? ''),
      projectVerSeq: String(row.PROJECT_VER_SEQ ?? ''),
      projectOwner: String(row.PROJECT_OWNER ?? ''),
    });
    onClose();
  };

  const handleSubmit = () => {
    const selected = gridRef.current?.selectedItems?.[0] as ProjRow | undefined;
    if (!selected) return;
    confirm(selected);
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(grid, ht.row);
    if (row) confirm(row);
  };

  return (
    <CustomDialog
      size={900}
      type='modaless'
      position='basic'
      open={open}
      handleClose={onClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Project by Division</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00001', 'Div')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        disabled
                        value={params?.divisionId ?? ''}
                        options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00617', 'Project')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={projectCode}
                        onChange={e => setProjectCode(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
                      />
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
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<ProjRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                staticColumns={staticColumns}
                itemsSource={rows}
                dblClick={handleDblClick}
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
