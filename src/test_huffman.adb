with Ada.Text_IO; use Ada.Text_IO;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with System.Assertions; use System.Assertions;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;
with huffman; use HUFFMAN;  


procedure test_Huffman is

    procedure tester_Initialiser_Liste is
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
        Initialiser_Liste(liste);

        --Ajouter plusieurs arbres et vérifier qu'ils sont dans la liste et que leurs informations sont correctes

        Initialiser(arbre1);
        Enregistrer(arbre1,1,5);

        Initialiser(arbre2);
        Enregistrer(arbre2,2,125);

        Initialiser(arbre3);
        Enregistrer(arbre3,3,96);

        pragma Assert(Taille_Liste(liste)=0);
        Enregistrer_Liste(liste,arbre1);

        pragma Assert(Taille_Liste(liste)=1);
        pragma Assert(liste(1).all.occurence=1);
        pragma Assert(liste(1).all.Caractere=5);

        Enregistrer_Liste(liste,arbre2);
        Enregistrer_Liste(liste,arbre3);
        pragma Assert(Taille_Liste(liste)=3);
        pragma Assert(liste(2).all.occurence=2);
        pragma Assert(liste(2).all.Caractere=125);
        pragma Assert(liste(3).all.occurence=3);
        pragma Assert(liste(3).all.Caractere=96);

        --Ajouter un arbre null
        Initialiser(arbre4);
        Enregistrer_Liste(liste,arbre4);
        pragma Assert(Taille_Liste(liste)=3);
        pragma Assert(liste(4)=null);

        --Supprimer un arbre et ajouter un nouvel arbre pour vérifier que l'enregistrement se fait dans la première case non vide
        Supprimer_Liste(liste,2);
        pragma Assert(liste(2)=null);
        Initialiser(arbre5);
        Enregistrer(arbre5,8,-1);
        Enregistrer_Liste(liste,arbre5);
        Pragma Assert(liste(2).all.occurence=8);
        Pragma Assert(liste(2).all.caractere=-1);

        Vider_Liste(liste);
    end;

    procedure tester_taille_liste is
        liste : T_Liste;
        arbre1, arbre2, arbre3 : T_Arbre;
    begin
        Initialiser_Liste(liste);
        pragma Assert(Taille_Liste(liste)=0);
        Initialiser(arbre1);
        Enregistrer(arbre1,1,5);

        Initialiser(arbre2);
        Enregistrer(arbre2,2,125);

        Initialiser(arbre3);
        Enregistrer(arbre3,3,96);
        Enregistrer(arbre3, 2,25);

        Enregistrer_Liste(liste,arbre1);
        Enregistrer_Liste(liste,arbre2);
        Enregistrer_Liste(liste,arbre3);

        pragma Assert(Taille_Liste(liste)=3);

        Supprimer_Liste(liste,1);

        pragma Assert(Taille_Liste(liste)=2);
    end;


    procedure tester_supprimer_liste is
        arbre1, arbre2, arbre3: T_Arbre;
        liste: T_Liste;

    begin
        Initialiser_Liste(liste);

        --Ajouter plusieurs arbres à la liste et les supprimer

        Initialiser(arbre1);
        Enregistrer(arbre1,1,5);

        Initialiser(arbre2);
        Enregistrer(arbre2,2,125);

        Initialiser(arbre3);
        Enregistrer(arbre3,3,96);
        Enregistrer(arbre3, 2,25);

        Enregistrer_Liste(liste,arbre1);
        Enregistrer_Liste(liste,arbre2);
        Enregistrer_Liste(liste,arbre3);

        pragma Assert(Taille_Liste(liste)=3);

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

    procedure tester_initialiser_arbre is
        arbre : T_arbre;
    begin
        initialiser(arbre);
        Pragma assert (Est_vide(arbre) = (arbre = null));
        vider(arbre);
    end;

    procedure tester_vider is
        arbre : T_arbre;
    begin
        initialiser(arbre);
        enregistrer(arbre, 3, 255);
        enregistrer(arbre, 1, 107);
        enregistrer(arbre, 2, 78);
        vider(arbre);
        pragma assert(Est_Vide(arbre));
    end;
    
    procedure tester_Get_Frequence is
        Liste: T_Liste;
    begin
        Get_Frequence(Liste,"texte_1.txt");
        pragma Assert (Taille_Liste(liste)=10); 
        pragma Assert (liste(1).all.occurence=18);
        pragma Assert (liste(1).all.caractere=97);
        pragma Assert (liste(2).all.occurence=8);
        pragma Assert (liste(2).all.caractere=10);
        pragma Assert (liste(3).all.occurence=9);
        pragma Assert (liste(3).all.caractere=98);
        pragma Assert (liste(10).all.occurence=0);
        pragma Assert (liste(10).all.caractere=-1);
    end;
    
    procedure tester_Construire_Arbre is
        Liste: T_Liste;
        Arbre: T_Arbre;
    begin
        Get_Frequence(Liste,"texte_1.txt");
        Construire_Arbre(Liste);
        pragma Assert (Taille_Liste(liste)=1);
        Get_Arbre(Liste,Arbre);
        pragma Assert (Arbre.all.occurence=107);
        Dessiner_Arbre(Arbre,0,'x');
    end;
    
    procedure test_Coder_Table  is
        Code: Unbounded_String:=To_Unbounded_String("");
        Arbre: T_Arbre;
        sag: T_Arbre;
        sad: T_Arbre;
        sagsag: T_Arbre;
        sagsad:T_Arbre;
        sadsad: T_Arbre;
        sa1: T_Arbre;
        sa2:T_Arbre;
        sa3: T_Arbre;
        sa4:T_Arbre;
        sa5: T_Arbre;
        sa6:T_Arbre;
        sa7: T_Arbre;
    begin
        -- Création d'un arbre quelconque 
        Enregistrer(sa1,20,65);
        Enregistrer(sa2,20,66);
        Enregistrer(sa3,20,67);
        Enregistrer(sa4,20,69);
        Enregistrer(sa5,20,-1);
        Enregistrer(sa6,20,70);
        Enregistrer(sa7,20,71);
    
        Fusion_Arbre(sa1,sa2,sagsag);
        Fusion_Arbre(sa3,sa4,sagsad);
        Fusion_Arbre(sagsag,sagsad,sag);
        Fusion_Arbre(sa6,sa7,sadsad);
        Fusion_Arbre(sa5,sadsad,sad);
        Fusion_Arbre(sag,sad,arbre);
        
        -- Ecriture de la signature de l'arbre
        Code:= To_Unbounded_String("");
        
        -- Code de la signature et ajout du "1"
        Coder_Arbre(Arbre,code);
        Code:= Code & To_Unbounded_String("1");
        Pragma Assert (Code= To_Unbounded_String("0001101101011"));
    end;
                               
    procedure test_Construire_Table is
        Liste: T_Liste;
        Arbre: T_Arbre;
        Table: T_Table;
        Code: Unbounded_String:= To_Unbounded_String("");
        Cardinal: Integer;
    begin    
        Get_Frequence(Liste, "texte_1.txt");
        Cardinal:=Taille_Liste(Liste);
        -- Création de l'arbre de Huffman
        Construire_Arbre(Liste);
    
        Get_Arbre(Liste,Arbre);
    
        -- Création de la table de Huffman
        Initialiser_Table(Table);
    
        -- On enregistre une valeur défaut dans la première case de la table afin de réserver cet emplacement pour le caractère de fin de texte
        Enregistrer_Table(0,To_Unbounded_String("00000000"),Table);
        pragma Assert (Table(1).all.caractere=0);
        Construire_Table(Arbre,To_Unbounded_String(""),Table);
    
        -- On place le caractère de fin de texte en début de table
        rearranger_Table(Table);
        
        pragma Assert (Table(1).all.caractere=-1);
        pragma Assert (Taille_Table(Table)=Cardinal+1);
        
        Dessiner_Table(Table);
        
        code_caracteres(Table, code);
        pragma Assert (code= To_Unbounded_String("0000001101100010011000110011011100111001011001000000101001111010011001010110000101100001"));
                       
    end;
    
    procedure Tests_Conversion is
        Caractere: Character;
        Octet: T_Octet;
        Bits: Unbounded_String;
    begin
        Caractere:=Convertir_Bits_En_Caractere(To_Unbounded_String("00110000"));
        pragma Assert (Caractere='0');
        Octet:=Convertir_Bits_en_Octet(To_Unbounded_String("00110000"));
        pragma Assert (Octet=48);
        Bits:=convertir_Octet_en_Bits(Octet);
        pragma Assert (Bits=To_Unbounded_String("00110000"));
        Bits:=convertir_Entier_en_Bits(49);
        pragma Assert (Bits=To_Unbounded_String("00110001"));
    end;
    
begin

    tester_Initialiser_Liste;
    tester_enregistrer_liste;
    tester_taille_liste;
    tester_supprimer_liste;
    tester_initialiser_arbre;
    tester_vider;
    tester_Get_Frequence;
    tester_Construire_Arbre;
    test_Coder_Table;
    test_Construire_Table;
    Tests_Conversion;
    Put_Line("Tests OK");
end;
