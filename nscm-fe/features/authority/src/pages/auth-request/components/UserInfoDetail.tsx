import { CustomDropdown } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import {
  DetailTableDataCell,
  DetailTableHeaderCell,
  DetailTableLine,
  DetailTableRow,
  Label,
} from '@shared/lges';
import { Typography } from '@shared/mui';
import { useTabid } from '@shared/stores';

import { MENU_ID, SHEETS } from '../auth-request.constants';
import { useAuthRequestStore } from '../useAuthRequestStore';

export const UserInfoDetail = () => {
  const { t } = useTranslation();
  const tabId = useTabid();

  const filters = useAuthRequestStore(state => state.filters[SHEETS.USER_INFO]);
  const langCd = useAuthRequestStore(state => state.langCd);
  const tmzCd = useAuthRequestStore(state => state.tmzCd);
  const setLangCd = useAuthRequestStore(state => state.setLangCd);
  const setTmzCd = useAuthRequestStore(state => state.setTmzCd);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.USER_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.USER_INFO,
    tabId,
    filters,
    enabled: !!filters,
  });

  const [languages, timeZones] = useTabComboQueries({ filters: ['Language', 'TimeZone'] });

  const userInfo = data?.o_rc?.[0];

  // TODO(Step 4): Sync server response (USER_INFO) into local langCd/tmzCd on first load
  // without violating "no useEffect copying server data into store" — read directly from
  // userInfo for display, and use store langCd/tmzCd only for user-edited values (fall back to userInfo).
  const currentLangCd = langCd || userInfo?.LANG_CD || '';
  const currentTmzCd = tmzCd || userInfo?.TMZ_CD || '';

  return (
    <DetailTableLine>
      <DetailTableRow>
        <DetailTableHeaderCell>
          <Label labelText={t('LBL00613', 'User ID')} />
        </DetailTableHeaderCell>
        <DetailTableDataCell>
          <Typography variant='bodyBasic'>{userInfo?.USER_ID ?? ''}</Typography>
        </DetailTableDataCell>
      </DetailTableRow>
      <DetailTableRow>
        <DetailTableHeaderCell>
          <Label labelText={t('LBL00614', 'User Name')} />
        </DetailTableHeaderCell>
        <DetailTableDataCell>
          <Typography variant='bodyBasic'>{userInfo?.USER_NM ?? ''}</Typography>
        </DetailTableDataCell>
      </DetailTableRow>
      <DetailTableRow>
        <DetailTableHeaderCell>
          <Label labelText={t('LBL00615', 'Department')} />
        </DetailTableHeaderCell>
        <DetailTableDataCell>
          <Typography variant='bodyBasic'>{userInfo?.DEPT_NM ?? ''}</Typography>
        </DetailTableDataCell>
      </DetailTableRow>
      <DetailTableRow>
        <DetailTableHeaderCell>
          <Label labelText={t('LBL00616', 'Language')} isRequired />
        </DetailTableHeaderCell>
        <DetailTableDataCell>
          <CustomDropdown
            isInput={false}
            value={currentLangCd}
            options={languages?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
            onChange={(_, value) => setLangCd(typeof value === 'string' ? value : '')}
          />
        </DetailTableDataCell>
      </DetailTableRow>
      <DetailTableRow>
        <DetailTableHeaderCell>
          <Label labelText={t('LBL00617', 'Time Zone')} isRequired />
        </DetailTableHeaderCell>
        <DetailTableDataCell>
          <CustomDropdown
            isInput={false}
            value={currentTmzCd}
            options={timeZones?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
            onChange={(_, value) => setTmzCd(typeof value === 'string' ? value : '')}
          />
        </DetailTableDataCell>
      </DetailTableRow>
    </DetailTableLine>
  );
};
