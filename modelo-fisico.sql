CREATE TABLE "users" ("id" uuid,"email" varchar(255),"password" varchar(255) NOT NULL,PRIMARY KEY ("id"),CONSTRAINT "uni_users_email" UNIQUE ("email"))

CREATE INDEX IF NOT EXISTS "idx_users_email" ON "users" ("email")

CREATE TABLE "user_subscriptions" ("id" uuid,"user_id" uuid NOT NULL,"user_plan" text NOT NULL DEFAULT 'free',"is_subscription_active" boolean DEFAULT false,PRIMARY KEY ("id"),CONSTRAINT "fk_users_user_subscription" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE,CONSTRAINT "uni_user_subscriptions_user_id" UNIQUE ("user_id"))

CREATE INDEX IF NOT EXISTS "idx_user_subscriptions_user_id" ON "user_subscriptions" ("user_id")

CREATE TABLE "businesses" ("id" uuid,"user_id" uuid NOT NULL,"name" varchar(255) NOT NULL,"category" text NOT NULL,"subcategories" text[],"images_url" text[],PRIMARY KEY ("id"),CONSTRAINT "fk_users_business" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE)

CREATE INDEX IF NOT EXISTS "idx_businesses_category" ON "businesses" ("category")

CREATE INDEX IF NOT EXISTS "idx_businesses_user_id" ON "businesses" ("user_id")

CREATE TABLE "business_infos" ("id" uuid,"business_id" uuid NOT NULL,PRIMARY KEY ("id"),CONSTRAINT "fk_businesses_info" FOREIGN KEY ("business_id") REFERENCES "businesses"("id") ON DELETE CASCADE,CONSTRAINT "uni_business_infos_business_id" UNIQUE ("business_id"))

CREATE INDEX IF NOT EXISTS "idx_business_infos_business_id" ON "business_infos" ("business_id")

CREATE TABLE "business_addresses" ("id" uuid,"business_info_id" uuid NOT NULL,"street" varchar(255),"address_number" varchar(6),"complement" varchar(255),"city" varchar(127),"state" varchar(2),"cep" varchar(8),PRIMARY KEY ("id"),CONSTRAINT "fk_business_infos_address" FOREIGN KEY ("business_info_id") REFERENCES "business_infos"("id") ON DELETE CASCADE,CONSTRAINT "uni_business_addresses_business_info_id" UNIQUE ("business_info_id"))

CREATE INDEX IF NOT EXISTS "idx_business_addresses_business_info_id" ON "business_addresses" ("business_info_id")

CREATE TABLE "business_contacts" ("id" uuid,"business_info_id" uuid NOT NULL,"phone" varchar(14),"whatsapp" varchar(14),"contact_email" varchar(255),"website" varchar(255),PRIMARY KEY ("id"),CONSTRAINT "fk_business_infos_contact" FOREIGN KEY ("business_info_id") REFERENCES "business_infos"("id") ON DELETE CASCADE,CONSTRAINT "uni_business_contacts_business_info_id" UNIQUE ("business_info_id"))

CREATE INDEX IF NOT EXISTS "idx_business_contacts_business_info_id" ON "business_contacts" ("business_info_id")

CREATE TABLE "business_registration_data" ("id" uuid,"business_info_id" uuid NOT NULL,"cnpj" varchar(14) NOT NULL,PRIMARY KEY ("id"),CONSTRAINT "fk_business_infos_registration_data" FOREIGN KEY ("business_info_id") REFERENCES "business_infos"("id") ON DELETE CASCADE,CONSTRAINT "uni_business_registration_data_business_info_id" UNIQUE ("business_info_id"))

CREATE INDEX IF NOT EXISTS "idx_business_registration_data_business_info_id" ON "business_registration_data" ("business_info_id")

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'check_user_plan'
  ) THEN
    ALTER TABLE user_subscriptions
    ADD CONSTRAINT check_user_plan
    CHECK (user_plan IN ('free', 'basic', 'standard', 'business'));
  END IF;
END $$;
