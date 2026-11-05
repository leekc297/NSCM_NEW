import { MaterialByDivisionModal } from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { PeriodRangePicker, SsoUserModal } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { Stack } from '@shared/mui';
import { useSessionStore } from '@shared/stores';

import { LBL, MENU_ID } from '../shipment-request-pack.constants';
import { useShipmentRequestPackStore } from '../useShipmentRequestPackStore';

import { PopupInput } from './PopupInput';
import styles from './ShipmentRequestPackDetailSearch.module.scss';

interface Props {
  onSearch: () => void;
}

/**
 * usrLayoutControl3 — 상세(Detail) 그리드 전용 보조조회조건(design 01 §1/§3, design 02 §1 #14~19).
 * 디자인·배선은 자매 화면 SSP0015(ShipmentPsiDetailBar) 참고 — 상단 필드 Grid + 우측 Search 버튼의
 * 가로 바(detailBar) 레이아웃, 팝업 필드는 공용 popupSearchField 스타일(PopupInput).
 *
 * Request Detail ↔ Result Detail 시트 전환 시 NickName/Requestor/LotID 3필드가 노출/은닉 토글된다
 * (design 01 R15) — Result Detail 활성 시 렌더하지 않음.
 *
 * 팝업(design 02 §4.6):
 *   - Model(txtItemld2) → btnItemID2 → 공용 ModelByDivisionPopup(Division+Sales Site 기준).
 *   - Requestor(txtRequestor) → btnRequestor → 공용 SsoUserModal(AS-IS UserInfoPopup). 선택 사용자
 *     "이름"을 필드에 넣고 그 이름 문자열을 그대로 조회 파라미터로 쓴다(ID 아님 — §4.6 주의).
 */
export const ShipmentRequestPackDetailSearch = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sp = useShipmentRequestPackStore(state => state.searchParams);
  const setSearchParams = useShipmentRequestPackStore(state => state.setSearchParams);
  const activeDetailSheet = useShipmentRequestPackStore(state => state.activeDetailSheet);
  const langCd = useSessionStore(s => s.session.langCd);
  const isRequestDetail = activeDetailSheet === 'requestDetail';

  const [openModel, setOpenModel] = useState(false);
  const [openRequestor, setOpenRequestor] = useState(false);

  return (
    <Stack direction='row' alignItems='center' className={styles.detailBar}>
      <div className={styles.detailBarFields}>
        <div className={`${styles.detailBarField} ${styles.detailBarDateField}`}>
          <PeriodRangePicker
            className={commonStyles.formItem}
            label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
            start={sp.fromYyyymmdd2}
            end={sp.toYyyymmdd2}
            onChange={(start, end) => setSearchParams({ fromYyyymmdd2: start, toYyyymmdd2: end })}
          />
        </div>
        <div className={styles.detailBarField}>
          <FormItem
            className={`${commonStyles.formItem} ${styles.detailBarFieldItem}`}
            label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
            labelAlign='right'
            render={() => (
              <PopupInput
                value={sp.modelId2}
                // 직접입력은 품번(modelId2) 기준 — 이전 팝업에서 세팅된 nickName2 보조조건을 지운다.
                onChange={v => setSearchParams({ modelId2: v, nickName2: '' })}
                onOpen={() => setOpenModel(true)}
              />
            )}
          />
        </div>
        {isRequestDetail && (
          <>
            <div className={styles.detailBarField}>
              <FormItem
                className={`${commonStyles.formItem} ${styles.detailBarFieldItem}`}
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
            </div>
            <div className={styles.detailBarField}>
              <FormItem
                className={`${commonStyles.formItem} ${styles.detailBarFieldItem}`}
                label={t(LBL.REQUESTOR, '_Requestor')}
                labelAlign='right'
                render={() => (
                  <PopupInput
                    value={sp.requestor}
                    onChange={v => setSearchParams({ requestor: v })}
                    onOpen={() => setOpenRequestor(true)}
                      />
                )}
              />
            </div>
          </>
        )}
      </div>

      <Stack direction='row' className={styles.detailBarButtons}>
        <Button appearance='contained' priority='primary' onClick={onSearch}>
          {t(LBL.SEARCH_GRID, '_Search')}
        </Button>
      </Stack>

      {/* Model/Nickname 팝업 — 공용 MaterialByDivisionModal(COM0013, 사용자 지시 2026-10-22). 하단 상세조회
          Model + NickName 통합 칸. 선택 → 품번(ITEM_ID)=modelId2 + 첫 행 NICK_NAME=nickName2 둘 다 세팅
          (상세 GET SP 의 modelId+nickName 양쪽). Division(40) 단일이라 multiDivision 불요. 종전
          ModelByDivisionPopup 에서 교체 — 한계: Sales Site 축이 없어 기존 salesSite 사전필터는 빠진다(SSP0003 동일). */}
      <MaterialByDivisionModal
        open={openModel}
        modalClose={() => setOpenModel(false)}
        setSelectedValue={(items, _itemName, _itemClassName, nickName) =>
          setSearchParams({ modelId2: items, nickName2: nickName ?? '' })
        }
        preSearchParams={{
          divisionId: sp.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sp.modelId2,
        }}
      />

      {/* Requestor 팝업 — AS-IS btnRequestor → UserInfoPopup. 공용 SsoUserModal 재사용(SSP0015 동일).
          선택 사용자 "이름"(언어별 KO/EN)을 필드에 반영 — 그 이름 문자열이 조회 파라미터(§4.6 주의). */}
      <SsoUserModal
        open={openRequestor}
        modalClose={() => setOpenRequestor(false)}
        setSelectedValue={(userId, userNm, userEngNm) => {
          setSearchParams({ requestor: (langCd === 'KO' ? userNm : userEngNm) || userId });
          setOpenRequestor(false);
        }}
        ssoUserYn='N'
      />
    </Stack>
  );
};
