export interface Game {
  id?: number;
  title: string;
  description?: string;
  is_active?: boolean;
  created_at?: Date;
  updated_at?: Date;
}

export interface CreateGameRequest {
  title: string;
  description?: string;
}

export interface UpdateGameRequest {
  title?: string;
  description?: string;
  is_active?: boolean;
}

export interface GameQuestion {
  id?: number;
  game_id: number;
  question_text: string;
  question_type: 'MultipleChoice' | 'TrueFalse' | 'Slider' | 'Photo';
  options_json?: any;
  correct_answer?: string;
  order_index?: number;
  created_at?: Date;
  updated_at?: Date;
}

export interface CreateGameQuestionRequest {
  game_id: number;
  question_text: string;
  question_type: 'MultipleChoice' | 'TrueFalse' | 'Slider' | 'Photo';
  options_json?: any;
  correct_answer?: string;
  order_index?: number;
}

export interface GameProgress {
  id?: number;
  user_id: number;
  game_id: number;
  question_id: number;
  answer_text?: string;
  is_correct?: boolean;
  score_points: number;
  started_at?: Date;
  completed_at?: Date;
  progress_pct?: number;
}

export interface CreateGameProgressRequest {
  user_id: number;
  game_id: number;
  question_id: number;
  answer_text?: string;
  is_correct?: boolean;
  score_points: number;
}
