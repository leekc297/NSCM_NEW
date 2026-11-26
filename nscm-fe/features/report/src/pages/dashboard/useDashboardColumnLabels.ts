import { useEffect, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import { MENU_ID } from './demand-as-dashboard.constants';

// 그리드 헤더 텍스트를 컬럼 메타(SCM_MST_SHEET_COLUMNS)에서 가져온다.
//   커스텀 FlexGrid 레이아웃(binding·width·align)은 유지하고 header 만 메타(colLblNm)로 치환한다
//   (사용자 결정 2026-11-24). 등록 SQL: .atlas/gscm-design/DMD0001/design/05_register_columns.sql.
//   미등록/실패 시 labels 가 비어 header(colNm, fallback) 가 fallback 을 돌려준다.
export const useDashboardColumnLabels = (sheetName: string) => {
  const [labels, setLabels] = useState<Record<string, string>>({});

  useEffect(() => {
    let alive = true;
    void apiClient
      .post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm: sheetName })
      .then(res => {
        if (!alive) return;
        const map: Record<string, string> = {};
        for (const c of res.data.result ?? []) map[c.colNm] = c.colLblNm;
        setLabels(map);
      })
      .catch(() => {
        // 메타 미등록/조회 실패 — fallback 헤더 유지.
      });
    return () => {
      alive = false;
    };
  }, [sheetName]);

  const header = (colNm: string, fallback: string): string => labels[colNm] ?? fallback;
  return { labels, header };
};
