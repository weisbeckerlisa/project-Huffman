with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions; 		use SDA_Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with LISTE;
with ABR;

procedure test_abr is

    package ABR_Integer is
		new ABR (T_Caractere => Integer);
    use ABR_Integer;

    procedure tester_initialiser_liste is
        liste: T_Liste;
    begin
        Initialiser_Liste(liste);
        Pragma assert(Est_Vide_Liste(liste));
        Vider_Liste(liste);
    end;

    procedure tester_enregistrer_liste is
        arbre1, arbre2, arbre3, arbre4, arbre5: T_Arbre;
        liste: T_Liste;
    begin
        Initialiser(liste);

        --Ajouter plusieurs arbres et vérifier qu'ils sont dans la liste et que leurs informations sont correctes

        Initialiser(arbre1);
        Enrgistrer(arbre1,1,5);

        Initialiser(arbre2);
        Enrgistrer(arbre2,2,125);

        Initialiser(arbre3);
        Enrgistrer(arbre3,3,96);
        Enregistrer(arbre3, 2,25);

        pragma Assert(Taille_Liste(liste)=0);
        Enregistrer(liste,arbre1);

        pragma Assert(Taille_Liste(liste)=1);
        pragma Assert(liste(1).all.occurence=1);
        pragma Assert(liste(1).all.Caractere=5);

        Enregistrer(liste,arbre2);
        Enregistrer(liste,arbre3);
        pragma Assert(Taille_Liste(liste)=3);
        pragma Assert(liste(2).all.occurence=2);
        pragma Assert(liste(2).all.Caractere=125);
        pragma Assert(liste(3).all.occurence=3);
        pragma Assert(liste(3).all.Caractere=96);

        --Ajouter un arbre null
        Initialiser(arbre4);
        Enregistrer(liste,arbre4);
        pragma Assert(Taille_Liste(liste)=3);
        pragma Assert(liste(4)=null);

        --Supprimer un arbre et ajouter un nouvel arbre pour vérifier que l'enregistrement se fait dans la première case non vide
        Supprimer_Liste(liste,2);
        pragma Assert(liste(2)=null);
        Initialiser(arbre5);
        Enregistrer(arbre5,8,-1);
        Pragma Assert(liste(2).all.occurence=8);
        Pragma Assert(liste(2).all.caractere=-1);

        Vider_Liste(liste)
    end;

    procedure tester_supprimer_liste is
        arbre1, arbre2, arbre3: T_Arbre;
        liste: T_Liste;

    begin
        Initialiser(liste);

        --Ajouter plusieurs arbres à la liste et les supprimer

        Initialiser(arbre1);
        Enrgistrer(arbre1,1,5);

        Initialiser(arbre2);
        Enrgistrer(arbre2,2,125);

        Initialiser(arbre3);
        Enrgistrer(arbre3,3,96);
        Enregistrer(arbre3, 2,25);

        Enregistrer(liste,arbre1);
        Enregistrer(liste,arbre2);
        Enregistrer(liste,arbre3);

        pragma Assert(Taille_Liste(liste)=3)

        Supprimer_Liste(liste,1);

        pragma Assert(Taille_Liste(liste)=2);
        pragma assert(liste(1)=null);

        --Supprimer élément déjà null
        pragma assert(liste(4)=null);
        Supprimer_Liste(liste,4);
        pragma Assert(Taille_Liste(liste)=2);
        pragma assert(liste(4)=null);

        --Supprimer tout les arbres de la liste

        Supprimer_liste(liste,2);
        Supprimer_Liste(liste,3);
        pragma Assert(Taille_Liste(liste)=0);
        pragma assert(liste(2)=null);
        pragma assert(liste(3)=null);
        pragma Assert(Est_Vide_Liste(liste));

        Vider_Liste(liste);

    end;
