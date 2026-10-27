import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

// SCP0023 그리드 컬럼 — 정본은 admin SCM_MST_SHEET_COLUMNS(PROGRAM_ID='SCP0023' 13행, design 03 §1 실측).
//   admin 등록본이 있으면 authoritative 로 쓰고, 없으면(미등록/조회실패) 아래 MAIN_COLUMNS fallback.
//   colNm 은 DB SHEET_COLUMNS COLUMN_NAME 그대로 대문자(2026-10-14 ora.py 재실측 — 05_register.sql 의
//   lowercase 가정은 오류였다. GET SP 반환 컬럼이 unquoted 라 Oracle 기본 폴딩으로 대문자가 된다).

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

// design 03 §1 사양표(DB 메타 13열). DAILY_CAPA_QTY 만 편집(정수 scale0). CAPA_ORDER·VALID_YN 숨김.
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division', width: 60, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'SCM_SITE_ID', header: 'Plant Site Code', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'VENDOR_CODE', header: 'Vendor Code', width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'VENDOR_NAME', header: 'Vendor Name', width: 230, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ITEM_ID', header: 'Model', width: 140, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 140, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  // 유일 편집셀 — Daily Capacity* (정수 scale0, 최소 1). design 03 §1 #7.
  { key: 'DAILY_CAPA_QTY', header: 'Daily Capacity*', width: 120, align: 'R', scale: 0, _ctrlType: 'FPNumber', _inputEditType: 'O' },
  // CAPA_ORDER = GET SP 파생 정렬값(숨김), VALID_YN = 저장 payload 전용(화면 미노출).
  { key: 'CAPA_ORDER', header: 'Daily Capacity Order', width: 0, align: 'L', visible: false, _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'VALID_YN', header: 'valid_yn', width: 0, align: 'L', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CREATED_BY', header: 'Created By', width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 140, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
  { key: 'LAST_UPDATED_BY', header: 'Last Updated By', width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update Date', width: 140, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
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
      // 소수자리(DAILY_CAPA_QTY scale0=정수) 전달 — admin 메타 미등록 fallback 시에도 정수 포맷 보존.
      //   admin 등록본(DATA_SCALE_NUMBER) 사용 경로엔 영향 없음(이 map 은 adminCols 없을 때만 실행).
      scale: c.scale,
      inputTpCd:
        c._inputEditType === 'O'
          ? CELL_INPUT_EDIT_TYPE.OPTIONAL
          : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
    }));
};
