import { useEffect, useState } from 'react';

import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../contribute-view.constants';
import type { VersionOption, ViewSearchCondition } from '../types';
import { useContributeViewStore } from '../useContributeViewStore';

import styles from './ContributeViewForm.module.scss';

interface Props {
  onSearch: () => void;
  onOpenVersionPopup: () => void;        // AS-IS btnSPVer_Click (.cs L453)
}

// AS-IS DMF0043_Contribute_View Designer.cs 조회조건 9 컨트롤 1:1 매핑
//   usrYear      (UsrCombo, DropDownList, width 139)  → Year SP 콤보
//   txtVersion   (UsrMultiLineEditor, readonly+popup) → Version (btnSPVer 로만 채움)
//   btnSPVer     (UsrButton, image, width 37)         → Version popup trigger
//   usrCust      (UsrMultiLineEditor, free-form)      → 고객군
//   usrType      (UsrCombo, DropDownList, width 109)  → 제품군 (DMF0005_REPORT_GROUP3, lookup SP 미등록 — free-form)
//   usrBiz       (UsrCombo, DropDownList, width 59)   → Biz (DM_BIZ_TYPE, lookup SP 미등록 — free-form)
//   chkM         (UsrCheckBox, Visible=false)         → [M$] 백만 단위 (As-IS hidden)
//   usrChk       (UsrCheckBox, Visible=false)         → 정합성 체크 (As-IS hidden)
//   btnColumn    (UsrButton, image, width 40)         → 컬럼 표시 설정 (SubTitle Button 영역으로 이동)
//   [신규] btnCutOff (AS-IS .cs L444 btnCutOff_Click)  → 기여율 버전관리 (Form 아이콘으로 대체)
export const ContributeViewForm = ({ onSearch, onOpenVersionPopup }: Props) => {
  const searchCondition = useContributeViewStore(s => s.searchCondition);
  const setSearchCondition = useContributeViewStore(s => s.setSearchCondition);

  // AS-IS InitControls (.cs L104~108) + GetVersionData — Year SP 콤보 데이터
  const { data: yearData, isLoading: yearLoading } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
    filters: {},
    enabled: true,
  });

  const [yearOptions, setYearOptions] = useState<VersionOption[]>([]);

  useEffect(() => {
    const rows = (yearData?.o_rc1 ?? []) as unknown as VersionOption[];
    setYearOptions(rows);
    // AS-IS InitControls — 첫 옵션 자동 선택
    // ⛔ Oracle NUMBER → JS number 자동 변환 위험 (메모: feedback_no_type_cast_around_runtime).
    //   String() 강제 변환 의무.
    if (rows.length > 0 && !searchCondition.verSeq) {
      const first = rows[0];
      setSearchCondition({
        verSeq: String(first.CODE ?? ''),
        yyyy: String(first.NAME2 ?? first.NAME ?? '').substring(0, 4),
      });
    }
  }, [yearData]);

  const setCond = (k: keyof ViewSearchCondition, v: string) =>
    setSearchCondition({ [k]: v } as Partial<ViewSearchCondition>);

  // AS-IS .cs L112: Data.Common(Data.Type.DMF0005_REPORT_GROUP3) — 제품군 lookup
  //   To-Be 의 standalone lookup SP 미등록 → 정적 옵션 + 추후 SCM_ADM_LOOKUP_MASTER_DETAIL
  //   (LOOKUP_TYPE='REPORT_GROUP2') 기반 SP 등록 후 동적 전환.
  const PRODUCT_GROUP_OPTIONS = [
    { value: 'ALL', label: 'ALL' },
    { value: 'LCD', label: 'LCD' },
    { value: 'OLED', label: 'OLED' },
    { value: 'TR', label: 'TR' },
    { value: 'POL', label: 'POL' },
  ];

  // AS-IS .cs L115: Data.Common(Data.Type.DM_BIZ_TYPE) — Biz lookup
  //   To-Be SCM_ADM_LOOKUP_MASTER_DETAIL (LOOKUP_TYPE='DM_BIZ_TYPE_40') 기반 추후 동적.
  const BIZ_TYPE_OPTIONS = [
    { value: 'ALL', label: 'ALL' },
    { value: 'SET', label: 'SET' },
    { value: 'BIZ', label: 'BIZ' },
    { value: 'Total', label: 'Total' },
  ];

  return (
    <div className={styles.searchBar}>
      <div className={styles.searchRow}>
        {/* AS-IS usrYear (Designer.cs L199~232): UsrCombo DropDownList */}
        <div className={styles.field}>
          <span className={styles.fieldLabel}>Year</span>
          <select
            className={styles.select}
            value={searchCondition.verSeq}
            onChange={e => {
              const opt = yearOptions.find(o => String(o.CODE) === e.target.value);
              // ⛔ NUMBER → String cast 의무 (메모: feedback_no_type_cast_around_runtime)
              setSearchCondition({
                verSeq: e.target.value,
                yyyy: String(opt?.NAME2 ?? opt?.NAME ?? '').substring(0, 4),
              });
            }}
          >
            <option value=''>{yearLoading ? '로딩 중...' : '선택'}</option>
            {yearOptions.map(o => (
              <option key={String(o.CODE)} value={String(o.CODE)}>
                {String(o.NAME2 ?? o.NAME ?? o.CODE)}
              </option>
            ))}
          </select>
        </div>

        {/* AS-IS txtVersion (Designer.cs L129~162): UsrMultiLineEditor readonly + btnSPVer 로만 채움 */}
        <div className={styles.field}>
          <span className={styles.fieldLabel}>Version</span>
          <input
            className={styles.input}
            type='text'
            readOnly
            value={searchCondition.versionNo}
            placeholder='버전 선택'
          />
          {/* AS-IS btnSPVer (Designer.cs L163~197): UsrButton image — Version popup */}
          <button
            type='button'
            className={styles.iconButton}
            onClick={onOpenVersionPopup}
            title='SP Version 선택'
            aria-label='SP Version 선택'
          >
            ⋯
          </button>
        </div>

        {/* AS-IS usrCust (Designer.cs L304~336): UsrMultiLineEditor free-form
            AS-IS .cs L313: p_end_cust_report = usrCust.Text (텍스트 그대로 SP 전달) */}
        <div className={styles.field}>
          <span className={styles.fieldLabel}>고객군</span>
          <input
            className={styles.input}
            type='text'
            value={searchCondition.endCustReport}
            onChange={e => setCond('endCustReport', e.target.value)}
            placeholder='고객군 코드 직접 입력 (빈값=전체)'
          />
        </div>

        {/* AS-IS usrType (Designer.cs L412~444): UsrCombo DropDownList — 정적 옵션 dropdown */}
        <div className={styles.field}>
          <span className={styles.fieldLabel}>제품군</span>
          <select
            className={styles.select}
            value={searchCondition.productGroup}
            onChange={e => setCond('productGroup', e.target.value)}
          >
            {PRODUCT_GROUP_OPTIONS.map(o => (
              <option key={o.value} value={o.value}>
                {o.label}
              </option>
            ))}
          </select>
        </div>

        {/* AS-IS usrBiz (Designer.cs L270~302): UsrCombo DropDownList — 정적 옵션 dropdown */}
        <div className={styles.field}>
          <span className={styles.fieldLabel}>Biz</span>
          <select
            className={styles.select}
            value={searchCondition.bizType}
            onChange={e => setCond('bizType', e.target.value)}
          >
            {BIZ_TYPE_OPTIONS.map(o => (
              <option key={o.value} value={o.value}>
                {o.label}
              </option>
            ))}
          </select>
        </div>

        {/* AS-IS chkM (Designer.cs L233~268): [M$] 백만 단위 — AS-IS Visible=false 였으나 사용자 요구 2026-06-02 노출 */}
        <label className={styles.checkField}>
          <input
            type='checkbox'
            checked={searchCondition.millionYn === 'Y'}
            onChange={e => setSearchCondition({ millionYn: e.target.checked ? 'Y' : 'N' })}
          />
          [M$]
        </label>

        {/* AS-IS usrChk (Designer.cs L338~373): 정합성 체크 — AS-IS Visible=false 였으나 사용자 요구 노출 */}
        <label className={styles.checkField}>
          <input
            type='checkbox'
            checked={searchCondition.compatibilityYn === 'Y'}
            onChange={e => setSearchCondition({ compatibilityYn: e.target.checked ? 'Y' : 'N' })}
          />
          정합성 체크
        </label>

        {/* AS-IS btnColumn 은 사용자 요구로 Form 에서 제거 — SubTitle customButton 으로 일원화 */}

        <button type='button' className={styles.searchButton} onClick={onSearch}>
          조회 (F5)
        </button>
      </div>
    </div>
  );
};
