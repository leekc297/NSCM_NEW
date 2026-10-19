import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { COMBO, LBL, LINE_MODE, MSG } from '../line-master.constants';
import { useLineMasterStore } from '../useLineMasterStore';

interface Props {
  onSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 combo (칸-콤보 대응표, search-condition-combo-header):
//   [1] Division*(단일 root)   = MyDivision (권한 사업부, ATTRIBUTE3<>'EE' + VALID_YN='Y' 화면 재현)
//   [2] Plant Site(다중)       = Plant: PlantByDivisionOperNonOsp123 / Packer: PlantByDivisionOperOsp3
//   [3] Building(다중, Plant만) = BuildingByDivision1
//   [4] Operation(다중, Plant만)= LocationGroupByCapa (param-less 전량)
//   [5] Line(다중 leaf)        = Plant: LineByOperation2 / Packer: LineByPlantPacker
//   [6] Valid(단일 독립)       = YesOrNo (+ 전체 옵션, 기본 ALL)
//   cascade Division -> PlantSite/Building/Operation -> Line. 시트(Plant/Packer)로 PlantSite·Line 공급 콤보 분기.
export const LineMasterForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useLineMasterStore(s => s.searchCondition);
  const set = useLineMasterStore(s => s.setSearchCondition);
  const setMode = useLineMasterStore(s => s.setMode);
  const openSearchArea = useLineMasterStore(s => s.openSearchArea);
  const authLocked = useLineMasterStore(s => s.authLocked);
  const setAuthLocked = useLineMasterStore(s => s.setAuthLocked);
  const setAlert = useMessageStore.getState().setAlert;

  const isPlant = sc.mode === LINE_MODE.PLANT;

  // 전량 조회 후 client-side cascade 필터 (AS-IS CommonAll + DBUtils.Filter, design 02 §3).
  //   PlantSite·Line 공급 콤보는 시트(Plant/Packer)로 갈린다(combo-semantic-parity — 이름유사 재사용 금지).
  const [divisions, plantSites, buildings, operations, lines] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      isPlant ? COMBO.PLANT_SITE_PLANT : COMBO.PLANT_SITE_PACKER,
      COMBO.BUILDING,
      COMBO.OPERATION,
      isPlant ? COMBO.LINE_PLANT : COMBO.LINE_PACKER,
    ],
  });

  // cboDivision — 권한 사업부. AS-IS 권한필터 ATTRIBUTE3<>'EE' + VALID_YN='Y' 를 화면에서 재현
  //   (이관 SQL 본문 수정 금지 — Hard Boundary. combo-semantic-parity-no-name-reuse).
  const divisionOptions = toOptions(
    (divisions ?? []).filter(
      r => str(r.ATTRIBUTE3) !== 'EE' && (str(r.VALID_YN) === '' || str(r.VALID_YN) === 'Y')
    )
  );

  // division 기본값 = 첫 옵션 자동 선택. store 초기값(session.div)이 권한 목록에 없으면 빈칸으로 뜨므로
  //   현재 값이 옵션에 없을 때만 첫 옵션으로 교정한다(유효한 사용자 선택은 유지).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasCurrentDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasCurrentDivision) {
      set({
        divisionId: firstDivision,
        plantSiteIds: [],
        buildingIds: [],
        operationIds: [],
        lineIds: [],
      });
    }
  }, [firstDivision, hasCurrentDivision, set]);

  // 권한 사업부 0건 검색영역 잠금 — AS-IS SetDivisionAuthCheck(cs:142-143, BaseForm.cs:5995-6003):
  //   dtMyDivision.Rows.Count==0 → MSG00097 안내 + usrLayoutControl2.Enabled=false(검색영역 전체 잠금).
  //   콤보가 아직 로드되기 전(undefined)은 빈 배열과 구분한다 — 미로드 상태를 권한 0으로 오판하면
  //   초기 렌더에서 화면이 잘못 잠긴다(asis-checkedlist-blank-means-auth-csv-not-empty).
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (noDivisionAuth === authLocked) return;
    setAuthLocked(noDivisionAuth);
    // 잠금으로 전환될 때만 1회 안내(AS-IS GMessageBox("MSG00097") 등가).
    if (noDivisionAuth) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_AUTH_DIVISION, '_No division with authority.'),
      });
    }
  }, [noDivisionAuth, authLocked, setAuthLocked, setAlert, t]);

  // clbPlantSite = division 하위 (DBUtils.Filter DIVISION_ID = division, design 02 §2.2)
  const plantSiteOptions = toOptions(
    (plantSites ?? []).filter(r => !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId)
  );
  // clbBuilding = division 하위 (Plant 시트 전용)
  const buildingOptions = toOptions(
    (buildings ?? []).filter(r => !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId)
  );
  // clbOperation = LocationGroupByCapa param-less 전량 (design 02 filter/requery — 전량 노출)
  const operationOptions = toOptions(operations);
  // clbLine = division + 선택 plantSite/operation 하위 (design 02 §2.3)
  const lineOptions = toOptions(
    (lines ?? []).filter(
      r =>
        (!sc.divisionId || str(r.DIVISION_ID) === sc.divisionId) &&
        (sc.plantSiteIds.length === 0 || sc.plantSiteIds.includes(str(r.SCM_SITE_ID)))
    )
  );
  // cboValid — 독립 Y/N + 전체(ALL). 정적 옵션(design 02 §4 기본 "전체").
  const validOptions: Option[] = [
    { label: t(LBL.ALL, '_All'), value: 'ALL' },
    { label: t('LBL00728', '_Y'), value: 'Y' },
    { label: t('LBL00729', '_N'), value: 'N' },
  ];

  const multi = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy='label'
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              // CustomDropdown 전체해제/전체선택 = 'ALL' sentinel. 실제 코드로 담으면 하위 cascade 가
              //   'ALL' 을 코드로 매칭해 0건이 되므로 빈 배열로 정규화(SearchFields 표준 규약).
              onPick(
                String(picked ?? '')
                  .split(',')
                  .filter(v => v !== '' && v.toUpperCase() !== 'ALL')
              )
            }
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      // 권한 사업부 0건 = 검색영역 전체 비활성(AS-IS usrLayoutControl2.Enabled=false 등가).
      //   pointerEvents:none 로 조회조건·조회버튼 상호작용을 막고 opacity 로 비활성 시각을 준다.
      //   F5/SubTitle 단축키 등 DOM 밖 진입점은 LineMaster.handleSearch 가 authLocked 로 별도 차단.
      sx={authLocked ? { pointerEvents: 'none', opacity: 0.5 } : undefined}
      conditions={
        <>
          {/* View (Plant/Packer) — AS-IS FpSpread 시트탭(shtMain/shtPacker) TO-BE 등가 컨트롤.
              단일 DataGrid 에는 시트탭 표준이 없어 조회조건 상단 토글로 대체(design 01 §2.1 activeSheet state).
              시트 전환 = cascade 공급 콤보(PlantSite/Line) 교체 + 하위 초기화(setMode). 04_react-gap G1 참조. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00697', '_View')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.mode}
                  options={[
                    { label: t(LBL.PLANT, '_Plant'), value: LINE_MODE.PLANT },
                    { label: t('LBL00698', '_Packer'), value: LINE_MODE.PACKER },
                  ]}
                  onChange={(_, picked) =>
                    setMode((picked as LINE_MODE) === LINE_MODE.PACKER ? LINE_MODE.PACKER : LINE_MODE.PLANT)
                  }
                />
              )}
            />
          </Grid>

          {/* Division* (cascade 최상위, 필수 — design 02 §2.1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    // division 변경 = 하위 cascade 전체 초기화 (design 02 §3)
                    set({
                      divisionId: String(picked ?? ''),
                      plantSiteIds: [],
                      buildingIds: [],
                      operationIds: [],
                      lineIds: [],
                    })
                  }
                />
              )}
            />
          </Grid>

          {multi(LBL.PLANT_SITE, '_Plant Site', sc.plantSiteIds, plantSiteOptions, plantSiteIds =>
            // plantSite 변경 = line 초기화 (design 02 §3)
            set({ plantSiteIds, lineIds: [] })
          )}

          {/* Building / Operation 은 Plant 시트에서만 노출 (Packer 조회 SP 입력에 없음 — design 03 §4.3) */}
          {isPlant &&
            multi(LBL.BUILDING, '_Building', sc.buildingIds, buildingOptions, buildingIds =>
              set({ buildingIds })
            )}
          {isPlant &&
            multi(LBL.OPERATION, '_Operation', sc.operationIds, operationOptions, operationIds =>
              set({ operationIds })
            )}

          {multi(LBL.LINE, '_Line', sc.lineIds, lineOptions, lineIds => set({ lineIds }))}

          {/* Valid (독립 — 기본 전체) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.VALID, '_Valid')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.valid}
                  options={validOptions}
                  onChange={(_, picked) => set({ valid: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
