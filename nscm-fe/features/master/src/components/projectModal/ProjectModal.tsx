import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useRef, useState } from 'react';

import _ from '@foundation/lodash';
import { GridUtils } from '@foundation/utils';
import { CustomDropdown, DataGrid, CustomDialog, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { MODAL_PROJECT, MODAL_SHEET_PROJECT } from './project-modal-constants';
import styles from './ProjectModal.module.scss';
import { useProjectModalStore } from './projectModalStore';

interface ProjectModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (projects: string, projectsNames?: string) => void;
  preSearchParams: ProcRequest<MODAL_PROJECT, MODAL_SHEET_PROJECT>;
  preProject: string;
}

export const ProjectModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  preProject,
}: ProjectModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<MODAL_PROJECT, MODAL_SHEET_PROJECT>>>();

  const initialized = useProjectModalStore(state => state.initialized);
  const staticColumns = useProjectModalStore(state => state.staticColumns);
  const fetchStaticColumns = useProjectModalStore(state => state.fetchStaticColumns);

  const [searchParam, setSearchParam] = useState<ProcRequest<MODAL_PROJECT, MODAL_SHEET_PROJECT>>(
    {} as ProcRequest<MODAL_PROJECT, MODAL_SHEET_PROJECT>
  );

  const [divisions] = useTabComboQueries({
    filters: ['MyDivision'],
  });

  const DEFAULT_FILTER = {
    divisionId: searchParam.divisionId,
  };

  const { data: projectData } = useTabProcQuery<MODAL_PROJECT>({
    menuId: MODAL_PROJECT,
    sheetName: MODAL_SHEET_PROJECT,
    tabId: 'ProjectModal',
    filters: DEFAULT_FILTER,
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
      MODAL_PROJECT,
      MODAL_SHEET_PROJECT
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
    setModalFilters({ project: preProject ?? '' });
    setSearchParam(preSearchParams);
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
          <h2 className='headerTitle'>{t('LBL00334', '_ProjectPopup')}</h2>
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
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00327', '_Project')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        defaultValue={preProject ?? ''}
                        onChange={e => handleProjectChange(e.target.value)}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<MODAL_PROJECT, MODAL_SHEET_PROJECT>>
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
