import { useTranslation } from 'react-i18next';

import { CustomDropdown } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { Button, InputField } from '@shared/lges';

import { LOOKUP } from '../production-request.constants';
import type { BuildFormState, BuildRow } from '../production-request.types';

import styles from './SampleBuildPanel.module.scss';

interface SampleBuildPanelProps {
  /** 조회 모드 표시값 — Tree 선택 빌드의 GET_PJT_SAMPLE_BUILD 첫 행 (미선택/미조회면 undefined) */
  build?: BuildRow;
  /** 신규(Insert View) 모드 여부 — §확인사항 1.1 (신규 진입/취소·저장 복귀) */
  insertMode: boolean;
  form: BuildFormState;
  onFormChange: (patch: Partial<BuildFormState>) => void;
  onInsert: () => void;
  onCancel: () => void;
  onSave: () => void;
  isEditable: boolean;
}

// SDM2010 샘플 빌드 등록 패널 — 설계서 GRID LEFT 시트 (Default/Insert View).
//   D-PJT 코드/Stack 공법 = 항상 조회 전용(선택 프로젝트 값). 빌드 차수/특이사항만 신규 모드에서 편집.
//   빌드 차수 구분/묶음 차수 구분 = lookup 드롭다운, Sequence 는 숫자 입력
//   (설계서는 ▼ 표기이나 후보 원장이 미정 — lookup 등재 시 드롭다운 교체. constants.LOOKUP 참고).
export const SampleBuildPanel = ({
  build,
  insertMode,
  form,
  onFormChange,
  onInsert,
  onCancel,
  onSave,
  isEditable,
}: SampleBuildPanelProps) => {
  const { t } = useTranslation();
  const [buildTypes, bindTypes] = useTabLookupQueries({
    filters: [LOOKUP.BUILD_TYPE, LOOKUP.BIND_TYPE],
  });
  const toOptions = (rows: Array<Record<string, string>> | undefined) =>
    (rows ?? []).map(r => ({
      label: String(r?.NAME ?? r?.CODE ?? ''),
      value: String(r?.CODE ?? ''),
    }));

  // 조회 모드 빌드 차수 표시 — "A 1 - 1" (설계서 Default View)
  const buildSeqText = build
    ? `${build?.DPJT_BUILD_TYPE ?? ''} ${build?.DPJT_BUILD_SEQ ?? ''} - ${build?.DPJT_BIND_SEQ ?? ''}`.trim() ||
      '-'
    : '-';

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        {/* LBL 채번 = SDM2010_META_20260827/sql/03_META §[1] (LBL01020~01030) */}
        <span className={styles.title}>{`1. ${t('LBL01022', '_샘플 빌드 등록')}`}</span>
        <div className={styles.buttons}>
          {insertMode ? (
            <Button size='small' appearance='outlined' onClick={onCancel}>
              {t('LBL00394', '_취소')}
            </Button>
          ) : (
            // [수정] 권한(ADMIN/WRITE)이 없거나 빌드 데이터 원본이 없으면 [신규] 버튼 disabled
            <Button
              size='small'
              appearance='outlined'
              onClick={onInsert}
              disabled={!isEditable || !build?.DPJT_CODE}
            >
              {t('LBL01028', '_신규')}
            </Button>
          )}
          {/* [수정] 권한이 없거나 편집모드가 활성화되지 않았다면 [저장] 버튼 disabled */}
          <Button
            size='small'
            appearance='contained'
            onClick={onSave}
            disabled={!isEditable || !insertMode}
          >
            {t('LBL00395', '_저장')}
          </Button>
        </div>
      </div>

      <div className={styles.fieldTable}>
        <div className={styles.row}>
          <div className={styles.label}>{t('LBL01024', '_D-PJT 코드')}</div>
          <div className={styles.value}>{build?.DPJT_CODE ?? ''}</div>
        </div>
        <div className={styles.row}>
          <div className={styles.label}>{t('LBL01025', '_Stack 공법')}</div>
          <div className={styles.value}>{build?.STACK_METHOD ?? ''}</div>
        </div>
        <div className={styles.row}>
          <div className={styles.label}>{t('LBL01026', '_빌드 차수')}</div>
          <div className={styles.value}>
            {insertMode ? (
              <div className={styles.seqEditors}>
                <CustomDropdown
                  value={form.buildType}
                  options={toOptions(buildTypes)}
                  onChange={(_, value) => onFormChange({ buildType: value })}
                />
                <InputField
                  type='number'
                  size='small'
                  value={form.buildSeq}
                  onChange={event => onFormChange({ buildSeq: event.target.value })}
                />
                <span className={styles.separator}>-</span>
                <CustomDropdown
                  value={form.bindType}
                  options={toOptions(bindTypes)}
                  onChange={(_, value) => onFormChange({ bindType: value })}
                />
                <InputField
                  type='number'
                  size='small'
                  value={form.bindSeq}
                  onChange={event => onFormChange({ bindSeq: event.target.value })}
                />
              </div>
            ) : (
              buildSeqText
            )}
          </div>
        </div>
        <div className={styles.row}>
          <div className={styles.label}>{t('LBL01027', '_특이사항')}</div>
          <div className={styles.value}>
            {insertMode ? (
              <InputField
                type='textarea'
                size='small'
                value={form.note}
                onChange={event => onFormChange({ note: event.target.value })}
              />
            ) : (
              (build?.NOTE ?? '')
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
