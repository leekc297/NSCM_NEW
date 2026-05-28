/**
 * DMF0020 SalesFuturePrice — Version Modal (DMF0073 연동)
 *
 * AS-IS POPUP: DMF0073_VersionBySalesPricePopup (DMF0020 의 btnSPVer L3895 에서 호출).
 * 분석서: Doc/_analysis/domain_DM/screens/DMF0020_POPUP_Version/
 *
 * 룰 25 §3.4 — 자체 modal 신규 생성 (DMF0073 별도 화면이지만 사용자 결정으로 자체 생성).
 *
 * Validation (validation.md v6.2):
 *   - V1: Apply 시 선택 Version > 2 → MSG00255 '읽기전용'
 *   - V2: FindData 시 Day/Week/Manual 모두 미선택 → silent (빈 결과)
 */
import { useEffect, useMemo, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CustomDialog } from '@shared/components';
import { Button, Checkbox } from '@shared/lges';
import { Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../../sales-future-price.constants';
import { useSalesFuturePriceStore } from '../../useSalesFuturePriceStore';

import styles from './SalesPriceVersionModal.module.scss';

interface VersionRow {
  VERSION_ID: string;
  VERSION_DESC: string;
  VERSION_TYPE: 'SP_D' | 'SP_W' | 'SP_M';
  DIVISION_ID: string;
  CREATED_BY: string;
  CREATION_DATE: string;
}

type VersionTypeKey = 'day' | 'week' | 'manual';

const MAX_SELECTION = 2;

interface SalesPriceVersionModalProps {
  open: boolean;
  modalClose: () => void;
}

export const SalesPriceVersionModal = ({ open, modalClose }: SalesPriceVersionModalProps) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const setSearchParams = useSalesFuturePriceStore(state => state.setSearchParams);
  const searchParams = useSalesFuturePriceStore(state => state.searchParams);

  /** V2: Day/Week/Manual 체크박스 — 모두 미선택 시 silent 빈 결과 */
  const [typeFilter, setTypeFilter] = useState<Record<VersionTypeKey, boolean>>({
    day: true,
    week: true,
    manual: false,
  });
  const [versions, setVersions] = useState<VersionRow[]>([]);
  const [selectedIds, setSelectedIds] = useState<string[]>([]);

  const enabledTypes = useMemo(() => {
    const arr: VersionRow['VERSION_TYPE'][] = [];
    if (typeFilter.day) arr.push('SP_D');
    if (typeFilter.week) arr.push('SP_W');
    if (typeFilter.manual) arr.push('SP_M');
    return arr;
  }, [typeFilter]);

  // FindData (V2 guard): Day/Week/Manual 모두 미선택 → silent
  const onSearch = async () => {
    if (enabledTypes.length === 0) {
      setVersions([]);
      return;
    }
    const { data } = await apiClient.post<VersionRow[]>(
      `/${MENU_ID}/${SHEETS.PRICE_VERSION}/SEARCH/call-proc`,
      {
        divisionId: searchParams.divisionId,
        versionTypes: enabledTypes.join(','),
        periodFrom: searchParams.periodFrom,
        periodTo: searchParams.periodTo,
      }
    );
    setVersions(data.result ?? []);
  };

  // V1: Apply 시 선택 > 2 → MSG00255
  const onApply = () => {
    if (selectedIds.length === 0) {
      // Selection 미선택 시 silent — 그냥 닫음
      modalClose();
      return;
    }
    if (selectedIds.length > MAX_SELECTION) {
      void setAlert({
        type: 'alert',
        content: t('MSG00255', '_읽기전용 — 선택은 최대 {0}개까지 가능합니다.', { 0: MAX_SELECTION }),
      });
      return;
    }
    // 첫 번째 Version 을 메인 검색조건으로 적용
    setSearchParams({ versionId: selectedIds[0] });
    modalClose();
  };

  useEffect(() => {
    if (open) void onSearch();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  return (
    <CustomDialog
      open={open}
      onClose={modalClose}
      maxWidth='md'
      fullWidth
      title={t('LBL_DMF0073_TITLE', '_Version 선택')}
    >
      <div className={styles.container}>
        <Stack direction='row' spacing={2} className={styles.filterBar}>
          <Checkbox
            labelText={t('LBL_DMF0073_DAY', '_Day')}
            checked={typeFilter.day}
            onChange={checked => setTypeFilter(prev => ({ ...prev, day: checked }))}
          />
          <Checkbox
            labelText={t('LBL_DMF0073_WEEK', '_Week')}
            checked={typeFilter.week}
            onChange={checked => setTypeFilter(prev => ({ ...prev, week: checked }))}
          />
          <Checkbox
            labelText={t('LBL_DMF0073_MANUAL', '_Manual')}
            checked={typeFilter.manual}
            onChange={checked => setTypeFilter(prev => ({ ...prev, manual: checked }))}
          />
          <Button appearance='outlined' priority='normal' size='small' onClick={onSearch}>
            {t('LBL00112', '_Search')}
          </Button>
        </Stack>

        <div className={styles.list}>
          {versions.length === 0 ? (
            <div className={styles.empty}>
              {t('LBL_DMF0073_EMPTY', '_조회된 Version 이 없습니다.')}
            </div>
          ) : (
            versions.map(v => (
              <label key={v.VERSION_ID} className={styles.row}>
                <input
                  type='checkbox'
                  checked={selectedIds.includes(v.VERSION_ID)}
                  onChange={e => {
                    setSelectedIds(prev =>
                      e.target.checked
                        ? [...prev, v.VERSION_ID]
                        : prev.filter(id => id !== v.VERSION_ID)
                    );
                  }}
                />
                <span className={styles.cell}>{v.VERSION_ID}</span>
                <span className={styles.cell}>{v.VERSION_DESC}</span>
                <span className={styles.cell}>{v.VERSION_TYPE}</span>
                <span className={styles.cell}>{v.DIVISION_ID}</span>
                <span className={styles.cell}>{v.CREATION_DATE}</span>
              </label>
            ))
          )}
        </div>

        <Stack direction='row' spacing={1} justifyContent='flex-end' className={styles.actions}>
          <Button appearance='contained' priority='normal' onClick={onApply}>
            {t('LBL00113', '_Apply')}
          </Button>
          <Button appearance='outlined' priority='normal' onClick={modalClose}>
            {t('LBL00114', '_Close')}
          </Button>
        </Stack>
      </div>
    </CustomDialog>
  );
};
