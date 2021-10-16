drop view if exists mergedt;
drop table if exists exchanging_rates;
drop table if exists clients, cities,
	accounts,currencies,operations, registry;
create table cities(
			city_name varchar(20) primary key,
			population int not null
);

create table clients(
			surname varchar(20) not null,
			name varchar(20) not null,
			patronymic varchar(20) not null,
			locality varchar(30) not null,
			city_name varchar(20) not null,
			adress varchar(30) not null,
			client_id int primary key, 
			passport_id	varchar(10) unique,
			foreign key (city_name) references cities(city_name)
);

create table currencies(
			currency_type varchar(10) primary key,
			iso_symb char,
			iso_num	int not null
);

create table accounts(
			acc_id int primary key ,
			client_id int,
			currency_type varchar(10),
			opening_date date not null,
			available_amount numeric not null,
			foreign key(currency_type) references currencies(currency_type),
			foreign key(client_id) references clients(client_id)
);


create table operations(
			oper_type varchar(20) primary key,
			oper_sign char
);

create table registry(
			acc_id int ,
			oper_type varchar(20),
			oper_sum numeric not null,
			oper_date date not null,
			foreign key(oper_type) references operations(oper_type)
);

create table exchanging_rates(
			curr_out varchar(3) not null ,
			curr_in varchar(3) not null,
			coeff numeric not null,
			foreign key (curr_out) references currencies(currency_type) on delete cascade,
			foreign key (curr_in) references currencies(currency_type) on delete cascade,
			unique(curr_out, curr_in)
);

insert into currencies 
values
('RUB', '₽', 643),
('USD', '$', 840),
('EUR', '€', 978),
('GBP', '£', 826),
('CNY', '¥', 156);

insert into exchanging_rates
values 
('RUB', 'USD', 0.014),
('RUB', 'EUR',0.012),
('RUB', 'GBP',0.01),
('RUB', 'CNY',0.09),
('USD', 'RUB', 71.8577),
('USD', 'EUR',0.86),
('USD', 'GBP',0.73),
('USD', 'CNY',6.44),
('EUR', 'RUB',83.0028),
('EUR', 'USD',1.16),
('EUR', 'GBP',0.85),
('EUR', 'CNY',7.47),
('GBP', 'RUB', 97.85),
('GBP', 'USD', 1.37),
('GBP', 'EUR', 1.18),
('GBP', 'CNY', 8.83),
('CNY', 'RUB', 11.09),
('CNY', 'USD', 0.16),
('CNY', 'EUR', 0.13),
('CNY', 'GBP', 0.11);

insert into cities 
values
('Москва', 1430000),
('Смоленск', 11000),
('Ставрополь', 1400),
('Санкт-Петербург', 240003);

insert into clients 
values
('Зубенко','Михаил',  'Петрович','-',
 	'Москва', 'ул.Вороная д.10 кв.29', 1,'1232323323'),
('Дорин', 'Лев',  'Семёнович','Ставропольский край',
 	'Ставрополь', 'ул.Строителей д.25 кв.12', 2,'3041768562'),
('Брыльска', 'Барбара', 'Пшековна','-',
 	'Санкт-Петербург', 'ул.Строителей д.25 кв.12', 3,'9810672839');



insert into accounts 
values
(1,1,'RUB','20.08.2013',34012.),
(2,1,'USD','10.12.2012',5699.),
(3,3,'GBP','30.04.2005', 140000.),
(4,3,'GBP','30.04.2012', -1133242.),
(5,2, 'RUB', '02.01.2008',-130322.),
(6,2,'EUR', '04.02.2009',-19922.);


insert into operations 
values
('Списание', '-'),
('Зачисление', '+'),
('Открытие счёта', '0'),
('Закрытие счёта', '0');

insert into registry
values
(1,'Открытие счёта', 0, '20.08.2013'),
(1,'Зачисление', 34012, '20.08.2013'),
(2,'Открытие счёта', 0, '10.12.2012'),
(2,'Зачисление', 5699, '10.12.2012'),
(3,'Открытие счёта',0,'30.04.2005'),
(3,'Зачисление', 140000, '30.04.2005'),
(4,'Открытие счёта',0,'30.04.2012'),
(4,'Зачисление', 1, '30.04.2012'),
(4,'Списание', 1133243, '11.04.2016'),
(5,'Открытие счёта',0,'02.01.2008'),
(5,'Зачисление', 1, '02.01.2008'),
(5,'Списание', 130323, '10.11.2010'),
(6,'Открытие счёта',0,'04.02.2009'),
(6,'Зачисление', 1, '04.02.2009'),
(6,'Списание', 19923, '09.04.2012'),
(3,'Списание', 1203, '30.04.2019'),
(1,'Списание', 13231, '29.11.2018'),
(2,'Списание', 11, '15.07.2020')