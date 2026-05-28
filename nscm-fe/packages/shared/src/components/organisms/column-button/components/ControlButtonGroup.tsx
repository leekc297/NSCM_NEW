import { Button } from '@lges/design-system';
import { ControlCloseIcon, ControlConfirmIcon } from '@lges/design-system/icon';

interface ControlButtonGroupProps {
  handleDefault: () => void;
  handleOk: () => Promise<void>;
  handleCancel: () => void;
}

export const ControlButtonGroup = ({
  handleDefault,
  handleOk,
  handleCancel,
}: ControlButtonGroupProps) => {
  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'row',
        justifyContent: 'flex-end',
        paddingTop: '5px',
        gap: '5px',
      }}
    >
      <Button
        appearance='outlined'
        iconComponent={<ControlConfirmIcon size='default' />}
        buttonLabel='Default'
        onClick={handleDefault}
      />
      <Button
        appearance='outlined'
        iconComponent={<ControlConfirmIcon size='default' />}
        buttonLabel='OK'
        onClick={handleOk}
      />
      <Button
        appearance='outlined'
        iconComponent={<ControlCloseIcon size='default' />}
        buttonLabel='Cancel'
        onClick={handleCancel}
      />
    </div>
  );
};
