import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import {
  COMBO,
  DIVISION_EXCLUDE_ATTRIBUTE3,
  MENU_ID,
  PRODUCT_GROUP,
  type ProductGroup,
} from '../capa-line-master.constants';
import { useCapaLineMasterStore } from '../useCapaLineMasterStore';

interface Props {
  onSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// design 02 (02_search-combo.md) 조회조건 1단 2필드 — 접기/펼치기(extraConditions) 미적용
//   (hook #52 기준 6필드 초과 아님, design 02 §5·§6-6).
//   1) Division* : 단일선택 콤보(Division_SCP 권한필터 + ATTRIBUTE3='EE' 클라 제외), ALL 옵션 없음
//   2) Product Group : 정적 3옵션(Electrode/Cell/Module·Pack) -> p_shop_group_id E/A/P, 기본 Electrode
//   cascade 없음(독립 2축, design 02 §3). 변경 시 즉시조회하지 않는다 — 명시 Search 게이트.
export const CapaLineMasterForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useCapaLineMasterStore(s => s.searchCondition);
  const setSearchCondition = useCapaLineMasterStore(s => s.setSearchCondition);
  const openSearchArea = useCapaLineMasterStore(s => s.openSearchArea);

  // Division = Division_SCP (AS-IS Data_SCP.Common(Type.Division) = 권한필터 변형).
  //   mnuId='SCP0114' 필수 — 미전달 시 권한군 ALL 로 열린다(design 02 §2.1 WHERE @mnuId).
  const [divisions] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }],
  });

  // EE 제외 재현 — AS-IS BLUtils.GetDivisionWithoutEE -> DBUtils.Filter(res, "ATTRIBUTE3 <> 'EE'")
  //   (BLUtils.cs:107~116). 이관된 CMBO SQL 에는 이 필터가 없어 FE 에서 재현한다(convert-core §2.6).
  //   공유 SQL_ID(Division_SCP) WHERE 수정 금지 — 타 화면 회귀(Hard Boundary §2.2).
  const divisionOptions = useMemo<Option[]>(
    () =>
      ((divisions ?? []))
        .filter(row => str(row.ATTRIBUTE3) !== DIVISION_EXCLUDE_ATTRIBUTE3)
        // 표시값은 NAME(= '{DIVISION_ID} {DIVISION_NAME}') — 코드만 뜨는 base 'Division' 재사용 금지.
        .map(row => ({ label: str(row.NAME) || str(row.CODE), value: str(row.CODE) })),
    [divisions]
  );

  // Product Group — 정적 옵션(SP 없음, design 02 §2.2). AS-IS RadioGroup 3항목(Designer.cs:597~601).
  //   NSCM 공용에 RadioGroup 컴포넌트가 없어 단일선택 드롭다운으로 매핑한다(의미 동일: 단일선택 3옵션).
  //   'Module/Pack' 은 등가 LBL 미존재(LBL00379 는 'Module' 전용) -> 영문 defaultValue 유지(hook #114).
  const productGroupOptions = useMemo<Option[]>(
    () => [
      { label: t('LBL00038', { defaultValue: 'Electrode' }), value: PRODUCT_GROUP.ELECTRODE },
      { label: t('LBL01059', { defaultValue: 'Cell' }), value: PRODUCT_GROUP.CELL },
      { label: 'Module/Pack', value: PRODUCT_GROUP.MODULE_PACK },
    ],
    [t]
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* (단일선택, ALL 없음 — design 02 §1 #1 / §4 setListBox(false)). LBL00641. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', { defaultValue: 'Division' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  autoFocus
                  useClearIcon
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) => setSearchCondition({ divisionId: String(picked ?? '') })}
                />
              )}
            />
          </Grid>

          {/* Product Group (정적 3옵션, 기본 Electrode — design 02 §1 #4 / §2.2). LBL00088. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00088', { defaultValue: 'Product Group' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.shopGroupId}
                  options={productGroupOptions}
                  onChange={(_, picked) =>
                    setSearchCondition({
                      shopGroupId: (String(picked ?? '') || PRODUCT_GROUP.ELECTRODE) as ProductGroup,
                    })
                  }
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
