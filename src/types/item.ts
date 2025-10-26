export interface Item {
  id?: number;
  name: string;
  brand?: string;
  category: 'Beverage' | 'Snack' | 'Food';
  unit_desc?: string;
  size_desc?: string;
  notes?: string;
  is_active?: boolean;
  created_at?: Date;
  updated_at?: Date;
}

export interface CreateItemRequest {
  name: string;
  category: 'Beverage' | 'Snack' | 'Food';
  brand?: string;
  unit_desc?: string;
  size_desc?: string;
  notes?: string;
}

export interface UpdateItemRequest {
  name?: string;
  category?: 'Beverage' | 'Snack' | 'Food';
  brand?: string;
  unit_desc?: string;
  size_desc?: string;
  notes?: string;
  is_active?: boolean;
}

export interface Beverage {
  id?: number;
  item_id: number;
  type?: string;
  flavour?: string;
  volume_ml: number;
  alcohol_pct?: number;
  default_pack_qty?: number;
}

export interface CreateBeverageRequest {
  item_id: number;
  type?: string;
  flavour?: string;
  volume_ml: number;
  alcohol_pct?: number;
  default_pack_qty?: number;
}

export interface Snack {
  id?: number;
  item_id: number;
  type?: string;
  size_grams?: number;
  default_pack_qty?: number;
}

export interface CreateSnackRequest {
  item_id: number;
  type?: string;
  size_grams?: number;
  default_pack_qty?: number;
}

export interface Food {
  id?: number;
  item_id: number;
  ingredients?: string;
  serving_size?: string;
  default_pack_qty?: number;
}

export interface CreateFoodRequest {
  item_id: number;
  ingredients?: string;
  serving_size?: string;
  default_pack_qty?: number;
}
