import { apiClient } from '@foundation/apis';

import { MODAL_SALES_VERSION, MODAL_SALES_VERSION_SHEET } from './version-modal.constants';

interface CallProcResult {
  ok: boolean;
  message?: string;
}

const parseFirstValue = (data: unknown): string | undefined => {
  const result = (data as { result?: unknown })?.result;
  const rows = Array.isArray(result)
    ? result
    : result && typeof result === 'object'
      ? (Object.values(result as Record<string, unknown>).find(Array.isArray) as
          | unknown[]
          | undefined)
      : undefined;
  const first = rows?.[0];
  if (!first || typeof first !== 'object') return undefined;
  const value = Object.values(first as Record<string, unknown>).find(
    item => typeof item === 'string' && item.trim() !== ''
  );
  return typeof value === 'string' ? value.trim() : undefined;
};

const callProc = async (
  buttonCode: string,
  payload: Record<string, string>
): Promise<CallProcResult> => {
  const response = await apiClient.post<Record<string, unknown>>(
    `/${MODAL_SALES_VERSION}/${MODAL_SALES_VERSION_SHEET}/${buttonCode}/call-proc`,
    payload
  );
  if (response.status >= 400 || Number((response.data as { code?: string }).code)) {
    return {
      ok: false,
      message: (response.data as { message?: string }).message?.trim(),
    };
  }
  const value = parseFirstValue(response.data);
  if (value && value.toLowerCase() !== 'success' && String(Number(value)) !== value) {
    return { ok: false, message: value };
  }
  return { ok: true };
};

export const callVersionAction = (params: {
  divisionId: string;
  versionNo: string;
  versionDescription: string;
  resultDate: string;
  actionType: string;
  mvPlanYyyymm: string;
  updateYn: string;
}) => callProc('ACTION', params);

export const callVersionActionBp = (params: {
  divisionId: string;
  versionNo: string;
  versionDescription: string;
  actionType: string;
}) => callProc('ACTION_BP', params);

export const callTransfer = (params: {
  divisionId: string;
  versionNo: string;
  versionType: string;
  actionType: string;
}) => callProc('TRANSFER', params);
