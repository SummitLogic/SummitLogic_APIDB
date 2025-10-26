export interface BottleInstance {
  id?: number;
  beverage_item_id: number;
  airline_id: number;
  qr_code: string;
  batch_code?: string;
  initial_volume_ml: number;
  current_pct?: number;
  status: 'InFlight' | 'Returned' | 'Kept' | 'Combined' | 'Discarded';
  last_flight_id?: number;
  created_at?: Date;
  updated_at?: Date;
}

export interface CreateBottleInstanceRequest {
  beverage_item_id: number;
  airline_id: number;
  qr_code: string;
  batch_code?: string;
  initial_volume_ml: number;
}

export interface UpdateBottleInstanceRequest {
  current_pct?: number;
  status?: 'InFlight' | 'Returned' | 'Kept' | 'Combined' | 'Discarded';
  last_flight_id?: number;
}

export interface PackPlan {
  id?: number;
  flight_id: number;
  generated_at?: Date;
  load_factor_pct?: number;
  created_by: number;
  status: 'draft' | 'active' | 'sealed';
}

export interface CreatePackPlanRequest {
  flight_id: number;
  created_by: number;
  load_factor_pct?: number;
}

export interface UpdatePackPlanRequest {
  status?: 'draft' | 'active' | 'sealed';
  load_factor_pct?: number;
}

export interface Cart {
  id?: number;
  flight_id: number;
  code: string;
  cart_type?: string;
  created_at?: Date;
  updated_at?: Date;
}

export interface CreateCartRequest {
  flight_id: number;
  code: string;
  cart_type?: string;
}

export interface UpdateCartRequest {
  code?: string;
  cart_type?: string;
}

export interface Tray {
  id?: number;
  cart_id: number;
  position_code: string;
  created_at?: Date;
  updated_at?: Date;
}

export interface CreateTrayRequest {
  cart_id: number;
  position_code: string;
}
