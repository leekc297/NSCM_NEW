import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { attachRowNoHeader, GridUtils } from '@foundation/utils';
import { CustomDropdown, DataGrid, CustomDialog, ResultArea, SearchArea } from '@shared/components';
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
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const initialized = useProjectModalStore(state => state.initialized);
  const staticColumns = useProjectModalStore(state => state.staticColumns);
  const fetchStaticColumns = useProjectModalStore(state => state.fetchStaticColumns);

  const [searchParam, setSearchParam] = useState<ProcRequest<MODAL_PROJECT, MODAL_SHEET_PROJECT>>(
    {} as ProcRequest<MODAL_PROJECT, MODAL_SHEET_PROJECT>
  );

  const [divisions] = useTabComboQueries({
    filters: ['MyDivision'],
  });

  // useTabProcQuery 는 filters 참조가 바뀌면 캐시를 버리고 재조회한다. 이전엔
  // DEFAULT_FILTER 라는 상수 이름의 객체를 렌더 본문에서 매번 새로 만들어 넘겼는데,
  // searchParam.divisionId 가 그대로여도 다른 이유로 리렌더될 때마다 그리드가
  // 깜빡였다. useMemo 로 참조를 divisionId/projectCode 에 고정한다.
  const filters = useMemo(
    () => ({ divisionId: searchParam.divisionId, projectCode: searchParam.projectCode ?? '' }),
    [searchParam.divisionId, searchParam.projectCode]
  );

  const { data: projectData } = useTabProcQuery<MODAL_PROJECT>({
    menuId: MODAL_PROJECT,
    sheetName: MODAL_SHEET_PROJECT,
    tabId: 'ProjectModal',
    filters,
    enabled: open,
  });

  // COM0012 는 division 과 project 키워드(콤마 다중값, 부분일치) 둘 다 서버에서 필터한다
  //   (PKG_COM0000.P_COM0012_GET_PROJECT_BY_ONLY_DIVISION_POPUP, 2026-09-15 p_project_code
  //   파라미터 추가 + SCM_ADM_PROC_M 메타 등록). 그리드는 응답을 그대로 보여준다.
  const itemsSource = useMemo(() => projectData?.o_rc1 ?? [], [projectData]);

  const [projectInput, setProjectInput] = useState('');

  // 입력값은 제어 컴포넌트로 둔다. modaless 라 닫아도 언마운트되지 않아, defaultValue 로 두면 다시 열 때
  //   초기화 effect 가 state 를 되돌려도 입력창에는 직전 문자가 그대로 남는다.
  // 주의: debounce 금지 - 제어 입력에서 setState 를 늦추면 타이핑이 밀리거나 글자가 유실된다.
  const handleProjectChange = (project: string) => setProjectInput(project);

  const handleSearch = () => setSearchParam(prev => ({ ...prev, projectCode: projectInput.trim() }));

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
    setProjectInput(preProject ?? '');
    setSearchParam({ ...preSearchParams, projectCode: preProject ?? '' });
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, itemsSource]);

  return (
    <CustomDialog
      size={1000}
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
          <h2 className='headerTitle'>{t('LBL00334', '_ProjectPopup')}</h2>
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
                    label={t('LBL00012', '_Project')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={projectInput}
                        onChange={e => handleProjectChange(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <ResultArea
              title=''
              count={itemsSource.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<ResponseData<MODAL_PROJECT, MODAL_SHEET_PROJECT>>
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
