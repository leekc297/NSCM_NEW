import { PeriodField } from 'features/master/src/components';

import type { ComboParam, ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { ALL, COMBO, LBL, LOOKUP } from '../shipment-change-request-confirm.constants';
import { useShipmentChangeRequestConfirmStore } from '../useShipmentChangeRequestConfirmStore';

interface Props {
  onSearch: () => void;
  onRequestorSearch: () => void;
  onItemSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: (ComboResponse | LookupResponse)[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 조회조건 7건 — **AS-IS Designer 좌표 그대로 2행 4열**로 배치한다(사용자 지시 2026-10-08).
//   종전엔 Period 만 `extraConditions`(접힘 영역)로 내려가 있어 펼쳐야 보였고 순서도 AS-IS 와 달랐다.
//
//   AS-IS `SSP0202_...Designer.cs` LayoutControlItem 의 Location(X,Y) 실측:
//     Row1(Y=0)  : lcDivision X=0 / layoutControlItem7(From Site) X=294 / PlanType(Status) X=554
//                  / emptySpaceItem1 X=796  ← 4열은 **의도적 빈칸**
//     Row2(Y=25) : layoutControlItem1(Request Date=drpPeriod) X=0 / Requestor X=294
//                  / Model X=554 / PlanType1(Change Type) X=796
//   (X=845·954·1063 의 Approval/Reject/SelfReject 는 Visibility=Never 라 조회영역에 렌더하지 않는다.
//    이 3버튼은 BtnArea 커스텀 버튼으로 이식돼 있다.)
//
//   그래서 메인 8칸(Grid size=3 × 4열 × 2행) = 필드 7 + 빈칸 1 이고 `extraConditions` 는 없다.
//   Request Date 라벨은 AS-IS 문구(`layoutControlItem1.Text`)를 따라 LBL00677 을 명시한다 —
//   공용 PeriodField 기본값 LBL00505('Period')를 쓰면 AS-IS 와 문구가 달라진다.
export const ShipmentChangeRequestConfirmForm = ({ onSearch, onRequestorSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentChangeRequestConfirmStore(s => s.searchCondition);
  const set = useShipmentChangeRequestConfirmStore(s => s.setSearchCondition);
  const setPeriod = useShipmentChangeRequestConfirmStore(s => s.setPeriod);
  const openSearchArea = useShipmentChangeRequestConfirmStore(s => s.openSearchArea);

  // From Site = FromSiteByDivisionOspPack @divisionId(='40'). Division 40 고정이라 param 변경 없으나 규약상 실음.
  const fromSiteFilter: ComboParam = { comboId: COMBO.FROM_SITE, divisionId: sc.divisionId };
  const [fromSites] = useTabComboQueries({ filters: [fromSiteFilter] });
  const [changeStatus] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.CHANGE_REQ_STATUS }] });
  const [changeTypes] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.CHANGE_REQ_TYPE }] });

  const fromSiteOptions = toOptions(fromSites);
  const statusOptions = toOptions(changeStatus);
  const changeTypeOptions = toOptions(changeTypes);
  // Division 은 '40' 고정 단일값 — 콤보 조회 없이 상수 옵션만.
  const divisionOptions: Option[] = [{ label: sc.divisionId, value: sc.divisionId }];

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division — C1 '40' 고정 + disabled(콤보 조회 없음, 상수). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown value={sc.divisionId} options={divisionOptions} disabled />
              )}
            />
          </Grid>

          {/* From Site (다중 + ALL) — FromSiteByDivisionOspPack(divisionId='40'). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.fromSiteIds.join(',')}
                  options={fromSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      fromSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Status — CHANGE_REQ_STATUS, ALL 선두, 기본 Q(Requested). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.STATUS, '_Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={sc.status}
                  options={statusOptions}
                  onChange={(_, picked) => set({ status: String(picked ?? ALL) })}
                />
              )}
            />
          </Grid>

          {/* Row1 4열 — AS-IS `emptySpaceItem1`(X=796, Y=0) 의도적 빈칸. 이게 없으면 Request Date 가
              1행으로 올라와 AS-IS 2행 구성이 깨진다(Change Type 이 Row2 4열이라 자리를 맞춰야 한다). */}
          <Grid size={3} />

          {/* Request Date(기간) — Row2 1열. 기본 D-14(from=오늘-14, to=오늘).
              라벨은 AS-IS `layoutControlItem1.Text="Request Date"` 를 따라 LBL00677 명시
              (PeriodField 기본값 LBL00505='Period' 를 쓰면 AS-IS 와 문구가 다르다). */}
          <PeriodField
            gridSize={3}
            label={t(LBL.REQUEST_DATE, '_Request Date')}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => setPeriod(start, end)}
          />

          {/* Requestor — 입력 + 돋보기(SsoUserModal, 단일선택), 다건(개행/콤마). design 02 §4.6. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.REQUESTOR, '_Requestor')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.requestId}
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
                  onChange={e => set({ requestId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Model/Nickname — 입력 + 돋보기(MaterialByDivisionModal COM0013, division='40'), 다건. design 02 §4.6. */}
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

          {/* Change Type — Row2 4열(AS-IS PlanType1 X=796, Y=26). CHANGE_REQ_TYPE(P/C/N/A),
              ALL 선두, 기본 ALL. 'P' 는 디테일 그리드 컬럼세트 분기 트리거다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CHANGE_TYPE, '_Change Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={sc.changeType}
                  options={changeTypeOptions}
                  onChange={(_, picked) => set({ changeType: String(picked ?? ALL) })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
