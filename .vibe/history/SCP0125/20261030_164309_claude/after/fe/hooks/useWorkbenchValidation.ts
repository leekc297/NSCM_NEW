// SCP0125 저장 검증 — AS-IS `Save_Data()` 4분기의 검증 39건을 1:1 이식한다
//   (design 03_grid-columns.md §4.3 검증표 / 00_checklist.md §6b).
//
// 검증 순서(AS-IS 그대로 — 순서가 바뀌면 사용자에게 뜨는 첫 메시지가 달라진다):
//   신규행('I') 1.필수공백 → 2.중복 → 3.1 날짜형식 → 3.2 Plan 시작일 역전 → 4.Project 존재
//                → 5.Item 존재 → 9.음수
//   기존행('M') 7.변경없음 skip → 6.필수값 → 8.CHG_TYPE 승격(save 유틸) → 9.음수
//   삭제행('D') 검증 없음(날짜 포맷만)
//
// 필수: `useSaveWithValidation`(메타 기반 필수검증)만으로는 이 화면이 통과된다 —
//   `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD` 102행 전건 `'S'`(goal.md §7 B1 결정으로 유지)라
//   `isEditableForRow` 가 전부 false 를 돌려주고 라벨 `*` 가 있어도 검사가 발동하지 않는다
//   (메모리 `input-tp-cd-search-only-kills-save-validation`). 그래서 이 화면 명시 검증이 정본이고,
//   공용 훅은 메타 정비 후를 대비해 함께 배선한다(4계층 중 ④).
//
// AS-IS 근거: cs:890~1066(MKT FCST) · cs:1210~1365(STOCK 계열) · cs:1520~1627(Elec. Demand) ·
//             cs:1770~1890(2nd OCV)

import { useCallback } from 'react';

import { CRUD_MSG } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { stripRequiredMark } from '@foundation/utils';
import { useMessageStore } from '@shared/stores';

import { isUnchanged, toYyyymmdd } from '../utils/workbench.save';
import {
  COL,
  DIVISION_CODE,
  DUPLICATE_KEYS,
  EXISTING_ROW_REQUIRED_MSG,
  INSERT_REQUIRED_COLUMNS,
  ITEM_EXISTENCE_CHECK,
  MKT_FCST_REQUIRED_SMALL,
  MSG,
  PLAN_START_REVERSE_CHECK,
  STOCK_UC_DUPLICATE_KEYS,
  STOCK_UC_REQUIRED_COLUMNS,
  TABS,
  DATE_COLUMN,
  DATE_COLUMN_LABEL,
} from '../workbench.constants';
import type { WorkbenchInitRow } from '../workbench.types';

const str = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

// 날짜 셀(FPDate → InputDate 에디터)은 값을 **Date 객체**로 커밋한다(메타 dataType 미지정이라
//   Wijmo 가 강제변환하지 않는다). str() 은 Date 를 문자열화하지 못해 ''(공백)로 떨어지므로,
//   Date 는 "채워진 값"으로 본다 — 안 그러면 날짜를 넣어도 신규행 필수검증이 공백으로 오판한다
//   (toYyyymmdd 가 저장·중복키·날짜형식 검사에서 이미 Date 를 처리하는 것과 같은 전제).
const isBlank = (value: unknown): boolean =>
  value instanceof Date ? false : str(value).trim() === '';

/**
 * AS-IS 대소문자 무관 비교를 재현하기 위한 정규화.
 *
 * AS-IS 존재검증·중복검증은 전부 `DBUtils.Filter`(`GSCM/06.UIL/GSCM.Utils/DBUtils.cs:53` =
 * `DataTable.Select(filterText)`)를 탄다. `DataTable.Select` 의 문자열 비교는 `DataTable.CaseSensitive`
 * 를 따르는데 기본값이 **false** 이고, 이 화면·`GSCM.Utils` 어디에도 `CaseSensitive` 를 켜는 코드가
 * 없다(grep 0건). 즉 AS-IS 는 `abc` 로 입력해도 `ABC` 를 찾아냈다.
 * JS `===` 로 옮기면 (a) 소문자 입력이 `MSG00457`/`MSG00458` 로 **부당 거부**되고
 * (b) 대소문자만 다른 중복을 **놓쳐** 저장 단계까지 흘러간다.
 */
const norm = (value: unknown): string => str(value).trim().toUpperCase();

/** AS-IS `DateTime.ParseExact(x, "yyyyMMdd")` 성공 여부. */
const isValidYyyymmdd = (value: string): boolean => {
  if (!/^\d{8}$/.test(value)) return false;
  const year = Number(value.slice(0, 4));
  const month = Number(value.slice(4, 6));
  const day = Number(value.slice(6, 8));
  if (month < 1 || month > 12 || day < 1 || day > 31) return false;
  const date = new Date(year, month - 1, day);
  return date.getFullYear() === year && date.getMonth() === month - 1 && date.getDate() === day;
};

/** 중복검사 키 — AS-IS `sb.ToString()` RowFilter 와 같은 컬럼 집합을 문자열 키로 접는다. */
const buildDuplicateKey = (
  tab: TABS,
  row: Record<string, unknown>,
  divisionId: string
): string => {
  const keys = [...DUPLICATE_KEYS[tab]];
  // MKT FCST 소형(40)은 PROJECT_CODE 대신 PROJECT_CODE_40 으로 비교한다(cs:951~958).
  if (tab === TABS.MKT_FCST && divisionId === DIVISION_CODE.SMALL) {
    const index = keys.indexOf(COL.PROJECT_CODE);
    if (index >= 0) keys[index] = COL.PROJECT_CODE_40;
  }
  // STOCK + 81_UC 는 LINE_ID·BEFORE_DEGAS 를 키에 추가한다(F17).
  if (tab === TABS.STOCK && divisionId === DIVISION_CODE.UC) keys.push(...STOCK_UC_DUPLICATE_KEYS);

  const dateColumn = DATE_COLUMN[tab];
  return keys
    // 대소문자는 접어서 비교한다 — AS-IS `DataTable.Select` 가 CI 였다(`norm` 주석).
    //   구분하면 대소문자만 다른 중복을 놓쳐 SP 의 PK 중복(무음 롤백)까지 흘러간다.
    .map(key => (key === dateColumn ? toYyyymmdd(row[key]) : norm(row[key])))
    .join('');
};

export interface ValidationSources {
  /** 조회조건에서 확정된 division(신규행 DIVISION_ID 와 동일) */
  divisionId: string;
  /** `init` O_RC6 — Project Code 존재검증(F14). 행 타입은 `procedures.d.ts` index signature 정본. */
  projectAll: WorkbenchInitRow[];
  /** `init` O_RC7 — 소형(40) End Customer 존재검증(F15) */
  projectCode40All: { CODE?: string }[];
  /** `init` O_RC5 — Item 존재검증(F16·F19) */
  itemAll: WorkbenchInitRow[];
}

export const useWorkbenchValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  const alert = useCallback(
    (id: string, fallback: string, param?: string) => {
      const text = t(id, { defaultValue: fallback });
      void setAlert({ type: 'alert', content: param ? text.replace('{0}', param) : text });
    },
    [setAlert, t]
  );

  /**
   * 저장 대상 행을 검증하고 실제로 보낼 행만 돌려준다. 실패 시 alert 후 `undefined`
   * (AS-IS 는 첫 위반에서 `return` 하며 그 행 이후는 검사하지 않는다 — 같은 동작).
   */
  const validateSaveRows = useCallback(
    (
      tab: TABS,
      allRows: Record<string, unknown>[],
      sources: ValidationSources,
      columns: RawFlexGridColumnConfig[]
    ): Record<string, unknown>[] | undefined => {
      const dateColumn = DATE_COLUMN[tab];
      const dateLabel = DATE_COLUMN_LABEL[tab] ?? 'Date';
      // 기존행 per-field 필수 메시지용 라벨(사용자가 헤더에서 본 이름 = admin 메타 colLblNm, `*` 제거).
      const labelOf = (colNm: string): string =>
        stripRequiredMark(columns.find(col => col.colNm === colNm)?.colLblNm ?? '') || colNm;
      // 중복 비교 대상 = 조회로 내려온 원본행(AS-IS `dtXxxAll` 스냅샷과 등가 — 키 컬럼은 기존행에서
      //   편집 불가라 값이 변하지 않는다).
      const existingKeys = new Set(
        allRows
          .filter(row => str(row.CRUD_TYPE) !== 'I')
          .map(row => buildDuplicateKey(tab, row, sources.divisionId))
      );

      const target: Record<string, unknown>[] = [];

      for (const row of allRows) {
        const crud = str(row.CRUD_TYPE);
        if (crud !== 'I' && crud !== 'M' && crud !== 'D') continue;

        if (crud === 'I') {
          // 1. 신규 입력 필수 공백
          const baseRequired =
            tab === TABS.MKT_FCST && sources.divisionId === DIVISION_CODE.SMALL
              ? MKT_FCST_REQUIRED_SMALL
              : INSERT_REQUIRED_COLUMNS[tab];
          // STOCK + 81_UC 는 LINE_ID·BEFORE_DEGAS 도 필수다(cs:1268~1273). 비UC 는 '-' 강제라 제외.
          const required =
            tab === TABS.STOCK && sources.divisionId === DIVISION_CODE.UC
              ? [...baseRequired, ...STOCK_UC_REQUIRED_COLUMNS]
              : baseRequired;
          if (required.some(column => isBlank(row[column]))) {
            alert(MSG.REQUIRED_ALL, 'All entries are mandatory.');
            return undefined;
          }

          // 2. 중복 (조회 원본 대비)
          if (existingKeys.has(buildDuplicateKey(tab, row, sources.divisionId))) {
            alert(
              MSG.DUPLICATE_NEW_ROW,
              'There are duplicate entries among the newly entered data.'
            );
            return undefined;
          }

          // 3.1 날짜 형식 / 3.2 Plan 시작일 역전
          if (dateColumn) {
            const dateValue = toYyyymmdd(row[dateColumn]);
            // 2nd OCV 의 SECOND_OCV_DATE 는 NULL 허용 — 공백이면 검사 skip(cs:1838).
            const skipBlank = tab === TABS.STOCK_2ND_OCV && dateValue === '';
            if (!skipBlank) {
              if (!isValidYyyymmdd(dateValue)) {
                alert(MSG.INVALID_DATE, 'This is not a valid date format. {0}', dateLabel);
                return undefined;
              }
              if (PLAN_START_REVERSE_CHECK[tab]) {
                const planStart =
                  tab === TABS.ELEC_DEMAND
                    ? str(row[COL.PLAN_START_YYYYMMDD])
                    : str(row[COL.CUTOFF_YYYYMMDD]);
                if (planStart && Number(planStart) > Number(dateValue)) {
                  alert(
                    MSG.DATE_BEFORE_PLAN_START,
                    'Please check the Date earlier than the Plan start date.'
                  );
                  return undefined;
                }
              }
            }
          }

          // 4. Project Code 존재 (MKT FCST 만 — cs:1002~1026)
          if (tab === TABS.MKT_FCST) {
            if (sources.divisionId === DIVISION_CODE.SMALL) {
              const code = str(row[COL.PROJECT_CODE_40]);
              if (!sources.projectCode40All.some(item => norm(item.CODE) === norm(code))) {
                alert(MSG.INVALID_PROJECT, 'PROJECT_CODE:{0} Invalid project code!', code);
                return undefined;
              }
            } else {
              const code = str(row[COL.PROJECT_CODE]);
              const found = sources.projectAll.some(
                item =>
                  norm(item.DIVISION_ID) === norm(sources.divisionId) &&
                  norm(item.PROJECT_CODE) === norm(code)
              );
              if (!found) {
                alert(MSG.INVALID_PROJECT, 'PROJECT_CODE:{0} Invalid project code!', code);
                return undefined;
              }
            }
          }

          // 5. Item 존재 (MKT FCST · Elec. Demand 만 — cs:1030·1589)
          if (ITEM_EXISTENCE_CHECK[tab]) {
            const itemId = str(row[COL.ITEM_ID]);
            const found = sources.itemAll.some(
              item =>
                norm(item.DIVISION_ID) === norm(sources.divisionId) &&
                norm(item.ITEM_ID) === norm(itemId)
            );
            if (!found) {
              alert(MSG.INVALID_ITEM, 'MODEL:{0} Invalid model!', itemId);
              return undefined;
            }
          }
        } else if (crud === 'M') {
          // 7. 변경 없음 → 저장 대상에서 제외(무메시지)
          if (isUnchanged(row)) continue;

          // 6. 기존행 수정 필수값 — AS-IS 가 탭마다 갈린다:
          //   MKT FCST = `DataUtil.checkRequiredOfSpread`(cs:1045 → DataUtil.cs:54) 로 **빈 컬럼을
          //     지목하는 per-field** 메시지(MSG00429). 종전 TO-BE 는 이걸 lump(REQUIRED_ALL)로 잘못
          //     매핑해 수정 시 "모든 항목은 필수입력입니다" 가 떴다(2026-10-08 정정).
          //   그 외 탭 = inline check(cs:1342) 로 MSG00310 일반 문구(checkRequiredOfSpread 주석처리됨).
          const blank = [COL.CHG_QTY, COL.CHG_RSN].find(column => isBlank(row[column]));
          if (blank) {
            if (tab === TABS.MKT_FCST) {
              alert(
                CRUD_MSG.REQUIRED_FIELD.id,
                CRUD_MSG.REQUIRED_FIELD.fallback,
                `[${labelOf(blank)}]`
              );
            } else {
              alert(EXISTING_ROW_REQUIRED_MSG[tab], 'Please enter the required fields.');
            }
            return undefined;
          }
        }

        // 9. 음수 금지 (I·M 공통 — cs:1060·1360·1623·1885)
        if (crud !== 'D') {
          const chgQty = str(row[COL.CHG_QTY]);
          if (Number(chgQty) < 0 || Number.isNaN(Number(chgQty))) {
            alert(MSG.INVALID_NUMBER, 'This is not a valid numeric format. {0}', chgQty);
            return undefined;
          }
        }

        target.push(row);
      }

      return target;
    },
    [alert]
  );

  return { validateSaveRows };
};
