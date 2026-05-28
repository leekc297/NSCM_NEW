/**
 * 날짜 포맷팅 유틸리티
 */

export const formatDate = (date: Date): string => {
  return date.toISOString().split('T')[0];
};

export const formatDateTime = (date: Date): string => {
  return date.toISOString();
};

export const parseDate = (dateStr: string): Date => {
  return new Date(dateStr);
};
