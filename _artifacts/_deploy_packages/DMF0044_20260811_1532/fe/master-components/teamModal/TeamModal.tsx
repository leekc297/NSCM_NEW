import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useRef, useState } from 'react';

import _ from '@foundation/lodash';
import { GridUtils } from '@foundation/utils';
import { CustomDialog, SearchArea, DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { MODAL_SHEET_TEAM, MODAL_TEAM } from './team-modal.constants';
import styles from './TeamModal.module.scss';
import { useTeamModalStore } from './teamModalStore';

interface TeamModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (teamId: string, teamName?: string) => void;
  teamId?: string;
  teamName?: string;
}

const EMPTY_FILTER = { teamId: '', teamName: '' };

export const TeamModal = ({
  open,
  modalClose,
  setSelectedValue,
  teamId = '',
  teamName = '',
}: TeamModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<MODAL_TEAM, MODAL_SHEET_TEAM, 'o_rc1'>>>();

  const initialized = useTeamModalStore(state => state.initialized);
  const staticColumns = useTeamModalStore(state => state.staticColumns);
  const fetchStaticColumns = useTeamModalStore(state => state.fetchStaticColumns);

  const [modalFilters, setModalFilters] = useState<{
    teamId: string;
    teamName: string;
  }>(EMPTY_FILTER);

  const { data: teamData } = useTabProcQuery<MODAL_TEAM>({
    menuId: MODAL_TEAM,
    sheetName: MODAL_SHEET_TEAM,
    tabId: 'TeamModal',
    filters: EMPTY_FILTER,
    enabled: true,
  });

  const itemsSource = (teamData?.o_rc1 ?? []).filter(
    team =>
      (team.TEAM_ID ?? '').toLowerCase().includes(modalFilters.teamId.toLowerCase()) &&
      (team.TEAM_NAME_KO ?? '').toLowerCase().includes(modalFilters.teamName.toLowerCase())
  );

  const handleFilterhange = _.debounce((teamId: string, teamName: string) => {
    setModalFilters({
      teamId: teamId,
      teamName: teamName,
    });
  }, 50);

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(gridRef.current, ht.row);
    if (!dataItem) return;

    setSelectedValue(dataItem.TEAM_ID, dataItem.TEAM_NAME_KO);
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setModalFilters({
      teamId: teamId,
      teamName: teamName,
    });
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  return (
    <CustomDialog
      size={800}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00333', '_TeamPopup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00329', '_Team ID')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        defaultValue={teamId}
                        onChange={e => handleFilterhange(e.target.value, modalFilters.teamName)}
                      />
                    )}
                  />
                </Grid>

                <Grid size={4}>
                  <FormItem
                    label={t('LBL00328', '_Team Name')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        defaultValue={teamName}
                        onChange={e => handleFilterhange(modalFilters.teamId, e.target.value)}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<MODAL_TEAM, MODAL_SHEET_TEAM, 'o_rc1'>>
              gridRef={gridRef}
              isReadOnly
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={handleDblClick}
            />
          </div>
        </div>
      }
    />
  );
};
