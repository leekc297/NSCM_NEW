import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { LBL, USE_FLAG_ALL, USE_FLAG_COMBO } from '../mdm-class-master.constants';
import { useMdmClassMasterStore } from '../useMdmClassMasterStore';

interface Props {
  onSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// design 02 (02_search-combo.md) 조회조건 — Class ID(text) / Class Name(text) / Use Flag(combo).
//   cascade 없음(events/comboCalls 0). 조회조건 팝업 없음. 자동조회 없음(명시 Search 게이트).
export const MdmClassMasterForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useMdmClassMasterStore(s => s.searchCondition);
  const set = useMdmClassMasterStore(s => s.setSearchCondition);
  const openSearchArea = useMdmClassMasterStore(s => s.openSearchArea);

  // Use Flag 콤보 = YesOrNo(Y/N, 등록확인) + FE addAll('ALL') prepend(design 02 §2.3 — 콤보 SQL UNION 금지).
  const [yesOrNo] = useTabComboQueries({ filters: [USE_FLAG_COMBO] });
  const useFlagOptions: Option[] = [
    { label: USE_FLAG_ALL, value: USE_FLAG_ALL },
    ...(yesOrNo ?? []).map((r: ComboResponse) => ({
      label: str(r.NAME) || str(r.CODE),
      value: str(r.CODE),
    })),
  ];

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Class ID (text, 부분일치) — 진입 첫 포커스(design 07 §3-4 / 01 §3) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CLASS_ID, '_Class ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  autoFocus
                  value={sc.classId}
                  onChange={e => set({ classId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Class Name (text, 부분일치) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CLASS_NAME, '_Class Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.className}
                  onChange={e => set({ className: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Use Flag (combo Y/N/ALL, default Y — design 02 §2.2/§4) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.USE_FLAG, '_Use Flag')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.useFlag}
                  options={useFlagOptions}
                  onChange={(_, picked) => set({ useFlag: String(picked ?? USE_FLAG_ALL) })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
