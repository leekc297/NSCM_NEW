import { useEffect, useMemo } from 'react';

import { apiClient } from '@foundation/apis';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField, Label } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { MENU_ID, SHEETS } from '../contribute-view.constants';
import type { VersionOption, ViewSearchCondition } from '../types';
import { useContributeViewStore } from '../useContributeViewStore';

// admin /search-conditions 응답 row 의 paramNm 키 (ViewSearchCondition 의 string-valued 키만)
type SearchParamProps = Pick<
  ViewSearchCondition,
  'yyyy' | 'verSeq' | 'versionNo' | 'divisionId' | 'endCustReport' | 'productGroup' | 'bizType'
>;

interface Props {
  onSearch: () => void;
  onOpenVersionPopup: () => void; // AS-IS btnSPVer_Click (.cs L453)
}

// AS-IS DMF0043_Contribute_View Designer.cs 조회조건 9 컨트롤 1:1 매핑
//   usrYear      (UsrCombo, DropDownList)         → Year SP 콤보 (SHEETS.VERSION SP)
//   txtVersion   (UsrMultiLineEditor, readonly)   → Version (btnSPVer 로만 채움)
//   btnSPVer     (UsrButton, image)               → Version popup trigger (InputField endAdornment)
//   usrCust      (UsrMultiLineEditor, free-form)  → 고객군 (InputField)
//   usrType      (UsrCombo, DropDownList)         → 제품군 (CustomDropdown — ReportGroup3 lookup)
//   usrBiz       (UsrCombo, DropDownList)         → Biz (CustomDropdown — DmBizType lookup)
//   chkM         (UsrCheckBox)                    → [M$] 백만 단위 (Checkbox)
//   usrChk       (UsrCheckBox)                    → 정합성 체크 (Checkbox)
//   btnColumn / btnCutOff — Form 에서 제거 (SubTitle customButton + 기여율버전관리 분리)
export const ContributeViewForm = ({ onSearch, onOpenVersionPopup }: Props) => {
  const { t } = useTranslation();
  const searchParams = useContributeViewStore(s => s.searchParams);
  const setSearchParams = useContributeViewStore(s => s.setSearchParams);

  // AS-IS InitControls (.cs L104~108) + GetVersionData — Year SP 콤보 데이터
  const { data: yearData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
    filters: {},
    enabled: true,
  });

  const yearOptions = useMemo<VersionOption[]>(
    () => (yearData?.o_rc1 ?? []) as unknown as VersionOption[],
    [yearData]
  );

  // AS-IS InitControls — 검색조건 복원 (G1 personalize). 최초 1회만 수행.
  useEffect(() => {
    // if (yearOptions.length > 0 && !searchParams.verSeq) {
    //   const first = yearOptions[0];
    //   setSearchParams({
    //     verSeq: String(first.CODE ?? ''),
    //     yyyy: String(first.NAME2 ?? first.NAME ?? '').substring(0, 4),
    //   });
    // }
    void apiClient
      .get<
        { paramNm: keyof SearchParamProps; paramCtn: string }[]
      >(`/admin/menu/${MENU_ID}/search-conditions`)
      .then(res => {
        if (res.data.result?.length > 0) {
          const restored = res.data.result.reduce((acc, curr) => {
            acc[curr.paramNm] = curr.paramCtn;
            return acc;
          }, {} as SearchParamProps);
          setSearchParams(restored);
        }
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // AS-IS InitControls — 첫 옵션(max seq) 자동 선택.
  // verSeq 가 비어있는 최초 진입뿐 아니라, Condition 저장 당시엔 유효했지만
  // 이후 ContributeMain의 Version 팝업에서 삭제되어 더 이상 yearOptions 에 없는
  // 경우(stale 값)도 함께 검증해서, 유효하지 않으면 max seq(첫 옵션)로 되돌린다.
  useEffect(() => {
    if (yearOptions.length === 0) return;
    const exists = yearOptions.some(o => String(o.CODE) === searchParams.verSeq);
    if (exists) return;
    const first = yearOptions[0];
    setSearchParams({
      verSeq: String(first.CODE ?? ''),
      yyyy: String(first.NAME2 ?? first.NAME ?? '').substring(0, 4),
    });
  }, [yearOptions, searchParams.verSeq]);

  const [reportGroup, dmBizType] = useTabComboQueries({
    filters: ['ReportGroup3', 'DmBizType'],
  });

  const yearDropdownOptions = useMemo(
    () =>
      yearOptions.map(o => ({
        value: String(o.CODE ?? ''),
        label: String(o.NAME2 ?? o.NAME ?? o.CODE ?? ''),
      })),
    [yearOptions]
  );

  const productGroupOptions = useMemo(
    () => (reportGroup ?? []).map(item => ({ label: item.NAME, value: item.CODE })),
    [reportGroup]
  );

  const bizTypeOptions = useMemo(
    () => (dmBizType ?? []).map(item => ({ label: item.NAME, value: item.CODE })),
    [dmBizType]
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', 'Search')}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00086', '_Year')}
              labelAlign='right'
              className={commonStyles.formItem}
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.verSeq}
                  options={yearDropdownOptions}
                  onChange={(_, option) => {
                    const opt = yearOptions.find(o => String(o.CODE) === option);
                    // Year 변경 시 그 외 조회조건도 기본값으로 초기화
                    setSearchParams({
                      verSeq: option,
                      yyyy: String(opt?.NAME2 ?? opt?.NAME ?? '').substring(0, 4),
                      versionNo: '',
                      productGroup: 'ALL',
                      endCustReport: '',
                      bizType: 'ALL',
                      millionYn: 'N',
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00653', '_Version')}
              labelAlign='right'
              className={commonStyles.formItem}
              required
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={searchParams.versionNo}
                  InputProps={{
                    readOnly: true,
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onOpenVersionPopup} />
                        }
                      />
                    ),
                  }}
                  onDoubleClick={onOpenVersionPopup}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00088', '_제품군')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={searchParams.productGroup}
                  options={productGroupOptions}
                  onChange={(_, option) => setSearchParams({ productGroup: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00087', '_고객군')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <InputField
                  style={{ width: '100%' }}
                  value={searchParams.endCustReport}
                  onChange={e => setSearchParams({ endCustReport: e.target.value })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00657', '_Biz')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={searchParams.bizType}
                  options={bizTypeOptions}
                  onChange={(_, option) => setSearchParams({ bizType: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3} className={commonStyles.customGrid}>
            <FormItem
              render={() => (
                <div className={commonStyles.customCheckbox}>
                  <Checkbox
                    checked={searchParams.millionYn === 'Y'}
                    onChange={checked => setSearchParams({ millionYn: checked ? 'Y' : 'N' })}
                  />
                  <Label labelText={t('LBL00654', '_M$')} depth='sub' />
                </div>
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
