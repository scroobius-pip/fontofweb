CREATE TABLE "designer" (
  "id" integer PRIMARY KEY,
  "name" text,
  "url" text,
  UNIQUE("name", "url")
);

CREATE TABLE "manufacturer" (
  "id" integer PRIMARY KEY,
  "name" text,
  "url" text,
  UNIQUE("name", "url")
);

CREATE TABLE "family" (
  "id" integer PRIMARY KEY,
  "name" text UNIQUE,
  "designer_id" integer,
  "manufacturer_id" integer,
  "created_at" integer,
  "updated_at" integer,
  UNIQUE("name", "designer_id", "manufacturer_id"),
  FOREIGN KEY ("designer_id") REFERENCES "designer" ("id"),
  FOREIGN KEY ("manufacturer_id") REFERENCES "manufacturer" ("id")
);

CREATE TABLE "sub_family" (
  "id" integer PRIMARY KEY,
  "family_id" integer NOT NULL,
  "name" text NOT NULL,
  "created_at" integer,
  "updated_at" integer,
  UNIQUE("family_id", "name"),
  FOREIGN KEY ("family_id") REFERENCES "family" ("id")
);

CREATE TABLE "sub_family_version" (
  "sub_family_id" integer NOT NULL,
  "version" float NOT NULL,
  "src" text,
  UNIQUE("sub_family_id", "version"),
  FOREIGN KEY ("sub_family_id") REFERENCES "sub_family" ("id")
);

CREATE TABLE "usage_detail" (
  "id" integer PRIMARY KEY,
  "weight" integer,
  "line_height" float,
  "size" float,
  UNIQUE("weight", "line_height", "size")
);

CREATE TABLE "element" (
  "id" integer PRIMARY KEY,
  "name" text UNIQUE
);

CREATE TABLE "usage" (
  "id" integer PRIMARY KEY,
  "element_id" integer,
  "sub_family_id" integer,
  "usage_detail_id" integer,
  UNIQUE("element_id", "sub_family_id", "usage_detail_id"),
  FOREIGN KEY ("element_id") REFERENCES "element" ("id"),
  FOREIGN KEY ("sub_family_id") REFERENCES "sub_family" ("id"),
  FOREIGN KEY ("usage_detail_id") REFERENCES "usage_detail" ("id")
);

CREATE TABLE "domain" (
  "id" integer PRIMARY KEY,
  "url" text UNIQUE
);

CREATE TABLE "path" (
  "id" integer PRIMARY KEY,
  "name" text,
  "domain_id" integer,
  UNIQUE("domain_id", "name"),
  FOREIGN KEY ("domain_id") REFERENCES "domain" ("id")
);

CREATE TABLE "page" (
  "id" integer PRIMARY KEY,
  "path_id" integer,
  "screenshot_count" integer,
  "created_at" integer NOT NULL,
  "updated_at" integer NOT NULL,
  FOREIGN KEY ("path_id") REFERENCES "path" ("id")
);

CREATE TABLE "page_history" (
  "id" integer PRIMARY KEY,
  "page_id" integer,
  "screenshot_count" integer,
  "created_at" integer,  -- when it was added to page table
  "archived_at" integer, -- when it was added to page_history table
  UNIQUE("page_id", "created_at"),
  FOREIGN KEY ("page_id") REFERENCES "page" ("id")
);

CREATE TABLE "page_usage" (
  "page_id" integer,
  "usage_id" integer,
  FOREIGN KEY ("page_id") REFERENCES "page" ("id"),
  FOREIGN KEY ("usage_id") REFERENCES "usage" ("id")
);

CREATE TABLE "page_history_usage" (
  "page_history_id" integer,
  "usage_id" integer,
  FOREIGN KEY ("page_history_id") REFERENCES "page_history" ("id"),
  FOREIGN KEY ("usage_id") REFERENCES "usage" ("id")
);

CREATE TABLE "user" (
  "id" integer PRIMARY KEY NOT NULL,
  "email" text UNIQUE NOT NULL,
  "created_at" integer NOT NULL,
  "updated_at" integer
);

CREATE TABLE "bookmark" (
  "user_id" integer NOT NULL,
  "page_id" integer,
  "page_created_at" integer, -- if null, use the latest in the page table, else go to page_history
  "collection_name" text,
  "created_at" integer NOT NULL,
  UNIQUE("user_id", "page_id", "collection_name"),
  FOREIGN KEY ("user_id") REFERENCES "user" ("id"),
  FOREIGN KEY ("page_id") REFERENCES "page" ("id"),
  FOREIGN KEY ("page_id", "page_created_at") REFERENCES "page_history" ("page_id", "created_at")
);