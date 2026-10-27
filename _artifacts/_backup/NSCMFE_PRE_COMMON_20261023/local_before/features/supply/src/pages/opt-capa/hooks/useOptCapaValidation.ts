import type { RawFlexGridColumnConfig } from '@foundation/models';
import { stripRequiredMark } from '@foundation/utils';

import {
  DECIMAL_SCALE_COLUMNS,
  MAX_DECIMAL_SCALE,
  MSG,
  NON_NEGATIVE_COLUMNS,
  PERIOD_RANGE_COLUMNS,
  PRE_KEY_COLUMNS,
  SHEETS,
  COLUMN,
  type GridSheet,
} from '../opt-capa.constants';
import type { GridRow } from '../opt-capa.types';
import { str } from '../utils/optCapa.candidates';
import {
  currentKeyOf,
  isElectrodeCapaRow,
  previousKeyOf,
  toStoredDateValue,
} from '../utils/optCapa.save';

/**
 * 저장 전 검증 — AS-IS `Save_*()` 8메서드의 검증 블록 이식(design 03 §4.4 V-02~V-57 / R-22·R-23).
 *
 * ## 필수컬럼 검증의 축 분리 (2026-09-26 iter-4, 사용자 판정 D-3′ = D-3 의 사실 정정)
 * AS-IS 필수검증은 **시트에 따라 원천이 둘로 갈린다** — iter-2·iter-3 이 "`MSG00002` 4건이 전부
 * `Save_DailyCapa` 안" 이라고 본 것은 오측이었다. AS-IS 는 `MSG00002` 를 화면 `.cs` 에서 직접
 * 띄우지 않고 공용 헬퍼가 띄운다:
 *   · **나머지 7시트** = `DataUtil.checkRequiredOfSpread(siMain)` 라이브 호출 **7건**
 *     (cs:1311 NoWork · 1866 SopEop · 2089 Rampup · 2390 RampupItvl · 2648 PrepRt · 2907 UtilRt ·
 *     3160 Yield). 헬퍼 본문(`DataUtil.cs:23-65`) = `action=='D'` skip → 헤더 라벨에 `*` 없으면
 *     skip → `IsNullOrWhiteSpace` → `MSG00002` + 중단. 즉 **헤더 라벨 `*` 전건**이 필수다.
 *   · **Daily Capa** = 그 호출이 **주석처리**(cs:1572)돼 있고 로컬 상호배타 4건만 본다.
 *
 * 그래서 역할 분담은 이렇게 갈린다 — **중복 없음**:
 *   · 공용 `useSaveWithValidation` = **7시트**의 메타 기반 필수검증(`isMandatoryColumn` =
 *     `inputTpCd` M/IM **또는** 라벨 `*` → AS-IS 술어와 동치). `OptCapa.handleSave` 가
 *     `staticColumns[sheet]` 를 넘겨 살린다. 숨긴 컬럼(`visible !== false`)과 `S` 컬럼
 *     (`isEditableForRow`)은 공용 훅이 이미 거르므로 "필수인데 채울 수 없는 셀" 은 생기지 않는다.
 *   · 이 훅의 {@link findMissingRequired} = **Daily Capa 전용** 상호배타 4건.
 *   · 이 훅의 나머지 = 메타로 표현할 수 없는 업무규칙(키중복 / 키변경 / 기간중첩·역전 /
 *     숫자·날짜 / 자릿수).
 *
 * 메타 `INPUT_TP_CD`·라벨 `*` 은 **그대로 둔다** — 편집가능 판정과 헤더 필수표시(빨간 점)의 정본은
 * 여전히 메타다(hook #130 / CLAUDE.md §2 속성 단위 덮어쓰기 금지).
 *
 * 검증 순서는 AS-IS 와 같다: 필수 → 업무규칙(cs:1573-1596 → 1603 이후).
 */

export interface ValidationFailure {
  /** i18n 코드(`MSG#####`). */
  msgId: string;
  /** `{0}` 치환값. i18next 기본 보간자는 `{{ }}` 라 DB 메시지의 `{0}` 은 직접 replace 한다. */
  arg?: string;
}

interface ValidateArgs {
  sheet: GridSheet;
  /** 저장 대상 행(`CRUD_TYPE` = I/M/D). */
  dirtyRows: readonly GridRow[];
  /** 직전 조회 원본 전체 — 키중복 대조에 쓴다(React Query 데이터를 버리지 않는다). */
  sourceRows: readonly GridRow[];
  /** 값 검증 오류 메시지의 `{0}` 에 넣을 컬럼 라벨 원천. */
  staticColumns: readonly RawFlexGridColumnConfig[];
}

/** AS-IS `string.IsNullOrWhiteSpace`(cs:1582·1590) 등가. */
const isBlank = (value: unknown): boolean => str(value).trim() === '';

/** AS-IS `string.IsNullOrEmpty`(cs:1573·1654) 등가 — 공백 1칸은 "채워진 값"으로 본다. */
const isEmpty = (value: unknown): boolean => str(value) === '';

/**
 * 오류 문구의 `{0}` 에 넣을 컬럼 라벨 — AS-IS `col.Label.ToString()` 등가.
 * 메타 라벨 끝 `*` 는 떼고 보여준다(헤더도 `*` 없이 빨간 점으로 그려진다).
 */
const labelOf = (staticColumns: readonly RawFlexGridColumnConfig[], binding: string): string => {
  const column = staticColumns.find(candidate => candidate.colNm === binding);
  return stripRequiredMark(column?.colLblNm ?? '') || binding;
};

/** 신규행인가 — `CRUD_TYPE='I'` 는 EditTracker/GridAction 이 세운 값이다(자체 필드 신설 금지). */
const isInsert = (row: GridRow): boolean => str(row.CRUD_TYPE) === 'I';
const isDelete = (row: GridRow): boolean => str(row.CRUD_TYPE) === 'D';

/** 숫자 파싱 — AS-IS `double.TryParse` 등가. 빈 값은 검사 대상이 아니다. */
const parseNumber = (value: unknown): number | undefined => {
  const text = str(value).trim();
  if (!text) return undefined;
  const parsed = Number(text);
  return Number.isFinite(parsed) ? parsed : undefined;
};

/** 소수 자릿수 — `123.4567890123` → 10. 지수 표기는 입력 경로상 나오지 않는다. */
const decimalScaleOf = (value: unknown): number => {
  const text = str(value).trim();
  const dot = text.indexOf('.');
  return dot < 0 ? 0 : text.length - dot - 1;
};

/** `YYYYMMDD` 8자리로 환원한 값이 실제 달력 일자인가 — AS-IS `Convert.ToDateTime` 실패 대응. */
const isValidDate8 = (stored: string): boolean => {
  if (!/^\d{8}$/.test(stored)) return false;
  const year = Number(stored.slice(0, 4));
  const month = Number(stored.slice(4, 6));
  const day = Number(stored.slice(6, 8));
  if (month < 1 || month > 12 || day < 1 || day > 31) return false;
  const probe = new Date(year, month - 1, day);
  return probe.getFullYear() === year && probe.getMonth() === month - 1 && probe.getDate() === day;
};

export const useOptCapaValidation = () => {
  /**
   * 필수컬럼 (AS-IS `MSG00002` 4건 — cs:1573-1596·1654-1659, **전부 Daily Capa**).
   *
   * 상호배타다 — {@link isElectrodeCapaRow} 가 참이면 `M_MIN`·`LANE`·`WIDE_YN` 만, 거짓이면
   * `CAPA` 만 본다. 같은 분기가 저장 기본값 주입도 가른다(`optCapa.save.applyDailyCapaSaveRules`)
   * → 필수로 막는 컬럼과 덮어쓰는 컬럼이 절대 겹치지 않는다.
   *
   * 판정 함수도 AS-IS 를 그대로 따른다: `M_MIN`/`CAPA` 는 `IsNullOrEmpty`,
   * `LANE`/`WIDE_YN` 은 `IsNullOrWhiteSpace` 다(cs:1573·1582·1590·1654).
   * 삭제행은 대상 아님 — AS-IS 도 `action == FlagI || FlagM` 안에서만 검사한다(cs:1561).
   */
  const findMissingRequired = ({
    sheet,
    dirtyRows,
    staticColumns,
  }: Pick<
    ValidateArgs,
    'sheet' | 'dirtyRows' | 'staticColumns'
  >): ValidationFailure | undefined => {
    // 나머지 7시트는 **공용 훅**이 메타 라벨 `*` 전건을 본다(AS-IS `checkRequiredOfSpread` 7건 등가,
    //   user-decisions D-3′) — 여기서 또 보면 같은 사실이 두 곳에 놓인다(hook #130).
    if (sheet !== SHEETS.DAILY_CAPA) return undefined;
    // `{0}` 에 넣는 형식은 공용 `useSaveWithValidation` 과 같게 `[라벨]` 로 맞춘다.
    const bracketed = (binding: string): string => `[${labelOf(staticColumns, binding)}]`;

    for (const row of dirtyRows) {
      if (isDelete(row)) continue;
      if (isElectrodeCapaRow(row)) {
        if (isEmpty(row[COLUMN.M_MIN])) {
          return { msgId: MSG.REQUIRED_FIELD, arg: bracketed(COLUMN.M_MIN) };
        }
        if (isBlank(row[COLUMN.LANE])) {
          return { msgId: MSG.REQUIRED_FIELD, arg: bracketed(COLUMN.LANE) };
        }
        if (isBlank(row[COLUMN.WIDE_YN])) {
          return { msgId: MSG.REQUIRED_FIELD, arg: bracketed(COLUMN.WIDE_YN) };
        }
        continue;
      }
      if (isEmpty(row[COLUMN.CAPA])) {
        return { msgId: MSG.REQUIRED_FIELD, arg: bracketed(COLUMN.CAPA) };
      }
    }
    return undefined;
  };

  /**
   * 키 중복 / 키 변경 (R-22, cs:1314-1345 외 7시트 동형).
   *   · 신규행(`I`) — 같은 키가 조회 원본에 있으면 즉시 중복 오류(`MSG00428`).
   *   · 수정행(`M`) — `PRE_KEY_VALUES` 와 키가 **달라졌을 때만** 중복 검사(`MSG01427`).
   *     (키 컬럼도 기존행에서 편집 가능하다 — 그래서 권고 `INPUT_TP_CD` 가 `S` 가 아니라 `M` 이다.)
   *   · 저장 배치 안의 중복도 같이 본다 — AS-IS 도 루프를 돌며 누적 목록과 대조한다.
   *
   * 의도적 차이(iter-3 감사 G3-9): AS-IS `Save_DailyCapa`(cs:1488-1800) 구간에는 `MSG00260`/
   * `MSG00443` 이 0 hit 라 중복 검사가 없으나 여기서는 시트 무관으로 돌린다. Daily Capa 키 6종이
   * 전건 `INPUT_TP_CD='S'` 라 사용자가 바꿀 수 없어 오탐 확률이 0 에 가깝고, SAVE SP 의 `'I'` 분기도
   * 같은 6키 중복을 `C_MSG_DUP_I` 로 되돌리므로(BODY:2972-2986) 서버 방어와 문구만 일치시킨다.
   */
  const findDuplicateKey = ({
    sheet,
    dirtyRows,
    sourceRows,
  }: Pick<ValidateArgs, 'sheet' | 'dirtyRows' | 'sourceRows'>): ValidationFailure | undefined => {
    const persistedKeys = new Set(
      sourceRows.filter(row => !isInsert(row)).map(row => previousKeyOf(sheet, row))
    );
    const batchKeys = new Set<string>();
    for (const row of dirtyRows) {
      if (isDelete(row)) continue;
      const key = currentKeyOf(sheet, row);
      if (batchKeys.has(key)) return { msgId: MSG.DUPLICATE_NEW };
      batchKeys.add(key);
      if (isInsert(row)) {
        if (persistedKeys.has(key)) return { msgId: MSG.DUPLICATE_NEW };
        continue;
      }
      // 수정행: 키가 그대로면 자기 자신과 부딪히므로 검사하지 않는다.
      if (key === previousKeyOf(sheet, row)) continue;
      if (persistedKeys.has(key)) return { msgId: MSG.DUPLICATE_KEY_CHANGED };
    }
    return undefined;
  };

  /**
   * 기간 4방향 중첩 + 역전 (R-23, cs:2136-2173 · 2694-2730 · 2950-2986).
   * 대상은 시작·종료가 쌍으로 있는 3시트뿐이다(`Ramp-up(Interval)` 은 `START_DATE` 단일).
   * 중첩 비교 그룹 = `PRE_KEY_COLUMNS` 중 기간 컬럼을 뺀 나머지 키(= 동일 대상 식별키).
   *
   * 순서는 **중첩(`MSG00105`) → 역전(`MSG00108`)** 이다 — AS-IS 가 그 순서다(cs:2156-2161 →
   * 2171-2175 · 2714-2719 → 2728-2732 · 2970-2975 → 2984-2988). 두 오류가 동시에 성립하는 행에서
   * 표시 메시지가 갈리므로 순서를 맞춘다(iter-3 감사 G3-11 ①).
   *
   * 대조 원천은 **라이브 그리드**(`sourceRows` = `collectionView.sourceCollection`)다. AS-IS 는
   * 조회 스냅샷(`dtRampupAll` 등, cs:1206-1240 의 Copy)을 쓰므로 "같은 배치에서 두 행 기간을 함께
   * 고치면 TO-BE 만 차단" 하는 차이가 남는다 — TO-BE 쪽이 더 엄격해 잘못된 마스터 적재를 막으므로
   * 의도적 차이로 유지한다(G3-11 ②, 04 리포트 기재).
   */
  const findPeriodProblem = ({
    sheet,
    dirtyRows,
    sourceRows,
  }: Pick<ValidateArgs, 'sheet' | 'dirtyRows' | 'sourceRows'>): ValidationFailure | undefined => {
    const range = PERIOD_RANGE_COLUMNS[sheet];
    if (!range) return undefined;
    const groupColumns = PRE_KEY_COLUMNS[sheet].filter(
      column => column !== range.start && column !== range.end
    );
    const groupKeyOf = (row: GridRow): string =>
      groupColumns.map(column => toStoredDateValue(column, row[column])).join('|');

    for (const row of dirtyRows) {
      if (isDelete(row)) continue;
      const start = toStoredDateValue(range.start, row[range.start]);
      const end = toStoredDateValue(range.end, row[range.end]);
      if (!start || !end) continue;
      const group = groupKeyOf(row);
      const others = sourceRows.filter(
        candidate => candidate !== row && !isDelete(candidate) && groupKeyOf(candidate) === group
      );
      const overlapped = others.some(candidate => {
        const otherStart = toStoredDateValue(range.start, candidate[range.start]);
        const otherEnd = toStoredDateValue(range.end, candidate[range.end]);
        if (!otherStart || !otherEnd) return false;
        // 4방향 중첩 = 두 구간이 한 점이라도 공유하는 모든 경우.
        return start <= otherEnd && otherStart <= end;
      });
      if (overlapped) return { msgId: MSG.PERIOD_OVERLAP };
      if (start > end) return { msgId: MSG.PERIOD_REVERSED };
    }
    return undefined;
  };

  /**
   * 숫자·날짜·자릿수 (V-04·05·12·13·14·16·56·57).
   *   · 숫자 파싱 실패 → `MSG01082`(AS-IS MSG00050) · 음수 → 동일 메시지(AS-IS 도 같은 코드)
   *   · 소수 11자리 이상 → `MSG00165` (AS-IS 하드코딩 한글의 등가 문구)
   *   · `NO_WORK_DATE`/`DATE` 파싱 실패 → `MSG01081`(AS-IS MSG00046)
   *
   * 검사 대상 컬럼은 `NON_NEGATIVE_COLUMNS`(3건) / `DECIMAL_SCALE_COLUMNS`(3건) 로 AS-IS 실측
   * 범위다 — 초과 차단은 AS-IS 가 통과시키는 저장을 막으므로 금지다(iter-3 감사 G3-6).
   */
  const findValueProblem = ({
    sheet,
    dirtyRows,
    staticColumns,
  }: Pick<ValidateArgs, 'sheet' | 'dirtyRows' | 'staticColumns'>): ValidationFailure | undefined => {
    const label = (binding: string): string => labelOf(staticColumns, binding);
    const dateColumns =
      sheet === SHEETS.NO_WORK
        ? [COLUMN.NO_WORK_DATE]
        : sheet === SHEETS.SOP_EOP
          ? [COLUMN.DATE]
          : [];

    /**
     * Daily Capa 는 AS-IS 가 `M_MIN`/`LANE` 을 **전극 분기 안에서만**, `CAPA` 를 **그 반대 분기
     * 안에서만** 검사한다(cs:1569 분기 · 1603 · 1634-1638 · 1667-1674). 분기 밖에서 보면
     * `applyDailyCapaSaveRules` 가 저장 직전에 덮어쓸 값(비전극 행의 `M_MIN`/`LANE`, 전극 행의
     * `CAPA`)까지 검증해 AS-IS 가 통과시키는 저장을 막는다. 다른 7시트는 분기 자체가 없다.
     */
    const inAsisBranch = (binding: string, row: GridRow): boolean => {
      if (sheet !== SHEETS.DAILY_CAPA) return true;
      const electrode = isElectrodeCapaRow(row);
      if (binding === COLUMN.M_MIN || binding === COLUMN.LANE) return electrode;
      if (binding === COLUMN.CAPA) return !electrode;
      return true;
    };

    for (const row of dirtyRows) {
      if (isDelete(row)) continue;
      for (const binding of dateColumns) {
        const raw = row[binding];
        if (isBlank(raw)) continue;
        if (!isValidDate8(toStoredDateValue(binding, raw))) {
          return { msgId: MSG.INVALID_DATE, arg: label(binding) };
        }
      }
      for (const binding of NON_NEGATIVE_COLUMNS) {
        const raw = row[binding];
        if (raw === undefined || isBlank(raw)) continue;
        if (!inAsisBranch(binding, row)) continue;
        const parsed = parseNumber(raw);
        if (parsed === undefined || parsed < 0) {
          return { msgId: MSG.INVALID_NUMBER, arg: `${label(binding)} : ${str(raw)}` };
        }
      }
      for (const binding of DECIMAL_SCALE_COLUMNS) {
        const raw = row[binding];
        if (raw === undefined || isBlank(raw)) continue;
        if (!inAsisBranch(binding, row)) continue;
        if (decimalScaleOf(raw) > MAX_DECIMAL_SCALE) {
          return { msgId: MSG.DIGIT_EXCEEDED };
        }
      }
    }
    return undefined;
  };

  /**
   * 저장 전 전체 검증 — 첫 실패 1건만 돌려준다(AS-IS 도 첫 오류에서 중단한다).
   * 순서 = 필수 → 키중복·키변경 → 기간 → 값. AS-IS `Save_DailyCapa` 도 필수를 가장 먼저 본다
   * (cs:1573 이 1603 이후의 숫자·자릿수 검사보다 앞이다).
   */
  const validateSave = (args: ValidateArgs): ValidationFailure | undefined =>
    findMissingRequired(args) ??
    findDuplicateKey(args) ??
    findPeriodProblem(args) ??
    findValueProblem(args);

  /** 조회 게이트 — Period 역전만 막는다(AS-IS `Required` 속성 0건, design 02 §4.4). */
  const validateSearch = (fromYyyymm: string, toYyyymm: string): ValidationFailure | undefined => {
    if (!fromYyyymm || !toYyyymm) return undefined;
    if (fromYyyymm > toYyyymm) return { msgId: MSG.PERIOD_INVALID };
    return undefined;
  };

  return { validateSave, validateSearch };
};
