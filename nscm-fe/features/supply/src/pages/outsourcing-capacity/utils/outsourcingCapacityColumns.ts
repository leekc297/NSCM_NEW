import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

// SCP0023 그리드 컬럼 — 정본은 admin SCM_MST_SHEET_COLUMNS(PROGRAM_ID='SCP0023' 13행, design 03 §1 실측).
//   admin 등록본이 있으면 authoritative 로 쓰고, 없으면(미등록/조회실패) 아래 MAIN_COLUMNS fallback.
//   colNm 은 DB SHEET_COLUMNS COLUMN_NAME 그대로 lowercase (GET SP 반환 컬럼과 1:1).

export interface MainColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  scale?: number;
  _ctrlType?: 'FPText' | 'FPNumber' | 'FPDateTime';
  // baseline 편집타입: 'S'=검색전용(잠금) / 'O'=편집후보. 최종 셀 편집은 grid beginningEdit + isCellEditable.
  _inputEditType?: 'S' | 'O';
}

// design 03 §1 사양표(DB 메타 13열). daily_capa_qty 만 편집(정수 scale0). capa_order·valid_yn 숨김.
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'division_id', header: 'Division', width: 60, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'scm_site_id', header: 'Plant Site Code', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'vendor_code', header: 'Vendor Code', width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'vendor_name', header: 'Vendor Name', width: 230, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'item_id', header: 'Model', width: 140, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'nick_name', header: 'Nick Name', width: 140, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  // 유일 편집셀 — Daily Capacity* (정수 scale0, 최소 1). design 03 §1 #7.
  { key: 'daily_capa_qty', header: 'Daily Capacity*', width: 120, align: 'R', scale: 0, _ctrlType: 'FPNumber', _inputEditType: 'O' },
  // capa_order = GET SP 파생 정렬값(숨김), valid_yn = 저장 payload 전용(화면 미노출).
  { key: 'capa_order', header: 'Daily Capacity Order', width: 0, align: 'L', visible: false, _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'valid_yn', header: 'valid_yn', width: 0, align: 'L', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'created_by', header: 'Created By', width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'creation_date', header: 'Creation Date', width: 140, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
  { key: 'last_updated_by', header: 'Last Updated By', width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'last_update_date', header: 'Last Update Date', width: 140, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
];

// MainColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 그걸 그대로 쓰고(속성 단위 덮어쓰기 금지, convert-core §2.3),
//   없으면 이 constants 를 fallback (tact-time buildColumns 패턴).
export const buildColumns = (
  meta: MainColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminCols && adminCols.length > 0) return adminCols;
  return meta
    .filter(c => c.visible !== false)
    .map<RawFlexGridColumnConfig>(c => ({
      colNm: c.key,
      colLblNm: c.header,
      horzAlgnCd: c.align ?? 'C',
      colWth: c.width ?? 100,
      visible: true,
      display: true,
      // 소수자리(daily_capa_qty scale0=정수) 전달 — admin 메타 미등록 fallback 시에도 정수 포맷 보존.
      //   admin 등록본(DATA_SCALE_NUMBER) 사용 경로엔 영향 없음(이 map 은 adminCols 없을 때만 실행).
      scale: c.scale,
      inputTpCd:
        c._inputEditType === 'O'
          ? CELL_INPUT_EDIT_TYPE.OPTIONAL
          : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
    }));
};
