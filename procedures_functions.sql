-----------------------------------------------------------1----------------------------------------------------------------------

create or replace procedure
	remittance(acc_id_out int, acc_id_in int, remit_sum numeric)
as
$$ 
	declare residue_in numeric; residue_out numeric; cur_in varchar(3); cur_out varchar(3); coeff_remit numeric;
	begin
		residue_in = (select available_amount from accounts where acc_id = acc_id_in);
		residue_out = (select available_amount from accounts where acc_id = acc_id_out);
		cur_in = (select currency_type from accounts where acc_id = acc_id_in);
		cur_out = (select currency_type from accounts where acc_id = acc_id_out);
		
		insert into registry values (acc_id_out, 'Списание', remit_sum, (select current_date));
		
		if cur_out <> cur_in then
			coeff_remit = (select coeff from exchanging_rates where curr_out = cur_out and curr_in = cur_in);
			remit_sum = remit_sum * coeff_remit;
		end if;
		raise notice '%', remit_sum;
		insert into registry values (acc_id_in, 'Зачисление', remit_sum, (select current_date));
		
	end;
$$ language plpgsql;    				--works correctly

select * from accounts
call remittance(2, 1, 10)
select * from accounts


-----------------------------------------------2--------------------------------------------------------------------------------
drop function if exists calculate_credit_interest;
create or replace function
	calculate_credit_interest(curr_client_id int) returns numeric 
as
$$
	declare init_perc numeric;lifetime int;mean_ratio numeric;avg_income numeric; 
		avg_outcome numeric; curr_year int;birth_year int;
	begin
		init_perc = 9.;
		curr_year = (select extract(
							year from current_date
							) );
		birth_year = (select extract(
								year from (select min(opening_date) from accounts 
										   	where client_id = curr_client_id)
							) );
		lifetime =  curr_year - birth_year;
		init_perc = init_perc - lifetime * 0.1;
		avg_income = (select avg(oper_sum) 
						from accounts natural join registry 
						where oper_type = 'Зачисление' and (curr_year - 
					  								(select extract(year from oper_date)) <= 2)
													and client_id = curr_client_id);
						raise notice 'Средний доход: %', avg_income;
		avg_outcome = (select avg(oper_sum) 
						from accounts natural join registry 
						where oper_type = 'Списание' and (curr_year - 
					   								(select extract(year from oper_date)) <= 2)
													and client_id = curr_client_id);
						raise notice 'Средние траты: %', avg_outcome;
		mean_ratio = avg_outcome / avg_income;
		if mean_ratio  > 1 then
			mean_ratio = mean_ratio * 0.1;
		end if;
		init_perc = init_perc - mean_ratio;
		if init_perc < 4  then
			init_perc = 4;
		elseif init_perc is null then
			init_perc = 9;
		end if;
		return init_perc;
	end;
$$ language plpgsql;  


select * from calculate_credit_interest(3);

-----------------------------------------------------------3----------------------------------------------------------------------
drop function if exists clients_neg_accounts();
create or replace function
	clients_neg_accounts() returns table(id int, initials text, accounts text ) 
as
$$
begin
	return query
	select client_id, agg, acc_list
	from (
				select 
				  c.client_id, c.surname ||' ' ||c.name||' '||c.patronymic agg, 
				  count(*) num_accounts, 
				  sum(case when available_amount<0 then 1 else 0 end) num_neg_accounts,
				  string_agg (acc_id::varchar(3)||'('||currency_type||')'||':'
								||available_amount::varchar(10),'; ') acc_list
				from clients c join accounts a on c.client_id=a.client_id 
				group by 1, 2 ) foo
	where num_accounts > 1 and num_neg_accounts > 0;
end;
$$ language plpgsql;

select * from clients_neg_accounts()                    --works correct