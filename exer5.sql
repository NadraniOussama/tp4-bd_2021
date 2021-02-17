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
	IF chefName = null then return 'Aucaun';
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