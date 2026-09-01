import { useEffect, useMemo, useState } from 'react';

import dayjs from '@foundation/dayjs';
import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, InputField } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS } from '../../sales-reports.constants';
import type { TextboxRow } from '../../sales-reports.types';
import styles from '../../SalesReports.module.scss';
import { callSaveTextboxRow } from '../../utils/sales-reports.api';
import { toCellStr } from '../../utils/sales-reports.gridCombos';

import { useTextboxModalStore } from './textboxModalStore';

interface Props {
  open: boolean;
  modalClose: () => void;
  versionNo: string;
}

// 구분자 유무가 섞인 일자 문자열('20260717' / '2026-07-13')에서 기준월(yyyymm)만 뽑는다.
const monthOf = (v: unknown): string => {
  const digits = toCellStr(v).replace(/\D/g, '');
  return digits.length >= 6 ? digits.slice(0, 6) : '';
};

// Textbox 팝업 (Division 82 전용) — AS-IS DMF0044_SalesReport_TextboxPopup(453행):
//   조회 = GET_TEXTBOX (OUT 4커서 — data=행별 13개월 코멘트 / rc3 MONDAY=13개월 컬럼 기준월).
//   저장 = SAVE_TEXTBOX 16키(P_VERSION_NO/P_YYYYMM/P_DESCRIPTION1~13 — 1행분).
//   ⭐ 정책③(2026-07-22 교정): AS-IS 는 행 반복 변수 덮어쓰기로 "마지막 행만 저장"되는 구조적 결함 —
//   TO-BE 는 수정 행별 SP 반복 호출 (SP 무수정, 전 수정 행 저장).
export const TextboxModal = ({ open, modalClose, versionNo }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const [edited, setEdited] = useState<Record<number, Record<string, string>>>({});
  const [saving, setSaving] = useState(false);

  // 확정된 조회조건 — useTabProcQuery filters 참조 안정화 원천
  const appliedVersionNo = useTextboxModalStore(state => state.appliedVersionNo);
  const setAppliedVersionNo = useTextboxModalStore(state => state.setAppliedVersionNo);

  useEffect(() => {
    if (open) {
      setEdited({});
      setAppliedVersionNo(versionNo);
    }
  }, [open, versionNo, setAppliedVersionNo]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const filters = useMemo(
    () => ({ versionNo: appliedVersionNo, userId: sesUserId, mnuId: MENU_ID }),
    [appliedVersionNo, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.TEXTBOX>({
    menuId: MENU_ID,
    sheetName: SHEETS.TEXTBOX,
    tabId: MENU_ID,
    filters,
    enabled: open && appliedVersionNo !== '',
  });
  const rows = useMemo<TextboxRow[]>(
    () => (data as { data?: TextboxRow[] } | undefined)?.data ?? [],
    [data]
  );

  const descKeys = useMemo(() => Array.from({ length: 13 }, (_, i) => `DESCRIPTION${i + 1}`), []);

  // 컬럼 헤더 = 실제 월 라벨. DESCRIPTION1~13 은 저장 키일 뿐 월 정보가 없어서, 기준월을 못 구하면
  //   화면에 'D1..D13' 이 그대로 나온다(AS-IS 는 '2026-07' 형태).
  //   원천은 조회 SP 의 부가 커서다 — rows 와 같은 응답이라 추가 호출은 없다
  //   (ProcResponse = 커서 키별 배열).
  //   실측(2026-08-12): rc3 = { MONDAY: '2026-07-13' } / rc2 = { YYYYMMDD: '20260717' }.
  //   구분자 유무가 서로 달라 숫자만 남긴 뒤 앞 6자리를 쓴다. 이름이 명시적인 MONDAY 를 우선하고
  //   없으면 rc2 로 떨어진다.
  const baseYyyymm = useMemo(
    () => monthOf(data?.rc3?.[0]?.MONDAY) || monthOf(data?.rc2?.[0]?.YYYYMMDD),
    [data]
  );

  const monthLabels = useMemo(() => {
    // 기준월 미수신 시에는 컬럼명 폴백 — 빈 헤더보다 낫고 원인도 드러난다.
    if (baseYyyymm === '') return descKeys.map(k => k.replace('DESCRIPTION', 'D'));
    // dayjs customParseFormat 미등록 환경 — 하이픈 형태로 변환해 파싱 (VersionModal 동일 규약)
    const base = dayjs(`${baseYyyymm.slice(0, 4)}-${baseYyyymm.slice(4, 6)}-01`);
    return descKeys.map((_, i) => base.add(i, 'month').format('YYYY-MM'));
  }, [baseYyyymm, descKeys]);

  const valueOf = (rowIdx: number, key: string): string =>
    edited[rowIdx]?.[key] ?? toCellStr((rows[rowIdx] as Record<string, unknown>)?.[key]);

  const setValue = (rowIdx: number, key: string, v: string) =>
    setEdited(prev => ({ ...prev, [rowIdx]: { ...prev[rowIdx], [key]: v } }));

  // ⭐ 저장 — 수정 행별 반복 호출 (정책③ 교정)
  const handleSave = async () => {
    if (saving) return;
    const targets = Object.keys(edited).map(Number);
    if (targets.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }
    setSaving(true);
    try {
      for (const rowIdx of targets) {
        const row = rows[rowIdx] as Record<string, unknown> | undefined;
        if (!row) continue;
        const payload: Record<string, string> = {
          versionNo,
          yyyymm: toCellStr(row.YYYYMM),
        };
        descKeys.forEach((k, i) => {
          payload[`description${i + 1}`] = valueOf(rowIdx, k);
        });
        const res = await callSaveTextboxRow(payload);
        if (!res.ok) {
          void setAlert({
            type: 'alert',
            content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
          });
          return;
        }
      }
      // 성공은 Toast, 실패/검증은 Alert (AGENTS.md 저장 피드백 규칙)
      void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
      setEdited({});
      void refetch?.();
    } finally {
      setSaving(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={980}
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Text</h2>
        </div>
      }
      customContentArea={
        // 공용 modalContentWrapper 를 쓰지 않는다 — 그쪽 height:100% 는 부모 높이가 정해져야
        //   먹는데 이 팝업은 그렇지 않아 내용만큼만 잡히고 Save/Close 가 위로 붙었다.
        //   AS-IS 는 큰 창이므로 전용 wrapper 로 높이를 명시한다.
        <div className={styles.textboxContentWrapper}>
          <div className={styles.textboxTableWrapper}>
            <table className={styles.textboxTable}>
              <thead>
                {/* YYYYMM(행 기준월)은 표시하지 않는다 — 저장 payload 키로만 쓴다 */}
                <tr>
                  {monthLabels.map((label, i) => (
                    <th key={descKeys[i]}>{label}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {rows.map((row, rowIdx) => (
                  <tr key={toCellStr((row as Record<string, unknown>).YYYYMM) || rowIdx}>
                    {descKeys.map(k => (
                      <td key={k}>
                        {/* AS-IS 는 월별 코멘트가 여러 줄 입력(큰 칸)이다.
                            필수: type='textarea'. InputField 는 type 으로 분기해서 기본값('text')
                            이면 size 별 고정 높이(large=44px)를 걸어 버려, multiline 만 줘서는
                            칸이 안 커지고 글자만 상자 밖으로 흘러나온다. 'textarea' 면 그 분기가
                            빠지고 height:100% 가 적용돼 아래 래퍼 높이를 그대로 채운다.
                            크기를 td 가 아니라 래퍼 div 가 갖는 이유는 SalesReports.module.scss 주석 참조. */}
                        <div className={styles.textboxCell}>
                          <InputField
                            type='textarea'
                            fullWidth
                            value={valueOf(rowIdx, k)}
                            onChange={e => setValue(rowIdx, k, e.target.value)}
                          />
                        </div>
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Save'
              disabled={saving}
              onClick={() => void handleSave()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
