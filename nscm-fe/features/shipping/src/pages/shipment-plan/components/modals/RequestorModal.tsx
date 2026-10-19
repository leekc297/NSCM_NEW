import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { CustomDialog, DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, InputField } from '@shared/lges';
import { Stack } from '@shared/mui';

import { COMBO, LBL, MENU_ID } from '../../shipment-plan.constants';

interface Props {
  open: boolean;
  modalClose: () => void;
  // AS-IS UserInfoPopup(SingleSelectYn=true) — 선택 사용자 1건 반환 (02 §4.6#3)
  setSelectedValue: (userId: string, userName: string) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// Requestor 사용자검색 팝업 — AS-IS UserInfoPopup(SystemManager.UP_FX_GetUserInfoList) 의 SSP0060 전용
//   신규 컴포넌트(사용자 확정 2026-09-25 — 타 도메인 UserSearchPopup 직접 import 금지).
//   주의: AS-IS 원문 SQL(SystemManager DB)은 접근 불가라 콤보 SQL 미등록 상태(§2.3 임의 등록 금지) —
//   SCM_ADM_CMBO_SQL_M 에 'SSP0060_UserInfoList' 등록 전까지 목록은 빈 리스트다(메타 정비 대기,
//   04_react-gap.md 확인필요). 등록 계약: CODE=USER_ID / NAME=사용자명 / @userName 부분검색 토큰.
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'CODE', colLblNm: 'User ID', colWth: 140 },
  { colNm: 'NAME', colLblNm: 'User Name', colWth: 200 },
];

export const RequestorModal = ({ open, modalClose, setSelectedValue }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGridType>();
  const [keyword, setKeyword] = useState('');
  const [searchKeyword, setSearchKeyword] = useState('');
  // AS-IS UserInfoPopup 은 인자 없이 열려 빈 그리드로 뜨고 Search 를 눌러야 조회된다
  //   (SCP0001 VendorModal 선례 c75b85ac 와 동일 — 팝업 오픈만으로 자동조회 금지, basic-check #7).
  //   첫 Search 전까지 조회·표시를 막는다.
  const [hasSearched, setHasSearched] = useState(false);

  const [users] = useTabComboQueries({
    filters: [{ comboId: COMBO.REQUESTOR_USER, mnuId: MENU_ID, userName: searchKeyword }],
    enabled: open && hasSearched,
  });
  // 첫 Search 전에는 캐시가 있어도 빈 그리드로 둔다(오픈 자동조회 방지, enabled 와 2중 가드).
  const rows = useMemo(
    () => (hasSearched ? (users ?? []).map(r => ({ CODE: str(r.CODE), NAME: str(r.NAME) })) : []),
    [users, hasSearched]
  );

  // 재오픈마다 자동조회 금지 상태로 초기화(검색어도 비운다).
  useEffect(() => {
    if (!open) return;
    setHasSearched(false);
    setKeyword('');
    setSearchKeyword('');
  }, [open]);

  const handleSearch = () => {
    setSearchKeyword(keyword);
    setHasSearched(true);
  };

  const handleSelect = () => {
    const g = gridRef.current;
    if (!g) return;
    const row = GridUtils.getRow(g, g.selection?.row ?? -1) as
      | { CODE?: unknown; NAME?: unknown }
      | undefined;
    if (!row) return;
    setSelectedValue(str(row.CODE), str(row.NAME));
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={480}
      handleClose={modalClose}
      disableButtonCancel
      disableScale
      title={t(LBL.REQUESTOR, '_Requestor')}
      customContentArea={
        <Stack direction='column' spacing={1}>
          <Stack direction='row' spacing={1}>
            <InputField
              fullWidth
              value={keyword}
              onChange={e => setKeyword(e.target.value)}
              onKeyDown={e => e.key === 'Enter' && handleSearch()}
            />
            <Button appearance='contained' priority='primary' onClick={handleSearch}>
              {t(LBL.SEARCH, '_Search')}
            </Button>
          </Stack>
          <DataGrid
            gridRef={gridRef}
            isReadOnly
            itemsSource={rows as unknown as WijmoRowItem[]}
            staticColumns={POPUP_COLUMNS}
            dblClick={handleSelect}
          />
          {/* 하단 버튼 — 액션 먼저, Close 마지막 (nscm-patterns §3.7) */}
          <Stack direction='row' justifyContent='flex-end' spacing={1}>
            <Button appearance='contained' priority='primary' onClick={handleSelect}>
              {t(LBL.OK, '_OK')}
            </Button>
            <Button appearance='outlined' priority='normal' onClick={modalClose}>
              {t(LBL.CLOSE, '_Close')}
            </Button>
          </Stack>
        </Stack>
      }
    />
  );
};
