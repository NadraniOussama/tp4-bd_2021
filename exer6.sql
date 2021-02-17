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
