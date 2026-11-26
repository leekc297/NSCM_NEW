import InfoOutlined from '@mui/icons-material/InfoOutlined';
import SyncIcon from '@mui/icons-material/Sync';
import IconButton from '@mui/material/IconButton';
import { useMemo } from 'react';
import { useTranslation } from 'react-i18next';

import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import {
  COMBO,
  DIVISION_EXCLUDE_ATTRIBUTE3,
  FIXED_DIVISION,
  LAST_UPDATED,
  MENU_ID,
} from '../demand-as-dashboard.constants';
import { LBL } from '../demand-as-dashboard.labels';
import styles from '../DemandAsDashboard.module.scss';

interface Option {
  label: string;
  value: string;
}

interface DashboardHeaderProps {
  div: string;
  bizType: string;
  oem: string;
  baseMonth: string;
  baseMonthOptions: Option[]; // COMBO.BASE_DATE(DATE_WEEKLY) 옵션 — 부모가 로드/시드해 내려준다
  onDivChange: (value: string) => void;
  onBizTypeChange: (value: string) => void;
  onOemChange: (value: string) => void;
  onBaseMonthChange: (value: string) => void;
  onRefresh: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export const DashboardHeader = ({
  div,
  bizType,
  oem,
  baseMonth,
  baseMonthOptions,
  onDivChange,
  onBizTypeChange,
  onOemChange,
  onBaseMonthChange,
  onRefresh,
}: DashboardHeaderProps) => {
  const { t } = useTranslation();
  // 조회조건 콤보 옵션은 콤보 SP 에서 로드(하드코딩 제거). mnuId 필수 — 미전달 시 권한군 ALL.
  //   Biz Type = DM_BIZ_TYPE(파라미터 없음) · OEM = EndCustomerByDivision(@divisionId=Div 고정).
  const [divisions, bizTypes, endCustomers] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      { comboId: COMBO.BIZ_TYPE, mnuId: MENU_ID },
      { comboId: COMBO.END_CUSTOMER, mnuId: MENU_ID, divisionId: FIXED_DIVISION },
    ],
  });

  // EE 제외 재현(AS-IS BLUtils.GetDivisionWithoutEE) — 이관 CMBO SQL 에 없어 FE 에서 거른다.
  //   표시값은 NAME(= '{DIVISION_ID} {DIVISION_NAME}'), value 는 CODE.
  const divOptions = useMemo<Option[]>(
    () =>
      (divisions ?? [])
        .filter(row => str(row.ATTRIBUTE3) !== DIVISION_EXCLUDE_ATTRIBUTE3)
        .map(row => ({ label: str(row.NAME) || str(row.CODE), value: str(row.CODE) })),
    [divisions]
  );

  // 콤보 행만. '전체'는 다중 콤보의 allOption(SELECT ALL)이 제공하고, 미선택=ALL(무필터)로 내보낸다.
  //   value 는 CODE(proc 로 보내는 토큰 — 값 계약은 실 proc 확정 시 재점검).
  const bizTypeOptions = useMemo<Option[]>(
    () => (bizTypes ?? []).map(row => ({ label: str(row.NAME) || str(row.CODE), value: str(row.CODE) })),
    [bizTypes]
  );
  const oemOptions = useMemo<Option[]>(
    () =>
      (endCustomers ?? []).map(row => ({ label: str(row.NAME) || str(row.CODE), value: str(row.CODE) })),
    [endCustomers]
  );

  return (
    <div className={styles.header}>
      <div className={styles.field}>
        <label>{t(...LBL.div)}</label>
        <div className={styles.control}>
          {/* 현재는 Div=81 고정 조회라 선택 비활성(disabled). 콤보는 라벨('81 ...') 표시용으로만 로드. */}
          <CustomDropdown
            isInput={false}
            disabled
            value={div}
            options={divOptions}
            onChange={(_, value) => onDivChange(value)}
          />
        </div>
      </div>
      <div className={`${styles.field} ${styles.baseMonth}`}>
        <label>{t(...LBL.baseMonth)}</label>
        <div className={styles.control}>
          <CustomDropdown
            isInput={false}
            value={baseMonth}
            options={baseMonthOptions}
            onChange={(_, value) => onBaseMonthChange(value)}
          />
        </div>
      </div>
      <div className={styles.field}>
        <label>{t(...LBL.bizType)}</label>
        <div className={styles.control}>
          {/* 다중선택 — 고른 CODE 를 콤마로 이어 proc 로 넘긴다(미선택=ALL=무필터). value 는
              콤마 문자열, onChange 도 콤마 문자열('ALL')로 돌아온다(표준 다중 콤보, 예: SCP
              warehouse-capacity Site/Plan Group). */}
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={bizType}
            options={bizTypeOptions}
            onChange={(_, value) => onBizTypeChange(value)}
          />
        </div>
      </div>
      <div className={styles.field}>
        <label>{t(...LBL.oem)}</label>
        <div className={styles.control}>
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={oem}
            options={oemOptions}
            onChange={(_, value) => onOemChange(value)}
          />
        </div>
      </div>
      <IconButton
        size='small'
        aria-label={t(...LBL.refresh)}
        title={t(...LBL.refresh)}
        onClick={onRefresh}
        sx={{
          border: '1px solid #cfd6e0',
          borderRadius: '6px',
          color: '#4b5563',
          padding: '5px',
          '&:hover': { backgroundColor: '#eef2f7', color: '#1565c0', borderColor: '#1565c0' },
        }}
      >
        <SyncIcon sx={{ fontSize: 18 }} />
      </IconButton>
      <div className={styles.updated}>
        <InfoOutlined sx={{ fontSize: 14 }} />
        <span>{t(...LBL.lastUpdated)}</span>
        <strong>{LAST_UPDATED}</strong>
      </div>
    </div>
  );
};
