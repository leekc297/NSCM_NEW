import { PeriodField } from 'features/master/src/components';

import type { ComboParam, ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { ALL, COMBO, LBL, LOOKUP } from '../shipment-change-request.constants';
import { useShipmentChangeRequestStore } from '../useShipmentChangeRequestStore';

interface Props {
  onSearch: () => void;
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

// 조회조건 — **자매 SSP0200 과 동일 구성**(사용자 지시 2026-10-08), 단 AS-IS 비노출 2건은 제외한다.
//   메인(7, 전부 Grid size=3): Div(40고정 disabled) / From Site(다중+ALL) / To Site(다중+ALL) /
//     Status(ALL선두, P제외) / Shipment Date(기간) / Model/Nickname(입력+팝업) / Confirm ID(다건)
//   extraConditions: 없음.
//
//   SSP0200 과의 차이 2건 — 둘 다 AS-IS Designer 실측 기반(사용자 지시 "SO No·Single Process 제외"):
//     · SO No        : `lblSONo.Visibility=Never`(Designer:824). `lblSONo.Control=txtSoNo` 라 입력칸까지
//                      감싼 항목이므로 필드 전체가 비노출이다 → 렌더하지 않는다(store erpSoNo 는 '' 유지).
//     · Single Process: SSP0201 Designer 에 `chkSingleProcess` **자체가 없다**(grep 0건) → 만들지 않는다.
//   Plan Type(Change Type) 도 렌더하지 않는다 — `PlanType1.Visibility=Never`(Designer:810), 자매 SSP0200
//     과 동일한 판정이다. 값은 store 에서 'C'(Confirm) 고정이고 기간 재산출 분기는 도달 불가로 보존된다.
export const ShipmentChangeRequestForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentChangeRequestStore(s => s.searchCondition);
  const set = useShipmentChangeRequestStore(s => s.setSearchCondition);
  const setPeriod = useShipmentChangeRequestStore(s => s.setPeriod);
  const openSearchArea = useShipmentChangeRequestStore(s => s.openSearchArea);

  // To Site = ShipmentPlanToSite_SCP @divisionId. From Site = CN-1 콤보(OSP팩 의미 확인필요).
  //   Division 40 고정이라 param 변경은 없으나 규약상 재조회형(콤보 payload 에 divisionId 실음).
  const fromSiteFilter: ComboParam = { comboId: COMBO.FROM_SITE, divisionId: sc.divisionId };
  const toSiteFilter: ComboParam = { comboId: COMBO.TO_SITE, divisionId: sc.divisionId };

  const [divisions, fromSites, toSites] = useTabComboQueries({
    filters: [COMBO.DIVISION, fromSiteFilter, toSiteFilter],
  });
  const [shipmentStatus] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.SHIPMENT_STATUS }] });

  // Division: MyDivision(EE 제외 WHERE 내장) — combo-semantic-parity 상 화면에서도 EE 방어(§2.6).
  const divisionOptions = toOptions((divisions ?? []).filter(r => str(r.ATTRIBUTE3) !== 'EE'));
  const fromSiteOptions = toOptions(fromSites);
  const toSiteOptions = toOptions(toSites);
  // Status: P(Plan) 제외 + ALL 선두(allOption), 기본 ALL.
  const statusOptions = toOptions((shipmentStatus ?? []).filter(r => str(r.CODE) !== 'P'));

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* — R3 '40' 고정 + disabled(콤보 표시하되 변경불가). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown value={sc.divisionId} options={divisionOptions} disabled />
              )}
            />
          </Grid>

          {/* From Site (다중 + ALL) — CN-1 콤보(OSP팩 의미 확인필요). */}
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

          {/* To Site (다중 + ALL) — ShipmentPlanToSite_SCP @divisionId. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TO_SITE, '_To Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.toSiteIds.join(',')}
                  options={toSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      toSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Plan Type(Change Type) 조회조건은 렌더하지 않는다 — AS-IS `PlanType1.Visibility=Never`
              (Designer:810) 로 영구 비노출이고, 자매 SSP0200 도 같은 근거로 제거했다.
              값은 store 에서 'C'(Confirm) 고정이라 사용자가 바꾸지 않는다 — `changePlanType`(기간
              재산출 cascade)은 store 에 보존하되 호출부가 없어 도달 불가다. */}

          {/* Status — SHIPMENT_STATUS, P(Plan) 제외 + ALL 선두, 기본 ALL. */}
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
                  onChange={(_, picked) => set({ status: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* Shipment Date — 기본 30일. 자매 SSP0200 과 같은 자리(Status 다음)·같은 라벨로 둔다.
              주의: PeriodField 가 FormItem required 를 하드코딩해 '*' 가 붙는다(공용 컴포넌트 축). */}
          <PeriodField
            gridSize={3}
            label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => setPeriod(start, end)}
          />

          {/* Model/Nickname — 입력 + 돋보기(MaterialByDivisionModal, COM0013), 다건(개행/콤마). design 02 §4.6. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  // 다건(개행/콤마) 입력 — store 의 multiLine() 이 `[\n,]` 로 분해해 SP IN 절로 보내는데
                  //   multiline 이 없어 개행을 아예 못 넣었다(자매 SSP0200 은 multiline+maxRows=3).
                  multiline
                  maxRows={3}
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

          {/* Confirm ID — 다건(개행/콤마). 자매 SSP0200 과 같은 자리(Model/Nickname 다음, 메인 영역).
              SO No 는 바로 이 앞에 오지만 AS-IS 비노출이라 렌더하지 않는다(상단 주석 참조). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CONFIRM_ID, '_Confirm ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  multiline
                  maxRows={3}
                  // 기본 multiline 은 상단 정렬이라 같은 행의 콤보·popup 필드와 글자 세로 위치가
                  //   어긋난다(자매 SSP0200 a8dffcd0 과 동일 처방 — 정렬만 떼어낸 공용 클래스).
                  className={commonStyles.multilineSearchField}
                  value={sc.confirmId}
                  onChange={e => set({ confirmId: e.target.value })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
