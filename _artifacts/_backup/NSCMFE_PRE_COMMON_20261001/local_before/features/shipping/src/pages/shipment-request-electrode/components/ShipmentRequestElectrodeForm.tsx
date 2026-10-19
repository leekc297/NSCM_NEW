import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { COMBO } from '../shipment-request-electrode.constants';
import { useShipmentRequestElectrodeStore } from '../useShipmentRequestElectrodeStore';

interface Props {
  onSearch: () => void;
}

/**
 * 조회조건(design 02) — cascade 3단: Division(필터)→Company(재조회)→{PlantSite,PlanDate}(재조회).
 * `useCascadeFields`(master 도메인 CASCADE_LEVELS 카탈로그)는 division/team/endCustomer 등
 * 고정 필드셋만 지원해(Hard Boundary — master 패키지 확장 금지) 이 화면의 company/plantSite/
 * planDate 축을 표현할 수 없다. 개별 useTabComboQueries + CustomDropdown 조합으로 배선한다
 * (PlanGroupDashboardForm 선례 패턴).
 *
 * 확인 필요(design 02 §7 — 이번 회차 임의 해소 금지):
 * - CellType 콤보 ID(`CellTypeGr_SCP`) 반환값 대조 미완(확실성 중간)
 * - My Model 체크박스 기본값(dtMyModelChk 원천 SP 미확인)
 * - btnItemId/btnItemID2/btnRequestor 팝업 미배선(이번 회차는 텍스트 입력만 우선 배선, 팝업은 후속)
 * - btnModelId dead button — 신규 팝업 미신설
 */
export const ShipmentRequestElectrodeForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sp = useShipmentRequestElectrodeStore(state => state.searchParams);
  const setSearchParams = useShipmentRequestElectrodeStore(state => state.setSearchParams);
  const isOpenSearchArea = useShipmentRequestElectrodeStore(state => state.isOpenSearchArea);

  // Division→Company: 필터 방식(재조회 없음, design 02 §3) — 전량 1회 조회 후 클라 필터.
  const [divisions, companiesAll] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.COMPANY],
  });
  const companyOptions = (companiesAll ?? [])
    .filter(row => !sp.divisionId || String(row.DIVISION_ID ?? '') === sp.divisionId)
    .map(row => ({ label: String(row.NAME ?? ''), value: String(row.CODE ?? '') }));

  // Company→PlantSite/PlanDate: 재조회 방식(design 02 §3 — 서버가 division/company 파라미터로 필터).
  const plantSiteEnabled = !!sp.companyId;
  const [plantSites] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLANT_SITE, divisionId: sp.divisionId, companyId: sp.companyId }],
    enabled: plantSiteEnabled,
  });
  const [planDates] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLAN_DATE, companyId: sp.companyId }],
    enabled: plantSiteEnabled,
  });
  const [cellTypes] = useTabComboQueries({ filters: [COMBO.CELL_TYPE] });

  const handleDivisionChange = (divisionId: string) => {
    // Division 변경 = 하위 cascade 전건 초기화(design 02 §4 — Company/PlantSite/PlanDate/기간).
    setSearchParams({
      divisionId,
      companyId: '',
      plantSiteIds: [],
      planDate: '',
      fromYyyymmdd: '',
      toYyyymmdd: '',
    });
  };

  const handleCompanyChange = (companyId: string) => {
    setSearchParams({ companyId, plantSiteIds: [], planDate: '', fromYyyymmdd: '', toYyyymmdd: '' });
  };

  const handlePlanDateChange = (planDate: string) => {
    // PlanDate 선택 → 기간 자동 세팅(design 02 §3, 클라 파생 — 서버 재조회 없음).
    const row = (planDates ?? []).find(r => String(r.CODE ?? '') === planDate);
    setSearchParams({
      planDate,
      fromYyyymmdd: String(row?.FROM_DATE ?? ''),
      toYyyymmdd: String(row?.TO_DATE ?? ''),
    });
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00514', '_Search')}
      isHidden={!isOpenSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', '_Division')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sp.divisionId}
                  options={(divisions ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  onChange={(_, option) => handleDivisionChange(option)}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00047', '_Company')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sp.companyId}
                  options={companyOptions}
                  onChange={(_, option) => handleCompanyChange(option)}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00005', '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sp.plantSiteIds.join(',')}
                  options={(plantSites ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  onChange={(_, option) =>
                    setSearchParams({
                      plantSiteIds: option.split(',').filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00039', '_Plan Date')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sp.planDate}
                  options={(planDates ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  onChange={(_, option) => handlePlanDateChange(option)}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <PeriodRangePicker
              label={t('LBL00013', '_Period')}
              start={sp.fromYyyymmdd}
              end={sp.toYyyymmdd}
              onChange={(start, end) => setSearchParams({ fromYyyymmdd: start, toYyyymmdd: end })}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00046', '_Cell Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sp.cellTypes.join(',')}
                  options={(cellTypes ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  onChange={(_, option) =>
                    setSearchParams({ cellTypes: option.split(',').filter(v => v && v !== 'ALL') })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00669', '_Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sp.modelId}
                  onChange={e => setSearchParams({ modelId: e.target.value })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL01142', '_Item')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sp.itemId}
                  onChange={e => setSearchParams({ itemId: e.target.value })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00767', '_Nick Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sp.nickName}
                  onChange={e => setSearchParams({ nickName: e.target.value })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
