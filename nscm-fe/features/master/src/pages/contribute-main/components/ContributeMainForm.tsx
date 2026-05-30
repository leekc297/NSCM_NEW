/**
 * DMF0043 Contribute_Main — 조회조건 폼
 * AS-IS: DMF0043_Contribute_Main.Designer.cs — usrYear / chkYear / usrDiscard / usrHis / btnCutOff
 * 4축 매핑: __asis-mapping__.md §5 조회조건 인벤토리
 *
 * usrYear 데이터 출처 (AS-IS .cs:114 InitControls → GetVersionData → DM.DMF0043_GET_MAIN_VARSION_DATA):
 *   SELECT VER_SEQ AS CODE, YYYY || '(' || VERSION_NM || ')' AS NAME2
 *     FROM DM_MST_CONTRIBUTE_VER WHERE VALID_YN = 'Y' ORDER BY YYYY DESC
 *   → 콤보 표시 = NAME2 (예: "2026(Ver01)"), 콤보 값 = CODE (= VER_SEQ)
 */
import { useEffect } from 'react';
import { useTranslation } from 'react-i18next';

import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { MENU_ID } from '../contribute-main.constants';
import { useContributeMainStore } from '../useContributeMainStore';

import styles from './ContributeMainForm.module.scss';

/**
 * AS-IS DM_MST_CONTRIBUTE_VER.VER_SEQ 는 NUMBER 타입 → JS 에 number 로 전달됨.
 * CustomDropdown 의 value 는 string 만 허용 (`value?.trim()` 호출) → String() 명시 변환 필수.
 * NAME2 는 SP 가 YYYY || '(' || VERSION_NM || ')' 로 조립 → 항상 string.
 */
interface VersionRow {
  CODE: string | number;  // VER_SEQ (NUMBER) 또는 후속 변경 대비
  NAME2: string;
}

interface ContributeMainFormProps {
  onSearch?: () => void;
  onOpenContributeRate: () => void;
}

export const ContributeMainForm = ({ onSearch, onOpenContributeRate }: ContributeMainFormProps) => {
  const { t } = useTranslation();

  const searchParams = useContributeMainStore(state => state.searchParams);
  const setSearchParams = useContributeMainStore(state => state.setSearchParams);
  const setFilters = useContributeMainStore(state => state.setFilters);
  const isOpenSearchArea = useContributeMainStore(state => state.isOpenSearchArea);

  // ---------------------------------------------------------------------------
  // YEAR 콤보 — AS-IS GetVersionData → DM.DMF0043_GET_MAIN_VARSION_DATA
  // API 메타: DMF0043_version_SEARCH = PKG_DMF0043.P_DMF0043_GET_MAIN_VARSION_DATA
  // ---------------------------------------------------------------------------
  const { data: versionData } = useTabProcQuery({
    menuId: MENU_ID as never,
    sheetName: 'version' as never,
    tabId: MENU_ID,
    filters: {} as never,
    enabled: true,
  });

  // NUMBER 컬럼 (VER_SEQ) → String 명시 변환 의무 (CustomDropdown value 는 string 만 허용)
  const versionOptions = ((versionData as { o_rc1?: VersionRow[] } | undefined)?.o_rc1 ?? []).map(
    row => ({ label: row.NAME2, value: String(row.CODE) })
  );

  // AS-IS .cs:114~116 — 콤보 채움 후 첫 항목 자동 선택 (가장 최신 YYYY DESC)
  useEffect(() => {
    if (!searchParams.yearId && versionOptions.length > 0) {
      setSearchParams({ yearId: versionOptions[0].value });
    }
  }, [versionOptions, searchParams.yearId, setSearchParams]);

  const onSearchClick = () => {
    if (onSearch) onSearch();
    else setFilters();
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearchClick}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          {/* AS-IS Designer.cs lblYear (Label "Year") + usrYear (Combo 192x20) at (0,0)~(247,25)
              → master 도메인 표준 size=3 (sales-future-price 와 동일 비율, 1093px 기준 ≈ 273px)
              크기 상수: AS-IS Designer 의 ControlSize=(192,20), 라벨 폭 ~55px → 합산 ~247px 매칭 */}
          <Grid size={3}>
            <FormItem
              label={t('LBL_DMF0043_YEAR', '_Year')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  mandatory
                  value={searchParams.yearId}
                  options={versionOptions}
                  onChange={(_, option) => setSearchParams({ yearId: option as string })}
                />
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs chkYear / usrDiscard / usrHis (3 CheckBox 그룹)
              ⚠ AS-IS Designer 에서 3개 모두 Visible=false 로 선언되어 화면 미표시.
                 .cs 본문에도 동적 Visible=true 토글 없음 → 영구 hidden 컨트롤.
                 이벤트 핸들러(chkYear_CheckedChanged 등)는 보존 — 다른 코드 경로에서 호출될 수 있음.
                 표시 여부는 별도 issue 로 검토 권장. */}
          <Grid size={5} sx={{ display: 'flex', alignItems: 'center' }}>
            <Stack direction='row' spacing={2} alignItems='center'>
              <Checkbox
                /* AS-IS .cs:661-703 chkYear_CheckedChanged */
                labelText={t('LBL_DMF0043_CHK_YEAR', '_년도별')}
                checked={searchParams.isYearByYear}
                onChange={checked => setSearchParams({ isYearByYear: checked })}
              />
              <Checkbox
                /* AS-IS .cs:867-871 usrDiscard_Click */
                labelText={t('LBL_DMF0043_DISCARD', '_불일치조회')}
                checked={searchParams.isMismatch}
                onChange={checked => setSearchParams({ isMismatch: checked })}
              />
              <Checkbox
                /* AS-IS .cs:861-865 usrHis_CheckedChanged */
                labelText={t('LBL_DMF0043_HIS', '_History')}
                checked={searchParams.isHistory}
                onChange={checked => setSearchParams({ isHistory: checked })}
              />
            </Stack>
          </Grid>

          {/* AS-IS Designer.cs btnCutOff Location=(627,12) Size=(124,21) → 우측 정렬 + 폭 124px 강제 */}
          <Grid size={4}>
            <Stack direction='row' className={styles.buttonGroup}>
              <Button
                /* AS-IS .cs:535-539 btnCutOff_Click → DMF0043_ContributeRatePopup */
                appearance='outlined'
                priority='normal'
                size='small'
                onClick={onOpenContributeRate}
                style={{ width: 124, minWidth: 124 }}
              >
                {t('LBL_DMF0043_CUT_OFF', '_기여율버전관리')}
              </Button>
            </Stack>
          </Grid>
        </>
      }
    />
  );
};
