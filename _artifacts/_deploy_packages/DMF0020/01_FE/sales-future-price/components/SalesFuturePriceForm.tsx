import { useEffect, useMemo, useState } from 'react';

import { CustomDropdown } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { ItemByDivisionModal, OwnerByDivisionModal, ProjectByDivisionModal } from '../../../components';
import { BUCKET_TYPE, MENU_ID, SHEETS } from '../sales-future-price.constants';
import { useDivisionRole } from '../hooks/useSalesFuturePriceExpression';
import { useSalesFuturePriceStore } from '../useSalesFuturePriceStore';

import styles from '../SalesFuturePrice.module.scss';

interface Props {
  onSearch: () => void;
  onVersionOpen: () => void;
}

interface LookupRow {
  CODE?: string | number;
  NAME?: string | number;
}

// CODE / NAME → label format. 메모리 feedback_no_type_cast_around_runtime: NUMBER → String 명시
const toOptions = (rows: LookupRow[] | undefined) => {
  const arr = (rows ?? []) as LookupRow[];
  if (arr.length === 0) return [];
  return arr
    .map(r => {
      const code = String(r.CODE ?? '');
      const name = String(r.NAME ?? code);
      const label = code === name || name === '' ? code : `${code} (${name})`;
      return { value: code, label };
    })
    .filter(o => o.value !== 'ALL' && o.value !== '');
};

// AS-IS DMF0020_SalesFuturePrice.cs 14 조회 조건 (tobe_design.md §9.1 / analysis.md §18.1):
//   1. clbDivisions    (필수) — Division ComboBox
//   2. clbTeam         (다중) — Team CheckedList
//   3. clbEndCustomer  (다중) — End Customer CheckedList
//   4. clbSalesSite    (다중) — Sales Site CheckedList
//   5. clbPlantSite    (다중, div=81 ESS) — Plant Site
//   6. umltModel + btnItemId (popup) — Model / Nickname
//   7. umltProject + usrButton1 (popup) — Project
//   8. drpDateTime (필수) — Period Range
//   9. clbBizType (다중) — Biz Type
//  10. txtOwner + btnOwner (popup) — Owner
//  11. cboBucketType (필수, W/M) — Bucket Type
//  12. usrDiscard — Search over range
//  13. checkInvalidExec — Price 미등록 제외
//  14. txtVersion + btnSPVer (popup) — Version
//
// 동적 의존:
//   Division 변경 → Team / EndCustomer / SalesSite / BizType / PlantSite 재조회 + Grid 재초기화
//   EndCustomer 변경 → PlantSite 재조회 (Division=81)
//   BucketType 변경 → Grid 우측 W_/M_ Visible Toggle (Expression hook 처리)
export const SalesFuturePriceForm = ({ onSearch, onVersionOpen }: Props) => {
  const sc = useSalesFuturePriceStore(s => s.searchCondition);
  const set = useSalesFuturePriceStore(s => s.setSearchCondition);

  const role = useDivisionRole(sc.divisionId);

  // ----- Lookup combos (Division-dependent) -----
  // SP 등록은 추가 phase. 현 단계는 enabled 가드만 두고 빈 결과 허용.
  const { data: divData } = useTabProcQuery({
    menuId: MENU_ID, sheetName: SHEETS.MAIN, filters: {}, enabled: false,  // TODO: 별도 lookup sheet 등록
  });

  const divisionOptions = useMemo(() => toOptions(divData?.o_rc1 as LookupRow[] | undefined), [divData]);
  // 기본 분기 옵션 (lookup SP 미등록 시 fallback)
  const fallbackDivisions = useMemo(() => [
    { value: '40', label: '40 (Mobility & IT Battery)' },
    { value: '81', label: '81 (ESS Battery)' },
    { value: '82', label: '82 (Power Tool)' },
  ], []);
  const divs = divisionOptions.length > 0 ? divisionOptions : fallbackDivisions;

  // Popup state
  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);
  const [openOwnerModal, setOpenOwnerModal] = useState(false);

  // Division 변경 시 종속 reset (AS-IS clbDivisions_SelectedIndexChanged 4건)
  useEffect(() => {
    set({
      deptIds: [], endCustomers: [], scmSiteIds: [],
      plantSiteIds: [], bizTypes: [],
    });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  // Division 기본값 자동 적용 — 필수 (AS-IS L1327 MSG00097 회피)
  useEffect(() => {
    if (!sc.divisionId && divs.length > 0) set({ divisionId: divs[0].value });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divs]);

  return (
    <div className={styles.searchBar}>
      <div className={styles.searchRow}>
        {/* 1. Division (필수) */}
        <label className={styles.field}>
          <span className={styles.required}>Division*</span>
          <CustomDropdown
            options={divs}
            value={sc.divisionId}
            onChange={v => set({ divisionId: String(v) })}
          />
        </label>

        {/* 8. Period (필수) */}
        <label className={styles.field}>
          <span className={styles.required}>Period*</span>
          <input
            type='text'
            value={sc.startYyyymmdd}
            onChange={e => set({ startYyyymmdd: e.target.value })}
            placeholder='YYYYMMDD'
            className={styles.input}
          />
          <span>~</span>
          <input
            type='text'
            value={sc.endYyyymmdd}
            onChange={e => set({ endYyyymmdd: e.target.value })}
            placeholder='YYYYMMDD'
            className={styles.input}
          />
        </label>

        {/* 11. Bucket Type (필수) */}
        <label className={styles.field}>
          <span className={styles.required}>Bucket*</span>
          <select
            value={sc.bucketType}
            onChange={e => set({ bucketType: e.target.value as 'W' | 'M' })}
            className={styles.input}
          >
            <option value={BUCKET_TYPE.WEEKLY}>Weekly</option>
            <option value={BUCKET_TYPE.MONTHLY}>Monthly</option>
          </select>
        </label>

        {/* 14. Version (필수) — popup */}
        <label className={styles.field}>
          <span className={styles.required}>Version*</span>
          <input
            type='text'
            value={sc.versionId}
            onChange={e => set({ versionId: e.target.value })}
            className={styles.input}
            placeholder='CURRENT'
          />
          <button type='button' onClick={onVersionOpen} className={styles.popupBtn}>…</button>
        </label>
      </div>

      <div className={styles.searchRow}>
        {/* 2. Team (다중) */}
        <label className={styles.field}>
          <span>Team</span>
          <input
            type='text'
            value={sc.deptIds.join(',')}
            onChange={e => set({ deptIds: e.target.value.split(',').map(s => s.trim()).filter(Boolean) })}
            className={styles.input}
            placeholder='comma-separated'
          />
        </label>

        {/* 3. End Customer (다중) */}
        <label className={styles.field}>
          <span>End Customer</span>
          <input
            type='text'
            value={sc.endCustomers.join(',')}
            onChange={e => set({ endCustomers: e.target.value.split(',').map(s => s.trim()).filter(Boolean) })}
            className={styles.input}
          />
        </label>

        {/* 4. Sales Site (다중) */}
        <label className={styles.field}>
          <span>Sales Site</span>
          <input
            type='text'
            value={sc.scmSiteIds.join(',')}
            onChange={e => set({ scmSiteIds: e.target.value.split(',').map(s => s.trim()).filter(Boolean) })}
            className={styles.input}
          />
        </label>

        {/* 5. Plant Site (div=81 ESS 전용, E8) */}
        {role.showPlantSite && (
          <label className={styles.field}>
            <span>Plant Site (ESS)</span>
            <input
              type='text'
              value={sc.plantSiteIds.join(',')}
              onChange={e => set({ plantSiteIds: e.target.value.split(',').map(s => s.trim()).filter(Boolean) })}
              className={styles.input}
            />
          </label>
        )}

        {/* 9. Biz Type (다중) */}
        <label className={styles.field}>
          <span>Biz Type</span>
          <input
            type='text'
            value={sc.bizTypes.join(',')}
            onChange={e => set({ bizTypes: e.target.value.split(',').map(s => s.trim()).filter(Boolean) })}
            className={styles.input}
          />
        </label>
      </div>

      <div className={styles.searchRow}>
        {/* 6. Model / Nickname (popup) */}
        <label className={styles.field}>
          <span>Model</span>
          <input
            type='text'
            value={sc.itemIds.join(',')}
            readOnly
            className={styles.input}
            onClick={() => setOpenItemModal(true)}
          />
          <button type='button' onClick={() => setOpenItemModal(true)} className={styles.popupBtn}>…</button>
          <input
            type='text'
            value={sc.nickName}
            onChange={e => set({ nickName: e.target.value })}
            className={styles.input}
            placeholder='nickname'
            style={{ width: '120px' }}
          />
        </label>

        {/* 7. Project (popup) */}
        <label className={styles.field}>
          <span>Project</span>
          <input
            type='text'
            value={sc.projectCodes.join(',')}
            readOnly
            className={styles.input}
            onClick={() => setOpenProjectModal(true)}
          />
          <button type='button' onClick={() => setOpenProjectModal(true)} className={styles.popupBtn}>…</button>
        </label>

        {/* 10. Owner (popup) */}
        <label className={styles.field}>
          <span>Owner</span>
          <input
            type='text'
            value={sc.owners.join(',')}
            readOnly
            className={styles.input}
            onClick={() => setOpenOwnerModal(true)}
          />
          <button type='button' onClick={() => setOpenOwnerModal(true)} className={styles.popupBtn}>…</button>
        </label>
      </div>

      <div className={styles.searchRow}>
        {/* 12. Search over range */}
        <label className={styles.checkboxField}>
          <input
            type='checkbox'
            checked={sc.searchOverRange}
            onChange={e => set({ searchOverRange: e.target.checked })}
          />
          Search over range
        </label>

        {/* 13. Price 미등록 제외 */}
        <label className={styles.checkboxField}>
          <input
            type='checkbox'
            checked={sc.excludeNoPrice}
            onChange={e => set({ excludeNoPrice: e.target.checked })}
          />
          Price 미등록 제외
        </label>

        <button type='button' className={styles.searchButton} onClick={onSearch}>🔍 조회 (F5)</button>
      </div>

      <ProjectByDivisionModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        setSelectedValue={(projects: string) => {
          set({ projectCodes: projects.split(',').map(s => s.trim()).filter(Boolean) });
          setOpenProjectModal(false);
        }}
        preSearchParams={{
          divisionId: sc.divisionId,
          deptId: sc.deptIds.join(','),
          endCustomer: sc.endCustomers.join(','),
          salesSite: sc.scmSiteIds.join(','),
          projectCode: sc.projectCodes.join(','),
          etc: 'N',
        } as never}
      />
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={(items: string) => {
          set({ itemIds: items.split(',').map(s => s.trim()).filter(Boolean) });
          setOpenItemModal(false);
        }}
        preSearchParams={{
          divisionId: sc.divisionId,
          deptId: sc.deptIds.join(','),
          endCustomer: sc.endCustomers.join(','),
          salesSite: sc.scmSiteIds.join(','),
          projectCode: sc.projectCodes.join(','),
          itemId: sc.itemIds.join(','),
        } as never}
      />
      <OwnerByDivisionModal
        open={openOwnerModal}
        modalClose={() => setOpenOwnerModal(false)}
        setSelectedValue={(owners: string) => {
          set({ owners: owners.split(',').map(s => s.trim()).filter(Boolean) });
          setOpenOwnerModal(false);
        }}
        preSearchParams={{ divisionId: sc.divisionId } as never}
      />
    </div>
  );
};
