import { useEffect } from 'react';

import type { ComboParam, ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, LBL, LOOKUP } from '../inventory-raw.constants';
import { useInventoryRawStore } from '../useInventoryRawStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | LookupResponse[] | undefined) =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) §1 조회조건 5항목. 렌더 순서는 AS-IS 시각 배치(Designer 픽셀)
//   그대로 맞춘다(사용자 결정 2026-10-29): Division(x0) → Plant Site(x232) → Model(=Item ID, x393)
//   → Inventory Type(x590) → Plan-date*(2행 단독, x0/y28). SearchArea 가 Grid size={3}(한 행 4칸)이라
//   Plan Date 가 2행에 단독으로 떨어져 AS-IS 2행 레이아웃과 일치한다. 설계문서(§5)는 AS-IS tabIndex
//   (Inventory Type=3 < Model=4)를 따라 Inventory Type 을 앞에 뒀으나 "순서 기준"을 명시한 문서 근거가
//   없어, AS-IS 화면 배치를 우선 적용했다.
//   Division(고정 "40"+disabled) / Plant Site(다중, EE 분기 SQL_ID 2종) /
//   Model(=Item ID, 입력+팝업) / Inventory Type(단일 lookup INV_TYPE) / Plan-date*(PlanDateShip).
export const InventoryRawForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useInventoryRawStore(s => s.searchParams);
  const set = useInventoryRawStore(s => s.setSearchParams);
  const isOpenSearchArea = useInventoryRawStore(s => s.isOpenSearchArea);

  // Plant Site: Division 값의 'EE' 포함 여부로 SQL_ID 2종 상호배타 스위칭(design 02 §3#1) —
  //   콤보 UI 슬롯은 1개지만 공급 SQL_ID 는 2개(convert-core §2.6, 단일값으로 뭉뚱그리지 않음).
  const plantSiteFilter: ComboParam = {
    comboId: sc.divisionId.includes('EE') ? COMBO.PLANT_SITE_EE : COMBO.PLANT_SITE_NON_EE,
    divisionId: sc.divisionId,
  };

  // Plan Date(PlanDateShip) — 바인드 @divisionId·@shipPlanType 두 개를 모두 넘긴다(COL-09:
  //   세션 밖 바인드는 고정값이라도 comboParams 로 전달). AS-IS 는 param2(shipPlanType)를
  //   넘기지 않아 비-'P' 분기(SSP_PLAN_VERSION_V)를 타므로 Main 분기값 'A' 를 명시한다.
  const planDateFilter: ComboParam = {
    comboId: COMBO.PLAN_DATE,
    divisionId: sc.divisionId,
    shipPlanType: 'A',
  };

  const [divisions, plantSites, planDates] = useTabComboQueries({
    filters: [COMBO.DIVISION, plantSiteFilter, planDateFilter],
  });
  // Inventory Type = LookupCommon(LOOKUP_TYPE='INV_TYPE') — useTabLookupQueries 직접 조회
  //   (shipment-model-pic OPERATION_GROUP 선례와 동일, 콤보 브리지 원천과 동일 테이블).
  const [inventoryTypes] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.INVENTORY_TYPE }] });

  const divisionOptions = toOptions(divisions);
  const plantSiteOptions = toOptions(plantSites);
  const inventoryTypeOptions = toOptions(inventoryTypes);
  // NAME 이 이미 'YYYY-MM-DD' 로 내려온다(콤보 SQL 본문의 TO_CHAR) — 추가 포맷 불필요.
  const planDateOptions = toOptions(planDates);

  // Plan Date 기본 선택값 = 목록 첫 행[0] = 최신 Plan(콤보 SQL `ORDER BY UPPER(CODE) DESC`).
  //   AS-IS 파리티: SSP0017_InventoryRaw.cs:364 주석 "기본값 설정하기위해 division만 가지고 우선 조회"
  //   + cs:366 `setListBox(dt, cboPlanDate, false, "CODE", "NAME")` = 5인자 오버로드(CControl.cs:338)가
  //   `cbo.DataSource = dt` 로 바인딩 → WinForms ComboBox 는 비어있지 않은 DataSource 바인딩 시
  //   SelectedIndex 가 0 이 된다(같은 클래스 3인자 오버로드 CControl.cs:309 는 Items.Add 경로라
  //   자동선택이 없어 SelectedIndex=0 을 명시 — 두 경로의 의도가 "첫 행 선택"으로 일치).
  //   cs:168 `ConditionNotUseList.Add(cboPlanDate)` 로 조회조건 저장 대상도 아니라 매 로드마다
  //   목록 기본값에서 와야 한다(store restoreSearchConditions 의 EXCLUDED_DATE_PARAM 과 정합).
  //   미선택일 때만 설정 → 사용자가 고른 값은 재실행돼도 덮지 않는다(자매 ShipmentPsiForm I17 동일).
  //   dep 은 목록 '값 시그니처' — length 만 보면 길이가 같은 목록 교체에서 재선택이 안 된다.
  const planDateValueSig = planDateOptions.map(o => o.value).join('|');
  useEffect(() => {
    if (planDateOptions.length > 0 && !sc.planStartYyyymmdd) {
      set({ planStartYyyymmdd: planDateOptions[0].value });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planDateValueSig]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      onSearch={onSearch}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          {/* Division — clbDivision.ControlValues="40" 고정 + Enabled=false(design 02 §4). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => <CustomDropdown disabled value={sc.divisionId} options={divisionOptions} />}
            />
          </Grid>

          {/* From Site(=AS-IS Plant Site, 라벨만 변경·사용자 결정 2026-10-30, DMF0045 선례) — 다중선택,
              Division cascade 재조회(design 02 §3#1). 콤보 원천·필드·SP 파라미터는 Plant Site 그대로. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  limitTags={1}
                  sortBy='label'
                  value={sc.plantSiteIds.join(',')}
                  options={plantSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      plantSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Model/Nickname(=Item ID) — 텍스트 + 팝업(공용 MaterialByDivisionModal, design 02 §4.6).
              AS-IS 시각 배치상 Inventory Type(Designer x590)보다 앞(x393)이라 여기에 둔다(순서 주석 참조). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onItemSearch}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                />
              )}
            />
          </Grid>

          {/* Inventory Type — 단일선택, 기본선택 없음(design 02 §4). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.INVENTORY_TYPE, '_Inventory Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={sc.inventoryType}
                  options={inventoryTypeOptions}
                  onChange={(_, picked) => set({ inventoryType: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* Plan-date* — 필수(design 02 §4). SQL_ID 는 AS-IS 와 동명인 `PlanDateShip`
              (constants COMBO.PLAN_DATE 주석 — ora.py 실측 2026-10-14로 미결 해소). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLAN_DATE, '_Plan Date')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.planStartYyyymmdd}
                  options={planDateOptions}
                  onChange={(_, picked) => set({ planStartYyyymmdd: String(picked ?? '') })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
