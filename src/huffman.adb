with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

package body Huffman is
    
    procedure Initialiser_Liste(liste : out T_Liste) is
    begin
        for i in 1..257 loop
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
            exit when Vide = False or Indice = (257 + 1); --On sort de la boucle si une case du tableau est non vide ou si toutes cases sont vides.
            end loop;
        return Vide;
    end Est_Vide_Liste;

    function Taille_Liste(liste : in T_Liste) return Integer is
        Compteur : Integer := 0;
    begin
        for i in 1..257 loop
            if Liste(i)/=Null then
                compteur:=compteur+1;
            else
                Null;
            end if;
        end loop;
        return Compteur;
    end Taille_Liste;

    procedure Enregistrer_Liste (Liste : in out T_Liste; arbre: in T_Arbre ) is
        indice : Integer;
    begin
        -- On cherche la première case vide de la liste pour enregistrer l'arbre.
        Indice:=1;
        while Liste(Indice)/=Null loop
            Indice := Indice + 1;
        end loop;
        liste(indice) := arbre;
    end Enregistrer_Liste;

    procedure Supprimer_Liste (Liste : in out T_Liste ; Indice : in Integer) is
    begin
        Liste(indice) := null;
    end Supprimer_Liste;

    procedure Vider_liste (liste : in out T_liste) is
    begin
        for i in 1..257 loop
            Vider(liste(i));
        end loop;
    end Vider_liste;
    
    procedure Free is
	new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Arbre);

    procedure Initialiser(Arbre: out T_Arbre) is
    begin
        Arbre:=Null;
    end Initialiser;

    procedure Enregistrer(Arbre: in out T_Arbre; Occurence: in Integer; Caractere: in T_Octet) is
    begin
        Arbre := New T_Cellule'(Occurence, Caractere, null, null);
    end;
    
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


    procedure min_occurence(liste: in T_Liste; Indice: out Integer; Arbre: out T_Arbre) is
        min: Integer;
        non_nul: Integer:=1;
    begin
        -- On cherche la première case non nulle de la liste pour initialiser le min.
        while Liste(non_nul)=Null and non_nul<258 loop
            non_Nul:=non_nul+1;
        end loop;
        Indice:=non_nul;
        min:=Liste(non_nul).all.Occurence;
        Arbre:=Liste(non_nul);
        
        -- On cherche le minimum et son indice dans le reste de la liste.
        for i in non_nul..257 loop
            if Liste(i)=Null then
                Null;
            else
                if Liste(i).all.Occurence < min then
                    min:=Liste(i).all.Occurence;
                    Arbre:=Liste(i);
                    Indice:=i;
                else
                    Null;
                end if;
            end if;
        end loop;

    end min_occurence;

    procedure Construire_Arbre(Liste: in out T_Liste) is
        Indice_min_1, Indice_min_2: Integer;
        Arbre_min_1: T_Arbre;
        Arbre_min_2: T_Arbre;
        Arbre_Fusion: T_Arbre;
    begin
        -- Si la liste et de Taille 1, il n'y a plus qu'un arbre, donc la construction est
        if Taille_Liste(Liste)=1 then
            Null;
        else
            min_occurence(Liste, Indice_min_1, Arbre_min_1);
            Supprimer_Liste(Liste,Indice_min_1);
            min_occurence(Liste, Indice_min_2, Arbre_min_2);
            Supprimer_Liste(Liste, Indice_min_2);
            Fusion_Arbre(Arbre_min_1,Arbre_min_2,Arbre_Fusion);
            Enregistrer_Liste(Liste, Arbre_Fusion);
            Construire_Arbre(Liste);
        end if;
    end Construire_Arbre;
    
    procedure Get_Arbre(Liste: in T_Liste; Arbre: out T_Arbre) is
    begin
        Arbre:=Liste(1);
    end;
    
    function Est_Carac_Present(Liste: in T_Liste; Caractere: in T_Octet) return Boolean is
        Present: Boolean:=False;
    begin
        for i in 1..Taille_Liste(Liste) loop
            if Liste(i).all.Caractere=Caractere then
                Present:= True;
            end if;
        end loop;
        return Present;
    end;
    
    procedure Enregistrer_Carac(Liste: in out T_Liste; Caractere: in T_Octet) is
        Arbre: T_Arbre;
    begin
        Arbre:=New T_Cellule'(1,Caractere,Null,Null);
        Enregistrer_Liste(Liste,Arbre);
    end;
    
    procedure Incrementer_Occurence(Liste: in out T_Liste; Caractere: in T_Octet) is
       
    begin
        for i in 1..Taille_Liste(Liste) loop
            if Liste(i).all.Caractere=Caractere then
                Liste(i).all.Occurence:=Liste(i).all.Occurence+1;
            end if;
        end loop;
    end;
    
    procedure Get_Frequence(Liste: out T_Liste; Nom_texte: in String) is
        File: Ada.Streams.Stream_IO.File_Type;
        S: Stream_Access;
        Arbre_CaractereFinDeListe: T_Arbre;
        Caractere: T_Octet;
    begin
        Initialiser_Liste(Liste);
        Open(File, In_File, Nom_texte);
        S := Stream(File);
        while not End_Of_File(File) loop
            Caractere := T_Octet'Input(S);
            
            -- Si le caractère n'est pas encore présent dans la liste, on l'enregistre avec la fréquence "1"
            if not Est_Carac_Present(Liste, Caractere) then
                Enregistrer_Carac(Liste, Caractere);
            
            -- Si il est déjà présent, on incrémente sa fréquence.
            else
                Incrementer_Occurence(Liste, Caractere);
            end if;
        end loop;
        -- Ajout du caractere '\$'
        Arbre_CaractereFinDeListe:= New T_Cellule'(0,-1,Null,Null);
        Enregistrer_Liste(Liste,Arbre_CaractereFinDeListe); 
        Close(File);
    end Get_Frequence;

    procedure Fusion_arbre(Arbre1: in T_Arbre; Arbre2: in T_Arbre; Arbre_Fusion: out T_Arbre) is
    begin
        Arbre_Fusion := New T_Cellule'(Arbre1.all.Occurence + Arbre2.all.Occurence, 0, Arbre1, Arbre2);
    end Fusion_Arbre;
    
    procedure Enregistrer_Table(caractere: in T_Octet; Code: in Unbounded_String; Table: in out T_Table) is
        indice: Integer:=1;
    begin
        while Table(indice)/=Null and indice <258 loop
            indice:=indice+1;
        end loop;
        if Indice=257 then
            Null;
        else
            Table(indice):=New T_Cellule_Case'(caractere,code);
        end if;
    end;
    
    procedure Initialiser_Table(Table: out T_Table) is
    begin
        for i in 1..257 loop
            Table(i):=Null;
        end loop;
    end;
    
    function Taille_Table(Table: in T_Table) return Integer is
        compteur: Integer:=1;
    begin
        while Table(compteur)/=Null loop
            compteur:=compteur+1;
        end loop;
        return compteur-1;
    end;
        
    procedure Construire_Table(Arbre: in T_Arbre; code: in Unbounded_String; Table: in out T_Table) is
    begin
        -- Si on est arrivé à une feuille, on enregistre le caractère et son code de Huffman dans la table.
        if Arbre.all.sag=Null and arbre.all.sad=Null then
            Enregistrer_Table(Arbre.all.Caractere,code,Table);
        
        -- Sinon, on fonctionne par récurrence en ajoutant "0" au code si on tourne à gauche, "1" si on tourne à droite.
        else
            Construire_Table(Arbre.all.sag,  Code & To_Unbounded_String("0"), Table);
            Construire_Table(arbre.all.sad,  Code & To_Unbounded_String("1"), Table);
        end if;
    end;
    
    procedure rearranger_Table(Table: in out T_Table) is
        compteur: Integer:=1;
    begin
        while table(compteur).Caractere /= -1 and compteur<257 loop
            compteur:=compteur+1;
        end loop;
        -- On enregistre le code du caractère de fin de texte en première position dans la table (cette case avait été réservée pour lui).
        Table(1).Caractere:=Table(compteur).Caractere;
        Table(1).Code:=convertir_Entier_en_Bits(compteur);
        -- On décale la fin de la table à partir de l'endroit où se trouvait la code du caractère de fin de texte.
        -- Le dernier caractère est doublé: ce n'est pas dérangeant car on a besoin de le doubler pour la signature de la compression.
        for i in compteur..Taille_Table(Table)-1 loop
            Table(i).Caractere:=Table(i+1).Caractere;
            Table(i).Code:=Table(i+1).code;
        end loop;
    end rearranger_Table;
    
    function code_huffman(Caracter: in T_Octet; Table: in T_Table) return Unbounded_String is
        Indice: Integer:=1;
    begin
        -- On cherche l'emplacement du caractère donné dans la table et on retourne son code.
        while Table(Indice).all.Caractere/=Caracter and Indice<258 loop
            Indice:=Indice+1;
        end loop;
        if Indice=258 then
            Put("Erreur");
            return To_Unbounded_String("");
        else
            return Table(Indice).all.code;
        end if;
    end code_huffman;
    
    function get_code(i: in Integer; Table: in T_Table) return Unbounded_String is
        Code: Unbounded_String;
    begin
        Code:= Table(i).all.code;
        return code;
    end;

    procedure Coder_Arbre(Arbre: in T_Arbre; Code: in out Unbounded_String) is
        Virages: Integer ;
        Curseur: T_Arbre ;
    begin
        if  Arbre= Null then
            Code:= Code & To_Unbounded_String("");
        else
            -- On va compter le nombre de virages à gauche nécessaires pour arriver à la première feuille, et ajoute "0" au code à chaque fois.
            curseur:=Arbre;
            Virages :=0;
            while curseur.all.sag/=Null loop
                Code := Code & To_Unbounded_String("0");
                Virages:=Virages+1;
                Curseur:=Curseur.all.sag;
            end loop;
            
            while Virages >0 loop  
                -- On a atteint une feuille, on rajoute "1" à la signature.
                Code:= Code & To_Unbounded_String("1");
                -- On décrémente le nombre de virage et on se replace dans l'arbre avant le dernier virage à gauche, puis on tourne à droite.
                Virages:=Virages-1;
                Curseur:=Arbre;
                for i in 1..Virages loop
                    Curseur:=Curseur.all.sag;
                end loop;
                if curseur.all.sad/=Null then
                    Curseur:=Curseur.all.sad;
                end if;
                -- Par récursivité, on réappelle le code sur le sous arbre droit atteint.
                Coder_Arbre(Curseur,code);
            end loop;
        end if;
        -- Il manquera un "1" à la fin qu'on peut rajouter à posteriori.
    end Coder_Arbre;
    

    procedure Dessiner_Arbre(Arbre : in T_Arbre; etage: in Integer; D_ou_G: in Character) is
    
    begin
        if Arbre = Null then
            Null;
        -- Lorsqu'on appelle la procédure dessiner, étage aura la valeur 0: on est au début de l'arbre.
        -- Egalement, au premier appelle, D_ou_G peut prendre une valeur quelconque.    
        elsif etage=0 then
            Put("(");
            Put(Arbre.all.occurence,0);
            Put(")");
           if Arbre.all.Caractere /= 0 then
                Put(" '");
                -- On sépare les cas particuliers "\$" et "\n".
                if arbre.all.Caractere=-1 then
                    Put("\$");
                elsif arbre.all.Caractere=10 then
                    Put("\n");
                else
                    Put(Character'Val(arbre.all.Caractere));
                end if;
                Put_Line("'");
            else
                New_Line;
            end if;
            -- On appelle la procédure par récursivité sur le sous arbre droit et gaucge, étage sera > 0.
            Dessiner_Arbre(Arbre.all.sag,etage+1,'G');
            Dessiner_Arbre(Arbre.all.sad,etage+1,'D');
        else
            Put("   ");
            for i in 1..etage-1 loop
                Put("|      ");
            end loop;
            if D_ou_G='G' then
                Put("\--0--(");
                Put(Arbre.all.Occurence,0);
                Put(")");
            elsif D_ou_G='D' then
                Put("\--1--(");
                Put(Arbre.all.Occurence,0);
                Put(")");
            else
                Null;
            end if;
            if Arbre.all.Caractere /= 0 then
                Put(" '");
                if arbre.all.Caractere=-1 then
                    Put("\$");
                elsif arbre.all.caractere=10 then
                    Put("\n");
                else
                    Put(Character'Val(arbre.all.Caractere));
                end if;
                Put_Line("'");
            else
                New_Line;
            end if;
            Dessiner_Arbre(Arbre.all.sag,etage+1,'G');
            Dessiner_Arbre(Arbre.all.sad,etage+1,'D');
        end if;
    end Dessiner_arbre;

    procedure Dessiner_Table(Table: in T_Table) is

    begin
        for i in 1..Taille_Table(Table)-1 loop
            if Table(i).all.Caractere=-1 then
                Put("'");
                Put("\$");
                Put("'");
                Put("  -->  ");
                Put_Line(To_String(Table(i).all.code));
            elsif Table(i).all.caractere=10 then
                Put("'");
                Put("\n");
                Put("'");
                Put("  -->  ");
                Put_Line(To_String(Table(i).all.code));
            else 
                Put("'");
                Put(Character'Val(Table(i).all.Caractere));
                Put("'");
                Put("   -->  ");
                Put_Line(To_String(Table(i).all.code));
            end if;
        end loop;
    end;    
    
    procedure code_caracteres(Table: in T_Table; code: in out Unbounded_String) is
   
    begin 
        code:= code & Table(1).all.code;
        for i in 2..Taille_Table(Table) loop
            code:= code & convertir_Octet_en_Bits(Table(i).all.Caractere);
        end loop;
    end;
    
    Procedure compresser_Texte(Texte: in String; Table: in T_Table; Texte_Compresse: in out Unbounded_String) is
        File: Ada.Streams.Stream_IO.File_Type;
        S: Stream_Access;
        Caractere: T_Octet;
    begin
        open(File, In_File, texte);
        S:= Stream(File);
        while not End_Of_File(File) loop
            Caractere:=T_Octet'Input(S);
            Texte_Compresse:= Texte_Compresse & code_huffman(Caractere, Table);
        end loop;
        Close(File);
    end compresser_Texte;
    
    procedure recreer_Arbre(Texte_Compresse: in Unbounded_String; Arbre: out T_Arbre) is

    begin
        --TODO
        null;
    end;
    

    function Convertir_Bits_En_Caractere(Bits : in Unbounded_String) return Character is
        indice : T_Octet :=0;
    begin
        for k in 1..8 loop
            indice := indice * 2 or Boolean'pos(To_String(Bits)(k)='1');
        end loop;
        return Character'val(indice);
    end Convertir_Bits_En_Caractere;

    function Convertir_Bits_en_Octet(Bits : in Unbounded_String) return T_Octet is
        Octet: T_Octet:=0;
    begin
        for k in 1..8 loop
            Octet := Octet + (Character'Pos(To_String(Bits)(k))-48)*(2**(8-k));
        end loop;
        return Octet;
    end Convertir_Bits_en_Octet;
    
    function convertir_Octet_en_Bits(Octet: in T_Octet) return Unbounded_String is
        Bits: Unbounded_String:= To_Unbounded_String("");
        Val_Octet: T_Octet:= Octet;
    begin
        for k in 1..8 loop
            if Val_Octet -2**(8-k) > Val_Octet then
                Bits:= Bits & To_Unbounded_String("0");
            else
                Bits:= Bits & To_Unbounded_String("1");
                Val_Octet:=Val_Octet-2**(8-k);
            end if;
        end loop;
        return Bits;
    end convertir_Octet_en_Bits;
    
    function convertir_Entier_en_Bits(Entier: in Integer) return Unbounded_String is
        Bits: Unbounded_String:= To_Unbounded_String("");
        Val_Entier: Integer:= Entier;
    begin
        for k in 1..8 loop
            if Val_Entier -2**(8-k) < 0 then
                Bits:= Bits & To_Unbounded_String("0");
            else
                Bits:= Bits & To_Unbounded_String("1");
                Val_Entier:=Val_Entier-2**(8-k);
            end if;
        end loop;
        return Bits;
    end convertir_Entier_en_Bits;
    
    
    --  Partie décompression: non complète et non testée
    -- 
    --      procedure recreer_arbre(Texte_compresse : in Unbounded_String, Arbre : out T_arbre) is
    --          Liste_Caractere : L_Character;
    --          Liste_arbre : T_Liste2; --record avec Taille + Liste d'arbres
    --          nbr_0, nbr_1 : Integer := 0;
    --          Liste_bool : L_bool; --Liste avec Taille + Tableau de 256 boolean
    --          arbre : T_arbre;
    --      begin
    --          Liste_character.Taille := 0;
    --  
    --          -- On met les caractères dans la liste
    --          while To_String(Codage)(1..8)/=To_String(Codage)(9..16) loop
    --              Liste_Caractere.Taille := Liste_Caractere.Taille + 1;
    --              Liste_Caractere.Caracteres(Liste_Caractere.Taille) := Convertire_Bits_en_Octet((Codage)(1..8));
    --              Texte := Delete(Texte, 1, 8);
    --          end loop;
    --          Liste_Caractere.Taille := Liste_Caractere.Taille + 1;
    --          Liste_Caractere.Caracteres(Liste_Caractere.Taille) := Convertire_Bits_en_Octet((Codage)(1..8));
    --          Codage := Delete(Texte, 1, 16);
    --  
    --  
    --          -- Ecrire l'arbre à l'aide du texte restant
    --  
    --          Liste_bool.Taille := 0;
    --          Liste_arbre.Taille := 0;
    --  
    --          while nbr_0 >= nbr_1 loop
    --  
    --              if To_String(Texte)(1) = '0' then
    --                  -- Rajouter une racine à l'arbre
    --                  nbr_0 := nbr_0 + 1;
    --                  Liste_bool.Taille := Liste_bool.Taille + 1;
    --                  Liste_bool.bool(Liste_bool.Taille) := False;
    --  
    --              else
    --                  -- Rajouter une feuille à l'arbre
    --  
    --                  nbr_1 := nbr_1 + 1;
    --                  -- Creer La feuille selon sa position dans la portion des caractères de la table de Huffman
    --                  Liste_arbre.Taille := Liste_arbre.Taille + 1;
    --                  Liste_arbre.ARB(Liste_arbre.Taille) := new T_Cellule;
    --  
    --                  if nbr_1 = Character'pos(Liste_Caractere.Caracteres(1))+1 then
    --                      -- Donner les caracteristique de la feuille '\$'
    --                      Liste_arbre.ARB(Liste_arbre.Taille).all.Occurence := 0;
    --                      Liste_arbre.ARB(Liste_arbre.Taille).all.Caractere := Character'Val(0);
    --                  else
    --                      -- Donner les caracteristique de la feuille non '\$'
    --  
    --                      Liste_arbre.ARB(Liste_arbre.Taille).all.Occurence := 1;
    --  
    --                      if nbr_1 <= Character'Pos(Liste_Caractere.Caracteres(1)) then
    --                          Liste_arbre.ARB(Liste_arbre.Taille).all.Caractere := Liste_Caractere.Caracteres(nbr_1 + 1);
    --                      else
    --                          Liste_arbre.ARB(Liste_arbre.Taille).all.Caractere := Liste_Caractere.Caracteres(nbr_1);
    --                      end if;
    --  
    --                  end if;
    --  
    --                  Liste_arbre.ARB(Liste_arbre.Taille).all.sag := null;
    --                  Liste_arbre.ARB(Liste_arbre.Taille).all.sad := null;
    --  
    --  
    --                  -- Ajouter la feuille à l'arbre
    --                  while Liste_bool.Taille>0 and then Liste_bool.bool(Liste_bool.Taille) loop
    --  
    --                      Arbre := new T_Feuille;
    --                      Arbre.all.Occurence := Liste_Arbres.ARB(Liste_arbre.Taille-1).all.Occurence+Liste_Arbres.ARB(Liste_arbre.Taille).all.Occurence;
    --                      Arbre.all.sag := Liste_Arbres.Foret(Liste_arbre.Taille-1);
    --                      Arbre.all.sad := Liste_Arbres.Foret(Liste_arbre.Taille);
    --                      Liste_Arbres.ARB(Liste_arbre.Taille-1) := Arbre;
    --                      Liste_Arbres.ARB(Liste_arbre.Taille) := null;
    --  
    --                      Liste_arbre.Taille := Liste_arbre.Taille - 1;
    --                      Liste_bool.Taille := Liste_bool.Taille - 1;
    --                  end loop;
    --  
    --                  if Liste_bool.Taille > 0 then
    --                      Liste_bool.ARBs(Liste_bool.Taille) := True;
    --                  end if;
    --              end if;
    --  
    --          end loop;
    --      end Recuperer_arbre;
    --  
    --  
    --  
    --      procedure Decoder_texte(Texte_compresse: in Unbounded_String, Arbre : in T_arbre, texte_decode : out Unbounded_String) is
    --          caractere : T_caractere;
    --          j : Integer := 1;
    --          texte_decode : Unbounded_String := To_Unbounded_String("");
    --      begin
    --          for i in 1..length(texte_compresse)/8 loop
    --              caractere := Convertire_Bits_en_Octet(texte_decode(1+i*8..i*8));
    --              for j in 1..? loop
    --                  if caractere = Table(j).all.code
    --  
    --  
    --          end loop;
    --  
    --      end decoder_texte;

    
 end Huffman;
