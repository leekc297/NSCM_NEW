/**
 * SSP0015 Memo(Comments) 팝업 — AS-IS SSP0015_ShipmentPSICommentsPopup 이식.
 *   상단 Mobility 그리드에서 WH_IN 측정치 행의 일자(D_) 셀 우클릭 → "Memo" 로 연다(엑셀 메모형).
 *   읽기전용 정보 + 편집(Change Qty / Comments) → 저장 시 SAVE_SHIPMENT_PSI_COMMENTS(13 IN).
 *   저장은 부모(onSave)가 mutation 으로 수행한다.
 */
import { useEffect, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Box, Grid, Typography } from '@shared/mui';

// 모달이 표시/저장에 쓰는 메모 컨텍스트(셀 + GET_SHIPMENT_PSI_COMMENTS 매칭 값).
export interface MemoContext {
  divisionId: string;
  planDate: string; // YYYYMMDD
  fromSite: string;
  fromSiteNm: string;
  itemId: string;
  nickName: string;
  yyyymmdd: string; // D_ 컬럼 일자(YYYYMMDD)
  measure: string; // 'WH_IN'
  planType: string;
  seq: string;
  whInQty: string; // 현재 WH_IN 셀 수량
  prodQty: string; // 생산(다음 행) 수량
  // GET_SHIPMENT_PSI_COMMENTS 매칭값(없으면 '0'/'')
  beforeQty: string;
  gapQty: string;
  currentQty: string;
  comments: string;
}

export interface MemoSaveInput {
  changeQty: string;
  comments: string;
  changed: boolean; // Change Qty 가 현재값과 다른가 → changeFlag
}

interface Props {
  open: boolean;
  data: MemoContext | null;
  onClose: () => void;
  onSave: (input: MemoSaveInput) => void;
}

const fmtDate = (ymd: string): string =>
  /^\d{8}$/.test(ymd) ? `${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}` : ymd;

// 숫자만(정수, 백스페이스/음수 없음 — AS-IS Change Qty 입력 규칙).
const onlyDigits = (v: string): string => v.replace(/[^\d]/g, '');

const RO = ({ label, value }: { label: string; value: string }) => (
  <Grid size={6}>
    <FormItem
      label={label}
      labelAlign='right'
      render={() => <InputField value={value} disabled />}
    />
  </Grid>
);

export const ShipmentPsiMemoModal = ({ open, data, onClose, onSave }: Props) => {
  const [changeQty, setChangeQty] = useState('');
  const [comments, setComments] = useState('');

  // 열릴 때 현재값으로 초기화 — Change Qty 기본 = 현재 WH_IN 수량, Comments = 기존 메모.
  useEffect(() => {
    if (!open || !data) return;
    setChangeQty(onlyDigits(data.whInQty || '0'));
    setComments(data.comments ?? '');
  }, [open, data]);

  if (!data) return null;

  const handleSubmit = () => {
    onSave({
      changeQty: changeQty === '' ? '0' : changeQty,
      comments,
      changed: onlyDigits(data.whInQty || '0') !== (changeQty === '' ? '0' : changeQty),
    });
  };

  return (
    <CustomDialog
      size={500}
      height={460}
      position='basic'
      open={open}
      title='Memo'
      disableScale={false}
      handleClose={onClose}
      handleSubmit={handleSubmit}
      customContentArea={
        // 세로 flex: 상단 정보(고정) → Comments(남은 공간 전부 차지) → 하단 버튼(고정).
        //   Comments textarea 가 flex:1 로 늘어나 모달 하단 여백을 흡수한다(AS-IS 레이아웃).
        <Box sx={{ display: 'flex', flexDirection: 'column', height: '100%', gap: 1, p: 1 }}>
          {/* 정보 2열 — AS-IS 배열: 좌(Div/From Site/Date/WH in Qty/Change Qty) · 우(Plan Date/Model/Measure/Prod Qty/Gap Qty/Before Qty) */}
          <Grid container spacing={1} columnSpacing={2}>
            <RO label='Div' value={data.divisionId} />
            <RO label='Plan Date' value={fmtDate(data.planDate)} />
            <RO label='From Site' value={data.fromSiteNm || data.fromSite} />
            <RO label='Model' value={data.itemId} />
            <RO label='Date' value={fmtDate(data.yyyymmdd)} />
            <RO label='Measure' value={data.measure} />
            <RO label='WH in Qty' value={data.whInQty} />
            <RO label='Prod Qty' value={data.prodQty} />
            <Grid size={6}>
              <FormItem
                label='Change Qty'
                labelAlign='right'
                render={() => (
                  <InputField
                    value={changeQty}
                    textAlign='right'
                    onChange={e => setChangeQty(onlyDigits(e.target.value))}
                  />
                )}
              />
            </Grid>
            <RO label='Gap Qty' value={data.gapQty} />
            <Grid size={6} />
            <RO label='Before Qty' value={data.beforeQty} />
          </Grid>

          {/* Comments — 라벨 상단 + 전체 폭 textarea, 남은 세로공간 전부 차지(AS-IS rtxComments). */}
          <Typography variant='body2' sx={{ mt: 0.5 }}>
            Comments
          </Typography>
          <InputField
            type='textarea'
            value={comments}
            multiline
            fullWidth
            onChange={e => setComments(e.target.value)}
            sx={{
              flex: 1,
              minHeight: 0,
              '& .MuiInputBase-root': { height: '100%', alignItems: 'flex-start' },
              '& textarea': { height: '100% !important', overflow: 'auto' },
            }}
          />

          {/* 하단 버튼 — 우측 정렬, Save(앞)/Cancel. */}
          <Box sx={{ display: 'flex', justifyContent: 'flex-end', gap: 1 }}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Save'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleSubmit}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Cancel'
              onClick={onClose}
            />
          </Box>
        </Box>
      }
    />
  );
};
