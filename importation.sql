-- Ex 2:

drop table if exists import, games, athlete, regions, events, succes;

-- 1)
create temp table import(id integer,
			name text,
			sex char(1) check (sex = 'M' or sex = 'F' or sex = null),
			age integer,
			height float,
			weight float,
			team text,
			noc text,
			games text,
			year integer check (year>= 1894 and year<=2016),
			season text check (season = 'Summer' or season = 'Winter' or season = null),
			city text,
			sport text,
			event text,
			medal text check (medal = 'Bronze' or medal = 'Silver' or medal = 'Gold' or medal = null)
);

-- 2)
\copy import from athlete_events.csv with (format csv, delimiter ',', header, null 'NA');

--3)
delete from import
where year < 1920 or sport like ('Art%');

--4)
create table regions(noc char(3) primary key, team text, note text);
\copy regions from noc_regions.csv with (format csv, delimiter ',', header);

--Ex 4:

--1)3)
create table games(gno serial primary key, year integer, season text, city text);
insert into games(year, season, city)
select distinct year, season, city from import;

create table athlete(id integer primary key, name text, sex char(1));
insert into athlete select distinct id, name, sex from import;

update regions set noc = 'SGP' where noc = 'SIN';

create table events(eno serial primary key, sport text, event text);
insert into events(sport, event)
select distinct sport, event from import;

create table succes(sno serial primary key, gno integer, id integer, noc char(3), eno integer, age integer, height float, weight float, medal text,
			constraint fk_gno foreign key(gno) references games(gno) on delete cascade on update cascade,
			constraint fk_id foreign key(id) references athlete(id) on delete cascade on update cascade,
			constraint fk_rno foreign key(noc) references regions(noc) on delete cascade on update cascade,
			constraint fk_eno foreign key(eno) references events(eno) on delete cascade on update cascade
);
insert into succes(gno, id, noc, eno, age, height, weight, medal)
select g.gno, i.id, i.noc, e.eno, i.age, i.height, i.weight, i.medal
from import as i
join games as g on i.year = g.year and i.season = g.season
join events as e on i.sport = e.sport and i.event = e.event;
