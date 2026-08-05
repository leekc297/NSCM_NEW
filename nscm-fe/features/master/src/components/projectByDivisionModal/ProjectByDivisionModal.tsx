import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

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
  // DMF0020 (2026-06-03): cell dblClick 시 PROJECT_STATUS / BIZ_TYPE_NAME 자동 채움 의무 — optional 추가 인자
  setSelectedValue: (
    projects: string,
    projectsNames?: string,
    projectStatus?: string,
    bizTypeName?: string,
    projectOwner?: string // DMF0003 (2026-07-28): Project Owner 자동 채움 — 미사용 호출부는 무시 → 회귀 0
  ) => void;
  preSearchParams: ProcRequest<MODAL_PROJECT_BY_DIVISION, MODAL_SHEET_PROJECT_BY_DIVISION>;
  // ⭐ 2026-07-03 — cell/Form 호출 모두 동일 5개 조건 표시 + preSearchParams 그대로 사용 (사용자 요구).
  //   prop 은 기존 호출처 하위호환 위해 유지 (동작 분기 없음).
  callFromCell: boolean;
  // ⭐ 멀티 선택 모드(옵션). true 시 체크박스 컬럼으로 선택(재기동 시 carry/프리체크 없음).
  multiCheckbox?: boolean;
}

export const ProjectByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  callFromCell: _callFromCell,
  multiCheckbox = false,
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

  // useMemo — 매 렌더 새 배열이면 그리드 re-bind 로 체크박스 선택(row.isSelected)이 풀림.
  const itemsSource = useMemo(
    () =>
      (projectData?.o_rc1 ?? []).filter(
        project =>
          (project.PROJECT_CODE ?? '').toLowerCase().includes(modalFilters.project.toLowerCase()) ||
          (project.PROJECT_NAME ?? '').toLowerCase().includes(modalFilters.project.toLowerCase())
      ),
    [projectData, modalFilters]
  );

  // 자동필터 해제 — Search 버튼/Enter 시에만 modalFilters 반영 (입력 중 즉시필터 안 함).
  const handleSearch = () => setModalFilters({ project: projectCode ?? '' });

  const handleSubmit = () => {
    if (multiCheckbox) {
      // 체크박스 모드 — 체크된(row.isSelected) 행의 PROJECT_CODE/NAME 수집.
      const grid = gridRef.current;
      if (!grid) return;
      const codes: string[] = [];
      const names: string[] = [];
      for (const row of grid.rows) {
        const it = row?.dataItem as { PROJECT_CODE?: string; PROJECT_NAME?: string } | undefined;
        if (row?.isSelected && it?.PROJECT_CODE) {
          codes.push(it.PROJECT_CODE);
          names.push(it.PROJECT_NAME ?? '');
        }
      }
      setSelectedValue(codes.join(','), names.join(','));
      modalClose();
      return;
    }

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

    setSelectedValue(
      dataItem.PROJECT_CODE,
      dataItem.PROJECT_NAME,
      (dataItem as Record<string, unknown>).PROJECT_STATUS as string | undefined,
      (dataItem as Record<string, unknown>).BIZ_TYPE_NAME as string | undefined,
      (dataItem as Record<string, unknown>).PROJECT_OWNER as string | undefined
    );
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    // ⭐ 2026-07-03 (사용자 요구) — cell 호출도 Form 호출과 동일하게 preSearchParams 를 그대로 사용.
    //   기존 callFromCell 강제 'ALL' 은 그리드 행 값 cascade(hook #59 §5-G — 클릭 행의 상위 셀 값
    //   전달)를 무시하는 문제. cell 호출처는 값 미보유 시 'ALL' 을 명시 전달 (fallback 방어 포함).
    setSearchParam({
      divisionId: preSearchParams.divisionId,
      deptId: preSearchParams.deptId ?? 'ALL',
      endCustomer: preSearchParams.endCustomer ?? 'ALL',
      salesSite: preSearchParams.salesSite ?? 'ALL',
      projectCode: '',
      etc: 'N',
    });
    // 'ALL' sentinel(=projectCode 미선택, orAll 기본값)은 client-side 필터 대상이 아니므로 빈값 처리.
    //   (그대로 두면 PROJECT_CODE/NAME.includes('all') 로 0건 → div 81 등에서 데이터 미표시 버그)
    const initProject =
      (preSearchParams.projectCode ?? '') === 'ALL' ? '' : (preSearchParams.projectCode ?? '');
    setModalFilters({ project: initProject });
    setProjectCode(initProject);
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
                {/* ⭐ 2026-07-03 — cell 호출에서도 Form 호출과 동일하게 5개 조건 표시 (사용자 요구:
                    DMF0020 그리드 Project 팝업 조건 2개 → 조회조건 Project 팝업과 동일 5개). */}
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
                          // ⭐ 2026-07-03 — DEPT 관대 통과(hook #59 §5-G): 콤보 row 의 DEPT_ID 는
                          //   owner 기반(NULL 다수)이라 그리드 팀(SITE_ITEM.DEPT_ID)과 기준이 달라
                          //   엄격 필터 시 선택 값이 옵션에서 탈락 → disabled 표시가 비는 사고.
                          [
                            ...new Map(
                              endCustomers
                                ?.filter(
                                  item =>
                                    item.DIVISION_ID === searchParam.divisionId &&
                                    (searchParam.deptId === 'ALL' ||
                                      !item.DEPT_ID ||
                                      searchParam.deptId?.split(',').includes(item.DEPT_ID) ||
                                      searchParam.endCustomer?.split(',').includes(item.CODE))
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
                          // ⭐ 2026-07-03 — DEPT 관대 통과 + 선택 값 보존 (End Customer 와 동일 사유)
                          ...new Map(
                            (salesSites ?? [])
                              .filter(
                                item =>
                                  item.DIVISION_ID === searchParam.divisionId &&
                                  (searchParam.deptId === 'ALL' ||
                                    !item.DEPT_ID ||
                                    searchParam.deptId?.split(',').includes(item.DEPT_ID) ||
                                    searchParam.salesSite?.split(',').includes(item.CODE))
                              )
                              .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                          ).values(),
                        ].map(item => ({ label: item.NAME, value: item.CODE }))}
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
                        value={projectCode ?? ''}
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
            <DataGrid<ResponseData<MODAL_PROJECT_BY_DIVISION, MODAL_SHEET_PROJECT_BY_DIVISION>>
              gridRef={gridRef}
              isReadOnly
              useCheckbox={multiCheckbox}
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={multiCheckbox ? undefined : handleDblClick}
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
