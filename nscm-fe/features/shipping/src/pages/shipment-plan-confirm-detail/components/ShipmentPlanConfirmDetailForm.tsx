import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { sessionTimeZone } from '@foundation/utils';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { createMultilinePasteHandler } from '@shared/paste';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  ALL,
  COMBO,
  EE_DIVISION,
  LBL,
  MENU_ID,
  MSG,
  PERIOD_BUSINESS_DAYS,
} from '../shipment-plan-confirm-detail.constants';
import { useShipmentPlanConfirmDetailStore } from '../useShipmentPlanConfirmDetailStore';

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

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 6건 — 1.5단(6칸)이라 접기 없이 전량 conditions.
//   SRCH-02: 8칸(2단) 초과 시에만 extraConditions 로 분리하고, 그때만 SearchArea 가 펼침/닫기 토글을 렌더.
//   Division(다중, EE 제외) / From Site(다중+ALL, EE/비-EE 재조회) / Model(입력+SCM0002 팝업) /
//   Period*(오늘~+55영업일) / Sold To Party(자유) / Ship To Party(자유)
export const ShipmentPlanConfirmDetailForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useShipmentPlanConfirmDetailStore(s => s.searchCondition);
  const set = useShipmentPlanConfirmDetailStore(s => s.setSearchCondition);
  const setDivisions = useShipmentPlanConfirmDetailStore(s => s.setDivisions);
  const setDivisionCodes = useShipmentPlanConfirmDetailStore(s => s.setDivisionCodes);
  const setPeriod = useShipmentPlanConfirmDetailStore(s => s.setPeriod);
  const openSearchArea = useShipmentPlanConfirmDetailStore(s => s.openSearchArea);
  const hasDivisionAuth = useShipmentPlanConfirmDetailStore(s => s.hasDivisionAuth);
  const setDivisionAuth = useShipmentPlanConfirmDetailStore(s => s.setDivisionAuth);
  const setServerPeriod = useShipmentPlanConfirmDetailStore(s => s.setServerPeriod);

  // Division = MyDivisionInEE_SCP(권한 @sesUserId·@mnuId 세션). From Site = EE/비-EE 분기 재조회.
  //   design 02 §3: 선택 division 에 'EE' 부분문자열 포함 시 EE 콤보(ShipmentPlanPlantSite_SCP), else 비-EE.
  const hasEeDivision = sc.divisionIds.some(d => d.includes(EE_DIVISION));
  const fromSiteComboId = hasEeDivision ? COMBO.FROM_SITE_EE : COMBO.FROM_SITE_NON_EE;
  const divisionFilter: ComboParam = { comboId: COMBO.DIVISION, mnuId: MENU_ID };
  const fromSiteFilter: ComboParam = {
    comboId: fromSiteComboId,
    mnuId: MENU_ID,
    divisionId: sc.divisionIds.join(','),
  };

  // Period 기본구간 — AS-IS GetDayRange(cs:588-608): SCM0001_GET_SCP_DAY_PERIOD(@fromDate=''(서버가 timezone
  //   으로 '오늘' 산출), @offsetDay='55', @timeZone=sessionTimeZone(session) 사용자 등록 timezone). 종전 fromDate=
  //   클라 dayjs today + timeZone='' 는 브라우저 timezone 의존이라 비-KST 사용자 날짜경계 오차(2026-11-12 교정).
  const tmzCd = sessionTimeZone(useSessionStore(state => state.session));
  const dayPeriodFilter: ComboParam = {
    comboId: COMBO.DAY_PERIOD,
    mnuId: MENU_ID,
    fromDate: '',
    offsetDay: String(PERIOD_BUSINESS_DAYS),
    timeZone: tmzCd,
  };

  const [divisions, fromSites, dayPeriod] = useTabComboQueries({
    filters: [divisionFilter, fromSiteFilter, dayPeriodFilter],
  });

  // Period 기본값 서버 구간 반영 — 콤보 결과 CODE="from:to"(자매 shipment-plan-mobility-it ShipmentPsiForm 동일).
  //   파라미터(오늘) 불변이라 1회 도착하며, 그 시점에 store 의 dayjs 초기 근사를 AS-IS 서버 구간으로 덮는다.
  useEffect(() => {
    const [from, to] = str(dayPeriod?.[0]?.CODE).split(':');
    if (from && to) setServerPeriod(from, to);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dayPeriod]);

  // Division: MyDivisionInEE_SCP(EE 미제외) — AS-IS cs:237 클라 후처리 CODE!=='EE'(정확히 'EE') 재현.
  //   EE_HD/EE_HG 등 부분문자열 코드는 유지(EE 분기 도달 대상).
  const divisionOptions = toOptions(
    (divisions ?? []).filter(r => str(r.CODE) !== EE_DIVISION)
  );
  const fromSiteOptions = toOptions(fromSites);

  // L1 권한 게이트(design 01 §2): MyDivision(EE 제외) 0건이면 조회영역 disable + 안내(MSG00667 "No authority assigned.").
  const divisionsLoaded = divisions !== undefined;
  const noAuth = divisionsLoaded && divisionOptions.length === 0;

  // 권한 division 코드 전체(EE 제외) store 반영 — Div=ALL 전개 원천(GET 필터·Model 팝업).
  //   Form 은 조회영역 접힘 시 언마운트되므로 page(Model 팝업)가 쓰도록 store 에 올린다.
  useEffect(() => {
    if (!divisionsLoaded) return;
    setDivisionCodes(divisionOptions.map(o => o.value));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionsLoaded, divisions]);
  useEffect(() => {
    if (!divisionsLoaded) return;
    setDivisionAuth(!noAuth);
    if (noAuth) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_AUTHORITY, '__No authority assigned.'),
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionsLoaded, noAuth]);

  const disabled = !hasDivisionAuth;

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division (다중, EE 제외) — cascade parent. 변경 시 From Site 초기화 + Period 리셋(페이지 store). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIV, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  disabled={disabled}
                  value={sc.divisionIds.join(',')}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    setDivisions(
                      String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== ALL)
                    )
                  }
                />
              )}
            />
          </Grid>

          {/* From Site (다중 + ALL) — EE/비-EE 재조회 콤보(@divisionId). 클라 필터 아님(design 02 §6-2). */}
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
                  disabled={disabled}
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

          {/* Model — 입력 + 돋보기(AS-IS SCM0002_ItembyDivisionPopup → TO-BE MaterialByDivisionModal COM0013, 사용자 지시 2026-10-22), 다건(개행/콤마). design 02 §4.6. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  disabled={disabled}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={disabled}
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onItemSearch}
                      />
                    ),
                  }}
                  inputProps={{
                    onPaste: createMultilinePasteHandler(
                      () => sc.itemId,
                      next => set({ itemId: next }),
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                />
              )}
            />
          </Grid>

          {/* Period* (필수) — 기본 오늘~+55영업일(SCM0001_GET_SCP_DAY_PERIOD, SP 미배포라 클라 근사).
              필수(*)는 라벨 표기 + 조회 가드(페이지 handleSearch)로 강제. PeriodField 는 disabled prop 미지원. */}
          <PeriodField
            gridSize={3}
            label={`${t(LBL.PERIOD, '_Period')}*`}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => setPeriod(start, end)}
          />

          {/* Sold To Party — 자유 텍스트(SP p_Sold_To_Party). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SOLD_TO_PARTY, '_Sold To Party')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={disabled}
                  value={sc.soldToParty}
                  onChange={e => set({ soldToParty: e.target.value })}
                />
              )}
            />
          </Grid>

          {/* Ship To Party — 자유 텍스트(SP p_Ship_To_Party). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SHIP_TO_PARTY, '_Ship To Party')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={disabled}
                  value={sc.shipToParty}
                  onChange={e => set({ shipToParty: e.target.value })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
