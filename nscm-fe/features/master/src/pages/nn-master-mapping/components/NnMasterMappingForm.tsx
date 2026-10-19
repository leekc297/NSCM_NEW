import { useEffect, useMemo, useState } from 'react';

import { apiClient } from '@foundation/apis';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import {
  ItemByDivisionModal,
  ProjectByDivisionModal,
  buildComboOptions,
  toSelectedCodes,
} from '../../../components';
import { MENU_ID, SHEETS } from '../nn-master-mapping.constants';
import type { SearchCondition } from '../nn-master-mapping.types';
import { useNnMasterMappingStore } from '../useNnMasterMappingStore';
import {
  SEARCH_COMBO,
  buildEndCustomerComboParam,
  isRequeryTrigger,
  buildSalesSiteComboParam,
} from '../utils/searchCombos';

interface Props {
  onSearch: () => void;
}

// AS-IS DMF0072_NNMasterMapping.cs 조회조건 7 컨트롤 1:1 매핑:
//   DataType (L200) / Division (L154) / Team (L159) / EndCustomer (L165~178) /
//   Project (L457 popup) / Item (L458 popup) / SalesSite (L186)
// 패턴 원천: features/master/src/pages/contribute-view/components/ContributeViewForm.tsx (DMF0043_01)
export const NnMasterMappingForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const sc = useNnMasterMappingStore(s => s.searchCondition);
  const set = useNnMasterMappingStore(s => s.setSearchCondition);
  const comboTrigger = useNnMasterMappingStore(s => s.comboTrigger);
  const noFilters = useNnMasterMappingStore(s => s.noFilters);

  // Division 변경은 그리드를 비운다(NnMasterMapping.tsx division 변경 effect + store 가 filters 초기화).
  //   편집중(dirty)이면 MSG00704 confirm 후에만 바꾼다 — 조회 공통 가드 confirmIfDirtyKey(..., 'search')를
  //   콤보 변경에도 동일 적용. controlled 콤보라 취소 시 자동 복귀.
  const tabId = useTabid();

  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);

  // 화면 진입 시 저장된 검색조건 복원 (As-Is Condition 기능 — contribute-view 동일 패턴)
  //   Condition 버튼이 저장한 {paramNm, paramCtn} 들을 searchCondition 으로 셋팅. (자동조회는 하지 않음 — 사용자 Search)
  useEffect(() => {
    void apiClient
      .get<
        { paramNm: keyof SearchCondition; paramCtn: string }[]
      >(`/admin/menu/${MENU_ID}/search-conditions`)
      .then(res => {
        if (res.data.result?.length > 0) {
          const saved = res.data.result.reduce(
            (acc, curr) => {
              acc[curr.paramNm] = curr.paramCtn;
              return acc;
            },
            {} as Partial<Record<keyof SearchCondition, string>>
          );
          set(saved as Partial<SearchCondition>);
        }
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const { data: dtData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.DATA_TYPE,
    tabId: MENU_ID,
    filters: noFilters,
    enabled: true,
  });

  /**
   * 조회조건 콤보 (Doc/Combo/DMF0072_콤보구성.md §1).
   *
   * Division 과 Team 은 필터, End Customer 와 Sales Site 는 재조회다. 원천과 파라미터 규칙은
   * utils/searchCombos 참조.
   */
  const [divisions, teams] = useTabComboQueries({
    filters: [SEARCH_COMBO.division, SEARCH_COMBO.team],
  });

  // 이번에 부를 1건만 조립해 넘기므로 반대편 원천은 호출되지 않는다. 파라미터가 키에 실리는
  //   재조회 경로는 값이 바뀌면 자동으로 다시 조회된다.
  const [endCustomers] = useTabComboQueries({
    filters: [buildEndCustomerComboParam(comboTrigger, sc)],
  });
  const [salesSites] = useTabComboQueries({
    filters: [buildSalesSiteComboParam(comboTrigger, sc)],
  });

  const teamOptions = buildComboOptions(teams, { division: sc.divisionId });

  /**
   * 좁히기는 필터 경로에서만 한다.
   *
   * 필수: 재조회 경로에는 축을 하나도 걸지 않는다. 그 응답은 서버가 이미 좁혀서 CODE / NAME
   * 만 내려주므로 DIVISION_ID 조차 없다. 축을 걸면 엄격 매칭에서 전 행이 잘려 목록이 통째로
   * 빈다 - 값은 내려오는데 옵션이 0건이 되는 함정이다.
   *
   * Sales Site 는 필터 경로에서도 팀을 걸지 않는다(AS-IS :186 · :1406 · :1427 이 팀 자리를
   * 비운다). 대신 End Customer 미선택은 그 시점 End Customer 목록 전체로 펼친다 - AS-IS
   * CString.GetCheckedListValue 재현이며, 이 경로로 Team 이 Sales Site 까지 반영된다.
   */
  const isRequery = isRequeryTrigger(comboTrigger);
  const endCustomerOptions = isRequery
    ? buildComboOptions(endCustomers)
    : buildComboOptions(endCustomers, {
        division: sc.divisionId,
        narrow: { column: 'DEPT_ID', codes: sc.deptId.split(',') },
      });

  const selectedEndCustomers = toSelectedCodes(sc.endCustomer.split(','));
  const endCustomerCodes =
    selectedEndCustomers.length > 0
      ? selectedEndCustomers
      : endCustomerOptions.map(option => option.value);
  const salesSiteOptions = isRequery
    ? buildComboOptions(salesSites)
    : buildComboOptions(salesSites, {
        division: sc.divisionId,
        narrow: { column: 'END_CUSTOMER', codes: endCustomerCodes },
      });

  /**
   * 다중선택 조회조건 한 벌. 이 화면은 Division 만 단일선택이다.
   *
   * sortBy 는 칸마다 켜는 옵트인이라 호출부가 직접 넘긴다. 조회조건 드롭다운은 전부
   * 표시명 순(숫자-영문-한글)으로 둔다 - 눈으로 찾는 목록이라 콤보 SQL 의 ORDER BY 보다
   * 이쪽이 낫다는 사용자 확정(2026-08-28). Team 도 예외가 아니다.
   */
  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string,
    options: { label: string; value: string }[],
    onPick: (codes: string) => void,
    sortBy?: 'label'
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        labelSize='middle'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy={sortBy}
            value={value}
            options={options}
            onChange={(_, picked) => onPick(String(picked ?? '') || 'ALL')}
          />
        )}
      />
    </Grid>
  );

  // 표시 형식: ${CODE} (${NAME}) — 단 CODE==NAME 이면 CODE 만 (e.g. 'Excel')
  // SP 가 prepend 하는 `'ALL' AS CODE` 행은 제외 — CustomDropdown 의 `allOption` 으로 위임 (중복 회피)
  const dataTypeOptions = useMemo(
    () =>
      (dtData?.o_rc1 ?? [])
        .map(r => {
          const code = String(r.CODE ?? '');
          const name = String(r.NAME ?? code);
          const label = code === name || name === '' ? code : `${code}`;
          return { value: code, label };
        })
        .filter(o => o.value !== 'ALL' && o.value !== ''),
    [dtData]
  );

  // Division 첫 값 자동선택은 페이지 컴포넌트(NnMasterMapping)의 fallback effect 가 담당한다 —
  //   AS-IS InitControls L155 clbDivisions.ControlValues(권한필터 목록 첫 값) 1:1.

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00089', 'Data Type')}
              labelAlign='right'
              labelSize='middle'
              render={() => (
                <CustomDropdown
                  allOption
                  options={dataTypeOptions}
                  value={sc.dataTypeCode}
                  onChange={(_, v) => set({ dataTypeCode: v || 'ALL' })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              labelSize='middle'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={buildComboOptions(divisions)}
                  onChange={(_, picked) => {
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      // Division 변경 = 하위 단계와 화면 고유 조회조건 전부 초기화.
                      //   목록이 다시 만들어지므로 안 지우면 옵션에 없는 값이 그대로 서버로 나간다.
                      set(
                        {
                          divisionId: String(picked ?? ''),
                          deptId: 'ALL',
                          endCustomer: 'ALL',
                          scmSiteId: 'ALL',
                          projectCode: '',
                          itemId: '',
                          dataTypeCode: 'ALL',
                        },
                        'division'
                      );
                    });
                  }}
                />
              )}
            />
          </Grid>
          {multiField(
            'LBL00044',
            'Team',
            sc.deptId,
            teamOptions,
            deptId =>
              set(
                {
                  deptId,
                  endCustomer: 'ALL',
                  scmSiteId: 'ALL',
                  projectCode: '',
                  itemId: '',
                  dataTypeCode: 'ALL',
                },
                'team'
              ),
            'label'
          )}
          {multiField(
            'LBL00080',
            'End Customer',
            sc.endCustomer,
            endCustomerOptions,
            endCustomer => set({ endCustomer, scmSiteId: 'ALL' }, 'endCustomer'),
            'label'
          )}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00617', 'Project')}
              labelAlign='right'
              labelSize='middle'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.projectCode}
                  onChange={e => set({ projectCode: e.target.value })}
                  InputProps={{
                    endAdornment: (
                      <Button
                        disabled={sc.divisionId === '40'}
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon
                            appearance='lined'
                            onClick={() => setOpenProjectModal(true)}
                          />
                        }
                      />
                    ),
                  }}
                  onDoubleClick={() => setOpenProjectModal(true)}
                  // AS-IS DMF0072 umltProject_KeyDown(L223~228): Enter → Project 팝업 열기(이 화면 개별 배선).
                  onKeyDown={e => {
                    if (e.key === 'Enter' && sc.divisionId !== '40') setOpenProjectModal(true);
                  }}
                  disabled={sc.divisionId === '40'}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              // Model/Nickname 라벨 2단 표시 — Project 의 검색 button 영역과 시각 분리 (룰: search-area-button-position-and-toggle.md §1)
              // FormItem.label 이 string 만 받음 — JSX 직접 사용 불가. CSS `white-space: pre-wrap` 으로 multilineLabel 효과 처리.
              label={t('LBL00618', 'Model/Nickname').replace('/', '/\n')}
              labelAlign='right'
              labelSize='middle'
              className={commonStyles.formItem}
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  onChange={e => set({ itemId: e.target.value })}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon
                            appearance='lined'
                            onClick={() => setOpenItemModal(true)}
                          />
                        }
                      />
                    ),
                  }}
                  onDoubleClick={() => setOpenItemModal(true)}
                  // AS-IS DMF0072 umltModel_KeyDown(L231~236): Enter → Model/Nickname 팝업 열기(이 화면 개별 배선).
                  onKeyDown={e => {
                    if (e.key === 'Enter') setOpenItemModal(true);
                  }}
                />
              )}
            />
          </Grid>
          {multiField(
            'LBL00011',
            'Sales Site',
            sc.scmSiteId,
            salesSiteOptions,
            scmSiteId => set({ scmSiteId }),
            'label'
          )}

          {/* Project Popup (COM0005 공용 modal 재사용) */}
          <ProjectByDivisionModal
            open={openProjectModal}
            modalClose={() => setOpenProjectModal(false)}
            setSelectedValue={projects => {
              set({ projectCode: projects });
              setOpenProjectModal(false);
            }}
            preSearchParams={{
              divisionId: sc.divisionId,
              deptId: sc.deptId,
              endCustomer: sc.endCustomer,
              salesSite: sc.scmSiteId,
              projectCode: sc.projectCode,
              etc: 'N',
            }}
            callFromCell={false}
          />

          {/* Model/Nickname Popup (COM0008 ItemByDivisionModal 재사용) */}
          <ItemByDivisionModal
            open={openItemModal}
            modalClose={() => setOpenItemModal(false)}
            setSelectedValue={items => {
              set({ itemId: items });
              setOpenItemModal(false);
            }}
            preSearchParams={{
              divisionId: sc.divisionId,
              deptId: sc.deptId,
              endCustomer: sc.endCustomer,
              salesSite: sc.scmSiteId,
              projectCode: sc.projectCode,
              itemId: sc.itemId,
            }}
            callFromCell={false}
            headerTitle='Model/Nickname Popup'
          />
        </>
      }
    />
  );
};
