import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { LBL, LOOKUP } from '../shipment-plan-electrode.constants';
import styles from '../ShipmentPlanElectrode.module.scss';
import { useShipmentPlanElectrodeStore } from '../useShipmentPlanElectrodeStore';

interface Props {
  onDetailSearch: () => void; // btnSearch — 활성 Detail sheet 재조회
  onNew: () => void; // btnNew — PlanDetail 신규행 (가드: ActiveSheetIndex==0 이면만 동작 — 페이지 handleNew)
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: { CODE?: unknown; NAME?: unknown }[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 2차 조회조건 (usrLayoutControl3 — Detail 그리드 상단, design 03 §0):
//   활성 Detail sheet 별 필드셋 전환(detailFieldSet):
//     PlanDetail     : Shipment Date(표시전용, 1차 period 파생) + NEW + Search
//     StockDetail    : Search 만
//     ShipmentResult : Result Type + Shipment Date(표시전용) + Search
//   Shipment Date 는 별도 축을 두지 않고 1차 period(periodFrom~To) 를 표시전용으로 노출한다 —
//     store SearchCondition 에 detail 전용 기간축이 없다(계약에 없는 필드 신설 금지). 실제 조회 파라미터는
//     setDetailFilter 가 1차 period 로 채운다. drpPeriod2/3 독립축이 필요해지면 04_react-gap.md 확인필요.
export const ShipmentPlanElectrodeDetailBar = ({ onDetailSearch, onNew }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanElectrodeStore(s => s.searchCondition);
  const set = useShipmentPlanElectrodeStore(s => s.setSearchCondition);
  const fieldSet = useShipmentPlanElectrodeStore(s => s.detailFieldSet);

  // Result Type — lookup(SSP_SHIPMENT_RESULT_TYPE, 02 §5-1). FE 후필터 R 제외(설계 02 §5-1).
  const [resultTypes] = useTabLookupQueries({ filters: [LOOKUP.RESULT_TYPE] });
  const resultTypeOptions = toOptions((resultTypes ?? []).filter(r => str(r.CODE) !== 'R'));

  const periodText = sc.periodFrom ? `${sc.periodFrom} ~ ${sc.periodTo}` : '';

  return (
    <Stack direction='row' alignItems='center' className={styles.detailBar}>
      <Grid container columns={12} className={styles.detailBarFields}>
        {/* Result Type — clbResultType (ShipmentResult 전용, lookup FE 후필터 R 제외) */}
        {fieldSet.resultType && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.RESULT_TYPE, { defaultValue: 'Result Type' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  useClearIcon
                  value={sc.resultType}
                  options={resultTypeOptions}
                  onChange={(_, picked) => set({ resultType: str(picked) })}
                />
              )}
            />
          </Grid>
        )}

        {/* Shipment Date — 표시전용(1차 period 파생. 독립축 없음 — 상단 주석 참조) */}
        {fieldSet.shipmentDate && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SHIPMENT_DATE, { defaultValue: 'Shipment Date' })}
              labelAlign='right'
              render={() => <InputField fullWidth disabled value={periodText} />}
            />
          </Grid>
        )}
      </Grid>

      <Stack direction='row' className={styles.detailBarButtons}>
        {/* NEW — PlanDetail 전용 노출. 가드(활성 sheet==PlanDetail·편집가능)는 페이지 handleNew 재현 */}
        {fieldSet.newButton && (
          <Button appearance='outlined' priority='normal' onClick={onNew}>
            {t(LBL.NEW, { defaultValue: 'New' })}
          </Button>
        )}
        {/* Search — 활성 sheet 재조회(항상 표시) */}
        <Button appearance='contained' priority='primary' onClick={onDetailSearch}>
          {t(LBL.SEARCH, { defaultValue: 'Search' })}
        </Button>
      </Stack>
    </Stack>
  );
};
