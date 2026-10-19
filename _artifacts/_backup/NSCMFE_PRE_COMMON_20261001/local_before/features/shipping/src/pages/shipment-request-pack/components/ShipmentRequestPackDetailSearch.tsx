import commonStyles from '@foundation/styles/common-styles.module.scss';
import { PeriodRangePicker } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useShipmentRequestPackStore } from '../useShipmentRequestPackStore';

interface Props {
  onSearch: () => void;
}

/**
 * usrLayoutControl3 — 상세(Detail) 그리드 전용 보조조회조건(design 01 §1/§3, design 02 §1 #14~19).
 * Request Detail ↔ Result Detail 시트 전환 시 NickName/Requestor/Requestor버튼/LotID 4필드가
 * 노출/은닉 토글된다(design 01 R15) — Result Detail 활성 시 4필드 렌더하지 않음.
 *
 * 미완(04_react-gap.md): btnRequestor 팝업(UserInfoPopup) 미배선 — 텍스트 직접입력만 우선 반영.
 */
export const ShipmentRequestPackDetailSearch = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sp = useShipmentRequestPackStore(state => state.searchParams);
  const setSearchParams = useShipmentRequestPackStore(state => state.setSearchParams);
  const activeDetailSheet = useShipmentRequestPackStore(state => state.activeDetailSheet);
  const isRequestDetail = activeDetailSheet === 'requestDetail';

  return (
    <Grid container spacing={1} alignItems='center'>
      <Grid size={3}>
        <PeriodRangePicker
          label={t('LBL_SHIPMENT_DATE', 'Shipment Date')}
          start={sp.fromYyyymmdd2}
          end={sp.toYyyymmdd2}
          onChange={(start, end) => setSearchParams({ fromYyyymmdd2: start, toYyyymmdd2: end })}
        />
      </Grid>
      <Grid size={2}>
        <FormItem
          className={commonStyles.formItem}
          label={t('LBL_MODEL', 'Model')}
          labelAlign='right'
          render={() => (
            <InputField
              fullWidth
              value={sp.modelId2}
              onChange={e => setSearchParams({ modelId2: e.target.value })}
            />
          )}
        />
      </Grid>
      {isRequestDetail && (
        <>
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL_LOT_ID', 'Lot ID')}
              labelAlign='right'
              render={() => (
                <InputField fullWidth value={sp.lotId} onChange={e => setSearchParams({ lotId: e.target.value })} />
              )}
            />
          </Grid>
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL_NICK_NAME', 'Nick Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sp.nickName2}
                  onChange={e => setSearchParams({ nickName2: e.target.value })}
                />
              )}
            />
          </Grid>
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL_REQUESTOR', 'Requestor')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sp.requestor}
                  onChange={e => setSearchParams({ requestor: e.target.value })}
                />
              )}
            />
          </Grid>
        </>
      )}
      <Grid size={1}>
        <Button onClick={onSearch}>{t('LBL00514', '_Search')}</Button>
      </Grid>
    </Grid>
  );
};
