create view mergedt as
select *
from accounts natural join clients 

--- queries

--1
select *
from clients
where surname like 'Иванов'

--2
select *
from clients
where adress like '%Москва%'

--3
select client_id, count(*)
from mergedt
where opening_date > '20.08.2004' and currency_type = 'RUB'
group by client_id

--4
select a.acc_id, count(oper_date)
from accounts a left join registry r on a.acc_id = r.acc_id
where opening_date > '08.01.2004'
group by a.acc_id
order by acc_id

--5
select r.acc_id, oper_type, oper_sum, oper_date
from registry r left join accounts a on r.acc_id = a.acc_id
where currency_type = 'RUB'

--6
select client_id
from mergedt
group by client_id
having count(acc_id) > 1
order by client_id

--7
select locality
from clients

--8
select surname
from clients natural join accounts
where available_amount = 0
--9
select client_id, sum(oper_sum)
from registry natural join accounts
where currency_type = 'RUB' and oper_type = 'Списание'
group by client_id
--10
select c.currency_type, count(acc_id)
from currencies c left join accounts a on c.currency_type = a.currency_type
group by c.currency_type