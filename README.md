#TP4 Rapport


##Exercice 1 


> 1. Question 1

``` SQL
CREATE OR REPLACE FUNCTION  get_dname (dnum NUMBER )
	return dept.dname%type
	is 
	d_name dept.dname%type;
	Begin 
		SELECT dname INTO d_name  FROM dept where deptno =dnum;
		return d_name;
	End;
/
```

>  1.	Question2

``` SQL

CREATE OR REPLACE PROCEDURE p1(d_num NUMBER, d_name OUT dept.dname%type)
	IS
	Begin 
	select dname into d_name from dept WHERE d_num=deptno;
	END;
/
```

---

Exercice 2 

> 1. Question 1

``` SQL

CREATE OR REPLACE PROCEDURE P2 
	is
	cursor t_emp is
		SELECT * FROM emp;
	BEGIN 
		FOR e in t_emp loop 
			dbms_output.put_line( 'lemployer <<' || e.ename || '>> a la profession <<'
			 || e.job || '>> dans le departement <<' || get_dname(e.deptno) || '>>') ;
		END loop;
	END;
/	
```

Exercice 2 

> 1. Question 2

``` SQL

CREATE OR REPLACE FUNCTION F2(num NUMBER)
	return emp.ename%type
	IS
	e emp%rowtype;
	exam EXCEPTION;
	BEGIN 
	SELECT * into e FROM emp WHERE emp.empno = num;
	dbms_output.put_line('lemployer ' || e.ename ||' a la profession ' || e.job ||' dans le departement ' || get_dname(e.deptno));
	return e.ename;
	EXCEPTION 
		when NO_DATA_FOUND then return '';
	END;
/
```

Exercice 3

``` SQL

CREATE OR REPLACE FUNCTION F3(enum NUMBER)
	RETURN emp.ename%type
	IS
	numchef emp.empno%type;
	chefName emp.ename%type;
	BEGIN
	SELECT MGR INTO numchef FROM emp where empno = enum;
	chefName := F2(numchef);
	if chefName = '' then
		RETURN 'Aucaun';
	end if;
	return chefName;
	EXCEPTION 
		WHEN no_data_found then return 'Aucaun';
	END;
/	
```

Exercice 4

``` SQL
CREATE OR REPLACE PROCEDURE P4
	IS
	g salgrade.grade%type;
	cursor t_emp is
		SELECT * from emp;
	p NUMBER;
	BEGIN
		FOR e IN t_emp LOOP
		begin 
		SELECT grade into g FROM salgrade s where e.sal >= losal and e.sal < hisal ;
		EXCEPTION -- comme il n'y a pas de 
		when no_data_found then 
			g := 5;				
		end;
			IF g <3 then
				p := 1.1;
			ELSIF g=3 then
				p := 1.15;
			ELSE
				p := 1.2;
			END IF;
			-- dbms_output.put_line(e.sal || ' * ' ||p || ' = ' || e.sal*p);
			UPDATE EMP SET sal = e.sal*p WHERE empno = e.empno;
			commit;
		END LOOP;
	
	END;
/

```

Exercice 5

> package :

``` SQL

CREATE OR REPLACE PACKAGE gestion_emp
is
	FUNCTION get_dname (dnum NUMBER ) return dept.dname%type;
	PROCEDURE P1(d_num NUMBER, d_name out dept.dname%type);
	PROCEDURE P2 ;
	FUNCTION F2(num NUMBER) return emp.ename%type;
	FUNCTION F3(enum NUMBER) return emp.ename%type;
	PROCEDURE P4;
END;
/
```
> package body :

``` SQL


CREATE OR REPLACE PACKAGE BODY gestion_emp
is
-- ==> exer1_1.sql <==
 FUNCTION  get_dname (dnum NUMBER )
	return dept.dname%type
	is 
	d_name dept.dname%type;
	Begin 
		SELECT dname INTO d_name  FROM dept where deptno =dnum;
		return d_name;
	End;

-- ==> exer1_2.sql <==
 PROCEDURE P1(d_num NUMBER, d_name OUT dept.dname%type)
	IS
	Begin 
	select dname into d_name from dept;
	END;

-- ==> exer2_1.sql <==
 PROCEDURE P2 
	is
	cursor t_emp is
		SELECT * FROM emp;
	BEGIN 
		FOR e in t_emp loop 
			dbms_output.put_line( 'lemployer' || e.ename || 'a la profession ' || e.job || 'dans le departement ' || get_dname(e.deptno));
		END loop;
	END;
	
-- ==> exer2_2.sql <==
 FUNCTION F2(num NUMBER)
	return emp.ename%type
	IS
	e emp%rowtype;
	BEGIN 
	SELECT * into e FROM emp WHERE emp.empno = num;
	dbms_output.put_line('lemployer' || e.ename ||'a la profession' || e.job ||'dans le departement' || get_dname(e.deptno));
	return e.ename;
	END;
	
-- ==> exer3.sql <==
 FUNCTION F3(enum NUMBER)
	RETURN emp.ename%type
	IS
	numchef emp.empno%type;
	chefName emp.ename%type;
	BEGIN
	SELECT MGR INTO numchef FROM emp where empno = enum;
	chefName := F2(numchef);
	IF chefName = '' then return 'Aucaun';
	else return chefName;
	END IF;
	END;
	
-- ==> exer4.sql <==
 PROCEDURE P4
	IS
	g salgrade.grade%type;
	cursor t_emp is
		SELECT * from emp;
	p NUMBER;
	BEGIN
		FOR e IN t_emp LOOP
		begin 
		SELECT grade into g FROM salgrade s where e.sal >= losal and e.sal < hisal ;
		EXCEPTION -- comme il n'y a pas de 
		when no_data_found then 
			g := 5;				
		end;
			IF g <3 then
				p := 1.1;
			ELSIF g=3 then
				p := 1.15;
			ELSE
				p := 1.2;
			END IF;
			-- dbms_output.put_line(e.sal || ' * ' ||p || ' = ' || e.sal*p);
			UPDATE EMP SET sal = e.sal*p WHERE empno = e.empno;
	
			commit;
		END LOOP;
	
	END;
END;
/
```

Exercice 6

``` SQL

CREATE OR REPLACE TRIGGER T1 

Before insert or Update or delete on ligne_commande
for each Row
Declare
montan float;
stock1 integer;
nc integer;
np integer;
stock_act integer;

exc exception;
Begin
  IF inserting then
  montan:=:new.qte*:new.prix_unite;
  stock1:=:new.qte;
  nc:=:new.no_cmd;
  np:=:new.no_prod;
   END IF;
  IF deleting then

  montan:=-:old.qte*:old.prix_unite;
  stock1:=-:old.qte;
   nc:=:old.no_cmd;
  np:=:old.no_prod;
 END IF;
  IF updating then

  montan:=:new.qte*:new.prix_unite-:old.qte*:old.prix_unite;
  stock1:=:new.qte-:old.qte;
   nc:=:old.no_cmd;
  np:=:old.no_prod;
 END IF;

select stock into stock_act from produit where no_prod=np;
if(stock_act<stock1) then

  raise_application_error(-20002,'impossible stock empty');
  
Else 
update commande set montant=montant+montan where no_cmd=nc;
update produit set stock =stock-stock1 where no_prod=np;
end IF;
End;
/
```


