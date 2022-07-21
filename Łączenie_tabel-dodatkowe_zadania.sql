use hr;

-- Zadanie 1
-- Wyznacz dla każdego stanowiska średnie wynagrodzenie, zaokrąglij je do dwóch
-- miejsc po przecinku i posortuj w kolejności malejącej.
select j.job_id, round(avg(salary), 2)
from jobs j
join employees e
on j.JOB_ID = e.job_id
group by j.job_id
order by e.salary;

SHOW VARIABLES LIKE 'sql_mode';
SET sql_mode = 'STRICT_TRANS_TABLES';

-- Zadanie 2
-- Znajdź DEPARTMENT_ID których JOB_ID znajduje się w co najmniej dwóch JOB_ID.
-- Wyświetl ich imię, nazwisko i liczbę JOB_ID w których pracowali. Wyniki
-- posortuj rosnąco względem nazwiska.
select FIRST_NAME, LAST_NAME, count(JOB_ID)
from employees
group by DEPARTMENT_ID
having count(*) >= 2
order by LAST_NAME;

-- Zadanie 3
-- Wyświetl imię, nazwisko i wynagrodzenie najlepiej zarabiającego pracownika.
select FIRST_NAME, LAST_NAME, SALARY
from employees
having max(SALARY);

-- Sposób nr. 2 
select concat(FIRST_NAME, ' ', LAST_NAME), SALARY
from employees
having max(SALARY);

-- Zadanie 4
-- Wyświetl imię, nazwisko i wynagrodzenie drugiego najlepiej zarabiającego pracownika.
with temp_view as (
select FIRST_NAME, LAST_NAME, SALARY
from employees
group by SALARY
order by SALARY desc
limit 2
)
select * from temp_view
order by SALARY
limit 1;

-- Sposób nr. 2
select concat(FIRST_NAME, ' ', LAST_NAME), SALARY
from employees
where SALARY < (select max(SALARY) from employees)
order by SALARY desc
limit 1;

-- Zadanie 5
-- Wyświetl każdy departament i najwcześniejszą datę zatrudnienia pracownika który został w nim
-- zatrudniony.
select * from employees
group by DEPARTMENT_ID
order by HIRE_DATE;

-- Sposób nr.2
select DEPARTMENT_ID, min(HIRE_DATE)
from employees
group by DEPARTMENT_ID;

-- Zadanie 6
-- Znajdź wszystkich pracowników którzy nie mają samogłosek w imieniu (‘a’, ‘e’, ‘i’, ‘o’,
-- ‘u’), wyświetl ich imię, nazwisko i departament w którym pracują.
select FIRST_NAME 
from employees
where FIRST_NAME not like '%a%'
   and FIRST_NAME not like '%e%' 
   and FIRST_NAME not like '%i%' 
   and FIRST_NAME not like '%o%'
   and FIRST_NAME not like '%u%';
