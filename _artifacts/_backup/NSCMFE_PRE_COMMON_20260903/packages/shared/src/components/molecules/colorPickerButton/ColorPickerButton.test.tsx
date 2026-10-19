import { fireEvent, render, screen } from '@testing-library/react';
import { describe, expect, it, vi } from 'vitest';

import { ColorPickerButton } from './ColorPickerButton';

describe('ColorPickerButton', () => {
  it('클릭 시 팝오버를 열고 "자동" 선택 시 빈문자열을 반환한다', () => {
    const onChange = vi.fn();
    render(<ColorPickerButton value='' onChange={onChange} title='Cell Color' />);
    fireEvent.click(screen.getByTitle('Cell Color'));
    fireEvent.click(screen.getByText('자동'));
    expect(onChange).toHaveBeenCalledWith('');
  });

  it('유효한 hex 입력 후 적용하면 정규화된 값을 반환한다', () => {
    const onChange = vi.fn();
    render(<ColorPickerButton value='' onChange={onChange} title='Cell Color' />);
    fireEvent.click(screen.getByTitle('Cell Color'));
    fireEvent.change(screen.getByPlaceholderText('#RRGGBB'), { target: { value: '#abc' } });
    fireEvent.click(screen.getByText('적용'));
    expect(onChange).toHaveBeenCalledWith('#AABBCC');
  });
});
