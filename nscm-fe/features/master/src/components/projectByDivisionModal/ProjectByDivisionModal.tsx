import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { CustomDropdown, SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  SEARCH_POPUP_WIDTH,
  buildEndCustomerOptions,
  buildSalesSiteOptions,
} from '../searchFields/SearchFields.utils';

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
    projectOwner?: string, // DMF0003 (2026-07-28): Project Owner 자동 채움 — 미사용 호출부는 무시 → 회귀 0
    // DMF0021 (2026-08-14, 통합테스트 1st No.61-④): Team 자동 채움 — Team 은 입력 불가 컬럼이라
    //   선택한 마스터 행의 팀을 그대로 내려줘야 화면에 표시된다. 미사용 호출부는 무시 → 회귀 0.
    deptId?: string,
    deptName?: string
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

  const [divisions, endCustomers, salesSites] = useTabComboQueries({
    filters: ['MyDivision', 'EndCustomer', 'SalesSite'],
  });

  // Team 콤보는 divisionId 파라미터를 받아야 한다 (SearchFields TeamField 와 같은 계약).
  //   미전달 = 'ALL' 분기라 division 40 의 팀은 아예 반환되지 않는다 (40 은 owner 경로 전용
  //   분기 — 40 SALES 사이트는 DEPT 미배정 설계). 그러면 호출 화면 조회조건에서 넘어온 Team
  //   값이 options 에 없어 selectedOptions 가 비고, CustomDropdown 이 placeholder 'ALL' 만
  //   보여준다 — 값은 전달됐는데 화면만 ALL 로 보이던 원인.
  // 주의: BE makeComboQuery 는 raw 문자열 치환이라 작은따옴표를 포함해 넘긴다.
  // divisionId 가 바뀌면 쿼리키가 바뀌어 자동 재조회된다.
  const [teams] = useTabComboQueries({
    filters: [{ comboId: 'TeambyDivision', divisionId: `'${searchParam.divisionId ?? ''}'` }],
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

  // Search 버튼/Enter = 프로시저 재조회 (사용자 요구 2026-08-11).
  //   구: 입력값을 client-side 필터로만 썼다 → 팝업이 열릴 때 받아 온 행 안에서만 찾을 수 있었고,
  //   그 범위 밖의 Project 는 아무리 검색해도 안 나왔다. 이제 조회 파라미터에 실어 다시 조회한다.
  //   화면 필터도 같은 키워드로 유지 — SP 가 파라미터를 무시하거나 넓게 내려줘도 결과가 좁혀 보인다.
  const handleSearch = () => {
    const keyword = projectCode ?? '';
    setSearchParam(prev => ({ ...prev, projectCode: keyword }));
    setModalFilters({ project: keyword });
  };

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

    const firstSelection = selections[0] as Record<string, unknown> | undefined;
    setSelectedValue(
      selections.map(item => item.PROJECT_CODE).join(','),
      selections.map(item => item.PROJECT_NAME).join(','),
      undefined,
      undefined,
      undefined,
      // 단건 선택일 때만 팀을 넘긴다 — 다건은 어느 팀인지 확정할 수 없다.
      selections.length === 1 ? ((firstSelection?.DEPT_ID as string) ?? undefined) : undefined,
      selections.length === 1 ? ((firstSelection?.DEPT_NAME_KO as string) ?? undefined) : undefined
    );
    modalClose();
  };

  // ⭐ 더블클릭 = 그 행 하나로 확정 후 닫기 (체크박스 모드 포함 — 2026-08-06 사용자 요청).
  //   구: dblClick={multiCheckbox ? undefined : handleDblClick} 로 체크박스 모드에서 핸들러가
  //   미장착이라 더블클릭해도 부모창에 값이 안 넘어갔다 (Owner/Item ByDivision 팝업 동일 조치).
  //   ⚠ 체크박스 모드에서 더블클릭하면 체크해 둔 행들은 무시되고 더블클릭한 행만 전달된다
  //     (여러 건은 체크 후 OK). 단건 선택의 빠른 경로 규약.
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
      (dataItem as Record<string, unknown>).PROJECT_OWNER as string | undefined,
      (dataItem as Record<string, unknown>).DEPT_ID as string | undefined,
      (dataItem as Record<string, unknown>).DEPT_NAME_KO as string | undefined
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
      // ⭐ 1000 → SEARCH_POPUP_WIDTH(900) — Owner/Model 팝업과 폭 통일 (2026-08-06 사용자 요청)
      size={SEARCH_POPUP_WIDTH}
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
                              // DIVISION_ID 가 공란인 행은 통과시킨다 (SearchFields toOptions 와
                              // 동일 규칙). 엄격 비교만 하면 division 키를 안 채워 주는 응답에서
                              // 목록이 통째로 비어버린다.
                              .filter(
                                item =>
                                  !searchParam.divisionId ||
                                  !item.DIVISION_ID ||
                                  item.DIVISION_ID === searchParam.divisionId
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
                    label={t('LBL00080', '_End Customer')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        disabled
                        limitTags={1}
                        value={searchParam.endCustomer}
                        options={buildEndCustomerOptions({
                          rows: endCustomers,
                          divisionId: searchParam.divisionId,
                          deptId: searchParam.deptId,
                          selected: searchParam.endCustomer,
                        })}
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
                        options={buildSalesSiteOptions({
                          rows: salesSites,
                          divisionId: searchParam.divisionId,
                          deptId: searchParam.deptId,
                          selected: searchParam.salesSite,
                        })}
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
