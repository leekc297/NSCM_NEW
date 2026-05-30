/**
 * DMF0043 Contribute_Main — Wijmo FlexGrid + 동적 컬럼 (AS-IS spdMain 패턴)
 *
 * BE SP `P_DMF0043_GET_CONTRIBUTE_MAIN_DATA` 가 **wide-format** 반환:
 *   고정 분류 키 컬럼 (DIVISION_NM / DEPARTMENT_NM / DEPT_NM / END_CUST_REPORT /
 *                      SOLDTO_CUST_REPORT_NM / PRODUCT_GROUP / DM_BIZ_TYPE / EDIT_FLAG / DISCARD)
 *   + 동적 PIVOT 컬럼 ("M#YYYYMM#OS_CORP_CD" — AS-IS V_ColumnData 형식)
 *
 * FE 는 첫 row 의 keys 로 PIVOT 컬럼을 동적 생성 → AS-IS `CreateSheetHeaderColumn(dt)` 동등.
 * 헤더 2단 표시는 column group 사용 (룰 27 §F: leaf 2개 이상 보장).
 */
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGrid as FlexGridReact, FlexGridColumn, FlexGridColumnGroup } from '@mescius/wijmo.react.grid';
import { FlexGridFilter as FlexGridFilterReact } from '@mescius/wijmo.react.grid.filter';
import { useMemo, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';

import type { ContributeMainRow } from '../contribute-main.types';

interface ContributeMainGridProps {
  gridRef: MutableRefObject<FlexGrid<ContributeMainRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<ContributeMainRow> | undefined>;
  data: ContributeMainRow[];
}

interface PivotKey {
  key: string;      // "M#202401#RBU_0001"
  yyyymm: string;   // "202401"
  yyyymmLabel: string; // "2024-01"
  osCorp: string;   // "RBU_0001"
}

/**
 * 동적 PIVOT 컬럼 key 추출 — first row 의 "M#" prefix keys 만 수집.
 * YYYYMM 별로 group 묶음 (룰 27 §F 안전 패턴 — leaf 1개 group 금지).
 */
const extractPivotKeys = (rows: ContributeMainRow[]): PivotKey[] => {
  if (rows.length === 0) return [];
  return Object.keys(rows[0])
    .filter(k => k.startsWith('M#'))
    .map(key => {
      const [, yyyymm = '', osCorp = ''] = key.split('#');
      return {
        key,
        yyyymm,
        yyyymmLabel: yyyymm.length === 6 ? `${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}` : yyyymm,
        osCorp,
      };
    })
    .sort((a, b) => (a.yyyymm + a.osCorp).localeCompare(b.yyyymm + b.osCorp));
};

export const ContributeMainGrid = ({ gridRef, gridFilterRef, data }: ContributeMainGridProps) => {
  /* 동적 PIVOT 컬럼 추출 — useMemo 로 data 변경 시만 재계산 */
  const pivotKeys = useMemo(() => extractPivotKeys(data), [data]);

  /* YYYYMM 별로 group 묶음 — 룰 27 §F 따라 같은 YYYYMM 의 leaf 가 2개 이상일 때만 group 생성 */
  const groupedByMonth = useMemo(() => {
    const map = new Map<string, PivotKey[]>();
    pivotKeys.forEach(pk => {
      if (!map.has(pk.yyyymm)) map.set(pk.yyyymm, []);
      map.get(pk.yyyymm)!.push(pk);
    });
    return Array.from(map.entries()).map(([yyyymm, keys]) => ({
      yyyymm,
      yyyymmLabel: keys[0].yyyymmLabel,
      keys,
    }));
  }, [pivotKeys]);

  return (
    <FlexGridReact
      itemsSource={data}
      initialized={(g: FlexGrid<ContributeMainRow>) => {
        gridRef.current = g;
      }}
      allowAddNew={false}
      allowDelete={false}
      style={{ height: 'calc(100vh - 280px)' }}
    >
      <FlexGridFilterReact
        initialized={(f: FlexGridFilter) => {
          gridFilterRef.current = f;
        }}
      />
      {/* 고정 컬럼 — AS-IS DefColumns + EDIT_FLAG/DISCARD */}
      <FlexGridColumn header='Edit' binding='EDIT_FLAG' width={50} isReadOnly align='center' />
      <FlexGridColumn header='부문' binding='DIVISION_NM' width={140} isReadOnly />
      <FlexGridColumn header='부문급 부서' binding='DEPARTMENT_NM' width={160} isReadOnly />
      <FlexGridColumn header='부서' binding='DEPT_NM' width={160} isReadOnly />
      <FlexGridColumn header='고객군' binding='END_CUST_REPORT' width={100} isReadOnly />
      <FlexGridColumn header='판매처' binding='SOLDTO_CUST_REPORT_NM' width={140} isReadOnly />
      <FlexGridColumn header='제품군' binding='PRODUCT_GROUP' width={100} isReadOnly />
      <FlexGridColumn header='형태' binding='DM_BIZ_TYPE' width={80} isReadOnly />
      <FlexGridColumn header='불일치' binding='DISCARD' width={60} isReadOnly align='center' />

      {/* 동적 PIVOT 컬럼 — YYYYMM 별로 group, leaf = 해외법인 */}
      {groupedByMonth.map(group =>
        group.keys.length >= 2 ? (
          <FlexGridColumnGroup key={group.yyyymm} header={group.yyyymmLabel}>
            {group.keys.map(pk => (
              <FlexGridColumn
                key={pk.key}
                binding={pk.key}
                header={pk.osCorp}
                width={90}
                align='right'
                format='n2'
              />
            ))}
          </FlexGridColumnGroup>
        ) : (
          /* leaf 1개일 때는 group 없이 flat (룰 27 §F single-child 폭발 회피) */
          group.keys.map(pk => (
            <FlexGridColumn
              key={pk.key}
              binding={pk.key}
              header={`${group.yyyymmLabel} / ${pk.osCorp}`}
              width={120}
              align='right'
              format='n2'
            />
          ))
        )
      )}
    </FlexGridReact>
  );
};
