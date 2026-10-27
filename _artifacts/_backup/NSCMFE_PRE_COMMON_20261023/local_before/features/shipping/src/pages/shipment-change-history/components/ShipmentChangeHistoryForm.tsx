import dayjs from 'dayjs';
import { useEffect, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  COMBO,
  ELECTRODE_DIVISION_EXACT,
  ELECTRODE_DIVISION_PREFIX,
  LBL,
  MENU_ID,
  MSG,
} from '../shipment-change-history.constants';
import { useShipmentChangeHistoryStore } from '../useShipmentChangeHistoryStore';

import styles from './ShipmentChangeHistoryForm.module.scss';

interface Props {
  onSearch: () => void;
  // Model 팝업 버튼(design 02 §4.6) — 페이지가 ItemByDivisionModal 오픈(division/scmSite 사전필터).
  onOpenModelPopup: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// YYYYMMDD(문자) -> dayjs. 빈값이면 null.
const toDate = (value: string): dayjs.Dayjs | null =>
  value && value.length === 8
    ? dayjs(`${value.slice(0, 4)}-${value.slice(4, 6)}-${value.slice(6, 8)}`)
    : null;

// design 02 조회조건 10건 — main 6(Division/FromSite/ToSite/Incoterms/TransMode/ShipmentDate) +
//   extra 4(Model/SoNo/ConfirmId/Current). 6필드 초과 -> extraConditions 분리(hook #52). 기본포커스=Division.
export const ShipmentChangeHistoryForm = ({ onSearch, onOpenModelPopup }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useShipmentChangeHistoryStore(s => s.searchCondition);
  const set = useShipmentChangeHistoryStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentChangeHistoryStore(s => s.openSearchArea);
  const setDivisionAuth = useShipmentChangeHistoryStore(s => s.setDivisionAuth);
  const resetDivisionAuth = useShipmentChangeHistoryStore(s => s.resetDivisionAuth);

  // 전극(EE) 분기(design 02 §3) — 선택 division 에 EE 계열(코드 'EE' 로 시작)이 하나라도 있으면 EE 전용 콤보.
  const divisionCsv = sc.divisionIds.join(',');
  const isElectrode = sc.divisionIds.some(c => c.startsWith(ELECTRODE_DIVISION_PREFIX));
  const fromSiteComboId = isElectrode ? COMBO.FROM_SITE_EE : COMBO.FROM_SITE_NON_EE;
  const toSiteComboId = isElectrode ? COMBO.TO_SITE_EE : COMBO.TO_SITE_NON_EE;

  // Division = MyDivisionInEE_SCP(권한필터, EE 미제외). 자식 4콤보는 선택 division(@divisionId)로 재조회(cascade,
  //   재조회 방식 — divisionCsv 가 바뀌면 query key 변경으로 자동 refetch, refetch 직접호출 금지 §5-1).
  const [divisions, fromSites, toSites, incoterms, transModes] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      { comboId: fromSiteComboId, mnuId: MENU_ID, divisionId: divisionCsv },
      { comboId: toSiteComboId, mnuId: MENU_ID, divisionId: divisionCsv },
      { comboId: COMBO.INCOTERMS, mnuId: MENU_ID, divisionId: divisionCsv },
      { comboId: COMBO.TRANS_MODE, mnuId: MENU_ID, divisionId: divisionCsv },
    ],
  });

  // Division 후보 = MyDivisionInEE_SCP 결과에서 code==='EE' 만 제외(design 02 §2.2, EE_HD~EE_UC 유지).
  //   MyDivision/FilterMyDivision 재사용 금지(전극 세부 division 삭제 -> EE cascade 붕괴).
  const divisionOptions = toOptions(divisions).filter(o => o.value !== ELECTRODE_DIVISION_EXACT);
  const fromSiteOptions = toOptions(fromSites);
  const toSiteOptions = toOptions(toSites);
  const incotermsOptions = toOptions(incoterms);
  const transModeOptions = toOptions(transModes);

  // 권한 게이트(design 01 §2#1) — 권한 division 0건이면 MSG00667 alert + 조회영역 disable. 콤보 로드 완료 후 판정.
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  const alertedRef = useRef(false);
  useEffect(() => {
    if (noDivisionAuth && !alertedRef.current) {
      alertedRef.current = true;
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
      });
    }
  }, [noDivisionAuth, setAlert, t]);

  // 권한 division 후보를 store 로 올린다(0건 게이트 원천). 콤보 미도착 동안은 reset(page 가 조회 차단).
  const divisionCodesKey = divisionOptions.map(o => o.value).join(',');
  useEffect(() => {
    if (divisions === undefined) {
      resetDivisionAuth();
      return;
    }
    setDivisionAuth(divisionCodesKey ? divisionCodesKey.split(',') : []);
  }, [divisions, divisionCodesKey, setDivisionAuth, resetDivisionAuth]);

  // Division 변경 = 하위 콤보 선택 초기화(design 02 §3 — 후보 집합이 바뀌므로). 재조회는 명시 Search 게이트.
  const handleDivisionChange = (picked: string): void => {
    set({
      divisionIds: picked
        .split(',')
        .filter(v => v && v !== 'ALL'),
      fromSiteIds: [],
      toSiteIds: [],
      incoterms: [],
      transModes: [],
    });
  };

  // CustomDropdown(multiple) onChange 두번째 인자는 콤마 join 문자열 — 객체 stringify 방지(typeof 가드).
  const pickedToCsv = (picked: unknown): string => (typeof picked === 'string' ? picked : '');
  const splitMulti = (picked: unknown): string[] =>
    pickedToCsv(picked)
      .split(',')
      .filter(v => v && v !== 'ALL');

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* (다중, 기본포커스 — design 02 §1 #1 / 01 §4). MyDivisionInEE_SCP + FE code!=='EE'. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  autoFocus
                  multiple
                  allOption
                  useClearIcon
                  disabled={noDivisionAuth}
                  limitTags={1}
                  value={divisionCsv}
                  options={divisionOptions}
                  onChange={(_, picked) => handleDivisionChange(pickedToCsv(picked))}
                />
              )}
            />
          </Grid>

          {/* From Site (다중, EE 분기 comboId — design 02 §1 #2 / §3). */}
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
                  disabled={noDivisionAuth}
                  limitTags={1}
                  value={sc.fromSiteIds.join(',')}
                  options={fromSiteOptions}
                  onChange={(_, picked) => set({ fromSiteIds: splitMulti(picked) })}
                />
              )}
            />
          </Grid>

          {/* To Site (다중, EE 분기 comboId — design 02 §1 #3 / §3). */}
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
                  disabled={noDivisionAuth}
                  limitTags={1}
                  value={sc.toSiteIds.join(',')}
                  options={toSiteOptions}
                  onChange={(_, picked) => set({ toSiteIds: splitMulti(picked) })}
                />
              )}
            />
          </Grid>

          {/* Incoterms (다중, ssp0019_Incoterms_SCP — design 02 §1 #4). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.INCOTERMS, '_Incoterms')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  disabled={noDivisionAuth}
                  limitTags={1}
                  value={sc.incoterms.join(',')}
                  options={incotermsOptions}
                  onChange={(_, picked) => set({ incoterms: splitMulti(picked) })}
                />
              )}
            />
          </Grid>

          {/* Trans Mode (다중, ssp0019_TransportMode_SCP — design 02 §1 #5). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TRANS_MODE, '_Trans Mode')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  disabled={noDivisionAuth}
                  limitTags={1}
                  value={sc.transModes.join(',')}
                  options={transModeOptions}
                  onChange={(_, picked) => set({ transModes: splitMulti(picked) })}
                />
              )}
            />
          </Grid>

          {/* Shipment Date (기간 range — design 02 §1 #6 / §4. 기본 1개월은 page 가 mount 시 세팅). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
              labelAlign='right'
              render={() => (
                <div className={styles.periodWrapper}>
                  <DatePickerCalendar
                    usecase='date'
                    elevation
                    size='small'
                    format='YYYY.MM.DD'
                    disabled={noDivisionAuth}
                    value={toDate(sc.fromDate)}
                    onChange={
                      ((date: dayjs.Dayjs | null) => {
                        set({ fromDate: date?.format('YYYYMMDD') ?? '' });
                      }) as never
                    }
                  />
                  <span className={styles.periodSeparator}>~</span>
                  <DatePickerCalendar
                    usecase='date'
                    elevation
                    size='small'
                    format='YYYY.MM.DD'
                    disabled={noDivisionAuth}
                    mindate={toDate(sc.fromDate) ?? undefined}
                    value={toDate(sc.toDate)}
                    onChange={
                      ((date: dayjs.Dayjs | null) => {
                        set({ toDate: date?.format('YYYYMMDD') ?? '' });
                      }) as never
                    }
                  />
                </div>
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Model (텍스트 콤마 다중 + 팝업 버튼 — design 02 §1 #7/#8 / §4.6). LBL00669. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model')}
              labelAlign='right'
              render={() => (
                <div className={styles.modelWrapper}>
                  <InputField
                    fullWidth
                    disabled={noDivisionAuth}
                    value={sc.itemId}
                    onChange={e => set({ itemId: e.target.value })}
                    onKeyDown={e => e.key === 'Enter' && onSearch()}
                  />
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='...'
                    disabled={noDivisionAuth}
                    onClick={onOpenModelPopup}
                  />
                </div>
              )}
            />
          </Grid>

          {/* SO No (텍스트 콤마 다중 — design 02 §1 #9). LBL01111. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SO_NO, '_SO No')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  value={sc.soNo}
                  onChange={e => set({ soNo: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Confirm ID (텍스트 콤마 다중 — design 02 §1 #10). LBL01063. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CONFIRM_ID, '_Confirm ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  value={sc.confirmId}
                  onChange={e => set({ confirmId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Current (체크박스 — design 02 §1 #11 / 03 §3 SetCheckRow. 그리드 행표시 토글, 서버 재조회 없음). LBL01065. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CURRENT, '_Current')}
              labelAlign='right'
              render={() => (
                <input
                  type='checkbox'
                  disabled={noDivisionAuth}
                  checked={sc.chkCurrent}
                  onChange={e => set({ chkCurrent: e.target.checked })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
