-- Таблица договоров
CREATE TABLE "Contracts"(
    "ID" SERIAL PRIMARY KEY,
    "Type" BIGINT NOT NULL,
    "Name" VARCHAR(250) NOT NULL,
    "ConclDate" DATE NOT NULL,
    "RegistrDate" DATE NOT NULL,
    "Notes" VARCHAR(2500),
    "StartDate" DATE NOT NULL,
    "FinishDate" DATE NOT NULL
);

-- Таблица для типов договоров
CREATE TABLE "ContractTypes"(
    "ID" SERIAL PRIMARY KEY,
    "Name" VARCHAR(255) NOT NULL
);

-- Таблица сторон договора
CREATE TABLE "Sides"(
    "ID" SERIAL PRIMARY KEY,
    "ContractType" BIGINT NOT NULL,
    "Name" VARCHAR(50) NOT NULL,
    "Obligations" VARCHAR(2500) NOT NULL
);

-- Таблица статусов договора
CREATE TABLE "Status"(
    "ID" SERIAL PRIMARY KEY,
    "Contract" BIGINT NOT NULL,
    "Type" BIGINT NOT NULL,
    "Date" DATE NOT NULL
);

-- Таблица для определения типов статуса договора
CREATE TABLE "StatusTypes"(
    "ID" SERIAL PRIMARY KEY,
    "Name" VARCHAR(50) NOT NULL
);

-- Таблица контрагентов
CREATE TABLE "Contractors"(
    "ID" SERIAL PRIMARY KEY,
    "Contract" BIGINT NOT NULL,
    "Side" BIGINT NOT NULL,
    "Name" VARCHAR(250) NOT NULL,
    "Bank" VARCHAR(9) NOT NULL,
    "CurrAccount" VARCHAR(20) NOT NULL
);

-- Таблица ответственных лиц
CREATE TABLE "Responsibles"(
    "ID" SERIAL PRIMARY KEY,
    "Contract" BIGINT NOT NULL,
    "Contractor" BIGINT NOT NULL,
    "Name" VARCHAR(100) NOT NULL,
    "Type" BIGINT NOT NULL,
    "Notes" VARCHAR(2500),
    "StartDate" DATE NOT NULL,
    "FinishDate" DATE NOT NULL
);

-- Таблица типов ответственности
CREATE TABLE "ResponsibilityTypes"(
    "ID" SERIAL PRIMARY KEY,
    "Name" VARCHAR(2500) NOT NULL
);


-- Часть кода с определением связей между созданными таблицами
ALTER TABLE
    "Status" ADD CONSTRAINT "status_which_contract" FOREIGN KEY("Contract") REFERENCES "Contracts"("ID") ON DELETE CASCADE;
ALTER TABLE
    "Contractors" ADD CONSTRAINT "contrs_side" FOREIGN KEY("Side") REFERENCES "Sides"("ID") ON DELETE CASCADE;
ALTER TABLE
    "Status" ADD CONSTRAINT "stype" FOREIGN KEY("Type") REFERENCES "StatusTypes"("ID") ON DELETE CASCADE;
ALTER TABLE
    "Contractors" ADD CONSTRAINT "contrs_which_contract" FOREIGN KEY("Contract") REFERENCES "Contracts"("ID") ON DELETE CASCADE;
ALTER TABLE
    "Responsibles" ADD CONSTRAINT "resp_which_contract" FOREIGN KEY("Contract") REFERENCES "Contracts"("ID") ON DELETE CASCADE;
ALTER TABLE
    "Sides" ADD CONSTRAINT "ctype_for_side" FOREIGN KEY("ContractType") REFERENCES "ContractTypes"("ID") ON DELETE CASCADE;
ALTER TABLE
    "Responsibles" ADD CONSTRAINT "rtype" FOREIGN KEY("Type") REFERENCES "ResponsibilityTypes"("ID") ON DELETE CASCADE;
ALTER TABLE
    "Responsibles" ADD CONSTRAINT "resp_which_contrs" FOREIGN KEY("Contractor") REFERENCES "Contractors"("ID") ON DELETE CASCADE;
ALTER TABLE
    "Contracts" ADD CONSTRAINT "ctype" FOREIGN KEY("Type") REFERENCES "ContractTypes"("ID") ON DELETE CASCADE;

-- Определение типа договора
INSERT INTO "ContractTypes" ("Name") VALUES ('Договор о сотрудничестве');

-- Заполнение данных о договоре
INSERT INTO "Contracts" ("Type", "Name", "ConclDate", "RegistrDate", "Notes", "StartDate", "FinishDate") VALUES 
((SELECT "ID" FROM "ContractTypes" WHERE "Name"='Договор о сотрудничестве'),
'Договор о сотрудничестве между Центром недвижимости от Сбербанка и Российской Гильдией Риэлторов',
'2025-05-27', '2025-05-27', 'Обмен данными об ответственных лицах является одним из предметов договора, поэтому ответственные будут уточнены после заключения', '2025-05-27', '2025-12-31');

-- Заполнение данных о сторонах
INSERT INTO "Sides" ("ContractType", "Name", "Obligations") VALUES
((SELECT "ID" FROM "ContractTypes" WHERE "Name"='Договор о сотрудничестве'),
'Центр Недвижимости',
'2.1.1. Предоставить Гильдии, Коллективным членам Гильдии, Прямым членам Гильдии, на условиях простой неисключительной лицензии право использования результатов интеллектуальной деятельности, указанных в п. 1.4. и п. 1.5. Договора, а Гильдия обязуется использовать указанные результаты интеллектуальной деятельности только в пределах тех прав и теми способами, которые предусмотрены Договором. 2.1.2. Оказать Гильдии на возмездной основе услуги по размещению на Портале информации, предоставленной Гильдией и (или) лицами, указанными Гильдией, в том числе, информации рекламного характера. 2.1.3. Оказать Гильдии на возмездной основе услуги по технической и информационной поддержке при размещении (организации размещения) информации на Портале (п. 2.1.2. Договора).'),
((SELECT "ID" FROM "ContractTypes" WHERE "Name"='Договор о сотрудничестве'),
'Гильдия',
'2.2.1. Оказать Центру недвижимости на возмездной основе услуги рекламно-информационного характера по рекламированию (продвижению) Центра недвижимости (в том числе, услуг, оказываемых Центром недвижимости) на рынке, в том числе, среди Коллективных членов Гильдии, Прямых членов Гильдии и иных лиц. 2.2.2. Оказать Центру Недвижимости на возмездной основе услуги по размещению на официальном сайте Гильдии http://www.rgr.ru/ (далее – «Сайт Гильдии») информации, предоставленной Центром Недвижимости, в том числе, информации рекламного характера.');

-- Заполнение данных о контрагентах
INSERT INTO "Contractors"("Contract", "Side", "Name", "Bank", "CurrAccount") VALUES
((SELECT "ID" FROM "Contracts" WHERE "Name"='Договор о сотрудничестве между Центром недвижимости от Сбербанка и Российской Гильдией Риэлторов'),
(SELECT "ID" FROM "Sides" WHERE "Name"='Центр Недвижимости'),
'Общество с ограниченной ответственностью \"Центр Недвижимости от Сбербанка\"',
'044525225', '40702810900020000019'),
((SELECT "ID" FROM "Contracts" WHERE "Name"='Договор о сотрудничестве между Центром недвижимости от Сбербанка и Российской Гильдией Риэлторов'),
(SELECT "ID" FROM "Sides" WHERE "Name"='Гильдия'),
'Некоммерческое Партнерство \"Российская Гильдия Риэлторов\"',
'044525225', '40703810038130100275');

-- Определение статусов
INSERT INTO "StatusTypes"("Name") VALUES
('Идет согласование'), ('Подписан'), ('Отменен'), ('Выполнен'), ('Расторгнут');

-- Присвоение статуса договору
INSERT INTO "Status"("Contract", "Type", "Date") VALUES
((SELECT "ID" FROM "Contracts" WHERE "Name"='Договор о сотрудничестве между Центром недвижимости от Сбербанка и Российской Гильдией Риэлторов'),
(SELECT "ID" FROM "ContractTypes" WHERE "Name"='Договор о сотрудничестве'),
'2025-05-27');