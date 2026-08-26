import { useEffect, useMemo, useState } from 'react';

import { apiClient } from '@foundation/apis';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  DivisionField,
  EndCustomerField,
  ItemByDivisionModal,
  ProjectByDivisionModal,
  SalesSiteField,
  TeamField,
} from '../../../components';
// 임시 로컬 디버그 — 확인 끝나면 이 import 와 logSearchReset 호출, debugLabel prop 을 지운다.
import { logSearchReset } from '../../../components/searchFields/SearchFields.debug';
import { MENU_ID, SHEETS } from '../nn-master-mapping.constants';
import type { SearchCondition } from '../nn-master-mapping.types';
import { useNnMasterMappingStore } from '../useNnMasterMappingStore';

// 스토어의 조회조건은 CustomDropdown 이 내보내는 문자열 그대로다 ('ALL' 또는 콤마 조인).
// SearchFields 카탈로그는 string[] 계약이라 이 화면에서만 변환한다.
// 'ALL' 은 ['ALL'] 로 왕복하고, cascade 에서는 toFilterSet 이 걷어내 필터 미적용이 된다.
const toList = (v: string) => v.split(',').filter(Boolean);

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
    filters: {},
    enabled: true,
  });
  // End Customer / Sales Site 는 카탈로그 필드가 공용 콤보('EndCustomer' / 'SalesSite')로
  // 직접 조회하고 cascade 는 클라이언트에서 건다. DMF0044 sales-site-project-model 과 동일한 구도.
  // 이 화면 전용 SHEETS.END_CUSTOMER / SHEETS.SALES_SITE proc 은 더 이상 호출하지 않는다.

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

  // Division 필수 — 첫 옵션 자동 선택(AS-IS .cs L460 MSG00097 회피)은 DivisionField 가
  // resolveDivisionAutoSelect 로 내부 처리한다. 여기서 따로 보정하지 않는다.

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00614', 'Data Type')}
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
          <DivisionField
            gridSize={3}
            value={sc.divisionId}
            onChange={v => {
              // 임시 로컬 디버그 — division 변경 시 하위 조회조건이 어떻게 재세팅되는지.
              logSearchReset({
                label: 'DMF0072 nn-master-mapping',
                changed: { field: 'divisionId', from: sc.divisionId, to: v },
                resets: [
                  { field: 'deptId', from: sc.deptId, to: 'ALL' },
                  { field: 'endCustomer', from: sc.endCustomer, to: 'ALL' },
                  { field: 'scmSiteId', from: sc.scmSiteId, to: 'ALL' },
                  { field: 'projectCode', from: sc.projectCode, to: '' },
                  { field: 'itemId', from: sc.itemId, to: '' },
                  { field: 'dataTypeCode', from: sc.dataTypeCode, to: 'ALL' },
                ],
              });
              set({
                divisionId: v,
                deptId: 'ALL',
                endCustomer: 'ALL',
                scmSiteId: 'ALL',
                projectCode: '',
                itemId: '',
                dataTypeCode: 'ALL',
              });
            }}
          />
          {/* 주의: 'ALL' 을 빈 배열로 바꿔 내려보내지 않는다.
              CustomDropdown 은 SELECT ALL 을 'ALL' sentinel 로 내보내고, 그 값이 그대로
              돌아와야 전체 체크 표시를 유지한다(isAllSentinel). 빈 배열로 바꾸면 value 가 ''
              가 되어 sentinel 이 깨지고, setSelectAllChecked(false) 가 돌아 체크가 바로 풀린다. */}
          <TeamField
            gridSize={3}
            division={sc.divisionId}
            value={toList(sc.deptId)}
            onChange={v => {
              // 임시 로컬 디버그 — CustomDropdown 이 실제로 무엇을 내보내는지(전체선택='ALL',
              // 전체해제='', 개별선택=콤마 조인) 확인용.
              logSearchReset({
                label: 'DMF0072 nn-master-mapping',
                changed: {
                  field: 'deptId (= End Customer / Sales Site 콤보의 DEPT_ID)',
                  from: sc.deptId,
                  to: v.length > 0 ? v.join(',') : 'ALL',
                },
                resets: [
                  { field: 'endCustomer', from: sc.endCustomer, to: 'ALL' },
                  { field: 'scmSiteId', from: sc.scmSiteId, to: 'ALL' },
                  { field: 'projectCode', from: sc.projectCode, to: '' },
                  { field: 'itemId', from: sc.itemId, to: '' },
                  { field: 'dataTypeCode', from: sc.dataTypeCode, to: 'ALL' },
                ],
              });
              set({
                deptId: v.length > 0 ? v.join(',') : 'ALL',
                endCustomer: 'ALL',
                scmSiteId: 'ALL',
                projectCode: '',
                itemId: '',
                dataTypeCode: 'ALL',
              });
            }}
          />
          {/* cascade = division-team-endCustomer. division 은 카탈로그 필드가 항상 먼저 걸므로
              여기엔 Team(DEPT_ID) 단계만 넘긴다. 콤보를 바꾸면 컬럼명도 달라질 수 있어
              어느 조회조건이 어느 컬럼에 대응하는지는 화면이 들고 있는다.
              필수: strict. 'EndCustomer' 콤보는 DEPT_ID 가 공란인 행이 대다수라(SITE_ITEM LEFT
                OUTER JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다 — 필터가 통째로
                무력화된다. */}
          <EndCustomerField
            gridSize={3}
            division={sc.divisionId}
            cascade={{ DEPT_ID: { values: toList(sc.deptId), strict: true } }}
            debugLabel='DMF0072 nn-master-mapping / End Customer'
            value={toList(sc.endCustomer)}
            onChange={values => {
              // 임시 로컬 디버그 — 이 화면에서 End Customer 는 'SalesSite' 콤보의 PROJECT_CODE
              // 자리로 쓰인다. 어떤 값이 하위 Sales Site cascade 로 넘어가는지 확인용.
              logSearchReset({
                label: 'DMF0072 nn-master-mapping',
                changed: {
                  field: 'endCustomer (= SalesSite 콤보의 PROJECT_CODE)',
                  from: sc.endCustomer,
                  to: values.join(','),
                },
                resets: [{ field: 'scmSiteId', from: sc.scmSiteId, to: 'ALL' }],
              });
              set({
                endCustomer: values.join(','),
                // cascade 상위 단계라 하위 Sales Site 선택은 초기화한다 —
                // 안 지우면 옵션에서 사라진 사이트가 조회조건에 그대로 남아 서버로 나간다.
                scmSiteId: 'ALL',
              });
            }}
          />
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
                />
              )}
            />
          </Grid>
          {/* cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
              division 은 카탈로그 필드가 항상 먼저 걸므로 여기 적지 않는다.
              End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 — 콤보가 END_CUSTOMER 컬럼을
                내려주지 않기 때문이다. DMF0044 sales-site-project-model 과 동일.
              콤보를 바꾸면 컬럼명도 달라지므로 어느 조회조건이 어느 컬럼에 대응하는지는 화면이 든다. */}
          <SalesSiteField
            gridSize={3}
            division={sc.divisionId}
            cascade={{
              // DEPT_ID 는 strict — End Customer 와 같은 이유로 관대로 두면 Team 이 목록을 못 좁힌다.
              DEPT_ID: { values: toList(sc.deptId), strict: true },
              // PROJECT_CODE 는 관대 — 'SalesSite' 콤보는 이 컬럼이 NULL 인 행이 정상적으로
              // 존재한다. 자르면 목록이 비어버린다.
              PROJECT_CODE: toList(sc.endCustomer),
            }}
            debugLabel='DMF0072 nn-master-mapping / Sales Site'
            value={toList(sc.scmSiteId)}
            onChange={values => {
              // 임시 로컬 디버그 — cascade 최하위라 같이 재세팅되는 항목은 없다.
              logSearchReset({
                label: 'DMF0072 nn-master-mapping',
                changed: { field: 'scmSiteId', from: sc.scmSiteId, to: values.join(',') },
                resets: [],
              });
              set({ scmSiteId: values.join(',') });
            }}
          />
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
