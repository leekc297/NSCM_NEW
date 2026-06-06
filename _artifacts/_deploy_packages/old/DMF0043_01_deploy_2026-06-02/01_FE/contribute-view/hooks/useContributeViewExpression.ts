import type { SpreadTitleRow } from '../types';

// AS-IS DMF0043_Contribute_View.cs SetSpreadHeaderSpan (.cs L156~237) 1:1 매핑
//
// 헤더 구조 (3-row):
//   Row 0 (Large) : LARGE_CLASS_LABEL_NAME (예: '2024', 'SUM')
//   Row 1 (Small) : SMALL_CLASS_LABEL_NAME (예: '01', '02', 'SUM')
//   Row 2 (Leaf)  : COLUMN_LABEL_NAME      (예: '대만', '중국', 'SUM')
//
// 머지 규칙 (AS-IS L171~227):
//   - BASE 영역 (iCellCnt ≤ iSmallStartCol = EDIT_FLAG+1): row 0/1/2 세로 머지 → row 0 표시
//   - sLargeSpanName != sLargeLabelName 변경 시점:
//       (a) row 0 left → right Large 영역 가로 머지 (.cs L203)
//       (b) row 1 의 SUM 컬럼 1 칸 추가 (.cs L204)
//       (c) row 1 의 Small 머지 (.cs L209)
//   - sSmallSpanName != sSmallLabelName 변경 시점 (Large 변경 없이):
//       (a) row 1 Small 머지 (.cs L217)
//   - 루프 종료 후 마지막 Small + Large SUM 머지 (.cs L229~232)

export interface ColumnMeta {
  binding: string;        // COLUMN_NAME (예: 'M#202401#RBU_0001')
  large: string;          // LARGE_CLASS_LABEL_NAME
  small: string;          // SMALL_CLASS_LABEL_NAME
  leaf: string;           // COLUMN_LABEL_NAME
  isBase: boolean;        // true → BASE 컬럼 (좌측 고정, 단일 헤더)
  isHidden: boolean;      // AS-IS .cs L189: ColumnName.IndexOf("B_") > 0 → VisibleColumns(i, false)
  width: number;
}

export interface MergeRange {
  row: number;            // 0 = Large, 1 = Small (Leaf=2 는 자기 자신)
  leftCol: number;
  rightCol: number;
  text: string;
}

// 컬럼 메타 생성 — title sheet 의 SpreadTitleRow[] 로부터 ColumnMeta[] 빌드
export function buildColumnMeta(
  titleRows: SpreadTitleRow[],
  baseColumnCount: number
): ColumnMeta[] {
  return titleRows.map((r, i) => {
    const isBase = i < baseColumnCount;
    const binding = r.COLUMN_NAME ?? `col_${i}`;
    // AS-IS .cs L189: ColumnName 에 "B_" 포함 → 숨김 (sum 백업/source 컬럼)
    const isHidden = !isBase && binding.indexOf('B_') > 0;
    return {
      binding,
      large: r.LARGE_CLASS_LABEL_NAME ?? '',
      small: r.SMALL_CLASS_LABEL_NAME ?? '',
      leaf: r.COLUMN_LABEL_NAME ?? '',
      isBase,
      isHidden,
      width: isBase ? 120 : 80,
    };
  });
}

// AS-IS L156~232 의 머지 시퀀스 시뮬레이션 — row 0 (Large) + row 1 (Small) 머지 범위 계산
//   동적 영역은 large/small label 변경 시점에 그룹화. SUM 컬럼은 별도 추가하지 않고
//   AS-IS 가 명시적으로 row 1 에 'SUM' 머지를 추가하는 것은 leaf 가 SUM 인 컬럼에 대해
//   row 1 셀을 'SUM' 으로 표기. formatItem 에서 leaf === 'SUM' 행을 직접 처리.
export function buildHeaderMergeRanges(metas: ColumnMeta[]): MergeRange[] {
  const ranges: MergeRange[] = [];
  if (metas.length === 0) return ranges;

  let largeStart = 0;
  let smallStart = 0;
  let lastLarge = metas[0].large;
  let lastSmall = metas[0].small;

  for (let i = 1; i < metas.length; i++) {
    const m = metas[i];
    if (m.isBase) continue;        // BASE 영역은 row 0/1/2 세로 머지 (formatItem 처리)

    if (m.large !== lastLarge) {
      // AS-IS .cs L203: row 0 large 머지
      if (i - 1 >= largeStart) {
        ranges.push({ row: 0, leftCol: largeStart, rightCol: i - 1, text: lastLarge });
      }
      largeStart = i;
      lastLarge = m.large;
    }

    if (m.small !== lastSmall) {
      // AS-IS .cs L209/L217: row 1 small 머지
      if (i - 1 >= smallStart) {
        ranges.push({ row: 1, leftCol: smallStart, rightCol: i - 1, text: lastSmall });
      }
      smallStart = i;
      lastSmall = m.small;
    }
  }

  // 루프 종료 후 마지막 Large + Small 머지 (.cs L229~232)
  ranges.push({ row: 0, leftCol: largeStart, rightCol: metas.length - 1, text: lastLarge });
  ranges.push({ row: 1, leftCol: smallStart, rightCol: metas.length - 1, text: lastSmall });

  return ranges;
}
