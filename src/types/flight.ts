export interface Flight {
  id?: number;
  airline_id: number;
  flight_number: string;
  direction: 'Outbound' | 'Inbound';
  aircraft_type: string;
  departure_airport: string;
  arrival_airport: string;
  scheduled_departure: Date;
  scheduled_arrival: Date;
  capacity_seats: number;
  load_factor_pct?: number;
  service_date: Date;
  created_at?: Date;
  updated_at?: Date;
}

export interface CreateFlightRequest {
  airline_id: number;
  flight_number: string;
  direction: 'Outbound' | 'Inbound';
  aircraft_type: string;
  departure_airport: string;
  arrival_airport: string;
  scheduled_departure: string;
  scheduled_arrival: string;
  capacity_seats: number;
  service_date: string;
  load_factor_pct?: number;
}

export interface UpdateFlightRequest {
  flight_number?: string;
  direction?: 'Outbound' | 'Inbound';
  aircraft_type?: string;
  departure_airport?: string;
  arrival_airport?: string;
  scheduled_departure?: string;
  scheduled_arrival?: string;
  capacity_seats?: number;
  load_factor_pct?: number;
}
