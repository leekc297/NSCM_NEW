import { useEffect, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_MSG } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import { CustomDialog, CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem, InputField } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { useSessionStore, useMessageStore } from '@shared/stores';

import { COMBO, LBL, MENU_ID, MSG, VERSION_TYPE_LABELS } from '../../capa.constants';
import { sortDivisionOptions } from '../../utils/capa.combos';

interface Props {
  open: boolean;
  /** 메인 화면 조회조건 division — 팝업 division 기본선택(AS-IS 는 별도 SysLookup 체크리스트, TO-BE 편차). */
  divisionId: string;
  onClose: () => void;
  /** 저장 성공 후 — 메인 화면 버전 옵션 재조회(NEW-03). */
  onSaved?: () => void;
}

/**
 * SCP0049 New Version Confirm 팝업(01 R7 §3.2-7 · Roslyn SCP0049_CAPANewVersionConfirmPopup).
 * 폼: BP/RP/SCP 체크박스 · Division · Version Name → BtnConfirm → SaveData.
 * SAVE = newVersion SAVE(P_SAVE_NEW_VERSION, PROC_M COL_NM 실측:
 *   todayYyyymmdd/chkBp/chkRp/chkScp/versionDivision/versionName/updateId).
 * 검증(Roslyn validations): division 공백 차단 · versionName 공백 차단(AS-IS MSG 번호는 TO-BE 불일치라
 *   공용 필수입력 메시지 CRUD_MSG.REQUIRED_FIELD 사용, hook #114).
 * 편차(정직 보고): Division 원천 = AS-IS MASTER_DATA_DIVISION_SYSTEM SysLookup 다중체크. TO-BE 는 해당
 *   SysLookup 인프라 미존재 → MyDivision 단일선택(메인 조회 division 기본값)으로 대체. __asis-mapping__ 기록.
 */
export const NewVersionConfirmModal = ({ open, divisionId, onClose, onSaved }: Props) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore();
  const [saving, setSaving] = useState(false);

  const [versionDivision, setVersionDivision] = useState(divisionId);
  const [versionName, setVersionName] = useState('');
  const [chkBp, setChkBp] = useState(false);
  const [chkRp, setChkRp] = useState(false);
  const [chkScp, setChkScp] = useState(false);

  const [divisionRows] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  const divisionOptions = sortDivisionOptions(divisionRows);

  // 팝업 오픈 시 메인 조회 division 으로 초기화(재오픈마다 최신 조회조건 반영).
  useEffect(() => {
    if (open) {
      setVersionDivision(divisionId);
      setVersionName('');
      setChkBp(false);
      setChkRp(false);
      setChkScp(false);
    }
  }, [open, divisionId]);

  const yn = (b: boolean): string => (b ? 'Y' : 'N');

  const handleConfirm = async () => {
    if (versionDivision.trim() === '') {
      await setAlert({
        type: 'alert',
        content: t(CRUD_MSG.REQUIRED_FIELD.id, CRUD_MSG.REQUIRED_FIELD.fallback).replace(
          '{0}',
          t(LBL.DIVISION, 'Division')
        ),
      });
      return;
    }
    if (versionName.trim() === '') {
      await setAlert({
        type: 'alert',
        content: t(CRUD_MSG.REQUIRED_FIELD.id, CRUD_MSG.REQUIRED_FIELD.fallback).replace(
          '{0}',
          t(LBL.NAME, 'Name')
        ),
      });
      return;
    }
    const updateId = useSessionStore.getState().session.userId ?? '';
    setSaving(true);
    try {
      const res = await apiClient.post<{ code?: string; message?: string }>(
        `/${MENU_ID}/newVersion/SAVE/call-proc`,
        {
          todayYyyymmdd: dayjs().format('YYYYMMDD'),
          chkBp: yn(chkBp),
          chkRp: yn(chkRp),
          chkScp: yn(chkScp),
          versionDivision: versionDivision.trim(),
          versionName: versionName.trim(),
          updateId,
        }
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        await setAlert({
          type: 'alert',
          content: String(res.data?.message ?? '').trim() || t(MSG.SAVE_FAIL, '_Failed to save.'),
        });
        return;
      }
      setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_Saved successfully.') });
      onSaved?.();
      onClose();
    } finally {
      setSaving(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      size={480}
      type='modal'
      position='basic'
      handleClose={onClose}
      handleSubmit={saving ? undefined : () => void handleConfirm()}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t(LBL.NEW_VERSION, 'New Version')}</h2>
        </div>
      }
      customContentArea={
        <Grid container spacing={2}>
          <Grid size={12}>
            <Stack direction='row' spacing={2} alignItems='center'>
              <Checkbox
                labelText={VERSION_TYPE_LABELS.bp}
                checked={chkBp}
                onChange={checked => setChkBp(checked)}
              />
              <Checkbox
                labelText={VERSION_TYPE_LABELS.rp}
                checked={chkRp}
                onChange={checked => setChkRp(checked)}
              />
              <Checkbox
                labelText={VERSION_TYPE_LABELS.scp}
                checked={chkScp}
                onChange={checked => setChkScp(checked)}
              />
            </Stack>
          </Grid>
          <Grid size={12}>
            <FormItem
              label={t(LBL.DIVISION, 'Division')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={versionDivision}
                  options={divisionOptions}
                  onChange={(_, picked) => setVersionDivision(String(picked ?? ''))}
                />
              )}
            />
          </Grid>
          <Grid size={12}>
            <FormItem
              label={t(LBL.NAME, 'Name')}
              labelAlign='right'
              required
              render={() => (
                <InputField
                  fullWidth
                  value={versionName}
                  onChange={e => setVersionName(e.target.value)}
                />
              )}
            />
          </Grid>
        </Grid>
      }
    />
  );
};
