import { useMemo } from 'react';

import InfoOutlined from '@mui/icons-material/InfoOutlined';

import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import { COMBO, DIVISION_EXCLUDE_ATTRIBUTE3, MENU_ID } from '../demand-as-dashboard.constants';
import { BIZ_TYPE_OPTIONS, LAST_UPDATED, OEM_OPTIONS } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';

interface DashboardHeaderProps {
  div: string;
  bizType: string;
  oem: string;
  baseMonth: string;
  onDivChange: (value: string) => void;
  onBizTypeChange: (value: string) => void;
  onOemChange: (value: string) => void;
  onBaseMonthChange: (value: string) => void;
}

interface Option {
  label: string;
  value: string;
}

const BASE_MONTH_OPTIONS = ['2025-05', '2025-04', '2025-03'];

// 문자열 목록 → 표준 콤보(CustomDropdown) 옵션 형태({label,value})로 변환.
const toOptions = (values: readonly string[]) => values.map(v => ({ label: v, value: v }));

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export const DashboardHeader = ({
  div,
  bizType,
  oem,
  baseMonth,
  onDivChange,
  onBizTypeChange,
  onOemChange,
  onBaseMonthChange,
}: DashboardHeaderProps) => {
  // Div 콤보 = Division_SCP (SCP0114 Line Master 와 동일 처리). mnuId 필수 — 미전달 시 권한군 ALL.
  const [divisions] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }],
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

  return (
    <div className={styles.header}>
      <div className={styles.field}>
        <label>Div</label>
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
      <div className={styles.field}>
        <label>기준월</label>
        <div className={styles.control}>
          <CustomDropdown
            isInput={false}
            value={baseMonth}
            options={toOptions(BASE_MONTH_OPTIONS)}
            onChange={(_, value) => onBaseMonthChange(value)}
          />
        </div>
      </div>
      <div className={styles.field}>
        <label>Biz Type</label>
        <div className={styles.control}>
          <CustomDropdown
            isInput={false}
            value={bizType}
            options={toOptions(BIZ_TYPE_OPTIONS)}
            onChange={(_, value) => onBizTypeChange(value)}
          />
        </div>
      </div>
      <div className={styles.field}>
        <label>OEM</label>
        <div className={styles.control}>
          <CustomDropdown
            isInput={false}
            value={oem}
            options={toOptions(OEM_OPTIONS)}
            onChange={(_, value) => onOemChange(value)}
          />
        </div>
      </div>
      <div className={styles.updated}>
        <InfoOutlined sx={{ fontSize: 14 }} />
        <span>최근 업데이트</span>
        <strong>{LAST_UPDATED}</strong>
      </div>
    </div>
  );
};
