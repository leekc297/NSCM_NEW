import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField, Label } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  CascadeFields,
  ItemByDivisionModal,
  OwnerByDivisionModal,
  ProjectByDivisionModal,
} from '../../../components';
import { SEARCH_CASCADE_COMBO_ID, SHEET_INDEX } from '../sales-site-project-model.constants';
import { useSalesSiteProjectModelStore } from '../useSalesSiteProjectModelStore';

interface SalesSiteProjectModelFormProps {
  onSubmit: () => void;
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const SalesSiteProjectModelForm = ({
  onSubmit,
  setActiveTab,
}: SalesSiteProjectModelFormProps) => {
  const { t } = useTranslation();

  const openSearchArea = useSalesSiteProjectModelStore(state => state.openSearchArea);
  const openPurchaseGrid = useSalesSiteProjectModelStore(state => state.openPurchaseGrid);
  const searchParams = useSalesSiteProjectModelStore(state => state.searchParams);
  const setOpenPurchaseGrid = useSalesSiteProjectModelStore(state => state.setOpenPurchaseGrid);
  const setSearchParams = useSalesSiteProjectModelStore(state => state.setSearchParams);

  // Div / Team / End Customer / Sales Site 콤보는 CascadeFields 가 조인 콤보 1건으로 직접 조회한다.
  // 여기서는 이 화면에만 있는 Active 콤보만 받는다.
  const [yesOrNo] = useTabComboQueries({ filters: ['YesOrNo'] });

  const [openProjectByDivisionModal, setOpenProjectByDivisionModal] = useState(false);
  const [openItemByDivisionModal, setOpenItemByDivisionModal] = useState(false);
  const [openOwnerByDivisionModal, setOpenOwnerByDivisionModal] = useState(false);

  const handleProjectByDivisionModal = (projects: string) => {
    setSearchParams({ projectCode: projects });
  };

  const handleItemByDivisionModal = (items: string) => {
    setSearchParams({ itemId: items });
  };

  const handleOwnerByDivisionModalSubmit = (owners: string) => {
    setSearchParams({ owner: owners });
  };

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSubmit}
        conditions={
          <>
            {/* Div - Team - End Customer - Sales Site 는 조인 콤보 1건(CascadeFields)에서 뽑는다.
                단계 옵션은 상위 선택으로 좁힌 행에서 나오고, 하위 값 초기화도 컴포넌트가 한다.
                여기서는 이 화면 고유 항목(PJT / Model / Owner / Active)만 얹는다. */}
            <CascadeFields
              comboId={SEARCH_CASCADE_COMBO_ID}
              gridSize={3}
              // 배열 순서가 곧 cascade 순서다. 마지막 단계(salesSite)가 콤보의 CODE / NAME 을 읽는다.
              // field 는 스토어 필드명 — value 로 넘긴 searchParams 의 키와 대조돼 오타가 컴파일에서 잡힌다.
              // 인라인 배열이지만 CascadeFields 가 값 기준 서명으로 memo 하므로 매 렌더 재계산되지 않는다.
              levels={[
                { key: 'division', field: 'divisionId' },
                { key: 'team', field: 'deptId' },
                { key: 'endCustomer', field: 'endCustomer' },
                { key: 'salesSite', field: 'salesSite' },
              ]}
              value={searchParams}
              onChange={(next, changed) => {
                // Div / Team 변경은 화면 고유 조회조건까지 전부 초기화한다 — 종전 인라인 동작 그대로.
                // End Customer / Sales Site 는 cascade 하위만 정리되면 되므로 next 만 반영한다.
                if (changed === 'division' || changed === 'team') {
                  setSearchParams({
                    ...next,
                    projectCode: '',
                    itemId: '',
                    owner: '',
                    activeFlag: 'ALL',
                  });
                  setOpenPurchaseGrid(true);
                  return;
                }
                setSearchParams(next);
              }}
            />
            {searchParams.divisionId !== '40' && (
              <Grid size={3}>
                <FormItem
                  label={t('LBL00617', '_PJT')}
                  labelAlign='right'
                  className={commonStyles.formItem}
                  render={() => (
                    <InputField
                      fullWidth
                      className={commonStyles.popupSearchField}
                      value={searchParams.projectCode}
                      InputProps={{
                        endAdornment: (
                          <Button
                            appearance='outlined'
                            priority='normal'
                            iconComponent={
                              <FunctionSearchIcon
                                appearance='lined'
                                onClick={() => setOpenProjectByDivisionModal(true)}
                              />
                            }
                          />
                        ),
                      }}
                      onChange={e => setSearchParams({ projectCode: e.target.value })}
                    />
                  )}
                />
              </Grid>
            )}
            <Grid size={3}>
              <FormItem
                label={t('LBL00508', 'Model / Nickname')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    value={searchParams.itemId}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenItemByDivisionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={e => setSearchParams({ itemId: e.target.value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00082', '_Owner')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    value={searchParams.owner}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenOwnerByDivisionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={e => setSearchParams({ owner: e.target.value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3} className={commonStyles.customGrid}>
              <FormItem
                label={t('LBL00007', '_Active')}
                labelAlign='right'
                required
                width='100%'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    limitTags={1}
                    isInput={false}
                    allOption
                    value={searchParams.activeFlag}
                    options={
                      yesOrNo?.map(item => ({
                        label: item.NAME,
                        value: item.CODE,
                      })) ?? []
                    }
                    onChange={(_, options) => {
                      setSearchParams({ activeFlag: options });
                    }}
                  />
                )}
              />
              {searchParams.divisionId !== '40' && (
                <FormItem
                  render={() => (
                    <div className={commonStyles.customCheckbox}>
                      <Checkbox
                        checked={openPurchaseGrid}
                        sx={{ marginLeft: '15px' }}
                        onChange={checked => {
                          if (!checked) setActiveTab(SHEET_INDEX.PRODUCTION);
                          setOpenPurchaseGrid(checked);
                        }}
                      />
                      <Label labelText={t('LBL00316', '_Detail')} depth='sub' />
                    </div>
                  )}
                />
              )}
            </Grid>
          </>
        }
      />
      <ProjectByDivisionModal
        open={openProjectByDivisionModal}
        modalClose={() => setOpenProjectByDivisionModal(false)}
        setSelectedValue={handleProjectByDivisionModal}
        preSearchParams={{ ...searchParams }}
        callFromCell={false}
      />
      <ItemByDivisionModal
        open={openItemByDivisionModal}
        modalClose={() => setOpenItemByDivisionModal(false)}
        setSelectedValue={handleItemByDivisionModal}
        preSearchParams={searchParams}
        callFromCell={false}
      />
      <OwnerByDivisionModal
        open={openOwnerByDivisionModal}
        modalClose={() => setOpenOwnerByDivisionModal(false)}
        setSelectedValue={handleOwnerByDivisionModalSubmit}
        preSearchParams={searchParams}
        ownerId={searchParams.owner}
      />
    </>
  );
};
