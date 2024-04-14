--Ex 3:

--1)
select count(*) as nb_colonnes_import
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'import';

--2)
select count(*) as nb_lignes_import
from import;

--3)
select count(noc) as nb_codes_noc
from regions;

--4)
select count(distinct id) as nb_athletes
from import;

--5)
select count(*) as nb_medailles_or
from import where medal = 'Gold';

--6)
select count(*) as nb_ligne_carl_lewis
from import
where name like '%Carl% %Lewis%';


--Ex 5:

--1)
select r.team, count(e.eno) as participation
from regions as r
natural join (succes as s natural join events as e)
group by r.team
order by count(e.eno) desc;

--2)
select r.team, count(s.medal) as nb_medailles_or
from regions as r
natural join succes as s
where s.medal = 'Gold'
group by r.team
order by count(s.medal) desc;

--3)
select r.team, count(s.medal) as nb_medailles_totales
from regions as r
natural join succes as s
group by r.team
order by count(s.medal) desc;

--4)
select id, name, count(medal) as nb_medailles_or
from athlete
natural join succes
where medal = 'Gold'
group by id, name
having count(medal) >= all(select count(medal) from succes where medal = 'Gold' group by id, name);

--5)
select team, count(medal) as nb_medailles_totales
from regions
natural join (succes natural join games)
where city = 'Albertville'
group by team
order by count(medal) desc;

--6)
select count(distinct s1.id) as nb_sportifs
from regions as r1
natural join (succes as s1 natural join games as g1)
where r1.team != 'France' and exists (select * from regions as r2 natural join (succes as s2 natural join games as g2) where s1.id = s2.id and g1.year < g2.year and r2.team = 'France');

--7)
select count(distinct s1.id) as nb_sportifs
from regions as r1
natural join (succes as s1 natural join games as g1)
where r1.team = 'France' and exists (select * from regions as r2 natural join (succes as s2 natural join games as g2) where s1.id = s2.id and g1.year < g2.year and r2.team != 'France');


--8)
select age, count(medal) as nb_medailles_or
from succes
where medal = 'Gold'
group by age
order by age;

--9)
select sport, count(medal) as nb_medailles
from events
natural join succes
where age > 50
group by sport
having count(medal) > 0
order by count(medal) desc;

--10)
select count(eno) as nb_epreuves, season, year
from games
natural join (succes natural join events)
group by season, year
order by year;

--11)
select count(medal) as nb_medailles_feminines, year
from games
natural join (succes natural join athlete)
where sex = 'F' and season = 'Summer'
group by year
order by year;

--Ex 6:
--sport : badminton, pays : Etats-Unis

--donner le nombre total de médailles obtenues par les Etats-Unis au badminton.
select count(medal) as nb_medailles
from succes
where noc in (select noc from regions where team = 'USA') and eno in (select eno from events where sport = 'Badminton');

--donner la moyenne d'âge de tous les joueurs de badminton aux Etats-Unis.
Select avg(age) as moyenne_age
from succes
where noc = 'USA' and eno in (select eno from events where sport = 'Badminton');

--donner les athletes qui sont les plus grands des Etats-Unis et qui jouent au badminton.
select id, name
from athlete
where id in (select id from succes where noc = 'USA' and eno in (select eno from events where sport = 'Badminton') group by id,height having height >= all(select height from succes where noc = 'USA' and eno in (select eno from events where sport = 'Badminton')));

--donner les athletes qui font du badminton, qui ont 28 ans et qui sont aux Etats-Unis.
select id, name
from athlete
where id in (select id from succes where age = 28 and noc = 'USA' and eno in (select eno from events where sport = 'Badminton'));
