import commonStyles from '@foundation/styles/common-styles.module.scss';
import { PeriodRangePicker } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Stack } from '@shared/mui';

import { LBL } from '../shipment-request-electrode.constants';
import { useShipmentRequestElectrodeStore } from '../useShipmentRequestElectrodeStore';

interface Props {
  // btnSearch — 활성 Detail 탭(요청상세/재고상세) 재조회. AS-IS usrLayoutControl3 btnSearch.
  onDetailSearch: () => void;
  // btnItemID2 → MaterialByDivisionModal(page 소유, SSP0023 동일). 2차 Material 팝업.
  onItemSearch2: () => void;
  // 2차 Model/Nickname 돋보기 → MaterialByDivisionModal(page 소유, SSP0023 동일, 사용자 지시 2026-10-22).
  onModelSearch2: () => void;
}

/**
 * 2차 조회조건 바(usrLayoutControl3 — spdDetail 상단, design 02 §1 2차 필드). 노출 필드 =
 * Material(txtItemId2 + 팝업) · Model/Nickname(txtModelId2 + 팝업, Model+NickName 통합) · Lot ID(txtLotID) · Search.
 *   - Material·Model/Nickname 은 MaterialByDivisionModal(page 소유, SSP0023 동일)로 itemId2 / modelId2+nickName2 세팅.
 *   - 각 상세 SP IN 집합(setFilters): 요청상세 = modelId2/itemId2/nickName2/period2, 재고상세 = modelId2/itemId2/lotId.
 */
export const ShipmentRequestElectrodeDetailBar = ({
  onDetailSearch,
  onItemSearch2,
  onModelSearch2,
}: Props) => {
  const { t } = useTranslation();

  const sp = useShipmentRequestElectrodeStore(state => state.searchParams);
  const setSearchParams = useShipmentRequestElectrodeStore(state => state.setSearchParams);
  // Shipment ETA(drpPeriod2)는 AS-IS SpdDetail_ActiveSheetChanged(cs:1361-1386)에서 Shipment Request Detail
  //   탭일 때만 표시(item27 Always), Stock Detail 탭에선 숨김(Never). 활성 탭으로 조건부 렌더(사용자 확인 2026-10-26).
  const activeDetailTab = useShipmentRequestElectrodeStore(state => state.activeDetailTab);

  return (
    <Stack
      direction='row'
      alignItems='center'
      justifyContent='space-between'
      sx={{ px: 1, py: 0.5, gap: 2 }}
    >
      <Stack direction='row' alignItems='center' sx={{ gap: 2, flexWrap: 'nowrap' }}>
        {/* Shipment ETA — drpPeriod2 날짜범위(AS-IS usrLayoutControl3, layoutControlItem27.Text="Shipment ETA").
            Shipment Request Detail 탭일 때만 표시(AS-IS 토글). 편집 가능(AS-IS Enabled 미차단), Plan Date 선택 시
            자동 초기화(Form handlePlanDateChange). 요청상세 SP IN fromYyyymmdd/toYyyymmdd(= fromYyyymmdd2/toYyyymmdd2). */}
        {activeDetailTab === 'requestDetail' && (
          <PeriodRangePicker
            className={commonStyles.formItem}
            label={t(LBL.SHIPMENT_ETA, 'Shipment ETA')}
            start={sp.fromYyyymmdd2}
            end={sp.toYyyymmdd2}
            onChange={(start, end) => setSearchParams({ fromYyyymmdd2: start, toYyyymmdd2: end })}
          />
        )}
        {/* Material — txtItemId2 + btnItemID2 팝업(MaterialByDivisionModal, page 소유). 빈 반환 시 기존값 유지. */}
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.MATERIAL, '_Material')}
          labelAlign='right'
          render={() => (
            <InputField
              fullWidth
              className={commonStyles.popupSearchField}
              value={sp.itemId2}
              InputProps={{
                endAdornment: (
                  <Button
                    appearance='outlined'
                    priority='normal'
                    iconComponent={<FunctionSearchIcon appearance='lined' />}
                    onClick={onItemSearch2}
                  />
                ),
              }}
              onChange={e => setSearchParams({ itemId2: e.target.value })}
              onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
            />
          )}
        />
        {/* Model/Nickname — txtModelId2 + 돋보기(MaterialByDivisionModal, page 소유). Model + NickName 통합
            (사용자 지시 2026-10-22). 팝업 선택 → 품번(ITEM_ID)=modelId2 + 닉네임(NICK_NAME)=nickName2 둘 다 세팅
            (요청상세 SP p_model_id + p_nick_name). 직접입력은 품번(modelId2)만, nickName2 는 비운다. */}
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.MODEL, '_Model/Nickname')}
          labelAlign='right'
          render={() => (
            <InputField
              fullWidth
              className={commonStyles.popupSearchField}
              value={sp.modelId2}
              InputProps={{
                endAdornment: (
                  <Button
                    appearance='outlined'
                    priority='normal'
                    iconComponent={<FunctionSearchIcon appearance='lined' />}
                    onClick={onModelSearch2}
                  />
                ),
              }}
              onChange={e => setSearchParams({ modelId2: e.target.value, nickName2: '' })}
              onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
            />
          )}
        />
        {/* Lot ID — txtLotID. 재고상세 SP p_lot_id. */}
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.LOT_ID, '_Lot ID')}
          labelAlign='right'
          render={() => (
            <InputField
              fullWidth
              value={sp.lotId}
              onChange={e => setSearchParams({ lotId: e.target.value })}
              onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
            />
          )}
        />
      </Stack>
      <Button appearance='contained' priority='primary' onClick={onDetailSearch}>
        {t(LBL.SEARCH_GRID, '_Search')}
      </Button>
    </Stack>
  );
};
