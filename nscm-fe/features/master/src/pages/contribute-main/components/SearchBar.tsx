import { useEffect, useMemo } from 'react';

import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Checkbox, FormItem, Label } from '@shared/lges';
import { Grid } from '@shared/mui';

import { MENU_ID, SHEETS } from '../contribute-main.constants';
import styles from '../ContributeMain.module.scss';
import { useContributeMainStore } from '../useContributeMainStore';

interface VersionOption extends WijmoRowItem {
  CODE: string;
  NAME2: string;
  NAME: string;
}

interface Props {
  onSearch: () => void;
}

// AS-IS DMF0043_Contribute_Main 조회 영역.
//   - usrYear (Combo)        : GET_MAIN_VARSION_DATA SP → CustomDropdown
//   - chkYear (Checkbox)     : 년도별 필터 — Grid 측에서 store 구독 (재조회 X)
//   - usrDiscard (Checkbox)  : 불일치 조회 — dis='N' / his='N' 강제 + 즉시 onSearch
//   - usrHis (Checkbox)      : History     — his='Y' / dis='ALL' 강제 + 즉시 onSearch
// 표준: SearchArea + FormItem + CustomDropdown + Checkbox (lges)
export const SearchBar = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const openSearchArea = useContributeMainStore(s => s.openSearchArea);
  const searchParams = useContributeMainStore(s => s.searchParams);
  const setSearchParams = useContributeMainStore(s => s.setSearchParams);

  // 년도 콤보 — DMF0043_GET_MAIN_VARSION_DATA standalone SP (combo 가 admin DB 미등재).
  const { data: yearData } = useTabProcQuery<typeof MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
    filters: {},
    enabled: true,
  });

  const yearOptions = useMemo<VersionOption[]>(
    () => (yearData?.o_rc1 ?? []) as VersionOption[],
    [yearData]
  );

  // AS-IS InitControls — 첫 옵션 자동 선택.
  useEffect(() => {
    if (yearOptions.length === 0) return;
    if (searchParams.verSeq) return;
    const first = yearOptions[0];
    setSearchParams({
      verSeq: String(first.CODE ?? ''),
      yyyy: String(first.NAME2 ?? first.NAME ?? '').substring(0, 4),
    });
  }, [yearOptions]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={4}>
            <FormItem
              label={t('LBL00002', '_Year')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.verSeq}
                  options={yearOptions.map(o => ({
                    label: String(o.NAME2 ?? o.NAME ?? o.CODE),
                    value: String(o.CODE ?? ''),
                  }))}
                  onChange={(_, option) => {
                    const opt = yearOptions.find(o => String(o.CODE) === option);
                    setSearchParams({
                      verSeq: option,
                      yyyy: String(opt?.NAME2 ?? opt?.NAME ?? '').substring(0, 4),
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={2}>
            <FormItem
              render={() => (
                <div className={styles.customCheckbox}>
                  <Checkbox
                    checked={searchParams.chkYear}
                    onChange={checked => setSearchParams({ chkYear: checked })}
                  />
                  <Label labelText={t('LBL00601', '_By Year')} depth='sub' />
                </div>
              )}
            />
          </Grid>
          <Grid size={2}>
            <FormItem
              render={() => (
                <div className={styles.customCheckbox}>
                  <Checkbox
                    checked={searchParams.dis === 'N'}
                    onChange={checked => {
                      setSearchParams({ dis: checked ? 'N' : 'ALL', his: 'N' });
                      // 다음 paint 후 onSearch — state 반영 보장 (AS-IS usrDiscard_Click).
                      setTimeout(onSearch, 0);
                    }}
                  />
                  <Label labelText={t('LBL00602', '_Discard')} depth='sub' />
                </div>
              )}
            />
          </Grid>
          <Grid size={2}>
            <FormItem
              render={() => (
                <div className={styles.customCheckbox}>
                  <Checkbox
                    checked={searchParams.his === 'Y'}
                    onChange={checked => {
                      setSearchParams({ his: checked ? 'Y' : 'N', dis: 'ALL' });
                      setTimeout(onSearch, 0);
                    }}
                  />
                  <Label labelText={t('LBL00603', '_History')} depth='sub' />
                </div>
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
