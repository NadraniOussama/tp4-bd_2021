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
