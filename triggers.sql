create or replace function closing_account() returns trigger as
$$
declare oper_type_new varchar(20); available_amount_new numeric; acc_id_to_remit int;acc_id_new int;
begin
	oper_type_new=new.oper_type;
	if oper_type_new = 'Закрытие счёта' then
	  acc_id_new = new.acc_id;
	  available_amount_new = (select available_amount from accounts where acc_id = acc_id_new);
	  
		if available_amount_new < 0 then
			raise notice 'Для продолжения вам нужно закрыть свой долг по счёту';
			return old;
		elseif (select count(acc_id) from accounts where client_id =
				(select client_id from accounts where acc_id = acc_id_new)) > 1 then
			acc_id_to_remit = (select acc_id from accounts where client_id =
								(select client_id from accounts where acc_id = acc_id_new) 
							   and acc_id <> acc_id_new limit 1);
			raise notice 'Найден второй счёт, перевод средств...';
			call remittance(acc_id_new, acc_id_to_remit, available_amount_new);
		else raise notice 'Исключение';
			return old;
		end if;
	  
	  	raise notice 'Закрытие счёта';
		delete from accounts where acc_id = acc_id_new;
	end if;
	  -- CLIENT HAS available_amount = 0 so he's closing account
	return new;
end;
$$
language plpgsql;

drop trigger if exists tr_closing_account on registry;
create trigger tr_closing_account before insert on registry
for each row execute procedure closing_account();										---works correct


insert into registry values (3, 'Закрытие счёта', 0, (select current_date)) 
select * from clients

--------------------------------------------------------2-------------------------------------------------------------------
create or replace function new_operation() returns trigger as
$$
	declare new_acc_id int = new.acc_id; oper_type varchar(20) = new.oper_type; oper_sum numeric = new.oper_sum;
			curr_amount numeric = (select available_amount from accounts where acc_id = new.acc_id);
	begin
		if oper_type = 'Зачисление' then
			update accounts set available_amount = curr_amount + oper_sum where acc_id = new_acc_id;
		elseif oper_type = 'Списание' then
			update accounts set available_amount = curr_amount - oper_sum where acc_id = new_acc_id;
		end if;
		return new;
	end;
$$
language plpgsql;

drop trigger if exists tr_new_operation on registry;
create trigger tr_new_operation before insert on registry
for each row execute procedure new_operation();  									---works correct