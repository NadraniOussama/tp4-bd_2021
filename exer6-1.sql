CREATE OR REPLACE TRIGGER T1 

Before insert  on ligne_commande
for each Row
Declare
montan float;
stock1 integer;
nc integer;
np integer;
stock_act integer;

-- exc exception;
Begin
  montan:=:new.qte * :new.prix_unite;
  stock1:=:new.qte;
  nc:=:new.no_cmd;
  np:=:new.no_prod;

select stock into stock_act from produit where no_prod=np;
if(stock_act<stock1) then

  raise_application_error(-20002,'impossible stock empty');
END IF ;  

update commande set montant=montant+montan where no_cmd=nc;
update produit set stock =stock-stock1 where no_prod=np;

End;
/
