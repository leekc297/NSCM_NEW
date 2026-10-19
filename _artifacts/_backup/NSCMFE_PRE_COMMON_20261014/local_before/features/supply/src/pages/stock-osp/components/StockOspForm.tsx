import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo } from 'react';

import type { ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, EE_ATTRIBUTE, LBL, STATUS_LOOKUP, TAB_INDEX } from '../stock-osp.constants';
import { useStockOspStore } from '../useStockOspStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
  // Division 권한 0건 여부를 페이지로 전달(조회 차단 게이트, design 02 §6-8).
  onDivisionAuth: (hasAuth: boolean) => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 다중 콤보 'ALL'/공백 정규화 → 실코드 배열(전체선택 = 빈 배열, 부분선택만 유지).
const pickMulti = (picked: unknown): string[] =>
  str(picked)
    .split(',')
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL');

// PACKER_HOLD_STATUS lookup → 옵션. SEGMENT1=코드(HOLD/RELEASE), SEGMENT2=표시명(Hold/Release) (design 02 §lookup).
const toStatusOptions = (rows: LookupResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.SEGMENT2) || str(r.SEGMENT1), value: str(r.SEGMENT1) }));

// SCP0041 조회조건 (design 02 §1 인벤토리 7건, 탭 분기 §4):
//   공통: Division(FE 필터 ATTRIBUTE3!=='EE') / Plant Site(탭별 콤보 상이) / Model(ItemByDivisionModal 돋보기) / Period.
//   Pack 전용: Inspection(텍스트) / Status(PACKER_HOLD_STATUS lookup) / Cutoff Date(기간) — extraConditions 폴드.
//   Osp Plant Site = OSP1 ∪ SaleSite1 Merge / Pack Plant Site = PackerHoldStock1 단독(design 02 §Osp/§Pack).
export const StockOspForm = ({ onSearch, onItemSearch, onDivisionAuth }: Props) => {
  const { t } = useTranslation();

  const sc = useStockOspStore(s => s.searchCondition);
  const set = useStockOspStore(s => s.setSearchCondition);
  const openSearchArea = useStockOspStore(s => s.openSearchArea);
  const activeTab = useStockOspStore(s => s.activeTab);
  const isPack = activeTab === TAB_INDEX.PACK;

  // 콤보 4종 + Status lookup. Plant Site 는 탭에 따라 3개 소스가 달라 전부 조회하고 화면에서 합친다.
  //   Osp: OSP1(PLANT) ∪ SaleSite1(SALES) Merge / Pack: PackerHoldStock1(PLANT) 단독.
  const [divisions, plantOsp, saleOsp, plantPack] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      { comboId: COMBO.PLANT_SITE_OSP, divisionId: sc.divisionId },
      { comboId: COMBO.SALE_SITE_OSP, divisionId: sc.divisionId },
      { comboId: COMBO.PLANT_SITE_PACK, divisionId: sc.divisionId },
    ],
  });
  const [statusRows] = useTabLookupQueries({ filters: [STATUS_LOOKUP] });

  // Division — AS-IS GetDivisionWithoutEE 재현: ATTRIBUTE3='EE'(전극) 사업부 제외(design 02 §2-1).
  const divisionOptions = useMemo(
    () =>
      toOptions(divisions).filter(o => {
        const row = (divisions ?? []).find(r => str(r.CODE) === o.value);
        return str(row?.ATTRIBUTE3).trim().toUpperCase() !== EE_ATTRIBUTE;
      }),
    [divisions]
  );

  // Plant Site 옵션 — 탭별 소스. Osp 는 두 콤보를 CODE 기준 합집합(중복 제거, OSP1 우선).
  const plantSiteOptions = useMemo<Option[]>(() => {
    if (isPack) return toOptions(plantPack);
    const merged = [...toOptions(plantOsp), ...toOptions(saleOsp)];
    const seen = new Set<string>();
    return merged.filter(o => (seen.has(o.value) ? false : (seen.add(o.value), true)));
  }, [isPack, plantOsp, saleOsp, plantPack]);

  const statusOptions = toStatusOptions(statusRows);

  // 권한 게이트 — Division 응답이 왔고(≠undefined) 0건이면 권한 없음(design 02 §6-8).
  //   MyDivision 권한조인(USER_GR_MNU_MPG_M) 2행 실측이라 정상 사용자는 통과(memory 트랜스퍼킬러 해소).
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (divisions === undefined) return;
    onDivisionAuth(!noDivisionAuth);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions]);

  // Division 첫 항목 자동 보정 — 세션 사업부가 권한목록에 없거나 미설정일 때(design 02 §2-1 기본값).
  useEffect(() => {
    if (divisionOptions.length === 0) return;
    if (!divisionOptions.some(o => o.value === sc.divisionId)) {
      set({ divisionId: divisionOptions[0].value });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionOptions]);

  // Division 변경 = cascade 재조회(콤보 useTabComboQueries divisionId 파라미터가 자동 반영) + PlantSite 초기화.
  const onDivisionChange = (value: string) => {
    set({ divisionId: value, plantSiteIds: [] });
  };

  const model = (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(LBL.MODEL, '_Model')}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            className={commonStyles.popupSearchField}
            value={sc.itemId}
            disabled={noDivisionAuth}
            InputProps={{
              endAdornment: (
                <Button
                  appearance='outlined'
                  priority='normal'
                  disabled={noDivisionAuth}
                  iconComponent={
                    <FunctionSearchIcon appearance='lined' onClick={onItemSearch} />
                  }
                />
              ),
            }}
            onChange={e => set({ itemId: e.target.value })}
            onKeyDown={e => e.key === 'Enter' && onSearch()}
          />
        )}
      />
    </Grid>
  );

  // Pack 전용 조회조건(Inspection/Status/Cutoff Date) — 2단 초과분을 접이식(extraConditions)으로 분리(hook #52).
  const packExtra = isPack ? (
    <>
      <Grid size={3}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.INSPECTION, '_Inspection')}
          labelAlign='right'
          render={() => (
            <InputField
              fullWidth
              value={sc.inspectionId}
              disabled={noDivisionAuth}
              onChange={e => set({ inspectionId: e.target.value })}
              onKeyDown={e => e.key === 'Enter' && onSearch()}
            />
          )}
        />
      </Grid>
      <Grid size={3}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.STATUS, '_Status')}
          labelAlign='right'
          render={() => (
            <CustomDropdown
              allOption
              useClearIcon
              value={sc.status}
              options={statusOptions}
              disabled={noDivisionAuth}
              onChange={(_, picked) => set({ status: pickMulti(picked).join(',') })}
            />
          )}
        />
      </Grid>
      <PeriodField
        gridSize={3}
        start={sc.cutoffFromYyyymmdd}
        end={sc.cutoffToYyyymmdd}
        onChange={(start, end) => set({ cutoffFromYyyymmdd: start, cutoffToYyyymmdd: end })}
        label={t(LBL.CUTOFF_DATE, '_Cutoff Date')}
      />
    </>
  ) : undefined;

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      extraConditions={packExtra}
      conditions={
        <>
          {/* Division — FE 필터 ATTRIBUTE3!=='EE'(design 02 §2-1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  disabled={noDivisionAuth}
                  onChange={(_, picked) => onDivisionChange(str(picked))}
                />
              )}
            />
          </Grid>
          {/* Plant Site — 다중선택 + ALL. Osp=OSP1∪SaleSite1 / Pack=PackerHoldStock1 (design 02 §Osp/§Pack) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLANT_SITE, '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  disabled={noDivisionAuth}
                  value={sc.plantSiteIds.join(',')}
                  options={plantSiteOptions}
                  onChange={(_, picked) => set({ plantSiteIds: pickMulti(picked) })}
                />
              )}
            />
          </Grid>
          {/* Model — 텍스트 + 돋보기(ItemByDivisionModal, design 02 §popup) */}
          {model}
          {/* Period — 조회 기간(design 02 §1) */}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t(LBL.PERIOD, '_Period')}
          />
        </>
      }
    />
  );
};
