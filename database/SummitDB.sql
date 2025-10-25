-- SummitLogic GateFlow – MySQL schema

CREATE TABLE airlines (
                          id              INT AUTO_INCREMENT PRIMARY KEY,
                          name            VARCHAR(120) NOT NULL,
                          iata_code       VARCHAR(3)  NULL,
                          icao_code       VARCHAR(4)  NULL,
                          created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          UNIQUE KEY uq_airlines_iata (iata_code),
                          UNIQUE KEY uq_airlines_icao (icao_code)
) ENGINE=InnoDB;

CREATE TABLE users (
                       id              INT AUTO_INCREMENT PRIMARY KEY,
                       first_name      VARCHAR(100) NOT NULL,
                       last_name       VARCHAR(100) NOT NULL,
                       email           VARCHAR(255) NOT NULL,
                       username        VARCHAR(100) NOT NULL,
                       password_hash   VARCHAR(255) NOT NULL,
                       role            ENUM('FlightCrew','GroundCrew','Supervisor') NOT NULL,
                       created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       UNIQUE KEY uq_users_email (email),
                       UNIQUE KEY uq_users_username (username),
                       KEY idx_users_role (role)
) ENGINE=InnoDB;

CREATE TABLE flights (
                         id                   INT AUTO_INCREMENT PRIMARY KEY,
                         airline_id           INT NOT NULL,
                         flight_number        VARCHAR(10) NOT NULL,
                         direction            ENUM('Outbound','Inbound') NOT NULL,
                         aircraft_type        VARCHAR(50) NOT NULL,
                         departure_airport    VARCHAR(4) NOT NULL,
                         arrival_airport      VARCHAR(4) NOT NULL,
                         scheduled_departure  DATETIME NOT NULL,
                         scheduled_arrival    DATETIME NOT NULL,
                         capacity_seats       INT NOT NULL,
                         load_factor_pct      DECIMAL(5,2) DEFAULT NULL,
                         service_date         DATE NOT NULL,
                         created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         CONSTRAINT fk_flights_airline FOREIGN KEY (airline_id) REFERENCES airlines(id),
                         UNIQUE KEY uq_flight_day (airline_id, flight_number, service_date),
                         KEY idx_flights_airline (airline_id)
) ENGINE=InnoDB;

-- ---------- CATALOG ----------
CREATE TABLE items (
                       id              INT AUTO_INCREMENT PRIMARY KEY,
                       name            VARCHAR(120) NOT NULL,
                       brand           VARCHAR(120) NULL,
                       category        ENUM('Beverage','Snack','Food') NOT NULL,
                       unit_desc       VARCHAR(60)  NULL,
                       size_desc       VARCHAR(60)  NULL,
                       notes           TEXT         NULL,
                       is_active       TINYINT(1) NOT NULL DEFAULT 1,
                       created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       KEY idx_items_name_brand_cat (name, brand, category)
) ENGINE=InnoDB;

CREATE TABLE beverages (
                           id               INT AUTO_INCREMENT PRIMARY KEY,
                           item_id          INT NOT NULL UNIQUE,
                           type             VARCHAR(80)  NULL,
                           flavour          VARCHAR(120) NULL,
                           volume_ml        INT NOT NULL,
                           alcohol_pct      DECIMAL(5,2) DEFAULT NULL,
                           default_pack_qty INT DEFAULT NULL,
                           CONSTRAINT fk_beverages_item FOREIGN KEY (item_id) REFERENCES items(id)
) ENGINE=InnoDB;

CREATE TABLE snacks (
                        id               INT AUTO_INCREMENT PRIMARY KEY,
                        item_id          INT NOT NULL UNIQUE,
                        type             VARCHAR(80)  NULL,
                        size_grams       INT DEFAULT NULL,
                        default_pack_qty INT DEFAULT NULL,
                        CONSTRAINT fk_snacks_item FOREIGN KEY (item_id) REFERENCES items(id)
) ENGINE=InnoDB;

CREATE TABLE food (
                      id               INT AUTO_INCREMENT PRIMARY KEY,
                      item_id          INT NOT NULL UNIQUE,
                      ingredients      TEXT NULL,
                      serving_size     VARCHAR(80) NULL,
                      default_pack_qty INT DEFAULT NULL,
                      CONSTRAINT fk_food_item FOREIGN KEY (item_id) REFERENCES items(id)
) ENGINE=InnoDB;

-- ---------- RULES FOR ALCOHOL HANDLING ----------
CREATE TABLE airline_beverage_rules (
                                        id                       INT AUTO_INCREMENT PRIMARY KEY,
                                        airline_id               INT NOT NULL,
                                        beverage_item_id         INT NOT NULL,
                                        min_full_pct_to_keep     DECIMAL(5,2) NOT NULL,
                                        combine_allowed          TINYINT(1) NOT NULL DEFAULT 0,
                                        expiry_days              INT DEFAULT NULL,
                                        tamper_seal_required     TINYINT(1) NOT NULL DEFAULT 1,
                                        notes                    TEXT NULL,
                                        created_at               DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                        updated_at               DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                        CONSTRAINT fk_rules_airline FOREIGN KEY (airline_id) REFERENCES airlines(id),
                                        CONSTRAINT fk_rules_item FOREIGN KEY (beverage_item_id) REFERENCES items(id),
                                        UNIQUE KEY uq_rules_airline_item (airline_id, beverage_item_id)
) ENGINE=InnoDB;

-- ---------- BOTTLE LIFECYCLE ----------
CREATE TABLE bottle_instances (
                                  id                 INT AUTO_INCREMENT PRIMARY KEY,
                                  beverage_item_id   INT NOT NULL,
                                  airline_id         INT NOT NULL,
                                  qr_code            VARCHAR(64) NOT NULL,
                                  batch_code         VARCHAR(64) NULL,
                                  initial_volume_ml  INT NOT NULL,
                                  current_pct        DECIMAL(5,2) DEFAULT NULL,
                                  status             ENUM('InFlight','Returned','Kept','Combined','Discarded') NOT NULL DEFAULT 'Returned',
                                  last_flight_id     INT DEFAULT NULL,
                                  created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  updated_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                  CONSTRAINT fk_bottle_item FOREIGN KEY (beverage_item_id) REFERENCES items(id),
                                  CONSTRAINT fk_bottle_airline FOREIGN KEY (airline_id) REFERENCES airlines(id),
                                  CONSTRAINT fk_bottle_last_flight FOREIGN KEY (last_flight_id) REFERENCES flights(id),
                                  UNIQUE KEY uq_bottle_qr (qr_code),
                                  KEY idx_bottle_airline (airline_id),
                                  KEY idx_bottle_item (beverage_item_id)
) ENGINE=InnoDB;

CREATE TABLE bottle_events (
                               id               INT AUTO_INCREMENT PRIMARY KEY,
                               bottle_id        INT NOT NULL,
                               flight_id        INT DEFAULT NULL,
                               user_id          INT DEFAULT NULL,
                               event_type       VARCHAR(40) NOT NULL,
                               amount_ml        INT DEFAULT NULL,
                               pct_after        DECIMAL(5,2) DEFAULT NULL,
                               photo_url        VARCHAR(512) DEFAULT NULL,
                               created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               CONSTRAINT fk_be_bottle FOREIGN KEY (bottle_id) REFERENCES bottle_instances(id),
                               CONSTRAINT fk_be_flight FOREIGN KEY (flight_id) REFERENCES flights(id),
                               CONSTRAINT fk_be_user   FOREIGN KEY (user_id) REFERENCES users(id),
                               KEY idx_be_bottle (bottle_id),
                               KEY idx_be_flight (flight_id),
                               KEY idx_be_user (user_id),
                               KEY idx_be_type (event_type)
) ENGINE=InnoDB;

-- ---------- PACKING PLANS AND VERIFICATION ----------
CREATE TABLE carts (
                       id            INT AUTO_INCREMENT PRIMARY KEY,
                       flight_id     INT NOT NULL,
                       code          VARCHAR(40) NOT NULL,
                       cart_type     VARCHAR(40) NULL,
                       created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       CONSTRAINT fk_carts_flight FOREIGN KEY (flight_id) REFERENCES flights(id),
                       KEY idx_carts_flight (flight_id)
) ENGINE=InnoDB;

CREATE TABLE trays (
                       id            INT AUTO_INCREMENT PRIMARY KEY,
                       cart_id       INT NOT NULL,
                       position_code VARCHAR(20) NOT NULL,
                       created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       CONSTRAINT fk_trays_cart FOREIGN KEY (cart_id) REFERENCES carts(id),
                       KEY idx_trays_cart (cart_id)
) ENGINE=InnoDB;

CREATE TABLE pack_plans (
                            id               INT AUTO_INCREMENT PRIMARY KEY,
                            flight_id        INT NOT NULL,
                            generated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            load_factor_pct  DECIMAL(5,2) DEFAULT NULL,
                            created_by       INT NOT NULL,
                            status           ENUM('draft','active','sealed') NOT NULL DEFAULT 'draft',
                            CONSTRAINT fk_pack_plans_flight FOREIGN KEY (flight_id) REFERENCES flights(id),
                            CONSTRAINT fk_pack_plans_user   FOREIGN KEY (created_by) REFERENCES users(id),
                            KEY idx_pp_flight (flight_id)
) ENGINE=InnoDB;

CREATE TABLE pack_plan_items (
                                 id               INT AUTO_INCREMENT PRIMARY KEY,
                                 pack_plan_id     INT NOT NULL,
                                 item_id          INT NOT NULL,
                                 quantity_units   INT NOT NULL,
                                 cart_id          INT DEFAULT NULL,
                                 tray_id          INT DEFAULT NULL,
                                 slot_label       VARCHAR(30) NULL,
                                 notes            TEXT NULL,
                                 CONSTRAINT fk_ppi_plan  FOREIGN KEY (pack_plan_id) REFERENCES pack_plans(id),
                                 CONSTRAINT fk_ppi_item  FOREIGN KEY (item_id) REFERENCES items(id),
                                 CONSTRAINT fk_ppi_cart  FOREIGN KEY (cart_id) REFERENCES carts(id),
                                 CONSTRAINT fk_ppi_tray  FOREIGN KEY (tray_id) REFERENCES trays(id),
                                 KEY idx_ppi_plan (pack_plan_id),
                                 KEY idx_ppi_item (item_id)
) ENGINE=InnoDB;

CREATE TABLE pack_events (
                             id                 INT AUTO_INCREMENT PRIMARY KEY,
                             pack_plan_item_id  INT NOT NULL,
                             user_id            INT NOT NULL,
                             event_type         ENUM('Scan','Place','Correct','Mismatch','PhotoVerify','SealReleased') NOT NULL,
                             quantity_units     INT DEFAULT NULL,
                             photo_url          VARCHAR(512) DEFAULT NULL,
                             created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             CONSTRAINT fk_pe_item FOREIGN KEY (pack_plan_item_id) REFERENCES pack_plan_items(id),
                             CONSTRAINT fk_pe_user FOREIGN KEY (user_id) REFERENCES users(id),
                             KEY idx_pe_item (pack_plan_item_id),
                             KEY idx_pe_user (user_id),
                             KEY idx_pe_type (event_type)
) ENGINE=InnoDB;

CREATE TABLE audits (
                        id            INT AUTO_INCREMENT PRIMARY KEY,
                        flight_id     INT NOT NULL,
                        created_by    INT NOT NULL,
                        created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        status        ENUM('pass','fail','needs_review') NOT NULL DEFAULT 'pass',
                        summary       TEXT NULL,
                        bundle_url    VARCHAR(512) NULL,
                        CONSTRAINT fk_audits_flight FOREIGN KEY (flight_id) REFERENCES flights(id),
                        CONSTRAINT fk_audits_user   FOREIGN KEY (created_by) REFERENCES users(id),
                        KEY idx_audits_flight (flight_id),
                        KEY idx_audits_user (created_by)
) ENGINE=InnoDB;

-- ---------- INVENTORY ----------
CREATE TABLE inventory_ground (
                                  id               INT AUTO_INCREMENT PRIMARY KEY,
                                  item_id          INT NOT NULL,
                                  quantity_units   INT NOT NULL DEFAULT 0,
                                  location         VARCHAR(80) NULL,
                                  updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                  CONSTRAINT fk_inv_g_item FOREIGN KEY (item_id) REFERENCES items(id),
                                  KEY idx_inv_g_item (item_id)
) ENGINE=InnoDB;

CREATE TABLE inventory_flight (
                                  id               INT AUTO_INCREMENT PRIMARY KEY,
                                  flight_id        INT NOT NULL,
                                  item_id          INT NOT NULL,
                                  quantity_units   INT NOT NULL DEFAULT 0,
                                  location         VARCHAR(80) NULL,
                                  updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                  CONSTRAINT fk_inv_f_flight FOREIGN KEY (flight_id) REFERENCES flights(id),
                                  CONSTRAINT fk_inv_f_item   FOREIGN KEY (item_id)  REFERENCES items(id),
                                  KEY idx_inv_f_flight (flight_id),
                                  KEY idx_inv_f_item (item_id)
) ENGINE=InnoDB;

-- ---------- TRAINING AND GAMIFICATION ----------
CREATE TABLE games (
                       id            INT AUTO_INCREMENT PRIMARY KEY,
                       title         VARCHAR(160) NOT NULL,
                       description   TEXT NULL,
                       is_active     TINYINT(1) NOT NULL DEFAULT 1,
                       created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE game_questions (
                                id              INT AUTO_INCREMENT PRIMARY KEY,
                                game_id         INT NOT NULL,
                                question_text   TEXT NOT NULL,
                                question_type   ENUM('MultipleChoice','TrueFalse','Slider','Photo') NOT NULL,
                                options_json    JSON NULL,
                                correct_answer  TEXT NULL,
                                order_index     INT NOT NULL DEFAULT 0,
                                created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                CONSTRAINT fk_gq_game FOREIGN KEY (game_id) REFERENCES games(id),
                                KEY idx_gq_game (game_id)
) ENGINE=InnoDB;

CREATE TABLE game_progress (
                               id             INT AUTO_INCREMENT PRIMARY KEY,
                               user_id        INT NOT NULL,
                               game_id        INT NOT NULL,
                               question_id    INT NOT NULL,
                               answer_text    TEXT NULL,
                               is_correct     TINYINT(1) DEFAULT NULL,
                               score_points   INT NOT NULL DEFAULT 0,
                               started_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               completed_at   DATETIME NULL,
                               progress_pct   DECIMAL(5,2) DEFAULT NULL,
                               CONSTRAINT fk_gp_user     FOREIGN KEY (user_id)    REFERENCES users(id),
                               CONSTRAINT fk_gp_game     FOREIGN KEY (game_id)    REFERENCES games(id),
                               CONSTRAINT fk_gp_question FOREIGN KEY (question_id)REFERENCES game_questions(id),
                               UNIQUE KEY uq_gp_user_question (user_id, question_id),
                               KEY idx_gp_game (game_id)
) ENGINE=InnoDB;

