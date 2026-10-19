import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo } from 'react';

import type { ComboParam, ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField, Label } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Box, Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useSessionStore, useTabid } from '@shared/stores';

import {
  ALL,
  COMBO,
  EXCLUDED_DIVISION,
  EXCLUDED_STATUS,
  LBL,
  LOOKUP,
  MENU_ID,
  SCREEN_TEXT,
} from '../shipment-change-request-plan.constants';
import type { ComboOption } from '../shipment-change-request-plan.types';
import { useShipmentChangeRequestPlanStore } from '../useShipmentChangeRequestPlanStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
  // New / Insert Multiple 버튼은 조회영역이 아니라 BtnArea(SubTitle customButtons)가 렌더한다
  //   (사용자 지시 2026-09-30). 이 폼의 확장영역은 Single Process 체크박스만 담당한다.
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: (ComboResponse | LookupResponse)[] | undefined): ComboOption[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

/**
 * 조회조건 8필드 (design 02 §1·§5.1·§5.2).
 *   메인 1~2단(8): Div / From Site / To Site / Status / Shipment Date / Model / SO No / Confirm Id
 *   extraConditions(확장 영역): Single Process(chkSingleProcess) + New / Insert Multiple 버튼.
 *     New/Insert Multiple 은 조회영역을 확장했을 때만 노출한다(사용자 지시 2026-09-29) — 항상 보이는
 *     extraButtons 가 아니라 확장 토글 안쪽. AS-IS 조회영역 버튼(btnNew/btnInsertMultiple)의 TO-BE 배치.
 *
 *   Change Type 은 조회조건에서 **제거**했다 — AS-IS `PlanType1.Visibility=Never` 영구 비노출(Δ1) +
 *   런타임 'C'(Confirm) 고정(Δ2). 이전 회차가 "모드 스위치"라며 노출했으나 AS-IS 에 없는 조회조건이라
 *   사용자 확인(2026-09-29) 후 제거했다. changeType 값은 store 기본값 'C' 로 고정 유지된다
 *   (design 01 Δ1/Δ2, L-050, V-05).
 *
 *   필수표시 0건 — AS-IS 조회조건 라벨 중 '*' 로 끝나는 것이 없다(§4.4-②). required 를 임의로 붙이지 않는다.
 *   Designer 잔여 초기값(2013-07-12 / 1999-01-01)은 이식하지 않는다.
 */
export const ShipmentChangeRequestPlanForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();
  const groupId = useSessionStore(s => s.session.groupId);
  const tabId = useTabid();

  const sc = useShipmentChangeRequestPlanStore(s => s.searchParams);
  const set = useShipmentChangeRequestPlanStore(s => s.setSearchParams);
  const setPeriod = useShipmentChangeRequestPlanStore(s => s.setPeriod);
  const changeDivision = useShipmentChangeRequestPlanStore(s => s.changeDivision);
  const setFromSiteAllCodes = useShipmentChangeRequestPlanStore(s => s.setFromSiteAllCodes);
  const singleProcess = useShipmentChangeRequestPlanStore(s => s.singleProcess);
  const setSingleProcess = useShipmentChangeRequestPlanStore(s => s.setSingleProcess);
  const openSearchArea = useShipmentChangeRequestPlanStore(s => s.openSearchArea);

  // cascade 전건 재조회형(§3.2) — 상위 값을 콤보 payload 에 실어 react-query 키로 재조회한다.
  //   Filter* 접두(클라 좁힘) 콤보는 이 화면에 0건이다.
  const divisionFilter: ComboParam = { comboId: COMBO.DIVISION, mnuId: MENU_ID };
  const fromSiteFilter: ComboParam = { comboId: COMBO.FROM_SITE, divisionId: sc.divisionId };
  const toSiteFilter: ComboParam = {
    comboId: COMBO.TO_SITE,
    divisionId: sc.divisionId,
    // 필수: ShipmentPlanToSite_SCP 의 @__GROUP__ 를 FE 가 안 보내면 BE 가 '' 로 치환해
    //   CASE WHEN @__GROUP__='JV Planner' 가 항상 거짓이 되어 JV Planner 의 To Site 목록이 사라진다.
    __GROUP__: groupId,
  };
  const [divisions, fromSites, toSites] = useTabComboQueries({
    filters: [divisionFilter, fromSiteFilter, toSiteFilter],
  });
  const [shipmentStatus] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.SHIPMENT_STATUS }],
  });

  // C2/C3 — CODE 가 정확히 'EE' 인 1건만 제외한다. EE_HD/EE_HG/EE_HM/EE_ST/EE_UC 5건은 남긴다
  //   (ATTRIBUTE3<>'EE' 형 SQL_ID 로 바꾸면 그 5개 법인이 조용히 사라진다).
  const divisionOptions = useMemo(
    () => toOptions((divisions ?? []).filter(r => str(r.CODE) !== EXCLUDED_DIVISION)),
    [divisions]
  );
  const fromSiteOptions = useMemo(() => toOptions(fromSites), [fromSites]);
  const toSiteOptions = useMemo(() => toOptions(toSites), [toSites]);
  // C1 — Status 콤보에서 'P'(Plan) 제거. ALL 선두는 allOption 이 담당(기본 ALL).
  const statusOptions = useMemo(
    () => toOptions((shipmentStatus ?? []).filter(r => str(r.CODE) !== EXCLUDED_STATUS)),
    [shipmentStatus]
  );

  // Division 권한 0건 = 컨트롤 잠금형 게이트(L-127/L-128 / V-08 / design 02 §4.4).
  //   AS-IS 는 권한이 없으면 조회영역 자체를 못 쓰게 만든다 — 메시지만 띄우면 사용자가 계속 조작한다.
  //   콤보 응답 도착 전(undefined)과 0건을 구분한다(로딩 중 비활성 방지).
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;

  // Div 기본값 = 목록 첫 행(AS-IS setListBox 가 DataSource 만 넣어 SelectedIndex=0).
  //   초기 mount 에서 cascade 핸들러를 발화시키지 않는다(AS-IS InitEvent() 가 마지막, §4.1-2)
  //   -> changeDivision() 이 아니라 값만 세팅한다.
  useEffect(() => {
    if (!sc.divisionId && divisionOptions.length > 0) {
      set({ divisionId: divisionOptions[0].value });
    }
  }, [divisionOptions, sc.divisionId, set]);

  // C5 — JVFlag=true 경로에서 콤마 전개할 From Site 권한 전체 코드.
  useEffect(() => {
    setFromSiteAllCodes(fromSiteOptions.map(o => o.value));
  }, [fromSiteOptions, setFromSiteAllCodes]);

  // CustomDropdown multiple 은 선택값을 콤마 문자열로 돌려준다. ALL sentinel 은 payload 에서 '' 로 간다.
  const pickMulti = (picked: string): string[] =>
    picked.split(',').filter(v => v && v !== ALL);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Div — 단일, ALL 없음. 변경 시 From/To Site 재조회 + 그리드·컬럼메타 초기화(hook #5 §1.4). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIV, '_Div.')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noDivisionAuth}
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) => {
                    // Div 변경이 그리드를 초기화하므로 미저장 편집분 유실 전 MSG00704 confirm(공통 가드).
                    //   controlled value={sc.divisionId} 라 취소 시 자동으로 이전 Division 으로 복귀한다.
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) changeDivision(String(picked ?? ''));
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* From Site — 다중 + ALL. 잠정 콤보(VP UNION 없음 — 04 확인필요). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noDivisionAuth}
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.fromSiteIds.join(',')}
                  options={fromSiteOptions}
                  onChange={(_, picked) => set({ fromSiteIds: pickMulti(picked) })}
                />
              )}
            />
          </Grid>

          {/* To Site — 다중 + ALL. @__GROUP__ 전달 필수. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TO_SITE, '_To Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noDivisionAuth}
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.toSiteIds.join(',')}
                  options={toSiteOptions}
                  onChange={(_, picked) => set({ toSiteIds: pickMulti(picked) })}
                />
              )}
            />
          </Grid>

          {/* Status — ALL 선두 + P 제외, 기본 ALL. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.STATUS, '_Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noDivisionAuth}
                  allOption
                  value={sc.status}
                  options={statusOptions}
                  onChange={(_, picked) => set({ status: String(picked ?? ALL) })}
                />
              )}
            />
          </Grid>

          {/* Shipment Date — 기본값은 SCM0001_SCP_DAY_PERIOD_GET 산출(dayjs 근사 아님).
              한계 2건(공용 컴포넌트 축이라 이 화면에서 못 고친다 — 04 확인필요):
                (1) PeriodField 가 FormItem required 를 하드코딩해 '*' 가 붙는다(설계 §6.3 required 0건 위반).
                (2) 전체 비활성 prop 이 없어 Division 권한 0건 게이트에서 이 필드만 조작 가능하게 남는다. */}
          <PeriodField
            gridSize={3}
            label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => setPeriod(start, end)}
          />

          {/* Model/Nickname — 원천은 txtRequest(txtItemId 아님). 돋보기 -> MaterialByDivisionModal(COM0013). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  multiline
                  maxRows={3}
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
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
                />
              )}
            />
          </Grid>

          {/* SO No — 다건(개행/콤마). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SO_NO, '_SO No')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  multiline
                  maxRows={3}
                  className={commonStyles.multilineSearchField}
                  value={sc.erpSoNo}
                  onChange={e => set({ erpSoNo: e.target.value })}
                />
              )}
            />
          </Grid>

          {/* Confirm Id — 다건(개행/콤마). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CONFIRM_ID, '_Confirm ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  multiline
                  maxRows={3}
                  className={commonStyles.multilineSearchField}
                  value={sc.confirmId}
                  onChange={e => set({ confirmId: e.target.value })}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Change Type 조회조건은 렌더하지 않는다 — AS-IS `PlanType1.Visibility=Never` 영구 비노출
              (design 01 Δ1 / L-050 "라벨·콤보 둘 다 렌더 금지" / V-05 "조회조건에 Change Type 콤보가 없다").
              값은 store 에서 'C'(Confirm) 고정이다(Δ2, cs:494 SelectedIndex=1) — 사용자가 바꾸지 않는다.
              (사용자 확인 2026-09-29: AS-IS 에 없는 조회조건이라 제거) */}

          {/* Single Process(chkSingleProcess, 해제 시 동일 ERP_SO_NO 전 행 전파 cs:3904) — 상시 노출.
              New / Insert Multiple 버튼은 BtnArea(SubTitle customButtons)로 이동했다(사용자 지시 2026-09-30). */}
          <Grid size={6}>
            <Box display='flex' gap={2} alignItems='center' height='100%'>
              <Box display='flex' gap={0.5} alignItems='center'>
                {/* @lges Label 은 텍스트를 labelText prop 으로 받는다(children 아님) — children 으로 주면 안 뜬다. */}
                <Label labelText={t(SCREEN_TEXT.SINGLE_PROCESS, { defaultValue: 'Single Process' })} />
                <Checkbox
                  checked={singleProcess}
                  disabled={noDivisionAuth}
                  onChange={setSingleProcess}
                />
              </Box>
            </Box>
          </Grid>
        </>
      }
    />
  );
};
