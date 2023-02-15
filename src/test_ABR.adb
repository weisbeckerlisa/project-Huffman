with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions; 		use SDA_Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with ABR;

procedure test_abr is

    package ABR_Integer is
		new ABR (T_Caractere => Integer);
    use ABR_Integer;


    procedure tester_initialiser is
        arbre : T_arbre;
    begin
        initialiser(arbre);
        Pragma assert (Est_vide(arbre) = (arbre = null));
        vider(arbre);
    end;

    procedure tester_taille is
        arbre : T_arbre;
    begin
        initialiser(arbre);
        enregistrer(arbre, 2, 26);
        Pragma assert (taille(arbre) = 1);
        enregistrer(arbre, 1, 73);
        Pragma assert (taille(arbre) = 2);
        supprimer(arbre, 26);
        Pragma assert (taille(arbre) = 1);
        vider(arbre);
    end;


    procedure tester_enregistrer is
        arbre : T_arbre;
    begin
        initialiser(arbre);
        enregistrer(arbre, 3, -1);
        Pragma assert(Caractere_Present(arbre, -1));
        enregistrer(arbre, 1, 109);
        Pragma assert(Caractere_Present(arbre, 109));
        enregistrer(arbre, 4, 109);
        Pragma assert(L_Occurrence(arbre, 109) = 4);
        vider(arbre);
    end;

    procedure tester_supprimer is
        arbre : T_arbre;
    begin
        initialiser(arbre);
        enregistrer(arbre, 3, 255);
        enregistrer(arbre, 1, 107);
        supprimer(arbre, 255);
        Pragma assert(not Caractere_Present(arbre, 255));
        enregistrer(arbre, 2, 202);
        supprimer(arbre, 202);
        Pragma assert(not Caractere_Present(arbre, 202));
        vider(arbre);
    end;

    procedure tester_caractere_present is
        arbre : T_arbre;
    begin
        initialiser(arbre);
        enregistrer(arbre, 3, 183);
        enregistrer(arbre, 1, 4);
        Pragma assert(Caractere_Present(arbre, 183));
        supprimer(arbre, 4);
        Pragma assert(not Caractere_Present(arbre, 4));
        vider(arbre);
    end;

    procedure tester_L_occurence is
        arbre : T_arbre;
    begin
        initialiser(arbre);
        enregistrer(arbre, 5, 183);
        enregistrer(arbre, 1, 4);
        Pragma assert(L_Occurence(arbre, 183) = 5);
        enregistrer(arbre, 2, 4);
        vider(arbre);
    end;

    procedure tester_vider is
        arbre : T_arbre;
    begin
        initialiser(arbre);
        enregistrer(arbre, 3, 255);
        enregistrer(arbre, 1, 107);
        supprimer(arbre, 255);
        enregistrer(arbre, 2, 78);
        vider(arbre);
        assert(Est_Vide(arbre));
    end;
