# База данных банка

Задача – создать приложение, поддерживающее:

 

§  Справочник клиентов (ФИО, адрес, паспортные данные)

§  Справочник городов (название, количество населения)

§  Список счетов, открытых для клиентов (номер счета, валюта счета, дата открытия, дата закрытия, сумма доступных средств)

§  Справочник валют (название, ISO символ, ISO номер)

§  Справочник типов операций, осуществляемых над счетом (название операции, знак операции)

§  Реестр операций над счетом (счет, тип операции, сумма операции, дата операции)

§  Справочник курсов валют (валюта начальная, валюта конечная, коэффициент для пары)

 

## Запросы:

1.     Выбрать всех клиентов по фамилии “Иванов”.

2.     Выбрать всех клиентов, проживающих в Москве.

3.     Найти количество открытых после 20 августа 2004 года рублевых счетов.

4.     Вывести все счета и количество операций по этим счетам после 01.08.2004.

5.     Вывести все операции по рублевым счетам (номер операции, тип операции, сумма операции, дата операции).

6.     Вывести клиентов, у которых открыто несколько счетов.

7.     Вывести список населенных пунктов, в которых проживают клиенты банка.

8.     Вывести клиентов, у которых ни на одном счете не осталось средств.

9.     Вывести сумма расходов по рублевому счету для каждого клиента.


10.   Вывести количество открытых счетов для каждой валюты.


##   Хранимые процедуры и функции

1.     Написать процедуру перевода средств с одного счета банка на другой. В качестве параметров процедуры передаются номера счетов и сумма перевода. 
Необходимо соответсвующим образом изменить величину остатка на каждом из счетов и добавить записи в реестр операций для каждого из счетов.


2.     Написать функцию, вычисляющую кредитный процент для клиента. В качестве параметра функции передается id клиента. Величина процента зависит от срока, в течении которого  
данный человек является клиентом банка и ежемесячных посуплений на счета клиента. Начальное значение задается константой в теле функции (например, 9%). Из этого значения  
вычитается количество полных лет, в течение которых человек является клиентом банка, умноженное на 0.1; вычисляется среднее отношение дохода к расходу по всем счетам клиента за  последние 2 года, в случае, когда полученная величина больше 1, она умножается на 0.1 и вычитается из значения процента. Минимальное возможное значение 4%.  

3.      Написать функцию, возвращающую список клиентов, у которых в банке открыто несколько счетов, и у которых хотя бы на одном из счетов отрицательный баланс. Возвращаемая   
 таблица состоит из трех столбцов. Первые два – id и ФИО клиента. Третий – строка в формате: № _счета_1 (валюта_счета_1): остаток_на_счете_1; № _счета_2 (валюта_счета_2): остаток_на_счете_2, ...

##   Триггеры
1.     Создать триггер  на операцию закрытия счета. В случае, когда остаток на счете = 0 позволять закрыть счет. Когда остаток отрицателен выбрасывать исключение и не позволять закрыть счет. Когда остаток положителен и тот же клиент имеет в банке другой открытый счет – перевести остаток на второй счет, этот закрыть. Когда остаток положителен и второго открытого счета в нашем банке нет – выкидывать исключение.

2.     Создать триггер на добавление новой операции над счетом. В теле триггера изменять остаток на счете в соответствии с добавляемой операцией.
