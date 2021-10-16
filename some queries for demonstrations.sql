select * from registry

select * from accounts

call remittance(2, 1, 10)

select * from calculate_credit_interest(1);

insert into registry values(2, 'Закрытие счёта', 0, (select current_date))

select * from clients_neg_accounts() 