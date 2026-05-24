import { InventoryItem } from './types';

export function isExpiringSoon(item: InventoryItem, now = new Date()) {
  if (!item.expiryDate) {
    return false;
  }

  const soon = new Date(now);
  soon.setDate(soon.getDate() + 3);
  return new Date(`${item.expiryDate}T00:00:00`) <= soon;
}

export function formatDate(value: string) {
  return new Intl.DateTimeFormat(undefined, { month: 'short', day: 'numeric' }).format(new Date(`${value}T00:00:00`));
}

export function formatQuantity(value: number) {
  return new Intl.NumberFormat(undefined, { maximumFractionDigits: 2 }).format(value);
}
