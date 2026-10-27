// 같은 feature(supply) 안의 공용 팝업 — baseUrl 기준 비상대 경로(상대경로 import 금지, Top11 #1).
import { CapaItemPopup } from 'features/supply/src/components';
import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import {
  ALL,
  DIVISION_TYPE,
  FALLBACK_LABEL,
  LBL,
  SHOP_GROUP_BY_DIVISION_TYPE,
  type DivisionType,
} from '../capa-line-assign.constants';
import type { ComboOption } from '../capa-line-assign.types';
import type { useCapaLineCascade } from '../hooks/useCapaLineCascade';
import { useCapaLineAssignStore } from '../useCapaLineAssignStore';

import styles from './CapaLineAssignForm.module.scss';

interface Props {
  cascade: ReturnType<typeof useCapaLineCascade>;
  onSearch: () => void;
}

/**
 * 영역2 조회조건 (design 02 §5.1).
 *
 * 12필드라 hook #52 기준(12-column 그리드 2단 = 6필드) 초과 → 3단째부터 `extraConditions` 로 분리한다.
 *   1단 conditions      : Division · Plan Month · Version · Plan Type(readOnly)
 *   2단 conditions      : Division Type · Site
 *   3단~ extraConditions: Plant · Building · Line · Operation · Line Type · Item(+팝업) · Valid
 *
 * 축 A(`divisionType`) 는 조회조건이 아니라 화면 모드 스위치다 — Operation/Line Type 노출과
 * Item 라벨까지 동시에 가른다(R-04~R-06). Operation 과 Line Type 은 **서로 배타**이므로 한 자리에
 * 겹치지 않고 각각 조건부 렌더한다.
 *
 * 조회조건 변경만으로는 조회가 발사되지 않는다 — `setFilters()` 참조 교체만이 트리거다(V-25).
 */
export const CapaLineAssignForm = ({ cascade, onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useCapaLineAssignStore(s => s.searchParams);
  const setSearchParams = useCapaLineAssignStore(s => s.setSearchParams);
  const setDivision = useCapaLineAssignStore(s => s.setDivision);
  const changeDivisionType = useCapaLineAssignStore(s => s.changeDivisionType);
  const openSearchArea = useCapaLineAssignStore(s => s.openSearchArea);

  const tabId = useTabid();

  const [openItemPopup, setOpenItemPopup] = useState(false);

  const isEltr = sc.divisionType === DIVISION_TYPE.ELTR;
  // 권한 Division 0건이면 조회조건 **전 영역** 비활성(AS-IS `SetDivisionAuthCheck` 는 패널 100% 비활성).
  //   부분 비활성 금지(design 01 R-22 / CP-02).
  const locked = !cascade.hasDivisionAuth;

  // ── 기본값 — AS-IS 는 DataSource 바인딩 첫 행이 자동 선택된다(design 02 §4.2) ──────────
  //   값 축(`sc.divisionId`)을 deps 에 둬 F10(조회조건 초기화)로 값이 비면 자가복구한다 —
  //   F10 은 store.reset()으로 divisionId 를 initState('') 로 되돌리는데, 콤보 목록
  //   (`cascade.divisionOptions`)은 Division 선택과 무관해 바뀌지 않으므로 목록 축만 보면
  //   effect 가 재발화하지 않아 Division 이 빈 채로 남는다(삭제형). 값 축을 더해 초기 상수(첫 행)
  //   로 되돌린다 — basic-check #4, 메모리 `f10-wipes-mount-seeded-default-dates` 패턴.
  useEffect(() => {
    const first = cascade.divisionOptions[0]?.value ?? '';
    if (!sc.divisionId && first) setSearchParams({ divisionId: first });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cascade.divisionOptions, sc.divisionId]);

  useEffect(() => {
    const options = cascade.verIdOptions;
    if (options.length === 0) return;
    if (options.some(option => option.value === sc.verId)) return;
    // Plan Month 기본 = 첫 행(콤보 SQL `VER_ID DESC` = 최신 Plan Month, V-04).
    //   값 축(`sc.verId`)을 deps 에 둬 F10 으로 verId 가 비면(Division 재시드로 후보가 다시 차는
    //   순간) 첫 행으로 자가복구한다(위 Division effect 와 같은 이유).
    setSearchParams({ verId: options[0].value, verSeq: '' });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cascade.verIdOptions, sc.verId]);

  useEffect(() => {
    const options = cascade.verSeqOptions;
    if (options.length === 0) return;
    if (options.some(option => option.value === sc.verSeq)) return;
    // Version 기본 = 첫 행(`VER_SEQ DESC` = 최대 Seq). 값 축(`sc.verSeq`)으로 F10 자가복구.
    setSearchParams({ verSeq: options[0].value });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cascade.verSeqOptions, sc.verSeq]);

  // S05 Division Type — AS-IS RadioGroup 3택. NSCM 공용에 RadioGroup 이 없어 단일선택 드롭다운으로
  //   매핑한다(자매 SCP0114 선례, 의미 동일). `Module/Pack` 은 등가 LBL 미등록 → 영문 defaultValue.
  const divisionTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: t(LBL.ELECTRODE, '_Electrode'), value: String(DIVISION_TYPE.ELTR) },
      { label: t(LBL.CELL, '_Cell'), value: String(DIVISION_TYPE.CELL) },
      { label: FALLBACK_LABEL.MODULE_PACK, value: String(DIVISION_TYPE.MODULE_PACK) },
    ],
    [t]
  );

  // S14 Valid — `DataBind(Type.YesOrNo, true)` 가 ALL 을 선행 추가한다(cs:1737). 기본 ALL.
  const validOptions = useMemo<ComboOption[]>(
    () => [{ label: t(LBL.ALL, '_All'), value: ALL }, ...cascade.validOptions],
    [cascade.validOptions, t]
  );

  /**
   * 조회조건 Reset (CP-16 / design 01 §3.1) — AS-IS `UsrConditionPanel` 의 조건 초기화 경로
   * (`SavePanelCondition` 주석 cs:1548·1558). §4.2 기본값으로 되돌린다.
   *
   * Division Type 은 조건이 아니라 **화면 모드 스위치**라 건드리지 않는다 — 되돌리면 두 탭이 통째로
   * 초기화된다(R-01). 숨겨지는 축(ELTR 의 Operation·Line Type)은 `[]` 로 남긴다(U-3).
   */
  const handleResetCondition = () => {
    const hiddenAxisValue = isEltr ? [] : [ALL];
    const defaultVerId = cascade.verIdOptions[0]?.value ?? '';
    setSearchParams({
      divisionId: cascade.divisionOptions[0]?.value ?? '',
      verId: defaultVerId,
      // Plan Month 가 그대로면 Version 후보가 재계산되지 않아 기본값 effect 가 돌지 않는다 —
      //   그 경우에만 현재 후보의 첫 행을 직접 넣는다.
      verSeq: defaultVerId === sc.verId ? (cascade.verSeqOptions[0]?.value ?? '') : '',
      siteIds: [ALL],
      plantIds: [ALL],
      factoryIds: [ALL],
      lineIds: [ALL],
      operationIds: hiddenAxisValue,
      electrodeTypes: hiddenAxisValue,
      itemId: '',
      validYn: ALL,
    });
  };

  const singleField = (
    labelCode: string,
    labelEn: string,
    value: string,
    options: ComboOption[],
    onPick: (code: string) => void,
    extra?: { autoFocus?: boolean }
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, { defaultValue: labelEn })}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            autoFocus={extra?.autoFocus}
            disabled={locked}
            value={value}
            options={options}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  // 다중선택 5축 — 기본 `ALL`. `'ALL'` sentinel 은 서버로 나가지 않는다(store `setFilters` 가 펼친다).
  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: ComboOption[],
    onPick: (codes: string[]) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, { defaultValue: labelEn })}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            disabled={locked}
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              onPick(
                String(picked ?? '')
                  .split(',')
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );

  return (
    <>
      <SearchArea
        searchButtonLabel={t(LBL.SEARCH, '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        onResetCondition={handleResetCondition}
        conditions={
          <>
            {/* S01 Division — 단일선택, ALL 없음. 기본 포커스(AS-IS TabIndex 0).
                Division 변경 = TO-BE 공통 요건: Division 을 제외한 검색조건 전부 초기화 + 두 그리드
                초기화(store `setDivision`). AS-IS `cboDivision_SelectedIndexChanged`(cs:5510-5519)는
                `RefreshAll()`(cs:2005-2015)로 Site·Plant·Factory·Line·Operation·ElectrodeType 6축
                DataSource 를 전부 재생성해 이전 선택을 지운다 — 하위를 비우지 않으면 이전 Division 의
                코드가 `toCsv` 로 펼쳐져 SP 파라미터에 실린다(잠복 결함). 모드(`divisionType`)별 빈값
                규약은 store `changeDivisionType` 과 동일(U-3). 편집중(dirty)이면 MSG00704 confirm 후에만
                실행, 취소 시 controlled 콤보가 이전 Div 로 자동 복귀(commit 51d4e9fa 패턴). */}
            {singleField(
              LBL.DIVISION,
              'Division',
              sc.divisionId,
              cascade.divisionOptions,
              code => {
                void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                  if (ok) setDivision(code);
                });
              },
              { autoFocus: true }
            )}
            {/* S02 Plan Month(VER_ID) / S03 Version(VER_SEQ) — CapaVersion 1회 조회의 클라 파생. */}
            {singleField(LBL.PLAN_MONTH, 'Plan Month', sc.verId, cascade.verIdOptions, code =>
              setSearchParams({ verId: code, verSeq: '' })
            )}
            {singleField(LBL.VERSION, 'Version', sc.verSeq, cascade.verSeqOptions, code =>
              setSearchParams({ verSeq: code })
            )}
            {/* S04 Plan Type — 읽기전용 파생 표시(`txtPlanType.Enabled=false`, V-05). store 불필요. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.PLAN_TYPE, '_Plan Type')}
                labelAlign='right'
                render={() => <InputField fullWidth readOnly disabled value={cascade.planType} />}
              />
            </Grid>
            {/* S05 Division Type — 화면 모드 스위치. 변경 시 두 탭 전면 초기화(R-01).
                AS-IS `lciDivisionType` 은 `TextVisible=false` = 라벨 없는 라디오 3택이므로
                라벨을 새로 만들지 않는다(임의 문구 추가 = AS-IS 와 달라짐). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label=''
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    disabled={locked}
                    value={String(sc.divisionType)}
                    options={divisionTypeOptions}
                    onChange={(_, picked) =>
                      changeDivisionType(Number(picked ?? DIVISION_TYPE.ELTR) as DivisionType)
                    }
                  />
                )}
              />
            </Grid>
            {/* S06 Site */}
            {multiField(LBL.SITE, 'Site', sc.siteIds, cascade.siteOptions, codes =>
              // 상위 변경 시 하위 초기화 — 배열은 `['ALL']`(design 02 §5.4).
              setSearchParams({
                siteIds: codes,
                plantIds: [ALL],
                factoryIds: [ALL],
                lineIds: [ALL],
              })
            )}
          </>
        }
        extraConditions={
          <>
            {/* S07 Plant */}
            {multiField(LBL.PLANT, 'Plant', sc.plantIds, cascade.plantOptions, codes =>
              setSearchParams({ plantIds: codes, factoryIds: [ALL], lineIds: [ALL] })
            )}
            {/* S08 Building(컨트롤명은 Factory) — Site 가 아니라 Plant 에 종속된다(V-10). */}
            {multiField(LBL.BUILDING, 'Building', sc.factoryIds, cascade.factoryOptions, codes =>
              setSearchParams({ factoryIds: codes, lineIds: [ALL] })
            )}
            {/* S09 Line — `_A`/`_C` 접미 커스텀 정렬 적용분(V-19). */}
            {multiField(LBL.LINE, 'Line', sc.lineIds, cascade.lineOptions, codes =>
              setSearchParams({ lineIds: codes })
            )}
            {/* S10 Operation — Cell/Module-Pack 에서만 노출(R-04 — AS-IS `SetVisibleOperation`
                cs:5556-5566 은 ELTR 을 Never 로 숨긴다). Line 을 바꿔도 후보가 변하지 않는다(V-11). */}
            {!isEltr &&
              multiField(
                LBL.OPERATION,
                'Operation',
                sc.operationIds,
                cascade.operationOptions,
                codes => setSearchParams({ operationIds: codes, electrodeTypes: [ALL] })
              )}
            {/* S11 Line Type — Cell/Module-Pack 에서만 노출(R-05). Operation 과 **같은 방향**이다
                (`SetVisibleElectrodeType` cs:5568-5584 — ELTR 은 둘 다 숨김). CODE=NAME(V-14). */}
            {!isEltr &&
              multiField(
                LBL.LINE_TYPE,
                'Line Type',
                sc.electrodeTypes,
                cascade.electrodeTypeOptions,
                codes => setSearchParams({ electrodeTypes: codes })
              )}
            {/* S12+S13 Item — 라벨이 모드로 바뀐다(Basic Nickname ↔ Model, R-06). 버튼이 P01 팝업. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(isEltr ? LBL.MODEL : LBL.BASIC_NICKNAME, {
                  defaultValue: isEltr ? 'Model' : 'Basic Nickname',
                })}
                labelAlign='right'
                render={() => (
                  <div className={styles.itemField}>
                    <InputField
                      fullWidth
                      disabled={locked}
                      value={sc.itemId}
                      onChange={event => setSearchParams({ itemId: event.target.value })}
                      onKeyDown={event => event.key === 'Enter' && onSearch()}
                    />
                    <Button
                      className={styles.itemPopupButton}
                      appearance='outlined'
                      priority='normal'
                      size='small'
                      buttonLabel='...'
                      disabled={locked}
                      onClick={() => setOpenItemPopup(true)}
                    />
                  </div>
                )}
              />
            </Grid>
            {/* S14 Valid — 'ALL' 은 SP 로 '' 로 나간다(V-18). */}
            {singleField(LBL.VALID, 'Valid', sc.validYn, validOptions, code =>
              setSearchParams({ validYn: code || ALL })
            )}
          </>
        }
      />

      {/*
        P01 Item 팝업 — 기존 공용 컴포넌트 재사용(`features/supply/src/components/CapaItemPopup`).
        AS-IS `ShowItem` 은 `Init(multiSelect=true, …, shop_group, …)`(cs:5860)이라 **다중선택**이고,
        `OPERATION_GROUP IN (shop_group)` 필터는 조회 직후 **목록 자체**에 걸린다
        (SCM0002_CAPAItemPopup.cs:301-303). 공용 컴포넌트가 두 계약을 `multiSelect`/`operationGroup`
        prop 으로 이미 제공한다(기본값 = 기존 호출부 동작 보존) — 자기 화면 배선만으로 등가가 된다.
      */}
      <CapaItemPopup
        multiSelect
        open={openItemPopup}
        operationGroup={SHOP_GROUP_BY_DIVISION_TYPE[sc.divisionType]}
        params={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        onClose={() => setOpenItemPopup(false)}
        onSelect={(_, selectedAll) => {
          // CELL/MODULE_PACK 은 NICK_NAME, ELTR 은 ITEM_ID 를 텍스트로 받는다(cs:5864-5875).
          //   `GetSelectedValuesText` = 공백 제거 + distinct + `','` 결합(SCM0002_CAPAItemPopup.cs:139·158).
          //   결과가 빈 문자열이면 AS-IS 도 대입하지 않는다(cs:5999-6002).
          const picked = [
            ...new Set(
              selectedAll
                .map(selection => (isEltr ? selection.itemId : (selection.nickName ?? '')))
                .filter(Boolean)
            ),
          ].join(',');
          if (picked) setSearchParams({ itemId: picked });
        }}
      />
    </>
  );
};
