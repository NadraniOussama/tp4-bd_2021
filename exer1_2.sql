CREATE OR REPLACE PROCEDURE p1(d_num NUMBER, d_name OUT dept.dname%type)
	IS
	Begin 
	select dname into d_name from dept WHERE d_num=deptno;
	END;
/
