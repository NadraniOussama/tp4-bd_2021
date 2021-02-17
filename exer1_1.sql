CREATE OR REPLACE FUNCTION  get_dname (dnum NUMBER )
	return dept.dname%type
	is 
	d_name dept.dname%type;
	Begin 
		SELECT dname INTO d_name  FROM dept where deptno =dnum;
		return d_name;
	End;
/