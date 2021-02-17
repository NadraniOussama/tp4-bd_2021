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