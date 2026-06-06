/* @refresh reload */
import { useCallback, useEffect, useRef } from 'react';

import { apiClient } from '@foundation/apis';

/**
 * G3 — Performance Tracing hook (Phase 5 신규 구현, 2026-06-03)
 *
 * AS-IS DataService.FP_Log2("SpeedUp", form, action, "start"/"end") 동등.
 * + AS-IS Authentication.SaveMenuConnect (메뉴 open/close 로그) 통합.
 * + AS-IS BaseForm.SetSaveLog (화면 실행 시간) 통합.
 *
 * 본 hook 의 동작:
 * 1. 화면 진입 시 menu_open log 자동 기록
 * 2. 화면 종료 시 menu_close log 자동 기록 (cleanup)
 * 3. measure(action, fn) 으로 임의 동작의 duration 측정
 *
 * ⚠️ BE 통합: AS-IS 시점에는 BE 의 `POST /api/system/perf-log` endpoint 또는
 *    `@PerfLog` annotation 이 미구현일 수 있음. BE 미구현 시 본 hook 호출은 silently fail.
 *    BE 신규: SCM_SYS_PERF_LOG 테이블 + PerfLogController + AOP @PerfLog (Phase 5 후속).
 *
 * 사용 예:
 * ```typescript
 * const { measure } = usePerfTrace(MENU_ID);
 *
 * const handleDivisionChange = (divisionId: string) => {
 *   measure('division_change', async () => {
 *     await refetchCombos({ divisionIds: divisionId });
 *   });
 * };
 * ```
 */
export const usePerfTrace = (menuId: string) => {
  const startTimeRef = useRef<number>(performance.now());

  // 화면 진입 시 menu_open log
  useEffect(() => {
    void postPerfLog({ menuId, action: 'menu_open', phase: 'one' });

    // 화면 종료 시 menu_close log + 전체 duration
    return () => {
      const duration = performance.now() - startTimeRef.current;
      void postPerfLog({ menuId, action: 'menu_close', phase: 'one', duration });
    };
  }, [menuId]);

  /**
   * 임의 action 의 duration 측정
   */
  const measure = useCallback(
    async <T>(action: string, fn: () => Promise<T>): Promise<T> => {
      const start = performance.now();
      void postPerfLog({ menuId, action, phase: 'start' });
      try {
        const result = await fn();
        const duration = performance.now() - start;
        void postPerfLog({ menuId, action, phase: 'end', duration });
        return result;
      } catch (e) {
        const duration = performance.now() - start;
        void postPerfLog({ menuId, action, phase: 'end', duration: -1, error: String(e) });
        throw e;
      }
    },
    [menuId]
  );

  return { measure };
};

interface PerfLogPayload {
  menuId: string;
  action: string;
  phase: 'start' | 'end' | 'one';
  duration?: number;
  error?: string;
}

async function postPerfLog(payload: PerfLogPayload): Promise<void> {
  try {
    // BE 미구현 시 silently fail
    await apiClient.post('/admin/system/perf-log', payload);
  } catch {
    // ignore — perf log 실패는 화면 동작 영향 X
  }
}
