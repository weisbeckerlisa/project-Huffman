with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Unchecked_Deallocation;



package body ABR is

    procedure Free is
	new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Arbre);

    procedure Initialiser(Arbre: out T_Arbre) is
    begin
        Arbre:=Null;
    end Initialiser;

    function Est_Vide (Arbre : T_Arbre) return Boolean is
    begin
        return Arbre=Null;
    end;

    function Taille (Arbre : in T_Arbre) return Integer is
    begin
        if Arbre=Null then
            return 0;
        else
            return Taille(arbre.all.sag)+Taille(arbre.all.sad)+1;
        end if;
    end;

    procedure Vider (Arbre : in out T_Arbre) is
    begin
        if not Est_Vide(Arbre) then
            Vider(arbre.all.sag);
            Vider(arbre.all.sad);
            Free(Arbre);
        else
            Null;
        end if;
    end;

end ABR;
