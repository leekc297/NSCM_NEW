import {
  MaterialByDivisionModal,
  PeriodField,
  ProjectField,
} from 'features/master/src/components';
import { useEffect, useRef, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID } from '../shipment-request.constants';
import { useShipmentRequestStore } from '../useShipmentRequestStore';
import { isDiv40 } from '../utils/shipment-request.division';
import {
  BUCKET_LOOKUP_TYPE,
  SEARCH_COMBO,
  buildOrderedComboOptions,
} from '../utils/shipment-request.searchCombos';

// AS-IS DMF0045_ShipmentRequest 조회조건 (design 02 §1 영역2 인벤토리 — cs OnShown/InitCombo 실측).
//   칸-콤보 대응표 (SCM_ADM_CMBO_SQL_M / LOOKUP 등록 SQL_ID — memory search-condition-combo-header):
//     Div*        MyDivision                    권한조인 사업부 (단일, 필수) — cascade root
//     Team        UserTeamByDivision            Division
//     End Customer UserEndCustomerByDivisionDept Division + Team
//     Sales Site  UserSiteByEndCustomer         Division + End Customer (+40 팀변경 시 DEPT_ID)
//     Plant Site  UserPlantSiteByDivision       Division (40 비활성)
//     Period*     -                             오늘~오늘+55일(8주). AS-IS drpPeriod readOnly 였으나
//                                               TO-BE 표준(DM 자매화면 DMF0040)은 편집 가능 PeriodField.
//                                               readOnly 재현은 shared 컴포넌트 개변이 필요해 미이식
//                                               (__asis-mapping__ 기록). 기본값은 store init 이 고정.
//     Bucket*     BUCKET_TYPE_CODE (LOOKUP)      D/W/M (기본 Daily). 변경 가드는 페이지가 담당.
//     Project     팝업 ProjectByDivisionModal    40 비활성 (design 02 §3)
//     Model/Nickname 팝업 MaterialByDivisionModal 상시 활성 — SSP0014 정합(사용자 지시 2026-10-23).
//                                               종전 ItemByDivisionModal(ItemField)에서 교체.
//   원천·축·AS-IS 라인의 상세는 utils/shipment-request.searchCombos 참조.
interface ShipmentRequestFormProps {
  onSearch: () => void;
  // Division 변경 = Grid 초기화(비움) + CRUD reset 의무 — 부모(ShipmentRequest.tsx)가 수행.
  //   재조회는 Search 버튼이며 여기서는 하위 종속필드만 clear 한다.
  onDivisionChange: () => void;
  // Bucket 변경 가드 = 페이지가 담당(위 헤더표 Bucket* 주석). 변경분(pending) 존재 시 MSG00227 차단.
  //   Form 은 후보 버킷만 넘기고 실제 store 반영/차단 판정은 부모(ShipmentRequest.tsx)가 수행한다.
  onBucketChange: (next: BUCKET_TYPE) => void;
}

export const ShipmentRequestForm = ({
  onSearch,
  onDivisionChange,
  onBucketChange,
}: ShipmentRequestFormProps) => {
  const { t } = useTranslation();

  const sc = useShipmentRequestStore(s => s.searchCondition);
  const set = useShipmentRequestStore(s => s.setSearchCondition);
  const setDivision = useShipmentRequestStore(s => s.setDivision);
  const openSearchArea = useShipmentRequestStore(s => s.openSearchArea);

  const tabId = useTabid();
  const div40 = isDiv40(sc.divisionId);

  // Model/Nickname 팝업(MaterialByDivisionModal) open 상태 + 입력 로컬 텍스트.
  //   itemIds 는 배열 저장이라 콤마 편집 중 split+filter 로 입력 콤마가 즉시 소실된다(2026-09-16 기수정
  //   버그). 포커스 동안은 로컬 텍스트를 그대로 보여주고 blur/외부 변경 시에만 재동기화한다
  //   (SearchFields PopupSearchInput 규약과 동일).
  const [openItem, setOpenItem] = useState(false);
  const [itemText, setItemText] = useState(sc.itemIds.join(','));
  const itemFocusedRef = useRef(false);
  useEffect(() => {
    if (!itemFocusedRef.current) setItemText(sc.itemIds.join(','));
  }, [sc.itemIds]);

  // AS-IS cascade = 서버 재조회(refetch) — 상위 선택값을 콤보 @파라미터로 실어 하위를 다시 읽는다
  //   (design 02 §3/§5). react-query 파라미터 의존 자동 refetch(직접 호출 금지). BE makeComboQuery 는
  //   세션값(sesUserId/mnuId)만 자동 인용하므로 FE 가 넘기는 @파라미터는 홑따옴표로 감싼다
  //   (ItemByDivisionModal 규약). 멀티선택은 콤마 리스트, 미선택은 'ALL'(콤보 SQL NVL/INSTR 가드).
  //   전부 AS-IS명 콤보(UP_FX_GetCommonDataList @Code)로 @파라미터 서버 재조회 — 클라 축 없음.
  const q = (v: string): string => `'${v}'`;
  const divParam = q(sc.divisionId);
  const deptParam = q(sc.deptIds.length > 0 ? sc.deptIds.join(',') : 'ALL');
  const ecParam = q(sc.endCustomers.length > 0 ? sc.endCustomers.join(',') : 'ALL');
  const [divisions, teams, endCustomers, salesSites, plantSites] = useTabComboQueries({
    filters: [
      SEARCH_COMBO.division, // MyDivision (root, AS-IS cs:200) — 파라미터 없음
      // TeambyDivision(@divisionId) — AS-IS Division 재조회. validYn 미전달=전체(AS-IS Team 은 VALID 필터 없음)
      { comboId: SEARCH_COMBO.team, divisionId: divParam },
      // EndCustomerByDivisionDept(@divisionId,@deptId) — AS-IS Division+Team 재조회
      { comboId: SEARCH_COMBO.endCustomer, divisionId: divParam, deptId: deptParam },
      // SiteByEndCustomer(@divisionId,@endCustomer,@validYn) — AS-IS 는 VALID_YN='Y' 고정 → validYn='Y'
      { comboId: SEARCH_COMBO.salesSite, divisionId: divParam, endCustomer: ecParam, validYn: q('Y') },
      // FromSiteByDivision(@divisionId,@validYn) — AS-IS Plant Site 는 Data.UserPlantSiteByDivision
      //   → @Code='FromSiteByDivision'(PLANT+권한, NAME=SCM_SITE_ID 코드)이지 PlantSiteByDivision 아님.
      //   AS-IS 분기엔 VALID_YN 필터가 없어 비활성 사이트도 포함 → validYn='N'(valid 필터 off)으로 등가.
      { comboId: SEARCH_COMBO.plantSite, divisionId: divParam, validYn: q('N') },
    ],
  });

  // Bucket 은 CMBO 가 아니라 LOOKUP 정적 콤보다(design 02 §2-6 — SCM_ADM_LOOKUP_MASTER_DETAIL
  //   LOOKUP_TYPE='BUCKET_TYPE_CODE'). CMBO SQL_ID 로는 미등록이라 CMBO 경로로 조회하면 0행이다.
  const [bucketTypeLookup] = useTabLookupQueries({
    filters: [{ lookupType: BUCKET_LOOKUP_TYPE }],
  });

  // CODE='40'(Mobility) 제외 — AS-IS InitControls(DMF0045_ShipmentRequest.cs:203-204)가 콤보에서
  //   40 을 제거한다(design 02 §2.1). DMF0045 는 40 미지원이고 컬럼 메타도 82/81/81_UC 만 등록돼,
  //   40 을 노출하면 선택 시 컬럼 0행 → fallback 없는 그리드가 완전 공백이 된다.
  //   Division(MyDivision)은 DIVISION_ID 미출력 root 라 축 없음.
  const divisionOptions = buildOrderedComboOptions(divisions).filter(o => o.value !== DIVISION.MOBILITY);

  // Team/EndCustomer/SalesSite/PlantSite 는 서버가 @파라미터로 이미 좁혀 CODE/NAME 만 내려주므로
  //   클라 축을 걸지 않는다 — 걸면 DIVISION_ID 부재로 엄격매칭에서 전 행이 잘려 옵션 0건이 된다
  //   (bigFilterCombo 헤더 "재조회 응답에는 축을 걸지 말 것").
  const teamOptions = buildOrderedComboOptions(teams);
  const endCustomerOptions = buildOrderedComboOptions(endCustomers);
  const salesSiteOptions = buildOrderedComboOptions(salesSites);
  const plantSiteOptions = buildOrderedComboOptions(plantSites);

  // Bucket 옵션 — CMBO CODE 풀워드(DAILY/WEEKLY/MONTHLY) → 첫 글자 enum 매핑 + 정적 fallback.
  const bucketLabelKey: Record<string, string> = {
    [BUCKET_TYPE.DAILY]: 'LBL00682',
    [BUCKET_TYPE.WEEKLY]: 'LBL00683',
    [BUCKET_TYPE.MONTHLY]: 'LBL00684',
  };
  const bucketFallback = [
    { label: t('LBL00682', '_Daily'), value: BUCKET_TYPE.DAILY },
    { label: t('LBL00683', '_Weekly'), value: BUCKET_TYPE.WEEKLY },
    { label: t('LBL00684', '_Monthly'), value: BUCKET_TYPE.MONTHLY },
  ];
  const bucketOptions =
    bucketTypeLookup && bucketTypeLookup.length > 0
      ? bucketTypeLookup
          .map(item => {
            const code = String(item.CODE ?? '').charAt(0) as BUCKET_TYPE;
            return { label: t(bucketLabelKey[code] ?? '', String(item.NAME ?? code)), value: code };
          })
          .filter(
            o =>
              o.value === BUCKET_TYPE.DAILY ||
              o.value === BUCKET_TYPE.WEEKLY ||
              o.value === BUCKET_TYPE.MONTHLY
          )
      : bucketFallback;

  // 다중선택 조회조건 한 벌. 조회조건 드롭다운은 전부 표시명 순으로 둔다 — 눈으로 찾는 목록이라
  //   콤보 SQL 의 ORDER BY 보다 이쪽이 낫다(DM 자매화면 정본). Division 만 단일선택이다.
  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: { label: string; value: string }[],
    onPick: (codes: string[]) => void,
    extra?: { disabled?: boolean }
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
            disabled={extra?.disabled}
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
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — Division*(단일) / Team / End Customer / Period (사용자 지시 2026-10-29) */}
          {/* Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화 (store setDivision + onDivisionChange,
              TO-BE 공통 요건 — AS-IS clbDivision_SelectedIndexChanged 의 Team/EC/Site/Plant 재조회 +
              Project/Item 클리어 + InitSpread 를 포함하며 Bucket/Sum 까지 초기값으로 되돌린다).
              편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로
              자동 복귀(commit 51d4e9fa 패턴). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, option) => {
                    const next = String(option ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      setDivision(next);
                      onDivisionChange();
                    });
                  }}
                />
              )}
            />
          </Grid>
          {multiField(
            'LBL00044',
            'Team',
            sc.deptIds,
            teamOptions,
            v => set({ deptIds: v, endCustomers: [], scmSiteIds: [] }, 'team')
          )}
          {multiField(
            'LBL00080',
            'End Customer',
            sc.endCustomers,
            endCustomerOptions,
            v => set({ endCustomers: v, scmSiteIds: [] }, 'endCustomer')
          )}
          {/* Period* — 사용자 지시 2026-10-29: 접기 영역에서 Row1 4번째 칸으로 승격(항상 표시).
              오늘~오늘+55일 store init 고정. AS-IS drpPeriod.Enabled=false(Designer.cs:515,
              design 01 §2 L2 / design 02 §4) 입력 잠금 재현(disabled). 값 8주 기본 고정. */}
          <PeriodField
            gridSize={3}
            start={sc.startYyyymmdd}
            end={sc.endYyyymmdd}
            disabled
            onChange={(start, end) => set({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          {/* Row 2 — Sales Site / PJT*(40 비활성) / Model·Nickname / From Site(40 비활성)
              사용자 지시 2026-10-29: Sales Site 를 Row1→Row2 선두로, Plant Site 를 Row2 마지막(From Site)으로. */}
          {multiField('LBL00011', 'Sales Site', sc.scmSiteIds, salesSiteOptions, v =>
            set({ scmSiteIds: v })
          )}
          {/* Project → 'PJT' 표기(LBL00012, 사용자 지시 2026-10-29). ProjectField labelCode override. */}
          <ProjectField
            gridSize={3}
            value={sc.projectCodes}
            onChange={v => set({ projectCodes: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            disabled={div40}
            multiCheckbox
            labelCode='LBL00012'
          />
          {/* Model/Nickname — SSP0014 정합(사용자 지시 2026-10-23): 공용 MaterialByDivisionModal
              (COM0013, SCM0002_MaterialByDivisionPopup)로 교체(종전 ItemField/ItemByDivisionModal).
              입력 + 돋보기 → 팝업. preSearchParams 는 SSP0014 와 동일 구성(divisionId / scpModuleType=
              화면ID / operationGroup 공란 / 현재 입력 itemId). 팝업 선택 결과 ITEM_ID(콤마결합)를
              itemIds 로 채운다(빈 선택이면 미반영 — AS-IS 파리티). 팝업은 자체적으로 닫힌다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00618', '_Model / Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={itemText}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={() => setOpenItem(true)}
                      />
                    ),
                  }}
                  onFocus={() => {
                    itemFocusedRef.current = true;
                  }}
                  onBlur={() => {
                    itemFocusedRef.current = false;
                    setItemText(sc.itemIds.join(','));
                  }}
                  onChange={e => {
                    const v = e.target.value;
                    setItemText(v);
                    set({
                      itemIds: v
                        .split(',')
                        .map(s => s.trim())
                        .filter(Boolean),
                    });
                  }}
                />
              )}
            />
          </Grid>
          <MaterialByDivisionModal
            open={openItem}
            modalClose={() => setOpenItem(false)}
            setSelectedValue={items => {
              if (items)
                set({
                  itemIds: items
                    .split(',')
                    .map(s => s.trim())
                    .filter(Boolean),
                });
            }}
            preSearchParams={{
              divisionId: sc.divisionId,
              scpModuleType: MENU_ID,
              operationGroup: '',
              itemId: sc.itemIds.join(','),
            }}
          />
          {/* From Site(=AS-IS Plant Site, LBL00022 표기, 사용자 지시 2026-10-29) / 40 비활성.
              콤보 원천·동작은 Plant Site 그대로(SEARCH_COMBO.plantSite), 표시 라벨만 From Site. */}
          {multiField(
            'LBL00022',
            'From Site',
            sc.plantSiteIds,
            plantSiteOptions,
            v => set({ plantSiteIds: v }),
            { disabled: div40 }
          )}
        </>
      }
      // 기본 2줄(Row 1-2) 노출, Bucket(Row 3)만 펼침/접기(chevron) — MktFcst(mkt-fcst) 동일 패턴.
      //   SearchArea 가 extraConditions 존재 시 chevron(↓/↑) 토글을 자동 노출(기본 접힘).
      //   사용자 지시 2026-10-29: 접기 영역을 Period → Bucket 으로 교체(Period 는 Row1 로 승격).
      extraConditions={
        <>
          {/* Row 3(접기) — Bucket. 기본값 Daily(OnShown cs:179 강제). AS-IS cboBucketType. */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_Bucket')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.bucketType}
                  options={bucketOptions}
                  onChange={(_, option) => onBucketChange(option as BUCKET_TYPE)}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
