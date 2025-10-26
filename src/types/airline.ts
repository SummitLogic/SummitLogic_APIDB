export interface Airline {
  id?: number;
  name: string;
  iata_code?: string;
  icao_code?: string;
  created_at?: Date;
  updated_at?: Date;
}

export interface CreateAirlineRequest {
  name: string;
  iata_code?: string;
  icao_code?: string;
}

export interface UpdateAirlineRequest {
  name?: string;
  iata_code?: string;
  icao_code?: string;
}
