import dayjs from 'dayjs';
import { useEffect, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { createMultilinePasteHandler } from '@shared/paste';
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
  // Model/Nickname 팝업 버튼(design 02 §4.6) — 페이지가 공용 MaterialByDivisionModal 오픈(division 사전필터).
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

// design 02 조회조건 10건 — main 8(Division/FromSite/ToSite/Incoterms/Current/ShipmentDate/Model/SoNo) +
//   extra 2(ConfirmId/TransMode). Model/SoNo 를 2번째 줄로 올려 main 에 배치(사용자 지시 2026-10-22).
//   Current 를 AS-IS 처럼 Incoterms 뒤로, Trans Mode 를 조회조건 맨 끝으로 이동(사용자 지시 2026-11-02). 기본포커스=Division.
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

          {/* Current (체크박스 — design 02 §1 #11 / 03 §3 SetCheckRow. 그리드 행표시 토글, 서버 재조회 없음). LBL01065.
              조회 조건이 아니라 표시 토글(체크=LAST_SEQ='C' 현재값 행만, 해제=전행). AS-IS 는 1번째 줄 Incoterms 뒤
              맨 오른쪽에 위치 — 그 순서에 맞춰 Incoterms 바로 뒤(5번째 칸, Div 아래 열)로 배치(사용자 지시 2026-11-02).
              정렬: 공통 라벨 열(140px)을 모사해 '☐ Current' 를 라벨 열 안에서 우측 정렬 → 'Current' 글자가 윗줄 'Div'
              라벨과 같은 x 에서 끝난다(사용자 지시 2026-11-02 "들여쓰기 더, Div 아래 정렬"). 체크박스는 라벨 왼쪽으로
              돌출(박스 앞·라벨 뒤 = AS-IS 캡션 우측 모양 유지). styles.currentField/currentLabelSlot 참조. */}
          <Grid size={3}>
            <div className={styles.currentField}>
              <div className={styles.currentLabelSlot}>
                <Checkbox
                  labelText={t(LBL.CURRENT, '_Current')}
                  disabled={noDivisionAuth}
                  checked={sc.chkCurrent}
                  onChange={checked => set({ chkCurrent: checked })}
                />
              </div>
            </div>
          </Grid>

          {/* Shipment Date (기간 range — design 02 §1 #6 / §4. 기본 1개월은 page 가 mount 시 세팅).
              피커 스타일은 SSP0012 PeriodField 와 동일(datePickerFix 36px 높이 정합 + periodSplit 분리 레이아웃).
              PeriodField 는 label·required(*) 가 FormItem 에 고정 묶음이라 컴포넌트는 재사용하지 않고
              SSP0019 자체 FormItem(필수 아님) 을 유지한 채 스타일만 맞춘다(사용자 지시 2026-10-22). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
              labelAlign='right'
              render={() => (
                <div className={styles.periodSplit}>
                  <div className={styles.datePickerFix}>
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
                  </div>
                  <span className={styles.periodSep}>~</span>
                  <div className={styles.datePickerFix}>
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
                </div>
              )}
            />
          </Grid>

          {/* Model/Nickname (텍스트 콤마 다중 + 팝업 돋보기 — design 02 §1 #7/#8 / §4.6). LBL00618.
              2번째 줄(Trans Mode·Shipment Date 뒤)로 이동(사용자 지시 2026-10-22). 트리거는 SSP0012 Model
              필드와 동일 구조(FunctionSearchIcon endAdornment). 호출 팝업은 공용 MaterialByDivisionModal(page onOpenModelPopup). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  disabled={noDivisionAuth}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={noDivisionAuth}
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onOpenModelPopup}
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

          {/* SO No (텍스트 콤마 다중 — design 02 §1 #9). LBL01111. 2번째 줄로 이동(사용자 지시 2026-10-22). */}
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
                  inputProps={{
                    onPaste: createMultilinePasteHandler(
                      () => sc.soNo,
                      next => set({ soNo: next }),
                    ),
                  }}
                  onChange={e => set({ soNo: e.target.value })}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
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
                  inputProps={{
                    onPaste: createMultilinePasteHandler(
                      () => sc.confirmId,
                      next => set({ confirmId: next }),
                    ),
                  }}
                  onChange={e => set({ confirmId: e.target.value })}
                />
              )}
            />
          </Grid>

          {/* Trans Mode (다중, ssp0019_TransportMode_SCP — design 02 §1 #5). AS-IS 는 조회조건 맨 끝(Confirm ID
              뒤, 2번째 줄 우측)에 위치 — 그 순서에 맞춰 조회조건 마지막으로 이동(사용자 지시 2026-11-02).
              라벨 LBL01221('TransportMode', KO/EN/CN 전건 등록) — AS-IS 표시문구 일치(사용자 지시 2026-11-02). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TRANS_MODE, '_TransportMode')}
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
        </>
      }
    />
  );
};
