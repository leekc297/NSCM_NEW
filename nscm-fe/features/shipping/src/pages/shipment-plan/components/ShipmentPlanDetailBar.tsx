import { PeriodField } from 'features/master/src/components';
import { useEffect, useRef } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, DETAIL_CONDITIONS_SX } from '@shared/components';
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

// null 원소 가드 — 사유는 ShipmentPlanForm.toOptions 주석 참조(CellGroup_SCP 전 컬럼 NULL 행 →
//   MyBatis null 매핑). 이 바(Product Level1)도 같은 콤보를 쓰므로 동일 가드가 필요하다.
const toOptions = (
  rows: ({ CODE?: unknown; NAME?: unknown } | null)[] | undefined
): Option[] =>
  (rows ?? [])
    .filter((r): r is { CODE?: unknown; NAME?: unknown } => r != null)
    .map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

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
      <Grid container columns={12} className={styles.detailBarFields} sx={DETAIL_CONDITIONS_SX}>
        {/* Shipment Date (drpPeriod2 — PlanDetail 전용). AS-IS DrpPeriod2_ValueChanged(cs:2187~2202)는
            Shipment Date 범위를 상단 Period 보다 좁히면(시작>Period시작 or 종료<Period종료) Period 값으로
            되돌린다. 종전 무메시지 snap-back 은 "입력이 잘 안됨" 불편의 원인이라 제거됐었는데(2026-10-16),
            사용자 재확인(2026-11-16)으로 **picker 에서 범위 밖 날짜를 아예 비활성화**해 AS-IS 의도를
            살린다 — 시작일 max=Period 시작일, 종료일 min=Period 종료일. */}
        {fieldSet.period2 && (
          <PeriodField
            gridSize={3}
            label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
            start={sc.period2From}
            end={sc.period2To}
            startMax={sc.periodFrom}
            endMin={sc.periodTo}
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

        {/* Model/Nickname — txtModel2 + btnItemID2. 라벨·팝업 교체는 1차와 동일(2026-10-10 사용자 결정). */}
        {fieldSet.model && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
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
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onModelSearch}
                      />
                    ),
                  }}
                  onChange={e => set({ model: e.target.value })}
                />
              )}
            />
          </Grid>
        )}

        {/* Requestor — txtRequestor + btnRequestor(UserInfoPopup). 표시는 이름, 조회 파라미터는 requestorId.
            AS-IS Designer 좌표상 Requestor(x=914)가 Product Level1(x=1595)보다 앞이라 그 순서로 렌더한다
            (01_layout §usrLayoutControl3 — 종전 역순은 AS-IS 패리티 이탈, 사용자 신고 2026-10-13). */}
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
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onRequestorSearch}
                      />
                    ),
                  }}
                  onChange={e => set({ requestorId: e.target.value, requestorName: '' })}
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
                  // 빈 배열(= ALL 상태)은 value 를 'ALL' 로 내보내야 CustomDropdown 의 SELECT ALL 이
                  //   체크 상태로 유지된다(onChange 가 ALL 선택을 'ALL' 로 보냄 → 스토어는 [] 저장 →
                  //   value 가 ''이면 즉시 꺼져 'ALL 선택이 안 됨'. SSP0005 Div 와 동일 규약). SP 파라미터는
                  //   스토어 [] → '' 그대로라 조회는 영향 없음.
                  value={sc.productLevel12.length ? sc.productLevel12.join(',') : ALL}
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
                  // 빈 배열(= ALL)은 value 를 'ALL' 로 — SELECT ALL 유지(위 Product Level1 주석 참조).
                  value={sc.resultTypes.length ? sc.resultTypes.join(',') : ALL}
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
        {/* Search — 6 sheet 전부 항상 표시(02 §4.2) — 활성 sheet 재조회. Detail 은 F5 로 조회하지
            않으므로 (F5) 없는 평문 'Search'(DETAIL_SEARCH=LBL00664). 상단 Main 검색만 LBL.SEARCH="Search(F5)". */}
        <Button appearance='contained' priority='primary' onClick={onDetailSearch}>
          {t(LBL.DETAIL_SEARCH, '_Search')}
        </Button>
      </Stack>
    </Stack>
  );
};
