import { PeriodField } from 'features/master/src/components';
import { useEffect, useRef } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';

import { ALL, LBL, LOOKUP, SHEETS } from '../shipment-plan-auto-ess.constants';
import { useShipmentPlanAutoEssStore } from '../useShipmentPlanAutoEssStore';

import styles from './ShipmentPlanAutoEssDetailBar.module.scss';

interface Props {
  onDetailSearch: () => void; // btnSearch — 활성 Detail sheet 재조회 (02 §4.2)
  onModelSearch: () => void; // btnItemID2 — 2차 Model 팝업
  onRequestorSearch: () => void; // btnRequestor — UserInfoPopup
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: { CODE?: unknown; NAME?: unknown }[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 2차 조회조건 (usrLayoutControl3 — Detail 그리드 상단, design 01 §2 R3 / 02 §4.2):
//   활성 Detail sheet 별 필드셋 전환. HoldStock 전환 시 직전 상태 유지(R3 매핑 없음).
//   SSP0021 은 Product Level·New 버튼이 없다(Insert 는 공통 툴바 F8).
export const ShipmentPlanAutoEssDetailBar = ({
  onDetailSearch,
  onModelSearch,
  onRequestorSearch,
}: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanAutoEssStore(s => s.searchCondition);
  const set = useShipmentPlanAutoEssStore(s => s.setSearchCondition);
  const setPeriod2 = useShipmentPlanAutoEssStore(s => s.setPeriod2);
  const fieldSet = useShipmentPlanAutoEssStore(s => s.detailFieldSet);
  const activeDetailSheet = useShipmentPlanAutoEssStore(s => s.activeDetailSheet);

  // Result Type — lookup(SSP_SHIPMENT_RESULT_TYPE, 02 §2-6)
  const [resultTypes] = useTabLookupQueries({ filters: [LOOKUP.SHIPMENT_RESULT_TYPE] });

  // Shipment Result 탭 "전환 시 1회" Result Type 항목0·1 자동 체크 (AS-IS L2153-2154 — 클릭 1회,
  //   이후 사용자가 해제 가능. 탭을 떠나면 리셋되어 재진입 시 다시 1회 체크). lookup 미로딩 진입 시
  //   로딩 완료 시점에 1회 적용.
  const resultTypeDefaultAppliedRef = useRef(false);
  useEffect(() => {
    if (activeDetailSheet !== SHEETS.SHIPMENT_RESULT) {
      resultTypeDefaultAppliedRef.current = false;
      return;
    }
    if (resultTypeDefaultAppliedRef.current) return;
    const defaults = (resultTypes ?? [])
      .slice(0, 2)
      .map(r => str((r as { CODE?: unknown }).CODE))
      .filter(Boolean);
    if (defaults.length === 0) return;
    resultTypeDefaultAppliedRef.current = true;
    const merged = [...new Set([...sc.resultTypes, ...defaults])];
    if (merged.length !== sc.resultTypes.length) set({ resultTypes: merged });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeDetailSheet, resultTypes]);

  return (
    <Stack direction='row' alignItems='center' className={styles.detailBar}>
      <Grid container columns={12} className={styles.detailBarFields}>
        {/* Shipment Date (drpPeriod2 — PlanDetail 전용). 범위 이탈 시 무메시지 clamp(buttonGuard #37) */}
        {fieldSet.period2 && (
          <PeriodField
            gridSize={3}
            label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
            start={sc.period2From}
            end={sc.period2To}
            onChange={(start, end) => setPeriod2(start, end)}
          />
        )}

        {/* Shipment Date (drpPeriod3 — ShipmentResult 전용, 기본 오늘-9~오늘-1) */}
        {fieldSet.period3 && (
          <PeriodField
            gridSize={3}
            label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
            start={sc.period3From}
            end={sc.period3To}
            onChange={(start, end) => set({ period3From: start, period3To: end })}
          />
        )}

        {/* Model — txtModel2 + btnItemID2 */}
        {fieldSet.model && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.model}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onModelSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ model: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
                />
              )}
            />
          </Grid>
        )}

        {/* Requestor — txtRequestor + btnRequestor(UserInfoPopup). 표시는 이름, 조회 파라미터는 requestorId */}
        {fieldSet.requestor && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.REQUESTOR, '_Requestor')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.requestorName || sc.requestorId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onRequestorSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ requestorId: e.target.value, requestorName: '' })}
                  onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
                />
              )}
            />
          </Grid>
        )}

        {/* Result Type — clbResultType (ShipmentResult 전용, lookup) */}
        {fieldSet.resultType && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.RESULT_TYPE, '_Result Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.resultTypes.join(',')}
                  options={toOptions(resultTypes)}
                  onChange={(_, picked) =>
                    set({
                      resultTypes: str(picked)
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
                />
              )}
            />
          </Grid>
        )}

        {/* Box ID (LOT ID) — txtBoxID (MES Stock Detail 전용, 자유입력 다건) */}
        {fieldSet.boxId && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BOX_ID, '_Box ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.boxId}
                  onChange={e => set({ boxId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
                />
              )}
            />
          </Grid>
        )}
      </Grid>

      <Stack direction='row' className={styles.detailBarButtons}>
        {/* Search — 활성 sheet 재조회(02 §4.2 — 전 sheet 표시) */}
        <Button appearance='contained' priority='primary' onClick={onDetailSearch}>
          {t(LBL.SEARCH, '_Search')}
        </Button>
      </Stack>
    </Stack>
  );
};
