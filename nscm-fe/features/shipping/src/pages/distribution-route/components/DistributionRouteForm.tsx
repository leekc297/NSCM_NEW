import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, LBL, VALID_OPTIONS } from '../distribution-route.constants';
import { useDistributionRouteStore } from '../useDistributionRouteStore';

interface Props {
  onSearch: () => void;
  onFromSearch: () => void;
  onToSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건:
//   실 콤보 2 — Trans Mode(전용 콤보 'TransportModeCode', 무파라미터, 다중 체크 + ALL) / Valid(정적 Y/N).
//   AS-IS clbTransMode 는 UsrCheckedList 다중 체크다 — Designer ItemSelectionMode=One 은 하이라이트
//   방식일 뿐 체크 개수를 제한하지 않는다(단일 강제는 OneItemCheckFlag 인데 미설정). GET SP 는
//   UF_FX_STRING_SPLIT 콤마 다중 지원(2026-09-28 DB 실측).
//   From/To Country·City 4 = 텍스트 입력 + 도시검색 버튼(SCM0002 → RegionModal). cascade 없음(§3).
//   dead 콤보(Division/Site/BodType) 신설 금지(design 02 §2.4).
export const DistributionRouteForm = ({ onSearch, onFromSearch, onToSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useDistributionRouteStore(s => s.searchCondition);
  const set = useDistributionRouteStore(s => s.setSearchCondition);
  const openSearchArea = useDistributionRouteStore(s => s.openSearchArea);

  // Trans Mode 후보 — 전용 콤보 'TransportModeCode'(LOOKUP_TYPE 하드코딩, @lookupType 불요). 인용은 getCombo funnel.
  const [transModes] = useTabComboQueries({
    filters: [{ comboId: COMBO.TRANS_MODE }],
  });
  const transModeOptions: Option[] = toOptions(transModes);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* From Country / From City — 텍스트 입력 + 도시검색 (design 02 §2.3/§4.6, LBL00074/LBL00070) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_COUNTRY, '_From Country')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.fromCountry}
                  onChange={e => set({ fromCountry: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_CITY, '_From City')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.fromCity}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onFromSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ fromCity: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* To Country / To City — 텍스트 입력 + 도시검색 (LBL00075/LBL00071) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TO_COUNTRY, '_To Country')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.toCountry}
                  onChange={e => set({ toCountry: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TO_CITY, '_To City')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.toCity}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onToSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ toCity: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Trans Mode — 다중 체크 + SELECT ALL (AS-IS UsrCheckedList 다중 / LBL00025).
              값은 콤마 조인 문자열, 'ALL' sentinel = 미선택/전체(store orEmpty 가 '' 로 치환). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TRANS_MODE, '_Trans Mode')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sc.transportMode}
                  options={transModeOptions}
                  onChange={(_, picked) => set({ transportMode: picked || 'ALL' })}
                />
              )}
            />
          </Grid>

          {/* Valid — Y/N + ALL(전체), 기본 ALL (design 02 §2.2 / LBL00639).
              AS-IS setListBox(dtValidYN, cboValidYN, true, ...) 의 blnAllFlag=true 가 ALL 행을 삽입하고
              로드 시 ALL 선택 → DMF0004 cboActive 와 동일. allOption 이 'ALL' sentinel 을 공급하고
              store orEmpty 가 'ALL'->''(무필터)로 매핑한다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.VALID, '_Valid')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={sc.validYn}
                  options={VALID_OPTIONS}
                  onChange={(_, picked) => set({ validYn: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
