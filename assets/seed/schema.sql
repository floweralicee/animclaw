-- OpenClaw workspace seed schema + sample data
-- Used to pre-build workspace.duckdb for new workspace onboarding.

-- ── nanoid32 macro ──
CREATE OR REPLACE MACRO nanoid32() AS (
  SELECT string_agg(
    substr('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_-',
      (floor(random() * 64) + 1)::int, 1), '')
  FROM generate_series(1, 32)
);

-- ── Core tables ──

CREATE TABLE IF NOT EXISTS objects (
  id VARCHAR PRIMARY KEY DEFAULT (gen_random_uuid()::VARCHAR),
  name VARCHAR NOT NULL,
  description VARCHAR,
  icon VARCHAR,
  default_view VARCHAR DEFAULT 'table',
  parent_document_id VARCHAR,
  sort_order INTEGER DEFAULT 0,
  source_app VARCHAR,
  immutable BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(name)
);

CREATE TABLE IF NOT EXISTS fields (
  id VARCHAR PRIMARY KEY DEFAULT (gen_random_uuid()::VARCHAR),
  object_id VARCHAR NOT NULL REFERENCES objects(id),
  name VARCHAR NOT NULL,
  description VARCHAR,
  type VARCHAR NOT NULL,
  required BOOLEAN DEFAULT false,
  default_value VARCHAR,
  related_object_id VARCHAR REFERENCES objects(id),
  relationship_type VARCHAR,
  enum_values JSON,
  enum_colors JSON,
  enum_multiple BOOLEAN DEFAULT false,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(object_id, name)
);

CREATE TABLE IF NOT EXISTS entries (
  id VARCHAR PRIMARY KEY DEFAULT (gen_random_uuid()::VARCHAR),
  object_id VARCHAR NOT NULL REFERENCES objects(id),
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS entry_fields (
  id VARCHAR PRIMARY KEY DEFAULT (gen_random_uuid()::VARCHAR),
  entry_id VARCHAR NOT NULL REFERENCES entries(id),
  field_id VARCHAR NOT NULL REFERENCES fields(id),
  value VARCHAR,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(entry_id, field_id)
);

CREATE TABLE IF NOT EXISTS statuses (
  id VARCHAR PRIMARY KEY DEFAULT (gen_random_uuid()::VARCHAR),
  object_id VARCHAR NOT NULL REFERENCES objects(id),
  name VARCHAR NOT NULL,
  color VARCHAR DEFAULT '#94a3b8',
  sort_order INTEGER DEFAULT 0,
  is_default BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(object_id, name)
);

CREATE TABLE IF NOT EXISTS documents (
  id VARCHAR PRIMARY KEY DEFAULT (gen_random_uuid()::VARCHAR),
  title VARCHAR DEFAULT 'Untitled',
  icon VARCHAR,
  cover_image VARCHAR,
  file_path VARCHAR NOT NULL UNIQUE,
  parent_id VARCHAR REFERENCES documents(id),
  parent_object_id VARCHAR REFERENCES objects(id),
  sort_order INTEGER DEFAULT 0,
  is_published BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ── Seed: people ──

INSERT INTO objects (id, name, description, icon, default_view, immutable, sort_order)
VALUES ('seed_obj_people_00000000000000', 'people', 'Contact management', 'users', 'table', true, 0);

INSERT INTO fields (id, object_id, name, type, required, sort_order) VALUES
  ('seed_fld_people_fullname_000000', 'seed_obj_people_00000000000000', 'Full Name', 'text', true, 0),
  ('seed_fld_people_email_000000000', 'seed_obj_people_00000000000000', 'Email Address', 'email', true, 1),
  ('seed_fld_people_phone_000000000', 'seed_obj_people_00000000000000', 'Phone Number', 'phone', false, 2),
  ('seed_fld_people_company_0000000', 'seed_obj_people_00000000000000', 'Company', 'text', false, 3);

INSERT INTO fields (id, object_id, name, type, required, enum_values, enum_colors, sort_order) VALUES
  ('seed_fld_people_status_00000000', 'seed_obj_people_00000000000000', 'Status', 'enum', false,
   '["Active","Inactive","Lead"]'::JSON, '["#22c55e","#94a3b8","#3b82f6"]'::JSON, 4);

INSERT INTO fields (id, object_id, name, type, required, sort_order) VALUES
  ('seed_fld_people_notes_000000000', 'seed_obj_people_00000000000000', 'Notes', 'richtext', false, 5);

INSERT INTO entries (id, object_id) VALUES
  ('seed_ent_people_sarah_000000000', 'seed_obj_people_00000000000000'),
  ('seed_ent_people_james_000000000', 'seed_obj_people_00000000000000'),
  ('seed_ent_people_maria_000000000', 'seed_obj_people_00000000000000'),
  ('seed_ent_people_alex_0000000000', 'seed_obj_people_00000000000000'),
  ('seed_ent_people_priya_000000000', 'seed_obj_people_00000000000000');

INSERT INTO entry_fields (entry_id, field_id, value) VALUES
  ('seed_ent_people_sarah_000000000', 'seed_fld_people_fullname_000000', 'Sarah Chen'),
  ('seed_ent_people_sarah_000000000', 'seed_fld_people_email_000000000', 'sarah@acmecorp.com'),
  ('seed_ent_people_sarah_000000000', 'seed_fld_people_phone_000000000', '+1 (555) 234-5678'),
  ('seed_ent_people_sarah_000000000', 'seed_fld_people_company_0000000', 'Acme Corp'),
  ('seed_ent_people_sarah_000000000', 'seed_fld_people_status_00000000', 'Active'),
  ('seed_ent_people_james_000000000', 'seed_fld_people_fullname_000000', 'James Wilson'),
  ('seed_ent_people_james_000000000', 'seed_fld_people_email_000000000', 'james@techcorp.io'),
  ('seed_ent_people_james_000000000', 'seed_fld_people_phone_000000000', '+1 (555) 876-5432'),
  ('seed_ent_people_james_000000000', 'seed_fld_people_company_0000000', 'TechCorp Industries'),
  ('seed_ent_people_james_000000000', 'seed_fld_people_status_00000000', 'Active'),
  ('seed_ent_people_maria_000000000', 'seed_fld_people_fullname_000000', 'Maria Garcia'),
  ('seed_ent_people_maria_000000000', 'seed_fld_people_email_000000000', 'maria@innovate.co'),
  ('seed_ent_people_maria_000000000', 'seed_fld_people_phone_000000000', '+1 (555) 345-6789'),
  ('seed_ent_people_maria_000000000', 'seed_fld_people_company_0000000', 'Innovate Co'),
  ('seed_ent_people_maria_000000000', 'seed_fld_people_status_00000000', 'Lead'),
  ('seed_ent_people_alex_0000000000', 'seed_fld_people_fullname_000000', 'Alex Thompson'),
  ('seed_ent_people_alex_0000000000', 'seed_fld_people_email_000000000', 'alex@designstudio.io'),
  ('seed_ent_people_alex_0000000000', 'seed_fld_people_phone_000000000', '+1 (555) 567-8901'),
  ('seed_ent_people_alex_0000000000', 'seed_fld_people_company_0000000', 'Design Studio'),
  ('seed_ent_people_alex_0000000000', 'seed_fld_people_status_00000000', 'Active'),
  ('seed_ent_people_priya_000000000', 'seed_fld_people_fullname_000000', 'Priya Patel'),
  ('seed_ent_people_priya_000000000', 'seed_fld_people_email_000000000', 'priya@cloudnine.dev'),
  ('seed_ent_people_priya_000000000', 'seed_fld_people_phone_000000000', '+1 (555) 789-0123'),
  ('seed_ent_people_priya_000000000', 'seed_fld_people_company_0000000', 'CloudNine'),
  ('seed_ent_people_priya_000000000', 'seed_fld_people_status_00000000', 'Lead');

CREATE OR REPLACE VIEW v_people AS
PIVOT (
  SELECT e.id as entry_id, e.created_at, e.updated_at,
         f.name as field_name, ef.value
  FROM entries e
  JOIN entry_fields ef ON ef.entry_id = e.id
  JOIN fields f ON f.id = ef.field_id
  WHERE e.object_id = 'seed_obj_people_00000000000000'
) ON field_name IN ('Full Name', 'Email Address', 'Phone Number', 'Company', 'Status', 'Notes') USING first(value);

-- ── Seed: company ──

INSERT INTO objects (id, name, description, icon, default_view, immutable, sort_order)
VALUES ('seed_obj_company_0000000000000', 'company', 'Company tracking', 'building-2', 'table', true, 1);

INSERT INTO fields (id, object_id, name, type, required, sort_order) VALUES
  ('seed_fld_company_name_000000000', 'seed_obj_company_0000000000000', 'Company Name', 'text', true, 0);

INSERT INTO fields (id, object_id, name, type, required, enum_values, enum_colors, sort_order) VALUES
  ('seed_fld_company_industry_00000', 'seed_obj_company_0000000000000', 'Industry', 'enum', false,
   '["Technology","Finance","Healthcare","Education","Retail","Other"]'::JSON,
   '["#3b82f6","#22c55e","#ef4444","#f59e0b","#8b5cf6","#94a3b8"]'::JSON, 1);

INSERT INTO fields (id, object_id, name, type, required, sort_order) VALUES
  ('seed_fld_company_website_000000', 'seed_obj_company_0000000000000', 'Website', 'text', false, 2);

INSERT INTO fields (id, object_id, name, type, required, enum_values, enum_colors, sort_order) VALUES
  ('seed_fld_company_type_000000000', 'seed_obj_company_0000000000000', 'Type', 'enum', false,
   '["Client","Partner","Vendor","Prospect"]'::JSON,
   '["#22c55e","#3b82f6","#f59e0b","#94a3b8"]'::JSON, 3);

INSERT INTO fields (id, object_id, name, type, required, sort_order) VALUES
  ('seed_fld_company_notes_00000000', 'seed_obj_company_0000000000000', 'Notes', 'richtext', false, 4);

INSERT INTO entries (id, object_id) VALUES
  ('seed_ent_company_acme_000000000', 'seed_obj_company_0000000000000'),
  ('seed_ent_company_tech_000000000', 'seed_obj_company_0000000000000'),
  ('seed_ent_company_innov_00000000', 'seed_obj_company_0000000000000');

INSERT INTO entry_fields (entry_id, field_id, value) VALUES
  ('seed_ent_company_acme_000000000', 'seed_fld_company_name_000000000', 'Acme Corp'),
  ('seed_ent_company_acme_000000000', 'seed_fld_company_industry_00000', 'Technology'),
  ('seed_ent_company_acme_000000000', 'seed_fld_company_website_000000', 'https://acmecorp.com'),
  ('seed_ent_company_acme_000000000', 'seed_fld_company_type_000000000', 'Client'),
  ('seed_ent_company_tech_000000000', 'seed_fld_company_name_000000000', 'TechCorp Industries'),
  ('seed_ent_company_tech_000000000', 'seed_fld_company_industry_00000', 'Finance'),
  ('seed_ent_company_tech_000000000', 'seed_fld_company_website_000000', 'https://techcorp.io'),
  ('seed_ent_company_tech_000000000', 'seed_fld_company_type_000000000', 'Partner'),
  ('seed_ent_company_innov_00000000', 'seed_fld_company_name_000000000', 'Innovate Co'),
  ('seed_ent_company_innov_00000000', 'seed_fld_company_industry_00000', 'Healthcare'),
  ('seed_ent_company_innov_00000000', 'seed_fld_company_website_000000', 'https://innovate.co'),
  ('seed_ent_company_innov_00000000', 'seed_fld_company_type_000000000', 'Prospect');

CREATE OR REPLACE VIEW v_company AS
PIVOT (
  SELECT e.id as entry_id, e.created_at, e.updated_at,
         f.name as field_name, ef.value
  FROM entries e
  JOIN entry_fields ef ON ef.entry_id = e.id
  JOIN fields f ON f.id = ef.field_id
  WHERE e.object_id = 'seed_obj_company_0000000000000'
) ON field_name IN ('Company Name', 'Industry', 'Website', 'Type', 'Notes') USING first(value);

-- ── Seed: task ──

INSERT INTO objects (id, name, description, icon, default_view, sort_order)
VALUES ('seed_obj_task_000000000000000', 'task', 'Task tracking board', 'check-square', 'kanban', 2);

INSERT INTO fields (id, object_id, name, type, required, sort_order) VALUES
  ('seed_fld_task_title_00000000000', 'seed_obj_task_000000000000000', 'Title', 'text', true, 0),
  ('seed_fld_task_desc_000000000000', 'seed_obj_task_000000000000000', 'Description', 'text', false, 1);

INSERT INTO fields (id, object_id, name, type, required, enum_values, enum_colors, sort_order) VALUES
  ('seed_fld_task_status_0000000000', 'seed_obj_task_000000000000000', 'Status', 'enum', false,
   '["In Queue","In Progress","Done"]'::JSON, '["#94a3b8","#3b82f6","#22c55e"]'::JSON, 2),
  ('seed_fld_task_priority_00000000', 'seed_obj_task_000000000000000', 'Priority', 'enum', false,
   '["Low","Medium","High"]'::JSON, '["#94a3b8","#f59e0b","#ef4444"]'::JSON, 3);

INSERT INTO fields (id, object_id, name, type, required, sort_order) VALUES
  ('seed_fld_task_duedate_000000000', 'seed_obj_task_000000000000000', 'Due Date', 'date', false, 4),
  ('seed_fld_task_notes_00000000000', 'seed_obj_task_000000000000000', 'Notes', 'richtext', false, 5);

INSERT INTO statuses (id, object_id, name, color, sort_order, is_default) VALUES
  ('seed_sts_task_queue_00000000000', 'seed_obj_task_000000000000000', 'In Queue', '#94a3b8', 0, true),
  ('seed_sts_task_progress_00000000', 'seed_obj_task_000000000000000', 'In Progress', '#3b82f6', 1, false),
  ('seed_sts_task_done_000000000000', 'seed_obj_task_000000000000000', 'Done', '#22c55e', 2, false);

INSERT INTO entries (id, object_id) VALUES
  ('seed_ent_task_review_0000000000', 'seed_obj_task_000000000000000'),
  ('seed_ent_task_onboard_000000000', 'seed_obj_task_000000000000000'),
  ('seed_ent_task_retro_00000000000', 'seed_obj_task_000000000000000'),
  ('seed_ent_task_investor_00000000', 'seed_obj_task_000000000000000'),
  ('seed_ent_task_dashperf_00000000', 'seed_obj_task_000000000000000');

INSERT INTO entry_fields (entry_id, field_id, value) VALUES
  ('seed_ent_task_review_0000000000', 'seed_fld_task_title_00000000000', 'Review Q1 reports'),
  ('seed_ent_task_review_0000000000', 'seed_fld_task_desc_000000000000', 'Review and summarize Q1 financial reports'),
  ('seed_ent_task_review_0000000000', 'seed_fld_task_status_0000000000', 'In Progress'),
  ('seed_ent_task_review_0000000000', 'seed_fld_task_priority_00000000', 'High'),
  ('seed_ent_task_review_0000000000', 'seed_fld_task_duedate_000000000', '2026-03-15'),
  ('seed_ent_task_onboard_000000000', 'seed_fld_task_title_00000000000', 'Update client onboarding docs'),
  ('seed_ent_task_onboard_000000000', 'seed_fld_task_desc_000000000000', 'Refresh the onboarding documentation with latest screenshots'),
  ('seed_ent_task_onboard_000000000', 'seed_fld_task_status_0000000000', 'In Queue'),
  ('seed_ent_task_onboard_000000000', 'seed_fld_task_priority_00000000', 'Medium'),
  ('seed_ent_task_onboard_000000000', 'seed_fld_task_duedate_000000000', '2026-03-20'),
  ('seed_ent_task_retro_00000000000', 'seed_fld_task_title_00000000000', 'Schedule team retrospective'),
  ('seed_ent_task_retro_00000000000', 'seed_fld_task_desc_000000000000', 'Organize end-of-sprint retro for the team'),
  ('seed_ent_task_retro_00000000000', 'seed_fld_task_status_0000000000', 'Done'),
  ('seed_ent_task_retro_00000000000', 'seed_fld_task_priority_00000000', 'Low'),
  ('seed_ent_task_investor_00000000', 'seed_fld_task_title_00000000000', 'Prepare investor deck'),
  ('seed_ent_task_investor_00000000', 'seed_fld_task_desc_000000000000', 'Create presentation for upcoming investor meeting'),
  ('seed_ent_task_investor_00000000', 'seed_fld_task_status_0000000000', 'In Queue'),
  ('seed_ent_task_investor_00000000', 'seed_fld_task_priority_00000000', 'High'),
  ('seed_ent_task_investor_00000000', 'seed_fld_task_duedate_000000000', '2026-04-01'),
  ('seed_ent_task_dashperf_00000000', 'seed_fld_task_title_00000000000', 'Fix dashboard performance'),
  ('seed_ent_task_dashperf_00000000', 'seed_fld_task_desc_000000000000', 'Investigate and resolve slow loading on analytics dashboard'),
  ('seed_ent_task_dashperf_00000000', 'seed_fld_task_status_0000000000', 'In Progress'),
  ('seed_ent_task_dashperf_00000000', 'seed_fld_task_priority_00000000', 'Medium'),
  ('seed_ent_task_dashperf_00000000', 'seed_fld_task_duedate_000000000', '2026-03-10');

CREATE OR REPLACE VIEW v_task AS
PIVOT (
  SELECT e.id as entry_id, e.created_at, e.updated_at,
         f.name as field_name, ef.value
  FROM entries e
  JOIN entry_fields ef ON ef.entry_id = e.id
  JOIN fields f ON f.id = ef.field_id
  WHERE e.object_id = 'seed_obj_task_000000000000000'
) ON field_name IN ('Title', 'Description', 'Status', 'Priority', 'Due Date', 'Notes') USING first(value);

-- ── Seed: script ──

INSERT INTO objects (id, name, description, icon, default_view, sort_order)
VALUES ('seed_obj_script_000000000000000', 'script', 'Script library', 'file-text', 'table', 3);

INSERT INTO fields (id, object_id, name, type, required, sort_order) VALUES
  ('seed_fld_script_title_000000000', 'seed_obj_script_000000000000000', 'Title', 'text', true, 0),
  ('seed_fld_script_writer_00000000', 'seed_obj_script_000000000000000', 'Writer', 'text', false, 1);

INSERT INTO fields (id, object_id, name, type, required, enum_values, enum_colors, sort_order) VALUES
  ('seed_fld_script_genre_000000000', 'seed_obj_script_000000000000000', 'Genre', 'enum', false,
   '["Animation","Drama","Comedy","Horror","Thriller","Sci-Fi","Documentary","Other"]'::JSON,
   '["#6366f1","#3b82f6","#f59e0b","#ef4444","#8b5cf6","#06b6d4","#22c55e","#94a3b8"]'::JSON, 2),
  ('seed_fld_script_status_00000000', 'seed_obj_script_000000000000000', 'Status', 'enum', false,
   '["Development","Pre-Production","Production","Post-Production","Completed","Archived"]'::JSON,
   '["#94a3b8","#f59e0b","#3b82f6","#8b5cf6","#22c55e","#64748b"]'::JSON, 3),
  ('seed_fld_script_format_00000000', 'seed_obj_script_000000000000000', 'Format', 'enum', false,
   '["Feature Film","Short Film","TV Episode","Web Series","Documentary","Other"]'::JSON,
   '["#3b82f6","#06b6d4","#f59e0b","#22c55e","#8b5cf6","#94a3b8"]'::JSON, 4);

INSERT INTO fields (id, object_id, name, type, required, sort_order) VALUES
  ('seed_fld_script_pages_000000000', 'seed_obj_script_000000000000000', 'Pages', 'number', false, 5),
  ('seed_fld_script_notes_000000000', 'seed_obj_script_000000000000000', 'Notes', 'richtext', false, 6);

INSERT INTO entries (id, object_id) VALUES
  ('seed_ent_script_up_0000000000000', 'seed_obj_script_000000000000000');

INSERT INTO entry_fields (entry_id, field_id, value) VALUES
  ('seed_ent_script_up_0000000000000', 'seed_fld_script_title_000000000', 'Up'),
  ('seed_ent_script_up_0000000000000', 'seed_fld_script_writer_00000000', 'Pete Docter & Bob Peterson'),
  ('seed_ent_script_up_0000000000000', 'seed_fld_script_genre_000000000', 'Animation'),
  ('seed_ent_script_up_0000000000000', 'seed_fld_script_status_00000000', 'Production'),
  ('seed_ent_script_up_0000000000000', 'seed_fld_script_format_00000000', 'Feature Film'),
  ('seed_ent_script_up_0000000000000', 'seed_fld_script_pages_000000000', '109'),
  ('seed_ent_script_up_0000000000000', 'seed_fld_script_notes_000000000', 'Pixar / Walt Disney Pictures. 2009 Academy Award winner for Best Animated Feature and Best Original Score.');

INSERT INTO documents (id, title, icon, file_path, parent_object_id, sort_order)
VALUES ('seed_doc_up_script_000000000000', 'Up — Script', 'file-text', 'script/up.md',
        'seed_obj_script_000000000000000', 0);

CREATE OR REPLACE VIEW v_script AS
PIVOT (
  SELECT e.id as entry_id, e.created_at, e.updated_at,
         f.name as field_name, ef.value
  FROM entries e
  JOIN entry_fields ef ON ef.entry_id = e.id
  JOIN fields f ON f.id = ef.field_id
  WHERE e.object_id = 'seed_obj_script_000000000000000'
) ON field_name IN ('Title', 'Writer', 'Genre', 'Status', 'Format', 'Pages', 'Notes') USING first(value);

-- ── Seed: shot ──

INSERT INTO objects (id, name, description, icon, default_view, sort_order)
VALUES ('seed_obj_shot_0000000000000000', 'shot', 'Shot list', 'camera', 'table', 4);

INSERT INTO fields (id, object_id, name, type, required, sort_order) VALUES
  ('seed_fld_shot_shotnum_000000000', 'seed_obj_shot_0000000000000000', 'Shot #', 'text', true, 0),
  ('seed_fld_shot_scenenum_00000000', 'seed_obj_shot_0000000000000000', 'Scene #', 'text', false, 1),
  ('seed_fld_shot_location_00000000', 'seed_obj_shot_0000000000000000', 'Location', 'text', false, 2);

INSERT INTO fields (id, object_id, name, type, required, enum_values, enum_colors, sort_order) VALUES
  ('seed_fld_shot_intext_000000000', 'seed_obj_shot_0000000000000000', 'INT/EXT', 'enum', false,
   '["INT","EXT","INT/EXT"]'::JSON,
   '["#3b82f6","#22c55e","#f59e0b"]'::JSON, 3),
  ('seed_fld_shot_timeofday_0000000', 'seed_obj_shot_0000000000000000', 'Time of Day', 'enum', false,
   '["Day","Night","Morning","Evening","Continuous"]'::JSON,
   '["#f59e0b","#3b82f6","#06b6d4","#8b5cf6","#94a3b8"]'::JSON, 4),
  ('seed_fld_shot_type_000000000000', 'seed_obj_shot_0000000000000000', 'Shot Type', 'enum', false,
   '["Establishing","Wide","Medium","Close-Up","Extreme Close-Up","POV","Two-Shot","Over-the-Shoulder","Insert"]'::JSON,
   '["#6366f1","#3b82f6","#06b6d4","#22c55e","#ef4444","#f59e0b","#8b5cf6","#94a3b8","#64748b"]'::JSON, 5),
  ('seed_fld_shot_status_000000000', 'seed_obj_shot_0000000000000000', 'Status', 'enum', false,
   '["Not Started","In Progress","Complete","Hold"]'::JSON,
   '["#94a3b8","#3b82f6","#22c55e","#f59e0b"]'::JSON, 7);

INSERT INTO fields (id, object_id, name, type, required, sort_order) VALUES
  ('seed_fld_shot_desc_000000000000', 'seed_obj_shot_0000000000000000', 'Description', 'text', false, 6),
  ('seed_fld_shot_chars_00000000000', 'seed_obj_shot_0000000000000000', 'Characters', 'tags', false, 8),
  ('seed_fld_shot_notes_00000000000', 'seed_obj_shot_0000000000000000', 'Notes', 'richtext', false, 9);

INSERT INTO statuses (id, object_id, name, color, sort_order, is_default) VALUES
  ('seed_sts_shot_notstart_0000000', 'seed_obj_shot_0000000000000000', 'Not Started', '#94a3b8', 0, true),
  ('seed_sts_shot_inprog_000000000', 'seed_obj_shot_0000000000000000', 'In Progress', '#3b82f6', 1, false),
  ('seed_sts_shot_complete_00000000', 'seed_obj_shot_0000000000000000', 'Complete', '#22c55e', 2, false),
  ('seed_sts_shot_hold_000000000000', 'seed_obj_shot_0000000000000000', 'Hold', '#f59e0b', 3, false);

-- Shot entries (20 shots from Up — Act I)
INSERT INTO entries (id, object_id) VALUES
  ('seed_ent_shot_001_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_002_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_003_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_004_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_005_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_006_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_007_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_008_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_009_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_010_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_011_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_012_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_013_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_014_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_015_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_016_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_017_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_018_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_019_000000000000', 'seed_obj_shot_0000000000000000'),
  ('seed_ent_shot_020_000000000000', 'seed_obj_shot_0000000000000000');

INSERT INTO entry_fields (entry_id, field_id, value) VALUES
  -- Shot 001
  ('seed_ent_shot_001_000000000000', 'seed_fld_shot_shotnum_000000000', '001'),
  ('seed_ent_shot_001_000000000000', 'seed_fld_shot_scenenum_00000000', '1'),
  ('seed_ent_shot_001_000000000000', 'seed_fld_shot_location_00000000', 'Movie Theatre'),
  ('seed_ent_shot_001_000000000000', 'seed_fld_shot_intext_000000000', 'INT'),
  ('seed_ent_shot_001_000000000000', 'seed_fld_shot_timeofday_0000000', 'Continuous'),
  ('seed_ent_shot_001_000000000000', 'seed_fld_shot_type_000000000000', 'Establishing'),
  ('seed_ent_shot_001_000000000000', 'seed_fld_shot_desc_000000000000', 'Wide establishing shot of the packed 1930s movie theatre. A newsreel plays on the silver screen.'),
  ('seed_ent_shot_001_000000000000', 'seed_fld_shot_chars_00000000000', '["Young Carl"]'),
  ('seed_ent_shot_001_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 002
  ('seed_ent_shot_002_000000000000', 'seed_fld_shot_shotnum_000000000', '002'),
  ('seed_ent_shot_002_000000000000', 'seed_fld_shot_scenenum_00000000', '1'),
  ('seed_ent_shot_002_000000000000', 'seed_fld_shot_location_00000000', 'Movie Theatre'),
  ('seed_ent_shot_002_000000000000', 'seed_fld_shot_intext_000000000', 'INT'),
  ('seed_ent_shot_002_000000000000', 'seed_fld_shot_timeofday_0000000', 'Continuous'),
  ('seed_ent_shot_002_000000000000', 'seed_fld_shot_type_000000000000', 'Close-Up'),
  ('seed_ent_shot_002_000000000000', 'seed_fld_shot_desc_000000000000', 'Close-up on Young Carl''s face — mouth agape, eyes wide — wearing leather flight helmet and goggles.'),
  ('seed_ent_shot_002_000000000000', 'seed_fld_shot_chars_00000000000', '["Young Carl"]'),
  ('seed_ent_shot_002_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 003
  ('seed_ent_shot_003_000000000000', 'seed_fld_shot_shotnum_000000000', '003'),
  ('seed_ent_shot_003_000000000000', 'seed_fld_shot_scenenum_00000000', '2'),
  ('seed_ent_shot_003_000000000000', 'seed_fld_shot_location_00000000', 'Small Town Neighborhood'),
  ('seed_ent_shot_003_000000000000', 'seed_fld_shot_intext_000000000', 'EXT'),
  ('seed_ent_shot_003_000000000000', 'seed_fld_shot_timeofday_0000000', 'Day'),
  ('seed_ent_shot_003_000000000000', 'seed_fld_shot_type_000000000000', 'Wide'),
  ('seed_ent_shot_003_000000000000', 'seed_fld_shot_desc_000000000000', 'Young Carl runs along the sidewalk, "flying" his blue Spirit of Adventure balloon. Title cards play over.'),
  ('seed_ent_shot_003_000000000000', 'seed_fld_shot_chars_00000000000', '["Young Carl"]'),
  ('seed_ent_shot_003_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 004
  ('seed_ent_shot_004_000000000000', 'seed_fld_shot_shotnum_000000000', '004'),
  ('seed_ent_shot_004_000000000000', 'seed_fld_shot_scenenum_00000000', '4'),
  ('seed_ent_shot_004_000000000000', 'seed_fld_shot_location_00000000', 'Dilapidated House — Living Room'),
  ('seed_ent_shot_004_000000000000', 'seed_fld_shot_intext_000000000', 'INT'),
  ('seed_ent_shot_004_000000000000', 'seed_fld_shot_timeofday_0000000', 'Continuous'),
  ('seed_ent_shot_004_000000000000', 'seed_fld_shot_type_000000000000', 'Medium'),
  ('seed_ent_shot_004_000000000000', 'seed_fld_shot_desc_000000000000', 'Young Ellie steers her makeshift dirigible cockpit. The rusty bicycle wheel. Coke-bottle binoculars.'),
  ('seed_ent_shot_004_000000000000', 'seed_fld_shot_chars_00000000000', '["Young Ellie"]'),
  ('seed_ent_shot_004_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 005
  ('seed_ent_shot_005_000000000000', 'seed_fld_shot_shotnum_000000000', '005'),
  ('seed_ent_shot_005_000000000000', 'seed_fld_shot_scenenum_00000000', '4'),
  ('seed_ent_shot_005_000000000000', 'seed_fld_shot_location_00000000', 'Dilapidated House — Living Room'),
  ('seed_ent_shot_005_000000000000', 'seed_fld_shot_intext_000000000', 'INT'),
  ('seed_ent_shot_005_000000000000', 'seed_fld_shot_timeofday_0000000', 'Continuous'),
  ('seed_ent_shot_005_000000000000', 'seed_fld_shot_type_000000000000', 'Two-Shot'),
  ('seed_ent_shot_005_000000000000', 'seed_fld_shot_desc_000000000000', 'Ellie removes the grape soda cap pin from her shirt and pins it on Carl. The moment they become a club.'),
  ('seed_ent_shot_005_000000000000', 'seed_fld_shot_chars_00000000000', '["Young Carl","Young Ellie"]'),
  ('seed_ent_shot_005_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 006
  ('seed_ent_shot_006_000000000000', 'seed_fld_shot_shotnum_000000000', '006'),
  ('seed_ent_shot_006_000000000000', 'seed_fld_shot_scenenum_00000000', '5'),
  ('seed_ent_shot_006_000000000000', 'seed_fld_shot_location_00000000', 'Dilapidated House — Upstairs'),
  ('seed_ent_shot_006_000000000000', 'seed_fld_shot_intext_000000000', 'INT'),
  ('seed_ent_shot_006_000000000000', 'seed_fld_shot_timeofday_0000000', 'Continuous'),
  ('seed_ent_shot_006_000000000000', 'seed_fld_shot_type_000000000000', 'Wide'),
  ('seed_ent_shot_006_000000000000', 'seed_fld_shot_desc_000000000000', 'Carl inches across the single rickety beam toward his floating blue balloon — and falls through the floor.'),
  ('seed_ent_shot_006_000000000000', 'seed_fld_shot_chars_00000000000', '["Young Carl","Young Ellie"]'),
  ('seed_ent_shot_006_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 007
  ('seed_ent_shot_007_000000000000', 'seed_fld_shot_shotnum_000000000', '007'),
  ('seed_ent_shot_007_000000000000', 'seed_fld_shot_scenenum_00000000', '9'),
  ('seed_ent_shot_007_000000000000', 'seed_fld_shot_location_00000000', 'Carl''s Room'),
  ('seed_ent_shot_007_000000000000', 'seed_fld_shot_intext_000000000', 'INT'),
  ('seed_ent_shot_007_000000000000', 'seed_fld_shot_timeofday_0000000', 'Night'),
  ('seed_ent_shot_007_000000000000', 'seed_fld_shot_type_000000000000', 'Two-Shot'),
  ('seed_ent_shot_007_000000000000', 'seed_fld_shot_desc_000000000000', 'Carl and Ellie huddle under a blanket tent with a flashlight. Ellie reveals her Adventure Book.'),
  ('seed_ent_shot_007_000000000000', 'seed_fld_shot_chars_00000000000', '["Young Carl","Young Ellie"]'),
  ('seed_ent_shot_007_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 008
  ('seed_ent_shot_008_000000000000', 'seed_fld_shot_shotnum_000000000', '008'),
  ('seed_ent_shot_008_000000000000', 'seed_fld_shot_scenenum_00000000', '10'),
  ('seed_ent_shot_008_000000000000', 'seed_fld_shot_location_00000000', 'Church'),
  ('seed_ent_shot_008_000000000000', 'seed_fld_shot_intext_000000000', 'INT'),
  ('seed_ent_shot_008_000000000000', 'seed_fld_shot_timeofday_0000000', 'Day'),
  ('seed_ent_shot_008_000000000000', 'seed_fld_shot_type_000000000000', 'Wide'),
  ('seed_ent_shot_008_000000000000', 'seed_fld_shot_desc_000000000000', 'Carl and Ellie''s wedding. Her side of the church erupts; his side claps politely. She jumps and kisses him.'),
  ('seed_ent_shot_008_000000000000', 'seed_fld_shot_chars_00000000000', '["Carl Fredricksen","Ellie"]'),
  ('seed_ent_shot_008_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 009
  ('seed_ent_shot_009_000000000000', 'seed_fld_shot_shotnum_000000000', '009'),
  ('seed_ent_shot_009_000000000000', 'seed_fld_shot_scenenum_00000000', '16'),
  ('seed_ent_shot_009_000000000000', 'seed_fld_shot_location_00000000', 'Rural Hillside'),
  ('seed_ent_shot_009_000000000000', 'seed_fld_shot_intext_000000000', 'EXT'),
  ('seed_ent_shot_009_000000000000', 'seed_fld_shot_timeofday_0000000', 'Day'),
  ('seed_ent_shot_009_000000000000', 'seed_fld_shot_type_000000000000', 'Wide'),
  ('seed_ent_shot_009_000000000000', 'seed_fld_shot_desc_000000000000', 'Carl and Ellie lie side by side on a picnic blanket, watching clouds. He closes his eyes, smiling. He''s lucky.'),
  ('seed_ent_shot_009_000000000000', 'seed_fld_shot_chars_00000000000', '["Carl Fredricksen","Ellie"]'),
  ('seed_ent_shot_009_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 010
  ('seed_ent_shot_010_000000000000', 'seed_fld_shot_shotnum_000000000', '010'),
  ('seed_ent_shot_010_000000000000', 'seed_fld_shot_scenenum_00000000', '25'),
  ('seed_ent_shot_010_000000000000', 'seed_fld_shot_location_00000000', 'Carl & Ellie''s House — Living Room'),
  ('seed_ent_shot_010_000000000000', 'seed_fld_shot_intext_000000000', 'INT'),
  ('seed_ent_shot_010_000000000000', 'seed_fld_shot_timeofday_0000000', 'Continuous'),
  ('seed_ent_shot_010_000000000000', 'seed_fld_shot_type_000000000000', 'Insert'),
  ('seed_ent_shot_010_000000000000', 'seed_fld_shot_desc_000000000000', 'Insert: the Paradise Falls jar, slowly filling with coins over the years — then smashed again and again.'),
  ('seed_ent_shot_010_000000000000', 'seed_fld_shot_chars_00000000000', '[]'),
  ('seed_ent_shot_010_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 011
  ('seed_ent_shot_011_000000000000', 'seed_fld_shot_shotnum_000000000', '011'),
  ('seed_ent_shot_011_000000000000', 'seed_fld_shot_scenenum_00000000', '29'),
  ('seed_ent_shot_011_000000000000', 'seed_fld_shot_location_00000000', 'Zoo'),
  ('seed_ent_shot_011_000000000000', 'seed_fld_shot_intext_000000000', 'EXT'),
  ('seed_ent_shot_011_000000000000', 'seed_fld_shot_timeofday_0000000', 'Day'),
  ('seed_ent_shot_011_000000000000', 'seed_fld_shot_type_000000000000', 'Wide'),
  ('seed_ent_shot_011_000000000000', 'seed_fld_shot_desc_000000000000', 'Carl and Ellie in their 60s, still working happily side by side at the zoo. His balloon cart floats up.'),
  ('seed_ent_shot_011_000000000000', 'seed_fld_shot_chars_00000000000', '["Carl Fredricksen","Ellie"]'),
  ('seed_ent_shot_011_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 012
  ('seed_ent_shot_012_000000000000', 'seed_fld_shot_shotnum_000000000', '012'),
  ('seed_ent_shot_012_000000000000', 'seed_fld_shot_scenenum_00000000', '34'),
  ('seed_ent_shot_012_000000000000', 'seed_fld_shot_location_00000000', 'Rural Hillside'),
  ('seed_ent_shot_012_000000000000', 'seed_fld_shot_intext_000000000', 'EXT'),
  ('seed_ent_shot_012_000000000000', 'seed_fld_shot_timeofday_0000000', 'Afternoon'),
  ('seed_ent_shot_012_000000000000', 'seed_fld_shot_type_000000000000', 'Medium'),
  ('seed_ent_shot_012_000000000000', 'seed_fld_shot_desc_000000000000', 'Carl hurries up picnic hill, hiding airline tickets in his basket. Ellie falters — and falls. He runs to her.'),
  ('seed_ent_shot_012_000000000000', 'seed_fld_shot_chars_00000000000', '["Carl Fredricksen","Ellie"]'),
  ('seed_ent_shot_012_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 013
  ('seed_ent_shot_013_000000000000', 'seed_fld_shot_shotnum_000000000', '013'),
  ('seed_ent_shot_013_000000000000', 'seed_fld_shot_scenenum_00000000', '35'),
  ('seed_ent_shot_013_000000000000', 'seed_fld_shot_location_00000000', 'Hospital Room'),
  ('seed_ent_shot_013_000000000000', 'seed_fld_shot_intext_000000000', 'INT'),
  ('seed_ent_shot_013_000000000000', 'seed_fld_shot_timeofday_0000000', 'Day'),
  ('seed_ent_shot_013_000000000000', 'seed_fld_shot_type_000000000000', 'Medium'),
  ('seed_ent_shot_013_000000000000', 'seed_fld_shot_desc_000000000000', 'Ellie in the hospital bed looks through her Adventure Book. A blue balloon floats in. Carl stands at the door.'),
  ('seed_ent_shot_013_000000000000', 'seed_fld_shot_chars_00000000000', '["Carl Fredricksen","Ellie"]'),
  ('seed_ent_shot_013_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 014
  ('seed_ent_shot_014_000000000000', 'seed_fld_shot_shotnum_000000000', '014'),
  ('seed_ent_shot_014_000000000000', 'seed_fld_shot_scenenum_00000000', '36'),
  ('seed_ent_shot_014_000000000000', 'seed_fld_shot_location_00000000', 'Church'),
  ('seed_ent_shot_014_000000000000', 'seed_fld_shot_intext_000000000', 'INT'),
  ('seed_ent_shot_014_000000000000', 'seed_fld_shot_timeofday_0000000', 'Afternoon'),
  ('seed_ent_shot_014_000000000000', 'seed_fld_shot_type_000000000000', 'Wide'),
  ('seed_ent_shot_014_000000000000', 'seed_fld_shot_desc_000000000000', 'Carl sits alone in the church pews next to a massive bouquet of balloons. Silence.'),
  ('seed_ent_shot_014_000000000000', 'seed_fld_shot_chars_00000000000', '["Carl Fredricksen"]'),
  ('seed_ent_shot_014_000000000000', 'seed_fld_shot_status_000000000', 'Complete'),
  -- Shot 015
  ('seed_ent_shot_015_000000000000', 'seed_fld_shot_shotnum_000000000', '015'),
  ('seed_ent_shot_015_000000000000', 'seed_fld_shot_scenenum_00000000', '38'),
  ('seed_ent_shot_015_000000000000', 'seed_fld_shot_location_00000000', 'Carl''s Bedroom'),
  ('seed_ent_shot_015_000000000000', 'seed_fld_shot_intext_000000000', 'INT'),
  ('seed_ent_shot_015_000000000000', 'seed_fld_shot_timeofday_0000000', 'Morning'),
  ('seed_ent_shot_015_000000000000', 'seed_fld_shot_type_000000000000', 'Wide'),
  ('seed_ent_shot_015_000000000000', 'seed_fld_shot_desc_000000000000', 'Carl wakes alone in the double bed, several years later. The room is still and silent.'),
  ('seed_ent_shot_015_000000000000', 'seed_fld_shot_chars_00000000000', '["Carl Fredricksen"]'),
  ('seed_ent_shot_015_000000000000', 'seed_fld_shot_status_000000000', 'In Progress'),
  -- Shot 016
  ('seed_ent_shot_016_000000000000', 'seed_fld_shot_shotnum_000000000', '016'),
  ('seed_ent_shot_016_000000000000', 'seed_fld_shot_scenenum_00000000', '45'),
  ('seed_ent_shot_016_000000000000', 'seed_fld_shot_location_00000000', 'Carl''s Neighborhood'),
  ('seed_ent_shot_016_000000000000', 'seed_fld_shot_intext_000000000', 'EXT'),
  ('seed_ent_shot_016_000000000000', 'seed_fld_shot_timeofday_0000000', 'Day'),
  ('seed_ent_shot_016_000000000000', 'seed_fld_shot_type_000000000000', 'Establishing'),
  ('seed_ent_shot_016_000000000000', 'seed_fld_shot_desc_000000000000', 'Carl''s house — the lone surviving square on the block, surrounded by cranes and high-rise construction.'),
  ('seed_ent_shot_016_000000000000', 'seed_fld_shot_chars_00000000000', '["Carl Fredricksen"]'),
  ('seed_ent_shot_016_000000000000', 'seed_fld_shot_status_000000000', 'In Progress'),
  -- Shot 017
  ('seed_ent_shot_017_000000000000', 'seed_fld_shot_shotnum_000000000', '017'),
  ('seed_ent_shot_017_000000000000', 'seed_fld_shot_scenenum_00000000', '48'),
  ('seed_ent_shot_017_000000000000', 'seed_fld_shot_location_00000000', 'Carl''s House — Porch'),
  ('seed_ent_shot_017_000000000000', 'seed_fld_shot_intext_000000000', 'EXT'),
  ('seed_ent_shot_017_000000000000', 'seed_fld_shot_timeofday_0000000', 'Day'),
  ('seed_ent_shot_017_000000000000', 'seed_fld_shot_type_000000000000', 'Medium'),
  ('seed_ent_shot_017_000000000000', 'seed_fld_shot_desc_000000000000', 'Russell stands at the door reading from his Wilderness Explorer Manual. Enormous backpack. Carl in doorway.'),
  ('seed_ent_shot_017_000000000000', 'seed_fld_shot_chars_00000000000', '["Carl Fredricksen","Russell"]'),
  ('seed_ent_shot_017_000000000000', 'seed_fld_shot_status_000000000', 'In Progress'),
  -- Shot 018
  ('seed_ent_shot_018_000000000000', 'seed_fld_shot_shotnum_000000000', '018'),
  ('seed_ent_shot_018_000000000000', 'seed_fld_shot_scenenum_00000000', '59'),
  ('seed_ent_shot_018_000000000000', 'seed_fld_shot_location_00000000', 'Carl''s House'),
  ('seed_ent_shot_018_000000000000', 'seed_fld_shot_intext_000000000', 'EXT'),
  ('seed_ent_shot_018_000000000000', 'seed_fld_shot_timeofday_0000000', 'Morning'),
  ('seed_ent_shot_018_000000000000', 'seed_fld_shot_type_000000000000', 'Wide'),
  ('seed_ent_shot_018_000000000000', 'seed_fld_shot_desc_000000000000', 'Thousands of balloons burst through the roof and windows of the house. It groans, shudders — and lifts off.'),
  ('seed_ent_shot_018_000000000000', 'seed_fld_shot_chars_00000000000', '["Carl Fredricksen"]'),
  ('seed_ent_shot_018_000000000000', 'seed_fld_shot_status_000000000', 'Not Started'),
  -- Shot 019
  ('seed_ent_shot_019_000000000000', 'seed_fld_shot_shotnum_000000000', '019'),
  ('seed_ent_shot_019_000000000000', 'seed_fld_shot_scenenum_00000000', '60'),
  ('seed_ent_shot_019_000000000000', 'seed_fld_shot_location_00000000', 'Above the Town'),
  ('seed_ent_shot_019_000000000000', 'seed_fld_shot_intext_000000000', 'EXT'),
  ('seed_ent_shot_019_000000000000', 'seed_fld_shot_timeofday_0000000', 'Morning'),
  ('seed_ent_shot_019_000000000000', 'seed_fld_shot_type_000000000000', 'Wide'),
  ('seed_ent_shot_019_000000000000', 'seed_fld_shot_desc_000000000000', 'Carl''s house floats free above the city, trailing a magnificent column of colorful balloons into a clear sky.'),
  ('seed_ent_shot_019_000000000000', 'seed_fld_shot_chars_00000000000', '["Carl Fredricksen","Russell"]'),
  ('seed_ent_shot_019_000000000000', 'seed_fld_shot_status_000000000', 'Not Started'),
  -- Shot 020
  ('seed_ent_shot_020_000000000000', 'seed_fld_shot_shotnum_000000000', '020'),
  ('seed_ent_shot_020_000000000000', 'seed_fld_shot_scenenum_00000000', '1'),
  ('seed_ent_shot_020_000000000000', 'seed_fld_shot_location_00000000', 'Paradise Falls — South America'),
  ('seed_ent_shot_020_000000000000', 'seed_fld_shot_intext_000000000', 'EXT'),
  ('seed_ent_shot_020_000000000000', 'seed_fld_shot_timeofday_0000000', 'Day'),
  ('seed_ent_shot_020_000000000000', 'seed_fld_shot_type_000000000000', 'Establishing'),
  ('seed_ent_shot_020_000000000000', 'seed_fld_shot_desc_000000000000', 'The majestic Paradise Falls: a massive waterfall cascading down a gigantic flat-topped mountain in jungle. Newsreel footage.'),
  ('seed_ent_shot_020_000000000000', 'seed_fld_shot_chars_00000000000', '[]'),
  ('seed_ent_shot_020_000000000000', 'seed_fld_shot_status_000000000', 'Not Started');

CREATE OR REPLACE VIEW v_shot AS
PIVOT (
  SELECT e.id as entry_id, e.created_at, e.updated_at,
         f.name as field_name, ef.value
  FROM entries e
  JOIN entry_fields ef ON ef.entry_id = e.id
  JOIN fields f ON f.id = ef.field_id
  WHERE e.object_id = 'seed_obj_shot_0000000000000000'
) ON field_name IN ('Shot #', 'Scene #', 'Location', 'INT/EXT', 'Time of Day', 'Shot Type', 'Description', 'Characters', 'Status', 'Notes') USING first(value);
