import commonStyles from '@foundation/styles/common-styles.module.scss';
import { Button, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';

// AS-IS 조회조건 Project/Model/Requestor 는 "텍스트 + 돋보기 팝업버튼"(design 02 §4.6).
//   SSP0015 ShipmentPsiDetailBar 디자인 참고 — 별도 sibling 버튼이 아니라 InputField 의
//   endAdornment 로 돋보기 버튼을 넣는 공용 popupSearchField 스타일. 직접입력도 되고 버튼으로
//   팝업 선택도 된다 — 단일값.
interface Props {
  value: string;
  onChange: (v: string) => void;
  onOpen: () => void;
  // Enter = 재조회(상세검색 바 등에서 사용). 미전달이면 Enter 무동작.
  onSearch?: () => void;
}

export const PopupInput = ({ value, onChange, onOpen, onSearch }: Props) => (
  <InputField
    fullWidth
    className={commonStyles.popupSearchField}
    value={value}
    InputProps={{
      endAdornment: (
        <Button
          appearance='outlined'
          priority='normal'
          iconComponent={<FunctionSearchIcon appearance='lined' onClick={onOpen} />}
        />
      ),
    }}
    onChange={e => onChange(e.target.value)}
    onKeyDown={onSearch ? e => e.key === 'Enter' && onSearch() : undefined}
  />
);
