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