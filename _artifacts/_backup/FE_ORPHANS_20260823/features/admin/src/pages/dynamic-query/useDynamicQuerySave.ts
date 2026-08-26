// SYS0013 저장 오케스트레이션 — 표준 useProcMutation + useSaveWithValidation 수렴 (2026-07-09 재개발).
// 시퀀스(AS-IS SaveData 4-SP 체인 정합): main → columns → parameters → role diff → toast/invalidate.
// AS-IS 는 마스터만 'success' 검사했으나 TO-BE 는 전 시트 예외 전파(mutateAsync reject) — 격차 아님(강화).
import type { MutableRefObject } from 'react';

import { apiClient } from '@foundation/apis';
import { useQueryClient } from '@foundation/query-client';
import { useProcMutation, useSaveWithValidation } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './dynamic-query.constants';
import { toColumnsPayload, toMainPayload, toParametersPayload } from './dynamic-query.payload';
import type {
  ColumnMetaRow,
  ParameterMetaRow,
  PendingModalColumnRow,
  PendingModalConditionRow,
  PendingQueryMeta,
  QueryRow,
} from './dynamic-query.types';
import { useDynamicQueryStore } from './useDynamicQueryStore';

interface SaveArgs {
  tabId: string;
  mainRows: QueryRow[];
  columnsRows: ColumnMetaRow[];
  parametersRows: ParameterMetaRow[];
  // 편집 모달 OK 메타 — 최종 상태 vs 원본 diff(I/M/D) 를 저장 시 계산 (AS-IS 직렬화 반환 정합).
  // 신규 행은 main 저장 후 NEW_DQ_IDS 로 채번 ID 수신 (AS-IS sDB_ID 체인).
  pendingNewMetaRef: MutableRefObject<PendingQueryMeta | null>;
}

// 최종 상태 vs 원본 diff — I(신규 키) / M(필드 변경) / D(원본에만 존재).
const asStr = (v: unknown): string =>
  typeof v === 'string' || typeof v === 'number' || typeof v === 'boolean' ? String(v) : '';

const diffRows = <T extends Record<string, unknown>>(
  finals: T[],
  originals: T[],
  key: string,
  fields: string[]
): (T & { CRUD_TYPE: 'I' | 'M' | 'D' })[] => {
  const origMap = new Map(originals.map(o => [asStr(o[key]).toUpperCase(), o]));
  const finalKeys = new Set(finals.map(f => asStr(f[key]).toUpperCase()));
  const out: (T & { CRUD_TYPE: 'I' | 'M' | 'D' })[] = [];
  for (const f of finals) {
    const o = origMap.get(asStr(f[key]).toUpperCase());
    if (!o) out.push({ ...f, CRUD_TYPE: 'I' });
    else if (fields.some(fd => asStr(f[fd]) !== asStr(o[fd])))
      out.push({ ...o, ...f, CRUD_TYPE: 'M' });
  }
  for (const o of originals) {
    if (!finalKeys.has(asStr(o[key]).toUpperCase())) out.push({ ...o, CRUD_TYPE: 'D' });
  }
  return out;
};

export const useDynamicQuerySave = ({
  tabId,
  mainRows,
  columnsRows,
  parametersRows,
  pendingNewMetaRef,
}: SaveArgs) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);
  const queryClient = useQueryClient();
  const sessionUserId = useSessionStore(s => s.session.userId);
  const { saveWithValidation } = useSaveWithValidation();

  const staticColumns = useDynamicQueryStore(s => s.staticColumns);
  const selectedQueryId = useDynamicQueryStore(s => s.selectedQueryId);
  const roleSelection = useDynamicQueryStore(s => s.roleSelection);
  const roleOriginal = useDynamicQueryStore(s => s.roleOriginal);
  const setSelectedQueryId = useDynamicQueryStore(s => s.setSelectedQueryId);

  // onSuccess/onError no-op override — 시트별 3중 toast/invalidate 방지, 완료 처리는 아래에서 1회.
  const noop = () => undefined;
  const mainMutation = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    onSuccess: noop,
    onError: noop,
  });
  const columnsMutation = useProcMutation<MENU_ID, SHEETS.COLUMNS>({
    menuId: MENU_ID,
    sheetName: SHEETS.COLUMNS,
    tabId,
    onSuccess: noop,
    onError: noop,
  });
  const parametersMutation = useProcMutation<MENU_ID, SHEETS.PARAMETERS>({
    menuId: MENU_ID,
    sheetName: SHEETS.PARAMETERS,
    tabId,
    onSuccess: noop,
    onError: noop,
  });

  //[E20260807-AUDIT] call-proc 직접 호출 저장 결과 판정 — axios 인터셉터가 오류도 resolve 하므로
  //   status/code 직접 판정 (정본 business-plan.api.ts:71~74). 실패 시 throw → handleSave catch 의
  //   setAlert 로 SP message passthrough (message 부재 시 MSG00003 fallback).
  const assertCallProcOk = (res: { status: number; data: unknown }) => {
    if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
      throw new Error(
        (res.data as { message?: string })?.message?.trim() ||
          t('MSG00003', '_저장에 실패하였습니다.')
      );
    }
  };

  // saveWithValidation 을 검증 게이트로만 사용 — valid 시 mutate 콜백이 동기 호출되는 계약 이용.
  const validateSheet = <T,>(rows: T[], sheet: SHEETS.MAIN | SHEETS.COLUMNS | SHEETS.PARAMETERS) => {
    if (rows.length === 0) return true;
    let valid = false;
    saveWithValidation(rows, staticColumns[sheet], () => {
      valid = true;
    });
    return valid; // invalid 시 MSG00013 alert 은 saveWithValidation 이 표시
  };

  const handleSave = () => {
    const mainDirty = mainRows.filter(r => r.CRUD_TYPE);
    const columnsDirty = columnsRows.filter(r => r.CRUD_TYPE);
    const parametersDirty = parametersRows.filter(r => r.CRUD_TYPE);
    // Role diff — 저장된 쿼리 선택 시에만 (AS-IS SaveData ② Role 저장 정합).
    const roleChanged =
      !!selectedQueryId &&
      (roleSelection.length !== roleOriginal.length ||
        roleSelection.some(r => !roleOriginal.includes(r)));

    // 편집 모달 OK 분(Column/Condition diff) — main 필드 무변경이어도 저장 대상.
    const pendingMeta = pendingNewMetaRef.current;
    const pendingColsDiff = pendingMeta
      ? diffRows(
          pendingMeta.colsFinal as unknown as Record<string, unknown>[],
          pendingMeta.colsOriginal as unknown as Record<string, unknown>[],
          'COLUMN_NAME',
          ['VALUE_TYPE', 'VALID_YN', 'SEQNO']
        )
      : [];
    const pendingCondsDiff = pendingMeta
      ? diffRows(
          pendingMeta.condsFinal as unknown as Record<string, unknown>[],
          pendingMeta.condsOriginal as unknown as Record<string, unknown>[],
          'PARAMETER_ID',
          ['PARAMETER_TYPE', 'VALID_YN', 'SEQNO']
        )
      : [];
    const pendingRoleNew = pendingMeta?.row.CRUD_TYPE === 'I' && pendingMeta.roles.length > 0;

    const totalDirty =
      mainDirty.length +
      columnsDirty.length +
      parametersDirty.length +
      pendingColsDiff.length +
      pendingCondsDiff.length +
      (roleChanged ? 1 : 0) +
      (pendingRoleNew ? 1 : 0);
    if (totalDirty === 0) {
      // ⚠ MSG00003 은 '저장에 실패하였습니다' — 변경 없음 안내는 MSG00627 (2026-07-09 오인용 수정)
      void setAlert({ type: 'alert', content: t('MSG00627', '_변경 사항이 없습니다.') });
      return;
    }

    // 필수값 검증 3시트 선행 — 하나라도 실패하면 부분 저장 없이 중단.
    if (!validateSheet(mainDirty, SHEETS.MAIN)) return;
    if (!validateSheet(columnsDirty, SHEETS.COLUMNS)) return;
    if (!validateSheet(parametersDirty, SHEETS.PARAMETERS)) return;

    void (async () => {
      const ok = await setAlert({
        type: 'confirm',
        content: t('MSG00617', '_{0} 행을 저장하시겠습니까?').replace('{0}', String(totalDirty)),
      });
      if (!ok) return;
      try {
        // payload 매퍼 = SP JSON_TABLE camelCase 계약 (dynamic-query.payload.ts 헤더 참조).
        // 행 타입(UPPER_SNAKE)과 전송 계약(camelCase)이 다른 유일 지점 — cast 로 경계 명시.
        let newIds: string[] = [];
        if (mainDirty.length > 0) {
          const saveRes = await mainMutation.mutateAsync(
            toMainPayload(mainDirty) as unknown as ResponseData<MENU_ID, SHEETS.MAIN>[]
          );
          // SAVE_QUERY_LIST v3 — O_RC1.NEW_DQ_IDS ('#' 연결, I 행 순서 = payload 순서).
          const rc1 = (
            saveRes?.result as unknown as { o_rc1?: { NEW_DQ_IDS?: string }[] } | undefined
          )?.o_rc1;
          newIds = String(rc1?.[0]?.NEW_DQ_IDS ?? '')
            .split('#')
            .filter(Boolean);
        }
        // 모달 OK 분 저장 체인 — 신규 행은 NEW_DQ_IDS 로 채번 ID, 기존 행은 자기 DQ_ID.
        // (AS-IS SaveData: 마스터 저장 → sDB_ID 로 Role/Column/Parameter 순차 저장 정합)
        if (pendingMeta) {
          let targetId: string | undefined;
          if (pendingMeta.row.CRUD_TYPE === 'I') {
            const insertRows = mainDirty.filter(r => r.CRUD_TYPE === 'I');
            const idx = insertRows.indexOf(pendingMeta.row);
            targetId = idx >= 0 ? newIds[idx] : undefined;
          } else {
            targetId = String(pendingMeta.row.DQ_ID ?? '') || undefined;
          }
          if (targetId) {
            if (pendingColsDiff.length > 0) {
              await columnsMutation.mutateAsync(
                pendingColsDiff.map(c => {
                  const col = c as unknown as PendingModalColumnRow & { CRUD_TYPE: string };
                  return {
                    crudType: col.CRUD_TYPE,
                    dqId: Number(targetId),
                    columnName: col.COLUMN_NAME,
                    valueYn: 'Y',
                    valueType: col.VALUE_TYPE || 'System.String',
                    aggregate: col.AGGREGATE ?? '',
                    validYn: col.VALID_YN || 'Y',
                    seqno: col.SEQNO || '0',
                  };
                }) as unknown as ResponseData<MENU_ID, SHEETS.COLUMNS>[]
              );
            }
            if (pendingCondsDiff.length > 0) {
              await parametersMutation.mutateAsync(
                pendingCondsDiff.map(c => {
                  const cond = c as unknown as PendingModalConditionRow & { CRUD_TYPE: string };
                  return {
                    crudType: cond.CRUD_TYPE,
                    dqId: Number(targetId),
                    parameterId: cond.PARAMETER_ID,
                    parameterType: cond.PARAMETER_TYPE || 'Parameter',
                    operationId: cond.OPERATION_ID ?? '=',
                    validYn: cond.VALID_YN || 'Y',
                    repYn: cond.REP_YN ?? 'N',
                    seqno: cond.SEQNO || '0',
                    defaultValue: cond.DEFAULT_VALUE ?? null,
                  };
                }) as unknown as ResponseData<MENU_ID, SHEETS.PARAMETERS>[]
              );
            }
            // Role — 신규 행만 모달 메타로 저장 (기존 행은 roleChanged diff 경로).
            if (pendingMeta.row.CRUD_TYPE === 'I') {
              for (const groupId of pendingMeta.roles) {
                const roleRes = await apiClient.post(`/${MENU_ID}/${SHEETS.USER_GROUP}/SAVE/call-proc`, {
                  dqId: targetId,
                  groupId,
                  validYn: 'Y',
                  createdBy: sessionUserId ?? '',
                  lastUpdatedBy: sessionUserId ?? '',
                });
                assertCallProcOk(roleRes); //[E20260807-AUDIT] 실패 시 성공 toast 차단
              }
            }
          }
        }
        pendingNewMetaRef.current = null;
        if (columnsDirty.length > 0) {
          await columnsMutation.mutateAsync(
            toColumnsPayload(columnsDirty) as unknown as ResponseData<MENU_ID, SHEETS.COLUMNS>[]
          );
        }
        if (parametersDirty.length > 0) {
          await parametersMutation.mutateAsync(
            toParametersPayload(parametersDirty) as unknown as ResponseData<
              MENU_ID,
              SHEETS.PARAMETERS
            >[]
          );
        }
        // Role diff — P_SYS0013_SAVE_USER_GROUP 은 scalar 시그니처(그룹별 단건 MERGE) 라서
        // 배열 mutation 표준을 못 태움 → call-proc 직접 호출 (문서화된 예외).
        if (roleChanged) {
          const added = roleSelection.filter(r => !roleOriginal.includes(r));
          const removed = roleOriginal.filter(r => !roleSelection.includes(r));
          const roleCalls = [
            ...added.map(g => ({ groupId: g, validYn: 'Y' })),
            ...removed.map(g => ({ groupId: g, validYn: 'N' })),
          ];
          for (const rc of roleCalls) {
            const roleRes = await apiClient.post(`/${MENU_ID}/${SHEETS.USER_GROUP}/SAVE/call-proc`, {
              dqId: selectedQueryId,
              groupId: rc.groupId,
              validYn: rc.validYn,
              createdBy: sessionUserId ?? '',
              lastUpdatedBy: sessionUserId ?? '',
            });
            assertCallProcOk(roleRes); //[E20260807-AUDIT] 실패 시 성공 toast 차단
          }
        }
        setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
        setSelectedQueryId('');
        void queryClient.invalidateQueries({ queryKey: [tabId] });
      } catch (err) {
        void setAlert({ type: 'alert', content: String((err as Error)?.message ?? err) });
      }
    })();
  };

  return { handleSave };
};
