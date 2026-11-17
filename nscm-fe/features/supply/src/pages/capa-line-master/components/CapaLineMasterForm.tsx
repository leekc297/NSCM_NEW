import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { COMBO, DIVISION_EXCLUDE_ATTRIBUTE3, MENU_ID } from '../capa-line-master.constants';
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

// 상단 SearchArea — Division* 1필드만. Product Group 은 AS-IS(rgrpSearchLevel)처럼 상단이 아니라
//   Level1~3 과 Level4~5 그리드 사이의 하단 조회조건 바(CapaLineMasterProductGroupBar)로 분리했다
//   (SSP0023 2차 조회조건 패턴 참조, 사용자 지시 2026-10-30). 두 축 모두 명시 Search 게이트.
//   Division* : 단일선택 콤보(Division_SCP 권한필터 + ATTRIBUTE3='EE' 클라 제외), ALL 옵션 없음.
export const CapaLineMasterForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useCapaLineMasterStore(s => s.searchCondition);
  const setDivision = useCapaLineMasterStore(s => s.setDivision);
  const setSearchCondition = useCapaLineMasterStore(s => s.setSearchCondition);
  const openSearchArea = useCapaLineMasterStore(s => s.openSearchArea);

  const tabId = useTabid();

  // Division 콤보 강제 리마운트 키 — confirm 취소 시 표시값을 현재 divisionId 로 되돌리는 데 쓴다.
  //   MUI Autocomplete 는 controlled 라도 '포커스 중 + value 미변경'이면 내부 입력 표시를 되돌리지
  //   않는다(useAutocomplete.js: focused && !valueChange → 조기 return). 그래서 편집중 Div 를 바꿔
  //   MSG00704 에서 Cancel 하면 value(sc.divisionId)는 이전 값 그대로인데 콤보 칸만 새 값으로 남아,
  //   그 상태로 Search 하면 '칸=새 Div, 조회=이전 Div' 로 어긋난다(SCP0114 수정요청 2026-11-11).
  //   취소 시 이 키를 올려 remount → value 기준으로 표시를 강제 복원한다(확정 시엔 value 가 바뀌어
  //   MUI 가 스스로 resync 하므로 불필요).
  const [divComboKey, setDivComboKey] = useState(0);

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

  // Division 기본값 = 권한목록 첫 항목 자동선택(AS-IS setListBox DropDownList 첫 행 자동선택, cs:187~192).
  //   L1(Division 미선택) 갭 해소. 콤보가 async 로드라 첫 항목 확정 후, 아직 미선택일 때만 1회 세팅한다.
  //   setSearchCondition 으로 divisionId 만 채운다(setDivision 의 전체 리셋을 피해 Product Group 보존).
  //   자동조회는 하지 않는다 — 명시 Search 게이트(L3, 2026-09-23 사용자 확정). divisionId 변경 시 CapaLineMaster
  //   effect 가 컬럼 메타만 재조회한다.
  const firstDivision = divisionOptions[0]?.value;
  useEffect(() => {
    if (!sc.divisionId && firstDivision) setSearchCondition({ divisionId: firstDivision });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [firstDivision, sc.divisionId]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* (단일선택, ALL 없음 — design 02 §1 #1 / §4 setListBox(false)).
              라벨 = LBL00001 "Div" — AS-IS SCP0114 캡션(LBL00641 "Division")과 다르나, 자매 SCP0104
              (Line Assign) 및 공용 DivisionField 카탈로그와 통일하기로 사용자 확정(2026-11-06). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  key={divComboKey}
                  autoFocus
                  useClearIcon
                  value={sc.divisionId}
                  options={divisionOptions}
                  // Division 변경 = 검색조건(Div 제외 전부) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                  //   편집중(dirty)이면 MSG00704 confirm 후에만 실행한다. 조회(Search) 공통 가드와 동일 경로('search').
                  //   취소 시 표시 복원은 divComboKey remount 로 한다(위 주석 — MUI controlled 자동복귀가 안 됨).
                  onChange={(_, picked) => {
                    const v = String(picked ?? '');
                    if (v === sc.divisionId) return;
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(v);
                      else setDivComboKey(k => k + 1);
                    });
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
