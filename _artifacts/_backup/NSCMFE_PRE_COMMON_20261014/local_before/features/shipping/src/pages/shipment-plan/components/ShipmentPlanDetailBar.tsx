import { PeriodField } from 'features/master/src/components';
import { useEffect, useRef } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';

import { ALL, COMBO, LBL, LOOKUP, MENU_ID, SHEETS } from '../shipment-plan.constants';
import { useShipmentPlanStore } from '../useShipmentPlanStore';

import styles from './ShipmentPlanDetailBar.module.scss';

interface Props {
  onDetailSearch: () => void; // btnSearch — 활성 Detail sheet 재조회 (02 §4.2 — 6 sheet 전부 표시)
  onNew: () => void; // btnNew — PlanDetail 신규행 (buttonGuard #43: ActiveSheetIndex!=0 이면 무동작)
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

// 2차 조회조건 (usrLayoutControl3 — Detail 그리드 상단, design 01 R1/02 §4.2):
//   활성 Detail sheet 별 필드셋 6갈래 전환. HoldStock 전환 시 직전 상태 유지(R1f — 매핑 추가 금지).
export const ShipmentPlanDetailBar = ({
  onDetailSearch,
  onNew,
  onModelSearch,
  onRequestorSearch,
}: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanStore(s => s.searchCondition);
  const set = useShipmentPlanStore(s => s.setSearchCondition);
  const setPeriod2 = useShipmentPlanStore(s => s.setPeriod2);
  const fieldSet = useShipmentPlanStore(s => s.detailFieldSet);
  const activeDetailSheet = useShipmentPlanStore(s => s.activeDetailSheet);

  // Result Type — lookup(SSP_SHIPMENT_RESULT_TYPE, 02 §2-D) / Product Level1 — CellGroup_SCP 재사용
  const [resultTypes] = useTabLookupQueries({ filters: [LOOKUP.SHIPMENT_RESULT_TYPE] });
  const [cellGroups] = useTabComboQueries({
    filters: [{ comboId: COMBO.CELL_GROUP, mnuId: MENU_ID, divisionId: sc.divisionId }],
  });

  // Shipment Result 탭 "전환 시 1회" Result Type 항목0·1 자동 체크 (AS-IS SpdDetail_SheetTabClick
  //   L2439~2441 SetItemChecked(0/1,true) — 클릭 시점 1회, 이후 사용자가 해제 가능. 탭 활성 중
  //   상시 강제하면 기본 2코드 해제가 불가해진다 — gap-audit J2 회귀 수정. 탭을 떠나면 리셋되어
  //   재진입 시 다시 1회 체크(AS-IS 탭 클릭마다 체크와 동일). lookup 미로딩 상태로 진입했으면
  //   로딩 완료 시점에 1회 적용(AS-IS 는 로그인 시 선로딩이라 즉시 적용 — 등가 시점 보정).
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

        {/* Shipment Date (drpPeriod3 — ShipmentResult 전용, 기본 오늘-9~오늘-1 클라 계산) */}
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

        {/* Product Level1 — clbProductLevel12 (CellGroup_SCP 동일 결과셋 재사용, 02 §2-C #10) */}
        {fieldSet.productLevel1 && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PRODUCT_LEVEL1, '_Product Level1')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.productLevel12.join(',')}
                  options={toOptions(cellGroups)}
                  onChange={(_, picked) =>
                    set({
                      productLevel12: str(picked)
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
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

        {/* Result Type — clbResultType (ShipmentResult 전용, lookup 6코드) */}
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

        {/* Box ID — txtBoxID (MES Stock Detail 전용, 자유입력 다건) */}
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
        {/* NEW — PlanDetail 전용 노출(R1). 가드(#43 ActiveSheetIndex!=0 무동작)는 페이지 handleNew 가 재현 */}
        {fieldSet.newButton && (
          <Button appearance='outlined' priority='normal' onClick={onNew}>
            {t(LBL.NEW, '_New')}
          </Button>
        )}
        {/* Search — 6 sheet 전부 항상 표시(02 §4.2) — 활성 sheet 재조회 */}
        <Button appearance='contained' priority='primary' onClick={onDetailSearch}>
          {t(LBL.SEARCH, '_Search')}
        </Button>
      </Stack>
    </Stack>
  );
};
