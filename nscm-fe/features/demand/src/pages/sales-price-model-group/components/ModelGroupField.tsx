import { ItemByDivisionModal } from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { joinCodes, modelGroupsOf } from '../utils/sales-price-model-group.util';

interface Props {
  value: string[];
  onChange: (mdlGrs: string[]) => void;
  divisionId: string;
  deptIds: string[];
  endCustomers: string[];
  scmSiteIds: string[];
  projectCodes: string[];
  disabled?: boolean;
  gridSize?: number;
}

// 조회조건 Model Group (설계서 [개요] B16) — 공용 ITEM 팝업(COM0008)에서 Model 을 고르면 그 Model 의 Model Group 을 쓴다.
//   카탈로그 ItemField 는 라벨(Model / Nickname)과 값(Model ID)이 달라 쓸 수 없고, 공용 카탈로그는 이 화면에서
//   고치지 않는다(Hard Boundary). 그래서 화면 폴더에 둔다. 직접 입력도 받는다(쉼표 구분 Model Group).
export const ModelGroupField = ({
  value,
  onChange,
  divisionId,
  deptIds,
  endCustomers,
  scmSiteIds,
  projectCodes,
  disabled,
  gridSize = 3,
}: Props) => {
  const { t } = useTranslation();
  const [open, setOpen] = useState(false);

  return (
    <Grid size={gridSize}>
      <FormItem
        className={commonStyles.formItem}
        label={t('LBL01092', '_Model Group')}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            className={commonStyles.popupSearchField}
            disabled={disabled}
            value={value.join(',')}
            onDoubleClick={() => {
              if (!disabled) setOpen(true);
            }}
            onChange={event =>
              onChange(
                event.target.value
                  .split(',')
                  .map(v => v.trim())
                  .filter(Boolean)
              )
            }
            InputProps={{
              endAdornment: (
                <Button
                  appearance='outlined'
                  priority='normal'
                  disabled={disabled}
                  iconComponent={<FunctionSearchIcon appearance='lined' />}
                  onClick={() => {
                    if (!disabled) setOpen(true);
                  }}
                />
              ),
            }}
          />
        )}
      />
      <ItemByDivisionModal
        open={open}
        modalClose={() => setOpen(false)}
        setSelectedValue={itemIds => onChange(modelGroupsOf(itemIds))}
        preSearchParams={
          {
            divisionId,
            deptId: joinCodes(deptIds, ','),
            endCustomer: joinCodes(endCustomers, ','),
            salesSite: joinCodes(scmSiteIds, ','),
            projectCode: joinCodes(projectCodes, ','),
            itemId: '',
          } as never
        }
        multiCheckbox
        callFromCell={false}
      />
    </Grid>
  );
};
