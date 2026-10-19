import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

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

  // 실제 조회 조건 — Search 버튼/Enter(그리고 팝업 오픈) 시에만 갱신되고, 그때 프로시저를 재호출한다.
  //   (useTabProcQuery 는 filters 가 query key 라 값이 바뀌면 재조회. COM0009 는 teamId/teamName 을
  //   IN 파라미터로 받는다 — configs/types/procedures.d.ts COM0009.team.request 참고)
  const [searchParam, setSearchParam] = useState<{
    teamId: string;
    teamName: string;
  }>(EMPTY_FILTER);

  // 입력 중인 값 — 조회하지 않고 로컬 state 에만 담아둔다.
  const [teamIdInput, setTeamIdInput] = useState<string>(teamId);
  const [teamNameInput, setTeamNameInput] = useState<string>(teamName);

  const { data: teamData } = useTabProcQuery<MODAL_TEAM>({
    menuId: MODAL_TEAM,
    sheetName: MODAL_SHEET_TEAM,
    tabId: 'TeamModal',
    filters: searchParam,
    enabled: true,
  });

  // 필터링은 프로시저(teamId/teamName 파라미터)가 하고, 그리드는 조회 결과를 그대로 보여준다.
  //   useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 스크롤·선택이 초기화된다.
  const itemsSource = useMemo(() => teamData?.o_rc1 ?? [], [teamData]);

  const handleSearch = () => {
    setSearchParam({
      teamId: teamIdInput,
      teamName: teamNameInput,
    });
  };

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
    setSearchParam({
      teamId: teamId,
      teamName: teamName,
    });
    setTeamIdInput(teamId);
    setTeamNameInput(teamName);
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
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00329', '_Team ID')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={teamIdInput}
                        onChange={e => setTeamIdInput(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
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
                        value={teamNameInput}
                        onChange={e => setTeamNameInput(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
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
