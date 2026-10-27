import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { attachRowNoHeader, GridUtils } from '@foundation/utils';
import { CustomDialog, SearchArea, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
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
  // 조회 division (COM0009 P_DIVISION_ID). 미전달 시 빈 값 = 전체(기존 호출처 영향 없음).
  divisionId?: string;
}

export const TeamModal = ({
  open,
  modalClose,
  setSelectedValue,
  teamId = '',
  teamName = '',
  divisionId = '',
}: TeamModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<MODAL_TEAM, MODAL_SHEET_TEAM, 'o_rc1'>>>();
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const initialized = useTeamModalStore(state => state.initialized);
  const staticColumns = useTeamModalStore(state => state.staticColumns);
  const fetchStaticColumns = useTeamModalStore(state => state.fetchStaticColumns);

  // Team ID/Name 을 하나의 'Team' 검색으로 통합했다. 서버(COM0009)에는 빈 파라미터로 전체 팀
  //   목록을 1회 받아오고(teamId/teamName 은 서버에서 AND 라 단일값 OR 검색이 불가), ID/이름
  //   매칭은 화면에서 OR 필터한다(MessageModal 과 동일한 클라이언트 필터 방식).
  const [teamInput, setTeamInput] = useState<string>(teamId || teamName); // 입력 중인 값
  const [appliedTerm, setAppliedTerm] = useState<string>(teamId || teamName); // 실제 적용된 필터어

  // teamId/teamName 은 화면에서 OR 필터하므로 서버엔 빈 값으로 보내고, divisionId 만 SP 조회조건이다.
  //   filters 는 useTabProcQuery 의 query key 라 divisionId 가 바뀌면 재조회된다 — 참조 고정용 useMemo.
  const filters = useMemo(
    () => ({ teamId: '', teamName: '', divisionId }),
    [divisionId]
  );

  const {
    data: teamData,
    isLoading,
    isFetching,
  } = useTabProcQuery<MODAL_TEAM>({
    menuId: MODAL_TEAM,
    sheetName: MODAL_SHEET_TEAM,
    tabId: 'TeamModal',
    filters,
    enabled: true,
  });
  const loading = isLoading || isFetching;

  // 단일 'Team' 검색 — 서버가 준 전체 목록에서 TEAM_ID 또는 TEAM_NAME_KO(그리드 표시값)에
  //   검색어가 포함되면 매칭한다(대소문자 무시). 서버 결과셋에 이름은 KO 만 내려온다.
  //   useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 스크롤·선택이 초기화된다.
  const itemsSource = useMemo(() => {
    const rows = teamData?.o_rc1 ?? [];
    const term = appliedTerm.trim().toLowerCase();
    if (!term) return rows;
    return rows.filter(
      row =>
        (row.TEAM_ID ?? '').toLowerCase().includes(term) ||
        (row.TEAM_NAME_KO ?? '').toLowerCase().includes(term)
    );
  }, [teamData, appliedTerm]);

  const handleSearch = () => {
    setAppliedTerm(teamInput.trim());
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

  const handleSubmit = () => {
    const selections = gridRef.current?.selectedItems as ResponseData<
      MODAL_TEAM,
      MODAL_SHEET_TEAM,
      'o_rc1'
    >[];
    if (!selections?.length) return;

    setSelectedValue(selections[0].TEAM_ID, selections[0].TEAM_NAME_KO);
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    const seed = teamId || teamName;
    setTeamInput(seed);
    setAppliedTerm(seed);
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, itemsSource]);

  return (
    <CustomDialog
      size={800}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
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
              <Grid size={6}>
                <FormItem
                  label={t('LBL00044', 'Team')}
                  labelAlign='right'
                  render={() => (
                    <InputField
                      fullWidth
                      value={teamInput}
                      onChange={e => setTeamInput(e.target.value)}
                      onKeyDown={e => e.key === 'Enter' && handleSearch()}
                    />
                  )}
                />
              </Grid>
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea
              title=''
              count={itemsSource.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<ResponseData<MODAL_TEAM, MODAL_SHEET_TEAM, 'o_rc1'>>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                staticColumns={staticColumns}
                itemsSource={itemsSource}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleSubmit}
            />
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
