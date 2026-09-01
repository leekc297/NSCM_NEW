/**
 * 숫자 유틸리티
 */

export const formatNumber = (num: number, decimals: number = 0): string => {
  return num.toLocaleString('en-US', {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  });
};

export const formatCurrency = (num: number, currency: string = 'USD'): string => {
  return num.toLocaleString('en-US', {
    style: 'currency',
    currency,
  });
};

export const clamp = (num: number, min: number, max: number): number => {
  return Math.min(Math.max(num, min), max);
};
