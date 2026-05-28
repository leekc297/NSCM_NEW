import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useRef, useState } from 'react';

import _ from '@foundation/lodash';
import { GridUtils } from '@foundation/utils';
import { CustomDropdown, SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  MODAL_PROJECT_BY_DIVISION,
  MODAL_SHEET_PROJECT_BY_DIVISION,
} from './project-by-division-modal.constants';
import styles from './ProjectByDivisionModal.module.scss';
import { useProjectByDivisionModalStore } from './projectByDivisionModalStore';

interface ProjectByDivisionModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (projects: string, projectsNames?: string) => void;
  preSearchParams: ProcRequest<MODAL_PROJECT_BY_DIVISION, MODAL_SHEET_PROJECT_BY_DIVISION>;
  callFromCell: boolean;
}

export const ProjectByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  callFromCell,
}: ProjectByDivisionModalProps) => {
  const { t } = useTranslation();

  const gridRef =
    useRef<FlexGrid<ResponseData<MODAL_PROJECT_BY_DIVISION, MODAL_SHEET_PROJECT_BY_DIVISION>>>();

  const initialized = useProjectByDivisionModalStore(state => state.initialized);
  const staticColumns = useProjectByDivisionModalStore(state => state.staticColumns);
  const fetchStaticColumns = useProjectByDivisionModalStore(state => state.fetchStaticColumns);

  const [searchParam, setSearchParam] = useState<
    ProcRequest<MODAL_PROJECT_BY_DIVISION, MODAL_SHEET_PROJECT_BY_DIVISION>
  >({} as ProcRequest<MODAL_PROJECT_BY_DIVISION, MODAL_SHEET_PROJECT_BY_DIVISION>);
  const [projectCode, setProjectCode] = useState<string>();

  const [divisions, teams, endCustomers, salesSites] = useTabComboQueries({
    filters: ['MyDivision', 'TeambyDivision', 'EndCustomer', 'SalesSite'],
  });

  const { data: projectData } = useTabProcQuery<MODAL_PROJECT_BY_DIVISION>({
    menuId: MODAL_PROJECT_BY_DIVISION,
    sheetName: MODAL_SHEET_PROJECT_BY_DIVISION,
    tabId: 'ProjectByDivisionModal',
    filters: searchParam,
    enabled: open,
  });

  const [modalFilters, setModalFilters] = useState<{
    project: string;
  }>({ project: '' });

  const itemsSource = (projectData?.o_rc1 ?? []).filter(
    project =>
      (project.PROJECT_CODE ?? '').toLowerCase().includes(modalFilters.project.toLowerCase()) ||
      (project.PROJECT_NAME ?? '').toLowerCase().includes(modalFilters.project.toLowerCase())
  );

  const handleProjectChange = _.debounce((project: string) => {
    setModalFilters({
      project: project,
    });
  }, 50);

  const handleSubmit = () => {
    const selections = gridRef.current?.selectedItems as ResponseData<
      MODAL_PROJECT_BY_DIVISION,
      MODAL_SHEET_PROJECT_BY_DIVISION
    >[];

    if (!selections) return;

    setSelectedValue(
      selections.map(item => item.PROJECT_CODE).join(','),
      selections.map(item => item.PROJECT_NAME).join(',')
    );
    modalClose();
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    setSelectedValue(dataItem.PROJECT_CODE, dataItem.PROJECT_NAME);
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setSearchParam({
      divisionId: preSearchParams.divisionId,
      deptId: callFromCell ? 'ALL' : preSearchParams.deptId,
      endCustomer: callFromCell ? 'ALL' : preSearchParams.endCustomer,
      salesSite: callFromCell ? 'ALL' : preSearchParams.salesSite,
      projectCode: '',
      etc: 'N',
    });
    setModalFilters({ project: preSearchParams.projectCode ?? '' });
    setProjectCode(preSearchParams.projectCode);
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00334', '_ProjectByDivisionPopup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00001', '_Div.')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        mandatory
                        disabled
                        value={searchParam?.divisionId ?? ''}
                        options={
                          divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                        }
                      />
                    )}
                  />
                </Grid>
                {!callFromCell && (
                  <>
                    <Grid size={4}>
                      <FormItem
                        label={t('LBL00044', '_Team')}
                        labelAlign='right'
                        render={() => (
                          <CustomDropdown
                            mandatory
                            multiple
                            disabled
                            limitTags={1}
                            value={searchParam.deptId}
                            options={[
                              ...new Map(
                                (teams ?? [])
                                  .filter(item => item.DIVISION_ID === searchParam.divisionId)
                                  .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                              ).values(),
                            ].map(item => ({ label: item.NAME, value: item.CODE }))}
                          />
                        )}
                      />
                    </Grid>
                    <Grid size={4}>
                      <FormItem
                        label={t('LBL00080', '_End Customer')}
                        labelAlign='right'
                        render={() => (
                          <CustomDropdown
                            multiple
                            disabled
                            limitTags={1}
                            value={searchParam.endCustomer}
                            options={
                              [
                                ...new Map(
                                  endCustomers
                                    ?.filter(
                                      item =>
                                        item.DIVISION_ID === searchParam.divisionId &&
                                        (searchParam.deptId === 'ALL' ||
                                          searchParam.deptId?.split(',').includes(item.DEPT_ID))
                                    )
                                    .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                                ).values(),
                              ].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                            }
                          />
                        )}
                      />
                    </Grid>
                    <Grid size={4}>
                      <FormItem
                        label={t('LBL00011', '_Sales Site')}
                        labelAlign='right'
                        render={() => (
                          <CustomDropdown
                            multiple
                            disabled
                            limitTags={1}
                            value={searchParam.salesSite}
                            options={[
                              ...new Map(
                                (salesSites ?? [])
                                  .filter(
                                    item =>
                                      item.DIVISION_ID === searchParam.divisionId &&
                                      (searchParam.deptId === 'ALL' ||
                                        searchParam.deptId?.split(',').includes(item.DEPT_ID))
                                  )
                                  .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                              ).values(),
                            ].map(item => ({ label: item.NAME, value: item.CODE }))}
                          />
                        )}
                      />
                    </Grid>
                  </>
                )}
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00327', '_Project')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={projectCode ?? ''}
                        onChange={e => {
                          setProjectCode(e.target.value);
                          handleProjectChange(e.target.value);
                        }}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<MODAL_PROJECT_BY_DIVISION, MODAL_SHEET_PROJECT_BY_DIVISION>>
              gridRef={gridRef}
              isReadOnly
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={handleDblClick}
            />
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
            <Button
              appearance='contained'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleSubmit}
            />
          </div>
        </div>
      }
    />
  );
};
