with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions; 	use SDA_Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;


package body Liste is

    procedure Initialiser_Liste(liste : T_Liste) is
    begin
        for i in 1..Capacite loop
            Initialiser(liste(i));
        end loop;
    end Initialiser_Liste;

    function Est_Vide_Liste(liste : T_Liste) return boolean is
        Indice : Integer := 1;
        Vide : Boolean := True;
    begin
        loop
            Vide := (Est_Vide(liste(Indice)));
            Indice := Indice + 1;
            exit when Vide = False or Indice = (Capacite + 1); --On sort de la boucle si une case du tableau est non vide ou si toutes cases sont vides.
            end loop;
        return Vide;
    end Est_Vide_Liste;

    function Taille_Liste(liste : T_Liste) is
        Compteur : Integer := 0;
    begin
        for i in 1..Capacite loop
            if Liste(i)/=Null then
                compteur:=compteur+1;
            else
                Null;
            end if
        end loop;
        return Compteur;
    end Taille_Liste;

    procedure Enregistrer_Liste (Liste : in out T_Liste, in: arbre T_Arbre ) is
        indice : Integer;
    begin
        loop
            if not Est_Vide(liste(indice)) then
                Indice = Indice + 1;
            else
                liste(indice) := arbre
            end if;
        exit when indice > Capacite or not Est_vide(Liste(indice))
        end loop;
    end Enregistrer_Liste;

    procedure Supprimer_Liste (Liste : in out T_Liste ; Indice : Integer) is
    begin
        Liste(indice) := null;
    end Supprimer;

    procedure Vider_liste (liste : in out T_liste) is
    begin
        for i in 1..Capacite loop
            Vider(liste(i));
        end loop;
    end Vider;

end Liste;
