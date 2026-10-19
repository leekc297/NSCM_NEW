import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { COMBO, DEFAULT_DIVISION, LBL } from '../scp-bom-elec.constants';
import { useScpBomElecStore } from '../useScpBomElecStore';

interface Props {
  onSearch: () => void;
  // R6a — MyDivision 0건(권한 없음) 여부를 페이지로 전달(조회 차단 게이트, design 01 R6a).
  onDivisionAuth: (hasAuth: boolean) => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 조회조건 3행(1단): Division(단일·필수, 기본 '81' 존재 시 선택·미존재 시 마지막 항목) /
//   Parent Item / Child Item(멀티라인 텍스트 — 개행/콤마 다중). 3필드 ≤2단 → extraConditions 불요(§5).
export const ScpBomElecForm = ({ onSearch, onDivisionAuth }: Props) => {
  const { t } = useTranslation();

  const sc = useScpBomElecStore(s => s.searchCondition);
  const set = useScpBomElecStore(s => s.setSearchCondition);
  const changeDivision = useScpBomElecStore(s => s.changeDivision);
  const openSearchArea = useScpBomElecStore(s => s.openSearchArea);

  // MyDivision 콤보 — EE제외+unit권한+@mnuId 게이트 SQL 내장(@sesUserId 세션 자동). 클라 후처리 필터 없음(§2).
  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  const divisionOptions = toOptions(divisions);

  // R6a 권한 게이트 + R6b 기본값 강제(AS-IS OnShown SelectCombo). 콤보 로드 후 1회:
  //   후보 0건 → 권한 없음(조회 차단). 아직 미선택이면 '81' 존재 시 '81', 미존재 시 마지막 항목 선택
  //   (design 01 R6b — 임의 "첫 행" 통일 금지).
  useEffect(() => {
    if (divisions === undefined) return; // 로딩 중 판정 보류
    if (divisionOptions.length === 0) {
      onDivisionAuth(false);
      return;
    }
    onDivisionAuth(true);
    if (sc.divisionId === '') {
      const has81 = divisionOptions.some(o => o.value === DEFAULT_DIVISION);
      const picked = has81
        ? DEFAULT_DIVISION
        : divisionOptions[divisionOptions.length - 1].value;
      set({ divisionId: picked });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions]);

  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division — 선택 가능(자매 SCP0053 과 달리 disabled 아님) + 필수. 변경 시 Grid 초기화(R6c) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, { defaultValue: 'Div.' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  disabled={noDivisionAuth}
                  onChange={(_, value) => changeDivision(value)}
                />
              )}
            />
          </Grid>
          {/* Parent Item — 멀티라인 텍스트(개행→콤마 다중, design 02 §2.3). 공백=전체 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PARENT_ITEM, { defaultValue: 'Parent Item' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  multiline
                  maxRows={3}
                  value={sc.parentId}
                  disabled={noDivisionAuth}
                  onChange={e => set({ parentId: e.target.value })}
                />
              )}
            />
          </Grid>
          {/* Child Item — 멀티라인 텍스트(동상, design 02 §2.3) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CHILD_ITEM, { defaultValue: 'Child Item' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  multiline
                  maxRows={3}
                  value={sc.childId}
                  disabled={noDivisionAuth}
                  onChange={e => set({ childId: e.target.value })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
