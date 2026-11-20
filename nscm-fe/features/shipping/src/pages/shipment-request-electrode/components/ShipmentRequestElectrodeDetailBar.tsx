import commonStyles from '@foundation/styles/common-styles.module.scss';
import { PeriodRangePicker } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Stack } from '@shared/mui';
import { createMultilinePasteHandler } from '@shared/paste';

import { LBL } from '../shipment-request-electrode.constants';
import { useShipmentRequestElectrodeStore } from '../useShipmentRequestElectrodeStore';

interface Props {
  // btnSearch — 활성 Detail 탭(요청상세/재고상세) 재조회. AS-IS usrLayoutControl3 btnSearch.
  onDetailSearch: () => void;
  // btnItemID2 → MaterialByDivisionModal(page 소유, SSP0023 동일). 2차 Material 팝업.
  onItemSearch2: () => void;
  // 2차 Model/Nickname 돋보기 → MaterialByDivisionModal(page 소유, SSP0023 동일, 사용자 지시 2026-10-22).
  onModelSearch2: () => void;
  // btnRequestor → SsoUserModal(page 소유, AS-IS UserInfoPopup). 요청상세 탭 전용 Requestor 팝업.
  onRequestorSearch: () => void;
}

/**
 * 2차 조회조건 바(usrLayoutControl3 — spdDetail 상단, design 02 §1 2차 필드). 활성 상세 탭에 따라
 * 노출 필드가 토글된다(AS-IS SpdDetail_ActiveSheetChanged cs:1357-1382):
 *   - 공통: Material(txtItemId2 + 팝업) · Model/Nickname(txtModelId2 + 팝업, Model+NickName 통합) · Search.
 *   - 요청상세(Shipment Request Detail) 탭: Shipment ETA(drpPeriod2) + Requestor(txtRequestor + 팝업). Lot ID 숨김.
 *   - 재고상세(Stock Detail) 탭: Lot ID(txtLotID). Shipment ETA·Requestor 숨김.
 *   - 각 상세 SP IN 집합(setDetailFilters): 요청상세 = modelId2/itemId2/nickName2/period2/requestor,
 *     재고상세 = modelId2/itemId2/lotId(요청상세는 AS-IS p_lot_id="" 로 Lot ID 미사용, cs:2291-2292).
 */
export const ShipmentRequestElectrodeDetailBar = ({
  onDetailSearch,
  onItemSearch2,
  onModelSearch2,
  onRequestorSearch,
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
              inputProps={{
                onPaste: createMultilinePasteHandler(
                  () => sp.itemId2,
                  next => setSearchParams({ itemId2: next }),
                ),
              }}
              onChange={e => setSearchParams({ itemId2: e.target.value })}
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
              inputProps={{
                onPaste: createMultilinePasteHandler(
                  () => sp.modelId2,
                  next => setSearchParams({ modelId2: next, nickName2: '' }),
                ),
              }}
              onChange={e => setSearchParams({ modelId2: e.target.value, nickName2: '' })}
            />
          )}
        />
        {/* Requestor — txtRequestor + btnRequestor 팝업(SsoUserModal, page 소유, AS-IS UserInfoPopup).
            요청상세 탭 전용(AS-IS layoutControlItem26/28 Always/Never 토글, cs:1362-1374). 선택 사용자 "이름"을
            그대로 조회 파라미터(P_REQUESTOR_ID)로 쓴다(ID 아님 — design 02 §4.6). */}
        {activeDetailTab === 'requestDetail' && (
          <FormItem
            className={commonStyles.formItem}
            label={t(LBL.REQUESTOR, '_Requestor')}
            labelAlign='right'
            render={() => (
              <InputField
                fullWidth
                className={commonStyles.popupSearchField}
                value={sp.requestor}
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
                onChange={e => setSearchParams({ requestor: e.target.value })}
              />
            )}
          />
        )}
        {/* Lot ID — txtLotID. 재고상세 탭 전용(AS-IS layoutControlItem17 Always/Never 토글, cs:1364/1375).
            재고상세 SP p_lot_id. 요청상세 탭에서는 AS-IS 가 p_lot_id="" 로 미사용(cs:2291-2292). */}
        {activeDetailTab === 'stockDetail' && (
          <FormItem
            className={commonStyles.formItem}
            label={t(LBL.LOT_ID, '_Lot ID')}
            labelAlign='right'
            render={() => (
              <InputField
                fullWidth
                value={sp.lotId}
                onChange={e => setSearchParams({ lotId: e.target.value })}
              />
            )}
          />
        )}
      </Stack>
      <Button appearance='contained' priority='primary' onClick={onDetailSearch}>
        {t(LBL.SEARCH_GRID, '_Search')}
      </Button>
    </Stack>
  );
};
