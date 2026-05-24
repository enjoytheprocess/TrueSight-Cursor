export type InventoryItem = {
  id: string;
  name: string;
  quantity: number;
  unit: string;
  expiryDate: string | null;
  addedAt: string;
  updatedAt: string;
};

export type InventoryInput = {
  name: string;
  quantity: number;
  unit: string;
  expiryDate: string | null;
};

