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
